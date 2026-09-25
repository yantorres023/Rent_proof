# DECISIONS

Format: DATE / DECISION / OPTIONS CONSIDERED / RATIONALE / CONSEQUENCES

---

### D-001 — Do not install Android SDK via mirrors
- DATE: 2026-09-25
- DECISION: Android SDK is not installed locally; Android builds run in GitHub Actions.
- OPTIONS CONSIDERED: (a) third-party SDK mirrors, (b) skip Android build, (c) CI build.
- RATIONALE: dl.google.com is denied by the environment's egress policy (HTTP 403). Routing around an organization policy denial is not acceptable. GitHub-hosted runners ship the Android SDK.
- CONSEQUENCES: `flutter build apk` cannot be verified inside this container; it is verified only if/when CI runs. Local verification is limited to `dart format`, `flutter analyze`, `flutter test` (VM/host tests) and optionally a Linux/web build.

### D-002 — Product decision: PIVOT #1 ("Move-in record kit for US renters")
- DATE: 2026-09-25
- DECISION: Continue to implementation with a narrowed product: a free guided move-in record, a dated send to the landlord, a durable evidence package, and move-out comparison.
- OPTIONS CONSIDERED: GO as specified; PIVOT to "Move-in checklist & deposit deadline kit" (red team); PIVOT to maintenance timeline; STOP.
- RATIONALE: See research/RED_TEAM.md §4 and research/EVIDENCE_LEDGER.md. The problem is structurally supported. The feature gap is contradicted (the category is crowded, including an app with our name). The remaining gaps are distribution, trust and delivery.
- CONSEQUENCES: V1 has no payments and no state-specific legal content. A kill gate is defined in VALIDATION_DEBT.md.

### D-003 — Beachhead: United States, renters aged 18–34 (students and first-time renters) at move-in
- DATE: 2026-09-25
- OPTIONS CONSIDERED: US; England (runner-up: good official data, but landlords usually supply inventories and formal disputes are rare, 1–3%); Canada (Ontario bans damage deposits and Québec restricts deposits); Germany (would need full German localization and legal work).
- RATIONALE: Large renter base (~44.6M renter-occupied units). No free adjudication service, so the tenant's own record matters. Most states have no mandatory landlord checklist, so the tenant has to create one. There are reachable intermediaries (university off-campus housing offices, student legal services).
- CONSEQUENCES: English only, US-style room templates, date formats ISO/US-neutral. Localization-ready structure.

### D-004 — Public name: do not ship as "RentProof"
- DATE: 2026-09-25
- DECISION: "RentProof" stays as the internal codename (repo, Dart package, docs). User-facing strings use a single `appName` constant, provisionally "Move-In Record" (descriptive, low conflict risk, but weak as a trademark). The final name, domain and store IDs are HUMAN_ACTION_REQUIRED.
- OPTIONS CONSIDERED: RentProof (taken: iOS app "Rentproof", getrentproof.app, same features; also "RentProof" Toronto on Facebook); Move Ledger (red-team pick; rejected because "Ledger" is a prominent crypto-wallet app brand); RoomPrint (a web room planner exists); RoomTrace (an iOS LiDAR app exists); MoveProof, KeyDay and Walkthru (taken per NAME_CHECK.md).
- RATIONALE: Every brandable candidate checked had a conflict, and formal clearance (USPTO search, counsel) is not possible here.
- CONSEQUENCES: Android applicationId and iOS bundle ID are set to the provisional `app.moveinrecord.mobile`. They must be confirmed before the first store upload, because they cannot be changed afterwards.

### D-005 — No in-app purchases in V1
- DATE: 2026-09-25
- DECISION: Every feature is free in V1 (beta). The pricing hypothesis (free core; $9.99 one-time "move-out pack" per property) is documented and will be tested later.
- RATIONALE: IAP needs store accounts, products and sandbox testing (blocked by credentials). It would also confound the first validation question: will renters complete and send a move-in record?
- CONSEQUENCES: No billing permission or SDK. Monetization experiments are listed in MONETIZATION.md and VALIDATION_DEBT.md.

### D-006 — State-specific deadline content deferred
- DATE: 2026-09-25
- DECISION: No state-by-state legal deadlines or reminders in V1.
- RATIONALE: The statute details were not verified against primary text, and wrong deadlines could harm users and read as legal advice.
- CONSEQUENCES: V1 shows generic guidance only. Recorded in BACKLOG with a verification gate.

### D-007: English-only strings inline; localization-ready infrastructure
- DATE: 2026-09-25
- DECISION: The UI copy is inline English. `flutter_localizations` and locale-aware `intl` dates are wired up. The legal/limitations copy is centralized in `reportLimitations`.
- OPTIONS CONSIDERED: full ARB/gen-l10n now; inline strings with a documented migration.
- RATIONALE: V1 targets US English (D-003). Full ARB extraction costs a lot and adds no validation value yet.
- CONSEQUENCES: BACKLOG B-09. Extract to ARB before adding the first additional locale.

### D-008: Android cloud backup off; device transfer on; iOS backups allowed
- DATE: 2026-09-25
- DECISION: `allowBackup=false` plus `dataExtractionRules` excluding cloud backup. Device-to-device transfer is allowed. iOS app data stays in device backups.
- OPTIONS CONSIDERED: default Auto Backup; full exclusion; custom include rules.
- RATIONALE: Android Auto Backup caps at 25 MB. A partial restore could bring back database rows without their evidence files, which would show as "missing" and undermine trust. D2D and iOS backups copy everything together.
- CONSEQUENCES: The evidence package export is the primary backup. The UI shows backup status (FINAL_RED_TEAM #3).

### D-009: Riverpod 3 (no codegen), drift, imperative Navigator
- DATE: 2026-09-25
- OPTIONS CONSIDERED: Provider/ChangeNotifier, BLoC, Riverpod codegen; sqflite with raw SQL, Isar, Hive; go_router.
- RATIONALE:
  - drift: typed schema, migrations with schema verification, and reactive queries.
  - Riverpod: parameterized stream providers and easy overrides in tests.
  - Navigator: the stack is shallow and there are no deep links.
- CONSEQUENCES: build_runner is needed for drift, and CI checks that generated code is current.

### D-010: Platform-codec preview fallback
- DATE: 2026-09-25
- DECISION: When the pure-Dart decoder can't read a photo (e.g. HEIC), decode it with the platform's codecs via `dart:ui` and derive previews in an isolate.
- RATIONALE: iPhones and many Androids shoot HEIC. Without this, those photos would show "preview unavailable" in reports.
- CONSEQUENCES: Unit-tested with an injected decoder. The real HEIC path is unverified on devices (V-11).
