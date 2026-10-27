# Issue Management and Closeout Rule

## Purpose

GitHub issues are durable work items, not a replacement for controlled documentation.

## Preserve findings without fragmenting work

When Greg says **put this in the issue**, **add this to the issue**, or similar wording, first identify the existing owning issue/workstream.

Default behavior:

1. preserve the finding in the existing owning issue or workstream;
2. update controlled documentation when the finding establishes durable knowledge;
3. create a new issue only when the work is independently schedulable, acceptable, and closable.

Do not create a new issue merely because a discovery is important.

## Independent-work test

Create a separate issue only when the work can be completed and closed independently without falsely implying the parent problem is solved.

Examples that may justify separate issues:

- a new sequence parser;
- a separate catalog migration;
- a production Show-PC migration defect;
- a distinct reconciliation tool;
- a future UI or reporting capability.

Small corrections, edge cases, and discoveries normally stay with their owning workstream.

## Artifact roles

```text
conversation finding
    -> owning issue/workstream

independent durable work
    -> GitHub issue

implementation slice
    -> pull request

accepted architecture / procedure / path contract
    -> controlled repository documentation
```

## Closeout

Before closing work:

1. verify acceptance criteria;
2. update durable documentation;
3. identify implementation/merge evidence;
4. record deliberately deferred work;
5. leave open only real remaining work with an explicit next step.

The open-issue list should represent actual remaining work.

## Simple rule

> **Keep one coherent problem together, promote durable knowledge into documentation, and close work only when acceptance and documentation are complete.**
