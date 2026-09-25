import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:archive/archive_io.dart';
import 'package:drift/drift.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;

import '../app_info.dart';
import '../data/database.dart';
import '../services/clock.dart';
import '../services/media_processing.dart' show sha256OfFile;
import '../services/safe_paths.dart';
import '../services/storage_paths.dart';
import 'pdf_report_builder.dart';
import 'report_models.dart';
import 'snapshot_loader.dart';

typedef ReportFontLoader = Future<ReportFonts> Function();
typedef PdfRunner = Future<List<int>> Function(
  ReportInput input,
  ReportFonts fonts,
);

/// Builds the PDF on a background isolate.
Future<List<int>> buildPdfInIsolate(ReportInput input, ReportFonts fonts) =>
    Isolate.run(() => buildReportPdf(input, fonts));

class ReportRepository {
  ReportRepository(
    this._db,
    this._paths, {
    required this._fonts,
    this._clock = const SystemClock(),
    this._ids = const IdGenerator(),
    this._runner = buildPdfInIsolate,
  }) : _loader = SnapshotLoader(_db, _paths);

  final AppDatabase _db;
  final StoragePaths _paths;
  final ReportFontLoader _fonts;
  final Clock _clock;
  final IdGenerator _ids;
  final PdfRunner _runner;
  final SnapshotLoader _loader;

  Future<InspectionSnapshot> snapshot(String inspectionId) =>
      _loader.load(inspectionId);

  /// Loads the current inspection, its baseline (if any) and room pairs.
  Future<ReportInput> prepare(String inspectionId) async {
    final snap = await _loader.load(inspectionId);
    InspectionSnapshot? baseline;
    final baselineId = snap.inspection.baselineInspectionId;
    if (baselineId != null) {
      final exists = await (_db.select(
        _db.inspections,
      )..where((t) => t.id.equals(baselineId))).getSingleOrNull();
      if (exists != null) baseline = await _loader.load(baselineId);
    }
    final profile = await (_db.select(_db.userProfiles)).getSingleOrNull();
    return ReportInput(
      reportId: _ids.next(),
      generatedAt: _clock.now(),
      snapshot: snap,
      baseline: baseline,
      pairs: baseline == null ? const [] : pairRooms(snap, baseline),
      appVersion: appVersion,
      preparedBy: profile?.displayName ?? '',
    );
  }

  /// Generates a PDF, stores it privately and records its SHA-256.
  Future<Report> generate(String inspectionId) async {
    final input = await prepare(inspectionId);
    final bytes = await _runner(input, await _fonts());
    final rel = StoragePaths.reportRelative(inspectionId, input.reportId);
    final file = File(_paths.reportFile(rel));
    await file.parent.create(recursive: true);
    await file.writeAsBytes(bytes, flush: true);
    final hash = await sha256OfFile(file.path);
    await _db
        .into(_db.reports)
        .insert(
          ReportsCompanion.insert(
            id: input.reportId,
            inspectionId: inspectionId,
            filePath: rel,
            sha256: hash,
            byteSize: bytes.length,
            mediaCount: input.snapshot.allMedia.length,
            issueCount: input.snapshot.allIssues.length,
            includesComparison: Value(input.baseline != null),
            generatedAt: input.generatedAt,
          ),
        );
    return (_db.select(
      _db.reports,
    )..where((t) => t.id.equals(input.reportId))).getSingle();
  }

  Stream<List<Report>> watchReports(String inspectionId) =>
      (_db.select(_db.reports)
            ..where((t) => t.inspectionId.equals(inspectionId))
            ..orderBy([(t) => OrderingTerm.desc(t.generatedAt)]))
          .watch();

  String reportFilePath(Report r) => _paths.reportFile(r.filePath);

  /// Records (or clears) the user's confirmation that the report was sent.
  Future<void> markSent(String reportId, {required bool sent}) async {
    await (_db.update(_db.reports)..where((t) => t.id.equals(reportId))).write(
      ReportsCompanion(sentToLandlordAt: Value(sent ? _clock.now() : null)),
    );
  }

  Future<void> deleteReport(String reportId) async {
    final r = await (_db.select(
      _db.reports,
    )..where((t) => t.id.equals(reportId))).getSingle();
    await (_db.delete(_db.reports)..where((t) => t.id.equals(reportId))).go();
    final f = File(reportFilePath(r));
    if (f.existsSync()) await f.delete();
  }

  /// Copies a stored report into the export directory under a readable name.
  Future<File> exportReport(Report report) async {
    final snap = await _loader.load(report.inspectionId);
    final dir = await _paths.freshExportDir();
    final name =
        '${_exportBaseName(snap)}_report_${report.id.substring(0, 8)}.pdf';
    final dest = File(p.join(dir.path, name));
    return File(reportFilePath(report)).copy(dest.path);
  }

  String _exportBaseName(InspectionSnapshot snap) {
    final date = DateFormat('yyyy-MM-dd').format(snap.inspection.startedAt);
    final type = snap.inspection.type.name;
    return '${slugForFileName(snap.property.nickname, fallback: 'property')}'
        '_${type}_$date';
  }

