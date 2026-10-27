# Release Identity and Versioning Rule

## Purpose

Catalog/import/migration tools need distinct identities when their behavior materially changes so accepted results can be reproduced.

## Material change rule

Use a new visible tool/version identity when a change affects:

- sequence parsing;
- audio/media dependency extraction;
- path resolution;
- deduplication or matching;
- copy-manifest generation;
- file mutation/copy behavior;
- database schema;
- reconciliation decisions;
- acceptance results.

Documentation-only changes do not require a new tool version.

## Accepted-result identity

Any migration output used to copy or validate Show-PC files should be traceable to:

```text
tool/version
+ exact source SHA
+ source archive scope
+ input selection
+ generated manifest/report
+ acceptance result
```

Do not rely on a filename alone to prove which logic generated a manifest.

## Migration safety

A read-only catalog/inventory release and a file-copy/mutation release are materially different capabilities and should be distinguishable.

Do not silently expand a read-only scanner into a tool that mutates the archive or Show PC.

## Simple rule

> **If the tool can produce materially different catalog or migration results, give that candidate a distinct identity and preserve the exact SHA that produced the accepted output.**
