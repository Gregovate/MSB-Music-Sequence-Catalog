# MSB Music & Sequence Catalog — Conceptual Data Model

| Document control | Value |
|---|---|
| Filename | `docs/data_model.md` |
| Revision | 0.1 — Proposed / investigation |
| Source workstream | `docs/2026_show_pc_migration/README.md` |
| Storage implementation | **Undecided. No tables or database migrations approved.** |

## Scope and boundaries

This is a *database-independent conceptual model*, not a database selection or implementation plan. The catalog is owned solely by `Gregovate/MSB-Music-Sequence-Catalog` and must remain separate from the MSB Production Database. The immediate work remains read-only audio and sequence discovery. No source files, history or runtime audio paths are to be changed.

## Operator goals and confirmed practices (2026-10-27)

1. Store each purchased/ripped original recording in one maintained source collection; retaining artist/album/source folders is desirable. Keep original files unchanged.
2. Maintain one approved normalized show-use version **per distinct recording/edit** as a default, linked back to the original. Legacy filenames identify normalized files using `normalized-1db`; this does not prove the actual processing method.
3. Catalog music sequences and the **verified years actually used in the show** rather than adding a leading year to audio names. Existing year-prefixed filenames are *historical aliases*, not song identities or definitive played-year evidence.
4. Each show season starts by copying the **previous season's final musical editable sequences** into the new season's `Musical/Scratch` working area. Approved completed versions move through a controlled promotion to that season's `Musical/Final`; old seasons remain immutable historical references. The operator's 2026 workflow is `2026/Musical/Scratch` -> `2026/Musical/Final` (the exact filesystem anchor must be confirmed). `.loredit` versions remain season-specific due to incompatible previews.
5. Background animations are substantially reused across seasons; new designs or hardware/preview changes create **new animation revisions**. At least four are to be updated in 2026. The former Open/Close sign has become a full matrix, so the new sequence/preview relationship cannot silently overwrite earlier versions.

## Proposed logical records (not SQL tables)

| Logical entity | Identity and required relationships |
|---|---|
| **Song / composition** | Title and thematic classification; not the year prefix or physical filename |
| **Recording** | Performer/arrangement/master associated with a song; distinguishes genuinely different recordings |
| **Audio edit** | Full-length, shortened show edit, cropped intro/outro etc. Associated with one recording; time edits can change sequence synchronization |
| **Audio rendition** | Original/ripped/purchased MP3 and approved normalized show-use MP3 derived from an audio edit; distinguish processing recipe and approval state |
| **Audio file occurrence** | Physical source location, original filename, byte length, timestamps and optionally later SHA-256; multiple locations/names may identify the same content |
| **Sequence asset** | Logical musical or animation sequence concept; may evolve across years |
| **Sequence revision** | Exact editable file location, `.loredit` / legacy source format, season, preview/matrix compatibility, revision history, Scratch/Final status, parent copied-from revision |
| **Media dependency** | Exact media path stored inside each sequence revision, linked when confidently resolved to an audio rendition/edit; do not rewrite paths during discovery |
| **Show season / playlist entry** | Confirmed actual show-use evidence linking a specific sequence revision to a year/playlist; distinguish planned and performed use |
| **Animation asset / revision** | Reusable animation identity with versioned content and hardware/preview compatibility; one unchanged revision can be associated with multiple years when confirmed |
| **Source provenance** | Album purchase/rip origin, artist/album metadata, source evidence and approvals; retained even after normalized copies are selected |

The same song can have several recordings, and the same recording can have several **audio edits**, each with original/normalized renditions if required. Therefore *two files per song* is not an absolute invariant: the practical default is one original and one normalized output **per actual audio edit**. Prevent duplicate physical storage and redundant annual copying, not the legitimate existence of different performance or edit assets.

## Audio-level engineering decision still open

- **Do not assume 0 dB peak normalization delivers uniform broadcast loudness.** Peak targets (dBFS), perceived loudness (LUFS), true peak (dBTP), compression/limiting, and MP3 encoding are distinct concepts.
- Before proposing a fixed target, measure representative existing `normalized-1db` files and originals, compare listening through the local FM broadcast chain, and record the current processing recipe. Maintain enough headroom to avoid clipping.
- The normalized file selected for a working sequence must preserve musical timing unless a controlled re-sequencing change is accepted; shortened songs require explicit distinct audio edits.

## File and archive policy

- Historical Seasonal Files archive occurrences are read-only during discovery.
- Proposed Google Drive location `G:\Shared drives\Seasonal Files\LOR-Audio` is **not created or approved**.
- Current local runtime root is `C:\LOR`. Shared local audio path remains under review; `C:\LOR\Audio` is the existing low-risk candidate, while `C:\LOR-Audio` is untested.
- Every programmer PC and the Show PC must agree on exact local LOR reference paths. The live show must operate offline.
- The approved audio rendition would be distributed/synchronized **once** to a common local path rather than copied into each year's archive.
- Original album collections need not be distributed to every runtime PC.
- **No auto-delete, bulk rename, sequence rewrite, migration copy, synchronization cutover, or MP3 re-encode is authorized.**

## Next evidence required

1. Complete physical audio occurrence inventory, including 177 files in `2021\LOR S5 2021\Audio`.
2. Reconcile original and normalized variants with existing 2025 workbooks, and test true duplicate candidates by approved targeted read-only content comparison.
3. Read representative `.loredit` embedded media references and compare them with available MP3 files; keep exact original path and filename aliases.
4. Validate representative reused musical sequences and new animation/matrix revisions against year-specific preview dependencies.
5. Propose catalog acceptance criteria and audio normalization/synchronization workflow only after the evidence above. Do not select database engine/host or implement schema before separate acceptance.
