# Database Layer

This folder contains:

- SQL migration files (`migrations/`)
- Optional seed data (`seed/`)

Migrations must be:

1. Incremental  
2. Reversible (when possible)  
3. Committed in order  

The root database is MariaDB on Synology. Migrations should be applied using a future migration tool or manually during development.
