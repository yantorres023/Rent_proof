# LEGAL CONTEXT — security deposits, condition documentation, evidence

_Research date 2026-09-25. Source numbers refer to `docs/research/SOURCES_REDTEAM.md`._

> **NOT LEGAL ADVICE.** This is product research by a non-lawyer agent. It exists so the product team knows what the law roughly looks like and which claims the app must never make. Before any state-specific feature ships, a licensed attorney in that state should review it.
>
> **Verification caveat.** Full-page fetches of statute sites were blocked by the network proxy in this session. Statute content below is from search-engine extracts of the cited pages (mostly official legislature sites or Justia/FindLaw mirrors). Every row is marked **VERIFY_PRIMARY_TEXT**: someone must read the current official text before quoting it in-app.

Labels: **FACT** = stated by the cited source; **INFERENCE** = reasoning from facts; **HYPOTHESIS** = untested belief.

---

## 1. United States — state security-deposit law (selected states)

| State | Cap | Return deadline | Move-in condition document | Move-out / itemization | Penalty (tenant remedy) | Sources |
|---|---|---|---|---|---|---|
| **California** (Civ. Code §1950.5) | 1 month's rent for deposits collected on/after **July 1, 2024** (AB 12). Small-landlord exception: up to 2 months if the landlord is a natural person (or an LLC whose members are all natural persons) owning no more than 2 residential properties with no more than 4 units total | **21 days** after the tenant vacates | **Landlord photos (AB 2801):** for tenancies starting **on or after July 1, 2025**, landlord must photograph the unit immediately before or at the start of the tenancy. No statewide tenant-completed checklist mandate found | Itemized statement; receipts/invoices required for deductions of $125 or more (per court self-help extract); **since April 1, 2025** landlord must photograph the unit within a reasonable time after possession returns and before repairs/cleaning, and again after repairs/cleaning, and send photos with the itemized statement when deducting | Court may award statutory damages of **up to 2x the deposit** for bad-faith retention, on top of the deposit | FACT [1][2][3][4][5][6][7][8][9][10]. VERIFY_PRIMARY_TEXT. One low-quality extract [100] says "January 1, 2026"; this conflicts with the landlord-association and law-firm sources [1][3][4] and should be treated as an error unless the official text says otherwise |
| **Washington** (RCW 59.18.260, .280) | No statewide cap found in these sources (NOT VERIFIED) | **30 days** per current secondary sources [13] and the RCW PDF title; older Justia versions (2005-2022) say 21 days. INFERENCE: changed by a 2023 amendment. VERIFY | **Required:** no deposit may be collected unless the rental agreement is written and the landlord gives a **written checklist or statement** of the condition, cleanliness and existing damage (walls, floors, countertops, carpets, drapes, furniture, appliances), **signed and dated by both**, with a copy to the tenant | "Full and specific statement" of reasons for keeping money, with documentation (estimates or invoices) since 2023 | No checklist means the landlord is liable for the full deposit, plus costs and attorney fees. Intentional refusal to give the statement or refund: court may award **up to 2x** | FACT [11][12][13][37] |
| **Massachusetts** (G.L. c.186 §15B) | 1st month's rent (VERIFY) | 30 days (VERIFY) | If a deposit is taken, landlord gives a **statement of present condition**. Tenant may return it with a **separate list of damages within 15 days** (of receiving it or moving in, whichever is later). Landlord must answer that list **within 15 days**, agreeing or stating disagreement | Itemized list of damages, sworn, with evidence of cost (VERIFY) | **Treble damages** for certain violations, plus costs and attorney fees. Not every §15B violation triggers treble damages | FACT [14][15] |
| **Kentucky** (KRS 383.580) | — | — (VERIFY) | Before any deposit is paid, the tenant must be given a **comprehensive list of existing damage** with estimated repair costs. The tenant may inspect before occupancy. Both sign, and the signatures are **conclusive evidence** of the list's accuracy (not of latent defects). A tenant who disagrees must write and sign a statement of dissent | Final damage list required | Landlord may not keep **any** of the deposit if the separate account and the initial and final lists are missing | FACT [16] |
| **Georgia** (O.C.G.A. §44-7-33) | — | — (VERIFY) | Before the deposit is paid: **comprehensive list of existing damage** that the tenant keeps. Tenant may inspect first. Signed by both, with the same "conclusive except latent defects" and written-dissent rules as Kentucky | Tenant may inspect within 5 business days after the tenancy ends. Tenant may dispute the landlord's final list | (VERIFY remedies) | FACT [17] |
| **Virginia** (Va. Code §55.1-1226) | 2 months (secondary sources; VERIFY) | 45 days (secondary sources; VERIFY) | Landlord gives a **written move-in inspection report within 5 days** of occupancy. Tenant may object in writing. **If the landlord has a written policy letting the tenant prepare the move-in report, a tenant-submitted report is deemed correct unless the landlord objects in writing within 5 days** | Tenant may be present at a move-out inspection held within 72 hours of vacating. Written itemized disposition follows | (VERIFY) | FACT [18] (Justia 2025 + secondary extract) |
| **Maryland** (Real Prop. §8-203, §8-203.1) | **1 month** since Oct 1, 2024 (Renters' Rights and Stabilization Act). Exception: 2 months for tenants qualifying for certain utility assistance | **45 days** for the written list of charges | The receipt must tell the tenant they may ask for a move-in inspection, **by certified mail within 15 days** of occupancy, so the landlord writes up existing damage in the tenant's presence | Tenant may attend the move-out inspection if they ask by certified mail at least 15 days before moving. The inspection happens within 5 days of the move date | (VERIFY; historically up to 3x for wrongful withholding) | FACT [19][20][21] |
| **Arizona** (ARS §33-1321) | 1.5 months (VERIFY) | 14 business days (VERIFY) | At move-in, landlord gives a **move-in form for listing existing damage** and written notice that the tenant may attend the move-out inspection | Itemized deductions (VERIFY) | (VERIFY) | FACT [22] |
| **Michigan** (MCL 554.608) | 1.5 months (secondary; VERIFY) | 30 days (secondary; VERIFY) | Landlord must use **inventory checklists at start and end**. At move-in the tenant gets **2 blank copies**, and a bold notice tells them to complete the checklist and return it **within 7 days** of possession | Termination checklist on the same form | (VERIFY) | FACT [23] |
| **New York** (GOL §7-108) | 1 month (VERIFY in text) | **14 days** for itemized statement and refund. If late, the landlord **forfeits** any right to keep any of the deposit | (Landlord may offer a move-in inspection; VERIFY) | Tenant may ask for a pre-move-out inspection, held 1 to 2 weeks before the tenancy ends with 48 hours' notice. **Landlord bears the burden of proof** that the amount kept was reasonable | Forfeiture (see left) | FACT [24] |

**INFERENCE for product.** Four patterns matter:
1. **Deadlines that belong to the tenant:** MI 7 days, MA 15 days, VA 5 days (tenant objection / tenant-prepared report), MD 15 days (certified-mail request). These are the moments the app can support with timely capture plus a "send your list now" workflow. They are the strongest non-legal-advice value.
2. **Landlord-document states** (WA, KY, GA, AZ, CA photos): the landlord's document is the official record. A tenant's dissent or supplemental list is the tenant's leverage, and the app's report can serve as that list.
3. **Burden and penalties** (NY burden on landlord, CA 2x, MA 3x, WA 2x or full deposit): many tenants may have more leverage than they think. The app may link to official sources for this but must not advise on it.
4. **California AB 2801** means CA landlords now make their own photos. That weakens the tenant's information asymmetry, but it also means disputes turn into comparing two photo sets, so a tenant's own contemporaneous set still matters (INFERENCE).

## 2. How ordinary photos are used as evidence (US)

- **FACT.** Federal Rule of Evidence 901(b)(1) lets a **witness with knowledge** authenticate an item. For photos, courts commonly use the "**fair and accurate portrayal**" standard: a witness testifies that the photo fairly and accurately shows the scene as they knew it. Commentators describe the bar as very low, and the witness need not be the photographer [25][26]. States have similar rules (e.g., Pa., N.D., N.C. versions of Rule 901) [25].
- **FACT.** Small claims courts are informal. Virginia suspends the rules of evidence in small claims hearings [29], Indiana Small Claims Rule 8 provides for informal hearings [30], NY City Court Act §1804 is also informal [31], and Arizona court help says hearing officers may still exclude unreliable evidence [33]. The California courts' self-help guide tells tenants they could bring **photos with timestamps** of the clean home, or a friend who saw it, as evidence [5][6].
- **FACT.** Tenant and legal-aid organizations tell tenants to take photos and videos, have landlords sign and date inventories, use witnesses, and **email the photos** to create a dated record. The San Francisco Tenants Union suggests holding up the day's newspaper in photos to prove the date [36][37][13]. University housing and legal-services offices give the same advice [84]-[91].
- **INFERENCE (key red-team point).** Ordinary phone photos plus the tenant's testimony are already the standard, accepted form of evidence in deposit cases. **RentProof does not make photos admissible. They already are.** What the app can realistically add: completeness (nothing forgotten), organization, a readable report, move-in vs move-out pairing, and a **dated delivery** to the landlord.

## 3. What SHA-256 hashing and app timestamps do and do NOT prove

| Claim | True? | Why |
|---|---|---|
| "The file has not changed since the hash was computed" | **Yes, conditionally.** | A matching SHA-256 hash shows two files are bit-for-bit identical. Courts accept hash comparison for exact copies, and FRE 902(14) (Dec 2017) lets data copied from a device be self-authenticated by a qualified person's certification describing a hash-based "process of digital identification" [27][28]. FACT |
| "The photo was taken at time T" | **No.** | The app's timestamp comes from the device clock, which the user can change. EXIF dates can be rewritten in seconds with free tools [34][35]. A hash stored on the same device by the same person proves nothing about **when** it was computed. FACT + INFERENCE |
| "The photo shows the real, unaltered scene" | **No.** | A hash of an already-edited image is just as valid. Hashing covers integrity after capture, not truthfulness of the capture. INFERENCE |
| "Court-proof / tamper-proof / legally binding" | **No.** | Admissibility and weight are decided by the judge. Nothing in the sources supports these words. |
| "Timestamps are independently verifiable" | **Only with a third party.** | An independent time anchor requires something outside the user's control: (a) **emailing the report or hash list to the landlord** (their mail server records receipt), (b) emailing it to oneself (weaker, but provider-held), (c) an RFC 3161 trusted timestamp authority or a C2PA-signed capture (ProofMode, Truepic) [76][77]. The SFTU notes that some small claims judges may not accept camera date stamps because they can be tampered with [36]. FACT (SFTU) + INFERENCE |

**Design implication (INFERENCE).** Present hashes as an **"integrity fingerprint"** that lets anyone check a file later was not modified after it was added to the report. The emphasis should be on sending the report to the landlord promptly, because that is the step that creates a record the tenant cannot have backdated.

## 4. Emailing the report to the landlord as a contemporaneous record

- **FACT.** Tenant organizations and university offices recommend emailing documentation to the landlord the same day, or emailing photos to yourself for a dated record [36][37][84]-[86].
- **FACT.** In Virginia, a tenant-prepared move-in report can be **deemed correct unless the landlord objects within 5 days**, if the landlord has adopted that written policy [18]. In Massachusetts, a tenant's separate damage list obliges the landlord to respond within 15 days [14][15]. In Michigan, the tenant returns the checklist within 7 days [23].
- **INFERENCE.** "Share with landlord" should be a first-class, prompted step: prefilled email, PDF attached, and a reminder of the local deadline where one is known. Where a statute requires **certified mail** (MD move-in inspection request [19]), the app must say email may not be enough and point to the official source, without telling the user what to do legally.

## 5. Claims the app must NEVER make (store listing, website, in-app, content)

1. "Court-admissible", "court-proof", "legally binding", "legal proof", "guaranteed evidence".
2. "Tamper-proof" or "impossible to fake" timestamps; "verified date" (unless a third-party time anchor exists and is described precisely).
3. "Guaranteed to get your deposit back", or any dollar outcome or success rate (there is no data).
4. "Legal-ready" or "lawyer-approved" (a competitor uses "legal-ready" [59]; we should not).
5. That the report **replaces** the landlord's statutory checklist, statement of condition, or inventory (WA, MA, KY, GA, MI, VA, AZ, MD). At most it can be "your own record you can attach to or send with your checklist."
6. Any statement of what a user's rights are in their particular case, or what they should do ("you can sue for 3x"). Link to official or legal-aid sources instead, labeled as general information.
7. That hashes prove *when* a photo was taken.
8. Endorsement by courts, universities, tenant unions, or government.
9. "Photos never leave your device" should appear only if literally true (no analytics or crash SDK uploading content). "Encrypted" should appear only if implemented and described accurately.

Recommended standing disclaimer (short): _"RentProof helps you organize your own photos and notes. It is not a law firm and does not give legal advice. Whether a court accepts any evidence is up to the court. Check your state's rules or contact a local legal aid organization."_

## 6. Comparison: UK and Canada (brief)

- **England & Wales, FACT.** Landlords must protect deposits in one of three government-approved schemes within **30 days** and give "prescribed information" [38]. The deposit cap is **5 weeks' rent** (6 weeks if annual rent is £50,000 or more) under the Tenant Fees Act 2019 [39][99]. Each scheme offers a **free adjudication (ADR) service** that decides deductions on evidence such as check-in and check-out inventories, photos, invoices and correspondence [38]. For failing to protect a deposit, a court may award 1 to 3 times the deposit [38][99]. **INFERENCE:** the UK has an institutional evidence-review channel, and the market already has professional inventory clerks and many deposit apps (e.g., MoveSnap targets "rental bond" markets [67]). The UK is not the beachhead.
- **British Columbia, FACT.** Residential Tenancy Act s.23 requires a **joint condition inspection** on move-in day. The landlord must offer at least 2 opportunities, complete a condition inspection report as the regulations require, have both sign, and give the tenant a copy within 7 days [40].
- **Ontario, FACT (secondary source).** Damage deposits are not permitted. Only a last-month rent deposit (max 1 month) is allowed, and it must be applied to the final month's rent [41]. **INFERENCE:** a deposit-evidence app has weak value in Ontario (the dispute would move to Landlord and Tenant Board damage claims instead).

## 7. Open legal questions (to verify with counsel before launch)

1. Exact current text of CA §1950.5 subsections on photos (AB 2801) and whether tenants have any corresponding right to receive the move-in photos.
2. WA return deadline (21 vs 30 days) and current RCW 59.18.280 documentation rules.
3. Whether showing statutory deadlines in-app (MI 7 days, MA 15 days, VA 5 days, MD 15 days) is "legal information" (fine) versus advice. Show them with citations and a "verify" link only.
4. Whether any state regulates "legal document preparation" software in a way that could reach a tenant condition report. HYPOTHESIS: very unlikely for a photo report, but ask.
