import 'dart:io';
import 'dart:typed_data';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;
import 'package:rentproof/src/data/database.dart';
import 'package:rentproof/src/data/evidence_repository.dart';
import 'package:rentproof/src/data/inspection_repository.dart';
import 'package:rentproof/src/data/property_repository.dart';
import 'package:rentproof/src/report/pdf_report_builder.dart';
import 'package:rentproof/src/report/report_repository.dart';
import 'package:rentproof/src/services/clock.dart';
import 'package:rentproof/src/services/media_processing.dart';
import 'package:rentproof/src/services/storage_paths.dart';

/// Everything a data-layer test needs, backed by an in-memory database and a
/// temporary directory.
class TestEnv {
  TestEnv._(this.db, this.paths, this.dir, this.clock);

  final AppDatabase db;
  final StoragePaths paths;
  final Directory dir;
  final FixedClock clock;

  late final properties = PropertyRepository(db, paths, clock: clock);
  late final inspections = InspectionRepository(db, paths, clock: clock);
  late final evidence = EvidenceRepository(
    db,
    paths,
    clock: clock,
    processor: processMedia,
  );
  late final reports = ReportRepository(
    db,
    paths,
    clock: clock,
    fonts: loadTestFonts,
    runner: (input, fonts) => buildReportPdf(input, fonts),
  );

  static Future<TestEnv> create() async {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    final dir = await Directory.systemTemp.createTemp('rentproof_test_');
    final db = AppDatabase(NativeDatabase.memory());
    final paths = StoragePaths(
      root: p.join(dir.path, 'support'),
      exportRoot: p.join(dir.path, 'exports'),
    );
    return TestEnv._(db, paths, dir, FixedClock(DateTime(2026, 9, 1, 10, 30)));
  }

  Future<void> dispose() async {
    await db.close();
    if (dir.existsSync()) await dir.delete(recursive: true);
  }

  /// Writes a JPEG test photo and returns its path.
  File writeJpeg(
    String name, {
    int width = 64,
    int height = 48,
    bool withExif = false,
    bool withGps = false,
  }) {
    final image = img.Image(width: width, height: height);
    img.fill(image, color: img.ColorRgb8(200, 120, 40));
    if (withExif) {
      image.exif.imageIfd.make = 'TestMake';
      image.exif.imageIfd.model = 'TestModel';
      image.exif.exifIfd[0x9003] = img.IfdValueAscii('2026:08:31 09:15:00');
    }
    if (withGps) {
      image.exif.gpsIfd.gpsLatitudeRef = 'N';
      image.exif.gpsIfd.gpsLatitude = 40.0;
    }
    final file = File(p.join(dir.path, 'input', name));
    file.parent.createSync(recursive: true);
    file.writeAsBytesSync(img.encodeJpg(image));
    return file;
  }

  File writeBytes(String name, List<int> bytes) {
    final file = File(p.join(dir.path, 'input', name));
    file.parent.createSync(recursive: true);
    file.writeAsBytesSync(bytes);
    return file;
  }

  Future<Property> property([String nickname = 'Maple Apt 4B']) =>
      properties.create(PropertyInput(nickname: nickname, city: 'Austin'));
}

Future<ReportFonts> loadTestFonts() async {
  ByteData read(String name) {
    final bytes = File('assets/fonts/$name').readAsBytesSync();
    return ByteData.sublistView(Uint8List.fromList(bytes));
  }

  return ReportFonts(
    regular: read('Roboto-Regular.ttf'),
    bold: read('Roboto-Bold.ttf'),
    italic: read('Roboto-Italic.ttf'),
  );
}
