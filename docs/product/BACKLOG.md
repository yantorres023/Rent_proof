# Backlog (deferred by the scope gate)

Scope-gate question: *does this increase our ability to test the central hypothesis ("renters will complete, send and keep a move-in record")?* Items below were answered **no, not yet**, or are blocked.

| # | Item | Why deferred | Gate to reconsider |
|---|---|---|---|
| B-01 | State-by-state deadlines + reminders (red-team pivot idea) | Statutes not verified from primary text; wrong deadlines could harm users (D-006) | Primary-source table reviewed by a person or attorney; local notifications permission reviewed |
| B-02 | In-app purchases (Move-Out Pack $9.99 / lifetime $14.99) | No store accounts; would confound validation (D-005) | Activation ≥ target in beta; store accounts ready |
| B-03 | Video playback in app | Adds a native player dependency; recording and export already work | Beta users record videos and ask to review them |
| B-04 | Ghost overlay / angle matching for move-out photos | Nice-to-have; comparison works manually | Comparison used by ≥ X% of move-out users |
| B-05 | Cloud sync / account / multi-device | Needs backend, credentials and privacy work | Evidence of data loss or multi-device need; backend budget |
| B-06 | External timestamping (RFC 3161 TSA) or C2PA content credentials for originals | Would anchor time with a third party; needs network and a vendor | Legal review says it adds value; privacy review |
| B-07 | Co-tenant / landlord shared inspection, signatures | Multi-user; landlord-side scope | Clear demand plus legal review of e-signature |
| B-08 | Import a landlord's checklist form (PDF/photo) and answer item by item | Many formats; OCR | Top requested in beta |
| B-09 | Localization (Spanish first for the US) | English-only V1; strings are inline (D-007) | Beta success; extract strings to ARB first |
| B-10 | AI descriptions of damage / auto room classification | Deterministic prompts suffice; no paid API in V1; risk of wrong descriptions in a record | A clear user need; on-device model; human-confirmed only |
| B-11 | Dispute helper (letter templates, small-claims guidance) | Legal-advice risk | Partnership with legal aid |
| B-12 | Maintenance issue timeline across inspections | Possible mid-tenancy hook; unvalidated | Beta shows maintenance inspections are used |
| B-13 | Adaptive/monochrome Android icon, final branding | Waiting for the final name | Name chosen |
| B-14 | Encrypt the local database and files at rest beyond OS protections | OS sandbox + device encryption already apply; key management adds loss risk | Threat model change (e.g. shared devices) |
| B-15 | Reorder rooms/prompts by drag and drop | Minor UX | Beta feedback |
