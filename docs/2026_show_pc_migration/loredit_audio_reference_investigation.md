# 2025 .loredit Audio Reference Investigation

| Control | Value |
|---|---|
| Filename | `docs/2026_show_pc_migration/loredit_audio_reference_investigation.md` |
| Revision | Investigation 0.1 — 2026-10-27 |
| Repository | `Gregovate/MSB-Music-Sequence-Catalog` |
| Branch | `docs/2026-show-pc-migration` |
| Status | Read-only sample finding; not a parser acceptance test |
| Operating authority | [2026 Show PC migration README](README.md) |

## Source inspected

The operator uploaded an **already copied** file named `2025 Greg Frosty The Snowman.loredit` (20,182,738 bytes). File bytes were parsed read-only using Python's lxml XML parser. No XML, audio, historical archive, or Show PC files were modified. The upload filename does not prove its on-disk location within a Final folder; the operator has separately confirmed that every verified season-specific Final sequence was played in that show's year.

### Confirmed XML fields in this sample

| Location | Attribute | Actual observed value / meaning |
|---|---|---|
| Root `<sequence>` | `saveFileVersion` | `15` |
| Root `<sequence>` | `AppVersion` | `6.4.0.10` |
| Root `<sequence>` | `musicTitle` | `Frosty the Snowman` |
| Root `<sequence>` | `musicArtist` | `Jimmy Durante` |
| Root `<sequence>` | `musicAlbum` | Santa Claus Is Coming to Town: 30 Essential Christmas Songs by Perry Como, Harry Belafonte, Jimmy Durante, And More |
| Root `<sequence>` | `musicFilename` | `Frosty The Snowman-Jimmy Durante-SN.mp3` |
| Root `<sequence>` | `totalCentiseconds` | `15300` (153 seconds) |
| Root `<sequence>` | `author` | `Light-O-Rama` — generic metadata, **not** verification that Greg wrote the sequence |
| Root `<sequence>` | `createdAt` | `9/27/2022 10:34 AM` — source creation date, **not** the 2025 played year |
| `<PreviewClass>` | `Name` | `2025 Master Musical Preview RGB Plus 25-11-14` |
| `<PreviewClass>` | `Revision` | `54` |
| `<PreviewClass>` | `BackgroundFile` | `C:\LOR\Sequences\Images\Preview Design Backgrounds\25-11-13 cc Backgroung.jpg` |

The XML parsed successfully. The root-level `musicFilename` contains **only a basename** and no `C:\LOR\Audio` or G: prefix. Thus *this specific sequence's* media reference can be inventoried directly from the root start tag. Do not assume every LOR generation/format has the same field, or that an external folder such as `C:\LOR-Audio` will be resolved automatically. A read-only LOR-version-specific reference-resolution test remains required before changing local paths.

The sample has an empty `<Subsequences>` container. It also contains absolute **non-audio preview artwork** references: four occurrences to one `C:\Users\greg\Downloads` JPEG, six occurrences across two `G:\Shared drives\Display Folders` JPG/PNG paths. These are potentially nonportable for preview editing on other PCs and should be reviewed separately from the music migration. Presence of preview artwork paths does **not** prove show playback depends on access to G:.

## Recorded physical audio candidates

The requested exact filename appears **five** times in uploaded `MSB_Audio_Metadata_20261027_142222.csv`, in:

- `2023\LOR\Audio`
- `2024\LOR\Audio`
- `2025\LOR\Audio`
- `LOR_Source_Files\Audio`
- `LOR_Source_Files\Purchased LOR RGB Plus\2024_Jingle all the way\Audio`

All five have recorded length **2,513,143 bytes**, but content hashes were not measured. **Candidate duplicates only**, not proven identical. The inventory also lists `Frosty The Snowman-Jimmy Durante-SN-1 db.mp3` at **2,513,059 bytes**; it is a *different filename* from the file referenced by this sample and must not be silently substituted. `-SN` has not been decoded into a verified processing method.

## Parser design and first acceptance gate

**Propose a read-only first-pass inventory** for all `.loredit` files in the *already copied* 2025 Final musical set:

1. Open each source with a forward-only XML reader, prohibit DTD/external entity resolution, and extract the root `<sequence>` attributes: `musicFilename`, title, artist, album, app/version, duration and source XML id.
2. Record exact sequence filepath and basename independently of the music filename. Keep any programmer label (e.g. Greg, Adam) as a *candidate attribution*, not song identity; allow two separate sequences for one song.
3. Report empty/missing media references, parser errors and any XML variants explicitly. Never normalize or rewrite sequence source, never auto-repoint to a different MP3.
4. Match each exact media filename to all known physical occurrences and compare recorded size; separately flag possible raw/normalized derivatives, year-prefixed aliases, and multiple recordings/edits.
5. Add the currently omitted **177 MP3** occurrences from `2021\LOR S5 2021\Audio` before calling the source index complete.
6. Review and accept an audio selection/dependency manifest. Full XML/content hash or player validation is a later separate stage; a root-only extraction is **not** an exhaustive external-media dependency inventory.

This first pass should produce a CSV on the Windows user's local TEMP directory outside all `C:\LOR` and G: source trees, with no source modifications and no MP3 reads/hashes. For the active 2026 workflow, the operator reports that 2025 Final musical and background sequences are already on the Show PC, but no music has intentionally been transferred. **No sync, file copy, rename, deletion, database migration or source promotion is authorized by this investigation.**
