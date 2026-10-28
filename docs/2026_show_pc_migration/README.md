# 2026 Show PC Music and Sequence Migration

| Item | Current value |
|---|---|
| Repository | `Gregovate/MSB-Music-Sequence-Catalog` |
| Workstream | 2026 Show PC migration |
| Status | INVESTIGATION / MIGRATION PREPARATION |
| Production runtime root | `C:\LOR` |
| Historical archive root | `G:\Shared drives\Seasonal Files\<YEAR>\LOR` |

## Purpose

Migrate the useful Light-O-Rama sequence and media set to the new Show PC without carrying forward the entire historical accumulation of sequence/audio files.

This workstream also resumes the unfinished MSB Music & Sequence Catalog so the migration can be driven by actual sequence/media dependencies instead of manual bulk copying.

## Database ownership boundary

If this catalog uses a database, that database is **independent of the MSB Production Database system**. Do not add Music/Sequence Catalog tables, schemas, functions, migrations, or application dependencies to the MSB Production Database PostgreSQL environment.

The catalog repository owns its own data model and, if/when a database backend is selected, its own database lifecycle, migrations, backup/restore procedure, and runtime configuration. The storage engine and host are **not yet decided** by this workstream; do not infer PostgreSQL, MariaDB, Synology, or any other backend from older scaffold text.

## Hard constraints

1. The Show PC production Light-O-Rama root remains exactly:

   ```text
   C:\LOR
   ```

   Changing the root breaks existing Light-O-Rama references and supporting workflows.

2. The running show must operate from local files and must not depend on Internet access or Google Drive being available.

3. The Google Shared Drive yearly LOR trees are historical/source archives. Investigation of them begins read-only.

4. Do not copy the entire historical Audio or Sequences archive to the new Show PC merely for convenience.

5. Before copying media, produce a reviewable dependency/copy manifest.

6. Preserve exact media filenames expected by the selected Light-O-Rama sequence files.

## Ongoing Google Drive ↔ Show PC synchronization contract

This is not a one-time migration only. The Show PC needs an **ongoing synchronization workflow** between the Google Drive source/archive and the local Show PC so the show can always run from local storage while the maintained files remain protected in Google Drive.

The operating model is:

```text
Google Drive maintained files
        ⇅
controlled synchronization
        ⇅
C:\LOR local working/runtime files
        ↓
Light-O-Rama runs only from local storage
```

Requirements:

- The running show must never depend on an Internet connection or streamed Google Drive file access.
- Files required by Light-O-Rama must exist locally under `C:\LOR` before show operation.
- Synchronization must be explicit and reviewable; a sync job must not silently delete or overwrite files without a defined conflict policy.
- The exact synchronization tool and direction/conflict rules still need to be selected and documented.
- Annual archive folders and the local runtime are different roles: the archive preserves history; `C:\LOR` is the operational working copy.

## Programmer-PC path contract and proposed shared audio distribution location

The operator confirms that Light-O-Rama sequences embed media file paths and all MSB programmers intentionally maintain the **identical local `C:\LOR` hierarchy** for compatibility. The G: Google Shared Drive mount is a **transfer/synchronization location**, not a playable runtime dependency, and should not be embedded in production sequence audio references.

Proposed non-year-specific Google Shared Drive distribution/source folder (operator suggestion; not yet created or selected as an approved production sync target):

```text
G:\Shared drives\Seasonal Files\LOR-Audio
```

Every programmer's workstation and the Show PC must have the **same exact local audio path**, with the required show-use files available offline. Two candidate local paths are under consideration:

- **Preferred low-risk option:** `C:\LOR\Audio` on all computers. This is the already documented local runtime path and Light-O-Rama's standard media search location; it can be synchronized directly from the single non-annual Google Drive audio library without recopying audio into each year's archive.
- **Operator-proposed alternative:** `C:\LOR-Audio` on all computers. This may support external audio references but requires actual LOR version/path-behavior testing, updates to any existing sequence references, and successful playback on the Show PC before acceptance.

**Do not change the accepted local audio runtime path merely to avoid annual cloud synchronization; the cloud folder can be centralized independently of the local directory.** Both options preserve the required `C:\LOR` sequences/runtime root. No final external-audio path decision has been made.

LOR's published File Locations help recommends storing audio in the LOR Audio subfolder to allow transferred sequences to resolve their media without prompting. The Sequencer's Media File command can change a sequence's referenced media path, but some versions prompt to copy external files back into the normal Audio folder. Before any relocation, inspect the actual references in representative `.loredit` sequences, and validate opening, editing, generated playback, and offline show playback against the candidate path on the installed version(s).

Synchronization is a **controlled separately-reviewed action**, not a blind bidirectional mirror. Determine source/authoritative-edit location, file direction, conflict and overwrite policy, raw-versus-normalized MP3 handling, and verification before enabling any sync. Archive copies and Show PC contents are not to be modified during discovery.


## Canonical audio library — not annual duplicates

Audio is **shared across show years**. For the known MSB audio workflow, the relevant distinction is between an **original/raw MP3** and a **normalized MP3** derived from that original, rather than a separate per-year song recording.

Catalog an underlying audio recording once, with explicitly related file variants:

```text
one recording / audio identity
    ├── original (raw) MP3 — preserved source
    └── normalized MP3 — show-use version
          ├── 2024 editable sequence
          ├── 2025 editable sequence
          └── 2026 editable sequence
```

The raw original and normalized derivative are not byte-identical and should not be incorrectly classified as independent unrelated songs, nor treated as exact duplicates merely because titles match. Record the relationship between the two files; do not use filenames or SHA-256 alone to associate raw and normalized variants. Use hashes to establish **byte-identical file occurrences** across archive locations.

A normalized version may be reused by multiple years' sequences when it is the same actual show audio. Do not normalize again simply because a new season's previews require a new editable sequence. If inspection finds genuinely different recordings, edits, timing/duration, or distinct normalization passes, retain those variants and their relationships rather than collapsing them automatically.

Do not preserve redundant copies of a recording in each annual `Seasonal Files\<YEAR>\LOR` tree merely because different years' sequences reference it. Historical copies remain read-only during discovery and are not authorized for deletion or consolidation yet.

On the Show PC, the canonical local runtime audio location remains:

```text
C:\LOR\Audio
```

The Google Drive side requires a **single canonical audio library separate from annual year folders**. Its exact location and how original/raw source MP3s are stored or synchronized are still TBD and must not be invented. The Show PC must have the local normalized audio files required by the selected sequences before operation; local playback never requires Google Drive.

The catalog must distinguish audio recording identity, raw/normalized file variant, physical archive file occurrence, and each sequence's exact original audio reference.

## Year-specific editable sequences and generated artifacts

Operator-confirmed sequence workflow:

