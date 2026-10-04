# ==============================
# SETUPAPI DEVICE INSTALL ANALYSIS (FULL + LIVE LOG)
# ==============================

$scriptPath = $MyInvocation.MyCommand.Path
$basePath = "C:\Windows\INF"

# ==============================
# OUTPUT FILE
# ==============================

$computer = $env:COMPUTERNAME
$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"

$outFile = "C:\ProgramData\Franksoft\Logs\setupapi.device_install_${computer}_${timestamp}.txt"

New-Item -ItemType Directory -Path "C:\Temp" -Force | Out-Null
"" | Set-Content $outFile

# ==============================
# PATTERNS
# ==============================

$devicePattern = "\[Driver Install \(DrvSetupInstallDriver\)"
$timePattern = "Section start (\d{4}/\d{2}/\d{2} \d{2}:\d{2}:\d{2}\.\d+)"

# ==============================
# LOAD LOG FILES (ROTATING + LIVE)
# ==============================

$logFiles = @()

# Rotating logs
$logFiles += Get-ChildItem $basePath -Filter "setupapi.dev.2026*_*.log" -ErrorAction SilentlyContinue

# Live log
$liveLog = "$basePath\setupapi.dev.log"
if (Test-Path $liveLog) {
    $logFiles += Get-Item $liveLog
}

# ==============================
# COLLECT EVENTS
# ==============================

$events = @()

foreach ($file in $logFiles) {

    $lines = Get-Content $file.FullName -ErrorAction SilentlyContinue

    for ($i = 0; $i -lt $lines.Count - 2; $i++) {

        if ($lines[$i] -match $devicePattern -and $lines[$i+1] -match "Section start") {

            if ($lines[$i+1] -match $timePattern) {

                $eventTime = [datetime]::ParseExact(
                    $matches[1],
                    "yyyy/MM/dd HH:mm:ss.fff",
                    $null
                )

                $cmd = ""
                if ($lines[$i+2] -match "cmd:") {
                    $cmd = $lines[$i+2].Trim()
                }

                $events += [PSCustomObject]@{
                    Time   = $eventTime
                    File   = $file.Name
                    Device = $lines[$i].Trim()
                    Cmd    = $cmd
                }
            }
        }
    }
}

# ==============================
# GLOBAL SORT
# ==============================

$events = $events | Sort-Object Time

# ==============================
# LOG LIST (WITH TIME)
# ==============================

$i = 1
$logList = ""

foreach ($f in ($logFiles | Sort-Object Name)) {

    if ($f.Name -match "setupapi\.dev\.(\d{8})_(\d{6})\.log") {

        $dt = [datetime]::ParseExact(
            "$($matches[1])$($matches[2])",
            "yyyyMMddHHmmss",
            $null
        )

        $logList += "$i. $($dt.ToString('dd.MM.yyyy HH:mm:ss')) Uhr - $($f.Name)`n"
        $i++
    }
    elseif ($f.Name -eq "setupapi.dev.log") {
        $logList += "$i. LIVE - $($f.Name)`n"
        $i++
    }
}

# ==============================
# HEADER
# ==============================

$header = @"
========================================
SETUPAPI DEVICE INSTALL ANALYSIS (FULL)
========================================
Datum:        $(Get-Date -Format "dd.MM.yyyy HH:mm:ss") Uhr
Computer:     $computer
Script Pfad:  $scriptPath
Log Input:    $basePath
Log Output:   $outFile

Gelesene Logs:
$logList

Enthalten:
- Rotierende SetupAPI Logs
- Live setupapi.dev.log
- echte Section start Zeit
========================================

"@

Add-Content $outFile $header

# ==============================
# TIMELINE OUTPUT
# ==============================

$counter = 0

foreach ($e in $events) {

    $counter++

    Add-Content $outFile "[$counter] $($e.Time.ToString('dd.MM.yyyy HH:mm:ss')) Uhr"
    Add-Content $outFile "File:   $($e.File)"
    Add-Content $outFile "Device: $($e.Device)"
    if ($e.Cmd) { Add-Content $outFile $e.Cmd }
    Add-Content $outFile "----------------------------------------"
}

# ==============================
# SESSION DETECTION
# ==============================

$sessionThreshold = New-TimeSpan -Minutes 10
$sessions = @()
$current = @()
$prev = $null

foreach ($e in $events) {

    if ($prev -eq $null) {
        $current += $e
    }
    else {
        if (($e.Time - $prev.Time) -gt $sessionThreshold) {
            $sessions += ,$current
            $current = @()
        }

        $current += $e
    }

    $prev = $e
}

if ($current.Count -gt 0) {
    $sessions += ,$current
}

# ==============================
# SESSION + TOTAL INSTALL TIME
# ==============================

$totalInstallTime = [TimeSpan]::Zero
$sessionIndex = 0

Add-Content $outFile ""
Add-Content $outFile "========================================"
Add-Content $outFile "SESSIONS"
Add-Content $outFile "========================================"

foreach ($s in $sessions) {

    if ($s.Count -eq 0) { continue }

    $sessionIndex++

    $start = $s[0].Time
    $end   = $s[-1].Time
    $dur   = $end - $start

    $totalInstallTime += $dur

    Add-Content $outFile ""
    Add-Content $outFile "SESSION $sessionIndex"
    Add-Content $outFile "Start: $($start.ToString('dd.MM.yyyy HH:mm:ss')) Uhr"
    Add-Content $outFile "Ende:  $($end.ToString('dd.MM.yyyy HH:mm:ss')) Uhr"
    Add-Content $outFile "Dauer: $($dur.ToString('hh\:mm\:ss'))"
    Add-Content $outFile "Events: $($s.Count)"
    Add-Content $outFile "----------------------------------------"
}

# ==============================
# ACTIVITY vs IDLE ANALYSIS
# ==============================

$activityThreshold = New-TimeSpan -Minutes 10
$activityTime = [TimeSpan]::Zero
$idleTime = [TimeSpan]::Zero

for ($i = 1; $i -lt $events.Count; $i++) {

    $gap = $events[$i].Time - $events[$i-1].Time

    if ($gap -le $activityThreshold) {
        $activityTime += $gap
    }
    else {
        $idleTime += $gap
    }
}

$totalWindow = $events[-1].Time - $events[0].Time

# ==============================
# FOOTER
# ==============================

Add-Content $outFile ""
Add-Content $outFile "========================================"
Add-Content $outFile "FERTIG"
Add-Content $outFile "Gesamt Events: $counter"
Add-Content $outFile "Sessions: $sessionIndex"
Add-Content $outFile ""
Add-Content $outFile "Installations Dauer Insgesamt: $($totalInstallTime.ToString('hh\:mm\:ss'))"
Add-Content $outFile ""
Add-Content $outFile "WINDOWS ACTIVITY ANALYSIS"
Add-Content $outFile "Installations Activity Time: $($activityTime.ToString('hh\:mm\:ss'))"
Add-Content $outFile "Idle Time:                   $($idleTime.ToString('hh\:mm\:ss'))"
Add-Content $outFile "Total Window:                $($totalWindow.ToString('hh\:mm\:ss'))"
Add-Content $outFile "========================================"

Write-Host "Fertig. Events: $counter"
Write-Host "Sessions: $sessionIndex"
Write-Host "Install Time: $totalInstallTime"
Write-Host "Activity: $activityTime | Idle: $idleTime"
Write-Host "Output: $outFile"