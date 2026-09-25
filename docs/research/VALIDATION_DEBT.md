# Real-User Validation Debt

_2026-09-25. No interviews, surveys, usability tests or beta users exist. Everything below still requires real humans. Tests are ordered by how much they could change the decision._

| ID | Question | Test | Metric | Pass | Fail | Cheapest way to test later |
|---|---|---|---|---|---|---|
| V-01 | Will renters actually complete a guided inspection on move-in day? | Closed beta (TestFlight / Play internal testing) with 20–30 renters about to move | % who finish ≥1 inspection with a report within 7 days of install | ≥ 40% | < 20% → **kill gate**: rethink the core (lighter flow or different trigger) | Recruit via one university off-campus housing office or a tenant union mailing list; ask for consent to share a simple, anonymous usage sheet |
| V-02 | How long is acceptable? | Timed moderated sessions (5–8 people) walking a real or mock apartment | Median minutes to finish 5 rooms; SUS score | ≤ 30 min, SUS ≥ 70 | > 45 min or SUS < 60 | Friends-and-family sessions in any apartment; screen recording with consent |
| V-03 | Does the room checklist feel excessive or incomplete? | Same sessions + beta prompt stats | % prompts skipped / marked N/A; "missing prompt" requests | < 30% skipped, few additions | > 50% skipped | Count N/A vs documented in beta exports voluntarily shared |
| V-04 | Does the PDF create enough perceived value? Which wording feels trustworthy? | Show 2 report variants (current wording vs stronger wording) to 10 renters | Preference; "would you send this to your landlord?" | ≥ 70% would send current version | Majority find it weak or confusing | 5-second test + short survey (unmoderated tools) |
| V-05 | Will users back up and keep data until move-out? | Beta telemetry (opt-in) or follow-up survey | % exporting evidence package within 7 days; % still installed at 90 days | ≥ 30% export | < 10% | Opt-in beta counters; email follow-up to beta volunteers |
| V-06 | Will users pay $X at move-out? | Fake-door or pre-order on landing page; later IAP A/B ($6.99 / $9.99 / $14.99) | Click-to-intent rate; purchase conversion among move-out starters | ≥ 5% of move-out starters | < 1% | Landing page "Move-Out Pack – notify me" button (no charge) |
| V-07 | Will renters send the report to the landlord? | Beta | % of completed move-ins with "marked sent" | ≥ 50% | < 20% | In-app "Did you send it?" answer rate (local, voluntarily reported) |
| V-08 | Will intermediaries (universities, legal aid, tenant unions) link to it? | Outreach to 20 organizations (owner-approved) | # agreeing to list it | ≥ 3 | 0 | Email with a sample report PDF |
| V-09 | Do landlords/property managers push back on tenant-made reports? | Ask beta users after sending | % reporting a negative response | < 20% | > 40% | Follow-up question in beta survey |
| V-10 | Is the app usable with TalkBack/VoiceOver and large text on real phones? | Manual accessibility pass on 2 Android + 2 iPhones | Blocking issues | 0 blockers | Any blocker in capture/report flow | 1 hour with devices; ask disability-advocacy tester |
| V-11 | Is performance acceptable on low-end Android? | Test on a ~$150 Android phone with 100 photos | Save time per photo; report time; crashes | ≤ 3 s/photo, report ≤ 30 s, no OOM | OOM or > 10 s/photo | Borrow a device; Firebase Test Lab (needs account) |
| V-12 | Do people search for this in stores? | App Store search popularity / Play Console store listing experiments after listing | Impressions for "move in checklist", "rental inspection" | Meaningful impressions | Negligible | Publish listing (after name clearance) and watch console for 4 weeks |
| V-13 | Is "Move-In Record" (or the final name) understandable and trustworthy? | 5-second test of icon + name | Correct description of purpose | ≥ 70% | < 40% | Unmoderated test with 20 people |

## Kill / continue gate
Continue investment only if **V-01 ≥ 40%** and **V-07 ≥ 50%** in the first beta. If V-01 < 20% after one round of UX fixes, STOP (per mission pivot policy: one pivot remains, e.g. maintenance evidence timeline, but only if its own evidence justifies it).
