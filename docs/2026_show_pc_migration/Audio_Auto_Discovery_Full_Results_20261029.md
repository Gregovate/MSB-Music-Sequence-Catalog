# MSB Audio Auto Discovery — Complete Full-File Hash Analysis

| Control | Value |
|---|---|
| Document status | Full-run evidence, **read-only** |
| Report stamp | \`20261029_174327\` |
| Tool | MSB Audio Auto Discovery V0.1.0 candidate |
| Tool source SHA-256 | \`53adbcd35e3530837b40e18796c6e6b1fc78f6a77ee9c05a1b188690d300a822\` |
| Source inventory | \`MSB_All_Seasonal_Audio_20261028_174014.csv\`, SHA-256 \`e20454084a3531e1e3ae5ce12b62bb9b1d3b8e5fe694c6f67ccaf43cc348e5b3\` |
| Focused scope | 2,838 source audio occurrences (2,479 MP3, 351 WAV, 8 WMA), excluding Vegas SFX, AcousticMirror impulse assets and generated LOR CanonicalAudio |
| Source reports | Seven operator-uploaded CSV/TXT files, same timestamp; duplicate \`(1)\` uploads represent same report run |
| External review workbook | \`MSB_Audio_Full_Discovery_Analysis_20261029.xlsx\`, generated from full uploaded reports |
| Physical mutation | **NONE** — no copies, rewrites, deletion, Audacity processing, sequence changes, database loads or FreeFileSync |

## Results confirmed by reading full report rows

| Metric | Result | Interpretation |
|---|---:|---|
| Planned | 2,838 | All rows of focused CSV selection |
| Completed, \`HASH_OK\` | **2,838** | All hash values available |
| Remaining or read failures | **0** | No resumption needed |
| Distinct SHA-256 values | **817** | File-content identities, **not** independently verified songs or artist recordings |
| Groups with multiple same-SHA occurrences | **405** | Confirmed byte-identical sets |
| Occurrences participating in those groups | **2,426** | Includes the retained reference occurrence for every group |
| Additional redundant occurrences | **2,021** | 2,426 minus 405, or 2,838 minus 817 |
| Hash identities occurring once | **412** | 817 minus 405 |
| Total bytes represented by occurrence inventory | **15.687 GiB** | Multiple historical copies included |
| Total bytes retaining one occurrence per SHA | **5.341 GiB** | Mathematical deduplicated content volume only |
| Byte-identical extra storage across original occurrences | **10.346 GiB** | **Not** permission to delete historical archives |
| Same-size, different-hash report rows | **1,139** | Rows with one or more size matches of different bytes, **not** 1,139 distinct file pairs |
| Tagged artist/album combinations | **139** | Tags may represent tracks on compilations; not 139 verified physical albums |
| Same tagged artist+title, different hash groups | **81** | Variants require exact music duration/processing analysis |
| MP3 occurrences lacking at least artist or title | **599** | **Metadata gaps**, not scan errors |
| Actual file read/hash errors | **0** | All statuses \`HASH_OK\` |

The script's \`TagOrReadExceptions=599\` for this **completed** run is therefore entirely due to MP3 title/artist gaps. It does not mean unreadable files. The 359 non-MP3 sources were intentionally outside this tool's ID3 parser and are separately retained by SHA-256.

## Important cases and exceptions

- **Trans-Siberian Orchestra, Christmas Canon:** 124 occurrences sharing the same artist/title tag, but **23 distinct full-file hashes**. Do not infer 23 distinct performances or 23 legitimate audio timings; some may be re-encodes, trims or Audacity-normalized outputs. Critical existing LOR media/timing references must be protected.
- **Carpenters, Sleigh Ride (Album Version):** 56 tagged occurrences with **11 distinct hashes**.
- **David Foster/Keyboard Orchestra, Carol of the Bells [Instrumental]:** 69 tagged occurrences with **11 distinct hashes**.
- **61** of the 405 exact duplicate groups use **multiple filenames** for byte-identical content. Retain every legacy filename alias and full source path, especially those referenced by historical \`.loredit\` files.
- **389** exact duplicate hash groups span more than one of the scanner's broad source-family labels. A filename/folder is source-provenance evidence, not a separate music identity.
- **Two content hashes** mix *edited show-audio hints* with *possible original source hints* at different paths: copies of Carpenters' \`Sleigh Ride ... Edited/Cropped\` and Mannheim Steamroller's \`Stille Nacht ... edited/cropped\`. The same bytes cannot be classified differently solely because they are in an Original-looking folder. Mark both for **SOURCE_ROLE_CONFLICT** review; do not select as raw originals without evidence.

## Accepted entity normalization (conceptual only)

1. **Content identity:** one SHA-256-indexed content record for each of the **817** distinct file bytes, with every recorded physical file occurrence retained.
2. **Physical occurrence:** **2,838** source paths in the focused pass; no archive deletion. A single content identity may have distinct historical names and source locations.
3. **Recording/audio edit/rendition:** a higher-level relationship that **cannot** be inferred from full-file hash or artist/title tag alone. 81 tagged artist/title groups and role-conflict exceptions need technical audio-duration/edit and provenance evidence.
4. **Album membership:** album artist, album title, track, disc, and release edition remain distinct from source-folder wrappers such as \`Licensed Songs\`; the 139 artist/album tag groups cannot be treated as 139 verified releases.
5. **Ownership and actual show use:** personal Christmas albums, LOR purchased-sequence package, original source rights, show start/end announcements, historical singing-face vocal stems and available-but-unused songs remain separate dimensions. Only verified historical Final evidence establishes actual show-use years.

## Recommended next read-only engineering pass

No more broad file-hash scan is needed. Use the completed SHA-256 index to build a **canonical content-identity mapping** (817 identities linked to 2,838 unchanged source paths). Next analyze **audio duration, technical format, bitrate, loudness/normalization characteristics and crop/intro-outro differences** for selected distinct hash variants—especially same artist/title and proposed Originals/Show-Audio conflicts—before any copy decision. Music-tag metadata and file hashes alone are not proof of source-original status or compatible LOR timing. This new audio-analysis tool/procedure would require a new governed, clearly read-only release with checkpointing and bounded test before inspecting large numbers of files.

Then produce an explicit no-overwrite reviewed master selection proposal, preserving album provenance and distinct show renditions. Do not run FreeFileSync, rewrite 2025 Final or 2026 Scratch references, create master folders, or delete the old duplicated copies.

## Release/source constraint

The Python V0.1.0 candidate was supplied to the operator as a conversation attachment and is **not yet committed as the exact-byte source in the owning GitHub repository**. The full run is valid user-provided hash/metadata evidence but should not be described as a formally released repository-pinned tool. Before reusing code for the next stage or building any physical copier, publish and compare exact candidate source bytes, record release approval, and retain this completed-run evidence.
