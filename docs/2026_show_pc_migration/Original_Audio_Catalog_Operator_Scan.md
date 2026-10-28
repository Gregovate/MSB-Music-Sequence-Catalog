# Originals-First Audio Master — Seasonal Files Scan Operator Procedure

| Control | Value |
|---|---|
| Filename | docs/2026_show_pc_migration/Original_Audio_Catalog_Operator_Scan.md |
| Revision | Operator scan 0.4 (2026-10-28) — progress/resume scanner |
| Status | Read-only discovery approved; ORIGINALS source copy/creation NOT yet authorized |
| Runtime | Show PC PowerShell, current logged-in Windows LOR user |
| Master candidate | G:\Shared drives\Seasonal Files\LOR-Audio |
| Scanner | tools/scan_seasonal_original_audio_v0_3_0.ps1 |
| Pinned scanner commit | 1011c34c1bac2f68441896be82dc8f6f75621b51 |
| Design | Original_Audio_Catalog_Engineering.md |

## Intent and owner decisions

Scan **all** of G:\Shared drives\Seasonal Files to find original source recordings, ripped/purchased albums, annual archives, and processed show-use MP3s. **Originals are the original unmodified files. Normalized files are SHOW AUDIO copies, never raw originals.** Ripped/purchased album tracks keep their relative artist/album/track folder structure. Preserve entire archive intact. The candidate new master is a separate LOR-Audio root with Originals and Show-Audio subfolders, and must not be created or populated from scanner classification alone.

All audio classifications are tentative until source/processing provenance is verified. No automatic renaming or deduplication, and no FreeFileSync synchronization. The existing 24 Show PC local MP3 transfers are a different completed initial migration; this scanner does not touch them.

## Authority and mutation boundary

Authority: Gregovate/MSB-Music-Sequence-Catalog — System_Documentation/Project_Rules/Repository_Change_Workflow.md and this operator scan procedure.
Procedure: scanner V0.2.0 read-only seasonal inventory and review.
This step: list filenames/metadata under G:, write reports ONLY to Windows TEMP. Do not create LOR-Audio yet.

This tool has no copy, delete, hashing, normalization or synchronization mode. It does not rewrite sequence XML or LOR physical Display/Preview metadata.

## Previous scan V0.2.0 — interrupted; do not resume

The operator stopped V0.2.0 with Ctrl+C. That release used a full-tree Get-ChildItem -Recurse enumeration without directory-level progress or resumable checkpoints, and its printed tool identity was incorrect (V0.1.0). It did not change source files. Any partial V0.2.0 results are NOT evidence of complete archive coverage. **Do not run V0.2.0 overnight or reuse its output as the new master manifest.**

The replacement is V0.3.0. Its checkpoint state has a new local session version; it does not pretend it can resume the incomplete V0.2.0 process. A new scan starts at the requested root; within V0.3.0, stopping and restarting **does** resume completed directories.

## Step 1 — Fetch improved scanner V0.3.0

Run on the Show PC in PowerShell. The script is pinned to exact repository source commit, and saved to local TEMP; no audio source is modified.

    $scanner = Join-Path $env:TEMP 'MSB_Seasonal_Audio_Catalog_Scan_V0.3.0.ps1'

    Invoke-WebRequest -UseBasicParsing -ErrorAction Stop -Uri 'https://raw.githubusercontent.com/Gregovate/MSB-Music-Sequence-Catalog/1011c34c1bac2f68441896be82dc8f6f75621b51/tools/scan_seasonal_original_audio_v0_3_0.ps1' -OutFile $scanner

    Test-Path -LiteralPath $scanner -PathType Leaf

Must return True; otherwise STOP. Inspect the script before running. The pinned release identity must print V0.3.0.

## Step 2 — Scan with progress and automatic resume

    powershell.exe -NoProfile -ExecutionPolicy Bypass -File $scanner -Mode Scan

The scan enumerates **one directory at a time**, streaming its children without holding a complete 15-year tree in memory. The script writes an atomic checkpoint to **LOCALAPPDATA**, then continues to the next folder. Typical printed progress:

    TOOL: MSB Seasonal Audio Catalog Scanner V0.3.0
    CHECKPOINT: new=25 old=0 queued=... audio=... elapsed=...s

