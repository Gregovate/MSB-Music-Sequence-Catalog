# PostgreSQL Migration Engineering Design — Synology MariaDB to MSB Production
Revision: 0.3 — 2026-10-28
Status: ENGINEERING DESIGN IN PROGRESS / REVIEW REQUIRED / NOT AUTHORIZED FOR DEPLOYMENT
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

## 9. Existing PostgreSQL actor/person contract — verified from owning repository
The production database already has durable human identities in `ref.person(person_id)`, Directus linkage via `directus_user_id`, and shared `ref.resolve_actor()` with `person_id` and `actor_name`. See MSB-Production-Database-Project `People/README.md`, `People/Database/005_reconcile_directus_person_identity.sql`, and `Database/Acceptance/database_shared_audit_actor_disposable_validation.sql`.

**Decision for proposed design:** Do not create a separate music user/person/actor master. Future music assignments, testing, release approval and audit events must reference existing `ref.person.person_id` as appropriate. Historical free-text CSV `owner` and file-name author strings remain raw provenance; never auto-join them to a person by name. Mapping requires explicit, reviewed reconciliation with ambiguity/unmatched status. Purchased sequence creator/vendor attribution is not equivalent to an MSB human actor.

**Actor security:** use the accepted Directus UUID -> `ref.person` resolver and governed capability/authorization pattern. Never infer privileges from Person flags, Cloudflare authentication, or a filename. Existing shared audit fields are `created_at`, `created_by`, `created_by_person_id`, `updated_at`, `updated_by`, `updated_by_person_id`. Determine whether these should apply to new mutable music-domain tables through the owning audit policy before implementing; do not retroactively invent actor values for 2025 historical imports. Import provenance must distinguish system migration from original human action.

**Stage 1 historical tables:** keep imported source columns and original timestamps intact. New migration metadata (source dump fingerprint, import run, imported_at, migrator) should live in separate governed metadata rather than changing imported values. No automatic person FKs are added to legacy raw rows in Stage 1.

**Stage 2 workflow:** use Person FKs for `assigned_to_person_id`, `assigned_by_person_id`, `tested_by_person_id`, `approved_by_person_id`, and actor/event attribution; names are display projections, not keys. Do not duplicate Work Management task ownership. Cross-schema references to `ref.person` require reviewed grants and disposable validation.

## 10. Migration implementation boundary and unresolved gates
Stage 1 is a strict preservation migration of four tables only, with explicit source export evidence and verified counts. Stage 2 is a separate approved domain-model migration consuming music library inventory and the shared actor contract. This prevents an incomplete audio inventory from blocking preservation of history, without prematurely creating bad song identity tables.

Before Stage 1 SQL can be approved: confirm exact source export is available to disposable validation, timestamp timezone, path uniqueness/collation behavior, current music schema name availability, owner/migrator roles, and authorized server-managed disposable runner. Do not claim these checks have passed merely because code exists.

## 11. Verified historical programmer mappings — 2026-10-29
Operator executed a read-only query against production PostgreSQL `ref.person` and confirmed the following active, unique identities:

| Historical author token | person_id | Existing Person |
|---|---:|---|
| Adam | 1 | Adam Biebel |
| Andrew | 3 | Andrew Bubb |
| Greg | 17 | Greg Liebig |

These are approved candidate mappings for the three known historical programmer tokens, grounded in current Person records. Retain the raw author text and use a separate reviewed mapping/relationship rather than replacing it. Apply only to exact, normalized whole-token matches after inventorying distinct source owner values; do not infer ownership for blank/other names, purchased RGB+ vendors, or names embedded incidentally in song titles. Stage 1 migration remains lossless and can be accepted independently; normalized actor relationships require disposable FK and attribution validation. Do not create Person rows or change `ref.person`.
