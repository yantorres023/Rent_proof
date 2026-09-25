@Tags(['golden'])
library;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rentproof/src/ui/screens/home_screen.dart';
import 'package:rentproof/src/ui/screens/inspection_screen.dart';
import 'package:rentproof/src/ui/screens/issue_form_screen.dart';
import 'package:rentproof/src/ui/screens/media_screen.dart';
import 'package:rentproof/src/ui/screens/report_screen.dart';
import 'package:rentproof/src/ui/screens/room_screen.dart';

import 'harness.dart';
import 'seed.dart';

/// Loads real fonts so goldens are readable. Golden images are generated on
/// Linux; font rasterization differs on other OSes, so CI runs goldens on
/// Linux only (see dart_test.yaml / workflows). Goldens do not replace
/// visual QA on real devices.
Future<void> loadFonts() async {
  Future<ByteData> read(String path) async =>
      ByteData.sublistView(Uint8List.fromList(await File(path).readAsBytes()));
  final roboto = FontLoader('Roboto')
    ..addFont(read('assets/fonts/Roboto-Regular.ttf'))
    ..addFont(read('assets/fonts/Roboto-Bold.ttf'));
  await roboto.load();
  final root = Platform.environment['FLUTTER_ROOT'];
  if (root != null) {
    final icons = File(
      '$root/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf',
    );
    if (icons.existsSync()) {
      await (FontLoader('MaterialIcons')..addFont(read(icons.path))).load();
    }
  }
}

void main() {
  setUpAll(loadFonts);

  final cases = <String, Widget Function(Seeded s)>{
    'home': (_) => const HomeScreen(),
    'inspection': (s) => InspectionScreen(inspectionId: s.inspectionId),
    'room_move_out': (s) => RoomScreen(roomId: s.moveOutRoomId),
    'media': (s) => MediaScreen(mediaId: s.mediaId),
    'issue_form': (s) => IssueFormScreen(roomId: s.roomId),
    'report': (s) => ReportScreen(inspectionId: s.inspectionId),
  };

  for (final entry in cases.entries) {
    testWidgets('golden ${entry.key}', (tester) async {
      final ui = await createUiEnv(tester);
      final s = await seed(ui, tester);
      await pumpScreen(tester, ui, entry.value(s));
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/${entry.key}.png'),
      );
      await disposeUi(tester, ui);
    });
  }
}
