import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:rentproof/src/services/media_processing.dart';

import '../helpers.dart';

void main() {
  late TestEnv env;

  setUp(() async => env = await TestEnv.create());
  tearDown(() async => env.dispose());

  MediaProcessRequest request(File source, {bool isPhoto = true}) {
    final out = p.join(env.dir.path, 'out');
    return MediaProcessRequest(
      sourcePath: source.path,
      originalDestPath: p.join(out, 'orig.bin'),
      previewDestPath: isPhoto ? p.join(out, 'preview.jpg') : null,
      thumbnailDestPath: isPhoto ? p.join(out, 'thumb.jpg') : null,
      isPhoto: isPhoto,
    );
  }

  test('copies byte-for-byte and records the SHA-256 of the copy', () async {
    final source = env.writeJpeg('a.jpg');
    final expected = sha256.convert(source.readAsBytesSync()).toString();
    final req = request(source);
    final result = await processMedia(req);
    expect(result.sha256, expected);
    expect(result.byteSize, source.lengthSync());
    expect(
      File(req.originalDestPath).readAsBytesSync(),
      source.readAsBytesSync(),
    );
  });

  test('derives preview and thumbnail without EXIF', () async {
    final source = env.writeJpeg(
      'b.jpg',
      width: 2400,
      height: 1200,
      withExif: true,
      withGps: true,
    );
    final req = request(source);
    final result = await processMedia(req);
    expect(result.previewWritten, isTrue);
    expect(result.thumbnailWritten, isTrue);
    expect(result.width, 2400);
    expect(result.height, 1200);
    expect(result.exifDateTimeOriginal, '2026:08:31 09:15:00');
    expect(result.exifMake, 'TestMake');
    expect(result.exifModel, 'TestModel');
    expect(result.hasGps, isTrue);
    final preview = File(req.previewDestPath!).readAsBytesSync();
    final previewMeta = readPhotoMetadata(preview);
    expect(previewMeta.hasGps, isFalse);
    expect(previewMeta.make, isNull);
  });

  test('keeps corrupted photos as originals without a preview', () async {
    final source = env.writeBytes('broken.jpg', List.filled(500, 7));
    final req = request(source);
    final result = await processMedia(req);
    expect(result.previewWritten, isFalse);
    expect(result.thumbnailWritten, isFalse);
    expect(File(req.originalDestPath).existsSync(), isTrue);
    expect(File(req.previewDestPath!).existsSync(), isFalse);
  });

  test('videos are stored and hashed without derivatives', () async {
    final source = env.writeBytes('clip.mp4', List.generate(4096, (i) => i));
    final result = await processMedia(request(source, isPhoto: false));
    expect(result.previewWritten, isFalse);
    expect(result.byteSize, 4096);
  });

  test('rejects missing and empty sources', () async {
    final missing = File(p.join(env.dir.path, 'nope.jpg'));
    await expectLater(
      processMedia(request(missing)),
      throwsA(
        isA<MediaProcessingException>().having(
          (e) => e.code,
          'code',
          'source_missing',
        ),
      ),
    );
    final empty = env.writeBytes('empty.jpg', []);
    final req = request(empty);
    await expectLater(
      processMedia(req),
      throwsA(
        isA<MediaProcessingException>().having(
          (e) => e.code,
          'code',
          'empty_file',
        ),
      ),
    );
    expect(File(req.originalDestPath).existsSync(), isFalse);
  });

  test('sha256OfFile streams large files', () async {
    final bytes = List.generate(3 * 1024 * 1024 + 17, (i) => i % 251);
    final file = env.writeBytes('large.bin', bytes);
    expect(await sha256OfFile(file.path), sha256.convert(bytes).toString());
  });
}
