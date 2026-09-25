import 'package:drift/drift.dart';

import '../services/clock.dart';
import '../services/room_templates.dart';
import '../services/storage_paths.dart';
import 'database.dart';
import 'property_repository.dart' show ValidationException;

class InspectionLockedException implements Exception {
  const InspectionLockedException();

  @override
  String toString() => 'InspectionLockedException';
}

class InspectionNotReadyException implements Exception {
  const InspectionNotReadyException(this.reason);

  /// `no_media` when nothing has been captured yet.
  final String reason;

  @override
  String toString() => 'InspectionNotReadyException($reason)';
}

class InspectionSummary {
  const InspectionSummary({
    required this.inspection,
    required this.roomCount,
    required this.completedRoomCount,
    required this.mediaCount,
    required this.issueCount,
  });

  final Inspection inspection;
  final int roomCount;
  final int completedRoomCount;
  final int mediaCount;
  final int issueCount;
}

class ChecklistProgress {
  const ChecklistProgress({required this.item, required this.mediaCount});

  final ChecklistItem item;
  final int mediaCount;

  bool get isDone => item.notApplicable || mediaCount > 0;
}

class RoomProgress {
  const RoomProgress({
    required this.room,
    required this.checklist,
    required this.mediaCount,
    required this.issueCount,
  });

  final Room room;
  final List<ChecklistProgress> checklist;
  final int mediaCount;
  final int issueCount;

  int get doneCount => checklist.where((c) => c.isDone).length;
  int get totalCount => checklist.length;
}

class InspectionRepository {
  InspectionRepository(
    this._db,
    this._paths, {
    this._clock = const SystemClock(),
    this._ids = const IdGenerator(),
  });

  final AppDatabase _db;
  final StoragePaths _paths;
  final Clock _clock;
  final IdGenerator _ids;

  // ---------------------------------------------------------------------------
  // Inspections

  /// Creates an inspection. When [baselineInspectionId] is given the room
  /// list and prompts are copied from the baseline so rooms can be compared.
  Future<Inspection> create({
    required String propertyId,
    required InspectionType type,
    List<String> roomTemplateKeys = defaultRoomKeys,
    String? baselineInspectionId,
  }) async {
    final id = _ids.next();
    final now = _clock.now();
    await _db.transaction(() async {
      if (baselineInspectionId != null) {
        final baseline = await getInspection(baselineInspectionId);
        if (baseline.propertyId != propertyId) {
          throw const ValidationException('baseline', 'different property');
        }
      }
      await _db
          .into(_db.inspections)
          .insert(
            InspectionsCompanion.insert(
              id: id,
              propertyId: propertyId,
              type: type,
              status: InspectionStatus.inProgress,
              baselineInspectionId: Value(baselineInspectionId),
              startedAt: now,
            ),
          );
      if (baselineInspectionId != null) {
        await _copyRoomsFrom(baselineInspectionId, id);
      } else {
        var position = 0;
        for (final key in roomTemplateKeys) {
          final template = templateForKey(key);
          if (template == null) continue;
          await _insertRoom(
            inspectionId: id,
            name: await _uniqueRoomName(id, template.name),
            templateKey: template.key,
            position: position++,
            prompts: template.prompts,
          );
        }
      }
      await (_db.update(_db.properties)..where((t) => t.id.equals(propertyId)))
          .write(PropertiesCompanion(updatedAt: Value(now)));
    });
    return getInspection(id);
  }

  Future<void> _copyRoomsFrom(String baselineId, String newId) async {
    final rooms =
        await (_db.select(_db.rooms)
              ..where((r) => r.inspectionId.equals(baselineId))
              ..orderBy([(r) => OrderingTerm.asc(r.position)]))
            .get();
    for (final room in rooms) {
      final items =
          await (_db.select(_db.checklistItems)
                ..where((c) => c.roomId.equals(room.id))
                ..orderBy([(c) => OrderingTerm.asc(c.position)]))
              .get();
      await _insertRoom(
        inspectionId: newId,
        name: room.name,
        templateKey: room.templateKey,
        position: room.position,
        prompts: [for (final i in items) i.label],
        baselineRoomId: room.id,
      );
    }
  }

  Future<Inspection> getInspection(String id) =>
      (_db.select(_db.inspections)..where((t) => t.id.equals(id))).getSingle();

  Stream<Inspection?> watchInspection(String id) => (_db.select(
    _db.inspections,
  )..where((t) => t.id.equals(id))).watchSingleOrNull();

