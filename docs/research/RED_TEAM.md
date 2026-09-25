# RED TEAM — Why RentProof should NOT exist

_2026-09-25. Goal: try to kill the idea with evidence. Source numbers → `SOURCES_REDTEAM.md`. Labels: FACT / INFERENCE / HYPOTHESIS. No user interviews were conducted; nothing here is validated with real users._

Verdict scale: **FATAL** (kills the idea as specified) · **SERIOUS** (the idea survives only if the product is designed around it) · **MANAGEABLE** (a known mitigation exists) · **WEAK** (the objection mostly fails).

---

## 0. Biggest finding: the exact product (and the exact name) already exists

- **FACT.** An iOS app literally named **"Rentproof"** (getrentproof.app) offers room-by-room timestamped, GPS-tagged photos, a 12-point move-in checklist, a **side-by-side move-in/move-out slider**, a "legal-ready" PDF export, an Apple Watch lease countdown, and "photos never leave your device". It costs **$4.99 one-time, no subscription** [59].
- **FACT.** Other renter-side apps with overlapping features were found in this session:
  - **MoveProof**: at least 2 iOS apps and 1 Android app under that name; room-by-room, PDF, "nothing is uploaded" [65]
  - **MoveSnap**: timestamped photos, PDF reports, one-time Pro unlock, "Dispute Evidence Bundle" [67]
  - **DepositGenie**: renter-only, PDF with **hashed files**, pay once per property **$12.99–$29.99**, free tier [68]
  - **Tenant Inspect**: **$19.99** one price [69]
  - **door.lease**: renter-first, room order, share by link/PDF [70]
  - **RentersProof**: free tier plus Pro **$7.99/mo or $59.99/yr** [64]
  - **RentProof AI** (App Store, India) [62]
  - **Deposit Defender**: 2020 US app [71]; a UK app of the same name charges **£9.99/mo or £95/yr** [72]
  - **MyWalkThru** [74]
  - Landlord-paid tools with tenant-guided capture, e.g. **RentCheck** at $1–1.25/unit/month [73]
- **INFERENCE.** Every V1 feature in the RentProof spec (guided capture, notes, SHA-256, app timestamp, PDF, side-by-side, local-only) is already shipped by at least one app. SHA-256 hashing is shipped by DepositGenie; local-only and the side-by-side slider are shipped by the app that holds our name. **The feature set alone is not a differentiator.**

---

## 1. Objections, evidence, verdicts

### 1.1 "Tenants just use their phone camera (free), plus Google Photos albums with timestamps"
- **For the objection (FACT):** Courts' self-help, tenant unions and universities all tell renters to *just take photos/videos* (timestamped) and email them [5][36][37][84]-[91]. The camera is free and already installed. Google Photos keeps originals with EXIF [78].
- **Against (FACT + INFERENCE):** Legal-aid advice is a *checklist of chores* (every room, closets, appliances, close-ups, sign/date, send to landlord, keep for the tenancy). Camera rolls don't structure or pair move-in vs move-out, and don't produce a report to send. Google Photos users report shared-album downloads **resetting creation dates** [78], so an ad-hoc cloud album can weaken date evidence. Photos get lost in 2,000-photo camera rolls over a 1–5 year tenancy (INFERENCE).
- **Verdict: SERIOUS.** The free camera is the real competitor. RentProof has to be **free for capture and a basic report**, and its value has to come from organization, completeness prompts, pairing, the report, and the dated send. If the core is paywalled, users will just use the camera.

### 1.2 "Landlord checklists are sufficient (many states mandate them)"
- **For:** WA, KY, GA, MI, AZ, VA, MA, and MD (on request) require or define landlord checklists or condition statements. CA now requires landlord photos [11][14]-[23][1]-[4]. In KY/GA the signed list is "conclusive evidence" except for latent defects [16][17].
- **Against:** Many states have no mandate. In mandate states, the *tenant* still has to notice defects and write dissents or supplemental lists within short windows (MI 7 days, MA 15, VA 5, MD 15) [23][14][18][19]. Landlord-authored documents reflect the landlord's view. KY/GA's "conclusive" rule is a reason to be *thorough before signing*, which is exactly the job the app does.
- **Verdict: MANAGEABLE.** Position the app as the tool that helps you complete, check, and dissent from the landlord's checklist on time. Do not position it as a replacement.

