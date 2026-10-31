# ============================================================================
# Franksoft Client Deployment
# Deployment Report Generator
#
# Script : FSC-CreateDeploymentReport.ps1
# Version: 2.9
# Author : Franksoft
# Date   : 31.10.2026
# Time   : 14:40:00
#
# Purpose:
# Creates a local HTML deployment report from FSC registry timing data,
# Windows Update registry data, WinGet before/after logs, and the FSC master log.
#
# Creates:
# C:\ProgramData\Franksoft\Logs\DeploymentReport.html
#
# Sources:
# HKLM:\SOFTWARE\Franksoft\Setup
# HKLM:\SOFTWARE\Franksoft\WindowsUpdate
# C:\ProgramData\Franksoft\Logs\Franksoft Client.txt
# C:\ProgramData\Franksoft\Logs\WinGet*Before*.csv / .txt
# C:\ProgramData\Franksoft\Logs\WinGet*After*.csv / .txt
#
# Notes:
# - Debug / report only
# - Does not delete or modify deployment files
# - All missing sources are handled gracefully
#
# (c) Franksoft 1997-2026
# ============================================================================

[CmdletBinding()]
param(
    [string]$ReportPath = "C:\ProgramData\Franksoft\Logs\DeploymentReport.html",
    [switch]$OpenReport
)

Set-StrictMode -Version 2.0
$ErrorActionPreference = "Continue"

# ============================================================================
# Paths / Registry
# ============================================================================

$LogRoot        = "C:\ProgramData\Franksoft\Logs"
$FscLogPath     = Join-Path $LogRoot "Franksoft Client.txt"
$RegSetupRoot   = "HKLM:\SOFTWARE\Franksoft\Setup"
$RegWU          = "HKLM:\SOFTWARE\Franksoft\WindowsUpdate"
$BiosSerial     = (Get-CimInstance Win32_BIOS).SerialNumber

$DisplayVersion = (
    Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion"
).DisplayVersion


if (-not (Test-Path $LogRoot)) {
    New-Item -Path $LogRoot -ItemType Directory -Force | Out-Null
}

# ============================================================================
# Helpers
# ============================================================================

function Convert-FSCDate {
    param([string]$Value)

    if ([string]::IsNullOrWhiteSpace($Value)) { return $null }

    $Value = $Value.Trim()
    # CMD DATE can include a weekday prefix; TIME can use a one-digit hour.
    $Value = $Value -replace '^\D+\s+(?=\d{1,2}\.)','' 

    $formats = @(
        "dd.MM.yyyy HH:mm:ss",
        "dd.MM.yyyy H:mm:ss",
        "d.M.yyyy H:mm:ss",
        "dd.MM.yyyy HH:mm",
        "MM/dd/yyyy HH:mm:ss",
        "MM/dd/yyyy HH:mm"
    )

    foreach ($format in $formats) {
        try { return [datetime]::ParseExact($Value, $format, $null) } catch {}
    }

    try { return [datetime]$Value } catch { return $null }
}

function Get-Minutes {
    param(
        [datetime]$Start,
        [datetime]$End
    )

    if (-not $Start -or -not $End) { return $null }

    $m = [math]::Round(($End - $Start).TotalMinutes)
    if ($m -lt 0) { return 0 }
    return [int]$m
}

function Format-Duration {
    param([AllowNull()][object]$Start, [AllowNull()][object]$End)
    if ($null -eq $Start -or $null -eq $End) { return "-" }
    try {
        $span = ([datetime]$End) - ([datetime]$Start)
        if ($span.TotalSeconds -lt 0) { return "-" }
        return "{0:00}:{1:00}:{2:00}" -f [math]::Floor($span.TotalHours), $span.Minutes, $span.Seconds
    } catch { return "-" }
}

function HtmlEncode {
    param([object]$Text)
    if ($null -eq $Text) { return "" }
    return [System.Net.WebUtility]::HtmlEncode([string]$Text)
}

function Format-Time {
    param([AllowNull()][object]$Date)
    if ($null -eq $Date -or [string]::IsNullOrWhiteSpace([string]$Date)) { return "" }
    try { return ([datetime]$Date).ToString("HH:mm:ss") } catch { return "" }
}

function Format-DateTime {
    param([AllowNull()][object]$Date)
    if ($null -eq $Date -or [string]::IsNullOrWhiteSpace([string]$Date)) { return "" }
    try { return ([datetime]$Date).ToString("dd.MM.yyyy HH:mm:ss") } catch { return "" }
}

function Get-RegistryValueByNames {
    param(
        [object]$Item,
        [string[]]$Names
    )

    foreach ($name in $Names) {
        try {
            $v = $Item.$name
            if ($null -ne $v -and -not [string]::IsNullOrWhiteSpace([string]$v)) {
                return [string]$v
            }
        } catch {}
    }
    return ""
}

function Get-LogPathFromItem {
    param([object]$Item)

    return Get-RegistryValueByNames -Item $Item -Names @(
        "Log",
        "LogFile",
        "Log File",
        "LogPath",
        "Log Path",
        "FSC Log",
        "Script Log"
    )
}

