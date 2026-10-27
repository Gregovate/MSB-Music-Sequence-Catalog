# Project Rules

This is the repository-level instruction portal for `MSB-Music-Sequence-Catalog`.

When Greg says **read the project instructions**, read this README and every linked rule relevant to the requested work before proposing changes.

## Working hierarchy

Use this authority order:

1. Project rules in this folder.
2. Owning engineering/design documentation in this repository.
3. The current workstream README or migration runbook.
4. GitHub issues for unfinished work.
5. Pull requests for implementation and review.
6. Chat for working discussion only.

A chat decision is not durable authority until it is promoted into the responsible repository document.

## Current Project Rules

- [Runbook-First Production Rule](Runbook_First_Production_Rule.md) — no Production mutation or operational cutover without first reading the governing runbook/current authority.
- [Repository Change Workflow](Repository_Change_Workflow.md) — refresh current remote `main`, read current affected files, isolate changes on a branch, and reconcile concurrent work before editing.
- [Issue Management and Closeout Rule](Issue_Management_and_Closeout_Rule.md) — preserve findings in the owning issue/workstream instead of fragmenting work; close issues only when acceptance and durable documentation are complete.
- [Operational Documentation Rule](Operational_Documentation_Rule.md) — operator procedures, migration steps, path contracts, and recovery facts must be documented separately from engineering design and kept current as work is accepted.
- [Release Identity and Versioning Rule](Release_Identity_and_Versioning_Rule.md) — scripts/tools that materially change catalog import, migration, or operator behavior require a distinct version/release identity before accepted use.
- [Workstream Handoff Rule](Workstream_Handoff_Rule.md) — long-running work must have a repository handoff that records scope, accepted facts, boundaries, unresolved items, and the exact next step before moving to a new chat/thread.

## 2026 Show PC migration workstream

Current workstream portal:

[2026 Show PC Migration](../../docs/2026_show_pc_migration/README.md)

The migration must preserve the production Light-O-Rama runtime contract:

```text
C:\LOR
```

Historical Google Drive folders are source/archive material. They are not the live runtime path.

## Rule ownership

Repository-specific engineering and operating rules belong in this folder. Current implementation details and runtime facts belong in the responsible engineering/runbook documentation rather than being duplicated here.