  Stream<List<InspectionSummary>> watchSummaries(String propertyId) {
    return _db
        .customSelect(
          'SELECT i.*, '
          '(SELECT COUNT(*) FROM rooms r WHERE r.inspection_id = i.id) '
          'AS room_count, '
          '(SELECT COUNT(*) FROM rooms r WHERE r.inspection_id = i.id '
          "AND r.status = 'completed') AS completed_rooms, "
          '(SELECT COUNT(*) FROM media_evidence m JOIN rooms r '
          'ON m.room_id = r.id WHERE r.inspection_id = i.id) AS media_count, '
          '(SELECT COUNT(*) FROM issues s JOIN rooms r '
          'ON s.room_id = r.id WHERE r.inspection_id = i.id) AS issue_count '
          'FROM inspections i WHERE i.property_id = ? '
          'ORDER BY i.started_at DESC',
          variables: [Variable.withString(propertyId)],
          readsFrom: {
            _db.inspections,
            _db.rooms,
            _db.mediaEvidence,
            _db.issues,
          },
        )
        .watch()
        .asyncMap(
          (rows) async => [
            for (final r in rows)
              InspectionSummary(
                inspection: await _db.inspections.mapFromRow(r),
                roomCount: r.read<int>('room_count'),
                completedRoomCount: r.read<int>('completed_rooms'),
                mediaCount: r.read<int>('media_count'),
                issueCount: r.read<int>('issue_count'),
              ),
          ],
        );
  }

  /// Completed inspections of the same property that can serve as baseline.
  Future<List<Inspection>> baselineCandidates(String propertyId) =>
      (_db.select(_db.inspections)
            ..where(
              (t) =>
                  t.propertyId.equals(propertyId) &
                  t.status.equalsValue(InspectionStatus.completed),
            )
            ..orderBy([(t) => OrderingTerm.desc(t.startedAt)]))
          .get();

  Future<void> _ensureEditable(String inspectionId) async {
    final inspection = await getInspection(inspectionId);
    if (inspection.status == InspectionStatus.completed) {
      throw const InspectionLockedException();
    }
  }

  Future<void> updateNotes(String inspectionId, String notes) async {
    await (_db.update(_db.inspections)..where((t) => t.id.equals(inspectionId)))
        .write(InspectionsCompanion(notes: Value(_trim(notes, 4000))));
  }

  /// Marks the inspection complete. Requires at least one photo or video.
  /// Rooms are not force-completed; the report shows their real status.
  Future<void> complete(String inspectionId) async {
    await _ensureEditable(inspectionId);
    final mediaCount = await _mediaCountForInspection(inspectionId);
    if (mediaCount == 0) {
      throw const InspectionNotReadyException('no_media');
    }
    await (_db.update(
      _db.inspections,
    )..where((t) => t.id.equals(inspectionId))).write(
      InspectionsCompanion(
        status: const Value(InspectionStatus.completed),
        completedAt: Value(_clock.now()),
      ),
    );
  }

  /// Reopens a completed inspection so evidence can be added. Reports that
  /// were already generated keep their own recorded hash and timestamp.
  Future<void> reopen(String inspectionId) async {
    await (_db.update(
      _db.inspections,
    )..where((t) => t.id.equals(inspectionId))).write(
      const InspectionsCompanion(
        status: Value(InspectionStatus.inProgress),
        completedAt: Value(null),
      ),
    );
  }

  Future<void> deleteInspection(String inspectionId) async {
    await (_db.delete(
      _db.inspections,
    )..where((t) => t.id.equals(inspectionId))).go();
    await _paths.deleteInspectionFiles(inspectionId);
  }

  Future<int> _mediaCountForInspection(String inspectionId) async {
    final row = await _db
        .customSelect(
          'SELECT COUNT(*) AS c FROM media_evidence m JOIN rooms r '
          'ON m.room_id = r.id WHERE r.inspection_id = ?',
          variables: [Variable.withString(inspectionId)],
        )
        .getSingle();
    return row.read<int>('c');
  }

  // ---------------------------------------------------------------------------
  // Rooms

  /// Re-emits whenever rooms, prompts, media or issues change.
  Stream<void> _roomTablesChanged() => _db
      .customSelect(
        'SELECT 1',
        readsFrom: {
          _db.rooms,
          _db.checklistItems,
          _db.mediaEvidence,
          _db.issues,
        },
      )
      .watch();

  Stream<List<RoomProgress>> watchRoomProgress(String inspectionId) =>
      _roomTablesChanged().asyncMap((_) => _loadRoomProgress(inspectionId));

