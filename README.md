# Move-In Record (codename RentProof)

A free, private Flutter app (Android + iOS) that helps renters record a rental's condition room by room. It produces a dated PDF condition report to send to the landlord, and compares move-in with move-out.

> **Start here:** [`RELEASE_REPORT.md`](RELEASE_REPORT.md) summarizes the whole project: decision, what was built, test and build status, and what needs a human.
>
> **Naming:** "RentProof" is only the internal codename. An iOS app called "Rentproof" already exists, so the provisional public name is **Move-In Record** (`lib/src/app_info.dart`). See [`docs/DECISIONS.md`](docs/DECISIONS.md) D-004.

## What it does
- Guided walkthrough: 10 room templates with short photo prompts; custom rooms and prompts; "not in this unit".
- Photos and videos from the camera, or imported through the system picker. Originals are stored **unchanged** in private app storage, with a **SHA-256** recorded and verified at save time, plus the app's own timestamp. EXIF values are shown as "not verified".
- Issues (type, severity, details, linked photo) and numbered markers on photos, stored as metadata. The photo itself is never altered.
- PDF report: cover, rooms, evidence cards with metadata, comparison, evidence index, limitations. Three visually distinct content types: original media / user notes / app metadata.
- "Send to landlord" through the share sheet, with the sent date recorded. An **evidence package** ZIP (originals + manifest + `SHA256SUMS.txt`) for backups.
- Move-out inspections copy the move-in rooms, and you compare them side by side with a manual verdict per room.
- No account, network code, analytics or ads. The Android release build requests no INTERNET permission (checked in CI).

## Repository layout
```
lib/                 Flutter app (see docs/engineering/TECHNICAL_PLAN.md)
test/                unit, migration, widget, accessibility and golden tests
drift_schemas/       database schema snapshots (migration safety)
docs/                research, product, engineering, business docs + PROJECT_STATE/DECISIONS
legal/               DRAFT privacy policy and terms (need legal review)
release/             store listing drafts, screenshot plan, store icons
landing/             static landing page (index.html, privacy.html)
tool/                helper scripts (icon generator)
.github/workflows/   CI (Linux: checks + Android build; macOS: tests + iOS no-codesign)
```

## Develop
Requires Flutter **3.47.5** (Dart 3.13).
```bash
flutter pub get
dart run build_runner build          # regenerate drift code after schema changes
flutter analyze
flutter test                         # all tests (goldens render on Linux)
flutter test --exclude-tags golden   # on macOS/Windows
flutter run                          # device or emulator
```
Build:
```bash
flutter build apk --release          # uses android/key.properties if present, else the debug key (do not distribute)
flutter build appbundle --release
flutter build ios --release --no-codesign   # macOS + Xcode
```
Release signing on Android: create `android/key.properties` with `storeFile`, `storePassword`, `keyAlias` and `keyPassword`. It is git-ignored.

## Changing the database schema
Bump `schemaVersion` in `lib/src/data/database.dart` and add an `onUpgrade` step. Then run `dart run drift_dev make-migrations` and `dart run drift_dev schema generate drift_schemas/app_database/ test/data/generated_schema/`, and add a migration test (see `test/data/migration_test.dart`).

## Key docs
| Topic | File |
|---|---|
| Current state & next action | docs/PROJECT_STATE.md |
| Decisions log | docs/DECISIONS.md |
| Evidence & research | docs/research/EVIDENCE_LEDGER.md, MARKET.md, COMPETITORS.md, RED_TEAM.md, LEGAL_CONTEXT.md |
| Product | docs/product/PRODUCT_STRATEGY.md, PRD.md, UX_SPEC.md, ANALYTICS.md, BRAND.md, BACKLOG.md |
| Engineering | docs/engineering/TECHNICAL_PLAN.md, SECURITY.md, PRIVACY_DATA_MAP.md, PERFORMANCE.md |
| Business | docs/business/MONETIZATION.md, GROWTH.md |
| Validation still needed | docs/research/VALIDATION_DEBT.md |

## Important limitations
This app is not legal advice. Timestamps come from the device clock. A SHA-256 shows that a stored file is unchanged since the app recorded it. It does not prove when, where or by whom a photo was taken, and it does not make a record admissible anywhere.
