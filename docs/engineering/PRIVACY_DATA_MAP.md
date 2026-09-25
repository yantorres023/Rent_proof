# Privacy Data Map (V1)

_2026-09-25. V1 is entirely local: no account, server, analytics, crash reporting, ads or third-party SDK that transmits data. The Android release build has no INTERNET permission._

| Data | Why | Where stored | Retention | User control | Export | Deletion | Shared with third parties? |
|---|---|---|---|---|---|---|---|
| Place nickname, address, landlord name, notes | Identify the place in reports | SQLite in app support dir | Until deleted by user or app uninstalled | Edit anytime | In PDF and manifest.json | Delete place / delete all / uninstall | No. Only if the user shares a report or package |
| Inspection type, dates, notes, room names, prompts, statuses | Structure the record | SQLite | Same | Edit while in progress; reopen | PDF, manifest | Delete inspection / place / all | No (same) |
| Photos and videos (originals) | Core evidence | App support dir `evidence/…/originals` | Same | Add/delete while in progress | Evidence package ZIP (unchanged) | Delete photo/room/inspection/place/all | No (same) |
| Derived previews/thumbnails (no EXIF) | Display and PDF | App support dir `evidence/…/derived` | Same as originals | n/a | Embedded in PDF | Deleted with original | No (same) |
| EXIF date, make, model; GPS present flag (no coordinates) | Show metadata as "not verified" | SQLite | Same | n/a | PDF (date/device), manifest | With media | No (same) |
| GPS coordinates inside original files | Not used; kept only because originals must be unchanged | Inside original file | Same | User warned before export | Inside originals in ZIP | With media | Only if the user exports/shares originals |
| SHA-256 hashes, verification history | Integrity checking | SQLite | Same | Run checks | PDF, SHA256SUMS.txt, manifest | With media | No (same) |
| Issues, markers, captions, comparison verdicts | User's own notes | SQLite | Same | Edit/delete while in progress | PDF, manifest | With parent | No (same) |
| Report PDFs + their hash, "marked sent" date | Reports and delivery record | App support dir `reports/`, SQLite | Same | Delete report | Share sheet | Delete report / inspection / all | Only when the user shares |
| Name for "Prepared by" (optional), email field (unused in UI) | Shown on reports | SQLite | Until changed | Edit in Settings | PDF | Delete all | No (same) |
| Onboarding flag, pending-capture marker | App state | SQLite | Until delete all | n/a | No | Delete all | No |
| Temporary share copies | Hand files to the share sheet | App temp dir `rentproof_exports` | Cleared at every app launch | n/a | n/a | Automatic | Only to the app the user picks |

## Platform and store infrastructure (outside the app's control)
- Google Play / App Store collect install and crash data under their own policies (e.g. Play Console vitals and App Store analytics shared by the user's device settings). The app does not add SDKs for this.
- iOS device backups (iCloud or computer) may contain app data if the user enables backups.
- Share targets (email, messaging, cloud drives) receive whatever the user sends.

## Therefore
- Accurate: "No account. No analytics. Your records stay on your phone unless you share or export them."
- Do not claim "zero data collection by anyone", because store infrastructure and user-chosen share targets exist.
