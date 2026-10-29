# MSB Music & Sequence Catalog — Conceptual Data Model

| Document control | Value |
|---|---|
| Filename | `docs/data_model.md` |
| Revision | 0.5 — Proposed / operator collection classification (2026-10-29) |
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
| **Sequence revision** | Exact editable file location, `.loredit` / legacy format, season, preview/matrix compatibility, revision history, Scratch/Final status, parent copied-from revision, and separately recorded programmer/contributor; parallel versions for the same song must be preserved |
| **Media dependency** | Exact media path stored inside each sequence revision, linked when confidently resolved to an audio rendition/edit; do not rewrite paths during discovery |
| **Show season / playlist entry** | Actual show-use evidence: the operator's verified `Final` folder membership establishes played-year use; playlists may add timing/order detail. Distinguish planned versus played and preserve exact evidence |
| **Animation asset / revision** | Reusable animation identity with versioned content and hardware/preview compatibility; one unchanged revision can be associated with multiple years when confirmed |
| **Source provenance** | Album purchase/rip origin, artist/album metadata, source evidence and approvals; retained even after normalized copies are selected |

The same song can have several recordings, and the same recording can have several **audio edits**, each with original/normalized renditions if required. Therefore *two files per song* is not an absolute invariant: the practical default is one original and one normalized output **per actual audio edit**. Prevent duplicate physical storage and redundant annual copying, not the legitimate existence of different performance or edit assets.

## Accepted current operating facts and record relationships

- **Confirmed played-year evidence:** MSB's operating rule is that *every editable sequence in the correct season's `Final` folder actually played in that show*. Once a file is verified as belonging to that season's Final set, catalog its actual show use without requiring an unrelated playlist confirmation. Keep precise Final path/year and source evidence. Scratch or generic carried-forward folders do not establish use.
- **Contributor/programmer:** `Adam`, `Greg`, and other names inside sequence filenames identify programmer assignment or attribution and must be stored separately from song, recording, and year. Rare parallel Adam/Greg sequence versions for the same song remain **separate valid sequence assets or revisions**, not aliases to delete.
- **Show PC checkpoint (updated 2026-10-28):** previous year's Final musical `.loredit` sequences and backgrounds were already copied. Operator has now run the governed **V0.1.0 initial 24-MP3 selective transfer** to `C:\LOR\Audio` and supplied 24 individual `VERIFIED:` lines, `VERIFIED FILES: 24/24`, and report location `C:\Users\LIGHT-~1\AppData\Local\Temp\MSB_2025_Audio_Transfer_V0.1.0_20261028_114621.csv`. Final terminal `PASS:` footer and receipt contents were not pasted/independently inspected, so document **24 file-level hashes verified; terminal closeout unconfirmed**, not entire audio library migrated. FreeFileSync is installed but not configured.
- **Editing urgency:** prioritize read-only dependency extraction from the **already copied 2025 Final musical sequences** and match against verified audio source occurrences. Produce a tightly scoped 2026 playback-audio selection/exception manifest before any file copy. Full historical audio cleanup and database implementation are downstream of this immediate unblock.

## Separate song identity, show usage and audio filename — operator pain point confirmed 2026-10-28

The successful first 24-file transfer exposed why the historical practice of prefixing MP3s with their **year introduced into MSB** must not continue. All of the following exact filenames were referenced by the 2025 Final scan: `2015 Trans-Siberian Orchestra - Wizards in Winter.mp3`, `2021 Sia - Candy Cane Lane 128 CBR Normalized -1db Cropped 3-23.mp3`, and `2025 Let it Go 192 CBR Normalized -1db.mp3`. Their filename prefixes cannot represent the 2025 year of performance. Other files have no year prefix, and some MP3s are show-operational cues, not songs.

**Proposed normalized catalog fields, not filesystem rename instructions:**

