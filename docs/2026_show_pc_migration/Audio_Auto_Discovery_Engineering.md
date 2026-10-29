# MSB Audio Auto Discovery — Engineering Design

| Document | docs/2026_show_pc_migration/Audio_Auto_Discovery_Engineering.md |
|---|---|
| Revision | 0.1 — 2026-10-29 |
| Status | Read-only candidate tested locally; NOT yet accepted for complete Google Drive read |
| Source inventory | MSB Seasonal Audio Catalog Scanner V0.3.0 / 20261028_174014 |
| Candidate script | MSB_Audio_Auto_Discovery_V0_1_0.py — conversation-attached release candidate |
| Candidate source SHA-256 | 53adbcd35e3530837b40e18796c6e6b1fc78f6a77ee9c05a1b188690d300a822 |
| Repository publication | **Pending: exact candidate code not yet committed; review acceptance blocked until GitHub source is published** |

## Purpose and authorized scope

The operator requested automated original-versus-duplicate discovery rather than manual album review. This is permission for **read-only** source-byte comparison and embedded metadata extraction; it does not approve any file copy, creation of a canonical audio master, change to archived or show PC files, sound normalization, sync, sequence modification, or database import.

The completed V0.3.0 inventory covered 11,969 audio occurrences in 3,724 directories under G:\Shared drives\Seasonal Files. Exclude 8,311 Vegas/Studio Box effect sounds, 43 AcousticMirror impulse assets and 777 LORInternal\CanonicalAudio generated caches from the *first music-focused byte-reading pass*. Their records remain in the complete inventory.

**Focused scope: 2,838 occurrences** (2,479 MP3, 351 WAV, 8 WMA), totaling about **15.69 GiB** in historical recorded file sizes. **2,573** share extension+size with another occurrence. None of those numbers establishes duplicate byte identity or source-original status.

## Staged, resumable algorithm

**Plan:** Read the completed V0.3.0 MSB_All_Seasonal_Audio_20261028_174014.csv file from the user's LOCALAPPDATA; verify original count and required columns; write a fixed, sorted 2,838-file plan and a local source-CSV SHA-256 manifest. No source audio opened.

**Inspect:** One planned source at a time; confirm G: file exists and size matches; skip symlinks; stream full audio contents through SHA-256. For MP3, best-effort inspect embedded ID3v2.2/v2.3/v2.4 and ID3v1 text fields (title, artist, album, album artist, track, year). WAV/WMA receive full-file SHA but no supported semantic tag parsing in this candidate. Check size/mtime again after read, record missing/changed/unreadable sources as exceptions; save result as an atomic local per-file JSON checkpoint. Interrupted inspect can be resumed. Do not overwrite/readjust existing checkpoints without a separately governed recheck.

**Report:** Read local checkpoints and produce all-results CSV (including NOT_SCANNED), exact SHA256 duplicate groups, same-size/different-hash exception rows, tagged album candidate groups, tagged recording variants, exceptions and a summary with coverage. This does not read G: again.

The separate candidate script uses only Python 3.9+ standard library. Local checkpoint directory: %LOCALAPPDATA%\MSB\AudioAutoDiscoveryV0_1_0. This is different from the V0.3.0 scan session directory. Neither scan nor discovery creates or populates LOR-Audio.

## Interpretation and operator provenance

Identical full-file hashes prove **identical bytes**, not verified original acquisition/rights. Different hashes do not prove different audible songs; tag changes, transcodes, edits and normalization may all change bytes. Matching artist/title is not sufficient to merge recorded versions. No waveform loudness, fingerprint, signal-chain measurement, rights or time-alignment inference occurs.

Normalized files are Show-Audio, not raw Originals. Preserve original album and track membership; an individually useful title in a full album does not imply an additional standalone original copy. Historical Licensed Songs is operator's apparent purchased-music staging folder, not automatic evidence of license ownership. Purchased LOR sequences and commercial song rights are distinct. Bob Rivers material can be personal, while singing-face voiceovers/vocals, opening/closing cues, sound effects and unused recordings require separate categories. Confirmed season Final usage is independent of the library's mere availability.

The user-selected spreadsheet range A1:I1 of Original Candidates is **the header row**, not approval of any Original or music copy.

## Validation and acceptance gates

Local synthetic test PASS: ID3v2.3 tags extracted, two identical files hash equally, altered content hashes differently, report generation works. Against the actual uploaded inventory, local Plan PASS: 2,838 focused records and 2,573 with same-size counterparts, with zero G: reads. A live Show PC source pilot and complete hash pass have NOT been run.

Before final operator acceptance: get the exact candidate Python source into the owning repository at a pinned commit, test a maximum of 25 live files, review failures and Google Drive hydration/read cost, then resume. Any future canonical-original selection, hash-verified copy manifest, synchronizer or database implementation requires a separate authorization and runbook.
