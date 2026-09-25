Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Hardware Infos
$cs   = Get-CimInstance Win32_ComputerSystem
$cp   = Get-CimInstance Win32_ComputerSystemProduct

$bios = Get-CimInstance Win32_BIOS
if ($bios.SerialNumber) {
    Set-Clipboard -Value $bios.SerialNumber
}

$cpu  = Get-CimInstance Win32_Processor | Select-Object -First 1
$gpu  = Get-CimInstance Win32_VideoController | Select-Object -First 1
$os   = Get-CimInstance Win32_OperatingSystem

# Franksoft InstallDate aus Registry
$InstallDateRaw = (Get-ItemProperty `
    "HKLM:\SOFTWARE\Franksoft\Client Info" `
    -ErrorAction SilentlyContinue).InstallDate

if ($InstallDateRaw) {
    $dt = [datetime]::ParseExact(
        $InstallDateRaw,
        "MM/dd/yyyy HH:mm:ss",
        $null
    )

    $InstallDate = $dt.ToString("dd.MM.yyyy")
    $InstallTime = $dt.ToString("HH:mm")
}
else {
    $InstallDate = "Unbekannt"
    $InstallTime = "-"
}

# RAM / VRAM
$ramGB = [math]::Round(([double]$cs.TotalPhysicalMemory / 1GB), 2)

if ($gpu.AdapterRAM) {
    $vramText = "$([math]::Round(([double]$gpu.AdapterRAM / 1MB),0)) MB"
}
else {
    $vramText = "Unbekannt"
}

# Fenster
$form = New-Object System.Windows.Forms.Form
$form.Text = "Franksoft Client Information"
$form.Width = 700
$form.StartPosition = "CenterScreen"
$form.BackColor = [System.Drawing.Color]::White
$form.Font = New-Object System.Drawing.Font("Segoe UI",11)
$form.TopMost = $true

$main = New-Object System.Windows.Forms.Panel
$main.Dock = "Fill"
$main.AutoScroll = $false
$main.Padding = New-Object System.Windows.Forms.Padding(35,20,35,20)
$form.Controls.Add($main)

$script:y = 20
$blue = [System.Drawing.Color]::FromArgb(0,91,170)

function Add-Label {
    param(
        $text,$x,$y,$w,$h,
        $bold=$false,
        $color=$null
    )

    $lbl = New-Object System.Windows.Forms.Label
    $lbl.Text = "$text"
    $lbl.Location = New-Object System.Drawing.Point($x,$y)
    $lbl.Size = New-Object System.Drawing.Size($w,$h)

    $style = if($bold){
        [System.Drawing.FontStyle]::Bold
    } else {
        [System.Drawing.FontStyle]::Regular
    }

    $lbl.Font = New-Object System.Drawing.Font("Segoe UI",11,$style)

    if($color){
        $lbl.ForeColor = $color
    }

    $main.Controls.Add($lbl)
}

function Add-Section {
    param(
        [string]$title,
        [object[]]$rows
    )

    Add-Label $title.ToUpper() 70 $script:y 250 22 $true $blue
    $script:y += 26

    foreach ($row in $rows) {
        Add-Label $row.Name 70 $script:y 180 22
        Add-Label ":" 255 $script:y 15 22
        Add-Label $row.Value 280 $script:y 380 22

        $script:y += 24
    }

    $script:y += 4

    $line = New-Object System.Windows.Forms.Panel
    $line.BackColor = [System.Drawing.Color]::FromArgb(190,210,235)
    $line.Location = New-Object System.Drawing.Point(70,$script:y)
    $line.Size = New-Object System.Drawing.Size(560,1)
    $main.Controls.Add($line)

    $script:y += 14
}

# Sections
Add-Section "Computer" @(
    [pscustomobject]@{Name="Hersteller"; Value=$cs.Manufacturer}
    [pscustomobject]@{Name="Modell"; Value=$cs.Model}
    [pscustomobject]@{Name="UUID"; Value=$cp.UUID}
)

Add-Section "Windows" @(
    [pscustomobject]@{Name="Name"; Value=$os.Caption}
    [pscustomobject]@{Name="Version"; Value=$os.Version}
    [pscustomobject]@{Name="Build"; Value=$os.BuildNumber}
    [pscustomobject]@{Name="Install Date"; Value=$InstallDate}
    [pscustomobject]@{Name="Install Time"; Value=$InstallTime}
)

Add-Section "BIOS" @(
    [pscustomobject]@{Name="Version"; Value=$bios.SMBIOSBIOSVersion}
    [pscustomobject]@{Name="Seriennummer"; Value=$bios.SerialNumber}
)

Add-Section "CPU" @(
    [pscustomobject]@{Name="Name"; Value=$cpu.Name}
    [pscustomobject]@{Name="Takt"; Value="$($cpu.CurrentClockSpeed) MHz"}
)

Add-Section "RAM" @(
    [pscustomobject]@{Name="Installiert"; Value="$ramGB GB"}
)

Add-Section "Grafik" @(
    [pscustomobject]@{Name="Name"; Value=$gpu.Name}
    [pscustomobject]@{Name="Treiber"; Value=$gpu.DriverVersion}
    [pscustomobject]@{Name="Speicher"; Value=$vramText}
    [pscustomobject]@{
        Name="Aufloesung"
        Value="$($gpu.CurrentHorizontalResolution) x $($gpu.CurrentVerticalResolution)"
    }
)

$form.Height = $script:y + 70
[void]$form.ShowDialog()