- A `.loredit` file is the **editable sequence source** for modern Light-O-Rama work.
- Editable sequences are **show-year specific** because their previews change from year to year and the preview configurations are incompatible. Do **not** deduplicate or substitute different years' editable sequences based only on a common song/audio file.
- Older `.lms` musical sequences (and legacy `.las` animation sequences) are historical source formats that require separate format-aware handling.
- `.lss` is **not** an authoritative editable sequence for this initial catalog/migration inventory. The operator reports it is generated as part of the current LOR playback/update workflow. Exclude it from source-sequence counts and audio-dependency parsing for now; verify actual file structure before making assumptions about any later playback or playlist-history use.
- The season represented by a sequence and the archive snapshot containing it are **different attributes**: a later archive may carry forward, add, or revise an earlier season's files.
- `Final` folders are candidate official seasonal sets; verify them against source files and operator/show evidence before declaring authority.

## Confirmed source layout

The annual Seasonal Files archive contains year folders. Greg confirmed yearly LOR folder structures beginning with 2014:

```text
G:\Shared drives\Seasonal Files\2014\LOR
G:\Shared drives\Seasonal Files\2015\LOR
...
G:\Shared drives\Seasonal Files\2025\LOR
G:\Shared drives\Seasonal Files\2026\LOR
```

The immediate 2025 sequence source used during the new-PC setup is:

```text
G:\Shared drives\Seasonal Files\2025\LOR\Sequences
```

Those 2025 sequence folders were copied into the new PC's LOR structure as the starting point for 2026 work.

## New Show PC local LOR structure

The new PC has the standard LOR root with folders including:

```text
C:\LOR\Audio
C:\LOR\Clipboards
C:\LOR\CommonData
C:\LOR\Hardware
C:\LOR\ImportExport
C:\LOR\KeyMaps
C:\LOR\Logs
C:\LOR\LORInternal
C:\LOR\Network
C:\LOR\Plugins
C:\LOR\Sequences
C:\LOR\SuperStar
```

## Sequence-history reality

The historical `Sequences` tree contains carry-forward material from prior years such as Final/Scratch folders. Not every prior-year sequence can be used directly in the current show even when it uses the same audio track.

Therefore:

- sequence history is catalog data;
- audio identity can span multiple sequence/year versions;
- current-show eligibility is a separate decision from historical existence;
- the new PC should receive only the media required by the selected working sequences.

## Existing catalog repository state

The repository already states the goal of cataloging:

- songs;
- audio files;
- sequences;
- purchased RGB+ content;
- show-playlist history.

However, at the start of this workstream:

- `docs/data_model.md`, `docs/data_sources.md`, `docs/ingestion_plan.md`, `docs/path_conventions.md`, `docs/sequence_types.md`, and `docs/ui_design.md` are empty placeholders;
- `tools/import_audio_csv.py`, `tools/import_lss_history.py`, and `tools/import_rgbplus_sequences.py` are placeholders rather than working production tools;
- no existing tool should be assumed capable of performing the migration.

## Migration direction

The intended workflow is:

```text
annual historical LOR sequence archives
        |
        | read-only inventory
        v
sequence / audio / show-history catalog
        |
        +----> canonical audio identity / deduplication
        |
selected 2025/2026 working sequences
        |
        v
resolved media dependency manifest
        |
operator review
        |
        v
canonical Google Drive audio library
        ⇅
controlled synchronization
        ⇅
C:\LOR\Audio
        |
        +----> C:\LOR\Sequences
        |
offline validation
        |
        v
2026 show build
```

## Audio-first source discovery and consolidation checkpoint (2026-10-27)

**The operator has not approved or created a canonical audio synchronization folder.** FreeFileSync Business has been purchased for initial evaluation only; this does not authorize synchronization. There are scattered ripped/original MP3s and normalized MP3s using `normalized-1db` in their filenames (case/punctuation may vary). A missing normalization marker is **not** proof that a file is original.

**Existing inventory source to inspect before building another catalog:** On 2025-12-08, the operator identified `G:\Shared drives\Seasonal Files\LOR_Source_Files\MSB_SongHistory_AllShows_plus2025.xlsx` as a musical/sequence inventory. Its described sheets are `MasterSongs` (canonical song identity, classifications, show years) and `AlternateSources` (other versions/duplicates). This is historical evidence of an inventory outside the Git repository; present existence, completeness, file contents, and any tooling that created the surrounding `LOR_Source_Files` folder have **not** been verified. Treat the entire folder as existing source material, not a disposable generated output.

**Order of work (investigation now; cleanup only after manifest approval):**

1. Read-only inspect `LOR_Source_Files`, existing workbook, annual LOR Audio trees, candidate audio elsewhere under Seasonal Files, and local `C:\LOR\Audio` for current files. Capture exact root/path and file metadata; start with metadata before content hashing to avoid unnecessary Google Drive downloads.
2. Produce one path-preserving inventory of all discovered original/ripped/unknown/`normalized-1db` MP3 occurrences. Count per-root files and bytes. Keep audio identity separate from physical occurrences and from the year-specific `.loredit` sequences.
3. In a later controlled read-only content pass, determine exact duplicates with SHA-256; distinguish genuine duplicate files from raw/normalized derivatives and different mixes/edits. Match sequence audio references before choosing keep/copy/delete actions. Do not infer audio identity from filename alone.
4. Present reviewable proposed canonical library and exception/retention manifest, including current dependencies, raw source preservation, conflicts, duplicate candidates, and any estimated storage savings.
5. Only after explicit operator acceptance, create the canonical Google Drive library, perform controlled consolidation, and configure/test FreeFileSync synchronization. No automatic deletion, overwrites, or bidirectional conflicts before a documented policy and offline LOR validation.

**Current safety state:** No approved G: audio sync folder, no configured sync job, no archive/file relocation, no deletion. The proposed `G:\Shared drives\Seasonal Files\LOR-Audio` remains **TBD**, not the verified location of the existing inventory. A common local LOR audio path is required on every programmer PC; choosing `C:\LOR-Audio` versus current `C:\LOR\Audio` remains deferred until actual embedded-reference and offline playback tests.

### Existing music inventory evidence (verified 2026-10-27)

Operator-reported immediate contents of `G:\Shared drives\Seasonal Files\LOR_Source_Files` include these **preexisting** data files: `Audio Library.xlsx`, `MSB_Music_Normalized.xlsx`, `MSB_Music_Normalized_v2.xlsx`, `MSB_Music_Normalized_History.xlsx`, `MSB_Music_Normalized_History_v2.xlsx`, `MSB_Musical_Songs_Inventory.xlsx`, `Musical Sequences.xlsx`, `play Lists by Song.xlsx`, `normalized_mp3s_2025.csv`, and `MSB_SongHistory_AllShows_plus2025.xlsx`. Subdirectories include `Audio`, `Normalized Audio Albums`, `PurchasedMusic`, `Purchased LOR RGB Plus`, `Playlist History`, `Images`, and `Prop Testing`.

