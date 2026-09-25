# EVIDENCE LEDGER — Red team / legal / business

_2026-09-25. Source numbers → `SOURCES_REDTEAM.md`. No user research has been conducted. Any claim about user behavior is at best UNVALIDATED_WITH_REAL_USERS. Search-extract caveat applies to all sources (see SOURCES header)._

---

### L1. Legal usefulness of documentation
- **ASSUMPTION:** Organized, dated move-in/move-out documentation materially helps renters in deposit disputes.
- **SUPPORTING EVIDENCE:** Statutes build procedures around move-in condition records: WA checklist (no checklist means the full deposit is owed) [11]; KY/GA signed damage lists are "conclusive" except latent defects [16][17]; MA 15-day tenant list [14]; MI 7-day checklist [23]; VA 5-day report [18]; MD 15-day inspection request [19]; CA landlord photos (AB 2801) [1]-[4]. CA courts tell tenants to bring timestamped photos or a witness [5][6]. Legal aid, tenant unions and universities tell renters to photograph and send [36][37][84]-[91]. NY puts the burden of proof on the landlord [24].
- **CONTRARY EVIDENCE:** Ordinary phone photos plus testimony already meet the authentication bar (FRE 901 "fair and accurate") [25][26]. Small claims hearings are informal [29]-[31]. An app adds no admissibility. KY/GA landlord lists signed by the tenant can be conclusive *against* the tenant [16][17].
- **SOURCE LINKS:** [1]-[6], [11], [14], [16]-[19], [23]-[26], [29]-[31], [36], [37], [84]-[91]
- **SOURCE TYPE:** Statutes (official or mirrors), court self-help, legal aid, university, academic
- **SOURCE DATE:** 2012–2026 (statutes current as extracted)
- **CONFIDENCE:** High that documentation matters. **Low** that an *app* adds legal value beyond the camera.
- **STATUS:** SUPPORTED (documentation matters) / WEAK (app-specific legal value)
- **WHAT WOULD FALSIFY IT:** Court/ADR data showing deposit outcomes don't differ with tenant documentation, or users finding the camera plus email just as effective in practice (usability test comparing completeness).

### L2. Willingness to pay
- **ASSUMPTION:** Renters will pay about $10 once per move for move-out comparison and report features.
- **SUPPORTING EVIDENCE:** Competitors charge $4.99 [59], $12.99–29.99 per property [68], $19.99 [69], $59.99/yr [64]. Deposits are typically capped at 1 month in CA/MD [7][20], so the stake is large relative to the price. Vendor surveys: 26% denied deposit (Rent.com, 2013) [82]; ~42% got the full deposit back (Roost members, 2021) [81]. Both are weak-quality.
- **CONTRARY EVIDENCE:** No revenue or download data for any renter documentation app was found. The free camera is the default. Median freemium download-to-paid is 2.2% [80]. The lowest-priced direct substitute is $4.99 [59]. Deposit Defender added a landlord offering within about 6 months of its renter launch [71] (weak signal).
- **SOURCE LINKS:** [59], [64], [68], [69], [71], [80]-[82], [7], [20]
- **SOURCE TYPE:** Vendor pages, store listings, vendor surveys, industry benchmark
- **SOURCE DATE:** 2013–2026
- **CONFIDENCE:** Low
- **STATUS:** UNVALIDATED_WITH_REAL_USERS
- **WHAT WOULD FALSIFY IT:** Fewer than ~1–2% of users who reach move-out buying the pack. Price-test pages showing no intent at $4.99–$14.99. Competitor evidence of zero sales.

### L3. Retention / frequency
- **ASSUMPTION:** Users will keep the app and their data through the tenancy and return at move-out.
- **SUPPORTING EVIDENCE:** Lease end is a predictable date, so local notifications can re-engage (INFERENCE). A maintenance log may add mid-tenancy use (HYPOTHESIS).
- **CONTRARY EVIDENCE:** 25.6% of renters moved within 12 months in 2023. About a third stayed 5+ years [42]. The renter mover rate fell from 35.2% (1988) to 21.7% (2017) [43]. So the gap between the two uses is often multi-year. Local-only storage risks loss on phone replacement (INFERENCE).
- **SOURCE LINKS:** [42], [43], [44]
- **SOURCE TYPE:** Census data (via a Redfin secondary analysis), Census story
- **SOURCE DATE:** 2017, 2024
- **CONFIDENCE:** Medium on frequency facts. Low on the retention assumption.
- **STATUS:** WEAK / UNVALIDATED_WITH_REAL_USERS
- **WHAT WOULD FALSIFY IT:** Cohort data showing most move-in users never open move-out, or reports of lost data after device changes.

