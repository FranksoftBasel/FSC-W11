# Get-WindowsUpdateHistory.ps1

$DateStamp = Get-Date -Format "dd.MM.yyyy_HH-mm-ss"
$LogFile = "$PSScriptRoot\WindowsUpdateHistory_$DateStamp.log"

$StartTime = Get-Date -Format "dd.MM.yyyy HH:mm:ss"

Add-Content -Path $LogFile -Value "=================================================="
Add-Content -Path $LogFile -Value "Windows Update History Export gestartet: $StartTime"
Add-Content -Path $LogFile -Value "=================================================="

Get-WUHistory |
Where-Object { $_.Result -eq "Succeeded" } |
Select-Object Date, Title, Result |
ForEach-Object {

    $Line = "{0} | {1} | {2}" -f `
        $_.Date.ToString("dd.MM.yyyy HH:mm:ss"),
        $_.Result,
        $_.Title

    Write-Host $Line
    Add-Content -Path $LogFile -Value $Line
}

$EndTime = Get-Date -Format "dd.MM.yyyy HH:mm:ss"

Add-Content -Path $LogFile -Value ""
Add-Content -Path $LogFile -Value "Export beendet: $EndTime"
Add-Content -Path $LogFile -Value ""

Write-Host ""
Write-Host "Logdatei erstellt:"
Write-Host $LogFile