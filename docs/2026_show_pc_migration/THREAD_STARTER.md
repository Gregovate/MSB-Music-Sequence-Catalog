# New Thread Starter — 2026 Show PC Music/Sequence Migration

Use this when starting a new chat/thread inside the MSB Music & Sequence Catalog project.

## Required startup

1. Read `System_Documentation/Project_Rules/README.md` and the linked rules relevant to this work.
2. Read `docs/2026_show_pc_migration/README.md`.
3. Refresh current remote `main` before proposing repository changes.
4. Treat all annual Seasonal Files LOR archives as read-only until a reviewed migration/copy step is explicitly approved.

## Scope

Continue the 2026 Show PC music/sequence migration.

The live Show PC runtime root is fixed at `C:\LOR`. The running show must not depend on Google Drive or Internet access.

The annual archive is `G:\Shared drives\Seasonal Files\<YEAR>\LOR`, with yearly LOR folders beginning in 2014.

The immediate task is not to bulk-copy historical files. Resume the unfinished catalog work by discovering annual folder layouts and sequence formats, then build a read-only sequence-to-audio dependency inventory.

The operating requirement is an ongoing **Google Drive ↔ Show PC synchronization workflow**: Google Drive protects/maintains the source files, while Light-O-Rama must run entirely from local `C:\LOR` files with no Internet dependency.

Audio must use a **single canonical library**, separate from annual year folders. The same audio file should be referenced by every sequence that uses it; create separate audio assets only when the underlying file is truly different. The local canonical runtime location is `C:\LOR\Audio`. The corresponding canonical Google Drive audio-library path still needs to be identified rather than invented.

Produce a reviewable dependency/migration manifest before any selective audio copy or sync configuration.

Do not invent a new catalog or parallel source of truth; continue `Gregovate/MSB-Music-Sequence-Catalog`.

If the catalog requires a database, it is an **independent catalog database owned by this repository**. Do not place its schema or migrations in the MSB Production Database/PostgreSQL system. Backend technology/hosting remains undecided until this project designs it.
