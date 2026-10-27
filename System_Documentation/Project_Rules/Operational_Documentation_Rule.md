# Operational Documentation Rule

## Purpose

This rule keeps engineering design separate from the procedures used to operate and recover the Music/Sequence Catalog and Show-PC migration workflow.

## Separate engineering from operator procedure

Engineering documents explain:

- data models;
- parsing rules;
- source authority;
- reconciliation behavior;
- architecture and tradeoffs.

Operational/runbook documents explain:

- exact source and destination paths;
- installation/setup steps;
- read-only inventory steps;
- dry-run/copy procedure;
- verification;
- rollback/recovery;
- acceptance criteria.

Do not bury operator instructions inside design discussion.

## Path contracts are controlled facts

For the Show PC, the live Light-O-Rama runtime root is:

```text
C:\LOR
```

If a migration or catalog decision depends on a filesystem path, that path must be documented in the owning runbook before later work depends on it.

## Independent database ownership

If the Music/Sequence Catalog uses a database, it is owned and operated independently from the MSB Production Database system.

Do not place catalog tables, schema, functions, migrations, or runtime dependencies in the MSB Production Database PostgreSQL environment. The catalog must maintain its own database design, migration procedure, backup/recovery procedure, and runtime authority once a backend is selected.

Older scaffold references to a particular database engine or host are not authority for the future design unless deliberately reconfirmed in current engineering documentation.

## Historical sources versus runtime

The annual Google Shared Drive folders under:

```text
G:\Shared drives\Seasonal Files\<YEAR>\LOR
```

are historical/source archives.

They must not be treated as the live runtime simply because they are accessible on the Show PC.

The running show must not require an Internet connection or Google Drive availability.

## Procedure updates during discovery

When field work exposes a missing or incorrect operational step:

1. preserve the finding;
2. verify it;
3. update the owning procedure;
4. then use the corrected procedure for later work.

Do not let chat become the only record of the fix.

## Simple rule

> **Design explains why; runbooks explain exactly how. Paths, copy boundaries, validation, and recovery belong in controlled operational documentation.**
