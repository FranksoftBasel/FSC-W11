# ============================================================================
# WinGetUpdate_FSC.ps1
# Franksoft Client Deployment
# ============================================================================
# Modules: WinGetApps.json, WinGetUpdate_FSC.cmd
# Liest WinGetApps.json ein
# Mode=install -> winget install
# Mode=update  -> winget upgrade
#
# ============================================================================

$JsonFile = "$env:ProgramData\Franksoft\Scripts\WinGetApps.json"
$LogFile  = "$env:ProgramData\Franksoft\Logs\WinGetUpdate_FSC.log"

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
                winget upgrade `
                    --id "$($App.Id)" `
                    --exact `
                    --source winget `
                    --accept-source-agreements `
                    --disable-interactivity `
                    --silent `
                    --include-unknown `
                    --accept-package-agreements `
                    --force
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