  /// Builds a ZIP with every stored original, a manifest, SHA256SUMS.txt
  /// and (optionally) a report, so the evidence can be kept off-device or
  /// shared. Originals are copied byte-for-byte.
  Future<File> exportEvidencePackage(
    String inspectionId, {
    Report? report,
  }) async {
    final snap = await _loader.load(inspectionId);
    final dir = await _paths.freshExportDir();
    final base = _exportBaseName(snap);
    final zipPath = p.join(dir.path, '${base}_evidence.zip');
    final zipFile = File(zipPath);
    if (zipFile.existsSync()) await zipFile.delete();

    final encoder = ZipFileEncoder();
    encoder.create(zipPath);
    final sums = StringBuffer();
    final mediaManifest = <Map<String, Object?>>[];
    final missing = <String>[];
    try {
      for (final room in snap.rooms) {
        for (final entry in room.media) {
          final m = entry.media;
          final ext = p.extension(m.originalPath);
          final name =
              'originals/${entry.evidenceId}_'
              '${slugForFileName(room.room.name, fallback: 'room')}$ext';
          final source = File(_paths.evidenceFile(m.originalPath));
          if (source.existsSync()) {
            await encoder.addFile(source, name, 0);
            sums.writeln('${m.sha256}  $name');
          } else {
            missing.add(entry.evidenceId);
          }
          mediaManifest.add({
            'evidenceId': entry.evidenceId,
            'file': source.existsSync() ? name : null,
            'room': room.room.name,
            'prompt': entry.promptLabel,
            'kind': m.kind.name,
            'source': m.source.name,
            'sha256': m.sha256,
            'byteSize': m.byteSize,
            'recordedAtDeviceClock': m.recordedAt.toIso8601String(),
            'recordedAtUtcOffsetMinutes': m.recordedAt.timeZoneOffset.inMinutes,
            'exifDateTimeOriginalUnverified': m.exifDateTimeOriginal,
            'exifMakeUnverified': m.exifMake,
            'exifModelUnverified': m.exifModel,
            'originalContainsGpsMetadata': m.originalHasGps,
            'caption': m.caption,
            'markers': [
              for (final a in entry.annotations)
                {'x': a.x, 'y': a.y, 'label': a.label, 'issueId': a.issueId},
            ],
          });
        }
      }
      if (report != null) {
        final reportFile = File(reportFilePath(report));
        if (reportFile.existsSync()) {
          const name = 'report.pdf';
          await encoder.addFile(reportFile, name);
          sums.writeln('${report.sha256}  $name');
        }
      }
      final manifest = {
        'format': 'rentproof-evidence-package',
        'formatVersion': 1,
        'generatedAt': _clock.now().toIso8601String(),
        'generator': 'RentProof $appVersion',
        'property': {
          'nickname': snap.property.nickname,
          'address': [
            snap.property.addressLine1,
            snap.property.addressLine2,
            snap.property.city,
            snap.property.region,
            snap.property.postalCode,
            snap.property.country,
          ].where((s) => s.isNotEmpty).join(', '),
        },
        'inspection': {
          'id': snap.inspection.id,
          'type': snap.inspection.type.name,
          'status': snap.inspection.status.name,
          'startedAt': snap.inspection.startedAt.toIso8601String(),
          'completedAt': snap.inspection.completedAt?.toIso8601String(),
          'notes': snap.inspection.notes,
        },
        'rooms': [
          for (final r in snap.rooms)
            {
              'name': r.room.name,
              'status': r.room.status.name,
              'notes': r.room.notes,
              'issues': [
                for (final i in r.issues)
                  {
                    'id': i.id,
                    'title': i.title,
                    'description': i.description,
                    'category': i.category.name,
                    'severity': i.severity.name,
                    'evidenceId': i.mediaId == null
                        ? null
                        : snap.mediaById(i.mediaId!)?.evidenceId,
                  },
              ],
            },
        ],
        'media': mediaManifest,
        'missingOriginals': missing,
        'limitations': reportLimitations,
      };
      final manifestJson = const JsonEncoder.withIndent('  ').convert(manifest);
      encoder.addArchiveFile(ArchiveFile.string('manifest.json', manifestJson));
      encoder.addArchiveFile(
        ArchiveFile.string('SHA256SUMS.txt', sums.toString()),
      );
      encoder.addArchiveFile(ArchiveFile.string('README.txt', _readme));
    } finally {
      await encoder.close();
    }
    return zipFile;
  }
}

const _readme = '''
RentProof evidence package
==========================

originals/       Photos and videos exactly as stored by the app (unchanged).
report.pdf       The condition report, if one was included.
manifest.json    Rooms, issues, notes and metadata for every file.
SHA256SUMS.txt   SHA-256 of every file, recorded when the app stored it.

Checking the files
------------------
macOS / Linux:  shasum -a 256 -c SHA256SUMS.txt
Windows:        certutil -hashfile <file> SHA256  (compare with the list)

A matching hash shows the file is identical to the one the app recorded.
It does not prove when or where a photo was taken, who took it, or that
the scene was not altered. Timestamps come from the device clock. EXIF
values are copied from the files and are not verified.

Original photos may contain location (GPS) metadata written by the camera.
Review before sharing if that matters to you.
''';
