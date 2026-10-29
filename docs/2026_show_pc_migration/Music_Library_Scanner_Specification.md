# Music Library Inventory Scanner — V0.3.0 Specification and Interface Contract

| Control | Value |
|---|---|
| File | `docs/2026_show_pc_migration/Music_Library_Scanner_Specification.md` |
| Revision | 0.1 — 2026-10-28 |
| Status | Scanner specification and observed bounded acceptance; **not a catalog ingest or audio copy authorization** |
| Repository branch | `docs/2026-show-pc-migration` |
| Script | `tools/scan_seasonal_original_audio_v0_3_0.ps1` |
| Immutable script source | `1011c34c1bac2f68441896be82dc8f6f75621b51` |
| Related designs | [Originals master design](Original_Audio_Catalog_Engineering.md); [cross-workstream coordination](Music_Library_Cross_Workstream_Coordination.md) |

## Mission

Inventory physical audio **occurrences**, not yet canonical compositions/recordings and not yet PostgreSQL rows. Capture entire `G:\Shared drives\Seasonal Files` tree as one authorized source scope, including 15 years of annual archives and non-LOR locations. Preserve ripped album/artist/disc/source-package directory names and detect purchased LOR sequence-bundled music; do not guess a supplier's audio rendition.

The scanner **never writes to G:, a music master, C:\LOR\Audio, any sequence, or a database**. It does not hash audio contents, rename files, move files, normalize or copy MP3s. It writes only its local checkpoint and reports under LOCALAPPDATA. The master `G:\Shared drives\Seasonal Files\LOR-Audio` is proposed/excluded from source enumeration, not created.

## Version and prior implementations

- V0.1.0 and V0.2.0 are investigation predecessors. V0.2.0's eager `Get-ChildItem -Recurse` whole-tree enumeration was stopped with Ctrl+C and does not support resume. Its console identity was stale. **Do not run it as the authorized full scan**.
- V0.3.0 is the current, resumable metadata scanner. Its PowerShell source was added in the exact pinned commit above. Changes to classification, selection, path resolution or outputs require a new **version** and operator acceptance, not silent replacement.
- An operator ran `-Mode Scan -MaxNewDirectories 100` on the Show PC on 2026-10-28. Result: **100 directories completed; 53 audio occurrences; 175 presently discovered pending; PARTIAL expected; no reported runtime error.** This is bounded runtime evidence only. Do not report full coverage or a completed catalog.

## Inputs and modes

| Input | Contract |
|---|---|
| `-SeasonalRoot` | Default `G:\Shared drives\Seasonal Files`; root identity persisted, unexpected source change is HOLD |
| `-SessionDirectory` | Default `%LOCALAPPDATA%\MSB\SeasonalAudioCatalogScanV0_3_0`; separate from G: |
| `-Mode Scan` | Stream directory entries, persist each fully enumerated folder to a local atomic JSON checkpoint; automatically reuse prior completed directories |
| `-Mode Report` | Build reports **only from existing local checkpoints**, without enumerating unvisited G: folders |
| `-MaxNewDirectories N` | Bounded new-folder count for a trial; 0 is unbounded scan/resume |
| `-ProgressEvery` | Progress reporting cadence; default 25 directories |

Source file classes scanned: `.mp3`, `.wav`, `.flac`, `.m4a`, `.aac`, `.wma`, `.aif`, `.aiff`, `.ogg`, `.opus`. Other files are not output as audio. A subset of `.cue/.m3u/.m3u8/.jpg/.jpeg/.png/.log/.nfo` album-related sidecars is **counted**, not imported, and can inform a future original album metadata pass. Directory links are skipped to avoid recursion loops and require coverage review; errors fail closed.

## Outputs and stable draft row contract

Reports reside in the local session's `Reports` folder. Some CSVs are absent when no rows match; the summary records paths and counts. **Do not load incomplete reports into PostgreSQL as canonical catalog rows.**

