import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rentproof/src/data/database.dart';
import 'package:rentproof/src/data/evidence_repository.dart';
import 'package:rentproof/src/services/media_picker.dart';
import 'package:rentproof/src/ui/app.dart';
import 'package:rentproof/src/ui/screens/home_screen.dart';
import 'package:rentproof/src/ui/screens/inspection_screen.dart';
import 'package:rentproof/src/ui/screens/issue_form_screen.dart';
import 'package:rentproof/src/ui/screens/report_screen.dart';
import 'package:rentproof/src/ui/screens/review_screen.dart';
import 'package:rentproof/src/ui/screens/room_screen.dart';

import 'harness.dart';

void main() {
  testWidgets('onboarding leads to the empty home screen', (tester) async {
    final ui = await createUiEnv(tester);
    await pumpScreen(tester, ui, const RentProofApp());
    expect(find.text('Record your place on move-in day'), findsOneWidget);
    for (var i = 0; i < 3; i++) {
      await tapAndSettle(tester, find.text('Next'));
    }
    expect(find.text('Private, and honest about limits'), findsOneWidget);
    await tapAndSettle(tester, find.text('Get started'));
    expect(find.text('Start with your place'), findsOneWidget);
    await disposeUi(tester, ui);
  });

  testWidgets('add a place: validation then save', (tester) async {
    final ui = await createUiEnv(tester);
    await pumpScreen(tester, ui, const HomeScreen());
    await tapAndSettle(tester, find.text('Add your place'));
    await tapAndSettle(tester, find.text('Save place'));
    expect(find.text('Please enter a name'), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Name for this place *'),
      'Maple St apartment',
    );
    await tapAndSettle(tester, find.text('Save place'));
    expect(find.text('Ready for your walkthrough?'), findsOneWidget);
    final saved = await tester.runAsync(
      () => ui.env.db.select(ui.env.db.properties).get(),
    );
    expect(saved!.single.nickname, 'Maple St apartment');
    await disposeUi(tester, ui);
  });

  testWidgets('start a move-in inspection with default rooms', (tester) async {
    final ui = await createUiEnv(tester);
    final property = await tester.runAsync(() => ui.env.property());
    await pumpScreen(tester, ui, const HomeScreen());
    await tapAndSettle(tester, find.text(property!.nickname));
    await tapAndSettle(tester, find.text('Start inspection'));
    expect(find.text('Move-in'), findsOneWidget);
    await tapAndSettle(tester, find.text('Start walkthrough'));
    expect(find.text('Move-in inspection'), findsOneWidget);
    expect(find.text('0 of 5 rooms done'), findsOneWidget);
    expect(find.text('Kitchen'), findsOneWidget);
    await disposeUi(tester, ui);
  });

  Future<(String inspectionId, String roomId)> seedInspection(
    UiEnv ui,
    WidgetTester tester,
  ) async {
    final result = await tester.runAsync(() async {
      final p = await ui.env.property();
      final i = await ui.env.inspections.create(
        propertyId: p.id,
        type: InspectionType.moveIn,
        roomTemplateKeys: const ['laundry', 'bathroom'],
      );
      final rooms = await ui.env.inspections.watchRoomProgress(i.id).first;
      return (i.id, rooms.first.room.id);
    });
    return result!;
  }

  testWidgets('capture a photo for a prompt', (tester) async {
    final ui = await createUiEnv(tester);
    final (_, roomId) = await seedInspection(ui, tester);
    await pumpScreen(tester, ui, RoomScreen(roomId: roomId));
    expect(find.text('Not documented'), findsNWidgets(4));
    await tapAndSettle(tester, find.bySemanticsLabel('Take photo of Overview'));
    await settle(tester);
    expect(find.text('1 added'), findsOneWidget);
    final media = await tester.runAsync(
      () => ui.env.db.select(ui.env.db.mediaEvidence).get(),
    );
    expect(media!.single.source, MediaSource.camera);
    expect(media.single.sha256, hasLength(64));
    await disposeUi(tester, ui);
  });

  testWidgets('camera permission denied shows guidance', (tester) async {
    final ui = await createUiEnv(tester);
    final (_, roomId) = await seedInspection(ui, tester);
    ui.picker.error = const MediaPermissionDeniedException(true);
    await pumpScreen(tester, ui, RoomScreen(roomId: roomId));
    await tapAndSettle(tester, find.bySemanticsLabel('Take photo of Overview'));
    expect(find.textContaining('Camera access is off'), findsOneWidget);
    await disposeUi(tester, ui);
  });

  testWidgets('import multiple photos and mark a prompt not applicable', (
    tester,
  ) async {
    final ui = await createUiEnv(tester);
    final (_, roomId) = await seedInspection(ui, tester);
    await pumpScreen(tester, ui, RoomScreen(roomId: roomId));
    await tapAndSettle(
      tester,
      find.byTooltip('More ways to add for Washer').first,
    );
    await tapAndSettle(tester, find.text('Import photos'));
    await settle(tester);
    expect(find.text('2 added'), findsOneWidget);

    await tapAndSettle(tester, find.byTooltip('More ways to add for Dryer'));
    await tapAndSettle(tester, find.text('Not in this unit'));
    expect(find.text('Not applicable'), findsOneWidget);
    await disposeUi(tester, ui);
  });

  testWidgets('add an issue with validation', (tester) async {
    final ui = await createUiEnv(tester);
    final (_, roomId) = await seedInspection(ui, tester);
    await pumpScreen(tester, ui, IssueFormScreen(roomId: roomId));
    await tapAndSettle(tester, find.text('Save issue'));
    expect(find.text('Please describe the issue briefly'), findsOneWidget);
    await tester.enterText(
      find.widgetWithText(TextFormField, 'What is the issue? *'),
      'Water stain on ceiling',
    );
    await tapAndSettle(tester, find.text('Major'));
    await tapAndSettle(tester, find.text('Save issue'));
    final issues = await tester.runAsync(
      () => ui.env.evidence.roomIssues(roomId),
    );
    expect(issues!.single.title, 'Water stain on ceiling');
    expect(issues.single.severity, IssueSeverity.major);
    await disposeUi(tester, ui);
  });

  testWidgets('finish is disabled without media', (tester) async {
    final ui = await createUiEnv(tester);
    final (inspectionId, _) = await seedInspection(ui, tester);
    await pumpScreen(tester, ui, ReviewScreen(inspectionId: inspectionId));
    expect(
      find.text('Add at least one photo or video before finishing.'),
      findsOneWidget,
    );
    final button = tester.widget<FilledButton>(
      find.ancestor(
        of: find.text('Finish & create report'),
        matching: find.bySubtype<FilledButton>(),
      ),
    );
    expect(button.onPressed, isNull);
    await disposeUi(tester, ui);
  });

  testWidgets('finish, generate report and send to landlord', (tester) async {
    final ui = await createUiEnv(tester);
    final (inspectionId, roomId) = await seedInspection(ui, tester);
    await tester.runAsync(() async {
      final m = await ui.env.evidence.addMedia(
        roomId: roomId,
        sourcePath: ui.env.writeJpeg('seed.jpg').path,
        kind: MediaKind.photo,
        source: MediaSource.camera,
      );
      await ui.env.evidence.addIssue(
        roomId,
        IssueInput(title: 'Dent in washer', mediaId: m.id),
      );
    });
    await pumpScreen(tester, ui, ReviewScreen(inspectionId: inspectionId));
    expect(find.text('Some prompts have no photo yet'), findsOneWidget);
    await tapAndSettle(tester, find.text('Finish & create report'));
    await settle(tester, rounds: 12);
    expect(find.byType(ReportScreen), findsOneWidget);
    expect(find.text('Latest report'), findsOneWidget);
    expect(find.text('Not sent to your landlord yet'), findsOneWidget);

    await tapAndSettle(tester, find.text('Send to landlord'));
    expect(
      ui.share.calls.single.subject,
      startsWith('Move-in condition report'),
    );
    expect(ui.share.calls.single.text, contains('SHA-256'));
    expect(File(ui.share.calls.single.paths.single).existsSync(), isTrue);
    await tapAndSettle(tester, find.text('Yes, I sent it'));
    expect(find.textContaining('You marked this as sent'), findsOneWidget);

    // Let the confirmation snackbar disappear first.
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
    expect(find.text('No backup exported yet'), findsOneWidget);
    await tapAndSettle(tester, find.text('Export evidence package'));
    await settle(tester);
    expect(ui.share.calls.last.paths.single, endsWith('_evidence.zip'));
    expect(find.textContaining('Backup exported on'), findsOneWidget);
    await disposeUi(tester, ui);
  });

  testWidgets('completed inspection is read-only in the room', (tester) async {
    final ui = await createUiEnv(tester);
    final (inspectionId, roomId) = await seedInspection(ui, tester);
    await tester.runAsync(() async {
      await ui.env.evidence.addMedia(
        roomId: roomId,
        sourcePath: ui.env.writeJpeg('seed.jpg').path,
        kind: MediaKind.photo,
        source: MediaSource.camera,
      );
      await ui.env.inspections.complete(inspectionId);
    });
    await pumpScreen(tester, ui, RoomScreen(roomId: roomId));
    expect(find.textContaining('This inspection is finished'), findsOneWidget);
    expect(find.text('Take photo'), findsNothing);
    expect(find.text('Add issue'), findsNothing);

    await pumpScreen(tester, ui, InspectionScreen(inspectionId: inspectionId));
    expect(find.text('Report & share'), findsOneWidget);
    await disposeUi(tester, ui);
  });
}
