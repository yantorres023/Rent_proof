# PRD: Move-In Record V1 (codename RentProof)

_Version 1.0.0 · 2026-09-25 · Status: implemented (see "Implementation status" column)._

## 1. Vision
Every renter can leave move-in day with an organized, dated record of the home's condition that they control, have shared with their landlord, and can compare against at move-out, without paying, creating an account, or trusting a cloud service.

## 2. Non-goals (V1)
- Landlord or property-manager features, multi-user collaboration, or a landlord portal.
- Cloud sync, accounts, or a server of any kind.
- Automatic damage detection or AI descriptions.
- State-specific legal deadlines or reminders (D-006).
- Payments or in-app purchases (D-005).
- Legal advice, dispute letters, or court filing help.
- In-app video playback. Videos are stored, hashed and exported, but not played back in the app.

## 3. ICP and JTBD
See PRODUCT_STRATEGY.md §2–3. US renters aged 18–34 at move-in and move-out.

## 4. MVP scope and user stories

| ID | User story | Acceptance criteria | Status |
|---|---|---|---|
| US-01 | As a first-time user, I understand what the app does and what it can't prove | 4-page onboarding; the last page states the limits (device time, hash meaning, not legal advice); Skip is available; shown once | Done |
| US-02 | I can add the place I'm moving into | Name required (1–120 chars, trimmed); address/landlord optional; validation message; saved locally | Done |
| US-03 | I can start a move-in inspection with sensible default rooms | Types: move-in, move-out, routine, maintenance. Default rooms: entry, living, kitchen, bedroom, bathroom. Rooms selectable from 10 templates | Done |
| US-04 | I'm guided room by room with short prompts | Each room has 3–10 prompts; each prompt shows Not documented / N added / Not applicable with icon and text; "Take photo" per prompt | Done |
| US-05 | I can add photos from the camera or import existing ones | Camera capture; multi-select import via the system picker; per-file failure messages; progress indicator; no broad storage permission on Android | Done |
| US-06 | I can record or import a short video | Video capture up to 2 minutes; import; stored and hashed; placeholder in UI and PDF | Done (no playback) |
| US-07 | Originals are preserved unchanged | Original copied byte-for-byte to private storage; stored copy re-hashed and verified; derived preview/thumbnail created separately without EXIF | Done |
| US-08 | Each original has a SHA-256 fingerprint and app timestamp | Hash recorded at storage; app timestamp recorded when received; EXIF date/device stored separately and labeled "not verified"; GPS presence flagged, coordinates never stored | Done |
| US-09 | I can check that stored files haven't changed | Per-file and per-inspection check; results (match/mismatch/missing) kept in history | Done |
| US-10 | I can record issues | Title (required), type (9 categories), severity (minor/moderate/major), details, optional linked photo from the same room; edit/delete | Done |
| US-11 | I can mark the exact spot on a photo | Tap to place a numbered marker with an optional label or linked issue; stored as normalized coordinates (metadata only); the photo is never altered | Done |
| US-12 | I can add rooms, custom prompts and notes | Add template or custom room; duplicate names get " 2"; rename; delete with confirmation; room notes; custom prompts | Done |
| US-13 | I can finish an inspection honestly | Review lists undocumented prompts; finishing requires ≥1 media; after finishing, evidence is locked until reopened | Done |
| US-14 | I get a useful PDF report | Cover (property, type, dates, report ID, counts, legend), room pages (checklist, notes, issues, photo cards with markers and metadata), comparison section (if baseline), evidence index with hashes, limitations page; distinct styles for ORIGINAL MEDIA RECORD / USER NOTES / APP-GENERATED METADATA; PDF SHA-256 recorded | Done |
| US-15 | I can send the report to my landlord and remember I did | "Send to landlord" opens the share sheet with a prefilled subject and message including the report fingerprint; asks "Did you send it?" and records the date | Done |
| US-16 | I can back up everything | Evidence package ZIP: originals (unchanged), report.pdf, manifest.json, SHA256SUMS.txt, README with verification commands; missing originals listed | Done |
| US-17 | I can see my history per place | Place screen lists inspections with type, dates, status and counts | Done |
| US-18 | At move-out I can compare against move-in | Move-out defaults to the latest completed move-in as baseline; rooms and prompts copied and linked; side-by-side per prompt; issues on both sides; manual verdict (no change / changed / new issue) and note; included in the PDF | Done |
| US-19 | I control and can delete my data | Delete photo, issue, room, inspection, place, report; "Delete all data" with typed confirmation; storage usage shown | Done |
| US-20 | Media captured just before Android killed the app is not lost | Pending capture target saved before opening the camera; recovered at next launch into the same room/prompt | Done (untested on device) |

