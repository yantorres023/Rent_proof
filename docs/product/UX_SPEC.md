# UX Specification: Move-In Record V1

_2026-09-25. Describes the implemented app (`lib/src/ui`). Golden images: `test/ui/goldens/`._

## 1. Principles
1. **No inspection jargon.** "Take photo of Floor", not "Capture evidence item".
2. **One obvious next action per screen.** Filled button: take photo, done with room, review & finish, send to landlord.
3. **Never block on perfection.** Gaps are shown honestly, and the user can still finish.
4. **Honest wording.** "Fingerprint", "recorded by the app", "not verified". Never "proof".
5. **Status is never color-only.** It always has an icon and text.
6. **Stressed, one-handed use.** Large targets (≥48 dp, 52 dp primary buttons), bottom-anchored primary actions, short text.

## 2. Information architecture
```
Onboarding (first launch)
Home: Places
 ├─ Settings
 ├─ Add/Edit place
 └─ Place
     ├─ New inspection (type, baseline, rooms)
     └─ Inspection
         ├─ Room ──┬─ Photo details (markers, metadata, file checks)
         │         └─ Issue (add/edit)
         ├─ Compare rooms → Room comparison
         ├─ Review & finish
         └─ Report & share (send, share, evidence package, versions)
```
Navigation is a standard push stack (MaterialPageRoute), with the back button always available. New inspection → Inspection and Review → Report use `pushReplacement`, so Back goes somewhere sensible.

## 3. Screen inventory

| # | Screen | File | Purpose | Primary action | Empty state | Loading | Errors |
|---|---|---|---|---|---|---|---|
| S1 | Onboarding | onboarding_screen.dart | Explain value + limits | Next / Get started | n/a | n/a | n/a |
| S2 | Home (Places) | home_screen.dart | List places | Add place (FAB; centered button when empty) | "Start with your place" + button | spinner | message |
| S3 | Place form | property_form_screen.dart | Create/edit place | Save place | n/a | button disabled while saving | inline validation, snackbar |
| S4 | Place | property_screen.dart | History of inspections | New inspection (FAB) / Start inspection card | "Ready for your walkthrough?" card with guidance | spinner | message |
| S5 | New inspection | new_inspection_screen.dart | Type, baseline, rooms | Start walkthrough | n/a | spinner | snackbar |
| S6 | Inspection | inspection_screen.dart | Rooms + progress | Review & finish / Report & share (bottom) | "No rooms yet" + Add room | spinner | snackbar |
| S7 | Room | room_screen.dart | Guided prompts, media, issues | Take photo (per prompt); Done with room (bottom) | tip banner | linear progress while saving | snackbar per failure |
| S8 | Photo details | media_screen.dart | View, mark, note, metadata, check | Mark a spot / Add issue | "No note" | n/a | placeholder for undecodable/video |
| S9 | Issue form | issue_form_screen.dart | Record a problem | Save issue | "No photos in this room yet" | n/a | inline validation |
| S10 | Review & finish | review_screen.dart | Show gaps, finish | Finish & create report | error line if no media | spinner | snackbar |
| S11 | Report & share | report_screen.dart | Generate, send, share, back up | Send to landlord | "No report yet" + Create report | linear progress + label | "PDF file is missing" |
| S12 | Compare rooms | comparison_screen.dart | Pair list with verdicts | open a room | "No baseline" if it was deleted | spinner | message |
| S13 | Room comparison | comparison_screen.dart | Side by side per prompt, verdict, note | choose verdict | "No photo" cells | n/a | snackbar |
| S14 | Settings | settings_screen.dart | Name on reports, storage, limits, privacy, delete all | n/a | "Not set" | "Calculating…" | "Unavailable" |

## 4. Key flows