An operator-uploaded **read-only** copy of `MSB_SongHistory_AllShows_plus2025.xlsx` was inspected. Its eight worksheets include `MasterSongs` (81 nonblank records), `AlternateSongSources` (10), `RawSequenceHistory` (1,631 rows, **sequence/show references rather than unique source files**), `SongByYearMatrix`, and purchased RGBPlus reconciliation lists. Raw history references include 1,583 `.loredit` and 48 `.lms` filenames, and years 2018, 2019, 2021-2025. `MasterSongs` has `Source`, `HasAudioLibEntry`, `HasPurchasedRGBPlus`, and prior canonical identifiers. Several purchase reconciliation rows contain actual `G:` locations under `LOR_Source_Files\Purchased LOR RGB Plus`.

**Do not replace these historical catalog identities or import existing workbook rows uncritically as authoritative audio identities.** The workbook does not prove present-day file existence, physical duplicate status, normalized/raw lineage, or complete sequence coverage. It may contain provisional matching and intentionally carried-forward records. Inspect the audio-specific source workbooks and CSV next; establish current filesystem evidence independently. No source folder creation/renaming or sync target is approved.

### Uploaded 2025 audio-source catalogs: read-only audit (2026-10-27)

The operator supplied copies of `Audio Library.xlsx`, `MSB_Music_Normalized_v2.xlsx`, and `normalized_mp3s_2025.csv`. The second workbook is **not** `MSB_Music_Normalized_History_v2.xlsx`; that distinct historical workbook remains unexamined.

- `Audio Library.xlsx`: `AudioLibrary` has **51 data rows and 50 distinct filename values** (case-insensitive, ignoring a terminal `.mp3` extension). `2025 Light Of Christmas [feat. TobyMac] Normalized -1db.mp3` appears **twice as identical catalog rows**. The workbook has no verified physical file hashes.
- `MSB_Music_Normalized_v2.xlsx`: five tabs—`AudioLibrary` (36 data rows), `SongYearMatrix` (36), `Sequences_SongsMaster` (60), `Raw_Original_2023Sheet` (45), and `Playlist_Import_Template` (header only). Treat these as earlier/staged catalog lists; do not infer complete audio file coverage.
- `normalized_mp3s_2025.csv`: **37 distinct filename occurrences**, all pointing at `G:\Shared drives\Seasonal Files\2025\LOR\Audio`, totaling **139,418,055 bytes (~132.96 MiB)** based on recorded file sizes. Each name contains a `Normalized -1db` variant; they have not been opened or inspected.
- Exact filename crosswalk after lowercasing and dropping an optional trailing `.mp3` extension: **30/37 CSV names** appear in `Audio Library.xlsx`; **24/37** appear in the 36-row `MSB_Music_Normalized_v2.xlsx` AudioLibrary. Mismatches show catalog/snapshot or naming variance, **not verified absent physical files**.
- The CSV lists `2025  Light Of Christmas [feat. TobyMac] Normalized -1db.mp3` (two spaces) and `2025 Light Of Christmas [feat. TobyMac] Normalized -1db.mp3` (one space), **each 3,594,765 recorded bytes** and with different modified timestamps. Candidate exact duplication requires hashes; identical sizes do not establish byte equality.
- Original/ripped MP3s elsewhere, multiple raw/normalized versions, canonical audio content, file availability, and actual LOR audio dependency completeness have not yet been examined.

**Next read-only action:** Produce a per-root metadata-only MP3 count and size report for `LOR_Source_Files` audio collections, the annual `LOR\Audio` directories, and local `C:\LOR\Audio`; use this inventory to scope subsequent physical file/path reconciliation. Do not recursively hash cloud files yet. Do not choose a sync tool workflow, move files, consolidate, or create a canonical folder before operator-reviewed reconciliation.

### Actual MP3 location survey (operator PowerShell metadata, 2026-10-27)

The directory-metadata-only survey covered nine populated G: roots and one local C: root, yielding **2,073 MP3 file occurrences and 7,604.5 MiB (~7.43 GiB) recorded bytes**. This is NOT a unique-audio count or duplicate-storage estimate. The local machine running the survey had only **one MP3 / 2.6 MiB** at `C:\LOR\Audio`; do not assume other programmer workstations match.

| Source root | Count | MiB |
|---|---:|---:|
| `LOR_Source_Files\Audio` | 622 | 2552.9 |
| `LOR_Source_Files\Normalized Audio Albums` | 36 | 138.2 |
| `LOR_Source_Files\PurchasedMusic` | 13 | 80.7 |
| `LOR_Source_Files\Purchased LOR RGB Plus` | 90 | 230.5 |
| `2014\LOR\Audio` | 106 | 290.2 |
| `2020\LOR\Audio` | 162 | 452.7 |
| `2023\LOR\Audio` | 234 | 732.2 |
| `2024\LOR\Audio` | 363 | 1388.8 |
| `2025\LOR\Audio` | 446 | 1735.7 |
| local `C:\LOR\Audio` | 1 | 2.6 |

Default `YEAR\LOR\Audio` was NOT FOUND for 2015–2019, 2021, 2022, and 2026. **These are path misses only**; they do not prove the relevant years lack audio. The previously uploaded `MSB_Music_Normalized_History_v2.xlsx` was confirmed available and has six sheets: `AudioLibrary` (range A1:L52), `Sequences_SongsMaster`, `SongYearMatrix`, `Raw_Original_2023Sheet`, `PlaylistByYear_2019_25`, and `SequenceInventory_2019_25`. A sequence-history row references the alternate historical path `G:/Shared drives/Seasonal Files/2021/LOR S5 2021/Sequences/2019 Final/Musical`, demonstrating that default `YEAR\LOR` patterns may miss actual historical paths; current on-disk existence remains unverified.

**Next read-only evidence:** export a path-preserving filename/length/modified-date CSV of MP3s in these known roots, plus inventory the immediate subdirectory names under years with missing default `LOR\Audio` paths. The export should be on a local temporary path outside G: and `C:\LOR`, without opening MP3 contents or changing files. Use metadata to identify candidate same-name/same-size groups; hash only targeted candidates in a separately reviewed read-only stage.

### Nonstandard annual LOR layouts (operator directory listing, 2026-10-27)

The operator inspected immediate year-root directory names for years whose default `YEAR\LOR\Audio` path was not found. Alternative likely source roots exist at:

- `2015\LOR`
- `2018\LOR`
- `2021\LOR S5 2021` (consistent with a legacy catalog sequence path); `2021\LOR Setup` and `2021\Archive` also exist but are not yet evidenced as MP3 roots
- `2022\LOR`
- `2026\LOR`

No conventional `LOR` folder was listed at the root of 2016, 2017 or 2019. Those years may have audio in later archive copies or nonstandard named locations, **not proven missing**. The five alternate folder trees were subsequently scanned read-only: 2021 `LOR S5 2021\\Audio` contains 177 MP3s / 488.1 MiB, and the other four checked alternate roots contain none. The generated `MSB_Audio_Metadata_20261027_142222.csv` was uploaded and analyzed separately; its 2,073 rows do not include those 177 files. See the newer year-prefix checkpoint below.