  Future<List<RoomProgress>> _loadRoomProgress(String inspectionId) async {
    final rooms =
        await (_db.select(_db.rooms)
              ..where((r) => r.inspectionId.equals(inspectionId))
              ..orderBy([(r) => OrderingTerm.asc(r.position)]))
            .get();
    return [for (final room in rooms) await loadRoomProgress(room.id)];
  }

  Future<RoomProgress> loadRoomProgress(String roomId) async {
    final room = await getRoom(roomId);
    final items =
        await (_db.select(_db.checklistItems)
              ..where((c) => c.roomId.equals(roomId))
              ..orderBy([(c) => OrderingTerm.asc(c.position)]))
            .get();
    final counts = <String, int>{};
    final rows = await _db
        .customSelect(
          'SELECT checklist_item_id AS c, COUNT(*) AS n FROM media_evidence '
          'WHERE room_id = ? GROUP BY checklist_item_id',
          variables: [Variable.withString(roomId)],
        )
        .get();
    var total = 0;
    for (final r in rows) {
      final n = r.read<int>('n');
      total += n;
      final key = r.readNullable<String>('c');
      if (key != null) counts[key] = n;
    }
    final issueRow = await _db
        .customSelect(
          'SELECT COUNT(*) AS c FROM issues WHERE room_id = ?',
          variables: [Variable.withString(roomId)],
        )
        .getSingle();
    return RoomProgress(
      room: room,
      checklist: [
        for (final i in items)
          ChecklistProgress(item: i, mediaCount: counts[i.id] ?? 0),
      ],
      mediaCount: total,
      issueCount: issueRow.read<int>('c'),
    );
  }

  /// Emits null once the room has been deleted.
  Stream<RoomProgress?> watchRoom(String roomId) =>
      _roomTablesChanged().asyncMap(
        (_) async =>
            await findRoom(roomId) == null ? null : loadRoomProgress(roomId),
      );

  Future<Room> getRoom(String id) =>
      (_db.select(_db.rooms)..where((t) => t.id.equals(id))).getSingle();

