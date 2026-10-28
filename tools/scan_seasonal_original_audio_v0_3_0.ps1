# Filename: tools/scan_seasonal_original_audio_v0_3_0.ps1
# MSB Seasonal Audio Catalog Scanner V0.3.0 — READ ONLY ON G:
# Directory-level durable checkpoints, resume, progress, and partial reports.
# No source audio copying, hashing, renaming, rewriting, or synchronization.
#Requires -Version 5.1

[CmdletBinding()]
param(
    [ValidateSet('Scan','Report')][string]$Mode='Scan',
    [string]$SeasonalRoot='G:\Shared drives\Seasonal Files',
    [string]$SessionDirectory='',
    [ValidateRange(0,100000000)][int]$MaxNewDirectories=0,
    [ValidateRange(1,10000)][int]$ProgressEvery=25
)
Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'
$version='MSB Seasonal Audio Catalog Scanner V0.3.0'
if (-not $SessionDirectory) {
    $SessionDirectory=Join-Path $env:LOCALAPPDATA 'MSB\SeasonalAudioCatalogScanV0_3_0'
}
$root=[IO.Path]::GetFullPath($SeasonalRoot).TrimEnd('\')
$session=[IO.Path]::GetFullPath($SessionDirectory).TrimEnd('\')
$cmp=[StringComparison]::OrdinalIgnoreCase
if ($session.Equals($root,$cmp) -or $session.StartsWith($root+'\',$cmp)) {
    throw 'HOLD: Checkpoints and reports must not be inside Seasonal Files.'
}
$master=Join-Path $root 'LOR-Audio'
$stateDir=Join-Path $session 'CompletedDirectories'
$marker=Join-Path $session 'session.json'
$audioExt=@('.mp3','.wav','.flac','.m4a','.aac','.wma','.aif','.aiff','.ogg','.opus')
$sidecars=@('.cue','.m3u','.m3u8','.jpg','.jpeg','.png','.log','.nfo')

function Relative([string]$path) {
    if ($path.Equals($root,$cmp)) { return '.' }
    if (-not $path.StartsWith($root+'\',$cmp)) {
        throw "HOLD: Path outside Seasonal Files: $path"
    }
    return $path.Substring($root.Length+1)
}
function StatePath([string]$rel) {
    $sha=[Security.Cryptography.SHA256]::Create()
    try {
        $bytes=[Text.Encoding]::UTF8.GetBytes($rel.ToLowerInvariant())
        $id=[BitConverter]::ToString($sha.ComputeHash($bytes)).Replace('-','').ToLowerInvariant()
        return Join-Path $stateDir ($id+'.json')
    } finally { $sha.Dispose() }
}
function Enqueue([string]$rel) {
    $absolute=if ($rel -eq '.') {$root} else {Join-Path $root $rel}
    if ($absolute.Equals($master,$cmp) -or $absolute.StartsWith($master+'\',$cmp)) {return}
    if ($seen.Add($rel)) {$queue.Enqueue($rel)}
}
function Classify([string]$rel,[string]$filename) {
    $family='OTHER_SEASONAL'; $tail=''
    if ($rel -match '(?i)^LOR_Source_Files\\PurchasedMusic\\(.+)$') {
        $family='PURCHASED_MUSIC'; $tail=$Matches[1]
    } elseif ($rel -match '(?i)^LOR_Source_Files\\Audio\\(.+)$') {
        $family='SOURCE_AUDIO_COLLECTION'; $tail=$Matches[1]
    } elseif ($rel -match '(?i)^LOR_Source_Files\\Purchased LOR RGB Plus\\') {
        $family='PURCHASED_LOR_SEQUENCE_BUNDLE'
    } elseif ($rel -match '(?i)^LOR_Source_Files\\Normalized Audio Albums\\') {
        $family='NORMALIZED_SOURCE_ALBUM'
    } elseif ($rel -match '(?i)^\d{4}\\(?:LOR\\Audio|LOR S5 2021\\Audio)\\') {
        $family='ANNUAL_LOR_AUDIO'
    }
    $role='UNCLASSIFIED_REVIEW'
    $reason='Unprocessed original status unknown'
    $proposed='';$album=''
    if ($rel -match '(?i)(normalized|normalised|norm[ _-]*-?1\s*db|-1\s*db)') {
        $role='NORMALIZED_SHOW_REVIEW'
        $reason='Normalized indicator: Show-Audio review only, NEVER Originals'
    } elseif ($filename -match '(?i)(cropped|pitch[ _-]*shift|mastered|128\s*cbr|192\s*cbr|320\s*cbr)') {
        $role='EDITED_SHOW_REVIEW'
        $reason='Possible processed show edit, NOT a proven original'
    } elseif ($family -eq 'PURCHASED_LOR_SEQUENCE_BUNDLE') {
        $role='BUNDLED_AUDIO_REVIEW'
        $reason='Purchased LOR sequence package; bundled music provenance unknown'
    } elseif ($family -eq 'PURCHASED_MUSIC' -or $family -eq 'SOURCE_AUDIO_COLLECTION') {
        if ($tail.Contains('\')) {
            $role='POSSIBLE_ORIGINAL_ALBUM_REVIEW'
            $album=Split-Path -Path $tail -Parent
            $proposed=Join-Path (Join-Path $master 'Originals\Albums') $tail
            $reason='Preserve source album/collection path; originality not proven'
        } else {
            $role='POSSIBLE_ORIGINAL_SINGLE_REVIEW'
            $proposed=Join-Path (Join-Path $master 'Originals\Singles') $filename
            $reason='Loose candidate; verify source original before selection'
        }
    } elseif ($family -eq 'ANNUAL_LOR_AUDIO') {
        $role='ANNUAL_AUDIO_REVIEW'
        $reason='Could be source original, show rendition or duplicate'
    }
    return [pscustomobject]@{
        SourceFamily=$family;Classification=$role;Reason=$reason;
        AlbumOrCollectionFolder=$album;ProposedOriginalPath=$proposed
    }
}
function ExportIfAny([string]$file,[object[]]$rows) {
    if ($rows.Count -gt 0) {
        $rows | Export-Csv -LiteralPath $file -Encoding UTF8 -NoTypeInformation
    }
}

Write-Host "TOOL: $version"
Write-Host "MODE: $Mode"
Write-Host "SOURCE: $root"
Write-Host "CHECKPOINTS: $session"
Write-Host 'G: READ ONLY. No contents hashed, copied, moved, deleted or modified.'
if ($Mode -eq 'Scan' -and -not (Test-Path -LiteralPath $root -PathType Container)) {
    throw "HOLD: Seasonal Files root not accessible: $root"
}
if (Test-Path -LiteralPath $marker -PathType Leaf) {
    $metadata=Get-Content -LiteralPath $marker -Raw | ConvertFrom-Json
    if ($metadata.Version -ne $version -or -not $metadata.Root.Equals($root,$cmp)) {
        throw 'HOLD: Checkpoint source/version mismatch; use a separate local SessionDirectory.'
    }
} else {
    if ($Mode -eq 'Report') { throw 'HOLD: No existing scan session.' }
    New-Item -Path $stateDir -ItemType Directory -Force | Out-Null
    [pscustomobject]@{Version=$version;Root=$root;CreatedUTC=[DateTime]::UtcNow.ToString('o')} |
        ConvertTo-Json | Set-Content -LiteralPath $marker -Encoding UTF8
}
if (-not (Test-Path -LiteralPath $stateDir -PathType Container)) {
    throw 'HOLD: CompletedDirectories checkpoint directory missing.'
}

$queue=New-Object 'System.Collections.Generic.Queue[string]'
$seen=New-Object 'System.Collections.Generic.HashSet[string]' ([StringComparer]::OrdinalIgnoreCase)
Enqueue '.'
$newCount=0;$oldCount=0;$completedCount=0;$audioCount=0
$entryCount=0;$sidecarCount=0;$linkCount=0
$scanStart=Get-Date
while ($queue.Count -gt 0) {
    $rel=$queue.Dequeue()
    $checkpoint=StatePath $rel
    if (Test-Path -LiteralPath $checkpoint -PathType Leaf) {
        $state=Get-Content -LiteralPath $checkpoint -Raw | ConvertFrom-Json
        if ($state.Directory -ne $rel) {throw "HOLD: Wrong checkpoint directory: $checkpoint"}
        $oldCount++
    } else {
        if ($Mode -eq 'Report' -or
            ($MaxNewDirectories -gt 0 -and $newCount -ge $MaxNewDirectories)) {
            continue
        }
        $dir=if ($rel -eq '.') {$root} else {Join-Path $root $rel}
        $children=New-Object 'System.Collections.Generic.List[string]'
        $audio=New-Object 'System.Collections.Generic.List[object]'
        $entries=0;$side=0;$links=0
        try {
            # Stream ONE directory at a time. Never pre-enumerate the whole tree.
            $directory=New-Object System.IO.DirectoryInfo($dir)
            foreach ($entry in $directory.EnumerateFileSystemInfos()) {
                $entries++
                if (($entries % 5000) -eq 0) {
                    Write-Host "IN DIRECTORY: $rel : $entries entries"
                }
                $path=$entry.FullName
                $itemRel=Relative $path
                $isDir=($entry.Attributes -band [IO.FileAttributes]::Directory) -ne 0
                $isLink=($entry.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0
                if ($isDir) {
                    if ($isLink) {$links++;continue}
                    if ($path.Equals($master,$cmp) -or $path.StartsWith($master+'\',$cmp)) {continue}
                    $children.Add($itemRel)
                    continue
                }
                $extension=[IO.Path]::GetExtension($entry.Name).ToLowerInvariant()
                if ($audioExt -notcontains $extension) {
                    if ($sidecars -contains $extension) {$side++}
                    continue
                }
                $classification=Classify $itemRel $entry.Name
                $audio.Add([pscustomobject]@{
                    SourcePath=$path;SeasonalRelativePath=$itemRel;SourceFolder=$rel;
                    FileName=$entry.Name;Extension=$extension;SizeBytes=[long]$entry.Length;
                    ModifiedUTC=$entry.LastWriteTimeUtc.ToString('o');
                    SourceFamily=$classification.SourceFamily;
                    Classification=$classification.Classification;Reason=$classification.Reason;
                    AlbumOrCollectionFolder=$classification.AlbumOrCollectionFolder;
                    ProposedOriginalPath=$classification.ProposedOriginalPath;
                    Decision='REVIEW_REQUIRED';SHA256=''
                })
            }
        } catch {
            Write-Host "HOLD: Directory failed: $dir"
            Write-Host $_.Exception.Message
            throw 'HOLD: Completed directory checkpoints remain. Resume after resolving access.'
        }
        $state=[pscustomobject]@{
            Directory=$rel;Children=@($children.ToArray());Audio=@($audio.ToArray());
            Entries=$entries;Sidecars=$side;SkippedDirectoryLinks=$links;
            CompletedUTC=[DateTime]::UtcNow.ToString('o')
        }
        # Commit one complete directory atomically to the LOCAL session. On
        # interruption during enumeration, nothing is committed for that folder.
        $temp=Join-Path $stateDir ('.pending-'+[guid]::NewGuid().ToString('N')+'.tmp')
        try {
            $state | ConvertTo-Json -Depth 7 -Compress |
                Set-Content -LiteralPath $temp -Encoding UTF8 -ErrorAction Stop
            [IO.File]::Move($temp,$checkpoint)
        } finally {
            if (Test-Path -LiteralPath $temp -PathType Leaf) {
                Remove-Item -LiteralPath $temp -Force
            }
        }
        $newCount++
        if ($newCount -eq 1 -or ($newCount % $ProgressEvery) -eq 0) {
            $seconds=[int]((Get-Date)-$scanStart).TotalSeconds
            Write-Host "CHECKPOINT: new=$newCount old=$oldCount queued=$($queue.Count) audio=$audioCount elapsed=$($seconds)s"
        }
    }
    $completedCount++
    $audioCount+=@($state.Audio).Count
    $entryCount+=[long]$state.Entries
    $sidecarCount+=[long]$state.Sidecars
    $linkCount+=[long]$state.SkippedDirectoryLinks
    foreach ($child in @($state.Children)) { Enqueue ([string]$child) }
    if (($completedCount % $ProgressEvery) -eq 0) {
        Write-Progress -Activity 'MSB Seasonal Audio Catalog' -Status "Directories: $completedCount; Audio: $audioCount; Queued: $($queue.Count)"
    }
}
Write-Progress -Activity 'MSB Seasonal Audio Catalog' -Completed
$pendingCount=$seen.Count-$completedCount
$reportDir=Join-Path $session 'Reports'
New-Item -Path $reportDir -ItemType Directory -Force | Out-Null
$all=New-Object 'System.Collections.Generic.List[object]'
foreach ($file in (Get-ChildItem -LiteralPath $stateDir -Filter '*.json' -File)) {
    $state=Get-Content -LiteralPath $file.FullName -Raw | ConvertFrom-Json
    foreach ($row in @($state.Audio)) { $all.Add($row) }
}
$sorted=@($all | Sort-Object SourcePath)
$originals=@($sorted | Where-Object { -not [string]::IsNullOrWhiteSpace($_.ProposedOriginalPath) })
$show=@($sorted | Where-Object {
    $_.Classification -eq 'NORMALIZED_SHOW_REVIEW' -or
    $_.Classification -eq 'EDITED_SHOW_REVIEW'
})
$counts=@{}
foreach ($g in ($originals | Group-Object ProposedOriginalPath)) {
    $counts[$g.Name.ToLowerInvariant()]=$g.Count
}
$review=@(
    foreach ($item in $originals) {
        [pscustomobject]@{
            SourcePath=$item.SourcePath;ProposedOriginalPath=$item.ProposedOriginalPath;
            FileName=$item.FileName;SizeBytes=$item.SizeBytes;Classification=$item.Classification;
            AlbumOrCollectionFolder=$item.AlbumOrCollectionFolder;
            DestinationCollisions=$counts[$item.ProposedOriginalPath.ToLowerInvariant()];
            Decision='REVIEW_REQUIRED'
        }
    }
)
$albums=@(
    $originals | Where-Object { $_.AlbumOrCollectionFolder } |
        Group-Object AlbumOrCollectionFolder | Sort-Object Name |
        ForEach-Object {
            [pscustomobject]@{
                SourceAlbumOrCollectionFolder=$_.Name;Occurrences=$_.Count;
                Bytes=[long](($_.Group | Measure-Object SizeBytes -Sum).Sum);
                Decision='REVIEW_REQUIRED'
            }
        }
)
$stamp=Get-Date -Format 'yyyyMMdd_HHmmss'
$inventory=Join-Path $reportDir "MSB_All_Seasonal_Audio_$stamp.csv"
$originalFile=Join-Path $reportDir "MSB_Original_Candidates_$stamp.csv"
$showFile=Join-Path $reportDir "MSB_Show_Candidates_$stamp.csv"
$albumFile=Join-Path $reportDir "MSB_Album_Folders_$stamp.csv"
$summaryFile=Join-Path $reportDir "MSB_Scan_Summary_$stamp.txt"
ExportIfAny $inventory $sorted
ExportIfAny $originalFile $review
ExportIfAny $showFile $show
ExportIfAny $albumFile $albums
@(
    "Tool=$version";"Mode=$Mode";"SourceRoot=$root";"Session=$session";
    "NewDirectoriesCompleted=$newCount";"ResumedDirectories=$oldCount";
    "TotalDirectoriesCompleted=$completedCount";"KnownPendingDirectories=$pendingCount";
    "AudioOccurrences=$($sorted.Count)";"AllFileSystemEntriesVisited=$entryCount";
    "AlbumSidecarCandidates=$sidecarCount";"SkippedDirectorySymlinks=$linkCount";
    "OriginalCandidates=$($review.Count)";"ShowNormalizedOrEditedCandidates=$($show.Count)";
    "CoverageComplete=$($pendingCount -eq 0)";
    "NoAudioChanged=True";"SourceHashesComputed=False";
    "Inventory=$inventory";"OriginalsReview=$originalFile";
    "ShowReview=$showFile";"AlbumReview=$albumFile"
) | Set-Content -LiteralPath $summaryFile -Encoding UTF8
Write-Host "SUMMARY: $summaryFile"
Write-Host "REPORTS: $reportDir"
Write-Host "AUDIO: $($sorted.Count); COMPLETED DIRECTORIES: $completedCount; PENDING: $pendingCount"
if ($pendingCount -gt 0) {
    Write-Host 'PARTIAL: Resume -Mode Scan; or run -Mode Report for saved results only.'
} elseif ($linkCount -gt 0) {
    Write-Host 'SCAN COMPLETE WITH REVIEW: directory links skipped to avoid recursion loops.'
} else {
    Write-Host 'SCAN COMPLETE: No source file changes; no audio copied.'
}
