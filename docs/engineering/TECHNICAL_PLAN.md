# Technical Plan (as built)

_2026-09-25 · Flutter 3.47.5 / Dart 3.13.4 · Android + iOS._

## 1. Architecture overview
```
lib/
  main.dart                  bootstrap: storage paths, DB, ProviderScope
  src/app_info.dart          version + provisional public name
  src/providers.dart         Riverpod providers (infrastructure, repos, streams)
  src/data/                  drift schema, repositories (single source of truth)
    database.dart (+ .g.dart) enums.dart
    property_repository.dart inspection_repository.dart
    evidence_repository.dart settings_repository.dart
  src/services/              platform-independent services + platform adapters
    media_processing.dart    copy → SHA-256 → verify → previews/EXIF (isolate)
    storage_paths.dart       private directories, path containment
    safe_paths.dart          extension allow-list, name sanitizing
    room_templates.dart      guided prompts
    media_picker.dart        image_picker adapter (interface + impl)
    share_service.dart       share_plus adapter (interface + impl)
    clock.dart               injectable clock + UUIDs
  src/report/                snapshot → PDF, evidence package
    report_models.dart snapshot_loader.dart pdf_report_builder.dart
    report_repository.dart
  src/ui/                    screens, widgets, theme, capture flow
```
Layers: **UI → providers → repositories → drift/services.** There is no separate domain layer. Drift's generated data classes are the domain objects, which avoids a mirror hierarchy. Chosen for maintainability over abstraction.

## 2. State management: Riverpod 3 (no code generation)
- `Provider` for infrastructure and repositories. `databaseProvider` and `storagePathsProvider` are overridden in `main()` and in tests.
- `StreamProvider.autoDispose(.family)` wraps drift `watch()` queries, so screens update reactively when data changes anywhere.
- Automatic provider retry is disabled (`ProviderScope(retry: (_, _) => null)`) because database errors aren't transient.
- Platform integrations (picker, share, media processor, PDF runner, fonts) are providers, so tests swap them for fakes or in-process versions.
- Alternatives considered: Provider/ChangeNotifier (less ergonomic for parameterized streams), BLoC (more boilerplate), and Riverpod codegen (extra build step). See DECISIONS D-009.

## 3. Navigation
Imperative `Navigator` with `MaterialPageRoute`. The app is a shallow, linear stack, and deep links aren't needed in V1. `pushReplacement` is used where Back should skip a step (new inspection → inspection, review → report).

## 4. Database (drift + SQLite)
- Opened with `drift_flutter` (`driftDatabase(name: 'rentproof_v1')`) in the app's support directory. Queries run on a background isolate (drift_flutter default).
- `PRAGMA foreign_keys = ON` and `PRAGMA secure_delete = ON` on every open.
- DateTimes are stored as ISO-8601 text with offset (`store_date_time_values_as_text`), which keeps millisecond precision and is readable in exports. Aggregates over text timestamps are converted back to local time.
- **Schema v1:**

| Table | Key columns | Relations |
|---|---|---|
| user_profiles | id=1, display_name, email | – |
| app_settings | key, value | – |
| properties | id, nickname, address…, landlord_name | 1:N inspections (cascade) |
| inspections | id, property_id, type, status, baseline_inspection_id, started_at, completed_at, last_package_export_at | 1:N rooms (cascade); baseline → inspections (set null) |
| rooms | id, inspection_id, name, template_key, position, status, baseline_room_id | 1:N checklist_items, media, issues (cascade) |
| checklist_items | id, room_id, label, position, not_applicable | media.checklist_item_id (set null) |
| media_evidence | id, room_id, kind, source, original_path, preview_path, thumbnail_path, sha256, byte_size, recorded_at, exif_*, original_has_gps, width, height, caption | 1:N evidence_hashes, annotations (cascade); issues.media_id (set null) |
| evidence_hashes | id, media_id, algorithm, hex_digest, purpose (import/verification), result (recorded/match/mismatch/missing), computed_at | – |
| issues | id, room_id, media_id?, title, description, category, severity | annotations.issue_id (cascade) |
| annotations | id, media_id, issue_id?, x, y (0..1), label | – |
| reports | id, inspection_id, file_path, sha256, byte_size, counts, includes_comparison, generated_at, sent_to_landlord_at | – |
| room_comparisons | id, room_id (unique), verdict, note | – |

- **Migrations:** `schemaVersion = 1`. The snapshot is in `drift_schemas/app_database/drift_schema_v1.json`, with generated helpers in `test/data/generated_schema/`. `test/data/migration_test.dart` fails if the schema changes without a new snapshot. The procedure for v2 is documented in that test.
- Enums are stored by name (`textEnum`). Renaming a value requires a migration.

## 5. Media storage
```
<ApplicationSupport>/evidence/<inspectionId>/originals/<mediaId>.<ext>
<ApplicationSupport>/evidence/<inspectionId>/derived/<mediaId>_preview.jpg   (≤1600 px, q82, no EXIF)
<ApplicationSupport>/evidence/<inspectionId>/derived/<mediaId>_thumb.jpg     (≤360 px, q75, no EXIF)
<ApplicationSupport>/reports/<inspectionId>/<reportId>.pdf
<Temp>/rentproof_exports/…   (share/export copies; cleared on each launch)
```
- File names come only from UUIDs and an allow-listed extension. User or OS-supplied names are only displayed, after sanitizing (`safe_paths.dart`). Every stored relative path is resolved with `resolveWithin`, which rejects absolute paths and `..`.
- **Originals are never modified.** Orientation is applied to derived copies only. Annotations are rows, never pixels.
- Photos larger than 40 MB are stored and hashed but get no preview (memory bound).

