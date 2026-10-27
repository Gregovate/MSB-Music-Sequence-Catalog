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

Produce a reviewable dependency/migration manifest before any selective audio copy or sync configuration.

Do not invent a new catalog or parallel source of truth; continue `Gregovate/MSB-Music-Sequence-Catalog`.

If the catalog requires a database, it is an **independent catalog database owned by this repository**. Do not place its schema or migrations in the MSB Production Database/PostgreSQL system. Backend technology/hosting remains undecided until this project designs it.
