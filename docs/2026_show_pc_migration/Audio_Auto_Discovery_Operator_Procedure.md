# MSB Audio Auto Discovery — Operator Pilot (Read-Only)

| Control | Value |
|---|---|
| Revision | Candidate SOP 0.2 — 2026-10-29, pilot accepted for investigative continuation |
| Status | **25-file Show PC pilot PASS; read-only full investigation permitted against identical SHA-locked candidate. Production-grade source publication still pending.** |
| Owner | MSB Music & Sequence Catalog |
| Source inventory | 20261028_174014 V0.3.0 completed Seasonal Files scan |
| Candidate source | MSB_Audio_Auto_Discovery_V0_1_0.py, supplied in this project conversation |
| Expected script SHA-256 | 53adbcd35e3530837b40e18796c6e6b1fc78f6a77ee9c05a1b188690d300a822 |
| Engineering | Audio_Auto_Discovery_Engineering.md |

## Authority, environment, and boundaries

Authority: MSB-Music-Sequence-Catalog, Repository Change Workflow and this operator procedure.
Procedure: checkpointed read-only hash/tag investigation against the completed pinned inventory; no source or Production mutation.
This step: continue the validated 25-file read-only pilot over the remaining fixed 2,813 records; write results to LOCALAPPDATA. Do **not** rename/copy/delete/normalize any G: file, create LOR-Audio, edit C:\LOR, configure FreeFileSync, or write database tables.

**This candidate implementation is delivered as a conversation attachment but not yet committed to the repository.** Its verified SHA above must match the downloaded bytes. **Pilot acceptance exception:** The operator authorized read-only automated discovery and supplied the 25-file reports; the results have now been reviewed in [Pilot Review 20261029](Audio_Auto_Discovery_Pilot_Review_20261029.md). Further **investigative** hashing on the existing exact-SHA candidate may continue without restarting or changing the script; repository source publication still gates designation as a supported production tool and any downstream physical master-copy workflow. Never silently swap candidate code in the existing session.

The data source is the Show PC local reports folder:

    C:\Users\Light-O-Rama\AppData\Local\MSB\SeasonalAudioCatalogScanV0_3_0\Reports\MSB_All_Seasonal_Audio_20261028_174014.csv

If this file is absent, HOLD; do not substitute a different/partial report or rescan G:. The planning tool verifies the 11,969-row source and expects exactly 2,838 focused occurrences.

## 1. Download candidate script

Use the ChatGPT conversation attachment named MSB_Audio_Auto_Discovery_V0_1_0.py and save it to a known folder, for example Downloads. In Show PC PowerShell:

    $tool = Join-Path $env:USERPROFILE 'Downloads\MSB_Audio_Auto_Discovery_V0_1_0.py'
    Test-Path -LiteralPath $tool -PathType Leaf
    (Get-FileHash -LiteralPath $tool -Algorithm SHA256).Hash.ToLowerInvariant()
    py -3 --version

Expected: True; exact file SHA-256 as recorded in document; Python 3.9 or newer. If Python launcher is not available, HOLD rather than installing random packages or guessing a different runtime. This script uses Python's standard library only.

## 2. Local-only plan — no G: audio bytes read

    py -3 $tool --mode plan

Expected:

    PLAN PASS: 2838 focused files; 2573 share a file size
    FILES OUTSIDE PLAN: 9131
    NO SOURCE AUDIO READ IN PLAN MODE

Plan and session will be written under:

    C:\Users\Light-O-Rama\AppData\Local\MSB\AudioAutoDiscoveryV0_1_0

An already-existing matching Plan is reused. A different source inventory or source root causes HOLD. Do not edit the plan CSV by hand.

## 3. Limited, resumable source-reading pilot (25 files)

    py -3 $tool --mode inspect --max-files 25

Expect CHECKPOINT progress and an INSPECT CHECKPOINT closeout. This reads **up to 25 previously listed media files** on G:; may cause Google Drive to fetch cloud content. File contents are only read and SHA256-hashed, MP3 ID3 text metadata parsed, and a separate local JSON checkpoint saved for each completed file. No media files are edited.

On Ctrl+C, each completed file checkpoint persists; rerunning the identical command continues from the next unchecked file. Missing/unavailable/changed files are marked as exceptions, not treated as successful reads. Checkpointed exceptions are not automatically retried in this initial candidate.

## 4. Local-only report

    py -3 $tool --mode report

Under the LOCALAPPDATA AudioAutoDiscoveryV0_1_0\Reports folder the program writes:

- MSB_Discovery_Results_*.csv — all 2,838 focused records, hashed or NOT_SCANNED.
- MSB_Exact_Duplicates_*.csv — successful exact full-file SHA256 duplicates, when discovered.
- MSB_Same_Size_Different_Hash_*.csv — matching size does not mean matching content.
- MSB_Tagged_Album_Candidates_*.csv — tentative ID3 artist/album groups.
- MSB_Tagged_Recording_Variants_*.csv — artist/title matches across different bytes; edits/encodings not proven.
- MSB_Discovery_Exceptions_*.csv — pending, missing, changed, unreadable, incomplete or untagged items.
- MSB_Discovery_Summary_*.txt — per-status counts, completed/pending, source inventory identity, data limits and paths.

A 25-file pilot must report most planned files as NOT_SCANNED; this is expected. No hashes are available for uninspected rows. Same-size or tag matches never authorize deletion or selection of an original.

## 5. Full pass (only after pilot acceptance)

    py -3 $tool --mode inspect

The complete focused archive represents approximately **15.69 GiB** of file content to be read from Google Drive, and may be slow/hydrate cloud files. Inspect can be interrupted and resumed with the same command, with results preserved. Once complete, rerun --mode report and return summary and all reports as a ZIP.

**Gate passed for investigative scan:** 25 of 25 HASH_OK, zero source-read/hash errors, 4 scanned MP3s with missing artist/title metadata, and 2,813 NOT_SCANNED rows. `TagOrReadExceptions=2817` is a combined report count (**2,813 not yet read + 4 tag gaps, not 2,817 errors**). Confirm script SHA again before the full read. Keep the existing checkpoint session and execute exactly `py -3 $tool --mode inspect`; no `--mode plan`, no reset or retry on a changed source. Return `--mode report` results after completion. Full hash results remain investigation evidence, not approval to copy, delete or claim source original identity. Source publication and formal release closeout remain pending.
