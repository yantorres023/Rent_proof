# EVIDENCE LEDGER (consolidated)

_Last updated 2026-09-25. Maintained by the lead._

This is the master ledger. The full entries (supporting evidence, contrary
evidence, source links, source types and dates, falsification tests) are in:

- [EVIDENCE_LEDGER_MARKET.md](EVIDENCE_LEDGER_MARKET.md): A1–A9 (market, competitors, users)
- [EVIDENCE_LEDGER_REDTEAM.md](EVIDENCE_LEDGER_REDTEAM.md): L1–L6 (legal, pricing, retention, distribution)
- Sources: [SOURCES.md](SOURCES.md) and [SOURCES_REDTEAM.md](SOURCES_REDTEAM.md)

## How this research was done (read first)

- **There were no interviews, surveys or usability tests.** Every user-level conclusion is **UNVALIDATED_WITH_REAL_USERS**.
- The egress proxy blocked most page fetches (government, legislature, court, app-store and Reddit pages). Most findings therefore come from **search-engine result summaries** of the cited pages, not from the primary text. Research agents marked statute details `VERIFY_PRIMARY_TEXT`. Nothing here should go into product copy or legal statements until someone reads the primary source.
- Commercial surveys (Zillow, Opinium for Generation Rent, and similar) are rated LOW–MEDIUM quality. Where several articles repeat one figure, it counts as one piece of evidence.

## Consolidated status

| # | Assumption | Confidence | Status | Decision impact |
|---|---|---|---|---|
| A1 | Renters lose deposit money at move-out | MEDIUM (it happens) / LOW (how much is unfair) | SUPPORTED / WEAK | Problem exists, but the size of the *contestable* loss is unknown |
| A2 / L1 | Documentation helps in disputes | MEDIUM-HIGH (structurally: statutes, adjudication on paper, legal-aid advice) / LOW (effect size, and what an app adds beyond the camera) | SUPPORTED / WEAK | The product must add organization, timeliness and delivery, not "proof" |
| A3 | Renters fail to document adequately | LOW | WEAK / UNVALIDATED_WITH_REAL_USERS | Key validation debt |
| A4 | No good tenant-first app exists | MEDIUM | **CONTRADICTED** as a feature gap (≥10 renter apps exist); WEAK as a distribution gap | Features alone cannot differentiate |
| A5 | Renters will complete a guided capture | LOW | UNVALIDATED_WITH_REAL_USERS | First beta test |
| A6 / L2 | Renters will pay (~$5–10 once) | LOW | UNVALIDATED_WITH_REAL_USERS | No payments in V1; test later |
| A7 / L5 | Timestamps and hashes are legally meaningful | HIGH that hashes prove integrity only, not time | **CONTRADICTED** as "proof of time" / SUPPORTED as a fingerprint plus a dated send | Claims policy; add "send to landlord" step |
| A8 | Market size is adequate | HIGH (top of funnel: ~44.6M US renter-occupied units) / LOW (paying segment) | SUPPORTED / UNVALIDATED | Big enough for an indie or free product; no evidence of venture scale |
| A9 | "RentProof" name is usable | HIGH that a conflict exists | **CONTRADICTED** | Rename before any public artifact |
| L3 | Users keep the app through the tenancy | MEDIUM (facts) / LOW (assumption) | WEAK / UNVALIDATED | Evidence package export so data survives a phone change |
| L4 | Landlords accept tenant reports | MEDIUM that delivery matters / LOW acceptance | WEAK / SUPPORTED | Position as "your record, delivered on time", not "binding" |
| L6 | Cheap organic distribution is possible | LOW | UNVALIDATED_WITH_REAL_USERS | Paid acquisition is ~10x too expensive; intermediaries plus SEO |

## Lead's reading

FACT: The legal and administrative system is built around documented property condition (move-in checklist statutes in several US states; paper-based deposit adjudication in England; condition-inspection reports in BC). Official and legal-aid guidance tells tenants to photograph the unit. *(Primary texts still to be verified.)*

FACT: Renter-side documentation apps are a crowded, low-price category (roughly $0–$20 one-time) with no visible traction.

INFERENCE: The unmet need is not features. It is (a) reaching renters in the 0–72 h move-in window, (b) trust (honest claims, privacy), (c) getting the record to the landlord promptly, and (d) keeping the record until move-out, 1–5+ years later.

HYPOTHESIS: A free, honest, cross-platform (Android + iOS) guided record, with a dated send and a durable evidence package, distributed through trusted intermediaries (student housing offices, legal aid, tenant unions) and SEO, can reach meaningful completion rates. **UNVALIDATED_WITH_REAL_USERS.**
