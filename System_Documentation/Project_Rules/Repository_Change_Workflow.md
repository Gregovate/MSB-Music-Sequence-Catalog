# Repository Change Workflow

## Purpose

This rule defines the minimum repository synchronization and change-isolation steps for the MSB Music & Sequence Catalog.

## Step Zero — Refresh Before Editing

Before changing code, schema, scripts, configuration, or controlled documentation:

1. refresh the repository view from current remote `main`;
2. identify the current `main` head;
3. read the latest affected files;
4. inspect open work that may touch the same area; and
5. create or refresh an isolated working branch from current `main`.

Do not edit from remembered repository state or from an old chat summary.

For connector/API-based work, creating the branch directly from current remote `main` and reading the current remote files satisfies this requirement.

## Read-only investigation first

Catalog discovery, historical archive inventory, sequence parsing, and dependency analysis must begin read-only.

Do not rename, move, delete, rewrite, or normalize files in the annual Seasonal Files archive merely to simplify analysis.

When a script is intended only to inventory or analyze source material, it must be designed and reviewed as read-only before it is run against the archive.

## File migration changes

A migration tool or copy manifest must clearly identify:

- source path;
- destination path;
- operation type;
- whether existing files may be overwritten;
- whether deletions are possible;
- dry-run/preview evidence; and
- validation after the copy.

A catalog scan and a filesystem mutation are separate operations. Do not combine them silently.

## Concurrent work

If another branch or thread has changed the same design or tool:

- read the newer work first;
- preserve accepted newer decisions;
- reconcile conflicts against current repository authority;
- do not overwrite newer documentation because an older thread contains a draft.

## Documentation changes

Documentation is subject to the same refresh rule as code. Before rewriting a runbook or workstream document, read the current repository version and preserve accepted decisions.

## Command handoff

When commands are provided to Greg:

- state the expected repository/path or machine context;
- give steps in execution order;
- stop after failures rather than chaining into later mutation;
- distinguish read-only inspection from mutation;
- include verification of the result.

## Simple rule

> **Refresh current main, read current authority, investigate read-only first, and isolate every change before editing or copying production data.**
