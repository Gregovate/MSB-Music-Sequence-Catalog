# 2026 Music Production Workflow and Work Management Integration
Revision: 0.1 — 2026-10-28
Status: PROPOSED ENGINEERING DESIGN — REVIEW REQUIRED
Owner: MSB-Music-Sequence-Catalog
Related authorities: MSB-Production-Database-Project #419 (Work Management), #122 (Setup integration), existing People and server mail governance.

## Objective
Plan and release 2026 musical sequences with traceable authorship, conversion work, assignments, tests, and production approval. Preserve historical song usage, audio identity and immutable released revisions.

## Responsibility boundaries
Music Catalog owns compositions, recordings, audio assets, musical sequence identities/revisions, source LOR version, preview reference, conversion assessment, season readiness, tests, approvals, and show usage.
People/authentication owns durable person identities. Never rely on display name or filename prefix as identity.
Work Management owns only work orders/intake and their approved task lifecycle. Its current #419 design focuses on repairs and feedback; do not presume it is a generic seasonal scheduling engine. A linked WO may be used for a discrete defect/repair, but music status remains in Music Catalog.
Server Management owns shared email transport. Do not create a separate SMTP sender.

## Proposed logical model (NOT physical tables yet)
- song: composition title and canonical aliases.
- recording: artist/arrangement/version distinct from composition.
- audio_asset: source/original, normalized/cropped/edit derivative, checksum, duration and file location; link to recording.
- sequence: logical program and original programmer/provenance; purchased RGB+ attribution distinct from volunteer programmer.
- sequence_revision: exact file/checksum, source revision, LOR S4/S5/S6 format, target preview identity/reference, source audio asset, edit actor, revision timestamp and scratch/final path.
- season_selection: year, recording, candidate sequence revision, priority, target date, conversion assessment and planned/active/deferred status.
- season_assignment: assignee person, assigned_by person, assigned_at, due date, role and reassignment history; optional external work-order link after approved contract.
- activity_event: actor, timestamp, action, old/new state, notes and evidence; immutable audit.
- test_event: tested exact revision hash, tester, timestamp, test environment/preview, pass/fail and findings. Failed test must not overwrite earlier results.
- release_event: approved exact tested revision, approver, timestamp, target season, Final path, and revocation/supersession if needed.
- show_variant/show_entry: main, video and future themed shows; actual usage and ordering from LSS with provenance.

## Proposed lifecycle
Selected -> Conversion Assessed -> Assigned -> In Progress -> Ready for Test -> Tested Pass -> Approved for Release -> Released to Final -> Verified in Show.
Failed test -> Needs Correction -> In Progress; preserve previous tests and actor history.
A work-order completion does not grant music release. A file in Final is strong historical production convention but is not by itself proof of current-year technical approval. Imported historical Final files are accepted as historical usage evidence without retroactively fabricating test approvals.

## Conversion assessment
Recent S6 revisions may need minor adaptation; older S6 requires compatibility review; S4/S5 generally major rework; purchased RGB+ may be quicker but still needs preview/audio compatibility and testing. Effort is an estimate, not an automatic assertion from extension alone.

## Approval and safety gates
- Exact revision identity and audio asset checked before test.
- Preview reference is a music-side reference only; do not copy production stage/background/wiring records.
- Test environment and tester recorded; failures remain visible.
- Approval authority must be explicit and separate from assignee status.
- Release records exact file checksum, year and Final destination.
- Actual show usage is confirmed by LSS import, separate from release approval.
- Historical years locked except 2011 under review; 2025 can be imported incrementally as operator directed, but 2026 is the planning season.

## Work Management integration decision — PENDING
Review governing Work Order System Design, current schema and #419 acceptance status before adopting an integration contract. Candidate: optional link from music assignment/defect to existing WO ID, without dual ownership of task status. Do not introduce music work types or mutate Work Management schema until cross-repository design is approved.

## Next design review questions
1. Who may assign programmers, mark tested, and approve Final release?
2. What is the minimum test evidence for S6 revisions versus S4/S5 rewrites?
3. Should routine conversion assignments live in Music Catalog or an approved generalized Work Management task capability?
4. What is the 2026 planning freeze and ongoing 2025 history import schedule?
5. Which preview identifier and audio XML fields can be extracted reliably from LOREDIT/LMS?
6. What does a video playlist/show variant mean operationally, and who approves it?

## Implementation governance
No database changes or production deployment authorized. Approved engineering design must precede any implementation PR. The PostgreSQL migration design is a separate infrastructure step and must not silently expand into this workflow schema.
