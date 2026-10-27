# New Thread Starter — 2026 Show PC Music/Sequence Migration

Use this when starting a new chat/thread inside the MSB Music & Sequence Catalog project.

## Required startup

1. Read `System_Documentation/Project_Rules/README.md` and the linked rules relevant to this work.
2. Read `docs/2026_show_pc_migration/README.md`.
3. Refresh current remote `main` before proposing repository changes.
4. Treat all annual Seasonal Files LOR archives as read-only until a reviewed migration/copy step is explicitly approved.

## Scope

Continue the 2026 Show PC music/sequence migration.

The live Show PC runtime root is fixed at `C:\LOR`. The running show must not depend on Google Drive or Internet access.

The annual archive is `G:\Shared drives\Seasonal Files\<YEAR>\LOR`, with yearly LOR folders beginning in 2014.

The immediate task is not to bulk-copy historical files. Resume the unfinished catalog work by discovering annual folder layouts and sequence formats, then build a read-only sequence-to-audio dependency inventory.

The operating requirement is an ongoing **Google Drive ↔ Show PC synchronization workflow**: Google Drive protects/maintains the source files, while Light-O-Rama must run entirely from local `C:\LOR` files with no Internet dependency.

Audio must use a **single canonical library**, separate from annual year folders. The known MSB audio variants are original/raw MP3s and their normalized show-use MP3 derivatives. Treat those as related variants of one recording, not two unrelated songs or redundant byte-identical copies. Reuse the same normalized audio across yearly sequences when the actual content is unchanged. The local show runtime audio location is `C:\LOR\Audio`. The canonical Google Drive library path and disposition/sync scope of raw masters still need to be confirmed, not invented.

Modern `.loredit` files are the **editable source sequences** and must remain **year-specific**: annual preview configurations change and are incompatible. Do not deduplicate or substitute 2024/2025/2026 editable sequences simply because they use the same audio. Legacy `.lms`/`.las` need separate historical parsing. Generated/non-editable `.lss` files are excluded from the initial editable-sequence and audio-dependency inventory (verify exact format separately if future playlist/playback history requires it). Archive snapshot year and represented show year are different catalog dimensions.

MSB programmers maintain the same `C:\LOR` local directory structure on their own PCs because sequence media references are stored as file paths. The Google Drive G: mount is a transfer/synchronization source only; production sequences must not point at G:.

**Proposed nonannual Google Drive audio folder:** `G:\Shared drives\Seasonal Files\LOR-Audio` (operator suggestion, not created or finalized). **Local audio path decision remains open:** retaining `C:\LOR\Audio` on every PC is the lower-risk option and already avoids annual audio duplication when paired with the shared G: folder; `C:\LOR-Audio` is an alternate common local path requiring LOR sequence-reference and offline playback testing before approval. Do not change existing sequence media paths or configure synchronization during the read-only discovery phase.
**Updated immediate priority, 2026-10-27:** Inventory/reconcile **existing audio** before establishing any synchronization folder. The operator has purchased one FreeFileSync Business license for evaluation but has **not** approved an audio sync root. MP3s are scattered, including ripped/original material and normalized files marked `normalized-1db` in the filename. Do not treat names alone as proof of file identity or normalization.

A prior inventory was reported in a December 8, 2025 message at `G:\Shared drives\Seasonal Files\LOR_Source_Files\MSB_SongHistory_AllShows_plus2025.xlsx`. The reported workbook sheets are `MasterSongs` and `AlternateSources`, but the current file and its completeness must be checked. Do not assume the `LOR_Source_Files` folder was made by a catalog tool or may be replaced.

**Next read-only action:** Inspect `LOR_Source_Files`, locate previous audio/song inventories, then enumerate `.mp3` occurrences (paths, names, sizes, timestamps, candidate normalized labels) across known yearly LOR locations and local `C:\LOR\Audio`, without copying, moving, deleting, renaming, normalizing, or hashing cloud placeholders. Only after mapping sequence references and reviewing proposed canonical/duplicate/variant decisions should any cleanup or FreeFileSync configuration proceed.