function Get-PhaseFromItem {
    param([object]$Item)

    return Get-RegistryValueByNames -Item $Item -Names @(
        "FSC Phase",
        "FSC Phase ID",
        "Phase",
        "Phase ID"
    )
}

function Get-ScriptPathFromItem {
    param([object]$Item)

    return Get-RegistryValueByNames -Item $Item -Names @(
        "Script Path",
        "ScriptPath",
        "Path"
    )
}

# ============================================================================
# Device / OS Info
# ============================================================================

$ComputerName = $env:COMPUTERNAME
$Model = ""
$Manufacturer = ""
$RamGB = ""
$WindowsCaption = ""
$WindowsBuild = ""
$WindowsVersion = ""
$Architecture = ""
$InstallDate = ""

try {
    $cs = Get-CimInstance Win32_ComputerSystem
    $Model = ($cs.Model -replace ' inch Notebook AI PC',' Zoll')
    $Manufacturer = $cs.Manufacturer
    $RamGB = [math]::Ceiling($cs.TotalPhysicalMemory / 1GB)
} catch {}

try {
    $os = Get-CimInstance Win32_OperatingSystem
    $WindowsCaption = $os.Caption
    $WindowsBuild = $os.BuildNumber
    $WindowsVersion = $os.Version
    $Architecture = $os.OSArchitecture
    if ($os.InstallDate) { $InstallDate = ([datetime]$os.InstallDate).ToString("dd.MM.yyyy HH:mm:ss") }
} catch {}

# ============================================================================
# Registry Script Timeline
# ============================================================================

$ScriptItems = @()

if (Test-Path $RegSetupRoot) {
    $keys = Get-ChildItem -Path $RegSetupRoot -ErrorAction SilentlyContinue | Sort-Object PSChildName

    foreach ($key in $keys) {
        try {
            $item = Get-ItemProperty -Path $key.PSPath
            $start = Convert-FSCDate $item.Start
            $end   = Convert-FSCDate $item.End

            # PE-LogFile often has phase fields instead of Start/End.
            if (-not $start) {
                $start = Convert-FSCDate (Get-RegistryValueByNames -Item $item -Names @("WindowsSetupStart", "Phase 01/07 windowsPE"))
            }
            if (-not $end) {
                $end = Convert-FSCDate (Get-RegistryValueByNames -Item $item -Names @("Phase 04/07 specialize", "End"))
            }

            $min = Get-Minutes -Start $start -End $end
            $status = if ($end) { "OK" } elseif ($start) { "Started" } else { "Missing" }

            $ScriptItems += [pscustomobject]@{
                Phase      = Get-PhaseFromItem $item
                Script     = $key.PSChildName
                Start      = $start
                End        = $end
                Minutes    = $min
                Status     = $status
                Log        = Get-LogPathFromItem $item
                ScriptPath = Get-ScriptPathFromItem $item
                RegPath    = "HKLM\SOFTWARE\Franksoft\Setup\$($key.PSChildName)"
            }
        } catch {}
    }
}

# ============================================================================
# Deployment Summary Times
# ============================================================================

$WindowsSetupMin = 0
$FSCDeploymentMin = 0
$WindowsUpdateMin = 0
$TotalMin = 0

$WindowsSetupStart = $null
$WindowsSetupEnd = $null
$FSCDeploymentStart = $null
$FSCDeploymentEnd = $null
$WindowsUpdateStart = $null
$WindowsUpdateEnd = $null
$WUStatus = "nicht ausgeführt"
$WULastResult = ""
$WURound = ""
$WUPhase = ""

# Driver installation: exact registry script timestamps (included in deployment total).
$HPDriversStart = $null
$HPDriversEnd = $null
$HPDriversDuration = "nicht erfasst"
$hpDriverItem = @($ScriptItems | Where-Object { $_.Script -eq "Install_HP-Drivers.cmd" } | Select-Object -First 1)
if ($hpDriverItem.Count -gt 0) {
    $HPDriversStart = $hpDriverItem[0].Start
    $HPDriversEnd = $hpDriverItem[0].End
    if ($HPDriversStart -and $HPDriversEnd -and $HPDriversEnd -ge $HPDriversStart) {
        $hpSpan = $HPDriversEnd - $HPDriversStart
        $HPDriversDuration = "{0:00}:{1:00}:{2:00}" -f [math]::Floor($hpSpan.TotalHours), $hpSpan.Minutes, $hpSpan.Seconds
    }
}

# Windows Setup: PE WindowsSetupStart -> SetupComplete Start.
try {
    $pePath = Join-Path $RegSetupRoot "PE-LogFile.cmd"
    $setupCompletePath = Join-Path $RegSetupRoot "SetupComplete.cmd"

    if ((Test-Path $pePath) -and (Test-Path $setupCompletePath)) {
        $pe = Get-ItemProperty -Path $pePath
        $sc = Get-ItemProperty -Path $setupCompletePath

        $WindowsSetupStart = Convert-FSCDate (Get-RegistryValueByNames -Item $pe -Names @("WindowsSetupStart", "Phase 01/07 windowsPE"))
        $WindowsSetupEnd   = Convert-FSCDate $sc.Start

        $tmp = Get-Minutes -Start $WindowsSetupStart -End $WindowsSetupEnd
        if ($null -ne $tmp) { $WindowsSetupMin = $tmp }
    }
} catch {}

