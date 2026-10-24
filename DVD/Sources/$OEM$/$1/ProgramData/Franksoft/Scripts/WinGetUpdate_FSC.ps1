# =============================================================================
# Script Name : WinGetUpdate_FSC.ps1
# Version     : 1.1
# Date        : 23.10.2026
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
# Vorher-/Nachher-Versionsvergleich und ExitCode-Auswertung pro App
# =============================================================================

$JsonFile = "$env:ProgramData\Franksoft\Scripts\WinGetApps.json"
$LogFile  = "$env:ProgramData\Franksoft\Logs\FSC-WinGet-Update.log"

function Write-Log {
    param([string]$Text)

    $Time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    Write-Host $Text
    Add-Content -Path $LogFile -Value "$Time $Text"
}

if (!(Test-Path $JsonFile))
{
    Write-Log "JSON nicht gefunden: $JsonFile"
    exit 1
}

$Config = Get-Content $JsonFile -Raw | ConvertFrom-Json

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
        switch ($App.Mode.ToLower())
        {
            "install"
            {
                winget install `
                    --id "$($App.Id)" `
                    --accept-package-agreements `
                    --accept-source-agreements `
                    --silent
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

                & winget @WingetArgs
            }

            default
            {
                Write-Log "Unbekannter Mode: $($App.Mode)"
            }
        }

        Write-Log "Erfolgreich"
    }
    catch
    {
        Write-Log "FEHLER: $_"
    }
}

Write-Log ""
Write-Log "WinGet Updates abgeschlossen"

exit 0