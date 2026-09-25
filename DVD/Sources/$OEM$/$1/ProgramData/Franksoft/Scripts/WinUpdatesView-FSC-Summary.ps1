# ==================================================================================================
# Script Name : FSC-WinUpdatesView-Summary.ps1
# Version     : 1.0
# Date        : 15.06.2026
# Author      : Franksoft
# Purpose     : Aktuelles WinUpdatesView_after_*.txt auswerten, Summary schreiben und Registry fuellen
# ==================================================================================================

[CmdletBinding()]
param(
    [string]$LogDir = "$env:ProgramData\Franksoft\Logs",
    [string]$Pattern = "WinUpdatesView_after_*.txt"
)

$ErrorActionPreference = "Continue"

$RegPath = "HKLM:\SOFTWARE\Franksoft\WindowsUpdate"
$SummaryFile = Join-Path $LogDir "WinUpdatesView_Summary.txt"

function Write-FSLine {
    param([string]$Text)
    $Text | Out-File -FilePath $SummaryFile -Append -Encoding UTF8
}

function Get-FieldValue {
    param(
        [string[]]$Block,
        [string]$Name
    )

    $Line = $Block | Where-Object { $_ -match "^\s*$([regex]::Escape($Name))\s*:" } | Select-Object -First 1
    if (-not $Line) { return "" }

    return (($Line -split ":", 2)[1]).Trim()
}

