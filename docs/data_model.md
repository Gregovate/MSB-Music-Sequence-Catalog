# MSB Music & Sequence Catalog — Data Model
Document revision: 0.8 — 2026-10-28
Status: RECONNAISSANCE / NOT APPROVED FOR IMPLEMENTATION
Owner: MSB-Music-Sequence-Catalog

## Authority and scope
This document records observed MariaDB structure and proposed design boundaries. The operator-provided phpMyAdmin SQL dump dated 2026-10-28 is the verified schema evidence. Engineering design must be approved before implementation PRs consume it.

## Observed runtime inventory (operator-provided)
Database: msb_sequence_catalog, Synology MariaDB via phpMyAdmin.
Tables: raw_show_sequences, shows, sequences, show_sequences.
Reported exact counts in earlier operator checks: 409 raw rows, 14 shows, 408 sequences, 408 show-sequence links. Later information_schema estimates: 406, 14, 408, 408 respectively. InnoDB table_rows are estimates; reconcile with exact COUNT(*) before asserting current totals.
All four tables currently report create_time 2026-10-28 01:07:14; this is not evidence of the original project creation date.

## Live DDL verified against phpMyAdmin SQL export — 2026-10-28
raw_show_sequences: show_file, block_index, block_kind, section, sequence_order, full_path, file_name, ext, year, owner, title, sequence_role. Staging fields were changed to text for reliable CSV import; verify live types.
shows: show_id PK, show_file, show_year, show_label, created_at; unique(show_file,show_year).
sequences: sequence_id PK, full_path, file_name, ext, owner, title, created_at; historical proposed unique index on full_path prefix, file_name, ext. Confirm live index semantics before relying on it.
show_sequences: show_sequence_id PK, show_id FK, sequence_id FK, block_index, block_kind, section, sequence_order, sequence_role, created_at; indexes on show_id, sequence_id, role, block_kind/section.
The SQL export verifies these tables and indexes. Refer to the verified definitions below; no migration is approved.

## Identity boundaries — design requirements, not yet implemented
- A song/composition is distinct from an artist's recording or arrangement.
- An audio asset may be purchased/original, cropped, normalized, or a sequence-specific edit; audio file paths alone are not durable recording identity.
- A sequence file/revision is distinct from the recording and from its usage in a particular show.
- Historical show usage is immutable evidence once a year is locked; current-year planning/imports are revisable.
- A sequence conversion assignment, test outcome, and production release are separate workflow facts.
- Sequence programmer/filename owner and original internal LOREDIT author can differ.
- Master Musical Preview must NOT enter the production stage/background/wiring identity model. Store only music-side references and source evidence.
- Timing grids may be multiple per LOREDIT; defer detailed modeling pending source inspection.
- YYYY Final folders are the production-sequence convention; YYYY scratch folders are working copies, not evidence of release on their own.
- 2011 historical data remains incomplete; the marketing matrix scope is 2013–2025.
- Some titles (Grinch, Carol of the Bells, White Christmas) have distinct artist recordings and must not be silently merged.
- Historical video show playlists and future themed shows require their own show/variant usage records.

## Open design decisions
1. MariaDB on Synology vs dedicated music schema in PostgreSQL production database: PENDING. Do not migrate or create cross-schema links yet.
2. Canonical song/recording/audio identity and source-file checksum rules: PENDING.
3. Source ingestion provenance, repeatability, and non-destructive reconciliation: PENDING.
4. User identity and permission integration: PENDING.
5. Exact physical schema: PENDING live read-only DDL evidence.

## Next verification
Collect SHOW CREATE TABLE for each of the four tables, exact counts, SHOW INDEX, and foreign key metadata read-only. Compare with this reconstructed baseline and record differences before approving any DDL.

## Verified SQL export — physical schema and counts
Source: operator-provided msb_sequence_catalog.sql, phpMyAdmin 5.2.2, MariaDB 10.11.11; generated 2026-10-28 20:03. Source dump retained by operator; do not commit raw historical production data without explicit approval.

