import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rentproof/src/data/database.dart';
import 'package:rentproof/src/data/evidence_repository.dart';
import 'package:rentproof/src/data/property_repository.dart';
import 'package:rentproof/src/services/media_processing.dart';

import '../helpers.dart';

void main() {
  late TestEnv env;
  late String roomId;
  late String otherRoomId;
  late String inspectionId;

  setUp(() async {
    env = await TestEnv.create();
    final property = await env.property();
    final i = await env.inspections.create(
      propertyId: property.id,
      type: InspectionType.moveIn,
      roomTemplateKeys: const ['kitchen', 'bathroom'],
    );
    inspectionId = i.id;
    final rooms = await env.inspections.watchRoomProgress(i.id).first;
    roomId = rooms[0].room.id;
    otherRoomId = rooms[1].room.id;
  });
  tearDown(() async => env.dispose());

  Future<MediaItem> addPhoto({String name = 'IMG_1.JPG', String? room}) =>
      env.evidence.addMedia(
        roomId: room ?? roomId,
        sourcePath: env.writeJpeg(name, withExif: true).path,
        sourceFileName: name,
        kind: MediaKind.photo,
        source: MediaSource.import,
      );

  test('stores original privately with hash and app timestamp', () async {
    final source = env.writeJpeg('IMG_9.JPG', withExif: true);
    final m = await env.evidence.addMedia(
      roomId: roomId,
      sourcePath: source.path,
      sourceFileName: 'IMG_9.JPG',
      kind: MediaKind.photo,
      source: MediaSource.camera,
    );
    expect(m.sha256, sha256.convert(source.readAsBytesSync()).toString());
    expect(m.recordedAt, env.clock.value);
    expect(m.originalPath, startsWith(inspectionId));
    expect(m.originalPath, endsWith('.jpg'));
    expect(m.originalPath, isNot(contains('IMG_9')));
    expect(m.sourceFileName, 'IMG_9.JPG');
    expect(m.mimeType, 'image/jpeg');
    expect(m.exifDateTimeOriginal, '2026:08:31 09:15:00');
    expect(File(env.evidence.originalFilePath(m)).existsSync(), isTrue);
    expect(File(env.evidence.thumbnailFilePath(m)!).existsSync(), isTrue);

    final history = await env.evidence.hashHistory(m.id);
    expect(history.single.purpose, HashPurpose.import);
    expect(history.single.result, HashCheckResult.recorded);
    expect(history.single.hexDigest, m.sha256);
  });

  test('traversal in the source name cannot escape storage', () async {
    final m = await env.evidence.addMedia(
      roomId: roomId,
      sourcePath: env.writeJpeg('safe.jpg').path,
      sourceFileName: '../../../../evil.sh',
      kind: MediaKind.photo,
      source: MediaSource.import,
    );
    expect(m.sourceFileName, 'evil.sh');
    expect(m.originalPath, endsWith('.jpg'));
    expect(
      File(env.evidence.originalFilePath(m)).path,
      startsWith(env.paths.evidenceRoot),
    );
  });

  test('verification detects match, mismatch and missing', () async {
    final m = await addPhoto();
    expect(await env.evidence.verifyMedia(m.id), HashCheckResult.match);

    final file = File(env.evidence.originalFilePath(m));
    file.writeAsBytesSync([...file.readAsBytesSync(), 0], flush: true);
    expect(await env.evidence.verifyMedia(m.id), HashCheckResult.mismatch);

    file.deleteSync();
    expect(await env.evidence.verifyMedia(m.id), HashCheckResult.missing);

    final history = await env.evidence.hashHistory(m.id);
    expect(history.map((h) => h.result), [
      HashCheckResult.recorded,
      HashCheckResult.match,
      HashCheckResult.mismatch,
      HashCheckResult.missing,
    ]);
  });

  test('verifyInspection summarizes results', () async {
    await addPhoto(name: 'a.jpg');
    final b = await addPhoto(name: 'b.jpg', room: otherRoomId);
    File(env.evidence.originalFilePath(b)).deleteSync();
    final summary = await env.evidence.verifyInspection(inspectionId);
    expect(summary.checked, 2);
    expect(summary.matched, 1);
    expect(summary.missing, 1);
    expect(summary.allMatch, isFalse);
  });

  test('delete removes files and unlinks issues', () async {
    final m = await addPhoto();
    final issue = await env.evidence.addIssue(
      roomId,
      IssueInput(title: 'Crack', mediaId: m.id),
    );
    await env.evidence.addAnnotation(mediaId: m.id, x: 0.5, y: 0.5);
    await env.evidence.deleteMedia(m.id);
    expect(File(env.evidence.originalFilePath(m)).existsSync(), isFalse);
    expect(File(env.evidence.thumbnailFilePath(m)!).existsSync(), isFalse);
    expect((await env.evidence.getIssue(issue.id)).mediaId, isNull);
    expect(await env.db.select(env.db.annotations).get(), isEmpty);
    expect(await env.db.select(env.db.evidenceHashes).get(), isEmpty);
  });

  test('failed processing leaves no database rows', () async {
    final failing = EvidenceRepository(
      env.db,
      env.paths,
      clock: env.clock,
      processor: (_) async => throw const MediaProcessingException('no_space'),
    );
    await expectLater(
      failing.addMedia(
        roomId: roomId,
        sourcePath: env.writeJpeg('z.jpg').path,
        kind: MediaKind.photo,
        source: MediaSource.camera,
      ),
      throwsA(isA<MediaProcessingException>()),
    );
    expect(await env.db.select(env.db.mediaEvidence).get(), isEmpty);
  });

  group('issues', () {
    test('validates title and room of linked photo', () async {
      expect(
        () => env.evidence.addIssue(roomId, const IssueInput(title: ' ')),
        throwsA(isA<ValidationException>()),
      );
      final m = await addPhoto(room: otherRoomId);
      expect(
        () => env.evidence.addIssue(
          roomId,
          IssueInput(title: 'Stain', mediaId: m.id),
        ),
        throwsA(isA<ValidationException>()),
      );
    });

    test('create, update and delete', () async {
      final issue = await env.evidence.addIssue(
        roomId,
        IssueInput(
          title: 'Burn mark <script>',
          description: 'd' * 5000,
          category: IssueCategory.damage,
          severity: IssueSeverity.major,
        ),
      );
      expect(issue.title, 'Burn mark <script>');
      expect(issue.description.length, 4000);
      final updated = await env.evidence.updateIssue(
        issue.id,
        const IssueInput(title: 'Burn mark', severity: IssueSeverity.minor),
      );
      expect(updated.severity, IssueSeverity.minor);
      await env.evidence.deleteIssue(issue.id);
      expect(await env.evidence.roomIssues(roomId), isEmpty);
    });
  });

  test('annotations are clamped and reject NaN', () async {
    final m = await addPhoto();
    final a = await env.evidence.addAnnotation(mediaId: m.id, x: 1.7, y: -2);
    expect(a.x, 1.0);
    expect(a.y, 0.0);
    expect(
      () => env.evidence.addAnnotation(mediaId: m.id, x: double.nan, y: 0),
      throwsA(isA<ValidationException>()),
    );
  });
}
