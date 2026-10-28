# 2026 Show PC sequence conversion — operator workflow (DRAFT)

| Control | Value |
|---|---|
| Filename | `docs/2026_show_pc_migration/2026_conversion_operator_workflow_DRAFT.md` |
| Revision | DRAFT 0.3 (2026-10-28) — Show PC readiness and first local playback pilot |
| Status | **NOT approved for production operation**. Preview/map/grid-specific steps require a supervised pilot. |
| Engineering owner | [2026 conversion design](2026_sequence_conversion_engineering.md) |

## Scope

Convert an **already copied 2025 Final** musical sequence for the 2026 show using a new 2026 master musical preview, while preserving the 2025 source. Not a procedure to process every historical audio file, repair all previews or enable G: synchronization. Last year's Final sequences and backgrounds are already on the Show PC. The first **24 exact 2025-derived MP3 filenames** have now been transferred and individually SHA-256 verified; receipt path is recorded in the [audio copy operator procedure](2025_Final_Audio_Copy_Operator_Procedure.md). The operator reports all intended previews have been updated on the Show PC as of 2026-10-28, but their specific names/revisions and authoritative source comparison have not yet been captured in this workstream.

## Preconditions — DO NOT START THE EDITING STAGE UNTIL VERIFIED

1. Initial MP3 dependency staging has already completed for the first **24 exact 2025 Final primary audio basenames**, including 24 individual SHA-256 verification lines. This is **not** a complete historical catalog or new canonical library. Do not rerun V0.1.0 Copy. For any trial, verify the specific referenced MP3 exists locally at `C:\LOR\Audio`.
2. Source `.loredit` remains unchanged. Confirm both local source and separate 2026 working-copy paths explicitly; do not assume the old G: paths or create directories without approval.
3. The operator states all intended previews are now updated on the Show PC. **Still verify exact Preview names/revisions and approval lineage** from the latest completed LOR2DB reconciliation evidence and the MSB Production Database repository's Preview Import Workflow; installed copies do not automatically become authoritative master sources.
4. Confirm local MP3 reference resolution when LOR is opened; G: must not be needed for music playback. If the approved Preview cannot be imported/selected, **stop this sequence-conversion pilot** and follow the owning Production Database preview-authoring/approval process rather than changing the preview as part of a Music Catalog procedure.

## Authoritative preview procedure (external ownership)