### 4.1 First inspection (happy path)
1. Onboarding (4 pages) → Get started.
2. Home empty → **Add your place** → name (required) → Save.
3. Place → "Ready for your walkthrough?" → **Start inspection**.
4. New inspection: Move-in preselected, 5 default rooms → **Start walkthrough**.
5. Inspection: "0 of 5 rooms done" → tap Entry & hallway.
6. Room: tip banner, then per prompt **Take photo**, then the camera. Status changes to "✓ 1 added".
7. Optional: ⋮ → Import photos / Record video / Not in this unit. **Add issue** at the bottom.
8. **Done with room (4/6)** → automatically opens the next unfinished room.
9. After the last room, back to Inspection → **Review & finish**.
10. Review lists prompts without photos (tap to fix) → **Finish & create report**.
11. Report & share opens and generates the PDF automatically → **Send to landlord** → share sheet (email) → "Did you send it?" → Yes → "You marked this as sent on …".
12. **Export evidence package** → share sheet → save to Files/Drive/email.

### 4.2 Move-out comparison
Place → New inspection → Move-out is preselected once a move-in exists → Baseline = latest completed move-in → rooms and prompts are copied → walk through → Inspection shows "Compare with baseline" → Compare rooms → per room: side-by-side photos per prompt, issues on both sides, verdict and note → finish → the report includes the comparison section.

### 4.3 Interrupted capture (Android process death)
Before the camera opens, the room/prompt is saved. If the OS kills the app, then on next launch Home recovers the captured media into that room and shows "Recovered 1 photo into 'Kitchen' after the app restarted."

## 5. States

- **Permission states.**
  - The camera permission is requested by the OS the first time "Take photo" is tapped (iOS). On Android the system camera app is used and the app requests no camera permission.
  - Photo import uses the system picker (no permission on Android; limited-library-compatible on iOS).
  - When access is denied: "Camera access is off. You can turn it on in your phone Settings, or import photos instead."
- **Offline.** The whole app works offline, since nothing uses the network. Sharing depends on the chosen target app.
- **Locked (finished) inspection.** Room shows the lock banner; capture, delete and issue editing are hidden; the issue form opens read-only; the Inspection menu offers "Reopen inspection" with a confirmation.
- **Confirmation states.** Snackbars for saved/recovered/copied; the report card shows sent status; file checks show a result dialog.
- **Destructive actions.** Every delete uses a confirmation dialog with a red button that names what will be deleted and says whether files already shared are affected. "Delete all data" also requires typing DELETE.
- **Low storage.** Out-of-space failures delete partial files and say "Nothing was saved". Settings shows storage used.

## 6. Copy rules
- Say "record", "report", "fingerprint (SHA-256)", "saved by the app", "not verified".
- Never say "proof", "court-proof", "tamper-proof", "legally binding", "guaranteed", "verified date".
- Deadlines are only generic: "Your lease or local rules may set a deadline… Check your lease."

## 7. Onboarding content
1. Record your place on move-in day.
2. Get a dated report you can send.
3. Compare at move-out.
4. Private, and honest about limits (device clock, what a fingerprint shows, not legal advice).

## 8. Accessibility behavior
- Tap targets ≥ 48 dp (`MaterialTapTargetSize.padded`; primary buttons 52 dp). Tested with `androidTapTargetGuideline`, `iOSTapTargetGuideline` and `labeledTapTargetGuideline` on 9 screens.
- Text contrast is tested with `textContrastGuideline` on 9 screens.
- Text scaling: every main screen is tested at 200% on a 360×740 viewport with no overflow errors.
- Screen readers:
  - Thumbnails announce kind, index, prompt and saved time.
  - Capture buttons announce "Take photo of Floor".
  - Progress is announced as "3 of 5 rooms done".
  - Headers are marked, and decorative icons are excluded.
- Status uses icon + text + color.
- Reduced motion: onboarding page transitions are instant when the OS disables animations.
- Keyboard: standard Flutter focus traversal. Single-line dialog fields submit with the IME action.
- **Limits:** no manual TalkBack/VoiceOver pass was done (no devices). See VALIDATION_DEBT V-10.

## 9. Visual design
Material 3, seed color #1F5AA6 (trust blue), light and dark themes, outlined cards, and semantic status colors (done green, warning amber) that always come with icons. See BRAND.md.