- **Composition/song + recording:** Stable performer/recording identification independent of filenames and show years.
- **First introduced into MSB:** A historical attribute supported by actual introduction evidence; a leading legacy filename year is a *hint*, never the sole proof of introduction or historical use.
- **Show-use seasons:** Derived from confirmed annual Final sequence membership; a sequence-specific year is not an audio identity.
- **Audio edit/rendition:** Exact recording/edit, shortened/cropped duration and original vs approved normalized show-use rendition. Bitrate/loudness are metadata or processing attributes, not song identity. Different audio edits must remain distinct, even with similar titles.
- **Physical audio occurrence:** Existing exact filename, original absolute path, source archive year and SHA-256/size where verified. One audio rendition can have multiple historical filenames/paths.
- **Sequence media dependency:** Preserve the *exact stored* `musicFilename` per `.loredit` version and resolve it via an explicit compatibility alias/binding to the correct audio edit/rendition; never rewrite old sequences because the catalog has a cleaner display name.
- **Operational show cues:** Classification distinct from musical compositions (for example `2022 Park Closed Take 2 Pitch Shift.mp3` and `2023 No Walking Version 3.mp3`), with their playback dependencies preserved.

**Migration discipline:** Existing 2025 source and the initial 2026 local set retain their exact byte-identical old names. Later canonical audio naming or file consolidation must be designed around verified audio identities and a tested LOR path/legacy alias strategy, ensuring current and archived `.loredit` files do not silently break. Permanent canonical location and backend remain undecided. Do not use broad renaming or FreeFileSync synchronization as the de-duplication mechanism.

## Model coordination with historical MariaDB and 2026 music workflow (2026-10-28)

**Same repository, distinct engineering workstreams:** This document's conceptual audio/music identity model belongs to `docs/2026-show-pc-migration`. The separate `docs/music-catalog-recon-20261028` branch contains [historical MariaDB schema evidence](https://github.com/Gregovate/MSB-Music-Sequence-Catalog/blob/docs/music-catalog-recon-20261028/docs/data_model.md) (revision 0.2), [PostgreSQL Migration Engineering Design](https://github.com/Gregovate/MSB-Music-Sequence-Catalog/blob/docs/music-catalog-recon-20261028/docs/postgresql_migration_design.md) (proposal 0.1), and [2026 Music Production Workflow](https://github.com/Gregovate/MSB-Music-Sequence-Catalog/blob/docs/music-catalog-recon-20261028/docs/2026_music_workflow_design.md) (proposal 0.1). These are not merged, implemented, approved physical data models. See [cross-workstream coordination](2026_show_pc_migration/Music_Library_Cross_Workstream_Coordination.md).

**Legacy historical tables — observed only:** Synology MariaDB `msb_sequence_catalog` has `raw_show_sequences` (409 rows), `shows` (14), `sequences` (408), `show_sequences` (408) in the operator-provided 2026-10-28 export. Those store historical sequence/playlists and imported path/title fields. They **do not constitute a canonical recording/original/normalized audio library**. Known imported-header rows, malformed Windows paths, mismatched filename years and role errors must remain provenance exceptions pending authorized correction. An independently reviewed raw migration may preserve those four existing tables without implying future file identity tables are ready.

**Future domain relationships (conceptual, not SQL):** `song/composition -> recording/master/artist -> audio edit (timing) -> rendition (original or normalized/edited Show-Audio) -> file occurrence`; Album/release and purchased LOR package source provenance relate to original recordings and media occurrences, not to historical filename prefixes. `sequence revision` points to the exact audio rendition it was authored/tested against; retain original `musicFilename` and exact file content evidence. `show season/entry`, selection, programming assignment, testing and release are distinct from the source media catalog and require separate approval rules.

**Source-of-truth conflict still open:** This inventory branch's controlled rules require an **independent database** and forbid music catalog objects in the production PostgreSQL database; the parallel proposed migration would load a `music` schema into the **existing** production PostgreSQL instance. There is no approval to change those rules or create either target yet. Decide database placement/isolation, identities/roles, retention, backups, source migration and read-only/disposable tests with the relevant owners **before any physical schema or ingestion code**.

**Year-of-use evidence compatibility decision:** Verified season `Final` membership is confirmed by the operator as used in that show; the proposed new 2026 workflow also envisages LSS evidence and distinct test/release approvals. Do not use the absence of an imported LSS as proof a confirmed historical Final sequence wasn't played, and do not infer a modern approval signature for historical releases. Establish precedence and exceptions in a jointly approved design.