### 1.3 "Low frequency → poor retention" / "used only twice"
- **For (FACT):** 25.6% of renters moved within 12 months in 2023. Share staying 5–9 years rose to 17% and 10+ years to 16.6% (Redfin analysis of Census data) [42]. The renter mover rate was 21.7% in 2017 vs 35.2% in 1988 [43]. Median tenure not found directly: NOT FOUND. **INFERENCE:** move-in and move-out are typically 1–5 years apart, and many users open the app about twice per tenancy.
- **Against:** Retention is the wrong metric for an evidence tool. What matters is (a) the data surviving until move-out and (b) re-engagement at the right moment (lease end, notice to vacate, maintenance issues). A maintenance/issue log adds mid-tenancy use (HYPOTHESIS; unvalidated).
- **Extra risk found by red team: data loss (INFERENCE, SERIOUS).** Local-only storage over 1–5 years collides with phone replacement, loss, or app deletion. If the evidence is gone at move-out, the product failed at its only job. Without cloud, V1 needs user-controlled export/backup (ZIP/PDF to Files/Drive/email) and reminders to do it.
- **Verdict: SERIOUS.** Kills subscriptions (see MONETIZATION). Survivable with per-move pricing, exportable archives, and scheduled reminders (local notifications at lease end).

### 1.4 "People won't pay"
- **For (FACT):** The price band is already set low by direct substitutes: $4.99 one-time [59], $19.99 [69], $12.99–29.99 per property [68]. The camera is free. RevenueCat's 2025 benchmark: median download-to-paid is **2.2% for freemium vs 12.1% for hard paywalls** (all categories, subscription apps) [80]. **No public revenue figures were found for any renter-side documentation app.** No evidence was found that any of them sustains a business.
- **Shutdowns:** A search for shut-down tenant inspection apps returned no documented shutdowns [search in session]. Absence of evidence is not evidence of success: small apps die quietly. **Deposit Defender** (2020 PR [71]) moved to also serve property managers by 2021 [71]. **INFERENCE:** that pivot toward the landlord side hints the renter-only market was not enough for them (weak signal, one case).
- **Against:** Money at stake is concrete. Deposits are typically about one month's rent, and CA and MD caps are 1 month [7][20]. Surveys (vendor/old, weak quality) suggest disputes are common: Rent.com 2013, 26% denied their deposit [82]; Roost 2021 member survey, about 42% got the full deposit back [81]. A $5–15 one-time price against a deposit worth hundreds to thousands of dollars is an easy ROI story, *at the moment of fear* (move-out or dispute).
- **Verdict: SERIOUS.** Willingness to pay is **UNVALIDATED_WITH_REAL_USERS**. Expect low conversion and one-time purchases only.

### 1.5 "Competitors already solve it"
- **Evidence:** §0 above. At least 9 renter-side apps, several launched 2025–2026, some with identical positioning.
- **Against:** Almost all are tiny indie apps. Nothing found shows any has category leadership, search dominance, or meaningful distribution (INFERENCE from the lack of press, reviews, or revenue data; not verified with store ranking data). Room exists for a *better-executed* free option, or one that ties capture to **state-specific deadlines** and the **landlord delivery** step.
- **Verdict: SERIOUS**, bordering FATAL for a me-too V1. It is **FATAL for the name "RentProof"** (see NAME_CHECK.md).

### 1.6 "Legal usefulness is overstated"
- **For (FACT):** Ordinary photos plus testimony already meet the authentication bar (FRE 901 "fair and accurate", low bar) [25][26]. Small claims rules of evidence are relaxed or suspended [29]-[31]. Courts tell tenants to bring photos with timestamps or a witness [5][6]. An app adds **no admissibility**.
- **Against:** The problem in practice is **not having the photos, or not finding them**, not admissibility. Organized, complete, paired, dated-and-sent documentation plausibly helps settle disputes before court (HYPOTHESIS; unvalidated).
- **Verdict: SERIOUS for marketing** (any "court-ready / legal proof" claim is overstated and risky; see LEGAL_CONTEXT §5). **MANAGEABLE for the product** (the value is organization and timeliness).

### 1.7 "Photo timestamps are unreliable, EXIF is editable"
- **For (FACT):** EXIF dates can be rewritten in seconds with free tools [34][35]. SFTU says some judges may not accept camera date stamps [36]. The app's own timestamp uses the device clock (INFERENCE), and a SHA-256 hash stored locally proves integrity, **not time** [27][28].
- **Against:** A third-party time anchor fixes this cheaply: email the report or hash manifest to the landlord (and to yourself) at move-in. That creates a record held by others. Stronger options exist later: RFC 3161 TSA, or C2PA/ProofMode-style signing [76][77].
- **Verdict: MANAGEABLE**, if the product makes "send it now" the core step and never claims hashes prove time.