## 6. Hashing
- `processMedia` streams the source into the destination while feeding SHA-256 in chunks. It then re-reads the stored copy and compares. A mismatch deletes the copy and fails (`verify_failed`).
- The digest (lowercase hex) is stored on `media_evidence.sha256`, with an `evidence_hashes` row (`purpose=import, result=recorded`).
- Verification re-hashes on an isolate and appends `match` / `mismatch` / `missing`.
- The report PDF's own SHA-256 is recorded in `reports.sha256` and included in the "send to landlord" message.
- **What the hash means:** the stored file is bit-identical to what the app received. It does **not** establish capture time, author, scene authenticity or admissibility (LEGAL_CONTEXT.md). On iOS and Android the picker or camera may hand the app a re-encoded copy, so the hash covers the file *as received by the app*.

## 7. Metadata
The app's own timestamp (`recorded_at`, device clock with offset) is recorded when the file is received. EXIF `DateTimeOriginal`, Make and Model are read from JPEGs and stored separately, labeled "not verified" everywhere. GPS presence is recorded as a boolean; coordinates are never read into the database or reports.

## 8. PDF generation
- `pdf` package (pure Dart), fonts bundled from Roboto (Apache-2.0), Courier for hashes. Runs in `Isolate.run`.
- Input is an isolate-sendable `ReportInput` snapshot (drift data classes + absolute preview paths).
- Unsupported glyphs (e.g. emoji) are replaced with `?` by `pdfSafe` so text never silently disappears.
- Sections: cover (metadata, legend, room summary) → one page per room (checklist status, notes, issues, 2-up evidence cards with markers and metadata) → comparison (if baseline) → evidence index → limitations.

## 9. Evidence package
A ZIP (archive package, streaming `ZipFileEncoder`) containing `originals/E-###_<room>.<ext>` (stored uncompressed, byte-identical), `report.pdf`, `manifest.json` (format `rentproof-evidence-package` v1), `SHA256SUMS.txt` (`shasum -c` compatible) and `README.txt`. Missing originals are listed in the manifest.

## 10. Permissions
- **Android:** no dangerous permissions. Capture uses the system camera app via intent (no CAMERA permission declared). Import uses the Android photo picker (no READ_MEDIA_*). The release build has no INTERNET permission (Flutter adds it only to debug/profile manifests); CI audits the release APK.
- **iOS:** NSCameraUsageDescription, NSMicrophoneUsageDescription (video with sound), NSPhotoLibraryUsageDescription, all requested just in time by the OS. `PrivacyInfo.xcprivacy`: no tracking, no collected data, FileTimestamp reason C617.1.
- **Process death during capture (Android):** the target room/prompt is persisted before launching the camera. `retrieveLostData()` on the next launch stores the media there.

## 11. Localization readiness
- `flutter_localizations` delegates are wired up, dates use `intl`'s locale-aware `DateFormat`, and supported locales are `en_US`.
- UI strings are inline English in widgets. The legal/limitations copy is centralized (`reportLimitations`) and shared by the app and the PDF.
- Before adding a second locale, extract strings to ARB with gen-l10n (BACKLOG B-09, DECISIONS D-007).

## 12. Testing strategy
| Level | Location | What |
|---|---|---|
| Unit | test/services, test/data, test/report | paths/sanitizing, hashing & processing, repositories (validation, locking, cascade deletes, baseline copy), PDF generation, evidence package integrity, performance smoke test |
| Migration | test/data/migration_test.dart | v1 schema snapshot, FK enforcement |
| Widget | test/ui/flow_test.dart | onboarding, add place, start inspection, capture, permission denied, import + N/A, issue validation, finish gating, finish → report → send → mark sent → export, read-only lock |
| Accessibility | test/ui/accessibility_test.dart | tap targets, labels, contrast on 9 screens; 200% text scale with no overflow |
| Golden | test/ui/golden_test.dart (tag `golden`) | 6 screens rendered with real fonts (Linux only) |
Fakes: `FakeMediaPicker` and `FakeShareService`. IO runs through `tester.runAsync`. No integration_test/device tests (no emulator in this environment).

## 13. CI
- `.github/workflows/ci.yml` (ubuntu): pub get → generated code is current → format → analyze → test → build APK + AAB (release, debug-signed) → permission audit with `aapt2` → upload artifacts.
- `.github/workflows/ios.yml` (macos): test (goldens excluded) → `flutter build ios --release --no-codesign` → upload the unsigned Runner.app.

## 14. Release builds
- **Android:** `android/key.properties` (untracked) enables release signing. Without it, release builds use the debug key and must never be uploaded. `versionCode`/`versionName` come from pubspec `version: 1.0.0+1`.
- **iOS:** requires the owner's Apple Developer team, bundle ID and provisioning. The provisional bundle ID is `app.moveinrecord.mobile`.

## 15. Dependencies (direct)
| Package | Why |
|---|---|
| drift, drift_flutter (+ drift_dev, build_runner) | typed SQLite, migrations, reactive queries |
| flutter_riverpod | state/DI |
| image_picker | camera + system photo picker, lost-data recovery |
| image | EXIF, orientation, previews (pure Dart) |
| crypto | SHA-256 streaming |
| pdf | report generation |
| archive | ZIP evidence package |
| share_plus | system share sheet |
| path_provider, path | directories and path handling |
| intl, flutter_localizations | dates, l10n readiness |
| uuid | IDs |
No analytics, crash reporting, ads, networking or AI SDKs.