# Franksoft Deployment: SetupComplete Start -> last End of post scripts / setup scripts excluding PE and Windows Update.
try {
    $setupCompletePath = Join-Path $RegSetupRoot "SetupComplete.cmd"
    if (Test-Path $setupCompletePath) {
        $sc = Get-ItemProperty -Path $setupCompletePath
        $FSCDeploymentStart = Convert-FSCDate $sc.Start
    }

    $exclude = @("PE-LogFile.cmd", "WinUpdate_FSC.cmd", "WindowsUpdate_FSC.cmd", "WinGetUpdate_FSC.cmd", "Winget_FSC.cmd")
    $ends = @()

    foreach ($row in $ScriptItems) {
        if ($exclude -contains $row.Script) { continue }
        if ($row.End) { $ends += $row.End }
    }

    if ($ends.Count -gt 0) {
        $FSCDeploymentEnd = $ends | Sort-Object | Select-Object -Last 1
    }

    $tmp = Get-Minutes -Start $FSCDeploymentStart -End $FSCDeploymentEnd
    if ($null -ne $tmp) { $FSCDeploymentMin = $tmp }
} catch {}

# Windows Update: tolerate absent legacy values under StrictMode.
function Get-FSCWindowsUpdateData {
    param([object]$Item)
    $phases = @()
    for ($i = 1; $i -le 12; $i++) {
        $phaseName = 'Phase{0:00}' -f $i
        $start = Convert-FSCDate (Get-RegistryValueByNames $Item @("FirstStart$phaseName", "LastStart$phaseName"))
        $end = Convert-FSCDate (Get-RegistryValueByNames $Item @("LastEnd$phaseName"))
        if ($start -or $end) {
            $phases += [pscustomobject]@{Phase=$phaseName;Start=$start;End=$end}
        }
    }
    $start = Convert-FSCDate (Get-RegistryValueByNames $Item @('FirstStart'))
    if (-not $start) {
        $starts = @($phases | Where-Object { $null -ne $_.Start } | ForEach-Object { $_.Start } | Sort-Object)
        if ($starts.Count -gt 0) { $start = $starts[0] }
    }
    $result = Get-RegistryValueByNames $Item @('LastResult')
    $round = Get-RegistryValueByNames $Item @('CurrentRound')
    $phase = Get-RegistryValueByNames $Item @('CurrentPhase')
    $end = Convert-FSCDate (Get-RegistryValueByNames $Item @('DeploymentEnd','FinishTime'))
    # A per-phase timestamp is a final end only for a recorded completion.
    if (-not $end -and ($result -eq 'Success' -or $phase -eq 'Finish')) {
        $end = Convert-FSCDate (Get-RegistryValueByNames $Item @('LastEnd'))
        if (-not $end) {
            $ends = @($phases | Where-Object { $null -ne $_.End } | ForEach-Object { $_.End } | Sort-Object)
            if ($ends.Count -gt 0) { $end = $ends[-1] }
        }
    }
    $status = 'Zeitdaten fehlen'
    if ($result -eq 'Success') { $status = 'erfolgreich abgeschlossen' }
    elseif ($result -match 'Error|Fail') { $status = 'mit Fehler beendet' }
    elseif ($phase -eq 'Finish') { $status = 'beendet; Ergebnis: ' + $result }
    elseif ($start -or $result -or $phase) { $status = 'noch nicht abgeschlossen' }
    return [pscustomobject]@{Start=$start;End=$end;Result=$result;Round=$round;Phase=$phase;Status=$status;Phases=@($phases)}
}
$WUPhaseRows = @()
$WUStatus = 'Registry-Daten fehlen'
try {
    if (Test-Path $RegWU) {
        $wu = Get-ItemProperty -Path $RegWU -ErrorAction Stop
        $wuData = Get-FSCWindowsUpdateData $wu
        $WindowsUpdateStart = $wuData.Start
        $WindowsUpdateEnd = $wuData.End
        $WULastResult = $wuData.Result
        $WURound = $wuData.Round
        $WUPhase = $wuData.Phase
        $WUStatus = $wuData.Status
        $WUPhaseRows = @($wuData.Phases)
        if ($WindowsUpdateStart -and $WindowsUpdateEnd) {
            $tmp = Get-Minutes -Start $WindowsUpdateStart -End $WindowsUpdateEnd
            if ($null -ne $tmp) { $WindowsUpdateMin = $tmp }
        }
    }
} catch { $WUStatus = 'Registry konnte nicht gelesen werden: ' + $_.Exception.Message }

$TotalMin = $WindowsSetupMin + $FSCDeploymentMin + $WindowsUpdateMin

