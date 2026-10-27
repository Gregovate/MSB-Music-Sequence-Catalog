# MSB-Music-Sequence-Catalog
Centralize all information about MSB music and sequences into a single, queryable system

## Overview
The MSB Music & Sequence Catalog is the centralized system for managing all musical and sequencing assets used in the Making Spirits Bright show. This repository contains:

- The catalog data model and migrations, if a database backend is adopted
- Documentation for file conventions, audio handling, sequence types
- Tools for importing and analyzing music, audio files, sequences, and show history
- A backend API and future UI for browsing, planning, and theme-night design

This project replaces fragmented spreadsheets and scattered folders with one unified, version-controlled, long-term source of truth.

## Database Boundary

If this project uses a database, it is **independent of the MSB Production Database system**. Its schema, migrations, runtime, backup, and recovery remain owned by this repository. The database engine and hosting location are not currently fixed by this README.

---

## Goals
- Maintain a catalog of all **songs**, **audio files**, **sequences**, **purchased RGB+ content**, and **show playlist history**.
- Track **classification** (era, style, energy, audience, themes).
- Provide a consistent logical path model that works across all MSB workstations, regardless of local filesystem differences.
- Parse and analyze `.lss` show files to reconstruct usage history.
- Support future **theme-night programming**, analytics, and sequence planning.

---

## Repository Structure
```
MSB-Music-Sequence-Catalog/
│
├── README.md
│
├── docs/
│   ├── overview.md
│   ├── data_model.md
│   ├── data_sources.md
│   ├── path_conventions.md
│   ├── sequence_types.md
│   ├── ingestion_plan.md
│   ├── ui_design.md
│   └── roles_and_access.md
│
├── db/
│   ├── migrations/
│   │   └── placeholder.txt
│   ├── seed/
│   │   └── placeholder.txt
│   └── README.md
│
├── backend/
│   ├── api/
│   │   └── placeholder.txt
│   ├── parsers/
│   │   └── placeholder.txt
│   ├── models/
│   │   └── placeholder.txt
│   └── config/
│       └── placeholder.txt
│
└── tools/
    ├── import_audio_csv.py
    ├── import_rgbplus_sequences.py
    ├── import_lss_history.py
    └── utilities/
        └── placeholder.txt
```
