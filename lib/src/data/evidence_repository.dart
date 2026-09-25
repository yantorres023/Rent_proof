import 'dart:io';
import 'dart:isolate';

import 'package:drift/drift.dart';

import '../services/clock.dart';
import '../services/media_processing.dart';
import '../services/platform_preview.dart';
import '../services/safe_paths.dart';
import '../services/storage_paths.dart';
import 'database.dart';
import 'inspection_repository.dart' show InspectionLockedException;
import 'property_repository.dart' show ValidationException;

/// Result of re-hashing every stored original of an inspection.
class IntegritySummary {
  const IntegritySummary({
    required this.checked,
    required this.matched,
    required this.mismatched,
    required this.missing,
  });

  final int checked;
  final int matched;
  final int mismatched;
  final int missing;

  bool get allMatch => checked > 0 && matched == checked;
}

class IssueInput {
  const IssueInput({
    required this.title,
    this.description = '',
    this.category = IssueCategory.damage,
    this.severity = IssueSeverity.minor,
    this.mediaId,
  });

  final String title;
  final String description;
  final IssueCategory category;
  final IssueSeverity severity;
  final String? mediaId;
}

typedef MediaProcessor = Future<MediaProcessResult> Function(
  MediaProcessRequest request,
);

/// Runs [processMedia] on a background isolate so hashing and resizing never
/// block the UI thread.
Future<MediaProcessResult> processMediaInIsolate(MediaProcessRequest r) =>
    Isolate.run(() => processMedia(r));

class EvidenceRepository {
  EvidenceRepository(
    this._db,
    this._paths, {
    this._clock = const SystemClock(),
    this._ids = const IdGenerator(),
    this._processor = processMediaInIsolate,
    this._platformDecoder,
  });

  final AppDatabase _db;
  final StoragePaths _paths;
  final Clock _clock;
  final IdGenerator _ids;
  final MediaProcessor _processor;

  /// Fallback for photo formats the Dart decoder cannot read (e.g. HEIC).
  final PlatformDecoder? _platformDecoder;

  Future<Room> _editableRoom(String roomId) async {
    final room = await (_db.select(
      _db.rooms,
    )..where((t) => t.id.equals(roomId))).getSingle();
    final inspection = await (_db.select(
      _db.inspections,
    )..where((t) => t.id.equals(room.inspectionId))).getSingle();
    if (inspection.status == InspectionStatus.completed) {
      throw const InspectionLockedException();
    }
    return room;
  }

  // ---------------------------------------------------------------------------
  // Media

