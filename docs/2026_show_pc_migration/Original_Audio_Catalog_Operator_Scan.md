# Originals-First Audio Master — Seasonal Files Scan Operator Procedure

| Control | Value |
|---|---|
| Filename | docs/2026_show_pc_migration/Original_Audio_Catalog_Operator_Scan.md |
| Revision | Operator scan 0.2 (2026-10-28) |
| Status | Read-only discovery approved; ORIGINALS source copy/creation NOT yet authorized |
| Runtime | Show PC PowerShell, current logged-in Windows LOR user |
| Master candidate | G:\Shared drives\Seasonal Files\LOR-Audio |
| Scanner | tools/scan_seasonal_original_audio_v0_2_0.ps1 |
| Pinned scanner commit | 42ada3d4a9c5f626c158c65b9bacd2dad198c9c6 |
| Design | Original_Audio_Catalog_Engineering.md |

## Intent and owner decisions

Scan **all** of G:\Shared drives\Seasonal Files to find original source recordings, ripped/purchased albums, annual archives, and processed show-use MP3s. **Originals are the original unmodified files. Normalized files are SHOW AUDIO copies, never raw originals.** Ripped/purchased album tracks keep their relative artist/album/track folder structure. Preserve entire archive intact. The candidate new master is a separate LOR-Audio root with Originals and Show-Audio subfolders, and must not be created or populated from scanner classification alone.

All audio classifications are tentative until source/processing provenance is verified. No automatic renaming or deduplication, and no FreeFileSync synchronization. The existing 24 Show PC local MP3 transfers are a different completed initial migration; this scanner does not touch them.

## Authority and mutation boundary

Authority: Gregovate/MSB-Music-Sequence-Catalog — System_Documentation/Project_Rules/Repository_Change_Workflow.md and this operator scan procedure.
Procedure: scanner V0.2.0 read-only seasonal inventory and review.
This step: list filenames/metadata under G:, write reports ONLY to Windows TEMP. Do not create LOR-Audio yet.

This tool has no copy, delete, hashing, normalization or synchronization mode. It does not rewrite sequence XML or LOR physical Display/Preview metadata.

## Step 1 — Fetch the pinned scanner to local TEMP

On the **Show PC PowerShell** with the G: Shared Drive mounted:

    $scanner = Join-Path $env:TEMP 'MSB_Seasonal_Audio_Catalog_Scan_V0.2.0.ps1'

    Invoke-WebRequest -UseBasicParsing -ErrorAction Stop -Uri 'https://raw.githubusercontent.com/Gregovate/MSB-Music-Sequence-Catalog/42ada3d4a9c5f626c158c65b9bacd2dad198c9c6/tools/scan_seasonal_original_audio_v0_2_0.ps1' -OutFile $scanner

    Test-Path -LiteralPath $scanner -PathType Leaf

Expected True; otherwise STOP. Review the script before running. This writes only the script to the current user's TEMP.

## Step 2 — Run the read-only scan

    powershell.exe -NoProfile -ExecutionPolicy Bypass -File $scanner

The scan may take time because the entire Seasonal Files hierarchy is enumerated. It reads filesystem metadata, not MP3 contents, and does not calculate hashes. Drive hydration/access errors cause a HOLD/error; preserve output and do not invent missing results. Do not disable Google Drive error detection or change its sync settings.

Expected ending line:

    SCAN PASS: SOURCE READ-ONLY; NO AUDIO COPIED; MASTER NOT CREATED.

An actual count will only be known after execution, not before. Report directory is under current user's local TEMP, with four/five deliverables:

- MSB_All_Seasonal_Audio_*.csv — full inventory; path, original filename, size, timestamp, conservative class.
- MSB_Original_Candidates_*.csv — review-only Originals destination proposals and path-collision counts.
- MSB_Album_Folders_*.csv — ripped/purchased album or other collection folder candidates (only if any found).
- MSB_Processed_Show_Candidates_*.csv — normalized or edited show-copy candidates excluded from Originals (only if any found).
- MSB_Scan_Summary_*.txt — version, scope, count, and report filenames.

The existing root G:\Shared drives\Seasonal Files\LOR-Audio, if it exists, is deliberately excluded from source occurrences.

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
