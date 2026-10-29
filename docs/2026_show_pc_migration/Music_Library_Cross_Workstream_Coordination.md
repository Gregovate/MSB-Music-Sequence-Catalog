# Music Library Inventory — PostgreSQL and 2026 Sequencing Coordination

| Document control | Value |
|---|---|
| File | `docs/2026_show_pc_migration/Music_Library_Cross_Workstream_Coordination.md` |
| Revision | Engineering coordination proposal 0.1 — 2026-10-28 |
| Status | Cross-workstream handoff and design dependency record; **not an implementation, migration, or file-copy approval** |
| Repository | `Gregovate/MSB-Music-Sequence-Catalog` |
| Owning inventory branch | `docs/2026-show-pc-migration` |
| Inventory branch baseline reviewed | `2bf205814b26ba486d221b98f3e0cb97be455e04` |
| Parallel PostgreSQL / sequencing design branch | `docs/music-catalog-recon-20261028` |
| Parallel design branch baseline reviewed | `51cbe2af87f59178f3df4ddf1ad9f32f994e5192` |
| Main reviewed | `cf6894d496d8099d0ebf07a74ca756c8841b07c5` |

## Ownership and authoritative documents

One repository, two **existing** workstream branches. This checkpoint belongs to the established inventory/Show-PC branch, not a newly created competing branch. It **references and does not overwrite or merge** the parallel PostgreSQL/2026 workflow design branch.