**Source reconciliation checkpoint (2026-10-27):** `Audio Library.xlsx` has 51 rows/50 distinct filenames; `MSB_Music_Normalized_v2.xlsx` has a 36-row AudioLibrary and additional historical worksheets; `normalized_mp3s_2025.csv` lists 37 named MP3 file occurrences (139,418,055 recorded bytes), all under the 2025 archive `LOR\Audio`. Of the 37 CSV filenames, 30 match Audio Library and 24 match Normalized_v2 by case-insensitive basename with optional `.mp3` suffix removed. A doubled-space `2025  Light Of Christmas ...` filename and the single-space version both have equal recorded byte lengths, but duplication is not verified without hashes. The different `MSB_Music_Normalized_History_v2.xlsx` was not uploaded. Next: read-only per-root counts and metadata for physical audio across source collections, annual archive Audio folders, and the Show PC. No canonical sync folder approved.

**Physical MP3 metadata checkpoint:** 2,073 MP3 occurrences / 7,604.5 MiB across nine populated G: roots and the computer's `C:\LOR\Audio` (one MP3). Not unique-audio count. Largest G: locations are `LOR_Source_Files\Audio` (622), `2025\LOR\Audio` (446), `2024\LOR\Audio` (363), `2023\LOR\Audio` (234), and `2020\LOR\Audio` (162). Several default `YEAR\LOR\Audio` roots were not found, without proof of missing yearly source. The **uploaded** `MSB_Music_Normalized_History_v2.xlsx` was inspected: six sheets including `AudioLibrary`, `PlaylistByYear_2019_25`, and `SequenceInventory_2019_25`; historical paths include `2021\LOR S5 2021\...`, so inspect alternate year layouts.

**Next operator read-only task:** export a local temporary CSV with one row per actual MP3 containing source root, full/relative path, byte length, last-modified UTC, and filename normalization marker. Upload that CSV for reconciliation with the existing workbooks. Separately identify alternate directories under years whose standard `LOR\Audio` was not found. No SHA-256 or cloud-placeholder downloads yet; no sync/copy/delete.

**Legacy year-label correction (2026-10-27):** Every sequence filename and many MP3 filenames historically gained a leading year to track what played before a database. This prefix is NOT part of the song/audio identity and is not proof of actually played year. Preserve exact filenames/paths for LOR reference compatibility and archive lineage; derive a separate historical-year hint and name-match candidate only. Song identity, recording/raw/normalized audio variant, audio file occurrence, year-specific `.loredit` source/preview, and verified playlist show-year usage are separate dimensions.

The uploaded `MSB_Audio_Metadata_20261027_142222.csv` contains 2,073 occurrences: 517 distinct filenames, 334 same-name/same-size candidate duplicate groups, 40 names at multiple sizes. 535 entries (130 distinct names) start with a four-digit year label, and stripping just that leading label reveals 16 cross-filename match *candidates*. This cannot prove identical audio without later file evidence. The read-only review workbook includes a Year Prefix Candidates sheet. Alternate archive `2021\LOR S5 2021\Audio` has another 177 MP3s (488.1 MiB), outside that CSV; the other four inspected alternative roots contain none. Surveyed total 2,250 occurrences (~7.90 GiB), NOT unique recordings. New Show PC must stay clean; no copying, deleting, hashing cloud placeholder content, sync setup, or canonical-folder creation authorized.

**Exact next discovery:** extend metadata CSV for 2021's 177 files, then inspect `.loredit` embedded audio references and compare to canonical song/source worksheets, keeping both original names and year-of-use facts. No sequence collapse across seasons merely because the audio is the same.

Produce a reviewable dependency/migration manifest before any selective audio copy or sync configuration.

Do not invent a new catalog or parallel source of truth; continue `Gregovate/MSB-Music-Sequence-Catalog`.

If the catalog requires a database, it is an **independent catalog database owned by this repository**. Do not place its schema or migrations in the MSB Production Database/PostgreSQL system. Backend technology/hosting remains undecided until this project designs it.
