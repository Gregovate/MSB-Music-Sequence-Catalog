# Audio Auto-Discovery V0.1.0 — Show PC 25-file Pilot Review

| Control | Value |
|---|---|
| Revision | 0.1 — 2026-10-29 |
| Source | Operator-supplied V0.1.0 reports stamped `20261029_132559` |
| Inventory | V0.3.0 `MSB_All_Seasonal_Audio_20261028_174014.csv` (SHA256 `e20454084a3531e1e3ae5ce12b62bb9b1d3b8e5fe694c6f67ccaf43cc348e5b3`) |
| Program | `MSB_Audio_Auto_Discovery_V0_1_0.py`, candidate SHA256 `53adbcd35e3530837b40e18796c6e6b1fc78f6a77ee9c05a1b188690d300a822` |
| Scope | **Read-only 25-file pilot; entire 2,838-file read NOT performed** |
| Result | **PILOT PASS for read, full-file SHA-256, ID3 extraction, checkpoint and report** |
| Release status | **PENDING: source publication in owning repository and full-run release gate** |

## Pilot evidence

The operator ran `py -3 $tool --mode inspect --max-files 25`; console printed `CHECKPOINT: new=25 resumed=0 errors=0`. The separate `--mode report` produced seven reports, all supplied for review.

- `Planned=2838`, `CompletedCheckpoints=25`, `Remaining=2813`.
- All 25 were `HASH_OK`, contained 64-character SHA-256 values, and were recorded as ID3v2.3 MP3 source files under `LOR_Source_Files\Audio`.
- All 25 have `ActualSize` equal to the prior inventory `SizeBytes`; zero file-read, missing, changed-during-read, or hashing errors.
- **No exact-duplicate group confirmed** among 25 tested; their file sizes are individually distinct. This does **not** indicate the library contains no duplicates.
- The reported `TaggedAlbumCandidateGroups=18` means distinct **artist/album pair groups**, not proof of 18 independently bought/ripped album releases. Some tracks share one compilation album while displaying different performers.
- `SameArtistTitleDifferentBytesGroups=2`:
  - Jerry Wayne, `Jingle Bells`: files `01 Jingle Bells.mp3` (1,461,478 bytes) and `01 Jingle Bells_Base Boost.mp3` (1,466,479 bytes). Same artist/title metadata, different hash/size; a processed audio variant is a possibility, not proof of a distinct recording.
  - Trans-Siberian Orchestra, `Christmas Canon`: `07 Christmas Canon.mp3` (10,358,872 bytes) versus `08 Trans-Siberian Orchestra - Christmas Canon.mp3` (6,217,134 bytes). Same tags but different hashes and sizes; no inferred timing or edit without actual duration/audio evidence. This does not refer to the operator's separate 2026 Scratch sequence media-path correction.
- `TagOrReadExceptions=2817` is a **misleading aggregate**, not errors: **2,813 `NOT_SCANNED` rows** and **4 `HASH_OK` MP3s with no useful artist/title tags**. The four tagged-field gaps: `01 I'll Be Home for Christmas.mp3`, `02 The Beach Boys_Merry Christmas From 2.mp3`, `03 White Christmas.mp3`, `04 Deck the Halls.mp3`. None showed `TagNote` or `Error`.
- Pilot reports show `SourceFilesMutated=false` and `AudioCopiesMade=false`. This is scanner behavior as reported, not external filesystem comparison.

## Reporting interpretation correction

The V0.1.0 `MSB_Discovery_Exceptions` report combines (1) unscanned, (2) missing metadata, and (3) real read/size errors. In a **partial** run, `TagOrReadExceptions` must never be treated as a fault count. Read `Statuses`, filter `Status != NOT_SCANNED`, then distinguish `HASH_OK` with empty tags from actual error statuses. The program is safe to audit further, but the report label should be corrected in a **separately versioned** source release if its semantics change.

## Next acceptance action

The first pilot validated file reading, checkpointing and report creation on the operator's Show PC; no need to repeat these 25 files. **However, the owning operator procedure says full run remains gated on publishing the exact candidate source in the GitHub repository.** The conversation ZIP contains the current candidate, whose SHA256 was independently confirmed from the ZIP, but the Python source is not yet in the repository. Publish the exact source (without silently changing V0.1.0), verify repository byte/hash identity, revise governing SOP to accept the complete read-only pass, then resume existing checkpoint session using `py -3 $tool --mode inspect` and later `py -3 $tool --mode report`. All 25 file checkpoints must remain preserved.

No master creation, media movement, filename rewrite, MP3 re-encode, LOR edit, FreeFileSync configuration or database mutation is authorized by this pilot.