# Exact summary times. Drivers are contained within Franksoft Deployment.
$WindowsSetupDuration = Format-Duration $WindowsSetupStart $WindowsSetupEnd
$FSCDeploymentDuration = Format-Duration $FSCDeploymentStart $FSCDeploymentEnd
$WindowsUpdateDuration = "Zeitdaten fehlen"
$TotalDurationSpan = [timespan]::Zero
foreach ($period in @(
    @{ Start = $WindowsSetupStart; End = $WindowsSetupEnd },
    @{ Start = $FSCDeploymentStart; End = $FSCDeploymentEnd }
)) {
    if ($period.Start -and $period.End -and $period.End -ge $period.Start) {
        $TotalDurationSpan += ($period.End - $period.Start)
    }
}
if ($WindowsUpdateStart -and $WindowsUpdateEnd -and $WindowsUpdateEnd -ge $WindowsUpdateStart) {
    $WindowsUpdateDuration = Format-Duration $WindowsUpdateStart $WindowsUpdateEnd
    $TotalDurationSpan += ($WindowsUpdateEnd - $WindowsUpdateStart)
}
$TotalDuration = "{0:00}:{1:00}:{2:00}" -f [math]::Floor($TotalDurationSpan.TotalHours), $TotalDurationSpan.Minutes, $TotalDurationSpan.Seconds

# ============================================================================
# Full application inventory: Post-01 Before -> latest WinGet CMD After
# ============================================================================
$WinGetBeforePath = Join-Path $LogRoot 'AppSnapshots\Before.json'
$WinGetAfterPath = Join-Path $LogRoot 'AppSnapshots\After.json'
$WinGetRows = @()
$WinGetUpdated = 0
$WinGetUnchanged = 0
$AppSnapshotInfo = 'Kein vollstaendiges Snapshot-Paar vorhanden.'
try {
    $captureState = Get-ItemProperty 'HKLM:\SOFTWARE\Franksoft\Setup\WinGetUpdate_FSC.cmd' -ErrorAction SilentlyContinue
    if ($null -ne $captureState) {
        $captureRC = Get-RegistryValueByNames $captureState @('AfterSnapshotExitCode')
        if ($captureRC -and $captureRC -ne '0') { throw 'Letzter After-Snapshot fehlgeschlagen; alter Snapshot wird nicht ausgewertet.' }
    }
    $beforeDoc = Get-Content -LiteralPath $WinGetBeforePath -Raw -ErrorAction Stop | ConvertFrom-Json
    $afterDoc = Get-Content -LiteralPath $WinGetAfterPath -Raw -ErrorAction Stop | ConvertFrom-Json
    if ($beforeDoc.Schema -ne 1 -or $afterDoc.Schema -ne 1) { throw 'Unbekanntes Snapshot-Format.' }
    if ($beforeDoc.Session -ne $afterDoc.Session) { throw 'Snapshots stammen aus unterschiedlichen Installationen oder Benutzerkonten.' }
    $currentOS = Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion'
    $sessionPrefix = '{0}|{1}|' -f $env:COMPUTERNAME,$currentOS.InstallDate
    if (-not $beforeDoc.Session.StartsWith($sessionPrefix)) { throw 'Snapshots gehoeren zu einer anderen Windows-Installation.' }
    if ([datetimeoffset]$afterDoc.Captured -lt [datetimeoffset]$beforeDoc.Captured) { throw 'After-Snapshot ist aelter als Before.' }
    $AppSnapshotInfo = 'Before: {0} | After: {1}' -f $beforeDoc.Captured,$afterDoc.Captured
    # 7-Zip product family: match an architecture migration only when each
    # snapshot has exactly one installation in the same account scope.
    $sevenBefore = @($beforeDoc.Apps | Where-Object { $_.Name -match '^7-Zip(?:\s|$)' -and $_.Publisher -eq 'Igor Pavlov' })
    $sevenAfter = @($afterDoc.Apps | Where-Object { $_.Name -match '^7-Zip(?:\s|$)' -and $_.Publisher -eq 'Igor Pavlov' })
    if ($sevenBefore.Count -eq 1 -and $sevenAfter.Count -eq 1) {
        $scopeBefore = ([string]$sevenBefore[0].Source -split '/')[0]
        $scopeAfter = ([string]$sevenAfter[0].Source -split '/')[0]
        if ($scopeBefore -eq $scopeAfter) {
            $sevenBefore[0].Id = "Win32|$scopeBefore|Igor Pavlov|7-Zip"
            $sevenAfter[0].Id = $sevenBefore[0].Id
        }
    }
    # English and German WebView2 display names identify the same product.
    # Keep account scope and registry view separate.
    foreach ($entry in @($beforeDoc.Apps) + @($afterDoc.Apps)) {
        if ($entry.Name -match '^Microsoft Edge WebView2(?: Runtime|-Laufzeit)$' -and $entry.Source -match '^(LocalMachine|CurrentUser)/Registry(32|64)$') {
            $entry.Id = 'Win32|' + $entry.Source + '|Microsoft Edge WebView2'
        }
    }
    $before = @{}; $after = @{}
    foreach ($entry in @($beforeDoc.Apps)) {
        if (-not $before.ContainsKey($entry.Id)) { $before[$entry.Id] = @() }
        $before[$entry.Id] += $entry
    }
    foreach ($entry in @($afterDoc.Apps)) {
        if (-not $after.ContainsKey($entry.Id)) { $after[$entry.Id] = @() }
        $after[$entry.Id] += $entry
    }
    foreach ($id in @(@($before.Keys) + @($after.Keys) | Sort-Object -Unique)) {
        $hasBefore = $before.ContainsKey($id); $hasAfter = $after.ContainsKey($id)
        $b = ''; $a = ''
        if ($hasBefore) { $b = (@($before[$id] | ForEach-Object { [string]$_.Version } | Sort-Object -Unique) -join ', ') }
        if ($hasAfter) { $a = (@($after[$id] | ForEach-Object { [string]$_.Version } | Sort-Object -Unique) -join ', ') }
        $item = if ($hasAfter) { $after[$id][0] } else { $before[$id][0] }
        $status = 'Unverändert'
        if (-not $hasBefore) { $status = 'Neu' }
        elseif (-not $hasAfter) { $status = 'nicht mehr Vorhanden' }
        elseif (-not $b -or -not $a) { $status = 'Version unbekannt' }
        elseif ($b -ne $a) { $status = 'Aktualisiert'; $WinGetUpdated++ }
        else { $WinGetUnchanged++ }
        $WinGetRows += [pscustomobject]@{App=($item.Name + ' [' + $item.Source + ']');Before=$b;After=$a;Status=$status}
    }
} catch { $AppSnapshotInfo = 'Vergleich nicht verfuegbar: ' + $_.Exception.Message }
# Show every captured app; no former 80-row limit.
$WinGetRowsForHtml = @($WinGetRows | Sort-Object App)

