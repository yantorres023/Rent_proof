# STORE POLICY NOTES (Apple App Store + Google Play)

_2026-09-25. Sources → `SOURCES_REDTEAM.md`. Full-page fetches were blocked in this session, so everything below comes from search extracts of official pages. Anything not confirmed from an official Apple or Google page is marked **NEEDS_CURRENT_POLICY_VERIFICATION**. Re-verify all items at submission time; policies change often (Google changed fees in June 2026)._

## 1. Camera, photo and video permissions

### iOS
- **FACT.** `NSCameraUsageDescription` is required to access the camera. Its message explains to people why the app requests access [54]. The microphone key (`NSMicrophoneUsageDescription`) is needed if video is recorded with audio (standard iOS behavior; NEEDS_CURRENT_POLICY_VERIFICATION).
- **FACT (via Apple forum threads and extract).** Guideline 5.1.1 rejections commonly cite purpose strings that don't "clearly and completely describe" the use, usually with an example [53-related forum results; 97]. Draft purpose string: _"[AppName] uses the camera so you can photograph each room of your rental for your condition report. Photos are stored on this device."_
- **INFERENCE.** For imports, prefer `PHPickerViewController` (no photo-library permission needed) over full library access. Only request `NSPhotoLibraryAddUsageDescription` if the app *saves* to the user's library. NEEDS_CURRENT_POLICY_VERIFICATION.

### Android
- **FACT.** Google Play's **Photo and Video Permissions policy** only lets apps request `READ_MEDIA_IMAGES` / `READ_MEDIA_VIDEO` when the core functionality needs **persistent, broad access** to shared-storage media. Apps with occasional needs must use the **Android Photo Picker**. Broad access requires a **Play Console declaration** that Google reviews. Having a custom picker does not qualify an app by itself [49][50].
- **FACT.** Android 14 adds partial ("selected photos") access [51].
- **Recommendation (INFERENCE).** Capture with the in-app camera (`CAMERA` permission only) and store files in **app-private storage**. Import through the **system Photo Picker**. **Do not request READ_MEDIA_IMAGES/VIDEO.** This avoids the declaration entirely.

## 2. Privacy labels / Data safety for a local-only app
- **FACT (Google).** In the Data safety form, "collected" means **transmitted off the user's device**. Data processed only on-device need not be disclosed as collected [56].
- **FACT (secondary; official page not retrieved).** Apple's "collect" means transmitting data off-device in a way that lets the developer or partners access it longer than needed to service the request in real time [57]. Verify at developer.apple.com/app-store/app-privacy-details/ (**NEEDS_CURRENT_POLICY_VERIFICATION**).
- **INFERENCE.** A truly local app with **no analytics, no crash reporting SDK, no ads, and no server** can plausibly declare "Data Not Collected" (Apple) and "No data collected / no data shared" (Google). **Any** crash reporter (e.g., Firebase Crashlytics, Sentry) or analytics SDK changes this. The label must then list diagnostics/usage data, and marketing copy like "nothing leaves your device" must be qualified.
- **User-initiated sharing** (the user emails a PDF through the OS share sheet) is the user sending data, not the developer collecting it. Plausibly not "collection" under either definition. **NEEDS_CURRENT_POLICY_VERIFICATION.**
- **IAP.** Store receipts are handled by Apple/Google. If the app never sends purchase data to its own server, no collection arises from this (INFERENCE; verify).
- A **privacy policy URL** is still required by both stores even for a no-collection app (widely known requirement; NEEDS_CURRENT_POLICY_VERIFICATION of exact wording).

## 3. Account deletion
- **FACT.** Apple 5.1.1(v): apps that support account creation must let users start account deletion in-app [53]. Google Play: apps that allow account creation must offer in-app deletion **and** a web link for deletion requests, enforced since 2024 [58].
- **V1 (no accounts): not applicable.** If accounts or cloud are added later, both requirements apply.

## 4. Age rating
- **FACT.** Apple's new age-rating system adds **13+, 16+, 18+** (removing 12+ and 17+). Developers had to answer the updated questionnaire by **January 31, 2026**, or submissions and updates are blocked [55][95].
- **INFERENCE.** A utility with no user-generated sharing to others, no web browsing, and no mature content should rate **4+** (Apple) and **Everyone** (IARC/Google). Answer truthfully. Free-text notes stay on-device, so there is no UGC exposure to others. NEEDS_CURRENT_POLICY_VERIFICATION with the live questionnaire.

## 5. Target API level (Google Play, 2026)
- **FACT.** Since **August 31, 2026**, new apps and updates must **target Android 16 (API 36)** or higher (Wear OS / Automotive: 35; TV/XR: 34). Existing apps must target at least API 35 to stay available to new users on newer devices. An extension to **November 1, 2026** could be requested [52].
- **Implication.** Set `targetSdkVersion 36` in the Flutter Android config from day one. Account for Android 15/16 behavior changes (e.g., edge-to-edge enforcement). NEEDS_CURRENT_POLICY_VERIFICATION of specific behavior changes.

## 6. Payments / fees (for monetization modeling)
- **FACT.** Apple Small Business Program: 15% [45].
- **FACT.** Google Play (US/UK/EEA, from June 30, 2026): 10% service fee on the first $1M and on auto-renewing subscriptions, **plus a 5% billing fee** if using Play Billing. Alternative billing and external links are allowed [46][47]. NEEDS_CURRENT_POLICY_VERIFICATION for the exact US tiers on one-time IAPs above $1M (one secondary source says 20% on some new-install purchases above the threshold [102]; irrelevant at our scale).
- **Apple.** Digital unlocks must use IAP in most storefronts. US external-link rules changed after 2025 litigation (NEEDS_CURRENT_POLICY_VERIFICATION; not researched here).

## 7. Content and claims review risk
- **INFERENCE.** App Review and Play policy prohibit misleading claims in metadata (Apple 2.3 "Accurate Metadata"; Google "Misrepresentation"). NEEDS_CURRENT_POLICY_VERIFICATION of exact section numbers. "Court-proof", "guaranteed" or "legally binding" claims create review risk *and* legal risk (see LEGAL_CONTEXT §5).
- Do not use state seals, court logos or government branding in screenshots or the icon.

## 8. Checklist before first submission
- [ ] Camera and microphone purpose strings (iOS). CAMERA permission only (Android). No READ_MEDIA_*.
- [ ] System photo picker for imports, on both platforms.
- [ ] Privacy nutrition label and Data safety match the actual SDK list (audit dependencies).
- [ ] Privacy policy URL (hostable static page).
- [ ] Age-rating questionnaire (Apple, new system) and IARC (Google).
- [ ] targetSdk 36.
- [ ] Small Business Program enrollment (Apple). Play Billing library version current.
- [ ] Metadata claims reviewed against LEGAL_CONTEXT §5.
- [ ] No account → no deletion flow needed (document this in review notes).
