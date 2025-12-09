# MSB-Music-Sequence-Catalog
Centralize all information about MSB music and sequences into a single, queryable system

## Overview
The MSB Music & Sequence Catalog is the centralized system for managing all musical and sequencing assets used in the Making Spirits Bright show. This repository contains:

- The data model (MariaDB schema, migrations)
- Documentation for file conventions, audio handling, sequence types
- Tools for importing and analyzing music, audio files, sequences, and show history
- A backend API and future UI for browsing, planning, and theme-night design

This project replaces fragmented spreadsheets and scattered folders with one unified, version-controlled, long-term source of truth.

---

## Goals
- Maintain a catalog of all **songs**, **audio files**, **sequences**, **purchased RGB+ content**, and **show playlist history**.
- Track **classification** (era, style, energy, audience, themes).
- Provide a consistent logical path model that works across all MSB workstations, regardless of local filesystem differences.
- Parse and analyze `.lss` show files to reconstruct usage history.
- Support future **theme-night programming**, analytics, and sequence planning.

---

## Repository Structure