# ============================================================================
# FSC Log excerpt
# ============================================================================

$FscLogExcerpt = @()
if (Test-Path $FscLogPath) {
    try { $FscLogExcerpt = @(Get-Content -Path $FscLogPath -Tail 30 -ErrorAction SilentlyContinue) } catch {}
}

# ============================================================================
# HTML
# ============================================================================

$Generated = Get-Date -Format "dd.MM.yyyy HH:mm:ss"

# Explicit FSC deployment phase order; helper/child scripts are shown below
# in the complete execution overview, not in this main phase timeline.
$mainScriptOrder = @(
    "PE-LogFile.cmd",
    "SetupComplete.cmd",
    "Install_HP-Drivers.cmd",
    "FSC-Post-01.cmd",
    "FSC-Post-02.cmd",
    "FSC-Post-03.cmd"
)
$scriptRowsHtml = ""
foreach ($scriptName in $mainScriptOrder) {
    foreach ($row in @($ScriptItems | Where-Object { $_.Script -eq $scriptName })) {
    $statusClass = if ($row.Status -eq "OK") { "ok" } elseif ($row.Status -eq "Started") { "warn" } else { "bad" }
    $logText = if ($row.Log) { $row.Log } else { "" }

    $scriptRowsHtml += @"
<tr>
  <td>$(HtmlEncode $row.Phase)</td>
  <td>$(HtmlEncode $row.Script)</td>
  <td>$(HtmlEncode (Format-Time $row.Start))</td>
  <td>$(HtmlEncode (Format-Time $row.End))</td>
  <td>$(HtmlEncode (Format-Duration $row.Start $row.End))</td>
  <td class="$statusClass">$(HtmlEncode $row.Status)</td>
</tr>
"@
    }
}
if (-not $scriptRowsHtml) {
    $scriptRowsHtml = '<tr><td colspan="6" class="muted">Keine Haupt-Scriptdaten in der Registry gefunden.</td></tr>'
}

# ============================================================================
# Complete script execution overview (chronological, exact seconds)
# ============================================================================

$allScriptsRowsHtml = ""
$orderedScripts = @($ScriptItems | Sort-Object -Property @(@{ Expression = { if ($_.Start) { $_.Start } else { [datetime]::MaxValue } } }, 'Script'))
foreach ($row in $orderedScripts) {
    $durationText = "-"
    if ($row.Start -and $row.End -and $row.End -ge $row.Start) {
        $span = $row.End - $row.Start
        $durationText = "{0:00}:{1:00}:{2:00}" -f [math]::Floor($span.TotalHours), $span.Minutes, $span.Seconds
    }

    $exitCodeText = "-"
    $scriptRegPath = Join-Path $RegSetupRoot $row.Script
    if (Test-Path -LiteralPath $scriptRegPath) {
        $scriptRegItem = Get-ItemProperty -LiteralPath $scriptRegPath -ErrorAction SilentlyContinue
        if ($null -ne $scriptRegItem) {
            $exitValue = Get-RegistryValueByNames -Item $scriptRegItem -Names @("Exit_Code", "ExitCode", "Exit Code")
            if (-not [string]::IsNullOrWhiteSpace($exitValue)) {
                $exitCodeText = $exitValue
            }
        }
    }
    $statusClass = if ($row.Status -eq "OK") { "ok" } elseif ($row.Status -eq "Started") { "warn" } else { "bad" }
    $allScriptsRowsHtml += @"
<tr>
  <td>$(HtmlEncode $row.Phase)</td>
  <td>$(HtmlEncode $row.Script)</td>
  <td>$(HtmlEncode (Format-Time $row.Start))</td>
  <td>$(HtmlEncode (Format-Time $row.End))</td>
  <td class="num">$(HtmlEncode $durationText)</td>
  <td class="$statusClass">$(HtmlEncode $row.Status)</td>
  <td class="num">$(HtmlEncode $exitCodeText)</td>
</tr>
"@
}
if (-not $allScriptsRowsHtml) {
    $allScriptsRowsHtml = '<tr><td colspan="7" class="muted">Keine Script-Zeitdaten in der Registry gefunden.</td></tr>'
}