### Legacy year-prefixed filenames: recording identity versus show history

**Operator-confirmed history:** Before a database was available, MSB prefixed every sequence filename and many audio filenames with a year to indicate when music played. These leading YYYY values are historical tracking labels, **not part of the song title or evidence of a new recording**. Retain the original filename/path exactly for existing Light-O-Rama references and archive traceability; extract a separate `legacy_year_prefix` field and a *candidate* match key for catalog reconciliation. A filename prefix alone is not sufficient evidence that the song actually played in that year; use playlist/show history to establish confirmed year-of-use.

Keep these distinct catalog dimensions:

- **Song/work identity:** logical title/artist classification, irrespective of a leading historical YYYY filename label.
- **Audio recording/file variant:** actual recording plus original/ripped versus `normalized-1db` derivative, separate cropped/edited mixes where demonstrated. Filenames alone do not prove byte equality or recording identity.
- **Audio file occurrence and aliases:** each original exact filename, recorded full path, size and eventually verified content hash; a year-prefixed variant remains traceable even when mapped to a shared recording.
- **Sequence source version:** actual `.loredit` files remain season/preview specific and must not be collapsed across years simply because song/audio identity matches.
- **Documented show-year usage:** historical year references/playlist evidence, separate from archive snapshot year and filename year label.

**Findings from operator-uploaded metadata-only CSV `MSB_Audio_Metadata_20261027_142222.csv`:** 2,073 MP3 occurrences, 517 distinct filenames (case-insensitive), 334 duplicate-candidate filename+size groups, and 40 filenames spanning multiple sizes. **535 file occurrences** (130 distinct names) start with a recognizable four-digit year label. Removing *only* that leading label produces **16 candidate multi-filename match families** in this CSV, including `2012 It's Beginning to Look a Lot Like Christmas.mp3`, `2014 It's Beginning to Look a Lot Like Christmas.mp3`, and the unprefixed name; this family includes three distinct recorded byte lengths. These are review candidates only; no renames, merged identities, confirmed identical MP3s, or deletion authorization follow from textual matching. Preserve exact audio names referenced in sequence XML until an approved remap is validated.

**Additional archive discovery:** `2021\\LOR S5 2021\\Audio` contained **177 MP3s, 488.1 MiB**, not represented in the CSV. Alternate `2015\\LOR`, `2018\\LOR`, `2022\\LOR`, and `2026\\LOR` contained zero MP3s. The known surveyed occurrence total is now **2,250 files / approximately 7.90 GiB**, but the 2021 file-level records still need to be collected before joining duplicate groups. An existing read-only local reconciliation workbook now has a **Year Prefix Candidates** tab; it is a report, not a migration manifest or source of truth.

**Next read-only evidence:** incorporate the 177 alternate-2021 MP3 occurrences into the metadata report and inspect modern `.loredit` audio path references; use historical song/playlist sheets to support year-of-use rather than treating the filename prefix as an identity. Content-hash verification can be narrowly scoped to reviewed candidates later, with attention to Google Drive streaming downloads. No approved canonical sync folder and no copying to the new Show PC.

### Season planning, musical workflow, and reusable animations — 2026 operator requirements

The catalog must replace past song/sequence year-prefix tracking with explicit catalog show-use history. Record the difference between historical file occurrence, planned selection, `Final` status, and actual played season. The conceptual database-neutral model is in [`docs/data_model.md`](../data_model.md) (proposed, not a schema approval).

**Original music** may stay in purchased/ripped artist/album collections; do not flatten or discard original files. The default audio family is one preserved original and one approved show-use normalized rendition **per distinct audio edit**. Shortened/cropped songs such as *Christmas Canon* are intentional alternate edits; they may need distinct normalized audio and sequence timing. There is no absolute two-file limit for songs with genuine alternate recordings/edits. The existing `normalized-1db` filename convention is evidence of an intended processing variant, not a proven loudness specification.

**Audio normalization proposal — no production change:** Do not normalize everything to 0 dBFS. A common sample-peak target is not an equal perceived-volume target for the local FM broadcast. Before selecting a recipe, compare original versus current normalized files, measured integrated LUFS and true peak, and the actual broadcast audio chain. Verify that the perceived-volume solution preserves desired music dynamics and acceptable modulation. A separate acceptance decision is required before any batch re-encoding or renaming.

**Seasonal musical edit workflow (operator confirmed):** Start each year's musical show by copying the preceding year's `Final` editable musical sequences into the new year's `Musical/Scratch`. Edited/tested sequences are promoted to that year's `Musical/Final`. For 2026 the intended relative folder workflow is:

```text
2025/Musical/Final (baseline)
    -> 2026/Musical/Scratch (working revisions)
    -> 2026/Musical/Final (accepted show-year revisions)
```

These labels are the conceptual folder contract, not a command to create/move files. Before any copy, confirm the actual root relative to `C:\LOR\Sequences` and embedded media/preview compatibility. Preserve distinct season-specific editable `.loredit` versions even when their shared audio is unchanged.

**Background animation workflow (operator confirmed):** Background animation content is often reused without modification across years; the catalog should track the reusable *animation identity* and the specific compatible file/revision selected for each season. At least four backgrounds will be refreshed for 2026. The old Open/Close sign has been replaced by a full matrix, which represents a new animation/layout revision; preserve older variants and do not overwrite the historical one or assume incompatible previews work unchanged. Distinguish the animation's identity from hardware/matrix/preview configuration and the year's actual use.

**Synchronization is downstream:** The intended library avoids annual audio copying entirely; a common maintained audio set is synchronized to the same local path on programmer PCs and Show PC once, with later changed files transferred incrementally. The original/ripped album archive does not necessarily need to be on every runtime PC. FreeFileSync Business is licensed for a trial only, not configured/authorized. Preserve the offline `C:\LOR` production contract.

**Next step remains read-only** physical audio inventory and `.loredit` reference inspection. No file copying, catalog database provisioning, normalization rewrite, media path remapping, or sync job configuration yet.

### Representative 2025 LOR XML inspection completed

The operator uploaded `2025 Greg Frosty The Snowman.loredit`. It parsed successfully as a 20,182,738-byte XML file. Root `<sequence>` contains `musicFilename="Frosty The Snowman-Jimmy Durante-SN.mp3"`, a **basename without a drive/path**, and song/artist metadata. The embedded preview is `2025 Master Musical Preview RGB Plus 25-11-14` (revision `54`) and the separate preview background image points inside `C:\LOR\Sequences\Images`. Other shape preview imagery points at G: and `C:\Users\greg\Downloads`; this raises programmer-PC preview portability concerns, not evidence that music/audio depends on G:.