### L4. Landlord acceptance
- **ASSUMPTION:** Landlords will receive and, at least implicitly, respect a tenant-generated report.
- **SUPPORTING EVIDENCE:** VA: a tenant-prepared report is deemed correct absent a landlord objection within 5 days (where the landlord has that written policy) [18]. MA: the landlord must respond to a tenant's damage list within 15 days [14][15]. MI: the tenant completes and returns the checklist [23]. KY/GA: a tenant written-dissent mechanism exists [16][17]. Tenant unions: if the landlord won't sign, use photos and witnesses [36].
- **CONTRARY EVIDENCE:** No general legal duty for a landlord to sign or accept a tenant's app report was found. CA landlords now produce their own photo sets [1]-[4], which could crowd out tenant reports. No data on landlord behavior.
- **SOURCE LINKS:** [1]-[4], [14]-[18], [23], [36]
- **SOURCE TYPE:** Statutes, legal aid
- **SOURCE DATE:** current
- **CONFIDENCE:** Medium that *delivery* matters. Low on *acceptance*.
- **STATUS:** WEAK (acceptance) / SUPPORTED (value of delivery in specific states)
- **WHAT WOULD FALSIFY IT:** Landlords or property managers systematically rejecting or ignoring emailed tenant reports *and* those reports carrying no weight in dispute resolution.

### L5. Timestamp / hash trustworthiness
- **ASSUMPTION:** App-recorded timestamps and SHA-256 hashes make the evidence more trustworthy.
- **SUPPORTING EVIDENCE:** Hash matching reliably shows exact copies. FRE 902(14) recognizes hash-based digital identification with a certification [27][28]. ProofMode/C2PA show signed-capture approaches exist [76][77]. DepositGenie markets hashed evidence bundles [68].
- **CONTRARY EVIDENCE:** Device clocks and EXIF are user-editable [34][35]. SFTU says some judges may not accept camera date stamps [36]. A hash stored locally proves no time. Google Photos shared-album downloads may reset creation dates [78].
- **SOURCE LINKS:** [27], [28], [34]-[36], [68], [76]-[78]
- **SOURCE TYPE:** Bar association / court-hosted paper, academic, legal aid, vendor, forum
- **SOURCE DATE:** 2017–2026
- **CONFIDENCE:** High that hashes prove integrity and not time. High that a third-party anchor (email to landlord) is needed for time.
- **STATUS:** CONTRADICTED (as a standalone "proof of time" claim) / SUPPORTED (as an integrity fingerprint plus a dated send)
- **WHAT WOULD FALSIFY IT:** (Of the contradiction) Evidence that courts or ADR give weight to app-internal timestamps without other corroboration.

### L6. Distribution feasibility
- **ASSUMPTION:** The app can reach renters in the lease-signing window cheaply through organic channels.
- **SUPPORTING EVIDENCE:** Universities, legal aid and tenant unions already publish "take photos / checklist" advice, so natural linking partners exist [84]-[91][36][37]. Statutory deadlines give state-specific SEO topics [14][18][23]. Some competitors appear to rely on the same channels (INFERENCE).
- **CONTRARY EVIDENCE:** Paid UA is uneconomic: ~$2.90 utilities CPI [79] and 2.2% freemium conversion [80] give ≈$130 per payer. At least 9 competitors compete for the same terms [59]-[72]. No search-volume data was obtained. Neutral organizations may not recommend a commercial app.
- **SOURCE LINKS:** [36], [37], [59]-[72], [79], [80], [84]-[91]
- **SOURCE TYPE:** University, legal aid, industry benchmark (secondary), vendor/store
- **SOURCE DATE:** 2025–2026
- **CONFIDENCE:** Low
- **STATUS:** UNVALIDATED_WITH_REAL_USERS
- **WHAT WOULD FALSIFY IT:** Negligible store search popularity for core terms. SEO pages failing to rank within 6 months. Zero links from universities or legal aid after (future) outreach.
