# PostgreSQL Migration Engineering Design — Synology MariaDB to MSB Production
Revision: 0.1 — 2026-10-28
Status: PROPOSED DESIGN / REVIEW REQUIRED / NOT AUTHORIZED FOR DEPLOYMENT
Owner: MSB-Music-Sequence-Catalog
Cross-repository authority required: MSB-Server-Management and MSB-Production-Database-Project.

## 1. Objective and scope
Migrate the four historical tables from Synology MariaDB database msb_sequence_catalog into a dedicated music schema in existing PostgreSQL 16 production database on msb-prod-db. Retain music subsystem ownership in this repository. Do not alter existing ref/ops/stage/wiring data, reuse production preview tables, or install any application during the migration.

## 2. Verified source baseline
Source: phpMyAdmin SQL export dated 2026-10-28, MariaDB 10.11.11.
raw_show_sequences 409 rows; shows 14; sequences 408; show_sequences 408. InnoDB/utf8mb4_unicode_ci. Actual column definitions, keys and exceptions are recorded in docs/data_model.md revision 0.2.
Known defects: imported header row in raw_show_sequences and sequences(id=408); damaged path separators; sequence filename '2002' in 2022 show; musical startup entries misclassified as main_song. These are preserved as-is in the raw migration and reported for later correction.

## 3. Proposed target boundaries
Database: existing MSB production PostgreSQL 16; schema: music (pending architectural approval).
Tables: music.raw_show_sequences, music.shows, music.sequences, music.show_sequences. No additional domain tables in the first migration.
Use original integer primary keys and relationship IDs; preserve created_at timestamps, including original time interpretation, and text values without destructive normalization. Convert MariaDB AUTO_INCREMENT to PostgreSQL identity/sequence after loading, with next values checked. Preserve foreign keys and equivalent indexes. MariaDB's unique index on full_path(255),file_name,ext is not semantically equivalent to PostgreSQL full-path uniqueness; design a deliberate target key after collision analysis. Do not silently enforce a stronger constraint that could reject valid data.
Use schema-qualified names throughout; no reliance on public search_path.
Separate least-privilege owner, migrator, reader and application roles; no permissions on existing schemas beyond explicitly approved interfaces. PostgreSQL role names and grants are design pending.
Retain MariaDB unchanged as rollback source until acceptance and formal retirement approval.

## 4. Migration phases
A. Design gate: approve database placement, source/target ownership, permission matrix, backup/runbook authority, outage expectations and data identity.
B. Source capture: read-only counts, schema fingerprint, export hash, row-level stable hashes, index/FK inventory, source timestamp/timezone interpretation. Secure the source dump; never commit real show data to repository by default.
C. Disposable PostgreSQL validation: create isolated clone or scratch database using established Server Management disposable procedures; build proposed music schema, load data, verify exact counts and row fingerprints; test FK behavior, indexes, role denial and idempotent reload.
D. Controlled production deployment (separately authorized): production runbook, snapshot, maintenance/fencing if required by owning authority, schema migration, bulk load, sequence reseeding, validation, unfence and health checks.
E. Acceptance: exact source/target reconciliation, no cross-schema changes, production services healthy, documented operator approval.
F. Retirement (separate decision): keep MariaDB read-only or intact until an explicit retirement plan and restore test are approved.

## 5. Acceptance criteria
- Four target tables and all columns accounted for, with documented type mappings.
- Exact counts 409/14/408/408 at source snapshot or documented differences if source changes.
- Row-level content and ID mapping reconcile, including known bad header/path data.
- No orphan show_sequences rows; FK references preserve exact IDs.
- PostgreSQL identity/sequence generators advance past highest migrated ID.
- Least-privilege role tests PASS; application role cannot write to other MSB schemas.
- No modifications to production display, stage, background or preview identities.
- Repeatable disposable import, rollback/cleanup, and backup/restore tests PASS.
- Engineering docs and operator runbook approved before any production change.

## 6. Risks and open decisions
1. PostgreSQL music schema shares database failure/backup domain; schema separation is not isolation.
2. Prefix-unique MariaDB path key cannot be copied naively; paths are already malformed.
3. MariaDB timestamps may have timezone/session conversion implications; verify before importing.
4. Header rows are known defects but migration must not erase evidence.
5. Existing production authentication is not automatically available to a new app; permissions and application identity need explicit design.
6. Source SQL dump includes production-like records; protect and hash it, do not commit it.
7. Existing PostgreSQL maintenance, backup, schema ownership and deployment conventions must be read from their owning repositories before implementing.
8. Music-specific domain expansion (song, recording, audio asset, programmer, conversion, testing, release, themed/video shows) is a separate engineering design and later migration.

## 7. Implementation handoff — NOT YET AUTHORIZED
After design approval, create an issue-linked implementation PR that consumes this exact design revision, with versioned SQL, a read-only extraction/conversion utility, disposable validation, operator runbook and acceptance report. No ad hoc phpMyAdmin-to-production import.

## 8. Governance
Engineering docs are authoritative. PRs implement approved design. This proposal does not grant permission to change either database or production services. Production runbook-first rule applies in full.