The exact MP3 basename exists at five G: occurrence locations in the earlier metadata CSV, each recorded at 2,513,143 bytes (not hash verified); a similarly named `-1 db` derivative exists at 2,513,059 bytes and is **not** the song file referenced in this XML. The source XML root's `author` is `Light-O-Rama`, while `Greg` appears only in the supplied sequence filename; capture programmer attribution separately. Detailed engineering evidence and first-pass parser contract: [`loredit_audio_reference_investigation.md`](loredit_audio_reference_investigation.md).

### 2026 migration priority and accepted production facts (operator checkpoint, 2026-10-27)

**Work on the new Show PC has already advanced:** the operator has copied the previous year's **Final musical editable sequences and background sequences** onto the new Show PC. **No music/audio library has intentionally been transferred yet.** Earlier metadata found one existing MP3 under `C:\LOR\Audio`; that does not override the operator's confirmation that the show's music has not been migrated. Do not run another bulk sequence copy, select a synchronization destination, or pre-populate `C:\LOR\Audio` without a reviewed dependency/copy manifest.

**Revised near-term priority:** unblock the 2026 conversion of **2025 Final musical sequences** by identifying exactly which audio each copied editable sequence references, reconciling that against the historical audio occurrence inventory, and eliminating redundant *candidates* from the proposed 2026 selection. Do **not** make the full 2014–2026 audio deduplication project a prerequisite to beginning work on 2025 Final dependencies. A smaller confirmed 2026 audio-selection manifest is the first practical deliverable; wider archive cleanup follows.

**Authoritative use and programmer attribution (operator rules):**

- Every sequence placed in a given year's `Final` folder **was used in that year's show**. Treat the correct year's Final folder as authoritative show-use evidence in this workflow, retaining original filepath and archive-snapshot provenance; do not reduce it to merely "candidate official" when the folder is verified as Final.
- Programmer names embedded in sequence filenames (e.g., `Adam`, `Greg`) are **attribution labels**, not song identity, audio version, or production year. Store contributor identity separately; preserve filenames and exact source revision.
- On rare occasions the **same song has two independent sequences by different programmers**. Keep both sequence identities/revisions, relationships, and any actual Final show use. Do not merge them just because the title or referenced normalized MP3 matches.
- A year-prefixed filename is an older tracking convention, not the canonical song identity. The actual year-of-use is derived from Final folder membership plus later supporting history when needed.
- Musical sequences remain season/preview-specific despite shared audio. Background sequences may be reused unchanged or refreshed; no audio migration is needed to establish their presence on the PC.

**Near-term read-only acceptance flow:** (1) inspect one actual copied 2025 `.loredit` to validate how LOR stores the audio path; (2) extract all 2025 Final musical sequence-to-audio references without editing files; (3) match those exact references to the existing 2,073-entry metadata CSV, the additional unindexed 177 MP3s in 2021, and existing source workbooks; (4) group candidate filenames by preserved original name, optional historical year prefix, programmer/sequence identity, length and later targeted SHA-256 comparisons; (5) produce a **small reviewed 2026 audio copy manifest** with exactly one approved show-use rendition per actual audio edit, plus exceptions and unresolved items. The ongoing full-history catalog and archive deduplication remain separate follow-on tasks. A manifest is not authorization to copy.

**Database decision pending:** The operator already has working authentication in the MSB production application stack and is considering reuse for a future catalog, but does not have a separate catalog schema in the existing production PostgreSQL database and does not want to pollute it. The repository's **current** prohibition on installing catalog tables/functions in MSB Production Database stays in force until there is an explicit, documented architecture/ownership decision. Compare later: separate catalog database using existing identity/SSO, versus deliberately isolated database schema and roles with clear migration/backup/operational boundaries. Reusing login/authentication need not mean mixing data tables. **No database engine, hosting, schema, integration, or Production change is approved or required for this immediate file-level reconciliation.**

### 2025 Final read-only audio dependency scan (2026-10-27)

Uploaded scan report: MSB_2025_Final_Audio_20261027_152125.csv, produced from the already copied local 2025 Final folder.

- 114 .loredit records parsed without root-reading error: 27 have nonblank musicFilename; 87 do not.
- The 87 no-primary-MP3 records comprise 49 backgrounds, 37 stage-testing sequences, and one musical test (snowflake test santas station). Do not treat these as 87 missing songs.
- The 27 audio-bearing records comprise 25 files under Musical Sequences, one at Final root, and one operational Show cue. They reference 24 distinct MP3 basenames.
- All 24 basenames have exact matches in the uploaded 2,073-row audio metadata CSV, and all 24 have an occurrence in the 2025 archive's LOR/Audio. One 2025-archive occurrence per exact name totals 84,827,578 bytes (80.90 MiB). This is a candidate selection, NOT a verified copy manifest.
- Across scanned historical roots the 24 requested names have 88 physical file occurrences (unhashed). Another 177 MP3s under the alternate 2021 location have not yet been included in that metadata report.
- CRITICAL: same sequence basename "2025 Greg Christmas Canon-TransSiberian Orchestra.loredit" appears at Final root with Christmas Canon MP3, but in Final/Musical Sequences references 2015 Trans-Siberian Orchestra - Wizards in Winter.mp3. Preserve both; operator review required to determine correct intent.
- Four requested MP3 names appear with two recorded sizes each: First Snow-TransSiberian Orchestra-SN.mp3; Christmas Sarajevo 12-24-TransSiberian Orchestra-SN.mp3; Queen Of The Winter Night-TransSiberian Orchestra-SN.mp3; Wizards In Winter-TransSiberian Orchestra-SN.mp3. In each, the older 2020 archive has a different size than the later 2023–2025 files. Size is not proof of audio identity.
- The review workbook MSB_2025_Final_Audio_Dependency_Review_20261027.xlsx (not installed in the repo or copied to G:) contains five sheets: Summary, 2025 Sequence Scan, Required MP3 Review, Matching Audio Locations, and Review Exceptions.

Next: confirm the Christmas Canon source/version and the 2025 show-audio source choice; perform only targeted read-only content hashes after considering Google Drive streaming; decide the common local audio path; accept a limited 2026 transfer manifest BEFORE copying music. Do not copy the whole 2025 Audio collection or change LOR XML/media references now.

### 2025 proven-playback source selection supersedes premature exception gate (2026-10-27)

**Operator-confirmed decision for current work:** The 2025 show ran successfully using the media references embedded in the existing 2025 Final sequences/previews. The user cannot resolve or even inspect disputed sequence names/preview associations until the new Show PC's preview configurations are updated enough to open the sequences. **Do not make manual resolution of these exceptions a prerequisite to getting the 2025 baseline MP3s locally available.**

