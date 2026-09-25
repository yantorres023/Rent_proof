import 'package:flutter_test/flutter_test.dart';
import 'package:rentproof/src/data/database.dart';
import 'package:rentproof/src/data/evidence_repository.dart';

import 'harness.dart';

/// A finished move-in (kitchen photo with an issue and a marker, one report)
/// and a move-out inspection that uses it as baseline.
class Seeded {
  Seeded(
    this.inspectionId,
    this.roomId,
    this.mediaId,
    this.moveOutId,
    this.moveOutRoomId,
  );

  final String inspectionId;
  final String roomId;
  final String mediaId;
  final String moveOutId;
  final String moveOutRoomId;
}

Future<Seeded> seed(UiEnv ui, WidgetTester tester) async {
  final result = await tester.runAsync(() async {
    final env = ui.env;
    final p = await env.property('Maple St apartment');
    final i = await env.inspections.create(
      propertyId: p.id,
      type: InspectionType.moveIn,
      roomTemplateKeys: const ['kitchen', 'bathroom'],
    );
    final rooms = await env.inspections.watchRoomProgress(i.id).first;
    final kitchen = rooms.first;
    final m = await env.evidence.addMedia(
      roomId: kitchen.room.id,
      checklistItemId: kitchen.checklist.first.item.id,
      sourcePath: env.writeJpeg('k.jpg', width: 400, height: 300).path,
      kind: MediaKind.photo,
      source: MediaSource.camera,
    );
    final issue = await env.evidence.addIssue(
      kitchen.room.id,
      IssueInput(title: 'Chipped counter', mediaId: m.id),
    );
    await env.evidence.addAnnotation(
      mediaId: m.id,
      x: 0.4,
      y: 0.5,
      issueId: issue.id,
    );
    await env.inspections.complete(i.id);
    await env.reports.generate(i.id);
    final out = await env.inspections.create(
      propertyId: p.id,
      type: InspectionType.moveOut,
      baselineInspectionId: i.id,
    );
    final outRooms = await env.inspections.watchRoomProgress(out.id).first;
    return Seeded(i.id, kitchen.room.id, m.id, out.id, outRooms.first.room.id);
  });
  return result!;
}