try {
    if (-not (Test-Path $LogDir)) {
        New-Item -Path $LogDir -ItemType Directory -Force | Out-Null
    }

    $File = Get-ChildItem -Path $LogDir -Filter $Pattern -File -ErrorAction SilentlyContinue |
        Sort-Object LastWriteTime -Descending |
        Select-Object -First 1

    if (-not $File) {
        throw "Keine Datei gefunden: $LogDir\$Pattern"
    }

    $Raw = Get-Content -Path $File.FullName -Encoding UTF8 -ErrorAction Stop

    $Blocks = @()
    $Current = New-Object System.Collections.Generic.List[string]

    foreach ($Line in $Raw) {
        if ($Line -match "^=+$") {
            if ($Current.Count -gt 0) {
                $Blocks += ,@($Current)
                $Current.Clear()
            }
        }
        else {
            if (-not [string]::IsNullOrWhiteSpace($Line)) {
                $Current.Add($Line)
            }
        }
    }

    if ($Current.Count -gt 0) {
        $Blocks += ,@($Current)
    }

    $Items = foreach ($Block in $Blocks) {
        $Title  = Get-FieldValue -Block $Block -Name "Title"
        if ([string]::IsNullOrWhiteSpace($Title)) { continue }

        $KB     = Get-FieldValue -Block $Block -Name "KB Number"
        $Date   = Get-FieldValue -Block $Block -Name "Install Date"
        $Result = Get-FieldValue -Block $Block -Name "Operation Result"
        $Client = Get-FieldValue -Block $Block -Name "Client Application ID"
        $Cat    = Get-FieldValue -Block $Block -Name "Category"
        $Desc   = Get-FieldValue -Block $Block -Name "Description"
        $HRes   = Get-FieldValue -Block $Block -Name "hResult"

        $Type = "Microsoft"

        if ($Title -match "Driver|Treiber|Intel|Realtek|HP Inc\.|HP Development|ELAN|HIDClass|Extension|SoftwareComponent|Firmware|Bluetooth|AudioProcessingObject|Keyboard|net|System" -or
            $Client -match "Device Driver Retrieval Client") {
            $Type = "Driver"
        }

        if ($Title -match "Defender|Security Intelligence|Antischadsoftware|KB2267602|KB4052623" -or
            $Cat -match "Defender") {
            $Type = "Defender"
        }

        if ($Title -match "Windows Security platform|KB5007651") {
            $Type = "SecurityPlatform"
        }

        if ($Client -match "Acquisition|DSIC|StartProductInstall") {
            $Type = "Store/App"
        }

        [PSCustomObject]@{
            Title  = $Title
            KB     = $KB
            Date   = $Date
            Result = $Result
            Type   = $Type
            Client = $Client
            HResult = $HRes
        }
    }

    $Total      = @($Items).Count
    $Succeeded  = @($Items | Where-Object { $_.Result -eq "Succeeded" }).Count
    $Failed     = @($Items | Where-Object { $_.Result -eq "Failed" }).Count
    $InProgress = @($Items | Where-Object { $_.Result -eq "In Progress" }).Count

    $MSCount       = @($Items | Where-Object { $_.Type -eq "Microsoft" }).Count
    $DriverCount   = @($Items | Where-Object { $_.Type -eq "Driver" }).Count
    $DefenderCount = @($Items | Where-Object { $_.Type -eq "Defender" }).Count
    $SecurityCount = @($Items | Where-Object { $_.Type -eq "SecurityPlatform" }).Count
    $StoreCount    = @($Items | Where-Object { $_.Type -eq "Store/App" }).Count

    if (Test-Path $SummaryFile) {
        Remove-Item $SummaryFile -Force -ErrorAction SilentlyContinue
    }

    Write-FSLine "============================================================"
    Write-FSLine "Franksoft WinUpdatesView Summary"
    Write-FSLine "============================================================"
    Write-FSLine "Datei        : $($File.FullName)"
    Write-FSLine "Zeit         : $(Get-Date -Format 'dd.MM.yyyy HH:mm:ss')"
    Write-FSLine ""
    Write-FSLine "Total        : $Total"
    Write-FSLine "Succeeded    : $Succeeded"
    Write-FSLine "Failed       : $Failed"
    Write-FSLine "In Progress  : $InProgress"
    Write-FSLine ""
    Write-FSLine "Microsoft    : $MSCount"
    Write-FSLine "Driver       : $DriverCount"
    Write-FSLine "Defender     : $DefenderCount"
    Write-FSLine "SecurityPlat : $SecurityCount"
    Write-FSLine "Store/App    : $StoreCount"
    Write-FSLine ""

    Write-FSLine "------------------------------------------------------------"
    Write-FSLine "Failed / In Progress"
    Write-FSLine "------------------------------------------------------------"
    $Bad = @($Items | Where-Object { $_.Result -ne "Succeeded" })
    if ($Bad.Count -eq 0) {
        Write-FSLine "Keine Fehler."
    }
    else {
        foreach ($Item in $Bad) {
            Write-FSLine "$($Item.Result) | $($Item.HResult) | $($Item.KB) | $($Item.Title)"
        }
    }

    Write-FSLine ""
    Write-FSLine "------------------------------------------------------------"
    Write-FSLine "Succeeded Updates"
    Write-FSLine "------------------------------------------------------------"
    foreach ($Item in ($Items | Where-Object { $_.Result -eq "Succeeded" })) {
        $KBText = if ([string]::IsNullOrWhiteSpace($Item.KB)) { "-" } else { $Item.KB }
        Write-FSLine "$($Item.Type) | $KBText | $($Item.Date) | $($Item.Title)"
    }

    New-Item -Path $RegPath -Force | Out-Null

    New-ItemProperty -Path $RegPath -Name "WU_TotalUpdates"      -Value $Total         -PropertyType DWord  -Force | Out-Null
    New-ItemProperty -Path $RegPath -Name "WU_SucceededUpdates"  -Value $Succeeded     -PropertyType DWord  -Force | Out-Null
    New-ItemProperty -Path $RegPath -Name "WU_FailedUpdates"     -Value $Failed        -PropertyType DWord  -Force | Out-Null
    New-ItemProperty -Path $RegPath -Name "WU_InProgressUpdates" -Value $InProgress    -PropertyType DWord  -Force | Out-Null
    New-ItemProperty -Path $RegPath -Name "WU_MicrosoftUpdates"  -Value $MSCount       -PropertyType DWord  -Force | Out-Null
    New-ItemProperty -Path $RegPath -Name "WU_DriverUpdates"     -Value $DriverCount   -PropertyType DWord  -Force | Out-Null
    New-ItemProperty -Path $RegPath -Name "WU_DefenderUpdates"   -Value $DefenderCount -PropertyType DWord  -Force | Out-Null
    New-ItemProperty -Path $RegPath -Name "WU_SecurityPlatform"  -Value $SecurityCount -PropertyType DWord  -Force | Out-Null
    New-ItemProperty -Path $RegPath -Name "WU_StoreAppUpdates"   -Value $StoreCount    -PropertyType DWord  -Force | Out-Null
    New-ItemProperty -Path $RegPath -Name "WU_LastSummaryFile"   -Value $SummaryFile   -PropertyType String -Force | Out-Null
    New-ItemProperty -Path $RegPath -Name "WU_LastSourceFile"    -Value $File.FullName -PropertyType String -Force | Out-Null
    New-ItemProperty -Path $RegPath -Name "WU_LastSummaryTime"   -Value (Get-Date -Format "dd.MM.yyyy HH:mm:ss") -PropertyType String -Force | Out-Null

    Write-Host "Summary erstellt: $SummaryFile"
    Write-Host "Registry aktualisiert: $RegPath"
    exit 0
}
catch {
    if (-not (Test-Path $LogDir)) {
        New-Item -Path $LogDir -ItemType Directory -Force | Out-Null
    }

    "FEHLER: $($_.Exception.Message)" | Out-File -FilePath $SummaryFile -Encoding UTF8
    Write-Host "FEHLER: $($_.Exception.Message)"
    exit 1
}