### 1.8 "Storage costs"
- **Verdict: WEAK** for V1 (local-first, no server). The real cost is **on-device storage** (video is heavy) and the data-loss risk (§1.3), not server spend.

### 1.9 "Landlords won't trust tenant reports" / "landlords refuse to sign"
- **For:** No state found requires a landlord to *sign* a tenant-made report. Landlords can ignore it (INFERENCE).
- **Against (FACT):** Some statutes already give weight to tenant submissions. In VA, a tenant-prepared move-in report is deemed correct unless the landlord objects in writing within 5 days (where the landlord has that written policy) [18]. In MA the landlord must respond within 15 days to a tenant's damage list [14][15]. In MI, the tenant completes and returns the checklist [23]. KY/GA give tenants a written-dissent mechanism [16][17]. Tenant groups say that if the landlord won't sign, take photos and use witnesses [36]. The report's value does not depend on the landlord's agreement. What matters is that it was **delivered on a date** and **exists**.
- **Verdict: MANAGEABLE.** Never promise acceptance. Design for delivery, not signature. Optional "landlord acknowledged" field.

### 1.10 "Acquisition cost too high"
- **For (FACT, secondary data):** Utilities-category CPI is cited around **$2.90** (US iOS utility/lifestyle $2–4) [79]. **INFERENCE:** at a 2.2% freemium download-to-paid rate [80], cost per paying user ≈ $2.90 / 0.022 ≈ **$130**, against a $5–15 one-time price. **Paid acquisition is uneconomic** by an order of magnitude.
- **Against:** Organic channels exist where renters are already told to "take photos": universities, legal aid, tenant unions, SEO for "move in checklist". See GROWTH.md.
- **Verdict: SERIOUS.** Organic/SEO/partnership only. No paid UA until the unit economics are measured.

### 1.11 "Weak store demand"
- **Evidence:** No keyword-volume data was obtainable in this session (no ASO tool access). The existence of about 9 recent entrants suggests builders *perceive* demand. It does not prove demand. **UNVALIDATED.**
- **Verdict: UNVALIDATED (treat as SERIOUS until measured).** Before building more, measure App Store and Google Play search-term popularity (Apple Search Ads popularity scores, Google Trends) for "move in checklist", "security deposit", "rental inspection".

### 1.12 "Users don't care until it's too late"
- **For:** Legal aid, universities, and tenant unions spend effort telling people to document *before* move-in [84]-[91][36], which implies many don't. Anecdotes of renters who were charged and had (or lacked) photos appear in news and forums [83]. The motivation peak is at move-out or dispute, when move-in evidence can no longer be created (INFERENCE).
- **Against:** The failure mode is also an acquisition moment. A renter burned once documents the *next* move, and their friends hear the story (HYPOTHESIS). Move-out documentation alone still has value (proof of clean condition at handover) [5][36].
- **Verdict: SERIOUS.** Distribution must reach people in the **lease-signing → first-week window** (universities in Aug/Sep, moving checklists, listing sites), and the app must also serve late arrivals (move-out-only mode).

---

## 2. Scorecard

| # | Objection | Verdict |
|---|---|---|
| 0 | Same product and same name already on the App Store | **FATAL (name)** / SERIOUS (product) |
| 1.1 | Free camera | SERIOUS |
| 1.2 | Landlord checklists suffice | MANAGEABLE |
| 1.3 | Low frequency / used twice (+ local data-loss risk) | SERIOUS |
| 1.4 | Won't pay | SERIOUS |
| 1.5 | Competitors solve it | SERIOUS (near FATAL for a me-too) |
| 1.6 | Legal usefulness overstated | SERIOUS (marketing) / MANAGEABLE (product) |
| 1.7 | Timestamps / EXIF unreliable | MANAGEABLE |
| 1.8 | Storage cost | WEAK |
| 1.9 | Landlords distrust or refuse | MANAGEABLE |
| 1.10 | CAC too high | SERIOUS |
| 1.11 | Weak store demand | UNVALIDATED |
| 1.12 | Too late to care | SERIOUS |

No FATAL objection to the *problem*: the need to document condition is backed by statutes, courts, and legal aid. There is one FATAL objection to the *name*, and a cluster of SERIOUS objections to a *paid, me-too, subscription* version.

---

