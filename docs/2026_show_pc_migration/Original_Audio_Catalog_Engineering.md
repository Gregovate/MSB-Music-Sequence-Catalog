# Original Audio Master — Library Architecture and Classification

| Control | Value |
|---|---|
| Filename | `docs/2026_show_pc_migration/Original_Audio_Catalog_Engineering.md` |
| Revision | Design proposal 0.1 — 2026-10-28 |
| Status | Initial scan approved by operator request; physical master population awaits reviewed manifest |
| Owner | MSB Music & Sequence Catalog |
| Current tool | [Seasonal Audio Catalog Scan V0.1.0](../../tools/scan_seasonal_original_audio_v0_1_0.ps1) |

## Direction confirmed by operator

**Originals first.** Scan the **entire** `G:\Shared drives\Seasonal Files` tree for audio files and organize source/master recordings into a non-annual permanent audio library. Ripped albums may keep their existing artist, album, and disc directories **under the same master audio root**. Do not flatten albums into one song-name directory. Purchased/ripped source files should remain unchanged as evidence. Show-use files (expected Audacity-normalized) are a separate later library population phase.

The Google Drive master structure below is **proposed and not yet physically created**:

```text
G:\Shared drives\Seasonal Files\LOR-Audio\
    Originals\
        Albums\             # existing album subfolder structure preserved
        Singles\            # single tracks only after source validation
    Show-Audio\             # approved normalized/edited show audio, later phase
    Catalog\                # future approved reports/index, NOT scan output now
```

The master directory is a catalog/distribution source, **not** the operating LOR audio path. Live show and programmer PCs retain `C:\LOR\Audio` for approved playback assets, offline. No original album collection is required on all programmer PCs.

## Source scope and actual known evidence

The prior user-supplied metadata file `MSB_Audio_Metadata_20261027_142222.csv` recorded **2,073 MP3 occurrences from ten configured roots**, including:

- `LOR_Source_Files\Audio` — **622** occurrences, containing both loose files and folders such as `Frozen (Deluxe Edition)`, `Michael Bublé` and source-style collections such as `StockSongs`, `Licensed Songs`, and `Vocals for Superstar`;
- `LOR_Source_Files\PurchasedMusic` — **13** occurrences under `Lindsey Stirling\Warmer In The Winter`;
- `LOR_Source_Files\Normalized Audio Albums` — **36** processed-name occurrences to reserve for the later show-audio review;
- `LOR_Source_Files\Purchased LOR RGB Plus` — **90** occurrences, supplied audio for purchased sequences, which is **not automatically an unprocessed original**;
- annual 2014, 2020, 2023, 2024 and 2025 LOR Audio folders (with duplication candidates);
- one local Show PC audio sample, not part of this G: seasonal scan.

An additional **177 MP3s** in `2021\LOR S5 2021\Audio` were discovered but not file-level indexed in that CSV. Other audio extensions and other Seasonal Files folders were not comprehensively scanned in the earlier report. **Therefore this new recursive scanner replaces the narrow-root survey as coverage evidence once actually run.** Do not claim complete audio counts before that output is reviewed.

## Audio identity design (no database selected)

- **Song/composition** — title and work; no introduced-year identity.
- **Recording** — performer/master/arrangement; independent of file location.
- **Audio edit** — full recording versus shortened/cropped variant, preserving musical timing.
- **Audio rendition** — purchased/ripped source, Audacity normalized processed output, supplier-delivered audio; do not infer normalizing from absence/presence of filename marker.
- **Audio file occurrence** — source path, original basename, size, timestamp, later SHA-256, album-folder provenance.
- **Album** — release title, artist/album path, track order, optional disc, album provenance; multiple recordings/tracks map to an album. Existing folder hierarchy is not authoritative metadata by itself.
- **Use/history** — first MSB introduction (evidence) and annual Final show-use, independent of filename year prefixes.
- **Sequence reference** — exact audio basename stored in each `.loredit`, kept unchanged until a separately accepted alias/remapping migration.

**Do not rename or change file content** to fit the planned canonical organization. For original albums, preserve actual existing names including track numbers, punctuation and album directories. Artist/album metadata is subject to later source/tag/manual review. Where a source has only an album folder without artist information (e.g. `Frozen (Deluxe Edition)`), do not invent an artist to construct a folder path.

## V0.1.0 scanner scope and safeguards

The scanner is **read-only on G:**, processes `.mp3`, `.wav`, `.flac`, `.m4a`, `.aac`, `.wma`, `.aif`, `.aiff`, `.ogg`, `.opus`, and creates report files only under the Windows user's TEMP root by default. It excludes entries in `LOR-Audio` so an existing or future master is not mistaken for another source of originals.

Outputs:

1. `MSB_All_Seasonal_Audio_*.csv` — complete discovered source occurrences and conservative classifications;
2. `MSB_Original_Candidates_*.csv` — proposed `Originals\Albums` and `Originals\Singles` destination paths, every line requiring review, plus destination-collision counts;
3. `MSB_Album_Folders_*.csv` — discovered source album/collection folders and item counts; the word *collection* avoids wrongly declaring stock/show folders to be albums;
4. `MSB_Scan_Summary_*.txt` — operator receipt and exact report paths.

Classification is a **triage suggestion**, not verification of originality or normalization. `LOR_Source_Files\PurchasedMusic` produces original candidates with its purchased artist/album hierarchy retained; nested `LOR_Source_Files\Audio` folders produce possible-album review candidates; annual archive, supplied RGB Plus audio and processed-looking audio remain separate review groups. All proposals have `REVIEW_REQUIRED`, no SHA-256, and no license or original-content certification.

## Folder/duplicate policy for eventual population

1. Build the comprehensive physical inventory; inspect file provenance and uncertain folders.
2. Identify original album sets and individual source recordings. Preserve the original release folders and track names; assign album/recording identities in catalog metadata.
3. Compare exact duplicate candidates (read-only SHA-256 where approved); **do not** collapse different remasters, edits, channels, tracks or audio encodings because name/size happens to match.
4. Approve **one selected source occurrence per exact canonical original**, with a proposed destination under `Originals\Albums` or `Originals\Singles`. Preserve alternate album editions and actual edit variants.
5. Produce a **separate immutable, explicit no-overwrite copy manifest** with source, destination, expected byte length and SHA-256, target collision review, preflight and verification/receipt. Do not create destination folders or run copy/sync during V0.1.0 scanning.
6. Copy selected sources only under a separate accepted operator procedure; compare post-copy SHA-256. Never move or delete the original archive. Only after originals are accepted begin `Show-Audio` with normalized/edited sources and controlled sequence reference migration.
7. Design FreeFileSync independently, using explicit authority/conflict/overwrite/delete policies; do not mirror the historical archives into the master.

## Open acceptance items

- Exact master path `G:\Shared drives\Seasonal Files\LOR-Audio` was previously proposed; treat it as **intended candidate** until operator accepts the inventory and destination manifest. No folder has yet been created by this workstream.
- Which folders represent real ripped/purchased albums versus themed collections (StockSongs, Halloween, etc.)?
- Are any album sources lossy transcoded or processed copies rather than actual original rips?
- How to handle cross-source duplicate album tracks, same filename collisions and multi-disc packages?
- Future managed metadata storage/application and SSO remain undecided and isolated from MSB Production Database.
