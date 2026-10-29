# Original Audio Catalog — Completed Seasonal Files Scan Findings

| Document control | Value |
|---|---|
| Filename | `docs/2026_show_pc_migration/Original_Audio_Scan_Findings_20261029.md` |
| Revision | Evidence review 0.1 — 2026-10-29 |
| Operator scan | MSB Seasonal Audio Catalog Scanner V0.3.0 |
| Completed report stamp | `20261028_174014` |
| Source root | `G:\Shared drives\Seasonal Files` |
| Source archive received | `MSB_Audio_Catalog_20261028_174014.zip` |
| Status | **METADATA RECONCILIATION ONLY — no files hashed or copied to proposed master** |
| Owning docs | [Original Audio Catalog Engineering](Original_Audio_Catalog_Engineering.md) and [Operator Scan](Original_Audio_Catalog_Operator_Scan.md) |

## Verified coverage and content counts

The operator's completed report was uploaded and the five extracted files were inspected. V0.3.0 reported **3,724 completed directories**, **0 pending**, **0 skipped reparse directories**, **127,275 directory entries visited** and **11,969 audio-format file occurrences** (not distinct recordings or songs). It did not hash audio contents or modify the source archive. Coverage means the requested `Seasonal Files` tree only; audio outside it remains unknown.

| Category | Occurrences | Action |
|---|---:|---|
| Total file occurrences | **11,969** | Complete inventory baseline |
| `.wav` | 9,270 | Includes sound-effects libraries and LOR cache |
| `.mp3` | 2,479 | Includes annual duplicates and other source copies |
| `.wma` | 220 | Includes LOR cache and older audio |
| `Vegas` source library | **8,311** | Mostly Studio Box WAV sound effects; preserve as separate collection, do not declare original music albums |
| `AcousticMirror` impulses | **43** | Effect/impulse assets; separate from song recording Originals |
| `LORInternal\CanonicalAudio` | **777** | LOR-generated WAV/WMA cache, not first-priority original album candidates |
| Remaining focused audio occurrences | **2,838** | Includes 2,479 MP3, 351 WAV and 8 WMA; still contains duplicates, voiceovers and other files |
| Scanner-proposed original candidates | **588** | **471** nested-folder candidates and **117** loose candidates, every row REVIEW_REQUIRED |
| Album-or-collection folder groups | **38** | These are source directories, not 38 approved albums |
| Scanner normalized/edited candidates | **1,043** | Includes **338** generated-cache entries; **705** remain in focused audio after exclusions |
| Audio supplied with purchased LOR sequences | **90** | Preserve vendor package context; original/processed type unresolved |
| Focused repeated filename-and-size groups | **423** | **2,482 occurrences** across those groups; no SHA-256 verification |
| Proposed destination collision groups | **22** | **44 file occurrences** across two identical proposed targets per group; each pair has equal recorded file size, NOT proof of identical bytes |

**Original candidate total does not mean 588 confirmed unprocessed sources.** Raw album-source provenance, version/edit identity, all duplicate contents, and correct canonical folder choices remain review work.

## Highest-value original album cases

1. **Lindsey Stirling — Warmer In The Winter:** the album source is represented under both `LOR_Source_Files\PurchasedMusic\Lindsey Stirling\Warmer In The Winter` and `LOR_Source_Files\Audio\Lindsey Stirling\Warmer In The Winter`. Thirteen tracks occur at each path; the 13 corresponding proposed destination pairs have equal filenames and sizes. A third `Licensed Songs` wrapper holds another 13 album tracks. Preserve the artist/album tree and verify bytes; do not copy all 26 or 39 automatically.
2. **Lee Greenwood — The Best of…:** nine tracks are present in each `PurchasedMusic` and source `Audio` album directory. Their nine proposed-destination pairs have equal names and byte sizes. Preserve album source and verify hashes.
3. **Ghostbusters soundtrack:** ten album tracks appear in multiple paths, including the base soundtrack directory, `Halloween` and `Licensed Songs` wrappers, and a `Various Artists` soundtrack directory. The identical filename-and-size evidence makes them duplicate *candidates*, not proven identical recordings; do not preserve `Halloween` or `Licensed Songs` automatically as artist metadata.
4. **Frozen (Deluxe Edition):** 59 source audio occurrences in the existing album directory. Keep track names, disc markers and original album folder. No batch normalization during original copying.
5. **Michael Bublé — Christmas**, **Mariah Carey — Merry Christmas**, **The Polar Express**, and other existing albums: some appear in both direct album directories and `Licensed Songs` collection wrappers. Review grouping and original-source evidence instead of treating each folder as a separate recording.
6. **Not album recordings:** `StockSongs` (31 scanner original *candidates*), `Vocals for Superstar` (processed and raw/cue files mixed), `2020 Voiceovers`, `Band Songs` and `Samples` should be classified by their actual source/workflow role. Their source folders must be preserved, but should **not** automatically become `Originals\Albums`.

