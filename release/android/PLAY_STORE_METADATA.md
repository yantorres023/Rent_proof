# Google Play listing — DRAFT

_Name is provisional (DECISIONS D-004). Items marked **NEEDS_CURRENT_POLICY_VERIFICATION** must be checked against the live Play Console / policy pages at submission._

| Field | Draft |
|---|---|
| App name (≤30) | Move-In Record: Rental Check |
| Short description (≤80) | Walk through your rental room by room and send a dated condition report. |
| Category | House & Home (alternative: Productivity) |
| Tags | Moving, Real estate / rentals, Checklists (pick from Console list) |
| Contact email | [owner email] — HUMAN_ACTION |
| Privacy policy URL | [host legal/PRIVACY_POLICY.md after review] — HUMAN_ACTION |
| Website | [landing page URL] (optional) |
| Application ID | `app.moveinrecord.mobile` (provisional — permanent after first upload) |
| Target SDK | 36 (Flutter 3.47 default; required for new apps since 2026-08-31 per research — NEEDS_CURRENT_POLICY_VERIFICATION) |
| Pricing | Free, no in-app purchases, no ads |

## Full description (≤4000)
Moving into a rental? Record its condition before you unpack.

Move-In Record guides you through your new home room by room with simple prompts — overview, walls, floor, windows, appliances — so you photograph what's there, including anything already scratched, stained or broken.

• Guided walkthrough: 10 room types with short photo prompts. Add your own rooms and prompts.
• Record issues: describe damage, choose how noticeable it is, link it to a photo and mark the exact spot.
• A clear PDF report: every room, photo and note, with the date and time the app saved each file.
• Send it to your landlord from your phone, and note the date you sent it.
• Keep a backup: export an evidence package with your original files, the report and a list of SHA-256 fingerprints you can check with standard tools.
• Move-out comparison: repeat the walkthrough when you leave and view rooms side by side with your move-in photos.
• Private: no account, no ads, no analytics. Your records stay on your phone unless you share them.

Honest about limits: dates come from your phone's clock, and a file fingerprint shows a stored file hasn't changed — it doesn't prove when a photo was taken. Move-In Record isn't legal advice and can't guarantee any outcome. Check your lease and local rules for deadlines.

## Data safety form (draft answers — verify)
- Does your app collect or share any of the required user data types? **No** (no data transmitted off device by the app; user-initiated sharing via the system share sheet is not developer collection — NEEDS_CURRENT_POLICY_VERIFICATION).
- Is all data encrypted in transit? N/A (no transmission).
- Can users request data deletion? Data is on-device; in-app "Delete all data" + uninstall.
- Account creation: none → account deletion requirements not applicable.

## Permissions declared
None dangerous. Release APK permissions are audited in CI (`permissions.txt` artifact). Photo & Video Permissions policy: app uses the system photo picker and does **not** request READ_MEDIA_IMAGES/VIDEO → no declaration expected (NEEDS_CURRENT_POLICY_VERIFICATION).

## Content rating (IARC questionnaire)
Utility; no violence, sexual content, gambling, user-to-user communication, location sharing or purchases. Expected: Everyone / PEGI 3 (answer truthfully in Console).

## Ads
Contains ads: **No**.

## Target audience
18+ (renters). Not designed for children.

## Store assets
- Icon 512×512: `release/assets/play-icon-512.png` (placeholder — replace with final brand icon).
- Feature graphic 1024×500: TODO after final name (HUMAN_ACTION/design).
- Phone screenshots: see `release/SCREENSHOT_PLAN.md`.

## Release notes (1.0.0)
First release: guided room-by-room move-in record, issues and photo markers, PDF report, send to landlord, evidence package export, move-out comparison.

## Before first upload (HUMAN_ACTION)
1. Final app name + application ID. 2. Upload keystore + `android/key.properties`; enroll in Play App Signing. 3. Host privacy policy. 4. Complete Data safety, content rating, target audience. 5. Internal testing track first (recommended for VALIDATION_DEBT V-01).
