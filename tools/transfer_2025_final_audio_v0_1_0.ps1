# Filename: tools/transfer_2025_final_audio_v0_1_0.ps1
# Version: MSB Audio Selective Transfer V0.1.0
# Owner: MSB Music & Sequence Catalog
# Purpose: Transfer only the 24 MP3s named by the validated 2025 Final
#          sequence root-attribute inventory to the Show PC with NO OVERWRITE.
# Modes: Preview (read-only; default), Copy (approved one-time mutation).
# Sources: 2025 Seasonal Files archive, unchanged.
# Destination: C:\LOR\Audio, pre-existing folder.
# Safety: stop on unexpected files, sizes, collisions or hash mismatch.
# No changes to sequences, previews, archives, production database or sync.
[CmdletBinding()]
param(
    [ValidateSet('Preview','Copy')]
    [string] $Mode = 'Preview',
    [string] $InventoryPath = (Join-Path $env:TEMP 'MSB_2025_Final_Audio_20261027_152125.csv')
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$sourceDir = 'G:\Shared drives\Seasonal Files\2025\LOR\Audio'
$destDir = 'C:\LOR\Audio'
$expectedCount = 24
$expectedBytes = [long]84827578
$toolVersion = 'MSB Audio Selective Transfer V0.1.0'

Write-Host "TOOL: $toolVersion"
Write-Host "MODE: $Mode"
Write-Host "INVENTORY: $InventoryPath"

if (-not (Test-Path -LiteralPath $InventoryPath -PathType Leaf)) {
    throw "HOLD: Source sequence inventory not found: $InventoryPath"
}
if (-not (Test-Path -LiteralPath $sourceDir -PathType Container)) {
    throw "HOLD: Source directory not found: $sourceDir"
}
if (-not (Test-Path -LiteralPath $destDir -PathType Container)) {
    throw "HOLD: Destination directory not found: $destDir"
}

$rows = @(Import-Csv -LiteralPath $InventoryPath)
$selected = @($rows | Where-Object {
    $_.Status -eq 'OK' -and -not [string]::IsNullOrWhiteSpace($_.AudioFile)
})
$names = @($selected | ForEach-Object { $_.AudioFile } | Sort-Object -Unique)

if ($names.Count -ne $expectedCount) {
    throw "HOLD: Expected exactly $expectedCount distinct MP3 names, found $($names.Count)"
}
if ($names.Count -eq 0) { throw 'HOLD: No MP3s selected' }

$plan = New-Object 'System.Collections.Generic.List[object]'
foreach ($name in $names) {
    # Do not alter a sequence's stored filename to make it appear to match.
    if ([string]::IsNullOrWhiteSpace($name) -or
        $name -ne $name.Trim() -or
        $name -match '[\\/:*?"<>|]' -or
        $name -notmatch '(?i)\.mp3$' -or
        $name -eq '.' -or $name -eq '..') {
        throw "HOLD: Invalid unmodified filename in inventory: [$name]"
    }

    $src = Join-Path $sourceDir $name
    $dst = Join-Path $destDir $name
    if (-not (Test-Path -LiteralPath $src -PathType Leaf)) {
        throw "HOLD: Missing MP3 source: $src"
    }
    if (Test-Path -LiteralPath $dst) {
        throw "HOLD: Destination exists (NO OVERWRITE): $dst"
    }
    $srcInfo = Get-Item -LiteralPath $src
    if ($srcInfo.Length -le 0) {
        throw "HOLD: Empty source file: $src"
    }
    $plan.Add([pscustomobject]@{
        Filename = $name
        Source = $src
        Destination = $dst
        Bytes = [long]$srcInfo.Length
        ModifiedUTC = $srcInfo.LastWriteTimeUtc.ToString('o')
    })
}

$totalBytes = [long]0
foreach ($item in $plan) { $totalBytes += [long]$item.Bytes }
if ($totalBytes -ne $expectedBytes) {
    throw "HOLD: Source size total changed: expected $expectedBytes, found $totalBytes"
}

Write-Host "PREFLIGHT PASS: $($plan.Count) sources, $totalBytes bytes, zero destination conflicts."
if ($Mode -eq 'Preview') {
    $plan | Select-Object Filename, Bytes, Source, Destination |
        Format-Table -Wrap -AutoSize
    Write-Host 'PREVIEW ONLY: NO AUDIO FILES COPIED.'
    return
}

# Copy mode: explicitly approved one-time 2025 Final audio subset only.
# All preflight checks above run again immediately before copying.
$completed = New-Object 'System.Collections.Generic.List[object]'
$failure = $null
foreach ($item in $plan) {
    $part = Join-Path $destDir ('.msb-audio-transfer-' + [guid]::NewGuid().ToString('N') + '.part')
    $readStream = $null
    $writeStream = $null
    try {
        # Check again in case another process created the destination.
        if (Test-Path -LiteralPath $item.Destination) {
            throw "Destination appeared during copy: $($item.Destination)"
        }
        $sourceNow = Get-Item -LiteralPath $item.Source
        if ($sourceNow.Length -ne $item.Bytes -or
            $sourceNow.LastWriteTimeUtc.ToString('o') -ne $item.ModifiedUTC) {
            throw "Source metadata changed during run: $($item.Source)"
        }

        # Stage under a unique name. CreateNew makes overwrite impossible.
        $readStream = [System.IO.File]::Open(
            $item.Source,
            [System.IO.FileMode]::Open,
            [System.IO.FileAccess]::Read,
            [System.IO.FileShare]::Read
        )
        $writeStream = [System.IO.File]::Open(
            $part,
            [System.IO.FileMode]::CreateNew,
            [System.IO.FileAccess]::Write,
            [System.IO.FileShare]::None
        )
        $readStream.CopyTo($writeStream)
        $writeStream.Flush()
        $writeStream.Dispose()
        $writeStream = $null
        $readStream.Dispose()
        $readStream = $null

        $srcHash = (Get-FileHash -LiteralPath $item.Source -Algorithm SHA256).Hash
        $partHash = (Get-FileHash -LiteralPath $part -Algorithm SHA256).Hash
        if ($srcHash -ne $partHash) {
            throw "SHA-256 mismatch before final filename: $($item.Filename)"
        }

        # File.Move without overwrite fails if the destination now exists.
        [System.IO.File]::Move($part, $item.Destination)
        $dstHash = (Get-FileHash -LiteralPath $item.Destination -Algorithm SHA256).Hash
        if ($dstHash -ne $srcHash) {
            throw "SHA-256 mismatch after final filename: $($item.Filename)"
        }
        $completed.Add([pscustomobject]@{
            Filename = $item.Filename
            Source = $item.Source
            Destination = $item.Destination
            Bytes = $item.Bytes
            SHA256 = $dstHash
            Status = 'VERIFIED'
        })
        Write-Host "VERIFIED: $($item.Filename)"
    }
    catch {
        $failure = $_
        Write-Warning "HOLD: $($item.Filename): $($_.Exception.Message)"
        break
    }
    finally {
        if ($null -ne $readStream) { $readStream.Dispose() }
        if ($null -ne $writeStream) { $writeStream.Dispose() }
        # Remove ONLY this run's owned staging file, never a final MP3.
        if (Test-Path -LiteralPath $part -PathType Leaf) {
            Remove-Item -LiteralPath $part -Force
        }
    }
}

$stamp = Get-Date -Format 'yyyyMMdd_HHmmss'
$reportPath = Join-Path $env:TEMP "MSB_2025_Audio_Transfer_V0.1.0_$stamp.csv"
$completed | Export-Csv -LiteralPath $reportPath -NoTypeInformation -Encoding UTF8

Write-Host "VERIFICATION REPORT: $reportPath"
Write-Host "VERIFIED FILES: $($completed.Count)/$expectedCount"
if ($null -ne $failure -or $completed.Count -ne $expectedCount) {
    # Keep correctly verified prior files; never retry blindly or overwrite.
    throw 'HOLD: Copy incomplete. Do not rerun Copy. Review report and failed item before recovery.'
}
Write-Host "PASS: $expectedCount MP3s transferred without overwrite and verified by SHA-256."
