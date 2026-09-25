# MONETIZATION

_2026-09-25. Sources → `docs/research/SOURCES_REDTEAM.md`. No willingness-to-pay data from real users exists. Every price below is a HYPOTHESIS anchored on competitor prices._

## 1. Constraints that shape pricing

### 1.1 The frequency problem
- **FACT.** In 2023, 25.6% of renters had moved within the past 12 months, and about a third had stayed 5+ years (17% for 5–9 years, 16.6% for 10+) (Redfin analysis of Census data) [42]. Census reported a renter mover rate of 21.7% in 2017, down from 35.2% in 1988 [43]. A median renter tenure figure was **not found** in this session (to check: AHS "year moved in" tables).
- **INFERENCE.** For a typical user, move-in and move-out are 1–5 years apart. The app has about two high-value moments per tenancy, plus optional mid-tenancy maintenance events. **A subscription charges for months in which nothing happens.** Expect churn right after move-in and resentment at renewal.

### 1.2 Competitor prices (all FACT from search extracts; verify on store pages before publishing)
| Product | Side | Model | Price | Src |
|---|---|---|---|---|
| Rentproof (iOS) | Renter | One-time | **$4.99** | [59] |
| Tenant Inspect | Renter | One-time | **$19.99** | [69] |
| DepositGenie | Renter | Free tier + pay once per property | **$12.99–$29.99** | [68] |
| MoveSnap | Renter | Free + one-time Pro unlock | price not found | [67] |
| RentersProof | Renter | Free + subscription | **$7.99/mo or $59.99/yr** | [64] |
| Deposit Defender (UK app) | Renter | Subscription, 7-day trial | **£9.99/mo or £95/yr** | [72] |
| StampCam (timestamp camera) | General | Subscription or one-time | $1.99/mo, $9.99/yr, $11.99 Pro | [75] |
| RentCheck | Landlord/PM | Per unit per month | **$1–$1.25/unit/mo** | [73] |

**INFERENCE.** The renter one-time band is $5–$30, and the most direct substitute (with our name) is $4.99. Subscription competitors exist, but no evidence was found that they convert or retain.

### 1.3 Store economics
- **Apple, FACT.** App Store Small Business Program: **15% commission** for developers with up to $1M in proceeds in the prior calendar year. New developers qualify. You must enroll and list associated accounts [45].
- **Google, FACT (platform blog + help center, 2026).** Since **June 30, 2026** in the US, UK and EEA, Google Play splits its fee into a **service fee** (10% on the first $1M of annual earnings and on all auto-renewing subscriptions) plus a **5% billing fee** when Google Play Billing is used. Alternative billing and external links are allowed, without the 5% billing fee. Program rate cards (Apps Experience, Games Level Up) start September 30, 2026 [46][47][48][102]. **INFERENCE:** the effective rate is about 15% on Google Play Billing for a small developer, the same as Apple. **NEEDS_CURRENT_POLICY_VERIFICATION** before modeling, because this changed three months ago.
- **INFERENCE.** Net per $9.99 sale ≈ $8.49 before tax effects.

### 1.4 Acquisition economics
- **FACT (secondary).** Utilities-category CPI is about $2.90 in the US; utility/lifestyle apps on iOS run $2–4 [79]. Median freemium download-to-paid is 2.2% [80].
- **INFERENCE.** Cost per payer through paid acquisition ≈ $130, while revenue per payer is ≈ $8.50. **Paid UA does not work at any price in the observed band.** Growth must be organic.

## 2. Model evaluation

| Option | Description | For | Against | Verdict |
|---|---|---|---|---|
| **A. One-time inspection purchase** | Pay per report (e.g., $2.99 per move-in or move-out report) | Maps to the value moment | A paywall *at move-in* competes with the free camera, and users under-value move-in (§RED_TEAM 1.12). Nickel-and-diming feels bad | **Reject for move-in**; acceptable only as an add-on |
| **B. Property pack (per tenancy)** | One purchase unlocks move-out mode, side-by-side comparison, dispute packet and unlimited exports for one property | Aligns with deposit-at-stake value. Matches DepositGenie's structure [68]. Payment happens at move-out, the peak of fear | 12–60 months before first payment. Possible churn/uninstall first | **Recommended primary** |
| **C. Premium export** | Free report with basic layout; pay for the "complete" PDF (full-res appendix, hash manifest, comparison) | Easy to understand | A watermarked or crippled move-in report hurts the core promise and trust | **Fold into B** (no crippled move-in report) |
| **D. Annual subscription** | $/yr | Predictable revenue | Frequency problem (§1.1). Only RentersProof/Deposit Defender use it, with bundled "rights Q&A" we won't provide. Users resent paying for idle years | **Reject** |
| **E. Freemium** | Free core + paid pack | Necessary to compete with the camera and the $4.99 competitor | Low conversion (2.2% median [80]) | **Recommended** as the frame for B |
| **F. Moving bundle** | Partner-paid or co-branded (movers, renters insurance, universities) | Could remove the price objection entirely | Needs outreach and partners. Out of scope for V1 (no outreach permitted now) | **Later hypothesis** |
| (G) Lifetime unlock | One-time for all properties | Simple, and the most common indie model (Rentproof $4.99, Tenant Inspect $19.99) | Caps revenue per user | **Test as an alternative to B** |

## 3. Recommended pricing hypothesis (V1)
- **Free forever:** unlimited guided capture for one active property, issue notes, move-in PDF report, hash manifest, "send to landlord" email, local export/backup, and deadline reminders. No watermark on the move-in report.
- **Paid, "Move-Out Pack" per property: $9.99 one-time (HYPOTHESIS).** Includes the move-out walkthrough, the side-by-side move-in vs move-out comparison PDF, a dispute packet (timeline of sends, full-resolution appendix), and multiple properties.
- **Alternative test: lifetime unlock at $14.99** (all properties, all future moves).
- **Rationale (INFERENCE).** $9.99 sits inside the observed band [59][68][69], is priced against a deposit that is often about a month's rent [7][20], and nets about $8.49 after a 15% store fee.
- **Implementation note.** Use non-consumable or consumable IAP per property through the stores (StoreKit / Play Billing). Local-only means purchase restore works through the store receipt. No account needed.

## 4. Expected objections (from users) and responses
| Objection | Response in product/copy |
|---|---|
| "My camera is free" | The core *is* free. You pay only when you want the move-out comparison. |
| "Another subscription?" | No subscription. One payment per move. |
| "Will this guarantee my deposit?" | No. We never promise outcomes. It helps you keep an organized, dated record. |
| "Is my data uploaded?" | No. It stays on your device. (Say this only if analytics and crash SDKs don't upload content; see STORE_POLICY_NOTES.) |
| "I already moved in without it" | Move-out mode works on its own. You can also import existing photos via the system picker (dates are shown as "imported", not "captured"). |
| "$4.99 app does the same" | HYPOTHESIS: free core + deadline kit + dated send is better value. Must be validated. |

## 5. What to test later (no ads purchased now)
1. Pack vs lifetime price (e.g., $6.99 / $9.99 / $14.99), once there is organic traffic.
2. Paywall timing: at move-out start vs at comparison export.
3. Share of free users who reach move-out at all (retention through the tenancy). This is the biggest unknown.
4. Whether a maintenance log creates mid-tenancy engagement.
5. Partner-paid model (F): would universities, renters insurers or movers pay or co-brand? Requires outreach later.
