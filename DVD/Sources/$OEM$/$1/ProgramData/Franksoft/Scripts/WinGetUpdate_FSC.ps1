# =============================================================================
# Script Name : WinGetUpdate_FSC.ps1
# Version     : 1.2
# Date        : 25.10.2026
# Time        : 16:55:00
# Author      : Franksoft
#
# Purpose
# -----------------------------------------------------------------------------
# FSC Deployment - JSON-gesteuerte WinGet-Installationen und Updates
# Mode=install -> winget install
# Mode=update  -> winget upgrade
# Optional: UninstallPrevious=true -> --uninstall-previous beim Upgrade
# Kein globales winget upgrade --all
#
# Files
# -----------------------------------------------------------------------------
# Config      : C:\ProgramData\Franksoft\Scripts\WinGetApps.json
# Launcher    : WinGetUpdate_FSC.cmd
# Log         : C:\ProgramData\Franksoft\Logs\FSC-WinGet-Update.log
#
# Changelog
# -----------------------------------------------------------------------------
# v1.0  Initiale JSON-gesteuerte WinGet-Installation und Updates
# v1.1  Franksoft-Header und optionaler 7-Zip-Parameter
#       UninstallPrevious via JSON hinzugefuegt
#
# Planned
# -----------------------------------------------------------------------------
# v1.2: Echte ExitCodes und WinGet-Ausgabe im Log; Gesamtcode bei Fehlern.
# App-Snapshots werden zentral von den CMD-Aufrufern erfasst.
# =============================================================================

$JsonFile = "$env:ProgramData\Franksoft\Scripts\WinGetApps.json"
$LogFile  = "$env:ProgramData\Franksoft\Logs\FSC-WinGet-Update.log"

function Write-Log {
    param([string]$Text)

    $Time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    Write-Host $Text
    Add-Content -Path $LogFile -Value "$Time $Text"
}

$null = New-Item -ItemType Directory -Path (Split-Path $LogFile) -Force

if (!(Test-Path $JsonFile))
{
    Write-Log "JSON nicht gefunden: $JsonFile"
    exit 1
}

$ErrorActionPreference = 'Stop'
$null = New-Item -ItemType Directory -Path (Split-Path $LogFile) -Force
$Failures = 0
try { $Config = Get-Content $JsonFile -Raw | ConvertFrom-Json; $null = Get-Command winget -ErrorAction Stop }
catch { Write-Log "FEHLER Konfiguration/WinGet: $_"; exit 1 }

foreach ($App in $Config.Apps)
{
    Write-Log ""
    Write-Log "===================================================="
    Write-Log "$($App.Name)"
    Write-Log "Mode : $($App.Mode)"
    Write-Log "ID   : $($App.Id)"
    Write-Log "===================================================="

    try
    {
        $AppExitCode = $null
        switch ($App.Mode.ToLower())
        {
            "install"
            {
                $ErrorActionPreference = 'Continue'
                winget install `
                    --id "$($App.Id)" `
                    --accept-package-agreements `
                    --accept-source-agreements `
                    --silent 2>&1 | ForEach-Object { Write-Log ([string]$_) }
                $AppExitCode = $LASTEXITCODE
                $ErrorActionPreference = 'Stop'
            }

            "update"
            {
                $WingetArgs = @(
                    'upgrade', '--id', [string]$App.Id,
                    '--exact', '--source', 'winget',
                    '--accept-source-agreements', '--disable-interactivity',
                    '--silent', '--include-unknown',
                    '--accept-package-agreements', '--force'
                )

                if ($App.UninstallPrevious -eq $true) {
                    $WingetArgs += '--uninstall-previous'
                    Write-Log 'Option: --uninstall-previous'
                }

                $ErrorActionPreference = 'Continue'
                & winget @WingetArgs 2>&1 | ForEach-Object { Write-Log ([string]$_) }
                $AppExitCode = $LASTEXITCODE
                $ErrorActionPreference = 'Stop'
            }

            default
            {
                throw "Unbekannter Mode: $($App.Mode)"
            }
        }

        Write-Log "ExitCode: $AppExitCode"
        if ($AppExitCode -eq 0) { Write-Log 'Befehl erfolgreich; Versionsaenderung siehe App-Snapshot.' }
        elseif ($AppExitCode -eq -1978335189) { Write-Log 'Kein anwendbares Update vorhanden.' }
        else { $Failures++; Write-Log "FEHLER: WinGet ExitCode=$AppExitCode" }
    }
    catch
    {
        $Failures++
        Write-Log "FEHLER: $_"
    }
}

Write-Log ""
Write-Log "WinGet Updates abgeschlossen"

if ($Failures -gt 0) { exit 1 }
exit 0
