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

## Canonical audio library — not annual duplicates

Audio is **not** year-specific unless the actual audio content is different.

Do not create separate copies of the same song/audio file inside every annual `Seasonal Files\<YEAR>\LOR` tree merely because multiple yearly sequences use it.

The intended model is:

```text
one canonical audio asset
        ↑
        ├── 2024 sequence
        ├── 2025 sequence
        └── 2026 sequence
```

Each sequence should reference the same canonical audio file when the underlying audio is truly identical.

Only create a distinct audio asset when the file is materially different, for example:

- different edit/cut;
- different duration;
- different mix/master;
- different normalization/leveling;
- different intro/outro;
- different file content despite a similar title.

On the Show PC, the canonical local runtime location remains:

```text
C:\LOR\Audio
```

The Google Drive side should likewise have a **single canonical audio-library location separate from the annual year folders**. The exact Google Drive path for that canonical audio library still needs to be confirmed before implementation; do not invent it.

The catalog should track relationships between:

```text
audio asset
  -> one or more sequence versions
  -> one or more show years
```

rather than treating each year's audio copy as a new audio identity.

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
