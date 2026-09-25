import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rentproof/src/data/database.dart';
import 'package:rentproof/src/data/evidence_repository.dart';
import 'package:rentproof/src/report/pdf_report_builder.dart';
import 'package:rentproof/src/report/report_models.dart';
import 'package:rentproof/src/report/snapshot_loader.dart';

import '../helpers.dart';

void main() {
  late TestEnv env;
  late Property property;

  setUp(() async {
    env = await TestEnv.create();
    property = await env.property('Café Ünïcode 🏠 "Loft"');
  });
  tearDown(() async => env.dispose());

  Future<Inspection> documentedInspection({
    InspectionType type = InspectionType.moveIn,
    String? baseline,
  }) async {
    final i = await env.inspections.create(
      propertyId: property.id,
      type: type,
      roomTemplateKeys: const ['kitchen', 'bathroom'],
      baselineInspectionId: baseline,
    );
    final rooms = await env.inspections.watchRoomProgress(i.id).first;
    final kitchen = rooms.first;
    final photo = await env.evidence.addMedia(
      roomId: kitchen.room.id,
      checklistItemId: kitchen.checklist.first.item.id,
      sourcePath: env
          .writeJpeg('k${type.name}.jpg', width: 800, height: 600)
          .path,
      kind: MediaKind.photo,
      source: MediaSource.camera,
    );
    await env.evidence.updateCaption(photo.id, 'Counter chip — near sink 👍');
    final issue = await env.evidence.addIssue(
      kitchen.room.id,
      IssueInput(
        title: 'Chipped counter',
        description: 'Ünïcode: ñ ü ß ж λ "quotes" <tags> & emoji 🔥\nline 2',
        mediaId: photo.id,
      ),
    );
    await env.evidence.addAnnotation(
      mediaId: photo.id,
      x: 0.3,
      y: 0.6,
      issueId: issue.id,
    );
    await env.evidence.addMedia(
      roomId: kitchen.room.id,
      sourcePath: env
          .writeBytes('v${type.name}.mp4', List.filled(2048, 1))
          .path,
      kind: MediaKind.video,
      source: MediaSource.camera,
    );
    await env.evidence.addMedia(
      roomId: rooms[1].room.id,
      sourcePath: env
          .writeBytes('bad${type.name}.jpg', List.filled(99, 3))
          .path,
      kind: MediaKind.photo,
      source: MediaSource.import,
    );
    return i;
  }

  test('pdfSafe replaces unsupported glyphs only', () {
    expect(pdfSafe('Café ж λ – “x”'), 'Café ж λ – “x”');
    expect(pdfSafe('fire 🔥'), 'fire ?');
  });

  test('generates a PDF with recorded hash and counts', () async {
    final i = await documentedInspection();
    final report = await env.reports.generate(i.id);
    final file = File(env.reports.reportFilePath(report));
    final bytes = file.readAsBytesSync();
    expect(utf8.decode(bytes.sublist(0, 5)), '%PDF-');
    expect(report.sha256, sha256.convert(bytes).toString());
    expect(report.byteSize, bytes.length);
    expect(report.mediaCount, 3);
    expect(report.issueCount, 1);
    expect(report.includesComparison, isFalse);
    expect(report.generatedAt, env.clock.value);
  });

  test('generates a PDF for an inspection without media', () async {
    final i = await env.inspections.create(
      propertyId: property.id,
      type: InspectionType.routine,
      roomTemplateKeys: const [],
    );
    final report = await env.reports.generate(i.id);
    expect(
      File(env.reports.reportFilePath(report)).lengthSync(),
      greaterThan(1000),
    );
  });

  test('move-out report includes comparison with baseline', () async {
    final moveIn = await documentedInspection();
    await env.inspections.complete(moveIn.id);
    final moveOut = await documentedInspection(
      type: InspectionType.moveOut,
      baseline: moveIn.id,
    );
    final rooms = await env.inspections.watchRoomProgress(moveOut.id).first;
    await env.inspections.setComparisonVerdict(
      rooms.first.room.id,
      ComparisonVerdict.changed,
      note: 'Chip is larger',
    );
    final report = await env.reports.generate(moveOut.id);
    expect(report.includesComparison, isTrue);

    final input = await env.reports.prepare(moveOut.id);
    expect(input.pairs, hasLength(2));
    expect(
      input.pairs.every((p) => p.current != null && p.baseline != null),
      isTrue,
    );
  });

  test('pairRooms keeps unmatched rooms from both sides', () async {
    final a = await env.inspections.create(
      propertyId: property.id,
      type: InspectionType.moveIn,
      roomTemplateKeys: const ['kitchen', 'laundry'],
    );
    final b = await env.inspections.create(
      propertyId: property.id,
      type: InspectionType.moveOut,
      roomTemplateKeys: const ['kitchen', 'bedroom'],
    );
    final loader = SnapshotLoader(env.db, env.paths);
    final pairs = pairRooms(await loader.load(b.id), await loader.load(a.id));
    expect(pairs.map((p) => p.name), ['Kitchen', 'Bedroom', 'Laundry']);
    expect(pairs[0].baseline, isNotNull);
    expect(pairs[1].baseline, isNull);
    expect(pairs[2].current, isNull);
  });

  test('evidence IDs are sequential in walkthrough order', () async {
    final i = await documentedInspection();
    final snap = await env.reports.snapshot(i.id);
    expect(snap.allMedia.map((m) => m.evidenceId), ['E-001', 'E-002', 'E-003']);
    expect(snap.allMedia.first.promptLabel, 'Overview');
  });

  test(
    'evidence package contains originals, manifest and valid sums',
    () async {
      final i = await documentedInspection();
      final report = await env.reports.generate(i.id);
      final zip = await env.reports.exportEvidencePackage(i.id, report: report);
      final archive = ZipDecoder().decodeBytes(zip.readAsBytesSync());
      final names = archive.files.map((f) => f.name).toSet();
      expect(
        names,
        containsAll([
          'manifest.json',
          'SHA256SUMS.txt',
          'README.txt',
          'report.pdf',
        ]),
      );
      final originals = archive.files.where(
        (f) => f.name.startsWith('originals/'),
      );
      expect(originals, hasLength(3));

      final sums = utf8.decode(
        archive.files.firstWhere((f) => f.name == 'SHA256SUMS.txt').content,
      );
      for (final line in sums.trim().split('\n')) {
        final parts = line.split('  ');
        final file = archive.files.firstWhere((f) => f.name == parts[1]);
        expect(sha256.convert(file.content).toString(), parts[0]);
      }

      final manifest = jsonDecode(
        utf8.decode(
          archive.files.firstWhere((f) => f.name == 'manifest.json').content,
        ),
      ) as Map<String, dynamic>;
      expect(manifest['format'], 'rentproof-evidence-package');
      expect((manifest['media'] as List), hasLength(3));
      expect(manifest['missingOriginals'], isEmpty);
      expect((manifest['limitations'] as List), isNotEmpty);
    },
  );

  test('evidence package lists missing originals', () async {
    final i = await documentedInspection();
    final media = await env.evidence.mediaForInspection(i.id);
    File(env.evidence.originalFilePath(media.first)).deleteSync();
    final zip = await env.reports.exportEvidencePackage(i.id);
    final archive = ZipDecoder().decodeBytes(zip.readAsBytesSync());
    final manifest = jsonDecode(
      utf8.decode(
        archive.files.firstWhere((f) => f.name == 'manifest.json').content,
      ),
    ) as Map<String, dynamic>;
    expect(manifest['missingOriginals'], ['E-001']);
    expect(
      archive.files.where((f) => f.name.startsWith('originals/')),
      hasLength(2),
    );
  });

  test('delete report removes the file', () async {
    final i = await documentedInspection();
    final report = await env.reports.generate(i.id);
    final path = env.reports.reportFilePath(report);
    await env.reports.deleteReport(report.id);
    expect(File(path).existsSync(), isFalse);
  });

  test('performance: 60 photos across 12 rooms', () async {
    final i = await env.inspections.create(
      propertyId: property.id,
      type: InspectionType.moveIn,
      roomTemplateKeys: const [
        'entry',
        'living',
        'kitchen',
        'dining',
        'bedroom',
        'bathroom',
        'laundry',
        'storage',
        'outdoor',
        'utilities',
      ],
    );
    await env.inspections.addRoom(inspectionId: i.id, templateKey: 'bedroom');
    await env.inspections.addRoom(inspectionId: i.id, templateKey: 'bathroom');
    final rooms = await env.inspections.watchRoomProgress(i.id).first;
    expect(rooms, hasLength(12));
    final source = env.writeJpeg('big.jpg', width: 3000, height: 2000);
    for (var k = 0; k < 60; k++) {
      await env.evidence.addMedia(
        roomId: rooms[k % 12].room.id,
        sourcePath: source.path,
        kind: MediaKind.photo,
        source: MediaSource.import,
      );
    }
    final sw = Stopwatch()..start();
    final report = await env.reports.generate(i.id);
    sw.stop();
    // Recorded for docs/engineering/PERFORMANCE.md; generous bound for CI.
    // ignore: avoid_print
    print(
      'PERF report 60 photos: ${sw.elapsedMilliseconds} ms, '
      '${formatBytes(report.byteSize)}',
    );
    expect(sw.elapsed, lessThan(const Duration(seconds: 90)));
  }, timeout: const Timeout(Duration(minutes: 5)));
}