Progress prints after the first newly completed folder and every 25 additional newly completed directories, plus a per-directory count every 5,000 entries in a very large directory. Progress is not a timer, and a Google Drive filesystem call may be temporarily slow. No file contents are read or hashed, and no source files are copied, changed, or deleted.

Default durable checkpoint location:

    $env:LOCALAPPDATA\MSB\SeasonalAudioCatalogScanV0_3_0

Checkpoints and report files are **local only**, outside G:\Shared drives\Seasonal Files. Completed folder checkpoints are stored under CompletedDirectories; reports under Reports. The proposed master folder LOR-Audio is excluded as an input.

**If interrupted:** Ctrl+C stops the process. It is safe to run the *same* Scan command later. Completed directory checkpoints are reused; the unfinished directory is scanned from the beginning. Never delete the checkpoint directory just to make it scan again.

For a deliberate bounded pilot, this alternative scans at most 100 *new* directories in one invocation; it can be resumed later with the normal Scan command:

    powershell.exe -NoProfile -ExecutionPolicy Bypass -File $scanner -Mode Scan -MaxNewDirectories 100

## Step 3 — Inspect checkpoint results without resuming G: enumeration

    powershell.exe -NoProfile -ExecutionPolicy Bypass -File $scanner -Mode Report

Report mode reads local completed-directory records and produces CSV/TXT reports **without opening any unscanned G: folder**. Use this after Ctrl+C if you want to see partial progress. In a partial report, CoverageComplete=False and KnownPendingDirectories is only the presently discovered queue; undiscovered subfolders may still exist below pending directories.

Expected report folder:

    $env:LOCALAPPDATA\MSB\SeasonalAudioCatalogScanV0_3_0\Reports

Generated files, when the relevant rows are present:

- MSB_All_Seasonal_Audio_*.csv — exact source paths, formats, size and candidate roles.
- MSB_Original_Candidates_*.csv — original and album placement proposals, REVIEW_REQUIRED; no file copied.
- MSB_Album_Folders_*.csv — candidate album/collection folder grouping.
- MSB_Show_Candidates_*.csv — normalized and edited show-use candidates, **excluded from Originals**.
- MSB_Scan_Summary_*.txt — version, source root, counts, pending/complete flag, output paths.

Completion prints SCAN COMPLETE or SCAN COMPLETE WITH REVIEW (e.g., directory links excluded to prevent recursion cycles). If a folder enumeration fails, the tool stops with HOLD, retains prior completed checkpoints, and must be investigated before a subsequent resume. Completed directories are not silently marked as successfully enumerated after an error.

## Step 3 — Stop and review

Send or upload **the summary TXT and the complete CSV inventory/candidate/album/show reports**. Large CSV files can be compressed into a ZIP first if convenient. Do not upload private account credentials, personal files or media bytes; reports are just file paths and metadata, but still review what will be shared.

Expected classifications:

- NORMALIZED_SHOW_COPY_REVIEW / EDITED_SHOW_COPY_REVIEW: **for Show-Audio later**; never placed into Originals automatically.
- ORIGINAL_ALBUM_CANDIDATE and ORIGINAL_SINGLE_CANDIDATE: purchased-source evidence, still review actual original status.
- POSSIBLE_ALBUM_REVIEW and POSSIBLE_ORIGINAL_SINGLE_REVIEW: may be raw/album, stock effects, or misleading folders. REVIEW_REQUIRED.
- PURCHASED_SEQUENCE_AUDIO_REVIEW, ANNUAL_AUDIO_REVIEW, REVIEW_UNCLASSIFIED: unresolved and not approved for either master collection.

Review folder semantics, genuine originals, album artist/album/track paths, duplicate bytes (later separate hash pass), and destination-name conflicts. A candidate line is NOT permission to copy.

## Gate before building/populating the master

Only after user reviews a concrete per-file/album selection manifest, destination structure and collision decisions may a separate **no-overwrite, hash-verified copying procedure** be approved. Historical audio archives must remain untouched. No planned bulk-copy, move, delete, XML rewrite, normalization or FreeFileSync operation can happen based on this scanner output alone.

The later Show-Audio phase will reuse validated processed files. A normalized show file is a rendition or edit derived from an original, not a second raw original.