  /// Copies [sourcePath] into private storage, hashes it and records it.
  ///
  /// The app records its own timestamp at the moment the file is received;
  /// EXIF values are stored separately and are never treated as verified.
  Future<MediaItem> addMedia({
    required String roomId,
    required String sourcePath,
    required MediaKind kind,
    required MediaSource source,
    String? checklistItemId,
    String? sourceFileName,
  }) async {
    final room = await _editableRoom(roomId);
    final recordedAt = _clock.now();
    final id = _ids.next();
    final displayName = sanitizeDisplayFileName(
      sourceFileName ?? sourcePath.split(Platform.pathSeparator).last,
    );
    var ext = safeExtension(displayName);
    if (ext == 'bin') ext = safeExtension(sourcePath);
    final isPhoto = kind == MediaKind.photo;
    final originalRel = StoragePaths.originalRelative(
      room.inspectionId,
      id,
      ext,
    );
    final previewRel = StoragePaths.previewRelative(room.inspectionId, id);
    final thumbRel = StoragePaths.thumbnailRelative(room.inspectionId, id);
    final previewAbs = _paths.evidenceFile(previewRel);
    await Directory(File(previewAbs).parent.path).create(recursive: true);

    var result = await _processor(
      MediaProcessRequest(
        sourcePath: sourcePath,
        originalDestPath: _paths.evidenceFile(originalRel),
        previewDestPath: isPhoto ? previewAbs : null,
        thumbnailDestPath: isPhoto ? _paths.evidenceFile(thumbRel) : null,
        isPhoto: isPhoto,
      ),
    );
    if (isPhoto && !result.previewWritten && _platformDecoder != null) {
      result = await _derivePreviewWithPlatform(
        result,
        originalRel,
        previewRel,
        thumbRel,
      );
    }

    final media = MediaEvidenceCompanion.insert(
      id: id,
      roomId: roomId,
      checklistItemId: Value(checklistItemId),
      kind: kind,
      source: source,
      originalPath: originalRel,
      previewPath: Value(result.previewWritten ? previewRel : null),
      thumbnailPath: Value(result.thumbnailWritten ? thumbRel : null),
      sourceFileName: Value(displayName),
      mimeType: Value(mimeTypeForExtension(ext)),
      byteSize: result.byteSize,
      sha256: result.sha256,
      recordedAt: recordedAt,
      exifDateTimeOriginal: Value(result.exifDateTimeOriginal),
      exifMake: Value(result.exifMake),
      exifModel: Value(result.exifModel),
      originalHasGps: Value(result.hasGps),
      width: Value(result.width),
      height: Value(result.height),
    );
    try {
      await _db.transaction(() async {
        await _db.into(_db.mediaEvidence).insert(media);
        await _db
            .into(_db.evidenceHashes)
            .insert(
              EvidenceHashesCompanion.insert(
                id: _ids.next(),
                mediaId: id,
                hexDigest: Value(result.sha256),
                purpose: HashPurpose.import,
                result: HashCheckResult.recorded,
                computedAt: _clock.now(),
              ),
            );
        if (room.status == RoomStatus.notStarted) {
          await (_db.update(
            _db.rooms,
          )..where((t) => t.id.equals(roomId))).write(
            const RoomsCompanion(status: Value(RoomStatus.inProgress)),
          );
        }
      });
    } on Object {
      // Keep storage consistent with the database.
      for (final rel in [originalRel, previewRel, thumbRel]) {
        final f = File(_paths.evidenceFile(rel));
        if (f.existsSync()) await f.delete();
      }
      rethrow;
    }
    return getMedia(id);
  }

  Future<MediaProcessResult> _derivePreviewWithPlatform(
    MediaProcessResult result,
    String originalRel,
    String previewRel,
    String thumbRel,
  ) async {
    final decoded = await _platformDecoder!(_paths.evidenceFile(originalRel));
    if (decoded == null) return result;
    final request = DerivedFromRgbaRequest(
      image: decoded,
      previewDestPath: _paths.evidenceFile(previewRel),
      thumbnailDestPath: _paths.evidenceFile(thumbRel),
    );
    final ok = await Isolate.run(() => writeDerivedFromRgba(request));
    if (!ok) return result;
    return MediaProcessResult(
      sha256: result.sha256,
      byteSize: result.byteSize,
      previewWritten: true,
      thumbnailWritten: true,
      width: decoded.width,
      height: decoded.height,
      exifDateTimeOriginal: result.exifDateTimeOriginal,
      exifMake: result.exifMake,
      exifModel: result.exifModel,
      hasGps: result.hasGps,
    );
  }

  Future<MediaItem> getMedia(String id) => (_db.select(
    _db.mediaEvidence,
  )..where((t) => t.id.equals(id))).getSingle();

  Stream<MediaItem?> watchMedia(String id) => (_db.select(
    _db.mediaEvidence,
  )..where((t) => t.id.equals(id))).watchSingleOrNull();

  Stream<List<MediaItem>> watchRoomMedia(String roomId) =>
      (_db.select(_db.mediaEvidence)
            ..where((t) => t.roomId.equals(roomId))
            ..orderBy([(t) => OrderingTerm.asc(t.recordedAt)]))
          .watch();

  Future<List<MediaItem>> roomMedia(String roomId) =>
      (_db.select(_db.mediaEvidence)
            ..where((t) => t.roomId.equals(roomId))
            ..orderBy([(t) => OrderingTerm.asc(t.recordedAt)]))
          .get();

  Future<void> updateCaption(String mediaId, String caption) async {
    final media = await getMedia(mediaId);
    await _editableRoom(media.roomId);
    await (_db.update(_db.mediaEvidence)..where((t) => t.id.equals(mediaId)))
        .write(MediaEvidenceCompanion(caption: Value(_trim(caption, 500))));
  }

