# 2026 Show PC sequence conversion — operator workflow (DRAFT)

| Control | Value |
|---|---|
| Filename | `docs/2026_show_pc_migration/2026_conversion_operator_workflow_DRAFT.md` |
| Revision | DRAFT 0.1 (2026-10-27) |
| Status | **NOT approved for production operation**. Preview/map/grid-specific steps require a supervised pilot. |
| Engineering owner | [2026 conversion design](2026_sequence_conversion_engineering.md) |

## Scope

Convert an **already copied 2025 Final** musical sequence for the 2026 show using a new 2026 master musical preview, while preserving the 2025 source. Not a procedure to process every historical audio file, repair all previews or enable G: synchronization. Last year's Final sequences and backgrounds are already on the Show PC; audio has not intentionally been migrated.

## Preconditions — DO NOT START THE EDITING STAGE UNTIL VERIFIED

1. A reviewed, no-overwrite MP3 manifest lists the *exact filenames* referenced by the copied Final `.loredit` files, their 2025 archival audio source, intended local destination and preflight validation. The 24-name, ~80.90-MiB subset is only a candidate until approved and copied under a separate accepted procedure.
2. Source `.loredit` remains unchanged. Confirm both local source and separate 2026 working-copy paths explicitly; do not assume the old G: paths or create directories without approval.
3. Exact 2026 Master Musical Preview, approved match settings and grid configuration are installed, identifiable and compatible with the installed LOR version. These names/versions are **not yet known**.
4. Open the LOR software and confirm local audio reference resolution; no G: or Internet dependency for playing music.

## One-sequence trial (proposed; exact editor buttons to be confirmed)

1. Select one verified 2025 Final source with its exact path, original MP3 basename, associated programmer attribution, and duration.
2. Make/identify a separate 2026 Scratch working revision; record parent 2025 file path. **Do not edit or overwrite the 2025 Final source.**
3. Open only when the needed local MP3 is available and has been verified. If the audio reference is missing/mismatched, **stop**: do not silently replace it with a normalized alternate or an arbitrary same-title recording.
4. Assign the validated 2026 Master Musical Preview using the installed editor's confirmed method. Capture and investigate mapping warnings; **do not blindly ignore warnings**.
5. Apply only the approved 2026 matching configuration/grid mapping (if the pilot proves that these steps are required). Capture unmapped channels, archived or changed props, and new matrix hardware effects for correction.
6. Preview and listen: check sequence start, duration/timing, representative stages and effects, face/matrix alignments, quiet/dead areas and output compatibility.
7. Record each unresolved exception as a named work item rather than deleting archived props or guessing a replacement mapping. Confirm edits with the responsible programmer.
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
| Match settings/grid configuration IDs | TBD |
| Unmapped and modified props | TBD |
| Media and preview test status | NOT TESTED |
| Approved 2026 Final destination | TBD |
| Operator acceptance | NOT GIVEN |

## Safety

This is an **operator-procedure draft**, not authorization to copy, rename, delete, move, re-encode, remap, or synchronize files. Follow the project's runbook-first gate for any Production mutation. If an observed LOR interface/behavior differs from this proposal, STOP and revise the owning procedure using read-only evidence before relying on it.
