# Analytics taxonomy (design only)

_2026-09-25._

> **Status: no analytics are collected.** V1 contains no analytics SDK, no crash reporter and no network code, and the Android release build has no INTERNET permission. Nothing below is transmitted. This document defines what to measure when an **opt-in** beta instrumentation is added later (DECISIONS D-005 / VALIDATION_DEBT).

## Principles
- Opt-in only, off by default, with a clear toggle in Settings.
- Never send photos, notes, addresses, names, file names, hashes or free text.
- Events carry counts, enums and durations only. The only identifier is a random per-install ID that the user can reset.
- Before adding any SDK: update PRIVACY_DATA_MAP.md, the privacy policy, the Apple privacy label, the Google Data safety form and the Android manifest (INTERNET).

## Events

| Event | When | Properties (no PII) |
|---|---|---|
| app_opened | Cold start | days_since_install |
| onboarding_completed | Get started / Skip | skipped: bool |
| property_created | Place saved | has_address: bool |
| inspection_started | Start walkthrough | type, room_count, has_baseline |
| room_started | First media in a room | template_key |
| photo_added | Media stored | source (camera/import), prompt_assigned: bool |
| video_added | Video stored | source |
| issue_added | Issue saved | category, severity, has_photo |
| marker_added | Annotation saved | linked_issue: bool |
| room_completed | Done with room | prompts_done, prompts_total |
| inspection_completed | Finish | minutes_since_start, media_count, issue_count, rooms_done, rooms_total |
| report_generated | PDF created | media_count, includes_comparison, generation_ms |
| report_exported | Share / Send | target: share or landlord |
| report_marked_sent | "Yes, I sent it" | hours_since_completed |
| evidence_package_exported | ZIP shared | media_count, size_bucket |
| integrity_check_run | File check | checked, mismatched, missing |
| comparison_started | Compare rooms opened | pair_count |
| comparison_completed | Every current room has a verdict | changed_count, new_issue_count |
| capture_failed | Error | reason (permission / no_space / source_missing / other) |

## Metrics
- **Activation:** the share of new installs with `inspection_completed` and `report_generated` within 7 days.
- **Strong activation:** activation plus `report_marked_sent` or `evidence_package_exported`.
- **North Star:** completed documented inspections per month, meaning inspections finished with media in at least 80% of rooms and a report.
- **Walkthrough health:** median `minutes_since_start`, prompts done / total, and drop-off by room.
- **Move-out return rate:** the share of properties with a move-in that later get a move-out using it as baseline. This is a long-horizon metric (months to years).
- **Guardrails:** `capture_failed` rate, and time to generate a report.
