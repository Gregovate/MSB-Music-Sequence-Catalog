# Engineering Design Governance
Document revision: 1.0 — 2026-10-28
Status: CURRENT
Scope: MSB Music & Sequence Catalog engineering work

## Authority
Engineering documentation is the governing design authority. Issues and implementation pull requests consume the approved engineering design; code does not retroactively define design.

## Mandatory sequence
1. Reconnaissance: read repository rules, governing engineering docs, current implementation, migrations, and relevant operational evidence.
2. Document design: schema, relationships, identity rules, interfaces, workflows, ownership, security, testing and migration/rollback decisions. Identify unknowns rather than inventing facts.
3. Review and approve design before implementation changes.
4. Implement through an issue-linked PR referencing the exact governing design and revision.
5. Validate implementation against the design and preserve evidence.
6. Update engineering and separate operator documentation as part of the same work; do not declare closeout with missing or inconsistent docs.

## Change control
If implementation uncovers a design gap or contradiction, stop the affected change, document the issue, update and review design, then continue. Never silently rewrite design to match accidental behavior.

## Cross-repository ownership
The Music Catalog repository owns its music domain design, parsers and application. Any integration with MSB production PostgreSQL, People, Setup, previews or authentication must reference the owning repositories and approved interface contracts. Do not copy production wiring entities into the music catalog.

## Production gate
Read System_Documentation/Project_Rules/Runbook_First_Production_Rule.md before any production mutation. A missing procedure is RUNBOOK GAP FOUND; reconnaissance and documentation do not authorize production changes.

## Legacy implementation reconciliation
Observed runtime tables with no approved design must be documented as observed, compared to live DDL and historical evidence, and reviewed before being declared authoritative. No migration or destructive cleanup is permitted merely to make runtime match an unapproved reconstruction.
