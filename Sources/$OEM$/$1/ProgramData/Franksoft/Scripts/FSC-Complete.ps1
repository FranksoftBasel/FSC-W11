# =============================================================================
# Script Name : FSC-Complete.ps1
# Version     : 2.2
# Date        : 21.09.2026
# Author      : Franksoft
#
# Purpose     : Franksoft Client Deployment Abschlussdialog
#
# Features:
# - Windows Setup Zeit aus Registry
# - Franksoft Deployment Zeit aus Registry
# - Windows Update Zeit aus Registry
# - Gesamtdauer Berechnung
# - Hardware Modell + RAM Anzeige
# - Windows Update Status
# - Installationslog Link
# - ESC = OK Funktion
#
# Registry:
# HKLM\SOFTWARE\Franksoft\Setup
# HKLM\SOFTWARE\Franksoft\WindowsUpdate
#
# Franksoft Client Deployment 1997-2026
# =============================================================================


Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName WindowsBase

$timestamp = Get-Date -Format "dddd, dd.MM.yyyy 'um' HH:mm 'Uhr'"


$model = (Get-CimInstance Win32_ComputerSystem).Model
$model = $model -replace ' inch Notebook AI PC',' Zoll'

$ramGB = [math]::Ceiling(
    (Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB
)

$DeviceInfo = "$model | RAM $ramGB GB"


$ClientLogPath = "C:\ProgramData\Franksoft\Logs\Franksoft Client.txt"

# =====================================
# Zeiten aus Registry berechnen
# HKLM\SOFTWARE\Franksoft\Setup
# =====================================

$RegSetupRoot = "HKLM:\SOFTWARE\Franksoft\Setup"

function Convert-FSCDate {
    param([string]$Value)

    if ([string]::IsNullOrWhiteSpace($Value)) {
        return $null
    }

    $Value = $Value.Trim()

    $formats = @(
        "dd.MM.yyyy HH:mm:ss",
        "dd.MM.yyyy HH:mm"
    )

    foreach ($format in $formats) {
        try {
            return [datetime]::ParseExact($Value, $format, $null)
        }
        catch {}
    }

    return $null
}

# Windows Setup:
# PE Start bis SetupComplete Start + 3 Minuten

$WindowsSetupMin = 0

$peRegPath = Join-Path $RegSetupRoot "PE-LogFile.cmd"
$setupCompleteRegPath = Join-Path $RegSetupRoot "SetupComplete.cmd"

if ((Test-Path $peRegPath) -and (Test-Path $setupCompleteRegPath)) {

    $pe = Get-ItemProperty -Path $peRegPath
    $setupComplete = Get-ItemProperty -Path $setupCompleteRegPath

    $setupStart = Convert-FSCDate $pe."Phase 01/07 windowsPE"
    $setupEnd   = Convert-FSCDate $setupComplete.Start

    if ($setupStart -and $setupEnd) {

        $WindowsSetupMin = [math]::Round(
            ($setupEnd - $setupStart).TotalMinutes
        ) + 3

        if ($WindowsSetupMin -lt 0) {
            $WindowsSetupMin = 0
        }
    }
}

# Franksoft Deployment:
# frühester Start aller Keys ohne PE-LogFile.cmd
# bis spätestes End aller Keys ohne PE-LogFile.cmd

# =====================================
# Franksoft Deployment Zeit berechnen
# SetupComplete.cmd Start bis FSC-Post-03.cmd End
# Fallback: FSC-Post-02.cmd, FSC-Post-01.cmd
# OHNE Windows Update / Winget / Defender
# =====================================

$FSCDeploymentMin = 0

$deploymentStart = $null
$deploymentEnd   = $null

$setupCompleteRegPath = Join-Path $RegSetupRoot "SetupComplete.cmd"

if (Test-Path $setupCompleteRegPath) {
    $setupComplete = Get-ItemProperty -Path $setupCompleteRegPath
    $deploymentStart = Convert-FSCDate $setupComplete.Start
}

$PostKeys = @(
    "FSC-Post-03.cmd",
    "FSC-Post-02.cmd",
    "FSC-Post-01.cmd"
)

foreach ($postKey in $PostKeys) {

    $postRegPath = Join-Path $RegSetupRoot $postKey

    if (Test-Path $postRegPath) {
        $postItem = Get-ItemProperty -Path $postRegPath
        $deploymentEnd = Convert-FSCDate $postItem.End

        if ($deploymentEnd) {
            break
        }
    }
}

if ($deploymentStart -and $deploymentEnd) {

    $FSCDeploymentMin = [math]::Round(
        ($deploymentEnd - $deploymentStart).TotalMinutes
    )

    if ($FSCDeploymentMin -lt 0) {
        $FSCDeploymentMin = 0
    }
}

echo "====================================="
echo "FSC Deployment Debug"
echo "Start : $deploymentStart"
echo "Ende  : $deploymentEnd"
echo "Min   : $FSCDeploymentMin"
echo "====================================="

# =====================================
# Windows Update Status aus Registry prüfen
# HKLM\SOFTWARE\Franksoft\WindowsUpdate
# =====================================

$WinUpdStatus = $false
$RegWinUpdateRoot = "HKLM:\SOFTWARE\Franksoft\WindowsUpdate"

if (Test-Path $RegWinUpdateRoot) {

    $wuStatus = Get-ItemProperty -Path $RegWinUpdateRoot

    if ($wuStatus.DeploymentEnd -and ($wuStatus.LastResult -eq "Success")) {
        $WinUpdStatus = $true
        echo "Windows Update Status: erfolgreich abgeschlossen (Registry)"
    }
    else {
        echo "Windows Update Status: nicht erfolgreich abgeschlossen (Registry)"
    }
}
else {
    echo "Windows Update Status: Registry nicht vorhanden"
}

# =====================================
# Windows Update Zeit aus Registry berechnen
# HKLM\SOFTWARE\Franksoft\WindowsUpdate
# =====================================

$WindowsUpdateMin = 0
$WindowsUpdateValueText = "nicht ausgeführt"

echo "====================================="
echo "Windows Update Registry Zeit Debug"
echo "Registry: $RegWinUpdateRoot"
echo "====================================="

if ($WinUpdStatus -and (Test-Path $RegWinUpdateRoot)) {

    $wu = Get-ItemProperty -Path $RegWinUpdateRoot

    $wuStart = Convert-FSCDate $wu.FirstStartPhase01
    $wuEnd   = Convert-FSCDate $wu.LastEndPhase12

    if ($wuStart -and $wuEnd) {

        $WindowsUpdateMin = [math]::Round(
            ($wuEnd - $wuStart).TotalMinutes
        )

        if ($WindowsUpdateMin -lt 0) {
            $WindowsUpdateMin = 0
        }

        $WindowsUpdateValueText = "$WindowsUpdateMin Minuten"

        echo "Windows Update Zeit berechnet"
        echo "Start : $wuStart"
        echo "Ende  : $wuEnd"
        echo "Min   : $WindowsUpdateMin"
    }
    else {
        echo "Windows Update Registry Start oder Ende nicht gefunden."
        $WindowsUpdateMin = 0
        $WindowsUpdateValueText = "nicht gefunden"
    }
}
else {
    echo "Windows Update wurde nicht ausgeführt oder Registry fehlt."
    $WindowsUpdateMin = 0
    $WindowsUpdateValueText = "nicht ausgeführt"
}

# =====================================
# Gesamtdauer
# =====================================

$TotalMin = $WindowsSetupMin + $FSCDeploymentMin

if ($WinUpdStatus) {
    $TotalMin += $WindowsUpdateMin
}

# ============================================================================
# FSC Deployment Report erstellen
# ============================================================================

$ReportScript = "C:\ProgramData\Franksoft\Scripts\FSC-DeploymentReport.ps1"

if (Test-Path $ReportScript) {

    try {

        Start-Process powershell.exe `
            -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$ReportScript`"" `
            -WindowStyle Hidden `
            -Wait

    }
    catch {

        Write-Host "FSC Deployment Report konnte nicht erstellt werden."

    }

}

echo "====================================="
echo "Gesamtdauer Debug"
echo "Windows Setup       : $WindowsSetupMin Minuten"
#echo "Windows Setup       : $([int]$WindowsSetupMin + 5) Minuten"
echo "FSC Deployment      : $FSCDeploymentMin Minuten"
echo "Windows Update      : $WindowsUpdateMin Minuten"
echo "Gesamtdauer         : $TotalMin Minuten"
echo "====================================="

# Höhe und breite
[xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        Title="Franksoft Client Deployment"
        Height="590"
        Width="760"
        WindowStartupLocation="CenterScreen"
        ResizeMode="NoResize"
        Background="#FAFAFA">

    <Grid Margin="34,26,34,22">
        <Grid.RowDefinitions>
            <RowDefinition Height="*" />
            <RowDefinition Height="66" />
        </Grid.RowDefinitions>

        <StackPanel Orientation="Horizontal" Grid.Row="0">

<Image Name="LogoImage"
       Width="92"
       Height="92"
       Margin="0,8,42,0"
       VerticalAlignment="Top"
       Stretch="Uniform"
       Opacity="1"
       RenderOptions.BitmapScalingMode="HighQuality">

    <Image.Effect>
        <DropShadowEffect BlurRadius="22"
                          ShadowDepth="3"
                          Opacity="0.30"
                          Color="#000000"/>
    </Image.Effect>

</Image>
            <StackPanel Width="620" Margin="0,6,0,0">

                <TextBlock FontSize="27" Foreground="#202020" Margin="0,0,0,14">
                    <Run Text="Das Windows 11 Franksoft Client Deployment"/>
                    <LineBreak/>
                    <Run Text="wurde erfolgreich abgeschlossen."/>
                </TextBlock>

                <Border Height="1" Background="#DADADA" Margin="0,0,0,8"/>

<!-- Abschluss Datum -->

<TextBlock FontSize="20"
           Foreground="#202020"
           Margin="0,0,0,8">
    <Run Text="Installation abgeschlossen am"/>
    <LineBreak/>
    <Run Text="$timestamp"/>
</TextBlock>

<!-- Device Info Modell Typ -->

<TextBlock FontSize="16"
           Foreground="#707070"
           Margin="0,2,0,14">
    <Run Text="$DeviceInfo"/>
</TextBlock>

<Border Height="1"
        Background="#DADADA"
        Margin="0,0,0,14"/>

<TextBlock Name="UpdateStatusText"
           FontSize="21"
           Foreground="#202020"
           Margin="0,0,0,10"/>

<Border Height="1"
        Background="#DADADA"
        Margin="0,0,0,10"/>

<Grid Margin="0,0,0,10">
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="52"/>
                        <ColumnDefinition Width="270"/>
                        <ColumnDefinition Width="180"/>
                    </Grid.ColumnDefinitions>

                    <Grid.RowDefinitions>
                        <RowDefinition Height="40"/>
                        <RowDefinition Height="40"/>
                        <RowDefinition Height="40"/>
                    </Grid.RowDefinitions>

                    <TextBlock Grid.Row="0" Grid.Column="0" Text="◷" FontSize="27" Foreground="#0078D7" VerticalAlignment="Center"/>
                    <TextBlock Grid.Row="0" Grid.Column="1" Text="Windows Setup:" FontSize="19" Foreground="#505050" VerticalAlignment="Center"/>
                    <TextBlock Grid.Row="0" Grid.Column="2" Text="$WindowsSetupMin Minuten" FontSize="19" Foreground="#202020" VerticalAlignment="Center"/>

                    <TextBlock Grid.Row="1" Grid.Column="0" Text="▣" FontSize="26" Foreground="#0078D7" VerticalAlignment="Center"/>
                    <TextBlock Grid.Row="1" Grid.Column="1" Text="Franksoft Deployment:" FontSize="19" Foreground="#505050" VerticalAlignment="Center"/>
                    <TextBlock Grid.Row="1" Grid.Column="2" Text="$FSCDeploymentMin Minuten" FontSize="19" Foreground="#202020" VerticalAlignment="Center"/>

                    <TextBlock Grid.Row="2" Grid.Column="0" Text="↻" FontSize="28" Foreground="#0078D7" VerticalAlignment="Center"/>
                    <TextBlock Grid.Row="2" Grid.Column="1" Text="Windows Update:" FontSize="19" Foreground="#505050" VerticalAlignment="Center"/>
                    <TextBlock Grid.Row="2" Grid.Column="2" Text="$WindowsUpdateValueText" FontSize="19" Foreground="#202020" VerticalAlignment="Center"/>
                </Grid>
                
<Border Height="1"
        Background="#DADADA"
        Margin="0,0,0,8"/>

<Grid Margin="0,2,0,4">
    <Grid.ColumnDefinitions>
        <ColumnDefinition Width="322"/>
        <ColumnDefinition Width="180"/>
    </Grid.ColumnDefinitions>

    <TextBlock Grid.Column="0"
               Text="Gesamtdauer:"
               FontSize="21"
               FontWeight="Bold"
               Foreground="#202020"/>

    <TextBlock Grid.Column="1"
               Text="$TotalMin Minuten"
               FontSize="21"
               FontWeight="Bold"
               Foreground="#202020"/>
</Grid>

            </StackPanel>
        </StackPanel>

<TextBlock Name="LogLink"
           Grid.Row="1"
           Text="© Franksoft 1997–2026"
           FontSize="14"
           Foreground="#808080"
           Cursor="Hand"
           VerticalAlignment="Bottom"
           HorizontalAlignment="Left"
           Margin="0,0,0,4"/>

<Button Name="OkButton"
        Grid.Row="1"
        Width="170"
        Height="46"
        HorizontalAlignment="Left"
        VerticalAlignment="Bottom"
        Foreground="White"
        FontSize="18"
        FontWeight="Normal"
        BorderThickness="0"
        Cursor="Hand"
        Margin="430,0,0,0">

    <Button.Effect>
        <DropShadowEffect BlurRadius="14"
                          ShadowDepth="2"
                          Opacity="0.22"
                          Color="#000000"/>
    </Button.Effect>

    <Button.Style>
        <Style TargetType="Button">

            <Setter Property="Template">
                <Setter.Value>

                    <ControlTemplate TargetType="Button">

                        <Border CornerRadius="10"
                                BorderThickness="1">

                            <Border.BorderBrush>
                                <SolidColorBrush Color="#2C7FEA"/>
                            </Border.BorderBrush>

                            <Border.Background>

                                <LinearGradientBrush StartPoint="0,0"
                                                     EndPoint="0,1">

                                    <GradientStop Color="#1E90FF"
                                                  Offset="0"/>

                                    <GradientStop Color="#0066E6"
                                                  Offset="0.5"/>

                                    <GradientStop Color="#0052CC"
                                                  Offset="1"/>

                                </LinearGradientBrush>

                            </Border.Background>

                            <ContentPresenter HorizontalAlignment="Center"
                                              VerticalAlignment="Center"/>

                        </Border>

                    </ControlTemplate>

                </Setter.Value>
            </Setter>

            <Style.Triggers>

                <!-- Hover -->
                <Trigger Property="IsMouseOver"
                         Value="True">

                    <Setter Property="Opacity"
                            Value="0.94"/>

                </Trigger>

                <!-- Pressed -->
                <Trigger Property="IsPressed"
                         Value="True">

                    <Setter Property="Opacity"
                            Value="0.82"/>

                </Trigger>

            </Style.Triggers>

        </Style>
    </Button.Style>

    OK
</Button>
    </Grid>
</Window>
"@

$reader = New-Object System.Xml.XmlNodeReader $xaml
$window = [Windows.Markup.XamlReader]::Load($reader)

# Fensterhöhe bleibt aus XAML (620), damit Gesamtdauer sichtbar bleibt

if ([string]::IsNullOrWhiteSpace($PSScriptRoot)) {
    $scriptRootSafe = Split-Path -Parent $MyInvocation.MyCommand.Path
}
else {
    $scriptRootSafe = $PSScriptRoot
}

if ([string]::IsNullOrWhiteSpace($scriptRootSafe)) {
    $scriptRootSafe = Get-Location
}

$logoPath = Join-Path $scriptRootSafe "Franksoft.png"

echo "Logo Pfad: $logoPath"

if (Test-Path $logoPath) {
    $bitmap = New-Object System.Windows.Media.Imaging.BitmapImage
    $bitmap.BeginInit()
    $bitmap.UriSource = New-Object System.Uri($logoPath, [System.UriKind]::Absolute)
    $bitmap.CacheOption = [System.Windows.Media.Imaging.BitmapCacheOption]::OnLoad
    $bitmap.EndInit()

    $window.FindName("LogoImage").Source = $bitmap
}
else {
    echo "Logo nicht gefunden: $logoPath"
}

$updateText = $window.FindName("UpdateStatusText")
$updateText.Inlines.Add("Windows Update: ")

if ($WinUpdStatus) {
    $bold = New-Object System.Windows.Documents.Run("erfolgreich abgeschlossen.")
    $bold.FontWeight = "Bold"
    $updateText.Inlines.Add($bold)

}
else {
    $bold = New-Object System.Windows.Documents.Run("nicht ausgeführt.")
    $bold.FontWeight = "Bold"
    $updateText.Inlines.Add($bold)
}


# Log-Link unten links
$LogLink = $window.FindName("LogLink")

$LogLink.Add_MouseLeftButtonUp({
    $LogFile = "C:\ProgramData\Franksoft\Logs\Franksoft Client.txt"

    if (Test-Path $LogFile) {
        Start-Process explorer.exe "/select,`"$LogFile`""
    }
    else {
        Start-Process explorer.exe "C:\ProgramData\Franksoft\Logs"
    }
})

$okButton = $window.FindName("OkButton")

function Close-FSC {

    cmd /c "rd /s /q c:\Temp"
    cmd /c "md c:\Temp"

    $cleanupScript = "C:\ProgramData\Franksoft\Scripts\_Del-FSC-RT-Scr.cmd"

    if (Test-Path $cleanupScript) {
        Start-Process -FilePath "cmd.exe" `
            -WindowStyle Hidden `
            -ArgumentList "/c `"$cleanupScript`""
    }

    $window.Close()
}

$okButton.Add_Click({
    Close-FSC
})

$window.Add_KeyDown({

    if ($_.Key -eq "Escape") {
        Close-FSC
    }

})

# ============================================================================
# FSC Screenshot im Hintergrund starten
# ============================================================================
$ScreenshotScript = "C:\ProgramData\Franksoft\Scripts\FSC-Screenshot.ps1"

if (Test-Path $ScreenshotScript) {
    Start-Process powershell.exe `
        -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$ScreenshotScript`"" `
        -WindowStyle Hidden
}

$window.ShowDialog() | Out-Null