For *initial 2026 conversion*, preserve each copied 2025 Final sequence's **exact existing `musicFilename`** and take the **same-named file from `G:\Shared drives\Seasonal Files\2025\LOR\Audio`**, which has all 24 required basenames in the physical inventory. This is a defensible **source-selection rule grounded in last year's functional setup**, not proof that older same-named files have equal contents or that a filename describes the correct song. An explicit copy plan, destination approval, preflight, and post-copy checks are still required before any transfer; nothing is authorized to move as part of this documentation update.

**Defer**, but do not erase: two path-distinct Christmas Canon sequence files referring to different MP3s; four MP3 basename families with changed sizes in older archives; raw/normalized alternative selection; and historical deduplication. Both Canon audio basenames are already among the 24 required names, so the anomaly does not obstruct the initial exact-reference 2025-source media subset. Do **not** rewrite the `.loredit` files, substitute a `normalized-1db` variant, rename source files, or update their previews automatically. Revisit disputes in the LOR editor when the PC preview environment works.

The 24 2025-archive MP3 occurrences have a recorded aggregate length of 84,827,578 bytes (80.90 MiB). This number is a **read-only source manifest candidate**, not yet copy completion or player verification. The Show PC `C:\LOR\Audio` is the existing standard destination *candidate*, but any move to `C:\LOR-Audio` or other path remains undecided; for immediate compatibility, favor the existing standard path and validate the installed LOR's basename resolution before relying on it. Keep the permanent cloud-library design and broad deduplication independent of this urgent conversion need.

**Revised next gate:** turn the existing 2025 Final 24-name match report into a no-write, exact-source/exact-destination copy preview (one record per MP3 with bytes, source, destination, no overwrite, and current destination existence). Review it for missing source files or name collisions. Only then request explicit approval for the narrowly scoped transfer, confirm files locally, and reopen the 2025 sequences after their previews have been prepared. There is no need to hash 2020 archive copies or ask the operator to identify the correct Canon revision before the baseline audio becomes available.

### Historical 2023→2024 sequence conversion procedure reviewed — new 2026 design

The operator supplied `Converting 2023 Sequences to 2024.md` as **historical** evidence, not a current runbook. It covers (1) purchased RGB Plus intake, (2) previous-season Final-to-Scratch-to-Final edits via new preview/match settings/grid, and (3) legacy background animation/show scheduling. The old instructions embedded fixed 2023 master preview and Aux B/C breaking changes, named historical stages, annual G: paths, year-prefixed MP3s, Audacity -1 dB cropping/128-kbps CBR export, "ignore warnings," and deleting archived props. **None of those 2023-specific steps should be copied into a 2026 production procedure without testing against the entirely new 2026 Master Musical Preview.**

The accepted process principles are preservation of source files; conversion via a new approved preview/mapping/grid; song-by-song visual/effect review; and promotion to the season's Final set after verification. The user is replacing the manual annual conversion procedure with repeatable, evidence-driven operation. Do not implement automatic preview remapping based on assumptions.

Two **new documents** separate engineering choices from operator action: [2026 sequence conversion engineering proposal](2026_sequence_conversion_engineering.md) and [2026 conversion operator workflow — DRAFT](2026_conversion_operator_workflow_DRAFT.md). They are design/procedure proposals, **not yet accepted or tested**; precise 2026 master preview identity, matching map/grid versions, new season file anchors and pilot outcome remain unverified.

**Order:** first obtain explicit acceptance of a limited, exact-name 2025 audio transfer manifest, then obtain the installed 2026 master-preview/mapping identifiers and perform a **single non-destructive pilot** on a working copy; refine the operator procedure based on observed results. Preserve historical Final files and the 2025 original MP3 names. Broader audio cleanup and database architecture remain deferred.

### LOR preview / Production Database authority correction (2026-10-27)

**Supersedes all historical conversion directions about 'delete archived Props,' independently changing Display or network assignments, and reusing old 2023 match/map/grid procedures.** The 2026 conversion cannot create a new Preview lifecycle. The current Preview authoring and database identity/assignment process is wholly owned by `Gregovate/MSB-Production-Database-Project`, not this music catalog.

**Current authoritative operator/source references in that repository:**

