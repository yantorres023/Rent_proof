import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:rentproof/src/data/database.dart';
import 'package:rentproof/src/data/property_repository.dart';
import 'package:rentproof/src/data/settings_repository.dart';

import '../helpers.dart';

void main() {
  late TestEnv env;

  setUp(() async => env = await TestEnv.create());
  tearDown(() async => env.dispose());

  test('creates a property with trimmed fields', () async {
    final p = await env.properties.create(
      const PropertyInput(nickname: '  Maple Apt  ', city: ' Austin '),
    );
    expect(p.nickname, 'Maple Apt');
    expect(p.city, 'Austin');
    expect(p.createdAt, env.clock.value);
  });

  test('requires a nickname', () async {
    expect(
      () => env.properties.create(const PropertyInput(nickname: '   ')),
      throwsA(isA<ValidationException>()),
    );
  });

  test('truncates very long text and keeps special characters', () async {
    final p = await env.properties.create(
      PropertyInput(
        nickname: 'Café "Ünïcode" 🏠 ${'x' * 500}',
        notes: 'n' * 10000,
      ),
    );
    expect(p.nickname.length, 120);
    expect(p.nickname, startsWith('Café "Ünïcode" 🏠'));
    expect(p.notes.length, 2000);
  });

  test('summaries include inspection counts', () async {
    final p = await env.property();
    await env.inspections.create(propertyId: p.id, type: InspectionType.moveIn);
    final summaries = await env.properties.watchSummaries().first;
    expect(summaries.single.inspectionCount, 1);
    expect(summaries.single.lastInspectionAt!.isUtc, isFalse);
    expect(
      summaries.single.lastInspectionAt!.isAtSameMomentAs(env.clock.value),
      isTrue,
    );
  });

  test('delete cascades to inspections and removes files', () async {
    final p = await env.property();
    final inspection = await env.inspections.create(
      propertyId: p.id,
      type: InspectionType.moveIn,
    );
    final rooms = await env.inspections.watchRoomProgress(inspection.id).first;
    final media = await env.evidence.addMedia(
      roomId: rooms.first.room.id,
      sourcePath: env.writeJpeg('x.jpg').path,
      kind: MediaKind.photo,
      source: MediaSource.camera,
    );
    final original = File(env.evidence.originalFilePath(media));
    expect(original.existsSync(), isTrue);

    await env.properties.delete(p.id);

    expect(await env.db.select(env.db.inspections).get(), isEmpty);
    expect(await env.db.select(env.db.rooms).get(), isEmpty);
    expect(await env.db.select(env.db.mediaEvidence).get(), isEmpty);
    expect(await env.db.select(env.db.evidenceHashes).get(), isEmpty);
    expect(original.existsSync(), isFalse);
  });

  test('delete all data erases rows and files', () async {
    final p = await env.property();
    final inspection = await env.inspections.create(
      propertyId: p.id,
      type: InspectionType.moveIn,
    );
    final rooms = await env.inspections.watchRoomProgress(inspection.id).first;
    final media = await env.evidence.addMedia(
      roomId: rooms.first.room.id,
      sourcePath: env.writeJpeg('y.jpg').path,
      kind: MediaKind.photo,
      source: MediaSource.camera,
    );
    await env.reports.generate(inspection.id);
    final settings = SettingsRepository(env.db, env.paths, clock: env.clock);
    await settings.setOnboardingCompleted();
    await settings.saveProfile(name: 'Alex', email: '');

    await settings.deleteAllData();

    for (final table in env.db.allTables) {
      expect(
        await env.db.select(table).get(),
        isEmpty,
        reason: table.actualTableName,
      );
    }
    expect(File(env.evidence.originalFilePath(media)).existsSync(), isFalse);
    expect(Directory(env.paths.reportsRoot).existsSync(), isFalse);
    expect(await settings.watchOnboardingCompleted().first, isFalse);
  });
}
