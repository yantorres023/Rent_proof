# Product Strategy: Move-In Record (codename RentProof)

_2026-09-25. Decision basis: research/RED_TEAM.md §4, research/EVIDENCE_LEDGER.md, DECISIONS D-002…D-006._
_Every user-level statement here is **UNVALIDATED_WITH_REAL_USERS** unless it cites a source._

## 1. Positioning in one line
A free, private, guided walkthrough that turns move-in day into a **dated condition report you send to your landlord**. You repeat and compare it when you move out.

## 2. Exact ICP (initial)
- **Who:** US renters aged 18–34, especially students and first-time renters, moving into an apartment or shared house with a security deposit (median deposit ~$795; see research/MARKET.md).
- **Where:** United States. English. Product copy is not state-specific.
- **When (trigger):** the first 72 hours after getting the keys (move-in), and the last week before handing them back (move-out).
- **Situation:** stressed, time-poor, standing in an empty unit with a phone. They may have been given a landlord checklist, or nothing at all.
- **Excluded for V1:** landlords and property managers, UK inventory clerks, commercial leases, and multi-user households needing shared editing.

## 3. Jobs to be done (research/JTBD.md)
- **Primary functional job:** "When I move into a rental, help me capture the condition of every room quickly and completely, so that I'm not blamed for damage that was already there."
- **Secondary jobs:**
  1. Send the landlord a record while it is still timely.
  2. Keep the record safe until move-out, which may be years away and on a different phone.
  3. At move-out, show what changed and what didn't.
  4. During the tenancy, document a maintenance problem with dates.
- **Emotional job:** feel prepared and less anxious, and not feel like "the difficult tenant".
- **Social job:** look organized and reasonable to the landlord.

## 4. Core promise
"Record your place on move-in day, send a clear report, and compare when you leave." We never promise outcomes, legal effect or proof (research/LEGAL_CONTEXT.md §5).

## 5. Aha moment
Seeing the generated PDF: every room, photos grouped by prompt, issues listed, with dates and fingerprints. It should arrive a few seconds after tapping "Finish" (HYPOTHESIS).

## 6. Core loop
Property → inspection (move-in) → room → prompt → photo → issue/marker → room done → next room → review → finish → **report → send to landlord → export backup**. Months later: move-out inspection with the move-in as baseline → same rooms → compare → report.

## 7. Activation
**Activated user = finished at least one inspection AND generated a report.**
**Strong activation = also marked the report as sent to the landlord, or exported the evidence package.**

## 8. North Star (candidate)
**Completed documented inspections per month:** inspections finished with at least one photo in at least 80% of their rooms and a generated report.

## 9. Retention hypothesis
This is not a daily-use app. Healthy looks like:
1. Activation within 72 h of install.
2. A backup exported.
3. The app kept installed until move-out (1–5 years later).
4. A second inspection (move-out) that uses the first as baseline.

The maintenance inspection type is an optional mid-tenancy hook (HYPOTHESIS). Retention will be measured in tenancies, not DAU.

## 10. Monetization hypothesis
V1 is free (D-005). Later test: a free core plus a $9.99 one-time Move-Out Pack per property, vs a $14.99 lifetime unlock (business/MONETIZATION.md). No subscription.

## 11. Acquisition channels (business/GROWTH.md)
1. SEO and answer content on move-in checklists and deposits. State pages only after primary-source verification.
2. Intermediaries: university off-campus housing offices, student legal services, tenant unions, legal-aid pages that already tell tenants to "take photos". The ask is a link in their move-in checklist.
3. Short-form video showing a real walkthrough (no fabricated outcomes).
4. Referral from the shared report: the PDF footer names the app, with no ad language.

Paid acquisition is ruled out (estimated cost per payer is ~15x revenue per payer).

## 12. Differentiation versus existing apps (research/COMPETITORS.md)
The category is crowded, so features alone won't win. What we bet on:
1. **Honest claims.** No "legal-ready" or "court-proof" language. Limitations are printed in every report. Intermediaries such as legal aid and universities can recommend it without embarrassment.
2. **Android and iOS.** The name-conflicting competitor is iOS-only.
3. **Delivery step.** "Send to landlord" is a first-class action, and the sent date is recorded. This addresses the weakness of device timestamps (research/LEGAL_CONTEXT.md).
4. **Durable evidence package.** A ZIP with unchanged originals, a manifest and SHA256SUMS, verifiable with standard tools. It survives a phone change.
5. **Free core**, private by default, no account.

## 13. Primary risks
| Risk | Type | Mitigation now | Test later |
|---|---|---|---|
| Renters don't care until it's too late | Market | Onboarding framing; intermediaries reach renters at lease signing | Channel test (VALIDATION_DEBT V-08) |
| Walkthrough is too long and gets abandoned | UX | Small, skippable prompts; "not in this unit"; finish is allowed with gaps | Completion-time study (V-02) |
| Nobody pays | Monetization | Free V1; pack only at move-out | Price test (V-06) |
| Data lost before move-out | Product/tech | Evidence package export; backup prompt on the report screen | Backup rate (V-05) |
| Name/trademark conflict | Legal | Provisional descriptive name | Owner clearance (HUMAN_ACTION) |
| Over-claiming legal value | Legal | Claims policy, limitations in app and PDF | Copy review by counsel |

## 14. Scope control: never in this product (without a new strategy decision)
Property-management software, landlord CRM, rent payments, maintenance marketplace, tenant social network, legal-advice chatbot, insurance, generic AI assistant.

## 15. Assumptions requiring real-user testing
See research/VALIDATION_DEBT.md. The top five are: completion of the guided walkthrough, perceived value of the PDF, willingness to send it to the landlord, backup behavior, and willingness to pay at move-out.
