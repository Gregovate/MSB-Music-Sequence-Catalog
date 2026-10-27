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

## Immediate next step

Do **not** write a copier first.

Annual LOR folder layout discovery and the initial 2,073-file audio occurrence inventory are completed. The first-pass root-level XML inventory of all 114 files and the 24-name audio reconciliation are complete. Next: resolve conflicting Christmas Canon source files, verify four MP3 same-name/different-size families, review the 2025-archive 80.90 MiB candidate subset, and approve the local audio path and selective manifest before any file transfer. This does not yet validate complete external-media dependencies. Do not copy any music onto the Show PC until the resulting 2026 media manifest is reviewed.

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
