import 'package:flutter_test/flutter_test.dart';

import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:rentproof/src/services/safe_paths.dart';
import 'package:rentproof/src/services/storage_paths.dart';

void main() {
  group('safeExtension', () {
    test('allow-lists known media types case-insensitively', () {
      expect(safeExtension('IMG_001.JPG'), 'jpg');
      expect(safeExtension('clip.MOV'), 'mov');
      expect(safeExtension('photo.heic'), 'heic');
    });

    test('maps unknown or dangerous extensions to bin', () {
      expect(safeExtension('evil.sh'), 'bin');
      expect(safeExtension('noext'), 'bin');
      expect(safeExtension('../../x.jpg/..'), 'bin');
    });
  });

  group('sanitizeDisplayFileName', () {
    test('strips directories and control characters', () {
      expect(sanitizeDisplayFileName('../../etc/passwd'), 'passwd');
      expect(sanitizeDisplayFileName(r'C:\Users\a\b.jpg'), 'b.jpg');
      expect(sanitizeDisplayFileName('a\u0000b\nc.jpg'), 'abc.jpg');
      expect(sanitizeDisplayFileName('..'), '');
    });

    test('caps length and keeps the extension', () {
      final long = '${'x' * 300}.jpeg';
      final result = sanitizeDisplayFileName(long);
      expect(result.length, lessThanOrEqualTo(100));
      expect(result, endsWith('.jpeg'));
    });
  });

  group('resolveWithin', () {
    test('resolves nested relative paths', () {
      expect(resolveWithin('/root', 'a/b.jpg'), '/root/a/b.jpg');
    });

    test('rejects traversal and absolute paths', () {
      expect(() => resolveWithin('/root', '../x'), throwsArgumentError);
      expect(() => resolveWithin('/root', 'a/../../x'), throwsArgumentError);
      expect(() => resolveWithin('/root', '/etc/passwd'), throwsArgumentError);
      expect(() => resolveWithin('/root', ''), throwsArgumentError);
    });
  });

  test('slugForFileName produces safe names', () {
    expect(slugForFileName('Maple Apt #4B / Café'), 'maple-apt-4b-caf');
    expect(slugForFileName('!!!'), 'export');
    expect(slugForFileName('a' * 100).length, 40);
  });

  test('discardPickerTemp only deletes files inside the app cache', () async {
    final dir = await Directory.systemTemp.createTemp('rp_cache_');
    addTearDown(() => dir.delete(recursive: true));
    final paths = StoragePaths(
      root: p.join(dir.path, 'support'),
      exportRoot: p.join(dir.path, 'cache', 'rentproof_exports'),
    );
    File cacheFile(String rel) => File(p.join(dir.path, rel))
      ..createSync(recursive: true)
      ..writeAsStringSync('x');
    final picked = cacheFile('cache/image_picker123.jpg');
    final export = cacheFile('cache/rentproof_exports/report.pdf');
    final outside = cacheFile('elsewhere/photo.jpg');
    await paths.discardPickerTemp(picked.path);
    await paths.discardPickerTemp(export.path);
    await paths.discardPickerTemp(outside.path);
    await paths.discardPickerTemp(
      p.join(dir.path, 'cache', '..', 'elsewhere', 'photo.jpg'),
    );
    expect(picked.existsSync(), isFalse);
    expect(export.existsSync(), isTrue);
    expect(outside.existsSync(), isTrue);
  });
}
