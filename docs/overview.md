# MSB Music & Sequence Catalog — Engineering Overview
Document revision: 0.1 — 2026-10-28
Status: RECONNAISSANCE / DESIGN RECOVERY

## Purpose
Catalog MSB musical works, artist recordings, audio assets, sequencing revisions, historical show usage and future production readiness without polluting the existing production display/stage/wiring model.

## Current known architecture
Repository: Gregovate/MSB-Music-Sequence-Catalog.
Original stack documented in root README: MariaDB on Synology, planned Python/FastAPI backend and future UI.
Observed MariaDB database: msb_sequence_catalog with four tables: raw_show_sequences, shows, sequences, show_sequences. No evidence yet that proposed songs, audio_files, previews, conversion, test, or release tables exist.
Root README and db/README are original architecture references, not proof that all planned tools were implemented.

## Historical repository reconnaissance
Repository main commit history reviewed 2026-10-28: initial scaffold commits, README updates and later Project Rules additions. No committed SQL migration scripts were found among reviewed commit changed-file lists; db/migrations/placeholder.txt exists in initial scaffold. docs/data_model.md, docs/ingestion_plan.md, docs/roles_and_access.md and other original docs were empty on main before this recovery work.
Original kickoff transcript supplied by operator documents planned migrations 001–005, explicitly as future work, not completed implementation.
Current MariaDB four-table state was established by operator phpMyAdmin work, but live DDL remains unverified.

## Governing process
Engineering documentation controls design; issues and PRs consume approved design. Design changes require documentation review before implementation. Operator procedures are separate. Production mutations require reading the owning runbook in the current workstream; stop and declare RUNBOOK GAP FOUND when procedure is missing.
Authority: System_Documentation/Project_Rules/README.md and Runbook_First_Production_Rule.md.

## Architectural decision pending
Evaluate staying on Synology MariaDB versus migrating to a dedicated music schema in the MSB PostgreSQL production database. Compare operational isolation, authentication reuse, people/assignment integration, backups, migration risk and cross-repository ownership. Neither option is approved yet.

## Reconnaissance remaining
Read-only current DDL/indexes/counts, source CSV/parser inspection, actual .loredit/.lms metadata samples, repo worktree files not on main, historical playlist matrix provenance, and any existing uncommitted SQL. Mark unknowns explicitly; do not backfill invented implementation history.
