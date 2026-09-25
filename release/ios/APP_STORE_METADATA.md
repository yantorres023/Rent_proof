# App Store listing — DRAFT

_Name provisional (D-004). Items marked **NEEDS_CURRENT_POLICY_VERIFICATION** must be re-checked in App Store Connect at submission._

| Field | Draft |
|---|---|
| Name (≤30) | Move-In Record |
| Subtitle (≤30) | Rental condition report |
| Bundle ID | `app.moveinrecord.mobile` (provisional; permanent once used) |
| SKU | moveinrecord-ios-1 |
| Primary category | Lifestyle (alternative: Productivity) |
| Price | Free, no IAP |
| Keywords (≤100) | move in,checklist,rental,apartment,inspection,security deposit,tenant,move out,condition,photos |
| Promotional text (≤170) | Walk through your new rental room by room, record any damage, and send your landlord a dated PDF report — before you unpack. |
| Support URL | [required — HUMAN_ACTION] |
| Privacy policy URL | [required — HUMAN_ACTION] |
| Copyright | [year entity] |

## Description
Use the same text as `release/android/PLAY_STORE_METADATA.md` (full description), replacing "phone" with "iPhone" where natural.

## App Privacy ("nutrition label")
- Data collection: **Data Not Collected** (no SDKs, no server, no analytics). User-initiated sharing through the share sheet is not collection by the developer — NEEDS_CURRENT_POLICY_VERIFICATION against Apple's definitions.
- Tracking: No. `ios/Runner/PrivacyInfo.xcprivacy` declares no tracking and no collected data; required-reason API FileTimestamp C617.1 (verify the list of required-reason APIs used by plugins' own manifests at build time — Xcode privacy report).

## Permission purpose strings (Info.plist)
- Camera: "The camera is used to photograph each room so you have a record of its condition. Photos stay on your iPhone unless you share them."
- Photo library: "Choose existing photos or videos to add to a room. Only the items you pick are copied into the app."
- Microphone: "The microphone records sound when you choose to record a video of a room."

## Age rating
Answer Apple's updated questionnaire (new 13+/16+/18+ system; must be completed — NEEDS_CURRENT_POLICY_VERIFICATION). Expected **4+**: no objectionable content, no web access, no user-to-user interaction.

## Account deletion (5.1.1(v))
Not applicable — no accounts. State this in App Review notes.

## Export compliance
`ITSAppUsesNonExemptEncryption = false` set in Info.plist (app uses only OS-provided encryption and hashing; SHA-256 hashing is not encryption) — NEEDS_CURRENT_POLICY_VERIFICATION.

## App Review notes (draft)
"Local-only record-keeping app for renters. No account, no server. To test: tap Add your place → enter a name → Start inspection → Start walkthrough → open a room → Take photo (or ⋮ → Import photos) → Done with room → Review & finish → Finish & create report → Send to landlord (opens share sheet). The app does not provide legal advice and makes no claims of legal validity."

## Screenshots
6.9" and 6.5" iPhone sets required (NEEDS_CURRENT_POLICY_VERIFICATION of current required sizes). See `release/SCREENSHOT_PLAN.md`.

## Signing / TestFlight — BLOCKED_BY_CREDENTIALS
Requires Apple Developer Program membership, team ID, certificates, provisioning profile and App Store Connect app record. CI builds `--no-codesign` only.
