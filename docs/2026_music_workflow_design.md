# 2026 Music Production Workflow and Work Management Integration
Revision: 0.6 — 2026-10-28
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

## Historical sequence compatibility — operator clarification 2026-10-29
**Authoritative requirement:** No historical sequence file may be treated as playable in the current show in its existing form. All historical sequences are preserved as historical evidence and require conversion to a new current-season revision before current-show use. This applies even to older S6 material; conversion effort varies but conversion is mandatory.

Historical sequence status must be independent of production readiness. A historical LSS usage record proves past use, not current compatibility, test approval, or release. Selecting a historical sequence for reuse creates a new season conversion candidate and work item; it does not update or overwrite the historical file/revision. The converted current-season revision requires its own source lineage, author/actor, audio and preview checks, testing and release approval before it is eligible for the current Final show.

UI and reports must label historical items `Historical — conversion required`, never `Ready` merely because they were previously in a Final folder. No automated compatibility inference from S6 version alone can bypass this gate.

## LOR major-version compatibility — operator requirement 2026-10-29
The LOR software major version under which each sequence revision was developed is a required explicit attribute. Track S4/V4, S5/V5 and S6/V6 as distinct, incompatible sequence-generation families; do not infer cross-version playback compatibility. The actual authoring version may be unknown for imported historical files; store UNKNOWN with source/evidence, not a fabricated value based on file extension or show year.

Required design distinction: `authored_lor_major_version` (source revision), `target_lor_major_version` (season conversion), and `validated_lor_version` (actual test environment, preferably full major/minor/build when available). A converted revision is a new file/revision linked to its source, never an in-place rewrite of history. Even source and target both being S6 does not bypass the current-season conversion and test gates. The catalog must support conversion effort planning by source/target version and preserve who converted, when, tested result and approved release.

Before implementation, determine reliable LOREDIT/LMS fields that identify authoring software version. Do not equate file format extension with exact authoring version. Current-season target version is configuration/approved release policy, not hard-coded permanently as V6.

## LOR version inference from show year — 2026-10-29
Historical show year is a strong practical indicator of the likely LOR generation used to prepare that year's show, but is not definitive proof of the original authoring version of an individual sequence. Use an explicit, reviewable MSB year-to-LOR-version mapping, populated from operator-confirmed upgrade history; do not invent fixed calendar cutoffs from general LOR release dates.

For each historical revision retain (1) inferred_lor_major_version, (2) inference_basis='show_year' and source show ID/year plus mapping revision, (3) verified/authored LOR version when extracted from reliable file evidence, and (4) confidence/review status. Do not overwrite verified metadata with an inference. A sequence reused across years may have been converted between shows; show usage and sequence revision identities remain separate.

Use inference for candidate grouping and conversion effort planning, never to bypass mandatory conversion, testing, or current-season release approval. No physical schema or production change is authorized by this note.

## Vendor release chronology and provisional MSB version mapping — 2026-10-29
Official Light-O-Rama announcements establish: S4 beta March 30, 2015 and S4 production available by June 30, 2015; S5 first production August 1, 2018; S6 licensing from August 22, 2022, with production S6.1.8 announced December 24, 2022. Sources: https://forums.lightorama.com/forum/15-important-announcements/page/6/ ; https://forums.lightorama.com/forum/15-important-announcements/page/5/ ; https://store.lightorama.com/pages/faqs ; https://forums.lightorama.com/forum/15-important-announcements/page/3/ .

Provisional show-year inference (NOT verified MSB usage): 2011–2014 S3 or earlier; 2015–2017 S4; 2018 S4/S5 transition; 2019–2021 S5; 2022 S5/S6 transition; 2023–2025 S6. Operator reports MSB generally stayed current. Store transition years as ambiguous rather than assigning a false exact version. Import parser should record inference source and preserve UNKNOWN when evidence conflicts.

Vendor says S5 .loredit sequences can open in S6 without a formal upgrade (https://forums.lightorama.com/topic/58472-light-o-rama-version-644-released/). This does NOT waive MSB's mandatory current-season adaptation, preview/audio validation, testing, and release requirements. Separate vendor file compatibility from MSB production readiness. Exact sequence-file metadata supersedes year inference.

## Annual Master Musical Preview compatibility — governing operator clarification 2026-10-29
**Compatibility is two-dimensional.** LOR software generation and MSB Master Musical Preview identity/revision are independent. A sequence written in S6 for a prior year's preview is NOT assumed compatible with the current year's S6 show. Displays and layout may be added, moved, changed, or removed each season, requiring conversion/adaptation even without a software upgrade.

Design requirements:
- Represent the approved Master Musical Preview for each show season, with stable music-side preview identifier, source filename/path and a reliable revision/fingerprint when available.
- Every sequence revision must retain the specific source preview identity/revision recorded by its LOREDIT metadata where available; unknown must remain unknown until verified.
- Every conversion records source sequence revision and source preview, target season and approved target preview revision, target LOR version, actor and date.
- Test evidence binds to the exact converted sequence revision, exact target preview revision, verified audio asset, and LOR runtime version.
- A preview change after testing invalidates or requires reassessment of affected test/release approvals; the design must define how to determine affected sequences without assuming all changes are harmless.
- Final release requires compatibility with the currently approved Master Musical Preview and target software, not merely a matching S6 major version or a prior Final-folder entry.
- The catalog stores music-side preview references and source evidence ONLY. Stage/background/component/wiring detail remains in its separate authoritative database and must not be duplicated or mutated.
- Inspect real LOREDIT preview metadata and annual preview publication practices before choosing the physical preview identity and fingerprint contract. Do not invent source field names.

The provisional show-year -> LOR version inference is for planning only. It never proves annual preview compatibility.
