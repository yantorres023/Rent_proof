# RentProof Autonomous Build Report

_Generated 2026-09-25. Branch `claude/keen-ptolemy-mgqr0b`. The product ships under the provisional public name **"Move-In Record"**; "RentProof" is the internal codename only._

## Executive Summary
- **Research:** no human interviews were possible, so this is public-evidence research only. It found that the problem is real, but a renter photo-documentation app is **already a crowded, low-price category**, including an iOS app literally named **"Rentproof"** with nearly the same feature set ($4.99).
- **Decision:** **PIVOT** to a narrower, more honest product. It is a free, private, guided **move-in record kit for US renters**: walk through the unit, get a dated PDF, **send it to the landlord**, keep a verifiable **evidence package**, then **compare at move-out**.
- **What was built:** a complete Flutter app for Android and iOS, with 94 automated tests and green CI (Linux checks, Android APK/AAB build, macOS iOS no-codesign build).
- **What's left:** store publication needs the owner's name choice, credentials and legal review. Market viability still needs a real-user beta.

## Final Decision
**PIVOT** (pivot #1 of the 2 allowed). Not STOP: the underlying problem is structurally supported. Not GO-as-specified: that product already exists under our name. Rationale: `docs/research/RED_TEAM.md` §4, `docs/DECISIONS.md` D-002. The explicit kill gate is in `docs/research/VALIDATION_DEBT.md`: STOP if fewer than 20% of beta users complete an inspection, even after UX fixes.

## Market Chosen
**United States**, first-time and student renters (18–34), at **move-in** (the first ~72 h with the keys).
- **Runner-up: England.** It has the best data and paper-based deposit adjudication, but landlords usually provide inventories and only 1–3% of deposits end in formal disputes.
- **Canada rejected:** Ontario bans damage deposits and Québec prohibits requiring one.
- Details: `docs/research/MARKET.md`.

## Target Customer
A US renter who just signed a lease with a security deposit (median deposit about $795, per commercial data) and is stressed, alone in an empty unit with a phone. They are not a landlord and not a professional inspector.

## Problem
At move-out, deductions often hinge on whether damage existed at move-in. Renters' photos are scattered, undated in context, never sent, and lost by move-out (often 1–5 years later). Most states don't require the landlord to provide a checklist.

## Evidence Strength
| Claim | Confidence |
|---|---|
| Documentation matters structurally (statutes, adjudication, legal-aid advice) | MEDIUM-HIGH (primary statute text not fetched: proxy blocked) |
| Renters lose deposit money | MEDIUM (commercial surveys) |
| Renters fail to document | LOW |
| A tenant-app feature gap exists | **CONTRADICTED** (≥10 renter apps) |
| Hashes prove time | **CONTRADICTED** (they prove file integrity only) |
| Renters will complete, send, keep, pay | **UNVALIDATED_WITH_REAL_USERS** |

Consolidated ledger: `docs/research/EVIDENCE_LEDGER.md`. **Research caveat:** almost all web page fetches were blocked by the environment proxy, so the research relies on search-result summaries. Items needing primary verification are marked in the docs.

## Important Unvalidated Assumptions
1. Renters will finish a room-by-room walkthrough on move-in day (V-01, the kill gate).
2. They will send the report to the landlord (V-07).
3. They will back up and keep the record until move-out (V-05).
4. The honest wording reads as trustworthy rather than weak (V-04).
5. They will pay about $9.99 at move-out (V-06).
6. Universities, legal aid and tenant unions will link to it (V-08).

## Product Built
All of these are implemented and tested:
- **Onboarding** with explicit limits.
- **Places**, and **inspections** of type move-in, move-out, routine or maintenance.
- **10 room templates** with guided prompts; custom rooms and prompts; not-applicable marking.
- **Media:**
  - Camera photo and video, and import through the system picker.
  - Originals copied byte-for-byte to private storage and **SHA-256** verified at save.
  - An app timestamp, plus EXIF stored separately as "not verified".
  - GPS presence flagged; coordinates never stored.
  - Previews without EXIF. HEIC falls back to the platform codec.
  - Android lost-capture recovery.
- **Issues** with type, severity, details and a linked photo.
- **Photo markers**, stored as metadata only.
- **Integrity checks** with history.
- **Review & finish** that shows gaps honestly. Finished inspections are locked, with a reopen option.
- **PDF report:** cover, rooms, evidence cards, comparison, evidence index, limitations. It distinguishes ORIGINAL MEDIA RECORD, USER NOTES and APP-GENERATED METADATA, and records its own hash.
- **Send to landlord** with a record of the sent date.
- **Evidence package** ZIP (originals, manifest, SHA256SUMS, README), with backup status shown.
- **Move-out vs move-in comparison:** rooms linked, side by side per prompt, manual verdict and note, included in the PDF.
- **History** per place.
- **Settings:** name on reports, storage used, limits, privacy, delete all.

**Not built (deliberately; see `docs/product/BACKLOG.md`):**
- In-app purchases
- State deadline content
- Cloud sync
- In-app video playback
- AI features

## Core User Flow
Add place → Start inspection (move-in, 5 default rooms) → per room: take a photo for each prompt, add issues and markers → Done with room (goes to the next room automatically) → Review & finish → PDF generated → **Send to landlord** → confirm sent → **Export evidence package**. Months later: New inspection (move-out, move-in used as baseline) → same rooms → **Compare rooms** → report with comparison.

## Architecture
Flutter 3.47.5 / Dart 3.13, **Riverpod 3** (providers over drift streams), **drift/SQLite** schema v1 (foreign keys, `secure_delete`, a schema snapshot and verification test), private file storage split into originals and derived copies, hashing, previews and PDF built in background isolates, and the `pdf` package for reports. There is **no network code**. Full plan: `docs/engineering/TECHNICAL_PLAN.md`.

## Repository Structure
```
lib/src/{data,services,report,ui}   app code
test/{services,data,report,ui}      94 tests (+ goldens in test/ui/goldens)
drift_schemas/                      DB schema snapshots
docs/{research,product,engineering,business}  + PROJECT_STATE.md, DECISIONS.md
legal/  release/{android,ios,assets}  landing/  tool/  .github/workflows/
```

## Main Dependencies
drift 2.35.0, drift_flutter 0.3.1, flutter_riverpod 3.4.3, image_picker 1.2.3, image 4.10.1, crypto 3.0.7, pdf 3.13.1, archive 4.3.0, share_plus 13.3.0, path_provider 2.1.6, intl 0.20.3, uuid 4.6.0. Dev: drift_dev, build_runner, flutter_lints. There are no analytics, crash-reporting, ads, network or AI SDKs.

## Tests
- **Passed: 94 / 94**, both locally (Linux container) and in GitHub Actions (ubuntu). Breakdown:

| Suite | Tests |
|---|---|
| Services | 14 |
| Data (includes migration) | 33 |
| Report / evidence package / performance | 10 |
| App info | 2 |
| Widget flows | 10 |
| Accessibility (tap targets, labels, contrast, 200% text) | 19 |
| Goldens | 6 |

- **Failed:** 0.
- **Skipped:** goldens are excluded on the macOS CI job (font rasterization differs), so 88 tests run there.
- `dart format` clean. `flutter analyze`: **No issues found**.
- **Limitations:**
  - No on-device or integration tests (no emulator here).
  - Camera, share sheet, HEIC decoding and process-death recovery run against fakes or injected decoders in tests.
  - Goldens use test rendering and don't show photos.
  - No manual screen-reader pass.
  - Performance figures come from the container, not phones.

## Android
- **Local build:** not possible. The Android SDK download host (dl.google.com) is blocked by the environment's egress policy, and I did not route around it (D-001).
- **CI build:** **passed** on commit f6e738d, run [36133310402](https://github.com/yantorres023/Rent_proof/actions/runs/36133310402).
  - `app-release.apk` (69.0 MB, universal) and `app-release.aab` (66.5 MB) were built.
  - Artifact: `android-release-unsigned-for-testing`, retained until 2026-12-24.
  - These release builds are **debug-signed and must not be uploaded** to Play.
- **Permission audit** (aapt2 on the release APK): **no INTERNET, CAMERA, storage, media, location or audio permission**. The only entry is AndroidX's internal `DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION`.
- **Configuration:**
  - Provisional application ID `app.moveinrecord.mobile`; targetSdk 36; minSdk 24.
  - `key.properties`-based release signing.
  - Cloud backup excluded; device-to-device transfer allowed.
- **CI on the final code (1bf6944):** passed (see "Final Repository Status").

## iOS
- **Configuration:**
  - Display name set; camera, photo-library and microphone purpose strings.
  - `PrivacyInfo.xcprivacy`: no tracking, no data collected, FileTimestamp C617.1.
  - `ITSAppUsesNonExemptEncryption=false`.
  - Provisional bundle ID `app.moveinrecord.mobile`; deployment target iOS 15.
- **macOS CI:** **passed** on commit f6e738d, run [36133310466](https://github.com/yantorres023/Rent_proof/actions/runs/36133310466). Tests ran and `flutter build ios --release --no-codesign` succeeded. The unsigned Runner.app artifact was uploaded.
- **Signing / TestFlight / App Store:** **BLOCKED_BY_CREDENTIALS**. No signing was attempted or claimed.

## Privacy
- The app is fully local: no account, analytics, ads or crash reporting. The Android release build has no network permission.
- Derived images and PDFs are stripped of EXIF. Originals keep camera metadata, and users are warned about location data.
- Data map: `docs/engineering/PRIVACY_DATA_MAP.md`. Drafts: `legal/PRIVACY_POLICY.md` and `legal/TERMS.md`, both clearly marked DRAFT and requiring counsel review.
- Draft store answers: Apple "Data Not Collected"; Google "no data collected/shared". Both are marked NEEDS_CURRENT_POLICY_VERIFICATION.

## Security
Review: `docs/engineering/SECURITY.md` (18 items).
- Stored files get UUID names with allow-listed extensions, and path containment is enforced (tested against traversal).
- No logging.
- `secure_delete` plus `VACUUM` when deleting everything.
- Picker temp copies are cleaned up; export temp files are cleared at launch.
- A release-permission audit runs in CI.
- **Residual risks:** no app lock; shared originals can reveal location; the device clock is user-controlled (disclosed).

## Legal / Claims Limitations
- The app never claims "court-proof", "tamper-proof", "legally binding", "guaranteed", or "verified date".
- Every report, the onboarding, Settings and the ZIP README state:
  - timestamps come from the device clock;
  - a hash shows the file hasn't changed since it was recorded, not when or where the photo was taken, who took it, or that it's authentic;
  - EXIF is unverified;
  - this is not legal advice.
- Only a generic deadline note is shown ("check your lease/local rules"). State-specific law is deferred until it's verified against primary sources (D-006). Legal background: `docs/research/LEGAL_CONTEXT.md`.

## Monetization
V1 is **free, with no purchases** (D-005).
- **Hypothesis to test:** a free core, plus a **$9.99 one-time Move-Out Pack per property** or a **$14.99 lifetime unlock**. No subscription, because use is infrequent.
- Paid acquisition is uneconomic: estimated ~$130 cost per payer against ~$8.50 net per sale.

Details: `docs/business/MONETIZATION.md`.

## Distribution
Organic and intermediary-led: move-in and deposit SEO (state pages only after primary-source checks), university off-campus housing, student legal services, tenant unions, and honest short-form video. The plan includes 10 content concepts, 10 SEO ideas, and referral and creator hypotheses. No ads were bought and no one was contacted. See `docs/business/GROWTH.md` and its lead amendments.

## Landing Page
`landing/index.html` plus `privacy.html`: static, responsive (checked at 390 px and 1280 px with no horizontal scroll) and dark-mode aware. It has no testimonials, user counts, savings figures or guarantees. The CTA scrolls to an "Availability" note until store links are set in `STORE_LINKS`. It is not deployed anywhere.

## Known Bugs
None known in the tested flows. The following are known **limitations**, not verified bugs:
- No in-app video playback.
- HEIC fallback and Android process-death recovery have not been verified on devices.
- The comparison screen snapshot doesn't live-refresh if media changes while it's open.
- Photos in the app-switcher thumbnail aren't hidden.

## Technical Debt
- UI strings are inline English, so they need ARB extraction before localization (D-007).
- There is no integration_test on devices.
- The universal APK is large (per-ABI splits are recommended for sideloading).
- 13 transitive packages have newer major versions.
- Node 20 deprecation warnings in GitHub Actions (checkout/setup-java/upload-artifact v4) should be bumped when v5 is available.
- The golden for the media screen has no image because of fake-async decoding.

## External Blockers
- **BLOCKED_BY_CREDENTIALS:** Google Play Console; Apple Developer Program / App Store Connect / signing.
- **BLOCKED_BY_OWNER_DECISION:** final public name and permanent app IDs.
- **ENVIRONMENT:** Android SDK host blocked locally (worked around with CI); most research page fetches blocked (worked around with search summaries, flagged).

## HUMAN_ACTION_REQUIRED

1. **Choose the final name and permanent app IDs**
   - **WHY:** "RentProof" conflicts with an existing iOS app with the same features. The app/bundle ID can never change after the first upload.
   - **EXACT STEPS:**
     1. Pick a distinctive name.
     2. Run a USPTO TESS search and get counsel review.
     3. Buy the domain.
     4. Update `appName` in `lib/src/app_info.dart`, `android:label` in `android/app/src/main/AndroidManifest.xml`, `CFBundleDisplayName`/`CFBundleName` in `ios/Runner/Info.plist`, `applicationId`/`namespace` in `android/app/build.gradle.kts`, `PRODUCT_BUNDLE_IDENTIFIER` in `ios/Runner.xcodeproj/project.pbxproj`, and the Kotlin package path of `MainActivity.kt`.
     5. Run `flutter test --update-goldens` on Linux.
   - **EXPECTED RESULT:** a cleared name, with IDs you own.

2. **Create the Android upload key and publish to Internal testing**
   - **WHY:** needed for any Play distribution. CI artifacts are debug-signed.
   - **EXACT STEPS:**
     1. `keytool -genkey -v -keystore upload.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload`.
     2. Create `android/key.properties` (storeFile, storePassword, keyAlias, keyPassword). Never commit it.
     3. `flutter build appbundle --release`.
     4. Play Console: create the app, enroll in Play App Signing, upload to **Internal testing**, and complete Data safety, content rating, target audience and privacy policy URL using `release/android/PLAY_STORE_METADATA.md`.
   - **EXPECTED RESULT:** the internal test track is available to beta testers.

3. **Set up Apple signing and TestFlight**
   - **WHY:** iOS distribution requires your Apple Developer account.
   - **EXACT STEPS:**
     1. Enroll in the Apple Developer Program.
     2. Register the bundle ID.
     3. Open `ios/Runner.xcworkspace` in Xcode, set the Team and automatic signing.
     4. `flutter build ipa --release`.
     5. Upload with Xcode Organizer or Transporter.
     6. Complete App Privacy, the age-rating questionnaire and review notes from `release/ios/APP_STORE_METADATA.md`.
     7. Invite TestFlight testers.
   - **EXPECTED RESULT:** a TestFlight build is available.

4. **Legal review and hosting**
   - **WHY:** the privacy policy and terms are drafts, and the claims wording should be checked by counsel. Both stores require a privacy policy URL.
   - **EXACT STEPS:**
     1. Have counsel review `legal/*.md`, the in-app limitations text (`reportLimitations` in `lib/src/report/pdf_report_builder.dart`) and the store copy.
     2. Fill in the [bracketed] fields.
     3. Host `landing/` (e.g. GitHub Pages or any static host).
     4. Regenerate `landing/privacy.html` from the final policy.
   - **EXPECTED RESULT:** public privacy policy and support URLs for the store forms.

5. **Real-device QA before the beta**
   - **WHY:** the camera, HEIC fallback, lost-capture recovery, share sheet, screen readers and low-end performance couldn't be exercised here.
   - **EXACT STEPS:** On one recent iPhone, one older Android and one low-RAM Android, run the flow in the "Recommended First Beta Test" below with about 50 photos, including iPhone HEIC imports. Kill the app during camera capture on Android. Try TalkBack and VoiceOver. Export the ZIP and run `shasum -a 256 -c SHA256SUMS.txt`.
   - **EXPECTED RESULT:** no blockers, or issues filed.

6. **Approve the beta recruitment outreach**
   - **WHY:** validation needs real renters, and I was not permitted to contact anyone.
   - **EXACT STEPS:** Approve contacting 1–3 university off-campus housing offices or tenant unions to recruit 20–30 renters moving in the next month. Use the kill gate in `docs/research/VALIDATION_DEBT.md`.
   - **EXPECTED RESULT:** beta data for V-01 and V-07.

## Real-User Validation Debt
13 open questions, each with a test, metric, pass/fail condition and cheapest method: `docs/research/VALIDATION_DEBT.md`. **Kill gate:** continue only if at least 40% of beta users complete an inspection with a report and at least 50% of completed move-ins are marked sent. STOP if completion is below 20% after one round of UX fixes.

## Recommended First Beta Test
- **Who:** 20–30 US renters moving in within 30 days (student housing is ideal).
- **How:** Play internal testing plus TestFlight.
- **Task:** use the app on move-in day as they naturally would.
- **Measure:**
  - completion within 7 days (V-01);
  - time to finish (V-02);
  - prompts skipped (V-03);
  - "would you send this?" and whether they did send it (V-04, V-07);
  - backup export (V-05);
  - landlord reaction (V-09).
- **Follow-up:** a short survey at day 7 and a 20-minute call with five participants.

## Next 3 Experiments
1. **Completion and send-rate beta** (above). It decides continue or stop.
2. **Fake-door price test:** landing page "Move-Out Pack, notify me" at $6.99 / $9.99 / $14.99 variants (V-06), with no charges.
3. **Intermediary channel test:** a sample report PDF sent to 20 housing, legal-aid and tenant organizations, counting how many list the app (V-08).

## Files To Review First
1. `RELEASE_REPORT.md` (this file)
2. `docs/research/RED_TEAM.md` §4 and `docs/research/EVIDENCE_LEDGER.md`: the decision
3. `docs/product/PRODUCT_STRATEGY.md`: what we're betting on
4. `docs/research/VALIDATION_DEBT.md`: what's unproven
5. `lib/src/services/media_processing.dart`, `lib/src/data/evidence_repository.dart`, `lib/src/report/pdf_report_builder.dart`: the evidence core
6. `docs/engineering/SECURITY.md` and `PRIVACY_DATA_MAP.md`
7. `test/ui/goldens/*.png`: what the screens look like

## Definition of Done checklist
- [x] Market research completed (public evidence only; fetches mostly blocked; flagged)
- [x] Evidence ledger completed
- [x] Red team completed
- [x] GO/PIVOT decision documented (PIVOT)
- [x] ICP defined
- [x] PRD completed
- [x] UX specification completed
- [x] Technical plan completed
- [x] Flutter application implemented
- [x] Local persistence working
- [x] Property workflow working
- [x] Inspection workflow working
- [x] Room workflow working
- [x] Media workflow working (verified in tests with fakes; not on devices)
- [x] Evidence hash working
- [x] Issue annotation working
- [x] PDF generation working
- [x] History working
- [x] Comparison working (manual side-by-side)
- [x] Privacy review
- [x] Security review
- [x] Unit tests
- [x] Widget tests
- [x] Analyzer passing
- [x] Formatting passing
- [x] Android build attempted (local blocked by policy; CI build passed)
- [x] Android CI
- [x] iOS/macOS CI (no-codesign build passed)
- [x] Release metadata (drafts)
- [x] Landing page
- [x] Growth plan
- [x] Monetization analysis
- [x] Real-user validation debt
- [x] README
- [x] Final release report
- [ ] Store publication: BLOCKED_BY_CREDENTIALS / owner decisions (see HUMAN_ACTION_REQUIRED)
- [ ] Real-user validation: requires humans (see VALIDATION_DEBT)

## Final Repository Status
- Branch `claude/keen-ptolemy-mgqr0b`, pushed to `origin`. No pull request was opened.
- **CI on commit 1bf6944 (all app code in its final state) passed every job:**
  - [CI run 36135588481](https://github.com/yantorres023/Rent_proof/actions/runs/36135588481): generated code check, format, analyze, 94 tests including goldens, Android APK + AAB build, and the permission audit.
  - [iOS run 36135588533](https://github.com/yantorres023/Rent_proof/actions/runs/36135588533): tests, then `flutter build ios --release --no-codesign`.
- Later commits change only this report.
