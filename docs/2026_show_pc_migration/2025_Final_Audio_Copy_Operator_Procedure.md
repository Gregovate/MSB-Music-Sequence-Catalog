# 2025 Final Audio — Selective Transfer to New Show PC

| Control | Value |
|---|---|
| Filename | docs/2026_show_pc_migration/2025_Final_Audio_Copy_Operator_Procedure.md |
| Revision | Operator procedure 0.1, 2026-10-28 |
| Status | Operator-approved one-time copy of only the 24 referenced MP3s; no ongoing sync |
| Owning repo | Gregovate/MSB-Music-Sequence-Catalog |
| Governing rule | System_Documentation/Project_Rules/Runbook_First_Production_Rule.md |
| Tool | tools/transfer_2025_final_audio_v0_1_0.ps1 |
| Tool identity | MSB Audio Selective Transfer V0.1.0 |
| Pinned script source | commit 549aef6f9c5e38db1374decfc34593fdabeb8b78 |

## Authority and scope

The operator explicitly approved this first one-time copy following the read-only 24/24 source and 0/24 destination-conflict preflight. The required names come from the existing local TEMP file MSB_2025_Final_Audio_20261027_152125.csv, generated from the Show PC's already-copied 2025 Final .loredit sources.

- Source: G:\Shared drives\Seasonal Files\2025\LOR\Audio
- Destination: C:\LOR\Audio
- Exactly 24 MP3 basenames, 84,827,578 total source bytes (80.90 MiB)
- Operation: COPY, not move, delete, mirror, normalize, convert or synchronize
- Overwrite policy: NEVER, including if a destination file appears during transfer
- Archive/history: leave G: fully unchanged
- Extra source files: exclude all 422 other MP3 occurrences in the 2025 archive
- Show PC: audio must operate locally/offline, no G: playback dependency

No FreeFileSync configuration, canonical G: folder creation, normalization, sequence edit, preview edit, Production Database operation or history cleanup is authorized.

## Preflight/current conditions

Use the existing Light-O-Rama Windows user session. C:\LOR\Audio must exist, along with G: source and exact source sequence-inventory CSV in the current user's $env:TEMP directory. The tool fails closed if the inventory is absent, has other than 24 distinct MP3 names, includes path traversal or invalid basename, if any source is missing/empty, if the 24 source byte sum is not exactly 84,827,578, or if ANY destination name exists. Run a fresh Preview immediately before Copy.

File size/metadata checks are read-only. Copy mode then reads actual MP3 contents and may cause Google Drive to hydrate streamed source files.

## Step 1 — Obtain the exact pinned script

Run in PowerShell on the Show PC. These commands create only a local TEMP copy of the checked-in tool and no LOR changes.

    $script = Join-Path $env:TEMP 'MSB_2025_Final_Audio_Transfer_V0.1.0.ps1'
    Invoke-WebRequest -UseBasicParsing -Uri 'https://raw.githubusercontent.com/Gregovate/MSB-Music-Sequence-Catalog/549aef6f9c5e38db1374decfc34593fdabeb8b78/tools/transfer_2025_final_audio_v0_1_0.ps1' -OutFile $script -ErrorAction Stop
    Test-Path -LiteralPath $script -PathType Leaf

The last command must return True; if it fails STOP. Check the downloaded script before execution. Do not substitute a new script or new branch HEAD without review.

## Step 2 — Preview again, no copies

    powershell.exe -NoProfile -ExecutionPolicy Bypass -File $script -Mode Preview

Expected: PREFLIGHT PASS with 24 sources, 84827578 bytes, zero destination conflicts; then PREVIEW ONLY: NO AUDIO FILES COPIED. Any error is HOLD; do not proceed.

The ExecutionPolicy flag is scoped to this child process, not a persistent machine change. If a higher-level policy blocks it, stop without altering machine settings.

## Step 3 — Execute the explicitly approved copy once

    powershell.exe -NoProfile -ExecutionPolicy Bypass -File $script -Mode Copy

Expected: 24 VERIFIED lines; a receipt file named MSB_2025_Audio_Transfer_V0.1.0_YYYYMMDD_HHMMSS.csv under local TEMP; and the final line PASS: 24 MP3s transferred without overwrite and verified by SHA-256.

Stop after one copy invocation, record its outcome and receipt; do not repeat.

## Mutation, failure and recovery behavior

For each file, the tool checks current source metadata and target absence again, streams to a uniquely named .msb-audio-transfer-*.part file IN the local target directory, verifies SHA-256 against source, and uses an atomic same-directory File.Move that does not overwrite an existing destination. It checks destination SHA-256 again, then logs a VERIFIED item. Its own temporary staging part is removed when necessary. It never writes to source or overwrites any final destination file.

If a copy fails partway, preceding verified destination files remain, unprocessed files remain absent, and the script returns HOLD with a receipt listing verified completed files. This is not an all-or-nothing batch and it deliberately does not delete finished verified files. Do not re-run Copy because the initial fail-closed preflight will encounter already-created destinations. Preserve the output and report, inspect the partial state, and document a governed recovery decision before any further copy.

A receipt verifies file identity but does not prove sequence compatibility or local LOR editor sound/playback. Follow a separately accepted LOR preview-conversion procedure from the MSB Production Database repository after the copy.

## Execution evidence — 2026-10-28

The operator executed tool V0.1.0 on the Show PC. The pasted PowerShell transcript contains:

- `PREFLIGHT PASS: 24 sources, 84827578 bytes, zero destination conflicts.`
- **24 distinct `VERIFIED:` records** with the exact expected audio basenames; each `VERIFIED` line is emitted by this version only after staged SHA-256 comparison, non-overwriting final move, and destination SHA-256 recheck.
- `VERIFICATION REPORT: C:\Users\LIGHT-~1\AppData\Local\Temp\MSB_2025_Audio_Transfer_V0.1.0_20261028_114621.csv`
- `VERIFIED FILES: 24/24`

**Interpretation:** initial 24-MP3 copy and per-file SHA-256 verification are demonstrated by operator output. The final script `PASS:` footer was **not included in the pasted transcript**, and the receipt CSV is on the operator's Show PC, not independently inspected. Do not claim final full operator closeout until terminal status or receipt is verified; do not rerun Copy to recover a missing line. No preview, sequence editing, Google Drive cleanup, FreeFileSync synchronization, or canonical-library migration is proved by this receipt.

**Operator finding:** the transferred MP3s exhibit inconsistent historical filename conventions. Leading years such as 2015, 2021, 2022 and 2025 encode historical introduction/editing practice rather than actual performance year or file identity. Keep exact legacy names for compatibility; the conceptual catalog model records introduction year, played years, recording/edit/rendition, processing metadata, audio occurrences and legacy references separately.

## Acceptance evidence

Only mark selective AUDIO TRANSFER PASS when the operator's exact tool shows 24 VERIFIED files and final PASS, source and target SHA-256 match for all 24, and the local TEMP receipt path is recorded. Record HOLD if any condition fails.

This action is ONLY the initial 2025-derived music subset, not the planned full song catalog, canonical audio library or future synchronization solution. Retain the operator's source and destination paths and fixed tool release identity when reporting.
