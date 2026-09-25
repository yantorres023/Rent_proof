import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:rentproof/src/data/database.dart';
import 'package:rentproof/src/providers.dart';
import 'package:rentproof/src/report/pdf_report_builder.dart';
import 'package:rentproof/src/services/media_picker.dart';
import 'package:rentproof/src/services/media_processing.dart';
import 'package:rentproof/src/services/share_service.dart';
import 'package:rentproof/src/ui/theme.dart';

import '../helpers.dart';

class FakeMediaPicker implements MediaPicker {
  FakeMediaPicker(this.env);

  final TestEnv env;
  Object? error;
  int _n = 0;
  List<PickedMedia> lost = const [];

  PickedMedia _photo(MediaSource source) {
    _n++;
    final f = env.writeJpeg('picked_$_n.jpg', width: 120, height: 90);
    return PickedMedia(
      path: f.path,
      name: 'IMG_$_n.jpg',
      kind: MediaKind.photo,
      source: source,
    );
  }

  @override
  Future<PickedMedia?> capturePhoto() async {
    if (error != null) throw error!;
    return _photo(MediaSource.camera);
  }

  @override
  Future<PickedMedia?> captureVideo() async {
    if (error != null) throw error!;
    _n++;
    final f = env.writeBytes('video_$_n.mp4', List.filled(1024, 1));
    return PickedMedia(
      path: f.path,
      name: 'VID_$_n.mp4',
      kind: MediaKind.video,
      source: MediaSource.camera,
    );
  }

  @override
  Future<List<PickedMedia>> importPhotos() async {
    if (error != null) throw error!;
    return [_photo(MediaSource.import), _photo(MediaSource.import)];
  }

  @override
  Future<PickedMedia?> importVideo() async => null;

  @override
  Future<List<PickedMedia>> retrieveLost() async => lost;
}

class FakeShareService implements ShareService {
  final List<({List<String> paths, String? subject, String? text})> calls = [];

  @override
  Future<ShareOutcome> shareFiles(
    List<String> paths, {
    String? subject,
    String? text,
  }) async {
    calls.add((paths: paths, subject: subject, text: text));
    return ShareOutcome.shared;
  }
}

class UiEnv {
  UiEnv(this.env) : picker = FakeMediaPicker(env);

  final TestEnv env;
  final FakeMediaPicker picker;
  final share = FakeShareService();

  List<Override> get overrides => [
    databaseProvider.overrideWithValue(env.db),
    storagePathsProvider.overrideWithValue(env.paths),
    clockProvider.overrideWithValue(env.clock),
    mediaPickerProvider.overrideWithValue(picker),
    shareServiceProvider.overrideWithValue(share),
    mediaProcessorProvider.overrideWithValue(processMedia),
    pdfRunnerProvider.overrideWithValue(
      (input, fonts) => buildReportPdf(input, fonts),
    ),
    fontLoaderProvider.overrideWithValue(loadTestFonts),
  ];
}

/// Creates a test environment whose async IO runs outside fake time.
Future<UiEnv> createUiEnv(WidgetTester tester) async {
  final env = await tester.runAsync(TestEnv.create);
  return UiEnv(env!);
}

Future<void> pumpScreen(
  WidgetTester tester,
  UiEnv ui,
  Widget screen, {
  double textScale = 1,
  Size size = const Size(400, 860),
}) async {
  tester.view.physicalSize = size * 2;
  tester.view.devicePixelRatio = 2;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      overrides: ui.overrides,
      retry: (_, _) => null,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: buildTheme(Brightness.light),
        home: MediaQuery.withClampedTextScaling(
          minScaleFactor: textScale,
          maxScaleFactor: textScale,
          child: screen,
        ),
      ),
    ),
  );
  await settle(tester);
}

/// Pumps while letting real IO (files, database, PDF) complete. Waits until
/// no progress indicator is visible, then settles animations.
Future<void> settle(WidgetTester tester, {int rounds = 4}) async {
  final busy = find.byWidgetPredicate(
    (w) => w is ProgressIndicator && w.value == null,
  );
  for (var i = 0; i < 400; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 15)),
    );
    await tester.pump(const Duration(milliseconds: 16));
    if (i >= rounds && busy.evaluate().isEmpty) break;
  }
  await tester.pumpAndSettle();
}

/// Taps and waits for resulting IO to finish.
Future<void> tapAndSettle(WidgetTester tester, Finder finder) async {
  if (finder.evaluate().isEmpty) {
    // Lazily built list items: scroll the main list until built.
    await tester.scrollUntilVisible(
      finder,
      200,
      scrollable: find.byType(Scrollable).first,
    );
  }
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await settle(tester);
}

Future<void> disposeUi(WidgetTester tester, UiEnv ui) async {
  await tester.pumpWidget(const SizedBox());
  await tester.pump(const Duration(seconds: 1));
  await tester.runAsync(ui.env.dispose);
}
