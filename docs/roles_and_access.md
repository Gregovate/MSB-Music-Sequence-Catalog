# MSB Music & Sequence Catalog — Roles and Access
Document revision: 0.1 — 2026-10-28
Status: DESIGN PENDING

The operator reports no music-catalog-specific database users/roles defined as part of the initial work. Current MariaDB account permissions have not been inspected. Do not infer privileges from phpMyAdmin login.

Desired future roles: music catalog administration, ingestion, read-only reporting, programmer assignment/progress, testing, and production release approval. Exact permissions, identity provider integration, and mapping to existing MSB People/Google SSO remain pending design decisions.

No credentials, grants, or authentication changes are authorized by this document. First inventory accounts/grants using an approved read-only procedure, then design least-privilege access and operator-facing procedures.