## 3. Recommendation: **PIVOT** (not STOP, not GO-as-specified)

**Reasoning.** The problem is real and officially recognized: statutes build whole procedures around move-in condition records, and courts and legal aid tell tenants to take photos. But:
1. The specified V1 is already shipped, under our name, at $4.99.
2. The free camera sets the price anchor near zero.
3. Low frequency rules out subscriptions.
4. Paid acquisition is roughly 10x too expensive for the price point.

A generic "RentProof" is a commodity with no moat. **STOP** would be right if the goal is a venture-scale standalone business: nothing found supports that. **PIVOT** is right for a low-cost, local-first indie product, *if* the product changes as follows.

### Strongest pivot within renter + condition + documentation
**"Move-in Checklist & Deposit Deadline Kit"**: a *free* guided inspection that is built around the tenant's **own legal clock and delivery step**, not around "proof" claims:
1. **State-aware timeline** (information with citations, not advice): at setup, the user picks a state and sees, for example, "MI: return checklist within 7 days", "MA: separate damage list within 15 days", "VA: objections within 5 days", "MD: request a move-in inspection by certified mail within 15 days", "NY: landlord must itemize within 14 days", "CA: 21 days". Each item links to the official statute. Local notifications fire before each deadline.
2. **Checklist-completer:** mirror the landlord's form (WA/MI/KY/GA/AZ style rooms and items), attach photos per item, and produce a "tenant's supplemental list / dissent" PDF.
3. **Dated send:** a one-tap email of the PDF plus a hash manifest to the landlord (and a cc to self). This is the one feature that turns a weak device timestamp into a third-party-held record.
4. **Tenancy vault that survives phones:** export/import archive, and reminders at lease end.
5. **Move-out mode + comparison:** a pre-move-out walkthrough, then side-by-side pairing and a "condition at handover" report. **This is where payment happens**, at peak motivation.
6. **Maintenance evidence timeline** as an optional mid-tenancy hook (issue log with dates and photos) to reduce the "used twice" problem. HYPOTHESIS; test later.

### What the product must do to survive the strongest objections
- **Free core** (capture, organize, move-in report, dated send) so it can compete with the camera.
- **Never claim** court-proof, tamper-proof, guaranteed, or legal-ready (LEGAL_CONTEXT §5).
- **Pay once per tenancy/move**, at move-out or comparison. No subscription.
- **Rename** before any public artifact (store listing, domain, social).
- **Organic distribution only**, timed to lease signing (see GROWTH.md).
- **Kill/continue gate (HYPOTHESIS to test, no ads purchased):** measure store search popularity and landing-page intent before adding paid features. If fewer than a pre-agreed share of users complete a move-in report and send it, the free core is not delivering value and the idea should STOP.

---

## 4. Lead decision (2026-09-25): **PIVOT #1, then continue to implementation**

The lead accepts the red team's PIVOT recommendation with one change.

**Accepted:**
- Free core; never make proof or legal claims.
- A dated send to the landlord as the answer to "timestamps are weak".
- A durable evidence package that survives a phone change.
- Move-out comparison.
- Rename before any public artifact.
- Organic and intermediary distribution only.
- A kill gate based on move-in report completion and send rate.

**Changed:** the state-by-state deadline timeline with notifications is **deferred** (BACKLOG, gated). The deadlines were collected from search summaries marked `VERIFY_PRIMARY_TEXT`. Shipping wrong legal deadlines, with reminders the user relies on, could cause real harm and could look like legal advice. V1 shows only a generic, accurate prompt: "Your lease or local law may set a short deadline for move-in condition records. Check it." It then helps the user send the record promptly.

**Why not STOP:** the problem is structurally real (A2/L1 SUPPORTED) and the top of the funnel is large (A8). The failure mode of existing apps looks like distribution and trust, not proof that the need is absent. None of that can be tested without a working artifact, and the MVP is cheap to build. The STOP criterion moves into VALIDATION_DEBT.md as an explicit kill gate.

**Why not GO-as-specified:** the specified product already exists under our name ([getrentproof.app](https://www.getrentproof.app/)) and in several near-copies. Building it as specified adds nothing.

**Pivot definition (pivot #1 of the 2 allowed):** *"Move-in record kit for US renters."* A guided room-by-room walkthrough in the first days after getting the keys produces a dated condition report the renter sends to the landlord. The originals are kept in an exportable evidence package, and the same walkthrough is repeated and compared at move-out. It is free, private (on-device), and available on Android and iOS.
