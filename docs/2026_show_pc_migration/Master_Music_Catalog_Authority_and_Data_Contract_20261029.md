# MSB Master Music Catalog — Authority, Locations, and Database Contract

| Document | Decision |
|---|---|
| Authority record | MUSIC-CATALOG-AUTHORITY-2026-10-29 |
| Revision | 0.1 — 2026-10-29 |
| Owner | Gregovate/MSB-Music-Sequence-Catalog |
| Coordination | https://github.com/Gregovate/MSB-Music-Sequence-Catalog/issues/1 |
| Status | **SELECTED DESIGN TARGET / DATABASE INTERFACE; NO PHYSICAL DIRECTORY, DATABASE, OR FILE MUTATION AUTHORIZED** |
| Priority | 2026 show readiness takes priority over retrospective 15-year cleanup |

## Decision 1 — ONE catalog, TWO related music collections

The operator needs a clean catalog immediately for the 2026 show. The catalog shall have two user-facing collections, not two independent databases:

- **Original Music**: unchanged ripped/purchased recordings; album tracks and independent singles; tracks available for creating future MSB sequences, whether or not used in a prior year.
- **Show Audio**: normalized and/or cropped/edited renditions used for LOR sequence playback, each linked to an identified source recording or marked unresolved. Multiple show edits of one source are legitimate, especially if lengths differ.

Unknown role, unknown source rights, voiceovers, singing-face vocal stems, special opening/closing announcements, LOR-generated caches and effect libraries are **not** silently forced into either music collection. They remain discoverable as categorized assets or source-provenance exceptions.

An album track is searchable independently as a song, but need not be copied again into a physical Singles directory.

## Decision 2 — One nonannual physical audio master target

**Selected intended physical master root:**

    G:\Shared drives\Seasonal Files\LOR-Audio\
        Originals\
            Albums\          (retain artist/album/disc/track source structure)
            Singles\         (genuine standalone original recordings only)
        Show-Audio\           (approved show-ready edits/renditions)
        Catalog\              (optional controlled exports and copy receipts, not the database)

The annual directories in Seasonal Files remain historical read-only source evidence; they are not the maintained master. Historical wrapper folders such as Licensed Songs and Halloween are provenance, not automatically album artists or legal licensing evidence. Purchased LOR *sequences* and related supplied audio have distinct ownership/provenance records.

**This selected path is a design decision, not evidence that the folder exists.** No directory creation, bulk copy, rename, deletion, FreeFileSync job, normalization, or sequence rewrite is authorized without an approved operator runbook and hash-verified no-overwrite source/destination manifest.

**Local Show PC and programmer runtime remains C:\LOR\Audio.** The show must run offline; existing accepted LOR media filenames, 2025 Final history, 2026 Scratch working revisions and preview authority are unchanged. Do not recopy the initial 24 already hash-verified 2025 playback MP3s.

## Decision 3 — The master metadata catalog is a DATABASE, not a workbook

The single logical metadata authority is the **MSB Music & Sequence Catalog**, governed by this repository and Issue #1. Design for a **dedicated PostgreSQL database named msb_music_catalog** with two related audio collection views. Song/recording/album/artist/file identity and annual sequence use belong to that one music catalog. A spreadsheet is a staging/review/export artifact, NOT the authoritative metadata store.

**Deployment is NOT authorized.** The actual host, PostgreSQL instance/port, app roles/SSO, backup/restore, maintenance and cutover require an MSB Server Management-hosted design/runbook and explicit operator approval. Current Catalog Project Rules prohibit catalog schema/tables inside the MSB Production Database PostgreSQL environment.

The parallel branch docs/music-catalog-recon-20261028 currently proposes a music schema in the existing MSB production PostgreSQL database. **This conflicts with current repo authority and is HOLD for database placement**, pending an explicit jointly governed resolution. It must NOT implement that schema simply because a parallel draft exists. The old Synology MariaDB msb_sequence_catalog with four historical tables is migration source evidence, not the new master Original Music / Show Audio store.

This records the **logical database ownership and target name**, not an approved physical host or deployed instance. If an external host choice is required, the Server Management owner must approve it; do not invent a production endpoint.

## Database-facing domain model and required fields

Missing genre, length, album, rights, source-original evidence and source/show relationship are NULL / UNRESOLVED until verified. Never fabricate values merely to make an import pass.