The purchased LOR sequence bundle audio (90 occurrences) is held for vendor provenance review. The complete source paths in the inventory allow each candidate to be linked to the purchased sequence source/package. No album track or bundle can be asserted to be unprocessed solely from its filename or location.

## Confirmed boundaries and proposed physical layout

The operator's rule remains **Originals = unmodified source recordings; Audacity-normalized show copies belong exclusively in Show-Audio**. Unlabeled files require evidence; a folder named Audio, PurchasedMusic, StockSongs, Licensed Songs, or annual LOR/Audio is not by itself proof of original status.

The proposed destination root has **not** been created or approved to populate:

```text
G:\Shared drives\Seasonal Files\LOR-Audio\
    Originals\
        Albums\             # retain genuine artist/album/disc/track source structure
        Singles\            # reviewed original singles only
    Show-Audio\             # normalized / approved edited show playback copies later
```

Vegas sound-effects and AcousticMirror impulse collections are significant distinct **source libraries**. Preserve their original directories and catalog them as sound/production assets separately; whether to copy them into the new master at all is a future operator decision. `LORInternal\CanonicalAudio` generated files are source history/cache, not canonical source recordings. The running show's local `C:\LOR\Audio` remains separate and unchanged.

## Review workbook delivered

`MSB_Original_Audio_Master_Review_20261029.xlsx` is a generated **external review artifact**, not committed into GitHub and not a physically populated G: master. It has eleven tabs: Overview, Source Groups, Classifications, Album Folder Review, Original Candidates, Destination Collisions, LOR Bundled Audio, Show Audio Review, Focused Audio Inventory, Name Size Repeat Groups, Sources and Rules. It carries exact scanned paths and conservative proposed destinations; no row authorizes copying.

The original uploaded ZIP retains **all 11,969 file paths**. The workbook's focused sheet uses **2,838** records after separating the two source effect libraries and `LORInternal\CanonicalAudio`. Nothing was removed from the source ZIP.

## Required next acceptance gates

1. **Album/source triage:** inspect the 38 source collection/album groups and pick genuine artist/album originals, flag stock/voiceover folders as non-albums, and retain any vendor sequence-bundle provenance.
2. **Destination cleanup without source mutation:** propose one canonical original location for each approved album or single. Do not include `Licensed Songs` or `Halloween` as artist/album prefixes without an explicit operator choice.
3. **Selective read-only byte comparison:** hash only the 22 target-collision pairs, selected repeated album groups and suspected original/processed variants where needed; compare exact sizes and hashes. Google Drive may hydrate cloud files during hashing; plan scope deliberately.
4. **Reviewed copy manifest:** for each approved original occurrence, require exact source, approved destination, bytes, SHA-256, no-overwrite policy, exact filename, album identity, duplicate disposition and dry-run evidence.
5. **Physical master:** only after explicit acceptance create directories and copy selected original tracks under a separate documented, fail-closed operator procedure. Never move/delete historical files or turn on FreeFileSync as part of classification.
6. **Show-Audio later:** use normalized and genuine alternate edits, not raw albums, for LOR show playback. Decide catalogue/database hosting and controlled `.loredit` reference migration independently; the MSB Production Database Preview/Display/Comment/network authority remains unchanged.

No executable scanner changes, no PostgreSQL writes, no source archive cleanup, and no Show PC runtime file changes occurred while preparing this evidence review.