- raw_show_sequences: 409 exported rows; 12 columns. show_file VARCHAR(255) NOT NULL; block_index VARCHAR(32); block_kind VARCHAR(64); section VARCHAR(64); sequence_order VARCHAR(32); full_path TEXT NOT NULL; file_name VARCHAR(255) NOT NULL; ext VARCHAR(16) NOT NULL; year VARCHAR(16); owner VARCHAR(128); title VARCHAR(255); sequence_role VARCHAR(64). No primary key or other indexes in export.
- sequences: 408 exported rows; sequence_id INT AUTO_INCREMENT PK; full_path TEXT NOT NULL; file_name VARCHAR(255) NOT NULL; ext VARCHAR(16) NOT NULL; owner VARCHAR(128); title VARCHAR(255); created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP. Unique key uq_sequences_fullpath(full_path(255), file_name, ext). Note prefix index is not a full-text-path uniqueness guarantee.
- shows: 14 exported rows; show_id INT AUTO_INCREMENT PK; show_file VARCHAR(255) NOT NULL; show_year SMALLINT NOT NULL; show_label VARCHAR(255); created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP; unique uq_shows_file_year(show_file, show_year).
- show_sequences: 408 exported rows; show_sequence_id INT AUTO_INCREMENT PK; show_id INT NOT NULL FK to shows(show_id) ON DELETE CASCADE; sequence_id INT NOT NULL FK to sequences(sequence_id) ON DELETE CASCADE; block_index INT; block_kind VARCHAR(64); section VARCHAR(64); sequence_order INT; sequence_role VARCHAR(64); created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP. Indexes on show_id, sequence_id, sequence_role, and (block_kind,section).
- All tables InnoDB, utf8mb4, utf8mb4_unicode_ci.
- Exported created_at values show rows inserted 2025-12-11 around 19:52–19:55, confirming data population in December 2025. Current table metadata reports 2026-10-28; no restore/recreation cause established.

## Verified data quality exceptions — do not repair without authorization
1. raw_show_sequences first exported row is the literal CSV header (show_file='show_file').
2. sequences sequence_id=408 is an imported header row (full_path='full_path', file_name='file_name', ext='ext').
3. Historical Windows full_path values in SQL export are missing backslash directory separators (e.g. C:lorSequences2020 Final...). This may result from CSV/import escaping. Do not treat these paths as resolvable or use them as canonical file identities.
4. The 408 show_sequences links reference actual show entries; header sequence 408 is not evidently linked in the exported relationship list. Validate before cleanup.
5. 2011 is represented by 82 musical main entries and is incomplete according to operator; it must not be treated as final canonical history.
6. Startup entries are labeled main_song even for shutdown loops and pre-show tests; marketing playlist queries must filter by section and curated intent, not sequence_role alone.
7. A filename '2002 - All I Want for Christmas Is You...' occurs in the 2022 show; filename year is not show year.
8. Song/recording identity is not stored; filenames alone cannot prove artist/version.

## Provenance and approval
This section records observed export evidence, not approved schema evolution. The existing four tables remain unchanged. The design-first rule requires review before any DDL, data cleanup or PostgreSQL migration.

## Filename metadata retirement and canonical naming — requirement 2026-10-29
The catalog must own metadata historically encoded in audio/sequence filename prefixes and suffixes: introduction year, show-use year, programmer, artist/recording, purchased source, revision and processing state. Canonical display titles must not embed those fields.

Keep distinct facts:
- composition's canonical title and alternate title spellings;
- recording's artist/arrangement and first MSB use year;
- sequence's original creation/introduction year, original author and revision lineage;
- each show season's actual usage, with its own year and show variant;
- audio asset's original/normalized/edited derivation and exact checksum;
- each physical file occurrence's observed path and original filename.

Do not infer introduction year from a filename or assume the first known historical show is the actual introduction date: incomplete 2011 data and pre-2013 history can make that uncertain. Store verified dates with evidence and distinguish earliest observed use from verified introduction.

No mass rename, file move, or duplicate deletion is part of the historical migration. Preserve original filenames and paths as source evidence and establish a proposed canonical naming policy only after inventory matching, LOREDIT/LMS media reference verification, and safe sequence relinking design. Byte-identical duplicates can be candidates for consolidation, but a normalized derivative or different recording is not a duplicate merely because the song title matches.

## Canonical song versus annual sequence versions — operator decision 2026-10-29
A song/composition has one durable canonical identity and is NOT versioned by year. Distinct artist recordings/arrangements are separate recording identities under that song. Sequences are annual production artifacts: every show year requires its own sequence revision/version because the Master Musical Preview, LOR generation and physical show configuration can change. One recording may have many annual sequence versions, and multiple alternate programmer revisions may exist within one year. Preserve lineage from prior year's sequence without overwriting it.