**Current inventory source gate:** V0.3.0 Seasonal Files scan COMPLETED with 11,969 audio occurrences in 3,724 directories and zero pending. Its classification candidates remain `REVIEW_REQUIRED`, **not confirmed originals or imported catalog rows**. Persisting scanner output later requires exact source path, source root/version/SHA, completeness flag, album/package provenance, classification evidence and optional file hash; filenames alone cannot be join keys to malformed MariaDB paths.

## Artist/album, personal collections and actual show-use classification (operator discussion 2026-10-29)

Keep **separate dimensions** rather than treating a source folder as a database class or a recording as used merely because it is available:

| Dimension | Meaning / examples |
|---|---|
| **Music identity and membership** | Work/song, performing artist, recording, source album/release, track number, single/featured-song search. `Monster Mash` remains independently findable within the scanned 17-track Bobby Boris Pickett folder; `Grandma Got Run Over by a Reindeer` within the 10-track Dr. Elmo folder. Neither requires a duplicate standalone original file. |
| **Provenance and acquisition** | Ripped CD, commercially purchased album/single, personal collection, purchased LOR sequence package with separate audio source, unknown. Historical `Licensed Songs` was likely the operator's purchased-album organizing attempt, **not** proof of a particular legal license. |
| **Ownership/permissions** | Distinguish operator personal collections (e.g., Bob Rivers) from confirmed MSB-owned assets, unknown provenance, and separately verified permission to share to programmer PCs. This is a catalog information field, not a legal determination. |
| **Functional asset category** | Music recordings; Audacity-normalized show renditions; separately timed edits; special recorded show opening/closing announcements; historical singing-face/`Vocals for Superstar` isolated vocals and stems; nonmusic SFX; generated LOR cache. Categories may share the same song relationship but should not be flattened to original albums. |
| **Use and production status** | Source recording available for possible future custom sequence, sequence under development, verified historical Final/show use by year, or no use yet confirmed. A track in the library is not necessarily a show track. |
| **Physical occurrence** | Every exact path/file remains traceable, including historical copies from different PCs and yearly folders. Hash before declaring exact byte duplication. |

**User-provided operating context:** The Light-O-Rama purchases were primarily sequences; music rights/sources must be tracked separately, even when an audio file accompanied a package. The operator has extensive personal Christmas albums (including some Bob Rivers), old singing-face mouth-sync stem experiments in `Voiceovers`/`Vocals for Superstar`, special recorded show-start/end tracks and many songs never used in a sequence but retained as future programming choices. Those **must not** automatically become MSB-owned music, normalized Show-Audio, a historical performed song or a licensed recording based on folder placement alone.

The 2026-10-28 V0.3.0 scoped Seasonal Files scan is now **COMPLETE**: 11,969 occurrences across 3,724 directories, zero pending. Its 588 Originals proposals, album grouping and 90 LOR bundle source occurrences are still review candidates; no content hash or master copy has been approved. See [completed original-source findings](2026_show_pc_migration/Original_Audio_Scan_Findings_20261029.md). This supersedes any earlier model paragraph describing the bounded 100-directory pilot as the current inventory.

## Database / authentication decision — explicitly pending

The operator has a working authentication stack for existing MSB production applications and sees value in reusing it, but there is **no separate Music Catalog schema inside the production database** and the operator wishes to prevent production data pollution. The owning project's **current prohibition** on catalog objects in the MSB Production Database remains active until governance explicitly changes it. Explore without implementation:

1. A logically **separate catalog database** (which might share a PostgreSQL server) using existing app identity/SSO through a controlled authentication interface.
2. An intentionally **isolated catalog schema** within an existing database, but only if the production boundary, independent roles, migration controls, backup/recovery and release governance are expressly re-approved. This is **not currently authorized**.

In either design, the catalog is its own repository-owned application/subsystem. Reusing authentication does not itself require its catalog data tables to live alongside production tables. No decision, migration or server action is needed for the current file-level inventory.

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