| Report | Meaning |
|---|---|
| `MSB_All_Seasonal_Audio_*.csv` | Exact `SourcePath`, `SeasonalRelativePath`, `SourceFolder`, `FileName`, `Extension`, `SizeBytes`, `ModifiedUTC`, `SourceFamily`, `Classification`, `Reason`, `AlbumOrCollectionFolder`, `ProposedOriginalPath`, `Decision`, blank `SHA256` |
| `MSB_Original_Candidates_*.csv` | Review-only source path, proposed Originals destination, metadata, grouping, `DestinationCollisions`, `REVIEW_REQUIRED`. Not proof of an original or permission to copy |
| `MSB_Show_Candidates_*.csv` | Normalized/edited show-rendition candidates **excluded from Originals** |
| `MSB_Album_Folders_*.csv` | Existing source album/collection group names, counts and sizes, still requiring provenance checks |
| `MSB_Scan_Summary_*.txt` | Tool/version, mode, source root, session, completed/pending folder counts, audio occurrence count, skipped links, `CoverageComplete`, file paths and `NoAudioChanged=True` |

A future database ingest must retain source-root identity, scanner version/commit, checkpoint/report identity, coverage status and original exact path. Do not use `ProposedOriginalPath`, `FileName` or MariaDB's damaged `full_path` as a recording's permanent identity. Actual physical relational table design depends on a reviewed shared data model and database placement decision.

## Conservative classification and provenance

- `PURCHASED_MUSIC` and `SOURCE_AUDIO_COLLECTION` may produce **Originals candidates** with original nested album folders intact. Every row remains `REVIEW_REQUIRED`.
- `PURCHASED_LOR_SEQUENCE_BUNDLE` leads to `BUNDLED_AUDIO_REVIEW`: audio may be vendor source or supplier processed; sequence-package relationship remains essential.
- `NORMALIZED_SHOW_REVIEW` means show-rendition candidate, **NEVER a raw original**; `EDITED_SHOW_REVIEW` similarly excludes known edited-file hints from automatic Originals selection.
- `ANNUAL_AUDIO_REVIEW` and `UNCLASSIFIED_REVIEW` cannot be declared original merely for lacking a processing marker.
- Year prefixes refer to historical introduction/filename convention, not recording identity or proof of actual show year.
- Same filename/size is not enough to deduplicate. Only selected read-only SHA-256 (later stage) can establish byte equality; different edit/duration/normalization passes remain distinct renditions.

## Fail-closed and completeness semantics

Source enumeration interrupted mid-folder leaves that folder uncommitted; only completed checkpoints are replayed. Failure retains local work, stops and requires investigation. `PARTIAL` and `CoverageComplete=False` explicitly mean **not yet an archive-wide inventory**. At the bounded test, the 175 pending directories are *currently discovered*, not guaranteed total. Additional non-Seasonal-Files volumes remain out-of-scope until a separately authorized discovery pass.

The file inventory is a proposed **future domain-ingestion interface**, not a migration of the four historical MariaDB tables. It can be compared to `raw_show_sequences`, `shows`, `sequences`, `show_sequences` only through reviewed, provenance-preserving matching, without trusting filename-only correspondence or malformed path fields.

## Acceptance before downstream implementation

1. Complete/resume V0.3.0; collect `CoverageComplete` and exceptions plus all five source reports.
2. Review albums, purchased sequence bundle files, edited/normalized candidates and unknowns; select Originals only with actual evidence.
3. Decide canonical cloud master path, physical-copy no-overwrite/rollback plan and a governed source-hash manifest.
4. Review persistent song/recording/audio edit/rendition/file-occurrence identity and PostgreSQL target boundary with the parallel migration branch; **no data or DDL writes until approval**.
5. Make implementation PRs consume **approved** design revisions. Do not create a separate competing scanner or DB schema as a shortcut.
