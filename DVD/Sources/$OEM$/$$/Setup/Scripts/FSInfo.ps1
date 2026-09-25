# Franksoft Client / Hardware Info
# Modernisierte PowerShell-Version

$ErrorActionPreference = "SilentlyContinue"

$BasePath = "HKLM:\SOFTWARE\Franksoft"
$ClientPath = "$BasePath\Client Info"
$HwPath = "$BasePath\HW Setup"
$OemInfoPath = "HKLM:\Software\Microsoft\Windows\CurrentVersion\OEMInformation"

function Set-RegValue {
    param (
        [string]$Path,
        [string]$Name,
        [object]$Value
    )

    if (-not (Test-Path $Path)) {
        New-Item -Path $Path -Force | Out-Null
    }

    New-ItemProperty -Path $Path -Name $Name -Value "$Value" -PropertyType String -Force | Out-Null
}

# Client Info
$Release = $env:fsrel

Set-RegValue $ClientPath "Release" "Franksoft Windows 11 Client 2026"
# Set-RegValue $ClientPath "Release" "Microsoft $Release"
Set-RegValue $ClientPath "Url" "Http://www.Franksoft.Net"
Set-RegValue $ClientPath "Mail" "Info@Franksoft.Net"
Set-RegValue $ClientPath "Author" "Frank/Franksoft"
Set-RegValue $ClientPath "InstallDate" (Get-Date)

# Computer System
$ComputerSystem = Get-CimInstance Win32_ComputerSystem
$Model = "$($ComputerSystem.Manufacturer.Trim()) $($ComputerSystem.Model.Trim())"

Set-RegValue $HwPath "Hardware Model" $Model
Set-RegValue $OemInfoPath "Model" $Model

# UUID
$ComputerProduct = Get-CimInstance Win32_ComputerSystemProduct
Set-RegValue $HwPath "UUID" $ComputerProduct.UUID

# RAM - installierter RAM
$RamGB = [math]::Round($ComputerSystem.TotalPhysicalMemory / 1GB, 2)
Set-RegValue $HwPath "Total Physical Memory" "$RamGB GB"

# BIOS
$Bios = Get-CimInstance Win32_BIOS
$BiosPath = "$HwPath\Bios"

Set-RegValue $BiosPath "Bios Language" $Bios.CurrentLanguage
Set-RegValue $BiosPath "Bios Languages" ($Bios.ListOfLanguages -join ", ")
Set-RegValue $BiosPath "Bios ReleaseDate" $Bios.ReleaseDate
Set-RegValue $BiosPath "Bios Version" $Bios.SMBIOSBIOSVersion
Set-RegValue $BiosPath "SerialNumber" $Bios.SerialNumber

# CPU
$Cpu = Get-CimInstance Win32_Processor | Select-Object -First 1
Set-RegValue $HwPath "Processor" "$($Cpu.Name.Trim()) $($Cpu.CurrentClockSpeed)MHz"

# Video Card
$Video = Get-CimInstance Win32_VideoController | Select-Object -First 1
$VideoPath = "$HwPath\Video Card"
$DisplayPath = "$HwPath\Display"

$VideoMemoryMB = [math]::Round($Video.AdapterRAM / 1MB, 0)

Set-RegValue $VideoPath "Name" $Video.Name
Set-RegValue $VideoPath "DriverVersion" $Video.DriverVersion
Set-RegValue $VideoPath "Video Memory" "$VideoMemoryMB mb"
Set-RegValue $VideoPath "CurrentBitsPerPixel" $Video.CurrentBitsPerPixel
Set-RegValue $VideoPath "DeviceName" $Video.Caption

# Display
Set-RegValue $DisplayPath "Resolution Horizontal" $Video.CurrentHorizontalResolution
Set-RegValue $DisplayPath "Resolution Vertical" $Video.CurrentVerticalResolution
Set-RegValue $DisplayPath "BitsPerPixel" $Video.CurrentBitsPerPixel
Set-RegValue $DisplayPath "VideoMode" $Video.VideoModeDescription
Set-RegValue $DisplayPath "DisplayName" $Video.Name

exit 0