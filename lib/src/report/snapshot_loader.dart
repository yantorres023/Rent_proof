import 'package:drift/drift.dart';

import '../data/database.dart';
import '../services/storage_paths.dart';
import 'report_models.dart';

/// Reads an inspection and all its evidence into an [InspectionSnapshot].
class SnapshotLoader {
  SnapshotLoader(this._db, this._paths);

  final AppDatabase _db;
  final StoragePaths _paths;

  Future<InspectionSnapshot> load(String inspectionId) async {
    final inspection = await (_db.select(
      _db.inspections,
    )..where((t) => t.id.equals(inspectionId))).getSingle();
    final property = await (_db.select(
      _db.properties,
    )..where((t) => t.id.equals(inspection.propertyId))).getSingle();
    final rooms =
        await (_db.select(_db.rooms)
              ..where((t) => t.inspectionId.equals(inspectionId))
              ..orderBy([(t) => OrderingTerm.asc(t.position)]))
            .get();

    var counter = 0;
    final entries = <RoomEntry>[];
    for (final room in rooms) {
      final items =
          await (_db.select(_db.checklistItems)
                ..where((t) => t.roomId.equals(room.id))
                ..orderBy([(t) => OrderingTerm.asc(t.position)]))
              .get();
      final labels = {for (final i in items) i.id: i.label};
      final media =
          await (_db.select(_db.mediaEvidence)
                ..where((t) => t.roomId.equals(room.id))
                ..orderBy([(t) => OrderingTerm.asc(t.recordedAt)]))
              .get();
      // Group media by prompt order so the report follows the walkthrough.
      final order = {for (var i = 0; i < items.length; i++) items[i].id: i};
      media.sort((a, b) {
        final oa = order[a.checklistItemId] ?? items.length;
        final ob = order[b.checklistItemId] ?? items.length;
        if (oa != ob) return oa.compareTo(ob);
        return a.recordedAt.compareTo(b.recordedAt);
      });
      final mediaEntries = <MediaEntry>[];
      for (final m in media) {
        counter++;
        final annotations =
            await (_db.select(_db.annotations)
                  ..where((t) => t.mediaId.equals(m.id))
                  ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
                .get();
        mediaEntries.add(
          MediaEntry(
            evidenceId: 'E-${counter.toString().padLeft(3, '0')}',
            media: m,
            promptLabel: labels[m.checklistItemId],
            annotations: annotations,
            previewFile: m.previewPath == null
                ? null
                : _paths.evidenceFile(m.previewPath!),
            thumbnailFile: m.thumbnailPath == null
                ? null
                : _paths.evidenceFile(m.thumbnailPath!),
          ),
        );
      }
      final counts = <String, int>{};
      for (final m in media) {
        if (m.checklistItemId != null) {
          counts[m.checklistItemId!] = (counts[m.checklistItemId!] ?? 0) + 1;
        }
      }
      final issues =
          await (_db.select(_db.issues)
                ..where((t) => t.roomId.equals(room.id))
                ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
              .get();
      final comparison = await (_db.select(
        _db.roomComparisons,
      )..where((t) => t.roomId.equals(room.id))).getSingleOrNull();
      entries.add(
        RoomEntry(
          room: room,
          checklist: [
            for (final i in items)
              ChecklistLine(
                label: i.label,
                mediaCount: counts[i.id] ?? 0,
                notApplicable: i.notApplicable,
              ),
          ],
          media: mediaEntries,
          issues: issues,
          comparison: comparison,
        ),
      );
    }
    return InspectionSnapshot(
      property: property,
      inspection: inspection,
      rooms: entries,
    );
  }
}

/// Pairs rooms of [current] with rooms of [baseline]: first by the recorded
/// baseline link, then by case-insensitive name. Unmatched rooms on either
/// side are kept so nothing silently disappears from a comparison.
List<RoomPair> pairRooms(
  InspectionSnapshot current,
  InspectionSnapshot baseline,
) {
  final remaining = [...baseline.rooms];
  final pairs = <RoomPair>[];
  for (final room in current.rooms) {
    RoomEntry? match;
    final linked = room.room.baselineRoomId;
    if (linked != null) {
      match = remaining.where((b) => b.room.id == linked).firstOrNull;
    }
    match ??= remaining
        .where((b) => b.room.name.toLowerCase() == room.room.name.toLowerCase())
        .firstOrNull;
    if (match != null) remaining.remove(match);
    pairs.add(RoomPair(current: room, baseline: match));
  }
  for (final b in remaining) {
    pairs.add(RoomPair(baseline: b));
  }
  return pairs;
}
