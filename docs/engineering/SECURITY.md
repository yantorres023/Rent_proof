# Security Review

_2026-09-25 · Reviewer: autonomous QA/security pass over the V1 codebase. This is not a third-party audit and no penetration test was done._

## Threat model (V1)
- **Assets:** photos and videos of the user's home; notes; address and landlord name; report PDFs.
- **Actors considered:**
  - Someone else who gets the unlocked phone.
  - A malicious or odd file name coming from the picker.
  - Other apps on the device.
  - Accidental leaks through logs, backups, caches or shares.
  - A curious recipient of an export.
- **Out of scope:** a rooted or jailbroken device, OS compromise, forensic recovery of flash storage.
- **No network surface.** The app has no server, no network code, and no INTERNET permission in the Android release build.

## Findings and status

| # | Area | Finding | Status |
|---|---|---|---|
| S-01 | File access | All evidence and reports live in the app's private support directory; nothing is written to shared storage or the gallery | OK (by design) |
| S-02 | Path traversal | Stored names are `UUID + allow-listed extension`. Every relative path from the DB is resolved with `resolveWithin` (rejects absolute and `..`). Tests: `safe_paths_test`, `evidence_repository_test` ("traversal in the source name…") | OK |
| S-03 | Unsafe filenames | Picker-supplied names are display-only, stripped of directories, control characters and reserved characters, and capped at 100 chars. Export names use slugged `[a-z0-9-]` | OK |
| S-04 | Permission handling | Android declares no dangerous permissions (system camera app + photo picker); iOS purpose strings are just-in-time; denial produces guidance, not a crash (widget test) | OK |
| S-05 | Logs | No `print`/`debugPrint`/logging in `lib/`. Error messages shown to users never include paths or stack traces (`describeError`) | OK |
| S-06 | Sensitive data leakage: EXIF/GPS | Derived previews, thumbnails and PDFs are re-encoded with **no EXIF**. GPS coordinates are never stored in the DB. **Originals keep camera metadata (possibly GPS)** because they must stay unchanged. The evidence package README, the report screen and the photo details screen warn the user | Mitigated / documented |
| S-07 | Temporary files | Share/export copies go to `<temp>/rentproof_exports`, cleared on every launch. Picker/camera temp copies inside the app cache are deleted after storing (`discardPickerTemp`, Android). On iOS the plugin's tmp files are left to OS cleanup | Mitigated |
| S-08 | Exports | Exports happen only on explicit user action through the system share sheet. The ZIP contains originals (with metadata), the notes, and the property nickname/address in the manifest; the user is warned about location metadata | Accepted (user-initiated) |
| S-09 | Local database | SQLite in the app sandbox, protected by OS file encryption (iOS Data Protection default class; Android FBE). Not additionally encrypted (BACKLOG B-14). `secure_delete=ON` zeroes deleted content; "Delete all data" runs `VACUUM` | Accepted |
| S-10 | Deletion | Deleting media/rooms/inspections/places removes files as well as rows (tests). Delete-all removes every table row, evidence, reports and exports (test). Files the user already shared are outside the app's control, which the UI says | OK |
| S-11 | App backups | Android: `allowBackup=false` + `dataExtractionRules` exclude cloud backup (prevents partial DB-without-files restores); device-to-device transfer allowed. iOS: included in encrypted device backups (iCloud/computer). Documented in the privacy policy and Settings | Accepted / documented |
| S-12 | Debug configuration | No debug-only endpoints or flags. Release APK is audited in CI for INTERNET, CAMERA, storage, location and audio permissions. `debugShowCheckedModeBanner=false`. Release builds without `key.properties` are debug-signed and **must not be distributed** (build.gradle comment, RELEASE_REPORT) | OK / action for owner |
| S-13 | Clipboard | Only the SHA-256 string is copied, on explicit tap | OK |
| S-14 | PDF content injection | User text is rendered as text (no markup interpretation); unsupported glyphs are replaced | OK |
| S-15 | ZIP generation | Entry names come from generated evidence IDs + slug + a generated extension; no user-controlled paths (no zip-slip on the producer side) | OK |
| S-16 | Integrity claims | The hash is recomputed and compared; a mismatch or missing file is shown and recorded, never auto-"fixed" | OK |
| S-17 | Dependencies | Mature, widely used packages; no native code of our own. `flutter pub outdated` shows minor updates available within constraints | Monitor |
| S-18 | Screenshot/app-switcher privacy | The app does not hide content in the app switcher (FLAG_SECURE not set), so photos may show in recents thumbnails | Accepted (low risk); revisit if users request it |

## Residual risks
1. Anyone with the unlocked phone can open the app (no app lock). Possible future opt-in biometric lock.
2. Originals shared by the user can reveal location through EXIF.
3. The device clock can be changed by the user, so timestamps are not trustworthy against the device owner. This is disclosed in the app and in reports.

## How to re-run
`flutter analyze`, `flutter test`, CI permission audit, `grep -rn "print(" lib`.
