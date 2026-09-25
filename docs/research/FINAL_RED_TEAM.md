# Final Red Team: "If this launched tomorrow, how would it fail?"

_2026-09-25, after the MVP was built. Ranked by likelihood × impact (lead's judgment; no user data)._

| # | Failure mode | Class | Likelihood | Mitigation done before release | Remaining / next |
|---|---|---|---|---|---|
| 1 | Renters never find the app before move-in; installs happen after the damage dispute, when it's too late | DISTRIBUTION / MARKET | High | Landing page and copy; growth plan built on intermediaries (universities, legal aid, tenant unions) and move-in SEO; "I already moved in" path (import + move-out mode) | Outreach needs owner approval (HUMAN_ACTION); V-08, V-12 |
| 2 | Users start the walkthrough but abandon it (too many prompts, too long, boxes everywhere) | UX | High | 5 default rooms; short prompts; "Not in this unit"; finishing allowed with gaps (shown honestly); auto-advance to the next room; tip banner | Timed usability test (V-02); prompt analytics (V-03) |
| 3 | Data lost before move-out (new phone, uninstall), so the record doesn't exist when needed | PRODUCT / TECHNICAL | Medium-High | Evidence package export; **"No backup exported yet" status on the report screen and inspection history (added in this pass)**; Android device-to-device transfer allowed; iOS device backups include data | Cloud backup is BACKLOG B-05; measure V-05 |
| 4 | Store reviewers or users see the claims as over-promising or as legal advice | LEGAL | Medium | Claims policy; limitations in onboarding, settings, every PDF and the evidence README; no "proof/guarantee" wording in the app, landing or store drafts; generic deadline note only | Counsel review of copy + policy drafts (HUMAN_ACTION) |
| 5 | Name conflict: rejection, confusion with "Rentproof", takedown request | LEGAL / DISTRIBUTION | Medium (if shipped as RentProof: High) | Public name changed to the provisional "Move-In Record"; IDs set to match | Final name + trademark search (HUMAN_ACTION) |
| 6 | iPhone/Android HEIC photos show "preview unavailable" in the report, making it look broken | TECHNICAL | Medium | **Platform-codec fallback (dart:ui) added in this pass**; graceful placeholder if that fails too | Verify on real devices (V-11) |
| 7 | Android kills the app while the camera is open (common on low-RAM phones) and photos vanish | TECHNICAL | Medium | Pending-capture target saved; `retrieveLostData` recovery at launch into the right room | Device test (cannot emulate here) |
| 8 | Users share original photos that reveal their location | PRIVACY | Medium | Derived images and PDFs carry no EXIF; GPS presence flagged; warnings on the photo screen, report screen and in the ZIP README | Optional "strip location from exported originals" copy? Rejected for now because it would break hash equality; revisit |
| 9 | Free app with no revenue path → abandoned by its maintainer | MONETIZATION | Medium | Pricing hypothesis and test plan documented; free core chosen deliberately to compete with the camera | IAP after validation (B-02, V-06) |
| 10 | Large reports or packages fail to send by email (tens of MB), or the phone runs out of space | TECHNICAL / UX | Medium | Previews at ≤1600 px in the PDF; ZIP README and UI suggest cloud storage; storage-used display; out-of-space errors leave no partial files | Real-photo size measurements (V-11) |

Other risks considered but not ranked in the top 10:
- The landlord ignores or rejects the tenant's report (MARKET, V-09).
- The device clock is wrong. This is disclosed, and the email send creates an external timestamp.
- Accessibility on real screen readers (V-10).

**Complexity check:** no speculative infrastructure was added (no cloud, no AI, no payment SDK). Both code changes in this pass are small, isolated and tested.
