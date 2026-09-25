import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../data/database.dart';
import 'safe_paths.dart';

/// Private, app-controlled directories. Nothing is written to shared storage
/// or the photo gallery; exports go to a temp directory for the share sheet.
class StoragePaths {
  StoragePaths({required this.root, required this.exportRoot});

  /// Root of persistent private storage (application support directory).
  final String root;

  /// Scratch directory for share/export files; safe to clear anytime.
  final String exportRoot;

  String get evidenceRoot => p.join(root, 'evidence');
  String get reportsRoot => p.join(root, 'reports');

  static Future<StoragePaths> platform() async {
    final support = await getApplicationSupportDirectory();
    final temp = await getTemporaryDirectory();
    return StoragePaths(
      root: support.path,
      exportRoot: p.join(temp.path, 'rentproof_exports'),
    );
  }

  String evidenceFile(String relative) => resolveWithin(evidenceRoot, relative);
  String reportFile(String relative) => resolveWithin(reportsRoot, relative);

  /// Relative paths are built only from generated IDs and allow-listed
  /// extensions, never from user-supplied names.
  static String originalRelative(
    String inspectionId,
    String mediaId,
    String ext,
  ) => p.join(inspectionId, 'originals', '$mediaId.$ext');

  static String previewRelative(String inspectionId, String mediaId) =>
      p.join(inspectionId, 'derived', '${mediaId}_preview.jpg');

  static String thumbnailRelative(String inspectionId, String mediaId) =>
      p.join(inspectionId, 'derived', '${mediaId}_thumb.jpg');

  static String reportRelative(String inspectionId, String reportId) =>
      p.join(inspectionId, '$reportId.pdf');

  Future<void> deleteInspectionFiles(String inspectionId) async {
    for (final dir in [
      Directory(resolveWithin(evidenceRoot, inspectionId)),
      Directory(resolveWithin(reportsRoot, inspectionId)),
    ]) {
      if (dir.existsSync()) await dir.delete(recursive: true);
    }
  }

  /// Deletes the stored original and derived copies of [media].
  Future<void> deleteMediaFiles(MediaItem media) async {
    for (final rel in [
      media.originalPath,
      media.previewPath,
      media.thumbnailPath,
    ]) {
      if (rel == null) continue;
      final f = File(evidenceFile(rel));
      if (f.existsSync()) await f.delete();
    }
  }

  Future<void> clearExports() async {
    final dir = Directory(exportRoot);
    if (dir.existsSync()) await dir.delete(recursive: true);
  }

  Future<Directory> freshExportDir() async {
    final dir = Directory(exportRoot);
    await dir.create(recursive: true);
    return dir;
  }

  /// Total bytes used by evidence and reports.
  Future<int> usedBytes() async {
    var total = 0;
    for (final path in [evidenceRoot, reportsRoot]) {
      final dir = Directory(path);
      if (!dir.existsSync()) continue;
      await for (final e in dir.list(recursive: true, followLinks: false)) {
        if (e is File) total += await e.length();
      }
    }
    return total;
  }
}
