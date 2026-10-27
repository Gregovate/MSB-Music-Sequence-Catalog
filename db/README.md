# Database Layer

This folder is reserved for the Music & Sequence Catalog's own data-store schema, migrations, and seed/reference data if a database backend is adopted.

## Ownership Boundary

The Music & Sequence Catalog database is **independent of the MSB Production Database system**.

Do not place catalog tables, schemas, functions, migrations, or application dependencies in the MSB Production Database PostgreSQL environment.

The catalog repository owns its own:

- data model;
- migrations;
- runtime configuration;
- backup and restore procedure;
- deployment/upgrade procedure.

## Backend Status

The database engine and hosting location are **TBD**. Older scaffold assumptions about MariaDB or Synology are not current authority unless they are deliberately reconfirmed by the project.

When a backend is selected, update the controlled engineering documentation before implementing migrations.

Migrations must be:

1. incremental;
2. reversible when practical;
3. committed in order; and
4. traceable to the catalog release/tool version that requires them.
