# MSB Music Catalog — Integrated Engineering Design
Revision: 0.1 — 2026-10-30
Status: DESIGN REVIEW / HOLD FOR APPROVAL; no DDL, deployment, or file mutation authorized
Commanding authority: [Issue #1](https://github.com/Gregovate/MSB-Music-Sequence-Catalog/issues/1)
Inputs: audio evidence and authority contract on branch `docs/2026-show-pc-migration`; historical MariaDB reconstruction and workflow design on draft PR #2 (`docs/music-catalog-recon-20261028`).
This is an integration design, not a replacement for the audio evidence branch. Reconcile and merge approved design under Issue #1 before implementation PRs consume it.

## 1. Objective and accepted constraints
Build one searchable catalog for (a) historical songs and sequences, (b) available original recordings for new sequencing, and (c) exact duplicate inventory/consolidation, without requiring operator review of thousands of files. A catalog row is not a physical file. Do not infer song identity from filename alone or confuse distinct content hashes with distinct songs.
2026 has no approved playable musical sequence revisions yet. Historical sequences remain immutable evidence and must be converted for current-year use because of annual Master Musical Preview changes, even when the LOR software generation is unchanged.
Canonical filenames must omit year-of-use; show years live in show/sequence history. Original recordings are preserved. Edited audio timing is the sequencing baseline. One timing edit may have normalized and non-normalized renditions of the same timeline.
Preserve local LOR audio path `C:\LOR\Audio` for programmer and Show PCs, with offline playback. Proposed nonannual Google Drive master root: `G:\Shared drives\Seasonal Files\LOR-Audio` with `Originals/Albums`, `Originals/Singles`, and `Show-Audio`. This is selected design target, not an existing verified populated folder.

## 2. Verified evidence, not guessed data
Historical Synology MariaDB 10.11 source `msb_sequence_catalog` exported 2026-10-28: `raw_show_sequences` 409 rows, `shows` 14, `sequences` 408, `show_sequences` 408. The raw and sequences imports contain header artifacts; some imported Windows paths lost separators. Source export is immutable evidence. Show files (.lss) establish programmed membership, section and order; verified seasonal Final folder membership is operator evidence of actual use. Neither proves a canonical recording or original file without LOREDIT/LMS media reference reconciliation.
Audio workstream reports complete Seasonal Files survey 11,969 occurrences/3,724 directories; focused SHA survey 2,838 HASH_OK occurrences, 817 distinct hashes, 2,021 duplicate occurrences, 405 duplicate groups, 139 tagged artist/album groups, 81 same-artist/title distinct-hash groups, 599 missing artist/title tags. Provisional 817-hash split: 293 Original candidates, 222 Show Audio candidates, 302 Deferred; these are NOT approved identities. Staging workbook `MSB_Master_Music_Catalog_Database_Handoff_20261029.xlsx` has not been imported or accepted as a database. Duration and genre are not measured for all records and remain NULL until evidence exists. A 24-MP3 initial 2025 selective transfer was hash-verified; do not recopy those 24 by default.

## 3. Deployment architecture — binding conflict and resolution gate
The audio authority document `docs/2026_show_pc_migration/Master_Music_Catalog_Authority_and_Data_Contract_20261029.md` selects logical dedicated PostgreSQL database `msb_music_catalog`, with host/instance/roles/backup unapproved. It explicitly HOLDS the earlier draft PR #2 proposal for `music` schema inside existing production database `msb`.
**Current design target is dedicated `msb_music_catalog`; do not deploy `msb.music`.** Final physical host/instance and ownership must be accepted with MSB Server Management before DDL. A separate database cannot use ordinary cross-database foreign keys to `msb.ref.person`; Person IDs must be treated as external authoritative references with a governed lookup/snapshot/API contract, not copied as a second person master. If cross-database referential enforcement is required, that is a separate architecture decision under Issue #1. Never silently switch back to a production schema.

## 4. Logical normalized entities and cardinalities
| Entity | Identity and minimum contract | Relationship |
|---|---|---|
| song | song_id, canonical title, aliases, optional genres/themes, review state | 1:N recordings |
| artist | artist_id, display/sort names, aliases, provenance | M:N recording via recording_artist with performer role |
| album_release | album_id, title, album artist, edition, release metadata | N:M recordings/tracks via release_track with disc/track/order |
| recording | recording_id, song_id, arrangement/edition, identity evidence, review status | 1:N audio edits |
| audio_edit | edit_id, recording_id, edit type, approved duration_ms, crop/fade boundaries, timing approval/evidence | 1:N renditions |
| audio_rendition | rendition_id, edit_id, normalized flag/recipe, codec/sample rate/bitrate/channels, measured duration_ms, SHA256, bytes, status | 1:N physical occurrences |
| file_occurrence | occurrence_id, content/rendition link nullable, exact path, basename, source root, size/hash, scan run, observed metadata, role confidence | multiple locations for same bytes |
| inventory_run | run_id, scanner version, source root, time, evidence hash, counts | 1:N occurrences |
| sequence_asset | logical musical or animation program; song/recording link when resolved | 1:N revisions |
| sequence_revision | revision_id, asset, season, parent revision, LOR authoring version (inferred/verified), exact file/path/hash, source preview, programmer Person reference, Scratch/Final, approval | N:M show entries |
| master_preview_revision | preview identity, season, source filename/hash, approval status | referenced by sequence revision and test |
| sequence_media_dependency | exact LOREDIT/LMS embedded musicFilename, resolution to rendition/edit, evidence/confidence | revision -> audio |
| show | show_id, season, show variant (main/video/theme), .lss source identity and import provenance | 1:N show_entry |
| show_entry | show, sequence revision/reference, section, order, role, evidence | many appearances of one revision |
| season_plan / assignment / activity | target season, source revision, assigned Person external ID, due date, conversion status, actor/time/event | independent from general repair WO |
| test_event / release_event | exact revision hash, preview hash, audio edit/rendition, tester/approver Person external ID, outcome and time | immutable evidence |
| non_song_cue | cue kind and audio dependency for voiceover/open/close/stems/SFX | not forced into song |

**Critical timing rule:** one approved audio edit fixes the musical timeline. Normalized and non-normalized renditions may differ in bytes but must match the same edit duration and alignment. Store integer duration_ms; UI uses `m:ss.fff` (e.g. `3:15.500`). LOR centiseconds convert by 10 ms per unit; do not invent subsource precision. Exact audio checksum and measured duration remain rendition-specific. A changed crop/fade timeline is a new edit and requires affected sequence review. Gain-only changes may be compatible after validation.

**Song identity rule:** canonical song is never duplicated/versioned by year; different artist performances are different recordings; each annual LOR sequence is a distinct revision and may have parallel programmer alternatives. The show-entry join records actual .lss inclusion and order; matching table counts do not mean duplicate tables.

## 5. Historical import preservation and reconciliation
Migration 1: retain all four MariaDB tables as lossless source/staging history in the dedicated catalog database, with original IDs, relationships, raw strings and timestamps. Include import-run/source-hash metadata outside original fields. Known header records and broken paths remain documented exceptions until reviewed. Validate counts 409/14/408/408, all PK/FK links and content checksums. Do not claim that raw file references are canonical songs.
Migration 2: load audio inventory occurrences and distinct hashes into staged/reviewable records, retaining all 817 identities and 2,838 hashed occurrences. Unresolved 302 remain visible; do not force approval. Missing durations/genres remain NULL.
Migration 3: extract media dependencies from LOREDIT/LMS and reconcile by exact path/name, verified hash and other evidence. Derive canonical song/recording identity with reviewed alias rules; ambiguous same-title/different-hash matches remain exceptions.
Migration 4: introduce season planning, conversion assignments, testing, release, historical/video/theme usage and reporting. No 2026 release implied by a historical Final folder.

## 6. Human identity and authorization
Existing PostgreSQL `msb.ref.person` is authoritative. Operator verified Adam Biebel person_id=1, Andrew Bubb=3, Greg Liebig=17, all active. Keep raw historical author strings. Never create a separate People master. In dedicated database, store external person_id references with source authority, lookup/verification evidence and stale-reference behavior. Do not assert cross-database FK integrity. Existing Directus/People auth and audit cannot be assumed to work automatically in the dedicated database; Server Management/People must approve an explicit least-privilege integration contract. Work Management #419 is repair/ticket-oriented; normal annual music assignments remain music-owned unless an approved general-task contract exists.

## 7. Canonical naming and physical consolidation
Names do not encode show year, sequence programmer or metadata held in catalog. Name policy must disambiguate distinct recordings and timing edits/normalized variants deterministically, sanitize Windows-invalid characters, check case-insensitive collisions and keep source filenames as aliases. Do not create a third copy merely to obtain a clean name: choose a retained canonical occurrence or approved move/copy only after verified hashes and manifests.
Produce proposed actions with source path, canonical target, bytes/hash, dependent LOREDIT/LMS paths, overwrite/collision status, retained archive evidence and rollback. Exact SHA duplicate detection is automated; same-title different-hash is NOT auto-delete. Preserve historical sequences unchanged; retain recoverable historical audio/source archives until separately approved retirement. The current 2026 sequence set is empty, so no 2026 musical sequence references require bulk relinking; validate any new work created after this checkpoint before a later file operation.

## 8. User-facing minimum viable catalog
DBeaver browse/search first; future UI exposes Original Music, Show Audio, Historical Shows, Sequence Versions, Duplicate Groups and Exceptions. Show source, confidence and approval state. Search by song, artist, album, year, programmer, file alias and checksum. Show song history without year-prefix filenames; separate planned, Final-verified and .lss-programmed evidence. Show approved duration `m:ss.fff`, original vs cropped vs normalized, and selected canonical audio file.
Operator reviews only exceptions/collisions and proposed deletions, not every file. No file deletion is implicit in a catalog import.

## 9. Acceptance gates and sequencing
A. Cross-workstream design review and approval under Issue #1, including resolution of hosting and Person identity integration. Existing audio evidence branch remains authoritative for scan facts.
B. Server Management host/backup/restore/runbook design for dedicated catalog database. No production `msb` changes.
C. Implement versioned migrations and read-only import adapters in an implementation PR consuming approved design; private data stays out of Git.
D. Disposable PostgreSQL database tests: exact historical counts and FK preservation; 817 hash identities/2,838 occurrence import; null handling; duplicate grouping; ID3 ambiguity; duration format; cross-database identity failure cases; idempotent reruns; least privilege; restore/rollback.
E. Explicit operator approval for database creation/import; DBeaver read-only verification.
F. Separate approved file-consolidation dry run, reviewed manifests, hash-verified copy/move, rollback and offline playback test. No deletes before acceptance.

## 10. Blocking decisions and evidence gaps
- Physical PostgreSQL instance/host, roles, backup ownership, network exposure and restore runbook for dedicated database.
- How to resolve authoritative Person identity from dedicated database without unsupported cross-database FK.
- Confirm exact current source export/data package checksum, safe timestamps and MariaDB prefix-index semantics.
- Import staging workbook availability, scanner manifests and versioned hash evidence in an accessible controlled location.
- LOREDIT/LMS metadata fields for preview, LOR version and exact audio dependency; source year-version mapping is inference only.
- Canonical filename collision policy and exact audio alignment verification, beyond equal durations.
- Audio edit/recording approvals and rights/provenance exceptions.
- Reconcile the audio workstream's `.lss` generated-artifact caution with the independently verified historical .lss show membership parser. Do not discard historical show evidence.

## 11. Release status
DESIGN ONLY. No database installed, no production mutation, no file rename/move/delete, no change to LOR runtime. A PR does not imply deployment. Changes require accepted design revision and explicit operational approval.