  Future<void> assignChecklistItem(String mediaId, String? itemId) async {
    final media = await getMedia(mediaId);
    await _editableRoom(media.roomId);
    await (_db.update(_db.mediaEvidence)..where((t) => t.id.equals(mediaId)))
        .write(MediaEvidenceCompanion(checklistItemId: Value(itemId)));
  }

  /// Permanently deletes a photo/video, its derived copies and hash records.
  /// Issues that referenced it are kept but unlinked.
  Future<void> deleteMedia(String mediaId) async {
    final media = await getMedia(mediaId);
    await _editableRoom(media.roomId);
    await (_db.delete(
      _db.mediaEvidence,
    )..where((t) => t.id.equals(mediaId))).go();
    await _paths.deleteMediaFiles(media);
  }

  String originalFilePath(MediaItem m) => _paths.evidenceFile(m.originalPath);

  String? previewFilePath(MediaItem m) =>
      m.previewPath == null ? null : _paths.evidenceFile(m.previewPath!);

  String? thumbnailFilePath(MediaItem m) =>
      m.thumbnailPath == null ? null : _paths.evidenceFile(m.thumbnailPath!);

  // ---------------------------------------------------------------------------
  // Integrity

  /// Recomputes the SHA-256 of the stored original and records the outcome.
  Future<HashCheckResult> verifyMedia(String mediaId) async {
    final media = await getMedia(mediaId);
    final path = originalFilePath(media);
    String? digest;
    HashCheckResult result;
    if (!File(path).existsSync()) {
      result = HashCheckResult.missing;
    } else {
      try {
        digest = await Isolate.run(() => sha256OfFile(path));
        result = digest == media.sha256
            ? HashCheckResult.match
            : HashCheckResult.mismatch;
      } on FileSystemException {
        result = HashCheckResult.missing;
      }
    }
    await _db
        .into(_db.evidenceHashes)
        .insert(
          EvidenceHashesCompanion.insert(
            id: _ids.next(),
            mediaId: mediaId,
            hexDigest: Value(digest),
            purpose: HashPurpose.verification,
            result: result,
            computedAt: _clock.now(),
          ),
        );
    return result;
  }

  Future<IntegritySummary> verifyInspection(String inspectionId) async {
    final media = await mediaForInspection(inspectionId);
    var matched = 0, mismatched = 0, missing = 0;
    for (final m in media) {
      switch (await verifyMedia(m.id)) {
        case HashCheckResult.match:
          matched++;
        case HashCheckResult.mismatch:
          mismatched++;
        case HashCheckResult.missing:
          missing++;
        case HashCheckResult.recorded:
          break;
      }
    }
    return IntegritySummary(
      checked: media.length,
      matched: matched,
      mismatched: mismatched,
      missing: missing,
    );
  }

  Future<List<EvidenceHash>> hashHistory(String mediaId) =>
      (_db.select(_db.evidenceHashes)
            ..where((t) => t.mediaId.equals(mediaId))
            ..orderBy([(t) => OrderingTerm.asc(t.computedAt)]))
          .get();

  Stream<List<EvidenceHash>> watchHashHistory(String mediaId) =>
      (_db.select(_db.evidenceHashes)
            ..where((t) => t.mediaId.equals(mediaId))
            ..orderBy([(t) => OrderingTerm.asc(t.computedAt)]))
          .watch();

  Future<List<MediaItem>> mediaForInspection(String inspectionId) {
    final query =
        _db.select(_db.mediaEvidence).join([
            innerJoin(
              _db.rooms,
              _db.rooms.id.equalsExp(_db.mediaEvidence.roomId),
            ),
          ])
          ..where(_db.rooms.inspectionId.equals(inspectionId))
          ..orderBy([
            OrderingTerm.asc(_db.rooms.position),
            OrderingTerm.asc(_db.mediaEvidence.recordedAt),
          ]);
    return query.map((r) => r.readTable(_db.mediaEvidence)).get();
  }