  Future<Room?> findRoom(String id) =>
      (_db.select(_db.rooms)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<Room> addRoom({
    required String inspectionId,
    String? templateKey,
    String? customName,
  }) async {
    await _ensureEditable(inspectionId);
    final template = templateKey == null ? null : templateForKey(templateKey);
    final requested = _trim(customName ?? template?.name ?? '', 80);
    if (requested.isEmpty) {
      throw const ValidationException('name', 'required');
    }
    final positionRow = await _db
        .customSelect(
          'SELECT COALESCE(MAX(position), -1) + 1 AS p FROM rooms '
          'WHERE inspection_id = ?',
          variables: [Variable.withString(inspectionId)],
        )
        .getSingle();
    final id = await _insertRoom(
      inspectionId: inspectionId,
      name: await _uniqueRoomName(inspectionId, requested),
      templateKey: template?.key ?? 'custom',
      position: positionRow.read<int>('p'),
      prompts: template?.prompts ?? customRoomPrompts,
    );
    return getRoom(id);
  }

  Future<String> _insertRoom({
    required String inspectionId,
    required String name,
    required String templateKey,
    required int position,
    required List<String> prompts,
    String? baselineRoomId,
  }) async {
    final id = _ids.next();
    await _db
        .into(_db.rooms)
        .insert(
          RoomsCompanion.insert(
            id: id,
            inspectionId: inspectionId,
            name: name,
            templateKey: Value(templateKey),
            position: position,
            status: RoomStatus.notStarted,
            baselineRoomId: Value(baselineRoomId),
          ),
        );
    var i = 0;
    for (final label in prompts) {
      await _db
          .into(_db.checklistItems)
          .insert(
            ChecklistItemsCompanion.insert(
              id: _ids.next(),
              roomId: id,
              label: label,
              position: i++,
            ),
          );
    }
    return id;
  }

  /// Returns [name], or "[name] 2", "[name] 3"… if already used.
  Future<String> _uniqueRoomName(String inspectionId, String name) async {
    final existing =
        (await (_db.selectOnly(_db.rooms)
                  ..addColumns([_db.rooms.name])
                  ..where(_db.rooms.inspectionId.equals(inspectionId)))
                .map((r) => r.read(_db.rooms.name)!.toLowerCase())
                .get())
            .toSet();
    if (!existing.contains(name.toLowerCase())) return name;
    for (var n = 2; ; n++) {
      final suffix = ' $n';
      final base = name.length + suffix.length > 80
          ? name.substring(0, 80 - suffix.length)
          : name;
      final candidate = '$base$suffix';
      if (!existing.contains(candidate.toLowerCase())) return candidate;
    }
  }

  Future<void> renameRoom(String roomId, String newName) async {
    final room = await getRoom(roomId);
    await _ensureEditable(room.inspectionId);
    final name = _trim(newName, 80);
    if (name.isEmpty) throw const ValidationException('name', 'required');
    if (name.toLowerCase() == room.name.toLowerCase()) {
      if (name != room.name) {
        await (_db.update(_db.rooms)..where((t) => t.id.equals(roomId))).write(
          RoomsCompanion(name: Value(name)),
        );
      }
      return;
    }
    await (_db.update(_db.rooms)..where((t) => t.id.equals(roomId))).write(
      RoomsCompanion(
        name: Value(await _uniqueRoomName(room.inspectionId, name)),
      ),
    );
  }

  Future<void> updateRoomNotes(String roomId, String notes) async {
    final room = await getRoom(roomId);
    await _ensureEditable(room.inspectionId);
    await (_db.update(_db.rooms)..where((t) => t.id.equals(roomId))).write(
      RoomsCompanion(notes: Value(_trim(notes, 4000))),
    );
  }

  /// Deletes a room with its evidence files.
  Future<void> deleteRoom(String roomId) async {
    final room = await getRoom(roomId);
    await _ensureEditable(room.inspectionId);
    final media = await (_db.select(
      _db.mediaEvidence,
    )..where((m) => m.roomId.equals(roomId))).get();
    await (_db.delete(_db.rooms)..where((t) => t.id.equals(roomId))).go();
    for (final m in media) {
      await _paths.deleteMediaFiles(m);
    }
  }

  Future<void> setRoomStatus(String roomId, RoomStatus status) async {
    final room = await getRoom(roomId);
    await _ensureEditable(room.inspectionId);
    await (_db.update(_db.rooms)..where((t) => t.id.equals(roomId))).write(
      RoomsCompanion(
        status: Value(status),
        completedAt: Value(
          status == RoomStatus.completed ? _clock.now() : null,
        ),
      ),
    );
  }

  Future<ChecklistItem> addChecklistItem(String roomId, String label) async {
    final room = await getRoom(roomId);
    await _ensureEditable(room.inspectionId);
    final clean = _trim(label, 80);
    if (clean.isEmpty) throw const ValidationException('label', 'required');
    final positionRow = await _db
        .customSelect(
          'SELECT COALESCE(MAX(position), -1) + 1 AS p FROM checklist_items '
          'WHERE room_id = ?',
          variables: [Variable.withString(roomId)],
        )
        .getSingle();
    final id = _ids.next();
    await _db
        .into(_db.checklistItems)
        .insert(
          ChecklistItemsCompanion.insert(
            id: id,
            roomId: roomId,
            label: clean,
            position: positionRow.read<int>('p'),
          ),
        );
    return (_db.select(
      _db.checklistItems,
    )..where((t) => t.id.equals(id))).getSingle();
  }

  Future<void> setChecklistNotApplicable(String itemId, bool value) async {
    final item = await (_db.select(
      _db.checklistItems,
    )..where((t) => t.id.equals(itemId))).getSingle();
    final room = await getRoom(item.roomId);
    await _ensureEditable(room.inspectionId);
    await (_db.update(_db.checklistItems)..where((t) => t.id.equals(itemId)))
        .write(ChecklistItemsCompanion(notApplicable: Value(value)));
  }

  // ---------------------------------------------------------------------------
  // Comparison verdicts

  Future<void> setComparisonVerdict(
    String roomId,
    ComparisonVerdict verdict, {
    String note = '',
  }) async {
    await _db
        .into(_db.roomComparisons)
        .insert(
          RoomComparisonsCompanion.insert(
            id: _ids.next(),
            roomId: roomId,
            verdict: verdict,
            note: Value(_trim(note, 2000)),
            updatedAt: _clock.now(),
          ),
          onConflict: DoUpdate(
            (old) => RoomComparisonsCompanion(
              verdict: Value(verdict),
              note: Value(_trim(note, 2000)),
              updatedAt: Value(_clock.now()),
            ),
            target: [_db.roomComparisons.roomId],
          ),
        );
  }

  Future<RoomComparison?> comparisonFor(String roomId) => (_db.select(
    _db.roomComparisons,
  )..where((t) => t.roomId.equals(roomId))).getSingleOrNull();

  Stream<RoomComparison?> watchComparison(String roomId) => (_db.select(
    _db.roomComparisons,
  )..where((t) => t.roomId.equals(roomId))).watchSingleOrNull();
}

String _trim(String s, int max) {
  final t = s.trim();
  return t.length > max ? t.substring(0, max) : t;
}
