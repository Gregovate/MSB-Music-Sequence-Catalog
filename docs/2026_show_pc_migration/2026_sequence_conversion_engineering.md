# 2026 sequence conversion — engineering design proposal

| Control | Value |
|---|---|
| File | `docs/2026_show_pc_migration/2026_sequence_conversion_engineering.md` |
| Revision | Proposal 0.1 (2026-10-27) |
| Authority | Design candidate only; not an accepted LOR operating procedure or migration authorization |
| Governing workstream | [2026 Show PC Migration](README.md) |

## Basis: historical conversion workflow

The operator provided the historical Markdown file **Converting 2023 Sequences to 2024.md** as background, not as a current 2026 runbook. It combines (a) a procedure to adapt purchased RGB Plus sequences with normalized/cropped audio and a dated master preview/grid, (b) a year-to-year conversion checklist for previously finished sequences using new preview, match settings and grid, and (c) old background animation/show scheduling notes. Treat all dated stage, preview, map, Aux B/C and show-schedule details as historical, not current defaults.

The historical procedure explicitly included: preserving original purchased sequences; assigning a new preview; importing matching settings/grid configuration; fixing stage effects; reviewing dead areas; testing and saving final. The old text also says to ignore conversion warnings, delete archived props, crop/re-encode all new MP3s at 128-kbps CBR, prefix year in the MP3 filename, and operate from 2023 Google Drive paths. **These steps are not authorized for 2026 without new acceptance.**

## Target outcome

Make 2026 musical conversion repeatable and auditable without bulk copying audio, rewriting the historical archive, or building a new catalog database first. Preserve the working `C:\LOR` local runtime, last year's complete original Final sequences, each filename's programmer attribution, and year/preview-specific editable sequence versions. In the 2025 Final scan, 114 `.loredit` files had 27 nonempty primary music references covering 24 distinct MP3 basenames; all 24 have a 2025 archival audio candidate. This 24-name set is the initial conversion unblock, not a total musical program count or final copy approval.

## Split the previous overloaded procedure into three flows

**A. Carry-forward musical sequence (priority):** Take a distinct prior-year Final `.loredit` and create a new working 2026 Scratch revision. Keep the prior original unchanged; preserve programmer attribution and support two independently sequenced versions of one song (e.g. Adam and Greg). Use its existing media basename and review a controlled 2025-source audio distribution first. Confirm the *exact new 2026 master musical preview identity and revision*, then validate preview assignment, latest matching settings and grid configuration, unmapped/archived props, effects and audio timing. Promote an accepted working revision to 2026 Final.

**B. Purchased RGB Plus intake:** Inventory rights/source and preserve the purchased original; associate it with an approved original/normalized MP3 edit; validate that the current master preview's mapping/tags and grid support purchased groups, otherwise capture a gap. Follow the same Scratch/check/Final acceptance gate, but do not treat purchased-source steps as mandatory for every carried-forward song.

**C. Reusable background animation:** Track logical animation identity separately from its season-specific working revision and preview/hardware compatibility. Carry unchanged compatible animations forward with evidence, and create new revisions when hardware/display roles change. The Open/Close sign has become a full matrix; at least four backgrounds will be freshened for 2026. Background/operational sequences often have no primary MP3 and must not be flagged missing audio. Historical two-show/animation-loop schedule references are not accepted as the 2026 operational schedule.

## Proposed conversion record and gates (no database backend selected)

| Record/gate | Required evidence |
|---|---|
| Input | Exact source path, season, Final proof, sequence type, filename, content identity where needed |
| Attribution | Programmer from existing filename/operator validation; not part of song identity |
| Audio | Stored exact `musicFilename` basename, source match, original versus normalized/edited variant, timing and approval |
| Preview | Embedded prior-year preview identity and selected 2026 master preview identity/version; mapping compatibility status |
| Matching and grid | Approved 2026 import/match settings and grid configuration version, documented unresolved channels/props |
| Conversion exceptions | Preview warnings, changed/missing effects, removed/moved props, stage-specific manual repairs, hardware/matrix changes |
| Draft | 2026 Scratch path, input revision link, editor, date and status; preserve original Final source |
| Validation | Audio opens/plays locally, no unexpected duration changes, effect views checked, LOR output simulation/preview verified |
| Promotion | Operator acceptance and 2026 Final path/identity, with reason and evidence; no overwrite without explicit disposition |
| Future catalog | Later normalized song/audio identities and actual played year inferred from verified Final membership per operator rule |

## Deliberately retired practices

- Do **not** embed a year in a new canonical audio filename merely to record historical usage; capture year-of-use in the catalog and maintain aliases for previous references.
- Do **not** rerun Audacity normalization/cropping for previously approved, timing-aligned 2025 audio as part of a routine season conversion; preserve existing original/normalized provenance and analyze broadcast loudness separately.
- Do **not** assume an old 2023 preview/match map/grid configuration is correct for the entirely new 2026 Master Musical Preview.
- Do **not** ignore mapping warnings or automatically delete archived props; classify and resolve each changed/missing mapping under a validated map before any destructive step.
- Do **not** point live local sequences at G: or require Internet availability; the G: drive is an archive/transfer location.
- Do **not** conflate background animations and operational cues with musical songs in missing-MP3 checks.

## Open decisions; verification required

1. Exact installed 2026 LOR release and authoritative new master musical preview name/revision. **Not yet supplied.**
2. Approved 2026 preview mapping method, settings map, and grid configuration artifacts; verify actual LOR editor behavior before publishing an operator SOP.
3. Exact relative paths for 2026 `Musical/Scratch` and `Musical/Final` under `C:\LOR\Sequences` or other established local structure; do not invent/create them.
4. Approved common local music path (`C:\LOR\Audio` is current compatibility candidate; `C:\LOR-Audio` is not tested); reviewed selective transfer of 24 exact 2025 MP3 references.
5. Changed 2026 prop/matrix inventory, preview view/channel mappings, acceptance of revised background loops and show schedule.
6. Database location and authentication integration are **separate, pending architecture decisions**. The existing repo prohibition on adding catalog tables to the production MSB PostgreSQL database remains effective unless explicitly revised.

## Immediate next action

Complete the existing **read-only 24-name no-overwrite source/destination MP3 transfer preview** from the 2025 archived audio folder. Review it for exceptions and get explicit copy authorization separately. Collect the identity of the new 2026 master preview/settings/grid in parallel. Then conduct **one disposable/manual editor pilot** on a copy of a 2025 Final `.loredit` after the required local MP3 is available, recording what actually works before declaring a 2026 SOP.

No historical audio or sequence changes, production deployments, synchronized transfers, schema changes, or LOR preview edits are authorized by this design.
