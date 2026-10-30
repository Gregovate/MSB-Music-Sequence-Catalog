# MSB Music & Sequence Catalog — Ingestion and Reconciliation
Document revision: 0.1 — 2026-10-28
Status: RECONNAISSANCE / NO IMPORT AUTHORIZED

## Source evidence
Historical LSS parser output fields (operator-provided):
show_file, block_index, block_kind, section, sequence_order, full_path, file_name, ext, year, owner, title, sequence_role.

A merged CSV was imported into raw_show_sequences, then normalized to shows, sequences and show_sequences. The 2025 parsed folder initially contained two show-output variants, one with missing sequence_role; the operator removed the duplicate/incomplete source and completed import. Preserve this as an ingestion failure mode.

## Semantics and limitations
- show_file prefix is the show-year source for the current imported shows; the CSV year field can instead identify a sequence's source year and may be empty or older than the show year. Do not overwrite it globally.
- block_kind, section and sequence_role must be validated against actual data. main_song is the intended musical classification; startup songs may also be meaningful. Never assume every row is a playlist song.
- YYYY Final is the operator's production convention, but old LSS paths may predate it. A strict Final filter may omit valid historical songs.
- Filename-derived titles are not authoritative song or artist identity.
- .loredit and older .lms source media references must be inspected to distinguish recordings. Do not assume all LOREDIT/LMS formats or metadata are uniform.
- Audio checksums can establish byte identity; normalized and original audio can differ while representing the same recording.
- Show entries must retain source file and order, and repeated imports must not erase manual identity corrections or release/test decisions.
- 2011 requires review; historical years other than 2011 are treated as locked unless separately authorized. 2025 import workflow must support progressive updates.
- Video playlists are not yet imported and must be modeled separately from the main production show.

## Proposed stages — NOT YET IMPLEMENTED
1. Preserve immutable source CSVs, source show filename, parser version and import-run provenance.
2. Validate headers, row width, duplicate source files, year mismatches and role distributions before staging.
3. Load staging; reconcile shows and exact sequence-file references with deterministic keys.
4. Extract media references from .loredit/.lms and propose song/recording matches; queue ambiguities for review.
5. Generate marketing matrix from approved recording/song mappings; label uncertain version associations.
6. Later add conversion, assignment, testing, release and video/themed-show workflows.

## Acceptance gates
Read-only counts and exception reports precede any import. No database writes, folder moves, or audio cleanup without approved design and operator authorization. Document exact import command, dry run, backup/rollback, and operator acceptance before deployment.
