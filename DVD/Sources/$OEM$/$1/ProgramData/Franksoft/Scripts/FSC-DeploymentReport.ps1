# ============================================================================
# Franksoft Client Deployment
# Deployment Report Generator
#
# Script : FSC-CreateDeploymentReport.ps1
# Version: 1.1
# Author : Franksoft
# Date   : 22.06.2026
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

    $formats = @(
        "dd.MM.yyyy HH:mm:ss",
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

function HtmlEncode {
    param([object]$Text)
    if ($null -eq $Text) { return "" }
    return [System.Net.WebUtility]::HtmlEncode([string]$Text)
}

function Format-Time {
    param([datetime]$Date)
    if ($Date) { return $Date.ToString("HH:mm:ss") }
    return ""
}

function Format-DateTime {
    param([datetime]$Date)
    if ($Date) { return $Date.ToString("dd.MM.yyyy HH:mm:ss") }
    return ""
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

# Windows Update: HKLM\SOFTWARE\Franksoft\WindowsUpdate FirstStart -> DeploymentEnd fallback LastEndPhase09.
try {
    if (Test-Path $RegWU) {
        $wu = Get-ItemProperty -Path $RegWU

        $WindowsUpdateStart = Convert-FSCDate $wu.FirstStart
        $WindowsUpdateEnd   = Convert-FSCDate $wu.DeploymentEnd
        if (-not $WindowsUpdateEnd) { $WindowsUpdateEnd = Convert-FSCDate $wu.LastEndPhase09 }

        $WULastResult = [string]$wu.LastResult
        $WURound      = [string]$wu.CurrentRound
        $WUPhase      = [string]$wu.CurrentPhase

        $tmp = Get-Minutes -Start $WindowsUpdateStart -End $WindowsUpdateEnd
        if ($null -ne $tmp -and $tmp -gt 0) {
            $WindowsUpdateMin = $tmp
            $WUStatus = "erfolgreich abgeschlossen"
        }
    }
} catch {}

$TotalMin = $WindowsSetupMin + $FSCDeploymentMin + $WindowsUpdateMin

# ============================================================================
# WinGet Before / After comparison
# ============================================================================

function Find-WinGetFile {
    param([string]$Kind)

    if (-not (Test-Path $LogRoot)) { return $null }

    $patterns = @(
        "*WinGet*${Kind}*.csv",
        "*Winget*${Kind}*.csv",
        "*WinGet*${Kind}*.txt",
        "*Winget*${Kind}*.txt"
    )

    foreach ($pattern in $patterns) {
        $f = Get-ChildItem -Path $LogRoot -Filter $pattern -File -ErrorAction SilentlyContinue |
            Sort-Object LastWriteTime -Descending |
            Select-Object -First 1
        if ($f) { return $f.FullName }
    }
    return $null
}

function Import-WinGetSnapshot {
    param([string]$Path)

    $result = @{}
    if (-not $Path -or -not (Test-Path $Path)) { return $result }

    try {
        if ($Path.ToLower().EndsWith(".csv")) {
            $rows = Import-Csv -Path $Path
            foreach ($r in $rows) {
                $name = Get-RegistryValueByNames -Item $r -Names @("Name", "App", "PackageName", "Package", "DisplayName")
                $ver  = Get-RegistryValueByNames -Item $r -Names @("Version", "InstalledVersion", "Installed Version", "DisplayVersion")
                if ($name) { $result[$name] = $ver }
            }
        }
        else {
            $lines = Get-Content -Path $Path -ErrorAction SilentlyContinue
            foreach ($line in $lines) {
                if ([string]::IsNullOrWhiteSpace($line)) { continue }
                # Simple tolerant parsing: name + 2 spaces + version at end.
                if ($line -match "^(.+?)\s{2,}([0-9][^\s]*)\s*$") {
                    $result[$matches[1].Trim()] = $matches[2].Trim()
                }
            }
        }
    } catch {}

    return $result
}

$WinGetBeforePath = Find-WinGetFile -Kind "Before"
$WinGetAfterPath  = Find-WinGetFile -Kind "After"
$WinGetRows = @()
$WinGetUpdated = 0
$WinGetUnchanged = 0

$before = Import-WinGetSnapshot -Path $WinGetBeforePath
$after  = Import-WinGetSnapshot -Path $WinGetAfterPath

$allNames = @($before.Keys + $after.Keys) | Sort-Object -Unique
foreach ($name in $allNames) {
    $b = if ($before.ContainsKey($name)) { $before[$name] } else { "" }
    $a = if ($after.ContainsKey($name))  { $after[$name] }  else { "" }

    $status = "Unchanged"
    if ($b -and $a -and $b -ne $a) { $status = "Updated"; $WinGetUpdated++ }
    elseif (-not $b -and $a) { $status = "Added"; $WinGetUpdated++ }
    elseif ($b -and -not $a) { $status = "Missing" }
    else { $WinGetUnchanged++ }

    $WinGetRows += [pscustomobject]@{
        App = $name
        Before = $b
        After = $a
        Status = $status
    }
}

# Limit huge reports, but keep useful data.
$WinGetRowsForHtml = @($WinGetRows | Select-Object -First 80)

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

$scriptRowsHtml = ""
foreach ($row in $ScriptItems) {
    $statusClass = if ($row.Status -eq "OK") { "ok" } elseif ($row.Status -eq "Started") { "warn" } else { "bad" }
    $logText = if ($row.Log) { $row.Log } else { "" }

    $scriptRowsHtml += @"
<tr>
  <td>$(HtmlEncode $row.Phase)</td>
  <td>$(HtmlEncode $row.Script)</td>
  <td>$(HtmlEncode (Format-Time $row.Start))</td>
  <td>$(HtmlEncode (Format-Time $row.End))</td>
  <td class="num">$(HtmlEncode $row.Minutes)</td>
  <td class="$statusClass">$(HtmlEncode $row.Status)</td>
  <td class="path">$(HtmlEncode $logText)</td>
</tr>
"@
}

$wingetRowsHtml = ""
if ($WinGetRowsForHtml.Count -gt 0) {
    foreach ($row in $WinGetRowsForHtml) {
        $class = switch ($row.Status) {
            "Updated" { "ok"; break }
            "Added" { "ok"; break }
            "Missing" { "warn"; break }
            default { "muted" }
        }
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
    $wingetRowsHtml = "<tr><td colspan='4' class='muted'>Keine WinGet Before/After Daten gefunden.</td></tr>"
}

$fscLogHtml = ""
if ($FscLogExcerpt.Count -gt 0) {
    foreach ($line in $FscLogExcerpt) {
        $fscLogHtml += "$(HtmlEncode $line)`r`n"
    }
} else {
    $fscLogHtml = "Keine FSC Logdaten gefunden."
}

$wuStatusClass = if ($WUStatus -like "erfolgreich*") { "ok" } else { "muted" }

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
    .big { font-size: 18px; font-weight: 700; color: #003C7A; }
    .total-row td { font-weight: 700; background: #F1F6FD; font-size: 16px; }
    .ok { color: #0A7A20; font-weight: 600; }
    .warn { color: #B26B00; font-weight: 600; }
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
                <b>Registry:</b><span>$(if (Test-Path $RegSetupRoot) { "OK" } else { "Fehlt" })</span>
                <b>FSC Log:</b><span>$(if (Test-Path $FscLogPath) { "OK" } else { "Fehlt" })</span>
                <b>WinGet Logs:</b><span>$(if ($WinGetBeforePath -or $WinGetAfterPath) { "OK" } else { "Fehlt" })</span>
            </div>
        </div>
    </div>

    <div class="grid2">
        <div class="panel">
            <h2>Deployment Summary</h2>
            <table class="summary-table">
                <tr><td>Windows Setup</td><td>$(Format-Time $WindowsSetupStart)</td><td>$(Format-Time $WindowsSetupEnd)</td><td class="num big">$WindowsSetupMin Minuten</td></tr>
                <tr><td>Franksoft Deployment</td><td>$(Format-Time $FSCDeploymentStart)</td><td>$(Format-Time $FSCDeploymentEnd)</td><td class="num big">$FSCDeploymentMin Minuten</td></tr>
                <tr><td>Windows Update</td><td>$(Format-Time $WindowsUpdateStart)</td><td>$(Format-Time $WindowsUpdateEnd)</td><td class="num big">$(if ($WindowsUpdateMin -gt 0) { "$WindowsUpdateMin Minuten" } else { "nicht ausgeführt" })</td></tr>
                <tr class="total-row"><td colspan="3">Gesamtdauer</td><td class="num">$TotalMin Minuten</td></tr>
            </table>
        </div>

        <div class="panel">
            <h2>Windows Update</h2>
            <div class="kv">
                <b>Status:</b><span class="$wuStatusClass">$(HtmlEncode $WUStatus)</span>
                <b>FirstStart:</b><span>$(HtmlEncode (Format-DateTime $WindowsUpdateStart))</span>
                <b>DeploymentEnd:</b><span>$(HtmlEncode (Format-DateTime $WindowsUpdateEnd))</span>
                <b>Dauer:</b><span>$(if ($WindowsUpdateMin -gt 0) { "$WindowsUpdateMin Minuten" } else { "nicht ausgeführt" })</span>
                <b>Result:</b><span>$(HtmlEncode $WULastResult)</span>
                <b>Round:</b><span>$(HtmlEncode $WURound)</span>
                <b>Phase:</b><span>$(HtmlEncode $WUPhase)</span>
            </div>
        </div>
    </div>

    <div class="panel">
        <h2>Script Timeline aus Registry</h2>
        <table>
            <thead>
                <tr><th>Phase</th><th>Script</th><th>Start</th><th>Ende</th><th>Dauer (Min)</th><th>Status</th><th>Log File</th></tr>
            </thead>
            <tbody>
                $scriptRowsHtml
            </tbody>
        </table>
    </div>

    <div class="grid2">
        <div class="panel">
            <h2>WinGet Before / After Vergleich</h2>
            <table>
                <thead><tr><th>App</th><th>Vorher</th><th>Nachher</th><th>Status</th></tr></thead>
                <tbody>$wingetRowsHtml</tbody>
            </table>
            <p class="muted">Before: $(HtmlEncode $WinGetBeforePath)<br>After: $(HtmlEncode $WinGetAfterPath)</p>
            <p><b>Updated:</b> $WinGetUpdated &nbsp;&nbsp; <b>Unchanged:</b> $WinGetUnchanged</p>
        </div>

        <div class="panel">
            <h2>FSC Log Auszug</h2>
            <p class="path">$(HtmlEncode $FscLogPath)</p>
            <pre>$fscLogHtml</pre>
        </div>
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

Write-Host "Deployment Report erstellt: $ReportPath"

$Html | Set-Content -Path $ReportPath -Encoding UTF8

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
