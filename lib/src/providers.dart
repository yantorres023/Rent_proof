import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/database.dart';
import 'data/evidence_repository.dart';
import 'data/inspection_repository.dart';
import 'data/property_repository.dart';
import 'data/settings_repository.dart';
import 'report/pdf_report_builder.dart';
import 'report/report_repository.dart';
import 'services/clock.dart';
import 'services/media_picker.dart';
import 'services/platform_preview.dart';
import 'services/share_service.dart';
import 'services/storage_paths.dart';

// Infrastructure. The database and storage paths are provided by main() (or
// by tests) through ProviderScope overrides.

final databaseProvider = Provider<AppDatabase>(
  (ref) => throw UnimplementedError('databaseProvider must be overridden'),
);

final storagePathsProvider = Provider<StoragePaths>(
  (ref) => throw UnimplementedError('storagePathsProvider must be overridden'),
);

final clockProvider = Provider<Clock>((ref) => const SystemClock());

final mediaPickerProvider = Provider<MediaPicker>(
  (ref) => ImagePickerMediaPicker(),
);

final shareServiceProvider = Provider<ShareService>(
  (ref) => const SystemShareService(),
);

final mediaProcessorProvider = Provider<MediaProcessor>(
  (ref) => processMediaInIsolate,
);

final platformDecoderProvider = Provider<PlatformDecoder?>(
  (ref) => decodeWithPlatform,
);

final pdfRunnerProvider = Provider<PdfRunner>((ref) => buildPdfInIsolate);

Future<ReportFonts> loadBundledFonts() async => ReportFonts(
  regular: await rootBundle.load('assets/fonts/Roboto-Regular.ttf'),
  bold: await rootBundle.load('assets/fonts/Roboto-Bold.ttf'),
  italic: await rootBundle.load('assets/fonts/Roboto-Italic.ttf'),
);

final fontLoaderProvider = Provider<ReportFontLoader>(
  (ref) => loadBundledFonts,
);

// Repositories

final propertyRepositoryProvider = Provider(
  (ref) => PropertyRepository(
    ref.watch(databaseProvider),
    ref.watch(storagePathsProvider),
    clock: ref.watch(clockProvider),
  ),
);

final inspectionRepositoryProvider = Provider(
  (ref) => InspectionRepository(
    ref.watch(databaseProvider),
    ref.watch(storagePathsProvider),
    clock: ref.watch(clockProvider),
  ),
);

final evidenceRepositoryProvider = Provider(
  (ref) => EvidenceRepository(
    ref.watch(databaseProvider),
    ref.watch(storagePathsProvider),
    clock: ref.watch(clockProvider),
    processor: ref.watch(mediaProcessorProvider),
    platformDecoder: ref.watch(platformDecoderProvider),
  ),
);

final reportRepositoryProvider = Provider(
  (ref) => ReportRepository(
    ref.watch(databaseProvider),
    ref.watch(storagePathsProvider),
    clock: ref.watch(clockProvider),
    fonts: ref.watch(fontLoaderProvider),
    runner: ref.watch(pdfRunnerProvider),
  ),
);

final settingsRepositoryProvider = Provider(
  (ref) => SettingsRepository(
    ref.watch(databaseProvider),
    ref.watch(storagePathsProvider),
    clock: ref.watch(clockProvider),
  ),
);

// Reactive queries

final onboardingCompletedProvider = StreamProvider.autoDispose<bool>(
  (ref) => ref.watch(settingsRepositoryProvider).watchOnboardingCompleted(),
);

final profileProvider = StreamProvider.autoDispose<UserProfile?>(
  (ref) => ref.watch(settingsRepositoryProvider).watchProfile(),
);

final propertySummariesProvider =
    StreamProvider.autoDispose<List<PropertySummary>>(
      (ref) => ref.watch(propertyRepositoryProvider).watchSummaries(),
    );

final propertyProvider = StreamProvider.autoDispose.family<Property?, String>(
  (ref, id) => ref.watch(propertyRepositoryProvider).watch(id),
);

final inspectionSummariesProvider = StreamProvider.autoDispose
    .family<List<InspectionSummary>, String>(
      (ref, propertyId) =>
          ref.watch(inspectionRepositoryProvider).watchSummaries(propertyId),
    );

final inspectionProvider = StreamProvider.autoDispose
    .family<Inspection?, String>(
      (ref, id) => ref.watch(inspectionRepositoryProvider).watchInspection(id),
    );

final roomProgressListProvider = StreamProvider.autoDispose
    .family<List<RoomProgress>, String>(
      (ref, inspectionId) => ref
          .watch(inspectionRepositoryProvider)
          .watchRoomProgress(inspectionId),
    );

final roomProvider = StreamProvider.autoDispose.family<RoomProgress?, String>(
  (ref, roomId) => ref.watch(inspectionRepositoryProvider).watchRoom(roomId),
);

final roomMediaProvider = StreamProvider.autoDispose
    .family<List<MediaItem>, String>(
      (ref, roomId) =>
          ref.watch(evidenceRepositoryProvider).watchRoomMedia(roomId),
    );

final roomIssuesProvider = StreamProvider.autoDispose
    .family<List<Issue>, String>(
      (ref, roomId) =>
          ref.watch(evidenceRepositoryProvider).watchRoomIssues(roomId),
    );

final mediaProvider = StreamProvider.autoDispose.family<MediaItem?, String>(
  (ref, id) => ref.watch(evidenceRepositoryProvider).watchMedia(id),
);

final annotationsProvider = StreamProvider.autoDispose
    .family<List<Annotation>, String>(
      (ref, mediaId) =>
          ref.watch(evidenceRepositoryProvider).watchAnnotations(mediaId),
    );

final hashHistoryProvider = StreamProvider.autoDispose
    .family<List<EvidenceHash>, String>(
      (ref, mediaId) =>
          ref.watch(evidenceRepositoryProvider).watchHashHistory(mediaId),
    );

final reportsProvider = StreamProvider.autoDispose.family<List<Report>, String>(
  (ref, inspectionId) =>
      ref.watch(reportRepositoryProvider).watchReports(inspectionId),
);

final comparisonProvider = StreamProvider.autoDispose
    .family<RoomComparison?, String>(
      (ref, roomId) =>
          ref.watch(inspectionRepositoryProvider).watchComparison(roomId),
    );
