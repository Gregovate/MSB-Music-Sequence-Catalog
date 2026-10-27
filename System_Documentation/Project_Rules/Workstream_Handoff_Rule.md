# Workstream Handoff Rule

## Purpose

Long-running MSB work often moves between chat threads. The repository must carry enough state that a new thread can resume without reconstructing architecture from memory.

## Required handoff

Before intentionally moving a workstream to a new thread, create or update a repository handoff containing:

- workstream name and scope;
- repository and branch;
- accepted facts;
- source-of-truth paths;
- hard constraints;
- completed work;
- explicitly rejected approaches;
- unresolved questions;
- current safety/production boundary;
- exact next read-only step;
- links to owning design/runbook/issue when applicable.

## New-thread startup

The new thread must:

1. read `System_Documentation/Project_Rules/README.md`;
2. read the workstream handoff/README;
3. refresh current remote repository state;
4. confirm the next step from repository authority rather than conversation memory.

## Do not use chat as the handoff

A pasted chat transcript may provide context, but it is not the durable workstream authority. Promote accepted facts into the handoff first.

## Simple rule

> **A new thread starts from repository state, not from memory.**
