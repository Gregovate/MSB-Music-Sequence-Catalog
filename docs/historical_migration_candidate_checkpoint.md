# Historical migration implementation checkpoint — 2026-10-29
Status: CANDIDATE BUILT; PRODUCTION NOT DEPLOYED.

Source SQL dump converted into four CSV datasets (409/14/408/408) with original IDs and FK relationships verified offline. Data bundle is a private operator artifact, not committed to GitHub. PostgreSQL schema and psql client-side COPY loader prepared in conversation artifact; target schema: music. Known raw header records and malformed source paths intentionally preserved. Historical timestamps retained as wall-clock timestamp pending timezone provenance. PostgreSQL unique prefix-path semantics deferred; no stronger unique constraint introduced.

**Validation:** Offline parsing/counts/column arity and foreign-key reference sets PASS. No PostgreSQL disposable-clone test, live schema preflight, roles/grants validation or production deployment has been performed. Must use Server Management disposable acceptance and database-changing production runbooks. No direct ad hoc production SQL.

**Next gate:** run existing disposable clone acceptance with this exact candidate; compare row-level hashes and role isolation; then obtain explicit production deployment authorization and follow maintenance controller/snapshot/validation sequence. Do not retire MariaDB.