  // ---------------------------------------------------------------------------
  // Issues

  Future<Issue> addIssue(String roomId, IssueInput input) async {
    await _editableRoom(roomId);
    final title = _trim(input.title, 120);
    if (title.isEmpty) throw const ValidationException('title', 'required');
    if (input.mediaId != null) {
      final media = await getMedia(input.mediaId!);
      if (media.roomId != roomId) {
        throw const ValidationException('mediaId', 'different room');
      }
    }
    final now = _clock.now();
    final id = _ids.next();
    await _db
        .into(_db.issues)
        .insert(
          IssuesCompanion.insert(
            id: id,
            roomId: roomId,
            mediaId: Value(input.mediaId),
            title: title,
            description: Value(_trim(input.description, 4000)),
            category: input.category,
            severity: input.severity,
            createdAt: now,
            updatedAt: now,
          ),
        );
    return getIssue(id);
  }

  Future<Issue> updateIssue(String issueId, IssueInput input) async {
    final issue = await getIssue(issueId);
    await _editableRoom(issue.roomId);
    final title = _trim(input.title, 120);
    if (title.isEmpty) throw const ValidationException('title', 'required');
    await (_db.update(_db.issues)..where((t) => t.id.equals(issueId))).write(
      IssuesCompanion(
        title: Value(title),
        description: Value(_trim(input.description, 4000)),
        category: Value(input.category),
        severity: Value(input.severity),
        mediaId: Value(input.mediaId),
        updatedAt: Value(_clock.now()),
      ),
    );
    return getIssue(issueId);
  }

  Future<void> deleteIssue(String issueId) async {
    final issue = await getIssue(issueId);
    await _editableRoom(issue.roomId);
    await (_db.delete(_db.issues)..where((t) => t.id.equals(issueId))).go();
  }

  Future<Issue> getIssue(String id) =>
      (_db.select(_db.issues)..where((t) => t.id.equals(id))).getSingle();

  Stream<List<Issue>> watchRoomIssues(String roomId) =>
      (_db.select(_db.issues)
            ..where((t) => t.roomId.equals(roomId))
            ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
          .watch();

  Future<List<Issue>> roomIssues(String roomId) =>
      (_db.select(_db.issues)
            ..where((t) => t.roomId.equals(roomId))
            ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
          .get();

  // ---------------------------------------------------------------------------
  // Annotations (markers stored as metadata; the photo is never altered)

  Future<Annotation> addAnnotation({
    required String mediaId,
    required double x,
    required double y,
    String? issueId,
    String label = '',
  }) async {
    final media = await getMedia(mediaId);
    await _editableRoom(media.roomId);
    if (x.isNaN || y.isNaN) {
      throw const ValidationException('position', 'invalid');
    }
    final id = _ids.next();
    await _db
        .into(_db.annotations)
        .insert(
          AnnotationsCompanion.insert(
            id: id,
            mediaId: mediaId,
            issueId: Value(issueId),
            x: x.clamp(0.0, 1.0),
            y: y.clamp(0.0, 1.0),
            label: Value(_trim(label, 60)),
            createdAt: _clock.now(),
          ),
        );
    return (_db.select(
      _db.annotations,
    )..where((t) => t.id.equals(id))).getSingle();
  }

  Future<void> deleteAnnotation(String id) async {
    final a = await (_db.select(
      _db.annotations,
    )..where((t) => t.id.equals(id))).getSingle();
    final media = await getMedia(a.mediaId);
    await _editableRoom(media.roomId);
    await (_db.delete(_db.annotations)..where((t) => t.id.equals(id))).go();
  }

  Stream<List<Annotation>> watchAnnotations(String mediaId) =>
      (_db.select(_db.annotations)
            ..where((t) => t.mediaId.equals(mediaId))
            ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
          .watch();

  Future<List<Annotation>> annotationsFor(String mediaId) =>
      (_db.select(_db.annotations)
            ..where((t) => t.mediaId.equals(mediaId))
            ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
          .get();
}

String _trim(String s, int max) {
  final t = s.trim();
  return t.length > max ? t.substring(0, max) : t;
}
