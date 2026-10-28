# Filename: tools/scan_seasonal_original_audio_v0_2_0.ps1
# Version: MSB Seasonal Audio Catalog Scan V0.2.0
# Purpose: Inventory ALL audio under Seasonal Files, identify original and
#          album candidates, and propose destinations without changing G:.
#          Normalized files are SHOW AUDIO candidates, never Originals.
# READ ONLY against G:. Reports are written to the local user's TEMP directory.
# This is NOT an audio copy/rename/sync tool. No hashes or audio re-encoding.
#Requires -Version 5.1

[CmdletBinding()]
param(
    [string] $SeasonalRoot = 'G:\Shared drives\Seasonal Files',
    [string] $ReportDirectory = ''
)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$tool = 'MSB Seasonal Audio Catalog Scan V0.1.0'

if (-not (Test-Path -LiteralPath $SeasonalRoot -PathType Container)) {
    throw "HOLD: Seasonal Files root not found: $SeasonalRoot"
}
$root = (Get-Item -LiteralPath $SeasonalRoot).FullName.TrimEnd('\')
$master = Join-Path $root 'LOR-Audio'
if ([string]::IsNullOrWhiteSpace($ReportDirectory)) {
    $ReportDirectory = Join-Path $env:TEMP (
        'MSB_Original_Audio_Scan_' + (Get-Date -Format 'yyyyMMdd_HHmmss')
    )
}
$reportFull = [System.IO.Path]::GetFullPath($ReportDirectory)
if ($reportFull.Equals($root, [StringComparison]::OrdinalIgnoreCase) -or
    $reportFull.StartsWith($root + '\', [StringComparison]::OrdinalIgnoreCase)) {
    throw 'HOLD: Reports must not be written anywhere under Seasonal Files.'
}
$extensions = @('.mp3', '.wav', '.flac', '.m4a', '.aac',
                '.wma', '.aif', '.aiff', '.ogg', '.opus')
$rows = New-Object 'System.Collections.Generic.List[object]'
$scanned = 0
$excludedMaster = 0

Write-Host "TOOL: $tool"
Write-Host "SOURCE: $root"
Write-Host "PROPOSED MASTER (NOT CREATED): $master"
Write-Host 'MODE: READ-ONLY on Seasonal Files; no copies/hashes/renames'

# Explicit recursion lists regular files from the whole Seasonal Files tree.
# It includes older annual archives and LOR_Source_Files, not just 2025.
$allFiles = Get-ChildItem -LiteralPath $root -Recurse -File -Force -ErrorAction Stop
foreach ($file in $allFiles) {
    $scanned++
    if ($extensions -notcontains $file.Extension.ToLowerInvariant()) { continue }
    $full = $file.FullName
    if ($full.Equals($master, [StringComparison]::OrdinalIgnoreCase) -or
        $full.StartsWith($master + '\', [StringComparison]::OrdinalIgnoreCase)) {
        $excludedMaster++
        continue
    }
    if (-not $full.StartsWith($root + '\', [StringComparison]::OrdinalIgnoreCase)) {
        throw "HOLD: File unexpectedly outside source root: $full"
    }
    $rel = $full.Substring($root.Length + 1)
    $sourceFolder = Split-Path -Path $rel -Parent
    $class = 'REVIEW_UNCLASSIFIED'
    $reason = 'Cannot prove original/processed status from path alone'
    $candidateRelative = ''
    $albumFolder = ''
    $isNormalizedHint = ($rel -match '(?i)(normalized|normalised|norm(?:alized)?[ _-]*-?1\s*d[bB]|-1\s*d[bB])')
    $isOtherEditHint = ($rel -match '(?i)(cropped|pitch[ _-]*shift|mastered|128\s*cbr|192\s*cbr|320\s*cbr)')
    $isProcessedFolder = ($rel -match '(?i)(^|\\)Normalized Audio Albums\\')

    if ($isProcessedFolder -or $isNormalizedHint) {
        $class = 'NORMALIZED_SHOW_COPY_REVIEW'
        $reason = 'Normalized indicator: SHOW-AUDIO candidate only; NEVER an Originals candidate, approval pending'
    }
    elseif ($isOtherEditHint) {
        $class = 'EDITED_SHOW_COPY_REVIEW'
        $reason = 'Crop, pitch shift or encoding/edit hint; NOT eligible for Originals without manual provenance review'
    }
    elseif ($rel -match '(?i)(^|\\)LOR_Source_Files\\Purchased LOR RGB Plus\\') {
        $class = 'PURCHASED_SEQUENCE_AUDIO_REVIEW'
        $reason = 'Bundled RGB Plus audio; determine original versus supplied show rendition'
    }
    elseif ($rel -match '(?i)(^|\\)LOR_Source_Files\\PurchasedMusic\\(.+)$') {
        $tail = $Matches[2]
        if ($tail.Contains('\')) {
            $class = 'ORIGINAL_ALBUM_CANDIDATE'
            $candidateRelative = Join-Path 'Originals\Albums' $tail
            $albumFolder = Split-Path -Path $tail -Parent
            $reason = 'PurchasedMusic tree; keep existing artist/album path, verify original'
        }
        else {
            $class = 'ORIGINAL_SINGLE_CANDIDATE'
            $candidateRelative = Join-Path 'Originals\Singles' $file.Name
            $reason = 'PurchasedMusic root; confirm original recording'
        }
    }
    elseif ($rel -match '(?i)(^|\\)LOR_Source_Files\\Audio\\(.+)$') {
        $tail = $Matches[2]
        if ($tail.Contains('\')) {
            # Some nested directories are albums; others are stock songs,
            # vocals, effect libraries or organized show files. Review all.
            $class = 'POSSIBLE_ALBUM_REVIEW'
            $candidateRelative = Join-Path 'Originals\Albums' $tail
            $albumFolder = Split-Path -Path $tail -Parent
            $reason = 'Source Audio subfolder; album versus other collection unverified'
        }
        else {
            $class = 'POSSIBLE_ORIGINAL_SINGLE_REVIEW'
            $candidateRelative = Join-Path 'Originals\Singles' $file.Name
            $reason = 'Loose source audio; original versus show edit unverified'
        }
    }
    elseif ($rel -match '(?i)^\d{4}\\LOR\\Audio\\') {
        $class = 'ANNUAL_AUDIO_REVIEW'
        $reason = 'Annual archive; may duplicate originals or show renditions'
    }

    $proposed = ''
    if ($candidateRelative) { $proposed = Join-Path $master $candidateRelative }

    $rows.Add([pscustomobject]@{
        SourcePath = $full
        SeasonalRelativePath = $rel
        SourceFolder = $sourceFolder
        FileName = $file.Name
        Extension = $file.Extension.ToLowerInvariant()
        SizeBytes = [long]$file.Length
        ModifiedUTC = $file.LastWriteTimeUtc.ToString('o')
        Classification = $class
        Reason = $reason
        AlbumOrCollectionFolder = $albumFolder
        ProposedOriginalPath = $proposed
        Decision = 'REVIEW_REQUIRED'
        SHA256 = ''
    })
}
if ($rows.Count -eq 0) {
    throw 'HOLD: No audio files found. No reports produced.'
}

$sorted = @($rows | Sort-Object SourcePath)
$candidates = @($sorted | Where-Object { $_.ProposedOriginalPath })
$collisionCounts = @{}
foreach ($g in ($candidates | Group-Object -Property ProposedOriginalPath)) {
    $collisionCounts[$g.Name.ToLowerInvariant()] = $g.Count
}
$proposals = @(
    foreach ($r in $candidates) {
        $key = $r.ProposedOriginalPath.ToLowerInvariant()
        [pscustomobject]@{
            SourcePath = $r.SourcePath
            ProposedOriginalPath = $r.ProposedOriginalPath
            FileName = $r.FileName
            SizeBytes = $r.SizeBytes
            Classification = $r.Classification
            AlbumOrCollectionFolder = $r.AlbumOrCollectionFolder
            ProposedPathCollisionCount = $collisionCounts[$key]
            Decision = 'REVIEW_REQUIRED'
            SHA256 = ''
        }
    }
)
$showCandidates = @($sorted | Where-Object {
    $_.Classification -eq 'NORMALIZED_SHOW_COPY_REVIEW' -or
    $_.Classification -eq 'EDITED_SHOW_COPY_REVIEW'
})
$albums = @(
    $candidates |
      Where-Object { $_.AlbumOrCollectionFolder } |
      Group-Object -Property AlbumOrCollectionFolder |
      Sort-Object Name |
      ForEach-Object {
          [pscustomobject]@{
              ExistingFolderUnderAudioSource = $_.Name
              Occurrences = $_.Count
              Bytes = [long](($_.Group | Measure-Object -Property SizeBytes -Sum).Sum)
              Status = 'ALBUM_OR_COLLECTION_REVIEW'
          }
      }
)
New-Item -ItemType Directory -Path $reportFull -Force -ErrorAction Stop | Out-Null
$stamp = Get-Date -Format 'yyyyMMdd_HHmmss'
$inventoryFile = Join-Path $reportFull "MSB_All_Seasonal_Audio_$stamp.csv"
$candidateFile = Join-Path $reportFull "MSB_Original_Candidates_$stamp.csv"
$albumFile = Join-Path $reportFull "MSB_Album_Folders_$stamp.csv"
$showFile = Join-Path $reportFull "MSB_Processed_Show_Candidates_$stamp.csv"
$summaryFile = Join-Path $reportFull "MSB_Scan_Summary_$stamp.txt"

$sorted | Export-Csv -LiteralPath $inventoryFile -NoTypeInformation -Encoding UTF8
$proposals | Export-Csv -LiteralPath $candidateFile -NoTypeInformation -Encoding UTF8
if ($showCandidates.Count -gt 0) {
    $showCandidates | Export-Csv -LiteralPath $showFile -NoTypeInformation -Encoding UTF8
}
if ($albums.Count -gt 0) {
    $albums | Export-Csv -LiteralPath $albumFile -NoTypeInformation -Encoding UTF8
}
$lines = @(
    "Tool: $tool"
    "Source: $root"
    "Proposed master ONLY: $master"
    "Audio occurrences scanned: $($sorted.Count)"
    "Files visited: $scanned"
    "Existing master audio files excluded: $excludedMaster"
    "Original candidate occurrences requiring review: $($proposals.Count)"
    "Album/collection folder groups: $($albums.Count)"
    "Normalized/edited show candidates EXCLUDED from Originals: $($showCandidates.Count)"
    "No hashes computed. Identical filenames and sizes are NOT proof of duplicates."
    "No master folder created and NO audio files copied or modified."
    "All decisions remain REVIEW_REQUIRED pending classification and deduplication."
    "Inventory: $inventoryFile"
    "Candidates: $candidateFile"
    "Album folders: $albumFile"
    "Processed show-copy candidates: $showFile (only if found)"
)
$lines | Set-Content -LiteralPath $summaryFile -Encoding UTF8
Write-Host "AUDIO OCCURRENCES: $($sorted.Count)"
$sorted | Group-Object Classification | Sort-Object Name |
    Select-Object Name, Count | Format-Table -AutoSize
Write-Host "ORIGINAL CANDIDATES FOR REVIEW: $($proposals.Count)"
Write-Host "ALBUM / COLLECTION FOLDERS: $($albums.Count)"
Write-Host "NORMALIZED/EDITED SHOW CANDIDATES (NOT ORIGINALS): $($showCandidates.Count)"
if ($showCandidates.Count -gt 0) { Write-Host "SHOW REVIEW: $showFile" }
Write-Host "REPORT FOLDER: $reportFull"
Write-Host "INVENTORY: $inventoryFile"
Write-Host "CANDIDATES: $candidateFile"
Write-Host "ALBUMS: $albumFile"
Write-Host 'SCAN PASS: SOURCE READ-ONLY; NO AUDIO COPIED; MASTER NOT CREATED.'