| Record/view | Core fields/relationships | Notes |
|---|---|---|
| Song/work | song_id, canonical_title, alternate_titles, genre(s), theme(s) | Genre may be unknown; folder names are not proof of genre. |
| Artist | artist_id, display_name, sort_name and recording-artist roles | Performance and album artist are distinct; multiple performers allowed. |
| Recording | recording_id, song_id, artist(s), arrangement/edition, release membership | Distinguish performers and recordings with same song title. |
| Album/release | album_id, album_title, album_artist_id, release_year, edition, disc_number, track_number | Single track may be linked to album and independently searchable without a duplicate source file. |
| Audio edit | edit_id, recording_id, edit_kind (full/crop/shortened), duration_ms, crop_start_ms, crop_end_ms | A changed audio length is a sequence-critical version; each edit has its own duration. |
| Audio rendition | rendition_id, edit_id, collection_role (ORIGINAL, SHOW_AUDIO, UNRESOLVED), normalized_flag, normalized_method/target if evidenced, codec, bitrate, sample_rate, channels, duration_ms, SHA256, bytes | Normalized audio is never classified as raw Original merely by folder placement. Same edit may have normalized and non-normalized renditions of identical length. |
| File occurrence | occurrence_id, rendition/content_id, exact original source path, basename, source root, scan version, size/hash, album/purchase provenance, owner/rights evidence | Keep **all** historical source paths and aliases, even for identical hashes. |
| Show sequence/use | sequence_revision_id, year, Scratch/Final, programmer, exact LOR musicFilename, selected rendition/edit, verified use evidence | An available unused song is not automatically a played song. Never silently rewrite live LOR dependencies. |
| Non-song media | cue_id, cue_kind (open/close, voiceover, singing-face vocal stem, SFX), source/derived edit/rendition | Keep special recorded start/end and older Vocals for Superstar files without pretending they are music albums. |

### Duration precision (mandatory)

Store an integer **duration_ms**, with playback display **m:ss.fff** — example: **3:15.500**. Store full recording duration separately from the actual cropped show edit duration. Convert sequence-native centiseconds to milliseconds explicitly as 10 ms per centisecond; verify audio versus LOR timing independently, with no silent rounding of already used shows.

Existing V0.1.0 full-file SHA+ID3 inspection **did not measure playback durations**. ID3 tags do not reliably establish duration, normalization or exact crop points. Treat those fields as NULL until measured by a later bounded, read-only technical audio analysis. Genre is also missing/untrusted for some recordings and must not block creation of a minimal catalog.

## Data evidence we have today

- Complete Seasonal Files path survey: **11,969 occurrences** across 3,724 directories.
- Focused audio byte survey: **2,838 HASH_OK** occurrences, **817 distinct byte hashes**, 405 confirmed byte-identical duplicate groups and 2,021 additional duplicate occurrences.
- Tagged artist/album groups: 139; tagged same-artist/title distinct-byte groups: 81; missing artist or title ID3 tags: 599.
- A SHA256 establishes byte identity only. Same artist/title can have different recordings, crops, encodings and normalization. Do NOT collapse different hashes or assign one duration to all.
- Draft files named MSB_Original_Music_Catalog_DRAFT.csv, MSB_Show_Audio_Catalog_DRAFT.csv and MSB_Music_Catalog_Deferred.csv are **candidate planning exports**; they have not been accepted as canonical originals or physically copied. They do not yet have measured duration/genre and may contain same-destination conflicts.

## Provisional starter catalog handoff — 2026-10-29

The review/staging workbook `MSB_Master_Music_Catalog_Database_Handoff_20261029.xlsx` was generated from the completed 817-hash evidence and candidate classification, not manually curated titles. It contains:

| Draft view | File-byte identities | Meaning |
|---|---:|---|
| Original Music candidate | **293** | Possible source originals; raw/unaltered status **not proved** and no files approved for copying |
| Show Audio candidate | **222** | Possible normalized/cropped renditions; some filename/destination conflicts remain |
| Deferred Review | **302** | Unknown source role or special cue/stem/production assets; preserved and not discarded |
| **Total** | **817** | One provisional row for each distinct focused SHA-256 content identity, not 817 songs |

The workbook includes Start Here, Field Contract, Original Music, Show Audio and Deferred Review tabs. Genre, Duration_ms and Duration_LOR are **blank** until verified; a database ingest must not fabricate values or assume candidate collection roles are approved. The workbook is an exported staging artifact from the conversation, not the authoritative database and not currently hosted on GitHub. The database workstream should consume **this contract** first and request/import the staging workbook only through a reviewed catalog-ingestion process.

## Minimum near-term delivery for the database workstream

1. Implement the **shared domain contract** above as one model with Original Music and Show Audio collections; preserve source identities and historical show use. Stage candidate imports with review status, not falsely approved original/audio source paths.
2. Prioritize 2026 Show Audio selections and existing 2025 Final/2026 Scratch exact filename compatibility. The show does not wait for 81 ambiguous historical tagged title groups to be resolved.
3. Add nullable genre and duration_ms columns immediately in the design. Populate existing tags where supported; later bounded inspection fills in technical duration and processing evidence.
4. Keep raw historic MariaDB tables as a distinct preservation migration. The production music-schema proposal remains HOLD for hosting/ownership reconciliation against this decision record.
5. Host/instance selection and physical copies are separate governed operations requiring acceptance. No 2026 show-side mutation by database design alone.

**Coordination directive:** The database thread must read this file via the existing branch and the commanding Issue #1 before implementing its schema. Changes require a reviewed decision update; no parallel competing catalog authority.
