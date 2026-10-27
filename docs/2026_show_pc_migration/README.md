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

## Immediate next step

Do **not** write a copier first.

The next step is read-only discovery of the annual LOR folder layouts and the actual sequence file formats present, followed by inspection of how those sequence formats record their audio/media references.

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
