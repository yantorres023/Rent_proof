import 'package:drift/drift.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rentproof/src/data/database.dart';

import 'generated_schema/schema.dart';

/// Guards the on-device database format.
///
/// When the schema changes: bump `schemaVersion`, add an `onUpgrade` step,
/// run `dart run drift_dev make-migrations`, regenerate
/// `test/data/generated_schema/`, and add a `migrateAndValidate` test for
/// every older version.
void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late SchemaVerifier verifier;

  setUpAll(() => verifier = SchemaVerifier(GeneratedHelper()));

  test('fresh install matches the committed v1 schema', () async {
    final connection = await verifier.startAt(1);
    final db = AppDatabase(connection);
    await verifier.migrateAndValidate(db, 1);
    await db.close();
  });

  test('schemaVersion matches the latest committed schema snapshot', () {
    final db = AppDatabase(
      DatabaseConnection(
        // Never opened; only reads the constant.
        LazyDatabase(() => throw UnimplementedError()),
      ),
    );
    expect(db.schemaVersion, GeneratedHelper.versions.last);
  });

  test('foreign keys are enforced', () async {
    final connection = await verifier.startAt(1);
    final db = AppDatabase(connection);
    final pragma = await db.customSelect('PRAGMA foreign_keys').getSingle();
    expect(pragma.data.values.single, 1);
    await db.close();
  });
}
