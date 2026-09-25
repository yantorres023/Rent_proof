import 'package:flutter_test/flutter_test.dart';
import 'package:rentproof/src/data/database.dart';
import 'package:rentproof/src/data/inspection_repository.dart';
import 'package:rentproof/src/data/property_repository.dart';
import 'package:rentproof/src/services/room_templates.dart';

import '../helpers.dart';

void main() {
  late TestEnv env;
  late Property property;

  setUp(() async {
    env = await TestEnv.create();
    property = await env.property();
  });
  tearDown(() async => env.dispose());

  Future<Inspection> newInspection({
    InspectionType type = InspectionType.moveIn,
    List<String> rooms = defaultRoomKeys,
    String? baseline,
  }) => env.inspections.create(
    propertyId: property.id,
    type: type,
    roomTemplateKeys: rooms,
    baselineInspectionId: baseline,
  );

  Future<void> addPhoto(String roomId, {String? itemId}) =>
      env.evidence.addMedia(
        roomId: roomId,
        checklistItemId: itemId,
        sourcePath: env.writeJpeg('p${DateTime.now().microsecond}.jpg').path,
        kind: MediaKind.photo,
        source: MediaSource.camera,
      );

  test('creates default rooms with guided prompts', () async {
    final i = await newInspection();
    final rooms = await env.inspections.watchRoomProgress(i.id).first;
    expect(rooms.map((r) => r.room.name).toList(), [
      'Entry & hallway',
      'Living room',
      'Kitchen',
      'Bedroom',
      'Bathroom',
    ]);
    final kitchen = rooms[2];
    expect(kitchen.totalCount, templateForKey('kitchen')!.prompts.length);
    expect(kitchen.doneCount, 0);
    expect(i.status, InspectionStatus.inProgress);
  });

  test('an empty room list is allowed', () async {
    final i = await newInspection(rooms: const []);
    expect(await env.inspections.watchRoomProgress(i.id).first, isEmpty);
  });

  test('duplicate room names get a numeric suffix', () async {
    final i = await newInspection(rooms: const ['bedroom']);
    final second = await env.inspections.addRoom(
      inspectionId: i.id,
      templateKey: 'bedroom',
    );
    final third = await env.inspections.addRoom(
      inspectionId: i.id,
      customName: 'bedroom',
    );
    expect(second.name, 'Bedroom 2');
    expect(third.name, 'bedroom 3');
    expect(third.templateKey, 'custom');
  });

  test('rejects blank room names', () async {
    final i = await newInspection(rooms: const []);
    expect(
      () => env.inspections.addRoom(inspectionId: i.id, customName: '  '),
      throwsA(isA<ValidationException>()),
    );
  });

  test('progress counts documented and not-applicable prompts', () async {
    final i = await newInspection(rooms: const ['laundry']);
    var room = (await env.inspections.watchRoomProgress(i.id).first).single;
    await addPhoto(room.room.id, itemId: room.checklist[0].item.id);
    await env.inspections.setChecklistNotApplicable(
      room.checklist[1].item.id,
      true,
    );
    room = await env.inspections.loadRoomProgress(room.room.id);
    expect(room.doneCount, 2);
    expect(room.mediaCount, 1);
    expect(room.room.status, RoomStatus.inProgress);
  });

  test('cannot complete an inspection without media', () async {
    final i = await newInspection();
    expect(
      () => env.inspections.complete(i.id),
      throwsA(isA<InspectionNotReadyException>()),
    );
  });

  test('completed inspections are locked until reopened', () async {
    final i = await newInspection(rooms: const ['kitchen']);
    final room = (await env.inspections.watchRoomProgress(i.id).first).single;
    await addPhoto(room.room.id);
    env.clock.advance(const Duration(minutes: 20));
    await env.inspections.complete(i.id);
    final done = await env.inspections.getInspection(i.id);
    expect(done.status, InspectionStatus.completed);
    expect(done.completedAt, env.clock.value);

    await expectLater(
      addPhoto(room.room.id),
      throwsA(isA<InspectionLockedException>()),
    );
    await expectLater(
      env.inspections.addRoom(inspectionId: i.id, customName: 'Garage'),
      throwsA(isA<InspectionLockedException>()),
    );

    await env.inspections.reopen(i.id);
    await addPhoto(room.room.id);
    final reopened = await env.inspections.getInspection(i.id);
    expect(reopened.completedAt, isNull);
  });

  test('baseline inspection copies rooms and prompts with links', () async {
    final moveIn = await newInspection(rooms: const ['kitchen', 'bathroom']);
    await env.inspections.addRoom(inspectionId: moveIn.id, customName: 'Den');
    final moveOut = await newInspection(
      type: InspectionType.moveOut,
      baseline: moveIn.id,
    );
    final before = await env.inspections.watchRoomProgress(moveIn.id).first;
    final after = await env.inspections.watchRoomProgress(moveOut.id).first;
    expect(after.map((r) => r.room.name), before.map((r) => r.room.name));
    for (var k = 0; k < after.length; k++) {
      expect(after[k].room.baselineRoomId, before[k].room.id);
      expect(
        after[k].checklist.map((c) => c.item.label),
        before[k].checklist.map((c) => c.item.label),
      );
    }
    expect(moveOut.baselineInspectionId, moveIn.id);
  });

  test('baseline must belong to the same property', () async {
    final other = await env.property('Other place');
    final foreign = await env.inspections.create(
      propertyId: other.id,
      type: InspectionType.moveIn,
    );
    expect(
      () => newInspection(baseline: foreign.id),
      throwsA(isA<ValidationException>()),
    );
  });

  test('deleting a baseline keeps the later inspection', () async {
    final moveIn = await newInspection(rooms: const ['kitchen']);
    final moveOut = await newInspection(
      type: InspectionType.moveOut,
      baseline: moveIn.id,
    );
    await env.inspections.deleteInspection(moveIn.id);
    final after = await env.inspections.getInspection(moveOut.id);
    expect(after.baselineInspectionId, isNull);
    final rooms = await env.inspections.watchRoomProgress(moveOut.id).first;
    expect(rooms.single.room.baselineRoomId, isNull);
  });

  test('deleting a room removes its media rows', () async {
    final i = await newInspection(rooms: const ['kitchen']);
    final room = (await env.inspections.watchRoomProgress(i.id).first).single;
    await addPhoto(room.room.id);
    await env.inspections.deleteRoom(room.room.id);
    expect(await env.db.select(env.db.mediaEvidence).get(), isEmpty);
  });

  test('summaries report counts', () async {
    final i = await newInspection(rooms: const ['kitchen', 'bathroom']);
    final rooms = await env.inspections.watchRoomProgress(i.id).first;
    await addPhoto(rooms.first.room.id);
    await env.inspections.setRoomStatus(
      rooms.first.room.id,
      RoomStatus.completed,
    );
    final summary =
        (await env.inspections.watchSummaries(property.id).first).single;
    expect(summary.roomCount, 2);
    expect(summary.completedRoomCount, 1);
    expect(summary.mediaCount, 1);
    expect(summary.issueCount, 0);
  });

  test('comparison verdict upserts per room', () async {
    final i = await newInspection(rooms: const ['kitchen']);
    final room = (await env.inspections.watchRoomProgress(i.id).first).single;
    await env.inspections.setComparisonVerdict(
      room.room.id,
      ComparisonVerdict.noChange,
    );
    await env.inspections.setComparisonVerdict(
      room.room.id,
      ComparisonVerdict.newIssue,
      note: 'Scratch on counter',
    );
    final c = await env.inspections.comparisonFor(room.room.id);
    expect(c!.verdict, ComparisonVerdict.newIssue);
    expect(c.note, 'Scratch on counter');
    expect(await env.db.select(env.db.roomComparisons).get(), hasLength(1));
  });
}