- Inventory engineering authority: [Original Audio Catalog Engineering](Original_Audio_Catalog_Engineering.md); [Music Library Scanner Specification](Music_Library_Scanner_Specification.md); [conceptual catalog model](../data_model.md); [migration README](README.md).
- Inventory execution procedure (read-only): [Original Audio Catalog Operator Scan](Original_Audio_Catalog_Operator_Scan.md).
- PostgreSQL proposed authority **on the parallel branch**: [PostgreSQL Migration Engineering Design](https://github.com/Gregovate/MSB-Music-Sequence-Catalog/blob/docs/music-catalog-recon-20261028/docs/postgresql_migration_design.md), revision 0.1 (not approved for deployment); [MariaDB source DDL/data model](https://github.com/Gregovate/MSB-Music-Sequence-Catalog/blob/docs/music-catalog-recon-20261028/docs/data_model.md), revision 0.2.
- 2026 workflow proposed authority **on the parallel branch**: [2026 Music Production Workflow](https://github.com/Gregovate/MSB-Music-Sequence-Catalog/blob/docs/music-catalog-recon-20261028/docs/2026_music_workflow_design.md), revision 0.1 (review required).
- Engineering governance proposed on the parallel branch: [Engineering Design Governance](https://github.com/Gregovate/MSB-Music-Sequence-Catalog/blob/docs/music-catalog-recon-20261028/System_Documentation/Project_Rules/Engineering_Design_Governance.md). Engineering docs control design; implementation issues/PRs consume **approved** designs. Current inventory branch also has its own Project Rules index, runbook-first, repository-change and versioning controls. Do not silently replace either branch's rule files.
- MSB Production Database/Preview Authoring and Server Management remain **separate owners** of their present production interfaces, preview identity/configuration, production PostgreSQL runtime, roles, backups and deployment. Neither workstream invents a new production preview/write contract.

## Parallel work boundaries

| Workstream | Owns / can proceed independently | Must not assume |
|---|---|---|
| Music Library Inventory | File occurrences, purchased/ripped-album provenance, Originals vs normalized Show-Audio, conservative classifications, album paths, physical duplicates, exact legacy names, SHA-256 later | Existing MP3 filenames identify songs; all 15 years are completely scanned; files in source folders are necessarily raw; a candidate destination is authorized |
| Historical MariaDB → PostgreSQL | Evidence-preserving migration of `raw_show_sequences`, `shows`, `sequences`, `show_sequences` as **proposed** in parallel branch, with disposable validation and review | Inventory/album data is already in those four tables; new recording/audio tables are approved; placement of the `music` schema in production is accepted |
| 2026 sequencing workflow | Season selection/assignment, versioned Scratch → tested → approved Final, contributors, music-side Preview reference, release/show history | Music conversion may alter DB physical Display/Comment/Controller/Network; a music work order automatically authorizes release; library scan completion is necessary for local playback |

**Historical MariaDB source evidence in the parallel design:** Synology MariaDB 10.11.11 `msb_sequence_catalog`, SQL export 2026-10-28, four tables with exported row counts 409 raw, 14 shows, 408 sequences, 408 show-sequence links. The parallel design lists a header row in raw and `sequences(id=408)`, damaged imported path separators, ambiguous year in some sequence filenames, role misclassification, and MariaDB prefix-unique path index behavior. These facts must remain source-provenance warnings, not silently repaired in the original-source catalog or during raw migration.

## Critical decision collision — database placement

**UNRESOLVED; do not implement.** Existing inventory branch controlled `db/README.md`, `Operational_Documentation_Rule.md` and `docs/data_model.md` prohibit adding catalog schema/tables to the MSB production PostgreSQL database without deliberate approved governance change. The parallel PostgreSQL proposal 0.1 instead suggests **a dedicated `music` schema in the existing production PostgreSQL 16 database**. A schema provides namespace separation but shares the production database's failure/backup/migration domain.

This is a **proposed architecture conflict, not a migration authorization or an implicit policy override**. Before PostgreSQL implementation or physical catalog table design, the owner must choose and formally approve database placement and the changed governing rules if required; agree on ownership, isolation, role/authentication boundaries, backup/restore, maintenance/recovery and cross-repository runbook authority. Until then retain the MariaDB source intact and run only separately approved read-only/disposable discovery. Do **not** create `music` or catalog tables in production.

## Data-contract coordination — no premature physical schema

The inventory's domain is richer than the four legacy history tables:

1. `Song / composition` ≠ `recording / artist / master`.
2. `Recording` ≠ `audio edit` (cropped/shortened or alternate-timing show edit).
3. `Audio edit` ≠ `rendition` (source original, Audacity-normalized show copy, vendor-provided edit).
4. `File occurrence` carries exact source path, filename, size/timestamp, SHA-256 when verified, album/source-package grouping and provenance; multiple occurrences can be byte-identical without being extra songs.
5. `Sequence revision` carries exact editable file version, programmer attribution, year and exact `musicFilename`, plus source/target Preview references owned externally. The 2026 Scratch Christmas Canon correction must not rewrite 2025 Final history.
6. `Use in show` and `show/playlist entry` are not file-name year prefixes. Operator's verified historical **Final membership** establishes use for that season. The proposed 2026 workflow separately uses LSS imports for show-usage details/validation; LSS evidence must not silently erase operator-confirmed historical Final use. Resolve evidence hierarchy in a reviewed shared design.
7. Operational cues, purchased RGB Plus sequence audio packages, ripped/purchased albums, and historical themed/video show variants require their own classifications and provenance. A supplier's bundled audio is neither automatically original nor normalized.

The legacy history migration may load its **four original tables unchanged** in an approved target after independent design approval. It must not invent `album`, `recording`, `audio_asset`, `conversion`, `testing`, `release` SQL as part of that first raw migration. The inventory should export an external, versioned, non-destructive **file-occurrence/provenance manifest** for a *later* domain expansion, rather than writing directly into a candidate database.

## Checkpoint and dependencies

**Scanner baseline:** read-only V0.3.0, `tools/scan_seasonal_original_audio_v0_3_0.ps1` pinned to source commit `1011c34c1bac2f68441896be82dc8f6f75621b51`, Source `G:\Shared drives\Seasonal Files`, local resumable checkpoints `%LOCALAPPDATA%\MSB\SeasonalAudioCatalogScanV0_3_0`. V0.2.0 was stopped and superseded. Operator's **bounded** V0.3.0 test: 100 directories completed, 53 audio file occurrences, 175 **currently discovered** pending directories (not a definitive remaining-total), expected PARTIAL, no reported runtime error. This is **not complete inventory coverage** and no master audio folder has been created.

**Dependencies and gates:**

- Inventory → source identity: resume V0.3.0 on the Show PC, get `CoverageComplete=True` and review skipped directory links/errors, then review albums, loose originals, normalized show copies and bundled purchased-sequence files. Additional source roots outside Seasonal Files require separately documented scans.
- Inventory → canonical files: classify originals using source evidence and read-only hashes, resolve collisions/alternate editions, approve destination layout and a **separate** no-overwrite/hash-verified copy procedure. No automatic copy/consolidate/rename/delete.
- Inventory → PostgreSQL: share stable manifest field definitions, counts/coverage, provenance and uncertainties; **no production database write**, no merge of experimental schema, no automated join using damaged historical paths.
- PostgreSQL → Inventory: decide storage/identity and migration boundary before designing persistent catalog tables or file-ingest jobs. Raw migration of legacy historical tables is logically separable from completion of the full audio inventory.
- 2026 workflow → Inventory: resolve current local MP3s by exact legacy sequence reference while canonical naming is designed. Only verified 2026 working copies may have later audio-reference remaps under a reviewed conversion procedure. The Show PC already holds the initial 24 exact 2025-source audio files; this does not establish canonical audio completion.
- 2026 workflow → PostgreSQL: personnel/authentication and optional Work Management integration are separate proposed interfaces. The proposed workflow owns assignments/tests/release facts in Music, not MSB physical asset tables. The work management design is not an approved generic music task scheduler.

## Open decisions — explicit review required

1. Production `music` schema versus independent catalog database; any governance exception and owning deployment authority.
2. Whether legacy MariaDB source is frozen; precise counts/timezone/index/repair policy, raw table placement, disposable validation and rollback.
3. Canonical recording/album/edition/audio edit/rendition identity and checksum matching rules; show normalized original pairing when raw provenance is missing.
4. Scope/coverage of audio files located outside Seasonal Files, and handling of skipped links, inaccessible folders or repeated paths.
5. Master cloud library `G:\Shared drives\Seasonal Files\LOR-Audio` final acceptance, album hierarchy, collision resolution, and original/show audio copy manifests.
6. Historical Final-use proof versus LSS-derived actual-use verification and the release/test approval distinction; no retroactive fabricated approvals.
7. Programmers/testers/approvers as identities (separate from filename labels), Work Management integration and notification ownership.
8. Safe format-specific `.loredit`/`.lms` reference rewrite, previous seasons immutable vs corrected 2026 Scratch working revisions, LOR offline test, timing/normalization policy.
9. FreeFileSync direction, authoritative source, conflict/no-delete policy and release/rollback procedure; **not configured**.

## Next read-only actions and handoff

**Inventory:** Resume the current pinned V0.3.0 scan session, do **not** restart or create a new scanner branch; generate/export full local report, review real archive folder inventory and album groups, then propose original selection for approval. No file mutations authorized.

**PostgreSQL:** Read/approve the parallel engineering design and production-hosting boundary; later disposable validation only under owning server procedures. This inventory checkpoint does not alter parallel PostgreSQL documents or authorize DDL.

**Sequencing:** Continue conversion/testing on separate 2026 Scratch sources using the MSB Production Database approved preview source; do not mutate verified 2025 Final or silently change 2026 audio aliases.

**Source control:** This design checkpoint is on the **existing inventory branch**. Its exact baseline and parallel-branch source SHAs are recorded above; the new commit SHA is reported in the final repository handoff and operator response. Implementation PRs must consume the revised approved engineering design, not infer authorization from this proposal.
