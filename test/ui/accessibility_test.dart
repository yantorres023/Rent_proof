import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rentproof/src/ui/screens/comparison_screen.dart';
import 'package:rentproof/src/ui/screens/home_screen.dart';
import 'package:rentproof/src/ui/screens/inspection_screen.dart';
import 'package:rentproof/src/ui/screens/media_screen.dart';
import 'package:rentproof/src/ui/screens/onboarding_screen.dart';
import 'package:rentproof/src/ui/screens/report_screen.dart';
import 'package:rentproof/src/ui/screens/room_screen.dart';
import 'package:rentproof/src/ui/screens/settings_screen.dart';

import 'harness.dart';
import 'seed.dart';

Future<void> expectAccessible(WidgetTester tester) async {
  final handle = tester.ensureSemantics();
  await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
  await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
  await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
  await expectLater(tester, meetsGuideline(textContrastGuideline));
  handle.dispose();
}

void main() {
  final screens = <String, Widget Function(Seeded s)>{
    'onboarding': (_) => const OnboardingScreen(),
    'home': (_) => const HomeScreen(),
    'inspection': (s) => InspectionScreen(inspectionId: s.inspectionId),
    'move-out inspection': (s) => InspectionScreen(inspectionId: s.moveOutId),
    'room (read-only)': (s) => RoomScreen(roomId: s.roomId),
    'media': (s) => MediaScreen(mediaId: s.mediaId),
    'report': (s) => ReportScreen(inspectionId: s.inspectionId),
    'comparison': (s) => ComparisonScreen(inspectionId: s.moveOutId),
    'settings': (_) => const SettingsScreen(),
  };

  for (final entry in screens.entries) {
    testWidgets(
      '${entry.key} meets tap target, label and contrast guidelines',
      (tester) async {
        final ui = await createUiEnv(tester);
        final s = await seed(ui, tester);
        await pumpScreen(tester, ui, entry.value(s));
        await expectAccessible(tester);
        await disposeUi(tester, ui);
      },
    );

    testWidgets('${entry.key} has no overflow at 200% text size', (
      tester,
    ) async {
      final ui = await createUiEnv(tester);
      final s = await seed(ui, tester);
      await pumpScreen(
        tester,
        ui,
        entry.value(s),
        textScale: 2,
        size: const Size(360, 740),
      );
      expect(tester.takeException(), isNull);
      await disposeUi(tester, ui);
    });
  }

  testWidgets('editable room has labeled capture buttons', (tester) async {
    final ui = await createUiEnv(tester);
    final s = await seed(ui, tester);
    await pumpScreen(tester, ui, RoomScreen(roomId: s.moveOutRoomId));
    expect(find.bySemanticsLabel('Take photo of Overview'), findsOneWidget);
    await expectAccessible(tester);
    await disposeUi(tester, ui);
  });
}