$wingetRowsHtml = ""
if ($WinGetRowsForHtml.Count -gt 0) {
    foreach ($row in $WinGetRowsForHtml) {
        $class = 'muted'
        if ($row.Status -eq 'Aktualisiert' -or $row.Status -eq 'Neu') { $class = 'ok' }
        elseif ($row.Status -eq 'nicht mehr Vorhanden') { $class = 'warn removed-app' }
        $wingetRowsHtml += @"
<tr>
  <td>$(HtmlEncode $row.App)</td>
  <td>$(HtmlEncode $row.Before)</td>
  <td>$(HtmlEncode $row.After)</td>
  <td class="$class">$(HtmlEncode $row.Status)</td>
</tr>
"@
    }
} else {
    $wingetRowsHtml = "<tr><td colspan='4' class='muted'>Kein auswertbares App-Snapshot-Paar gefunden.</td></tr>"
}

$FscLogUri = 'file:///' + $FscLogPath.Replace('\','/')
$fscLogHtml = ""
if ($FscLogExcerpt.Count -gt 0) {
    foreach ($line in $FscLogExcerpt) {
        $fscLogHtml += "$(HtmlEncode $line)`r`n"
    }
} else {
    $fscLogHtml = "Keine FSC Logdaten gefunden."
}

$wuStatusClass = if ($WUStatus -like "erfolgreich*") { "ok" } elseif ($WUStatus -like '*Fehler*') { 'bad' } else { "muted" }
$wuPhasesHtml = ''
foreach ($p in $WUPhaseRows) {
    $wuPhasesHtml += '<tr><td>{0}</td><td>{1}</td><td>{2}</td><td>{3}</td></tr>' -f (HtmlEncode $p.Phase), (HtmlEncode (Format-DateTime $p.Start)), (HtmlEncode (Format-DateTime $p.End)), (HtmlEncode (Format-Duration $p.Start $p.End))
}
if (-not $wuPhasesHtml) { $wuPhasesHtml = '<tr><td colspan="4" class="muted">Keine Zeitdaten zu Update-Runden vorhanden.</td></tr>' }

$html = @"
<!DOCTYPE html>
<html lang="de">
<head>
<meta charset="utf-8">
<title>Franksoft Deployment Report</title>
<style>
    :root {
        --blue: #005FB8;
        --blue2: #0078D7;
        --darkblue: #003C7A;
        --line: #DADADA;
        --text: #202020;
        --muted: #707070;
        --panel: #FFFFFF;
        --bg: #F5F7FA;
    }
    * { box-sizing: border-box; }
    body {
        margin: 0;
        background: var(--bg);
        font-family: "Segoe UI", Arial, sans-serif;
        color: var(--text);
    }
    .header {
        background: linear-gradient(90deg, #003C7A, #006FD1);
        color: white;
        padding: 22px 30px;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }
    .header h1 { margin: 0; font-size: 30px; font-weight: 600; }
    .header .sub { margin-top: 4px; opacity: .9; font-size: 14px; }
    .brand { text-align: right; font-size: 34px; font-weight: 700; letter-spacing: 2px; }
    .brand small { display:block; font-size: 12px; letter-spacing: 1px; }
    .wrap { padding: 18px; max-width: 1280px; margin: 0 auto; }
    .grid3 { display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 16px; }
    .grid2 { display: grid; grid-template-columns: 1.2fr .8fr; gap: 16px; }
    .panel {
        background: var(--panel);
        border: 1px solid var(--line);
        border-radius: 6px;
        padding: 16px 18px;
        margin-bottom: 16px;
        box-shadow: 0 1px 2px rgba(0,0,0,.04);
    }
    .panel h2 {
        margin: 0 0 14px 0;
        font-size: 18px;
        color: #003C7A;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: .2px;
    }
    .kv { display: grid; grid-template-columns: 140px 1fr; row-gap: 8px; column-gap: 12px; font-size: 14px; }
    .kv b { color: #111; }
    .summary-table, table {
        width: 100%;
        border-collapse: collapse;
        font-size: 14px;
    }
    th {
        background: #EEF4FB;
        color: #003C7A;
        text-align: left;
        padding: 9px 10px;
        border: 1px solid var(--line);
        font-weight: 700;
    }
    td {
        padding: 8px 10px;
        border: 1px solid var(--line);
        vertical-align: top;
    }
    .num { text-align: right; }
    .summary-duration { font-size: 14px; font-weight: 400; color: #202020; font-variant-numeric: tabular-nums; }
    .summary-table .driver-row td { font-weight: 700; }
    .total-row td { font-weight: 700; background: #F1F6FD; font-size: 20px; color: #003C7A; }
    .total-row td.num { font-size: 24px; font-variant-numeric: tabular-nums; }
    .ok { color: #0A7A20; font-weight: 600; }
    .warn { color: #B26B00; font-weight: 600; }
    .removed-app { font-weight: 700; }
    .bad { color: #B00020; font-weight: 600; }
    .muted { color: var(--muted); }
    .path { font-family: Consolas, monospace; font-size: 12px; color: #404040; }
    pre {
        margin: 0;
        background: #FBFBFB;
        border: 1px solid var(--line);
        padding: 12px;
        border-radius: 4px;
        max-height: 280px;
        overflow: auto;
        font-family: Consolas, monospace;
        font-size: 12px;
        white-space: pre-wrap;
    }
    .footer {
        display:flex;
        justify-content: space-between;
        color: var(--muted);
        font-size: 13px;
        padding: 14px 2px 0 2px;
    }
</style>
</head>
<body>

<div class="header">
    <div>
        <h1>Franksoft Deployment Report</h1>
        <div class="sub">Automatischer Report aus Registry, FSC Log und WinGet Logs</div>
    </div>
    <div class="brand">FSC<small>FRANKSOFT CLIENT</small></div>
</div>

<div class="wrap">

<div class="grid3 panel">
    <div>
        <h2>System</h2>
        <div class="kv">
            <b>Computername:</b><span>$(HtmlEncode $ComputerName)</span>
            <b>Hersteller:</b><span>$(HtmlEncode $Manufacturer)</span>
            <b>Modell:</b><span>$(HtmlEncode $Model)</span>
            <b>RAM:</b><span>$(HtmlEncode $RamGB) GB</span>

            <b>BIOS Seriennr.:</b><span>$(HtmlEncode $BiosSerial)</span>

        </div>
    </div>
<div>
    <h2>Betriebssystem</h2>
    <div class="kv">
        <b>Windows:</b><span>$(HtmlEncode $WindowsCaption)</span>
        <b>Version:</b><span>$(HtmlEncode $DisplayVersion)</span>
        <b>Build:</b><span>$(HtmlEncode $WindowsBuild)</span>
        <b>Architektur:</b><span>$(HtmlEncode $Architecture)</span>
    </div>
</div>
        <div>
            <h2>Report Info</h2>
            <div class="kv">
                <b>Erstellt:</b><span>$(HtmlEncode $Generated)</span>
                <b>Generator:</b><span>FSC-DeploymentReport.ps1 v2.9 (31.10.2026 14:40:00)</span>
                <b>Registry:</b><span>$(if (Test-Path $RegSetupRoot) { "OK" } else { "Fehlt" })</span>
                <b>FSC Log:</b><span>$(if (Test-Path $FscLogPath) { "OK" } else { "Fehlt" })</span>
                <b>App-Snapshots:</b><span>$(if ((Test-Path $WinGetBeforePath) -and (Test-Path $WinGetAfterPath)) { "OK" } else { "Fehlt" })</span>
            </div>
        </div>
    </div>

    <div class="grid2">
        <div class="panel">
            <h2>Deployment Summary</h2>
            <table class="summary-table">
                <tr><td>Windows Setup</td><td>$(Format-Time $WindowsSetupStart)</td><td>$(Format-Time $WindowsSetupEnd)</td><td class="num summary-duration">$WindowsSetupDuration</td></tr>
                <tr><td>Franksoft Deployment</td><td>$(Format-Time $FSCDeploymentStart)</td><td>$(Format-Time $FSCDeploymentEnd)</td><td class="num summary-duration">$FSCDeploymentDuration</td></tr>
                <tr class="driver-row"><td><b>Install_HP-Drivers.cmd</b></td><td>$(Format-Time $HPDriversStart)</td><td>$(Format-Time $HPDriversEnd)</td><td class="num summary-duration">$(HtmlEncode $HPDriversDuration)</td></tr>
                <tr><td>Windows Update</td><td>$(Format-Time $WindowsUpdateStart)</td><td>$(Format-Time $WindowsUpdateEnd)</td><td class="num summary-duration">$WindowsUpdateDuration</td></tr>
                <tr class="total-row"><td colspan="3">Gesamtdauer</td><td class="num">$TotalDuration</td></tr>
            </table>
        </div>

        <div class="panel">
            <h2>Windows Update</h2>
            <div class="kv">
                <b>Status:</b><span class="$wuStatusClass">$(HtmlEncode $WUStatus)</span>
                <b>Start:</b><span>$(HtmlEncode (Format-DateTime $WindowsUpdateStart))</span>
                <b>Ende:</b><span>$(HtmlEncode (Format-DateTime $WindowsUpdateEnd))</span>
                <b>Dauer:</b><span>$(HtmlEncode $WindowsUpdateDuration)</span>
                <b>Result:</b><span>$(HtmlEncode $WULastResult)</span>
                <b>Round:</b><span>$(HtmlEncode $WURound)</span>
                <b>Phase:</b><span>$(HtmlEncode $WUPhase)</span>
            </div>
        </div>
    </div>

    <div class="panel">
        <h2>Windows Update – Runden aus Registry</h2>
        <p class="path">HKLM\SOFTWARE\Franksoft\WindowsUpdate</p>
        <table><thead><tr><th>Runde</th><th>Start</th><th>Ende</th><th>Dauer (hh:mm:ss)</th></tr></thead>
        <tbody>$wuPhasesHtml</tbody></table>
        <p class="muted">Gesamtdauer von erstem Start bis Abschluss inklusive Neustarts und Wartezeiten. Laufzeiten der Runden werden nicht zusätzlich summiert.</p>
    </div>

    <div class="panel">
        <h2>Script Timeline aus Registry</h2>
        <table>
            <thead>
                <tr><th>Phase</th><th>Script</th><th>Start</th><th>Ende</th><th>Dauer (hh:mm:ss)</th><th>Status</th></tr>
            </thead>
            <tbody>
                $scriptRowsHtml
            </tbody>
        </table>
    </div>

    <div>
        <div class="panel">
            <h2>Installierte Apps – Before / After Vergleich</h2>
            <table>
                <thead><tr><th>App</th><th>Vorher</th><th>Nachher</th><th>Status</th></tr></thead>
                <tbody>$wingetRowsHtml</tbody>
            </table>
            <p class="muted">Before: $(HtmlEncode $WinGetBeforePath)<br>After: $(HtmlEncode $WinGetAfterPath)</p>
            <p>$(HtmlEncode $AppSnapshotInfo)</p>
            <p><b>Aktualisiert:</b> $WinGetUpdated &nbsp;&nbsp; <b>Unverändert:</b> $WinGetUnchanged</p>
            <p class="muted">Versionsaenderungen zeigen keine Zuordnung zu einem bestimmten Updater. Neu bedeutet: kein Before-Eintrag vorhanden; eine Neuinstallation ist damit nicht bewiesen. Portable Apps ohne Registrierung sind nicht enthalten.</p>
        </div>

        <div class="panel">
            <h2>FSC Log Auszug</h2>
            <p class="path"><a href="$(HtmlEncode $FscLogUri)">$(HtmlEncode $FscLogPath)</a></p>
            <pre>$fscLogHtml</pre>
        </div>
    </div>

    <div class="panel">
        <h2>Alle Scripts – Laufzeiten (chronologisch)</h2>
        <table>
            <thead>
                <tr><th>Phase</th><th>Script</th><th>Start</th><th>Ende</th><th>Dauer (hh:mm:ss)</th><th>Status</th><th>Exit-Code</th></tr>
            </thead>
            <tbody>
                $allScriptsRowsHtml
            </tbody>
        </table>
        <p class="muted">Laufzeiten sekundengenau aus HKLM\\SOFTWARE\\Franksoft\\Setup. Parallele oder verschachtelte Scripts werden nicht als zusätzliche Deployment-Gesamtdauer summiert.</p>
    </div>

    <div class="footer">
        <div>Dieser Report wurde automatisch von Franksoft Client erstellt. Zeiten basieren auf Registry und Log-Dateien.</div>
        <div>(c) Franksoft 1997-2026</div>
    </div>

</div>
</body>
</html>
"@

# UTF-8 with BOM for compatibility with Notepad / older tools.
$utf8Bom = New-Object System.Text.UTF8Encoding($true)
[System.IO.File]::WriteAllText($ReportPath, $html, $utf8Bom)

Write-Host "Generator: FSC-DeploymentReport.ps1 v2.9 (31.10.2026 14:40:00)"
Write-Host "Script-Datei: $PSCommandPath"
Write-Host "Deployment Report erstellt: $ReportPath"


# ============================================================================
# Desktop Shortcut
# ============================================================================

$ShortcutPath = "$env:PUBLIC\Desktop\Franksoft Client Report.lnk"
$TargetPath   = $ReportPath

try {

    $Shell = New-Object -ComObject WScript.Shell
    $Shortcut = $Shell.CreateShortcut($ShortcutPath)

    $Shortcut.TargetPath = $TargetPath
    $Shortcut.WorkingDirectory = Split-Path $TargetPath
    $Shortcut.IconLocation = "C:\ProgramData\Franksoft\Ico\Franksoft\Franksoft (2).ico"

    $Shortcut.Save()

}
catch {}

Write-Host ""
Write-Host "Deployment Report erstellt:"
Write-Host $ReportPath

if ($OpenReport) {
    Start-Process $ReportPath
}