**This Music Catalog draft is not a Preview-building procedure.** It defers entirely to [`Gregovate/MSB-Production-Database-Project`](https://github.com/Gregovate/MSB-Production-Database-Project), specifically:

- [Preview Import Workflow](https://github.com/Gregovate/MSB-Production-Database-Project/blob/main/Docs/01_LOR_System/01_Preview_Authoring/Preview_Import_Workflow.md) — identify the approved source via LOR2DB reconciliation and obtain a current working copy.
- [Building the Master Musical Preview](https://github.com/Gregovate/MSB-Production-Database-Project/blob/main/Docs/01_LOR_System/01_Preview_Authoring/E_Master_Musical_Preview_Howto.md) — approved Master Musical Preview and Scene organization.
- [Building a Preview](https://github.com/Gregovate/MSB-Production-Database-Project/blob/main/Docs/01_LOR_System/01_Preview_Authoring/B_Building_Preview_Howto.md) and [Prop and Display Naming Conventions](https://github.com/Gregovate/MSB-Production-Database-Project/blob/main/Docs/01_LOR_System/01_Preview_Authoring/A_Naming_Conventions.md) — controlled `Comment` field, Display and Channel naming and channel behavior.
- [LOR XML to MSB Terminology Contract](https://github.com/Gregovate/MSB-Production-Database-Project/blob/main/Docs/01_LOR_System/02_Data_Extraction/LOR_XML_to_MSB_Terminology_Contract.md) — source terminology and identity distinctions.

The controlled `Comment` holds the MSB physical **Display Name**, not an arbitrary note. An approved V7 process reconciles it with permanent database Display identity; this procedure must not revise or reinterpret that relationship. Preview building, controlled Preview export/merge, LOR parser/ingest and database reconciliation are **external, governed workflows**. No 'delete archived Props' stage exists in this 2026 musical conversion draft.

## First immediate trial: local audio and sequence-open check (READ-ONLY, no save)

**Operator checkpoint 2026-10-28:** updated previews reported installed on the Show PC; 24 initial source-referenced MP3s copied and per-file SHA-256 verified. Begin with a known 2025 Final musical source, before making a 2026 working revision or changing media names.

1. In LOR Sequencer on the Show PC, open `C:\LOR\Sequences\2025 Final\Musical Sequences\2025 Greg Frosty The Snowman.loredit`.
2. The exact source root XML from the 2025 Final scan references `Frosty The Snowman-Jimmy Durante-SN.mp3`. The verified local file candidate is `C:\LOR\Audio\Frosty The Snowman-Jimmy Durante-SN.mp3`.
3. Record whether LOR opens without asking for audio, whether the audio actually plays from the local library, and any compatibility/Preview/wiring warnings. The sequence previously embedded the 2025 Master Musical Preview name, so the presence of a newer Preview does not imply its source sequence has been converted.
4. If any missing-audio prompt or Preview/channel warning occurs, preserve text/screenshot. Do not browse to an arbitrary same-title MP3, assign a new preview, remove Props, edit Display Name/Comment, or accept a destructive change.
5. Close the 2025 source without saving. Report OPEN / AUDIO / PREVIEW statuses. Only after that should a *separate 2026 Scratch working copy* be considered for controlled conversion testing.

## One-sequence trial (proposed; exact editor buttons to be confirmed)

1. Select one verified 2025 Final source with its exact path, original MP3 basename, associated programmer attribution, and duration.
2. Make/identify a separate 2026 Scratch working revision; record parent 2025 file path. **Do not edit or overwrite the 2025 Final source.**
3. Open only when the needed local MP3 is available and has been verified. If the audio reference is missing/mismatched, **stop**: do not silently replace it with a normalized alternate or an arbitrary same-title recording.
4. Open the 2026 working sequence against the **already approved 2026 Master Musical Preview** via the documented LOR Preview Import Workflow. Confirm the Preview name/revision; record any sequence compatibility warnings. This document does not authorize changing the approved Preview, its controlled Display Name (`PropClass.Comment`), its network/controller/channel configuration, or production database records.
5. Inspect whether carried-forward sequence effects and channels work with the approved Preview. Use **current MSB terminology**: Display Name (`PropClass.Comment`), Channel Name (`PropClass.Name`), Stage / Sub-stage / Scene, and approved network/controller/Channel Grid configuration. Do not prescribe old match/grid imports, perform generic 'archived props' cleanup, or invent a sequence-side repair for Display, identity or network changes. Record discrepancies for the **Production Database repository's owning Preview Authoring, Preview Merger and LOR2DB workflows**.
6. Preview and listen: check sequence start, duration/timing, representative stages and effects, face/matrix alignments, quiet/dead areas and output compatibility.
7. Record musical-effect/timing exceptions separately from authoritative Preview/Display/network discrepancies. Do **not** delete old LOR Props or change controlled `Comment` values in the music conversion procedure. Escalate those changes to the existing Production Database LOR preview governance process; confirm musical changes with the responsible programmer.
8. Once accepted, promote the specific validated Scratch revision to 2026 Final under the established operator naming/path contract; preserve provenance and Final evidence. Promotion may become automated later, but is **not implemented** here.

## Separate workflows

- **Purchased RGB Plus sequences:** Preserve supplier originals; use reviewed mapping/provenance process before converting to the new master preview.
- **Background animations:** Identify unchanged compatible reusable assets separately from the animations that need 2026 hardware/preview revisions. The updated Open/Close matrix requires a distinct revision and testing.
- **Audio processing:** The legacy 2023 instructions to normalize to -1 dB, crop and export 128-kbps CBR are historical practices. Do not re-encode working playback MP3s as part of an ordinary preview conversion.

## Trial receipt / acceptance fields

| Field | Value |
|---|---|
| Sequence source / 2025 Final path | TBD |
| Source musicFilename & local MP3 existence | TBD |
| Sequence programmer | TBD |
| 2026 Scratch path | TBD |
| Installed LOR version | TBD |
| 2026 Master Musical Preview name/revision | TBD |
| Approved Preview source/reconciliation evidence and verified reference | TBD |
| Musical effects / display-channel compatibility exceptions (no Preview mutation) | TBD |
| Media and preview test status | NOT TESTED |
| Approved 2026 Final destination | TBD |
| Operator acceptance | NOT GIVEN |

## Safety

This is an **operator-procedure draft**, not authorization to copy, rename, delete, move, re-encode, remap, or synchronize files. Follow the project's runbook-first gate for any Production mutation. If an observed LOR interface/behavior differs from this proposal, STOP and revise the owning procedure using read-only evidence before relying on it.