The show-to-sequence link is still necessary because it records actual .lss membership, show variant, order and section. A sequence revision is not the same thing as its show appearance. Existing MariaDB `sequences` rows are file references, not proven canonical song identities; migration preserves them first and later reconciles them to canonical songs/recordings and annual revisions.

Suggested future relationships (logical only): song 1:N recording; recording 1:N sequence revision; sequence revision N:M show via show entry (with per-show order/role). Do not add a year/version field to song itself. Show year belongs to show usage and annual sequence revision, not to canonical song identity. Song's earliest known use may be derived or recorded as provenance, not treated as a new song version.

## Original recording and MSB show audio derivative — operator decision 2026-10-29
The MSB show audio is a derivative of the original artist recording, not a new song or recording identity. Preserve original audio untouched. MSB may crop to shorten a long track (e.g., Christmas Canon), trim or adjust fade-outs to avoid long silence between songs, and optionally normalize playback volume. Normalization is a reversible policy choice and must not be a required field or mandatory processing gate. The operator's operational objective is no more than approximately one second of dead air between songs, not a claim that all source files contain that silence.

Logical model: canonical song -> artist recording -> original audio asset -> zero or more show-ready derived audio assets. Each derived asset retains source asset ID, checksum, duration, source and output paths, crop start/end when known, fade treatment, optional normalization/gain/loudness details and processing provenance. The exact edited audio asset referenced by each LOREDIT/LMS sequence revision must be captured; annual sequence versions can reuse a single show-ready audio derivative without duplicating it. A changed crop/fade/normalization creates a new derivative revision, not a new song, recording, or destructive overwrite.

Before file consolidation, confirm actual LOREDIT/LMS media references and file hashes; preserve original filenames as provenance. Do not automatically rename, move, delete or reprocess audio during the historical database migration.

## Approved show-audio timing version and processing variants — governing decision 2026-10-29
The timing/length of a prepared MSB show-audio edit is the controlling, durable identity for sequencing. Model a show_audio_timing_version under the original recording, with an explicit approved duration in milliseconds, crop start/end, fade/timeline treatment, timing status, and provenance. A new crop, trim or other timing change creates a new timing version.

One timing version may have multiple physical audio variants (e.g., normalized and non-normalized) with different bytes/checksums but the **same approved timeline and duration**. Normalization is optional and must not imply a new timing version. Each audio file variant retains its own path, checksum, processing metadata and measured duration. Validate actual duration and timing alignment before declaring variants interchangeable; equal duration alone does not prove sample alignment or matching edit boundaries.

Each LOR sequence revision references the approved timing version and the exact audio variant/file used for programming or testing. A normalization-only change that preserves timeline can be evaluated without mandatory resequencing; a timing change requires review and potential retiming/retest. Preserve the original master unchanged. This is a logical design requirement; no SQL or production changes authorized.

## LOR-facing duration format — operator requirement 2026-10-29
Audio duration must be displayed and accepted in the LOR-style `M:SS.mmm` format (example `3:15.500`). This is minutes, seconds, and three-digit milliseconds; the operator also describes LOR timing as centiseconds, so do not silently reduce the requested precision to two decimals. The canonical timing-version duration is stored as an integer millisecond count (e.g., 195500) and formatted as `3:15.500` for display and data entry. Validate seconds 00–59, fractional precision exactly three digits, and nonnegative durations. If LOR sequence metadata exposes centisecond quantization, record that source resolution separately and avoid claiming millisecond measurement precision beyond the source. Audio-file measured durations and timing equivalence must be validated independently.

## Year-free canonical audio filenames and alias-safe consolidation — 2026-10-30
Canonical audio filenames must not encode show year. Historical usage belongs to show and sequence relationships. Byte-identical year-prefixed files are duplicate occurrences, not new audio versions. Do not create a third copy merely to rename an existing rendition.

Maintain one canonical filename/path for each distinct approved rendition, with collision-safe naming for different recordings, crops, and normalization variants. Preserve original filename, path, SHA-256, source evidence and historical sequence references as aliases/occurrences. Different hashes require reconciliation rather than filename-based merging.

Before physical rename or cleanup, inspect LOREDIT/LMS media dependencies, prepare a reviewed alias mapping and copy/relink manifest, validate offline playback and preserve rollback. Keep the established C:\\LOR\\Audio runtime path. Historical archives remain intact until separately approved retirement. No physical changes are authorized by this design update.
