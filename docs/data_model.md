# MSB Music & Sequence Catalog — Data Model
Document revision: 0.1 — 2026-10-28
Status: RECONNAISSANCE / NOT APPROVED FOR IMPLEMENTATION
Owner: MSB-Music-Sequence-Catalog

## Authority and scope
This document records observed MariaDB structure and proposed design boundaries. It is not a substitute for a live SHOW CREATE TABLE inspection. Engineering design must be approved before implementation PRs consume it.

## Observed runtime inventory (operator-provided)
Database: msb_sequence_catalog, Synology MariaDB via phpMyAdmin.
Tables: raw_show_sequences, shows, sequences, show_sequences.
Reported exact counts in earlier operator checks: 409 raw rows, 14 shows, 408 sequences, 408 show-sequence links. Later information_schema estimates: 406, 14, 408, 408 respectively. InnoDB table_rows are estimates; reconcile with exact COUNT(*) before asserting current totals.
All four tables currently report create_time 2026-10-28 01:07:14; this is not evidence of the original project creation date.

## Historical DDL reconstructed from prior operator conversation — UNVERIFIED
raw_show_sequences: show_file, block_index, block_kind, section, sequence_order, full_path, file_name, ext, year, owner, title, sequence_role. Staging fields were changed to text for reliable CSV import; verify live types.
shows: show_id PK, show_file, show_year, show_label, created_at; unique(show_file,show_year).
sequences: sequence_id PK, full_path, file_name, ext, owner, title, created_at; historical proposed unique index on full_path prefix, file_name, ext. Confirm live index semantics before relying on it.
show_sequences: show_sequence_id PK, show_id FK, sequence_id FK, block_index, block_kind, section, sequence_order, sequence_role, created_at; indexes on show_id, sequence_id, role, block_kind/section.
These are reconstructed descriptions, NOT verified current column types, keys, or constraints.

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