- [Preview Import Workflow](https://github.com/Gregovate/MSB-Production-Database-Project/blob/main/Docs/01_LOR_System/01_Preview_Authoring/Preview_Import_Workflow.md): use the latest completed LOR2DB reconciliation report to locate the approved preview; import a copy without overriding the approved master.
- [Building a Preview](https://github.com/Gregovate/MSB-Production-Database-Project/blob/main/Docs/01_LOR_System/01_Preview_Authoring/B_Building_Preview_Howto.md) and [Master Musical Preview](https://github.com/Gregovate/MSB-Production-Database-Project/blob/main/Docs/01_LOR_System/01_Preview_Authoring/E_Master_Musical_Preview_Howto.md): preview design and versioned annual Master Musical Preview.
- [Prop and Display Naming Conventions](https://github.com/Gregovate/MSB-Production-Database-Project/blob/main/Docs/01_LOR_System/01_Preview_Authoring/A_Naming_Conventions.md) and [LOR XML to MSB terminology](https://github.com/Gregovate/MSB-Production-Database-Project/blob/main/Docs/01_LOR_System/02_Data_Extraction/LOR_XML_to_MSB_Terminology_Contract.md): controlled Display Name (`PropClass.Comment`), Channel Name (`PropClass.Name`), identity and network/channel grid meaning.
- [LOR System Overview](https://github.com/Gregovate/MSB-Production-Database-Project/blob/main/Docs/00_Project_Overview/00_LOR_System_Overview.md): Office PC is currently the designated master; V7 and LOR2DB reconciliation govern promotion into permanent production identities.

**The `Comment` field is not freeform annotation**; it is the controlled physical Display Name linkage used by the LOR-to-Production reconciliation. A permanent production Display is identified by `display_id`, separately from LOR Prop/Preview IDs. LOR is the source for the approved show programming/wiring configuration (Scenes, Displays/Channels, networks, controller/UID/channel assignments), whereas the Production Database owns permanent physical Display identity and operational records. Neither this music catalog nor sequence-conversion scripts may reinterpret or write those relationships.

Therefore, the **Music & Sequence Catalog** only defines audio identity and version provenance, sequence year/programmer/revision, selected approved preview ID/name/revision as an external reference, musical effect/timing validation, and Scratch-to-Final history. Approved preview creation/editing, Preview Merger, source parser, LOR2DB import/reconciliation, and controlled Display/network changes remain governed **exclusively in the Production Database repository**. A preview/channel integrity problem should be reported through that existing process; there is **no blanket archived-Prop deletion or automatic network migration step in musical conversion**.

Note: the Production Preview Authoring procedure separately governs a moved Display's vacated LOR channel (replace the old object with a correct SPARE). That specific authoring operation is **not** authority to delete 'archived Props' from a converted sequence.

The [2026 conversion engineering proposal](2026_sequence_conversion_engineering.md) and [operator workflow DRAFT](2026_conversion_operator_workflow_DRAFT.md) now defer to those living source documents. They must not become an independent Preview operations runbook; any completed pilot must use the approved Preview and must not update Production or the LOR master as a side effect.

### 2025 to Show PC selective audio preflight PASS — 2026-10-28

Operator ran the exact-name read-only PowerShell preflight on the **new Show PC** using `MSB_2025_Final_Audio_20261027_152125.csv` and these paths:

- Source: `G:\Shared drives\Seasonal Files\2025\LOR\Audio`.
- Target: `C:\LOR\Audio`.
- All 24 referenced distinct MP3 basenames are present as accessible source filesystem entries; 24/24 report `READY FOR REVIEW`.
- Zero `SOURCE MISSING`; zero `TARGET EXISTS - REVIEW` for these 24. Pre-existing unrelated files in the destination were not checked by this status.
- Recorded source sum = **80.90 MiB** (84,827,578 bytes from earlier manifest). **NO FILES COPIED** confirmed by the operator's transcript.

This is a **metadata/path-only PASS**, not a content hash/decoder/offline playback PASS or operator approval to copy. Do not claim FreeFileSync was configured or that the final canonical audio library was created. Existing 2025 `.loredit` references must remain exact, with no basename renaming, raw-versus-normalized substitution, or archive delete. Distinct 2025 Final sequence versions and Preview/Production Database authority remain unchanged.

**Controlled next gate:** operator to explicitly accept or reject the precise one-time *no-overwrite* selection of these 24 exact 2025 source filenames into `C:\LOR\Audio` on the Show PC; any resulting transfer instruction must follow a reviewed owner runbook and stop on an unexpected source/target conflict. Verify all copied file sizes and hashes from source to destination and local LOR music resolution afterwards. This one-time migration is **not** approval for ongoing FreeFileSync synchronization or source-archive cleanup. Until explicit approval, no transfer commands are authorized.

### 2025 Final audio — one-time selective transfer approved (2026-10-28)

**Operator authorization confirmed:** After 24/24 source checks and zero destination-name conflicts, the operator explicitly approved the transfer, emphasizing that this is **only the start** of the larger audio-library project. Scope remains EXACTLY 24 filenames and 84,827,578 bytes from G:\Shared drives\Seasonal Files\2025\LOR\Audio to C:\LOR\Audio, with NO OVERWRITE, no source mutation and no FreeFileSync. The transfer has **not yet been executed**; a successful preflight is not a completion receipt.

**RUNBOOK GAP FOUND / RESOLVED IN DOCUMENTATION:** The repository previously lacked a specific operator-controlled Show-PC audio copy/verification/recovery procedure. A governed one-time [2025 Final Audio Copy Operator Procedure](2025_Final_Audio_Copy_Operator_Procedure.md) now defines the exact approved operation, tool version/source, Preview then Copy stages, stop-on-failure behavior and SHA-256 receipt. The pinned execution script is tools/transfer_2025_final_audio_v0_1_0.ps1 release V0.1.0, original source commit 549aef6f9c5e38db1374decfc34593fdabeb8b78. This is a *new, distinct copy-capable tool*, not the read-only inventory scanner. Avoid treating the script's version number as an ongoing synchronization version.

**Next operator step:** Run the SOP's Preview mode on the Show PC and check exact 24/84,827,578 source/destination checks. If PASS, execute the specifically authorized one-time Copy mode exactly once, preserve its local TEMP receipt and report the final PASS or HOLD. No repeated Copy after a partial failure. Broader deduplication, normalized/original audio decisions, canonical G: location, FreeFileSync sync configuration, database and 2026 preview conversion remain separately governed work.

### Initial 24-MP3 transfer verified; year-prefixed filename model deprecated — 2026-10-28

The operator ran V0.1.0 `Copy` on the new Show PC and provided output: initial preflight 24 sources / 84,827,578 bytes / zero destination-name conflicts, **24 distinct `VERIFIED` files**, `VERIFIED FILES: 24/24`, and retained report `C:\Users\LIGHT-~1\AppData\Local\Temp\MSB_2025_Audio_Transfer_V0.1.0_20261028_114621.csv`. This version logs `VERIFIED` only after source/staging and destination SHA-256 comparisons. Thus the first 24 MP3 files have been copied and per-file verified. The final `PASS:` footer was not provided and the report was not uploaded, so formal script terminal closeout is **not independently confirmed**. **Do not rerun Copy.**

The operator emphasized the fundamental weakness of historical *year-prefixed MP3 filenames*. The 2025 Final dependencies include files beginning `2015`, `2021`, `2022`, and `2025`, along with many filenames without a year. A legacy prefix represents old introduction/editing convention and may not prove the first-used year; it certainly is not the year of current playback. The conceptual [data model](../../data_model.md) now explicitly separates **Song, Recording, Audio Edit/Rendition, historical introduced-year evidence, annual Final played-year usage, physical occurrence and exact LOR legacy filename reference**. MP3 bitrate, normalizing/cropping and source release/version are audio processing attributes, not canonical song keys. Operational show cues remain distinct from musical songs.

**Do not rename any existing audio file or rewrite an LOR `.loredit` reference to implement the future naming convention.** The finished first-stage transfer intentionally preserves the old filenames so last year's sequences can open. Full catalog deduplication, canonical library naming/location, FreeFileSync, and database design are downstream of LOR local playback and 2026 preview compatibility checks.

### Show PC updated-preview readiness; controlled LOR open-only pilot (2026-10-28)

**Operator reports all required previews are updated on the new Show PC.** This establishes local installation readiness only; approved Master Musical Preview identity/revision and provenance from latest completed LOR2DB reconciliation remain to be verified before any master Preview changes. The first 24 source-referenced 2025 MP3s were copied locally and individually SHA-256 checked, but the final transfer script PASS footer was not provided. Do not repeat Copy.

**NEXT OPERATOR ACTION — no file mutation:** Open `C:\LOR\Sequences\2025 Final\Musical Sequences\2025 Greg Frosty The Snowman.loredit` in the Show PC LOR Sequencer, confirm it resolves `Frosty The Snowman-Jimmy Durante-SN.mp3` locally in `C:\LOR\Audio`, starts/plays audio and displays its original 2025 preview/effects without media/preview prompt. Capture any warning/dialog/Preview name and revision; do not assign the 2026 preview or save the 2025 Final source in this first pass. Close without saving. See [2026 conversion operator draft 0.3](2026_conversion_operator_workflow_DRAFT.md).

**Only after a clean open-only result:** choose a separate, verified 2026 Scratch working-copy path, identify the exact approved 2026 Master Musical Preview and test one reversible conversion with the authoritative Production Database LOR preview procedure. Broader catalog-wide canonical naming/audio remapping is still design work and remains unapproved for mass file changes. FreeFileSync remains installed but unconfigured.

### Christmas Canon audio corrected in 2026 Scratch — operator clarification (2026-10-28)

**Correction to the earlier investigation:** The operator did not edit either historical 2025 Final file. The incorrect attached song in Christmas Canon was fixed in the **2026 Scratch working copy**, where new-year musical sequence changes belong. The earlier October 27 read-only scan showed two 2025 Final locations, with distinct MP3 references, and the October 28 read-only check showed those *historical 2025 Final* references still intact. **This is expected and not a failed save or outstanding repair on 2025 Final.**

Sequence lifecycle contract: preserve 2025 Final exactly as historical show-use evidence; track the new 2026 Scratch revision as a separate working sequence with a copied-from relationship; store its **corrected audio reference** as belonging to that 2026 sequence revision; promote only an accepted 2026 working revision to 2026 Final. The corrective 2026 Scratch file's exact path and `musicFilename` have **not yet been extracted**, so do not invent those fields. Also do not silently rewrite the 2025 Final inventory or replace its old media evidence with the new 2026 value.

**Next evidence only if needed for the 2026 dependency manifest:** read the audio reference from the actual saved **2026 Scratch** file, not the 2025 Final archives. Both of the historically referenced MP3 names were already in the first 24-file copied-and-verified set; do not repeat the selective transfer. The 2026 conversion must continue to use the existing MSB Production Database repository's approved Preview, Display Name/Comment and network authority.

### Original-recording master catalog — inventory-first workstream (2026-10-28)

**New operator priority:** Scan the **whole** `G:\Shared drives\Seasonal Files` tree and build a true non-year-specific catalog with **Originals first**. Ripped and purchased album tracks should preserve their existing artist/album/track directories under one proposed master `G:\Shared drives\Seasonal Files\LOR-Audio\Originals\Albums`, with reviewed single files under `Originals\Singles`. A separate `LOR-Audio\Show-Audio` will later hold the Audacity-normalized show-use copies (and explicitly distinct timed/edited versions). The operator explicitly confirmed: **normalized files are for SHOW copies, never raw/originals**. Do not classify files without a 'normalized' marker automatically as originals.

Current artifacts: [Original Audio Catalog Engineering](Original_Audio_Catalog_Engineering.md) (design 0.2), [Original Audio Catalog Operator Scan](Original_Audio_Catalog_Operator_Scan.md) (procedure 0.2), and **read-only** [`tools/scan_seasonal_original_audio_v0_2_0.ps1`](../../tools/scan_seasonal_original_audio_v0_2_0.ps1). V0.2.0 supersedes V0.1.0 before first operator run and separates normalized/edited Show-Audio review candidates from Originals. Source scan is recursive across all of Seasonal Files, including 2021 alternate audio and album folders. It creates local TEMP reports, **does not create/populate master**, does not hash file bytes and never edits source G: or Show PC audio/sequence files.

**NEXT ACTION:** Run the V0.2.0 pinned read-only scanner on the Show PC using the operator scan procedure. Bring back summary, full inventory, Originals proposal, album folders and separately normalized Show-Audio candidate files. Review actual source identities, duplicate candidate groups, and proposed album hierarchy; produce/approve a strict no-overwrite, source-hash-verified copy manifest before creating or populating any `LOR-Audio` master folder. Do not begin FreeFileSync or automated sequence rewrites. The already completed initial 24 local show MP3 copies remain unchanged.

### Seasonal Files scan V0.2.0 interrupted; V0.3.0 resumable replacement (2026-10-28)

Operator stopped first full-tree V0.2.0 scan with Ctrl+C; no G: files changed. Root cause: V0.2.0 used an eager recursive full-tree directory enumeration with no useful staged progress, no checkpoint/resume and a stale V0.1.0 printed identity. **Do not rerun V0.2.0 or treat incomplete output as a complete library.**

Improved **[V0.3.0 resumable PowerShell scanner](../../tools/scan_seasonal_original_audio_v0_3_0.ps1)** released on existing migration branch, pinned immutable source commit `1011c34c1bac2f68441896be82dc8f6f75621b51`. It streams one directory, checkpoints completed folders atomically to local `%LOCALAPPDATA%\MSB\SeasonalAudioCatalogScanV0_3_0`, shows directory progress, supports `-MaxNewDirectories 100` for a bounded live test, automatic `-Mode Scan` resume and `-Mode Report` offline partial CSV generation. No file bytes are read or hashed, and no source audio, original album structure, master folder or Show PC sequence is changed. It excludes the proposed LOR-Audio master. Normalized/edited items remain Show-Audio review only and purchased-sequence bundled music retains provenance-review status.

**NEXT OPERATOR ACTION:** follow the updated [Original Audio Catalog Operator Scan](Original_Audio_Catalog_Operator_Scan.md) revision 0.4. Fetch pinned V0.3.0 to local TEMP; run a bounded first 100-directory scan, inspect for errors/progress, then use the identical script in `-Mode Scan` for overnight resume. If interrupted, rerun Scan later or run Report for CSVs from completed checkpoints only. Report PARTIAL/coverage explicitly. Do not enable FreeFileSync or copy/rename Originals until manifest review.

## Immediate next step

Do **not** write a copier first.

The 114-file 2025 Final primary audio-reference scan is complete: 24 unique referenced MP3 names all exist in last year's `2025\LOR\Audio`. **The exact-name read-only source/destination preflight PASS is now complete:** all 24 source files exist, none of the 24 destination names exist, and the total is 80.90 MiB. **Approved 2026-10-28:** a narrowly-scoped, one-time, no-overwrite copy of those 24 verified 2025 files, subject to the new owning operator SOP's fresh Preview and independent SHA-256 post-copy verification. **Operator now reports 24/24 copied and SHA-256 verified** (receipt path recorded, terminal PASS footer not provided); no ongoing synchronization has been configured. **Do not repeat the one-time Copy command**; local playback, approved 2026 preview compatibility and later canonical audio catalog design are the next separate steps. The operator has since corrected the misattached Christmas Canon song in the separate **2026 Scratch working revision**; 2025 Final remains historical evidence. Extract the actual 2026 Scratch `musicFilename` when building the 2026 manifest. The older-archive byte-size conflicts remain deferred historical deduplication issues. The initial root-attribute scan does not establish all other external-media dependencies.

The first engineering deliverable should be a read-only inventory/report that can answer:

- which sequence files exist by year;
- which media file each sequence references;
- which audio references point to the same underlying audio asset;
- where candidate source media exists in the archive;
- duplicate audio files versus truly different edits/versions;
- missing media;
- which canonical audio files would be required for a selected migration set;
- which sequence and audio files must be synchronized to the local Show PC.

Only after that report is accepted should a copy operation be designed.

## Workstream boundary

PC operating-system setup, Windows/Chrome/Python/Git installation, NIC/audio hardware configuration, and general appliance setup stay in the existing Show-PC setup workstream.

This repository/workstream owns the **music, sequence, history, dependency, and media migration** problem, including any future independent catalog database. It does not become a subsystem of `MSB-Production-Database-Project` merely because both are MSB projects.
