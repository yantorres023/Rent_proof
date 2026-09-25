# PROJECT_STATE

_Last updated: 2026-09-25 · Phase: **MVP complete, release preparation done, waiting on human actions.**_

## Current phase
All autonomous phases are complete:
- research
- red team and the PIVOT decision
- strategy, PRD, UX, technical plan
- implementation
- tests
- security and privacy review
- CI
- release drafts and landing page
- final red team

The remaining work needs the owner (see RELEASE_REPORT.md → HUMAN_ACTION_REQUIRED) or real users (research/VALIDATION_DEBT.md).

## Environment facts (verified)
- The local container has Flutter 3.47.5 in /opt/flutter-sdk. The Android SDK can't be installed locally because dl.google.com is blocked by egress policy (D-001).
- GitHub Actions provides the Android SDK and macOS runners. CI run 36133310402 (CI) and 36133310466 (iOS) on commit f6e738d **passed**: format/analyze/tests, APK + AAB build, permission audit, and iOS tests + `--no-codesign` build.

## Validated assumptions (public evidence only, never real users)
- Documentation matters structurally in deposit disputes (statutes, paper adjudication, legal-aid advice). SUPPORTED, but primary texts were not fetched.
- The top of the funnel is large: ~44.6M US renter-occupied units. SUPPORTED.

## Rejected assumptions
- "No good tenant app exists." CONTRADICTED: the category is crowded, including an app named Rentproof.
- "The name RentProof is usable." CONTRADICTED.
- "Hashes/timestamps prove when a photo was taken." CONTRADICTED; the claims policy was adjusted.

## Decisions
D-001…D-010 in DECISIONS.md. The key ones:
- PIVOT #1: move-in record kit for US renters.
- Beachhead: US renters aged 18–34.
- Provisional name "Move-In Record".
- No IAP and no state deadlines in V1.
- Android cloud backup off.
- Platform HEIC fallback.

## Architecture summary
Flutter + Riverpod 3 + drift/SQLite (schema v1 with snapshot test) + private file storage (originals / derived) + SHA-256 verification in isolates + `pdf` report + ZIP evidence package. There is no network code. See engineering/TECHNICAL_PLAN.md.

## Completed work
Everything in the Definition of Done except the items listed under Pending. **94 automated tests pass locally and in CI** (the golden count may shift when goldens are updated).

## Pending (not doable autonomously)
- Final name, trademark search, domain, store IDs.
- Android signing key; Apple signing, provisioning and TestFlight.
- Hosting the privacy policy and support URL; legal review of drafts and copy.
- Real-device QA (camera, HEIC fallback, process-death recovery, TalkBack/VoiceOver, low-end performance).
- Beta with real renters (VALIDATION_DEBT V-01…V-13).

## Known bugs / limitations
- Videos cannot be played back in the app (BACKLOG B-03).
- Goldens don't show photo thumbnails (fake-async image decoding), which affects test visuals only.
- The iOS HEIC path and Android lost-data recovery have not been verified on devices.
- Universal release APK is 69 MB. Play delivers per-ABI splits from the AAB, so installs are smaller.

## Blockers
- BLOCKED_BY_CREDENTIALS: Play Console, Apple Developer / App Store Connect.
- BLOCKED_BY_OWNER_DECISION: final name and IDs (permanent after first upload).

## Next highest-priority action
The owner picks the final name and IDs. Then an internal-testing beta on both stores to run VALIDATION_DEBT V-01 / V-07 (the kill gate).