## 5. Data model
See engineering/TECHNICAL_PLAN.md §4. Tables: UserProfiles, AppSettings, Properties, Inspections, Rooms, ChecklistItems, MediaEvidence, EvidenceHashes, Issues, Annotations, Reports, RoomComparisons. The schema is versioned (v1 snapshot in `drift_schemas/`).

## 6. Security
engineering/SECURITY.md: private app storage, generated file names, allow-listed extensions, path containment checks, no logging of content or paths, no network permission in the Android release build.

## 7. Privacy
engineering/PRIVACY_DATA_MAP.md and legal/PRIVACY_POLICY.md (draft). No account, analytics, crash reporting or ads. Nothing leaves the device unless the user shares or exports it. On Android, app data is excluded from cloud backup. On iOS, device backups may include it.

## 8. Analytics
ANALYTICS.md defines the taxonomy. **No analytics SDK is included and no events are transmitted in V1.** Validation will use opt-in beta instrumentation or interviews (VALIDATION_DEBT.md).

## 9. Error handling
- Every repository call from the UI goes through `runGuarded`, which maps exceptions to plain-language messages without paths or stack traces (`describeError`).
- Permission denied → guidance to Settings, or import instead. No camera → suggest import.
- Out of space (ENOSPC) → "Nothing was saved"; partial files are removed.
- Source missing, empty or unreadable → specific message; nothing is stored.
- Hash verification fails right after copy → the file is rejected.
- Corrupted or undecodable photos (e.g. HEIC in some cases) → the original is kept and hashed; the UI and PDF show a "preview unavailable" placeholder.
- A database insert failure after the copy → stored files are deleted (no orphans).
- A missing report file → shown on the report screen with a "create a new version" path.

## 10. Accessibility
Minimum 48 dp tap targets, semantic labels on all icon buttons and thumbnails, status always shown with icon + text, headers marked for screen readers, layout checked at 200% text scale, contrast checked with Flutter's guideline matchers, and animations skipped when reduce-motion is on (onboarding). See UX_SPEC.md §8.

## 11. Performance
engineering/PERFORMANCE.md. Hashing, preview generation and PDF building run off the UI isolate. Thumbnails are decoded at display size. Measured on the Linux CI container: 60-photo / 12-room report built in about 0.4 s (2.8 MB); photo processing about 0.9 s per 6 MP image.

## 12. Release requirements
- `dart format`, `flutter analyze` and `flutter test` pass (CI).
- Android APK/AAB build in CI; release APK has no INTERNET, CAMERA, storage or location permission (CI audit).
- iOS build with `--no-codesign` in macOS CI.
- Store metadata drafts in /release. Final name, IDs, signing, privacy labels and policy verification are HUMAN_ACTION items (RELEASE_REPORT.md).

## 13. Future features
See BACKLOG.md.

## 14. UNVALIDATED_WITH_REAL_USERS assumptions
- Renters will complete a room-by-room walkthrough on move-in day (V-01, V-02).
- The default prompts are the right size (not too many, not too few) (V-03).
- The PDF is perceived as valuable and trustworthy, and the wording feels honest rather than weak (V-04).
- Renters will send the report to their landlord (V-07).
- Renters will export a backup and keep the app until move-out (V-05).
- Renters will pay at move-out (V-06).
- Intermediaries will link to the app (V-08).
