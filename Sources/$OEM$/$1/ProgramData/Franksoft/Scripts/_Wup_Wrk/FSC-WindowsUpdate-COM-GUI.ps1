# ============================================================================
# FSC-WindowsUpdate-COM-GUI.ps1
# Windows Update GUI via Microsoft Update COM API
# Ohne PSWindowsUpdate Modul
# Franksoft Beispiel V1
# ============================================================================

Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase
Add-Type -AssemblyName System.Xaml

# Muss als Administrator laufen
$IsAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $IsAdmin) {
    [System.Windows.MessageBox]::Show("Bitte als Administrator starten.", "Windows Update COM GUI", "OK", "Warning") | Out-Null
    exit 1
}

$Script:UpdateResult = $null
$Script:UpdateItems  = @()
$Script:RebootRequired = $false

$Xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Franksoft Windows Update COM GUI"
        Width="1050" Height="720"
        WindowStartupLocation="CenterScreen"
        Background="#F4F6F8"
        FontFamily="Segoe UI"
        FontSize="13">

    <Grid Margin="14">
        <Grid.RowDefinitions>
            <RowDefinition Height="74"/>
            <RowDefinition Height="34"/>
            <RowDefinition Height="*"/>
            <RowDefinition Height="150"/>
            <RowDefinition Height="32"/>
        </Grid.RowDefinitions>

        <!-- Top Buttons -->
        <Border Grid.Row="0" Background="White" CornerRadius="12" BorderBrush="#D8DEE9" BorderThickness="1" Padding="10">
            <Grid>
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="*"/>
                </Grid.ColumnDefinitions>

                <Button x:Name="BtnScan" Grid.Column="0" Margin="6" Content="🔍  Updates suchen" Height="44"/>
                <Button x:Name="BtnDownload" Grid.Column="1" Margin="6" Content="⬇  Download" Height="44" IsEnabled="False"/>
                <Button x:Name="BtnInstall" Grid.Column="2" Margin="6" Content="⚙  Installieren" Height="44" IsEnabled="False"/>
                <Button x:Name="BtnReboot" Grid.Column="3" Margin="6" Content="↻  Neustart" Height="44" IsEnabled="False"/>
                <Button x:Name="BtnClose" Grid.Column="4" Margin="6" Content="Schliessen" Height="44"/>
            </Grid>
        </Border>

        <!-- Status -->
        <Border Grid.Row="1" Margin="0,8,0,8" Background="White" CornerRadius="8" BorderBrush="#D8DEE9" BorderThickness="1">
            <TextBlock x:Name="TxtStatus" Text="Bereit" VerticalAlignment="Center" Margin="12,0,0,0" FontWeight="SemiBold"/>
        </Border>

        <!-- Update List -->
        <Border Grid.Row="2" Background="White" CornerRadius="12" BorderBrush="#D8DEE9" BorderThickness="1" Padding="8">
            <DataGrid x:Name="GridUpdates"
                      AutoGenerateColumns="False"
                      CanUserAddRows="False"
                      CanUserDeleteRows="False"
                      HeadersVisibility="Column"
                      GridLinesVisibility="Horizontal"
                      SelectionMode="Single"
                      IsReadOnly="False">
                <DataGrid.Columns>
                    <DataGridCheckBoxColumn Header="Auswahl" Binding="{Binding Selected}" Width="70"/>
                    <DataGridTextColumn Header="Titel" Binding="{Binding Title}" Width="*" IsReadOnly="True"/>
                    <DataGridTextColumn Header="KB" Binding="{Binding KB}" Width="110" IsReadOnly="True"/>
                    <DataGridTextColumn Header="Kategorie" Binding="{Binding Category}" Width="160" IsReadOnly="True"/>
                    <DataGridTextColumn Header="Grösse" Binding="{Binding Size}" Width="100" IsReadOnly="True"/>
                    <DataGridTextColumn Header="Status" Binding="{Binding Status}" Width="130" IsReadOnly="True"/>
                </DataGrid.Columns>
            </DataGrid>
        </Border>

        <!-- Log -->
        <Border Grid.Row="3" Margin="0,10,0,0" Background="White" CornerRadius="12" BorderBrush="#D8DEE9" BorderThickness="1" Padding="8">
            <Grid>
                <Grid.RowDefinitions>
                    <RowDefinition Height="24"/>
                    <RowDefinition Height="*"/>
                </Grid.RowDefinitions>
                <TextBlock Text="Verlauf / Protokoll" FontWeight="Bold"/>
                <TextBox x:Name="TxtLog" Grid.Row="1" IsReadOnly="True" TextWrapping="Wrap" VerticalScrollBarVisibility="Auto" BorderThickness="0" FontFamily="Consolas"/>
            </Grid>
        </Border>

        <!-- Bottom -->
        <Grid Grid.Row="4" Margin="0,8,0,0">
            <Grid.ColumnDefinitions>
                <ColumnDefinition Width="*"/>
                <ColumnDefinition Width="240"/>
            </Grid.ColumnDefinitions>
            <TextBlock x:Name="TxtReady" Text="● Bereit" VerticalAlignment="Center" Foreground="#258A2F" FontWeight="SemiBold"/>
            <TextBlock x:Name="TxtReboot" Grid.Column="1" Text="Reboot erforderlich: Nein" VerticalAlignment="Center" HorizontalAlignment="Right" FontWeight="SemiBold"/>
        </Grid>
    </Grid>
</Window>
"@

$Reader = New-Object System.Xml.XmlNodeReader ([xml]$Xaml)
$Window = [Windows.Markup.XamlReader]::Load($Reader)

$BtnScan     = $Window.FindName("BtnScan")
$BtnDownload = $Window.FindName("BtnDownload")
$BtnInstall  = $Window.FindName("BtnInstall")
$BtnReboot   = $Window.FindName("BtnReboot")
$BtnClose    = $Window.FindName("BtnClose")
$TxtStatus   = $Window.FindName("TxtStatus")
$TxtLog      = $Window.FindName("TxtLog")
$GridUpdates = $Window.FindName("GridUpdates")
$TxtReboot   = $Window.FindName("TxtReboot")

function Write-GuiLog {
    param([string]$Text)
    $Stamp = Get-Date -Format "dd.MM.yyyy HH:mm:ss"
    $TxtLog.AppendText("[$Stamp] $Text`r`n")
    $TxtLog.ScrollToEnd()
}

function Set-UiBusy {
    param([bool]$Busy, [string]$Status)
    $TxtStatus.Text = $Status
    $BtnScan.IsEnabled = -not $Busy
    $BtnDownload.IsEnabled = (-not $Busy -and $Script:UpdateItems.Count -gt 0)
    $BtnInstall.IsEnabled  = (-not $Busy -and $Script:UpdateItems.Count -gt 0)
}

function Get-UpdateSizeText {
    param($Update)
    try {
        $Bytes = [double]$Update.MaxDownloadSize
        if ($Bytes -ge 1GB) { return ("{0:N2} GB" -f ($Bytes / 1GB)) }
        if ($Bytes -ge 1MB) { return ("{0:N1} MB" -f ($Bytes / 1MB)) }
        if ($Bytes -ge 1KB) { return ("{0:N0} KB" -f ($Bytes / 1KB)) }
        return "$Bytes B"
    } catch {
        return ""
    }
}

function Get-KBText {
    param($Update)
    try {
        if ($Update.KBArticleIDs.Count -gt 0) {
            return (($Update.KBArticleIDs | ForEach-Object { "KB$_" }) -join ", ")
        }
    } catch {}
    return ""
}

function Get-CategoryText {
    param($Update)
    try {
        if ($Update.Categories.Count -gt 0) {
            return $Update.Categories.Item(0).Name
        }
    } catch {}
    return ""
}

function Get-SelectedUpdateCollection {
    $Collection = New-Object -ComObject Microsoft.Update.UpdateColl

    foreach ($Item in $Script:UpdateItems) {
        if ($Item.Selected -eq $true) {
            [void]$Collection.Add($Item.ComObject)
        }
    }

    return $Collection
}

$BtnScan.Add_Click({
    try {
        Set-UiBusy $true "Suche nach Updates..."
        Write-GuiLog "Suche nach Windows Updates gestartet."

        $Session = New-Object -ComObject Microsoft.Update.Session
        $Searcher = $Session.CreateUpdateSearcher()

        # Software + Treiber, nicht installiert, nicht versteckt
        $Criteria = "IsInstalled=0 and IsHidden=0"
        $Result = $Searcher.Search($Criteria)
        $Script:UpdateResult = $Result
        $Script:UpdateItems = @()

        for ($i = 0; $i -lt $Result.Updates.Count; $i++) {
            $U = $Result.Updates.Item($i)

            $Script:UpdateItems += [PSCustomObject]@{
                Selected = $true
                Title    = $U.Title
                KB       = Get-KBText $U
                Category = Get-CategoryText $U
                Size     = Get-UpdateSizeText $U
                Status   = "Nicht installiert"
                ComObject = $U
            }
        }

        $GridUpdates.ItemsSource = $null
        $GridUpdates.ItemsSource = $Script:UpdateItems

        Write-GuiLog "$($Script:UpdateItems.Count) Updates gefunden."
        $TxtStatus.Text = "Suche abgeschlossen. $($Script:UpdateItems.Count) Updates gefunden."
    }
    catch {
        Write-GuiLog "FEHLER bei Suche: $($_.Exception.Message)"
        $TxtStatus.Text = "Fehler bei Suche"
    }
    finally {
        Set-UiBusy $false $TxtStatus.Text
    }
})

$BtnDownload.Add_Click({
    try {
        $GridUpdates.CommitEdit() | Out-Null
        $GridUpdates.Items.Refresh()

        $Collection = Get-SelectedUpdateCollection
        if ($Collection.Count -eq 0) {
            [System.Windows.MessageBox]::Show("Keine Updates ausgewählt.", "Download", "OK", "Information") | Out-Null
            return
        }

        Set-UiBusy $true "Download läuft..."
        Write-GuiLog "Download von $($Collection.Count) Updates gestartet."

        $Session = New-Object -ComObject Microsoft.Update.Session
        $Downloader = $Session.CreateUpdateDownloader()
        $Downloader.Updates = $Collection
        $DownloadResult = $Downloader.Download()

        Write-GuiLog "Download abgeschlossen. ResultCode: $($DownloadResult.ResultCode)"
        $TxtStatus.Text = "Download abgeschlossen."
    }
    catch {
        Write-GuiLog "FEHLER bei Download: $($_.Exception.Message)"
        $TxtStatus.Text = "Fehler bei Download"
    }
    finally {
        Set-UiBusy $false $TxtStatus.Text
    }
})

$BtnInstall.Add_Click({
    try {
        $GridUpdates.CommitEdit() | Out-Null
        $GridUpdates.Items.Refresh()

        $Collection = Get-SelectedUpdateCollection
        if ($Collection.Count -eq 0) {
            [System.Windows.MessageBox]::Show("Keine Updates ausgewählt.", "Installation", "OK", "Information") | Out-Null
            return
        }

        Set-UiBusy $true "Installation läuft..."
        Write-GuiLog "Installation von $($Collection.Count) Updates gestartet."

        $Session = New-Object -ComObject Microsoft.Update.Session
        $Installer = $Session.CreateUpdateInstaller()
        $Installer.Updates = $Collection
        $InstallResult = $Installer.Install()

        $Script:RebootRequired = [bool]$InstallResult.RebootRequired
        $TxtReboot.Text = "Reboot erforderlich: " + $(if ($Script:RebootRequired) { "Ja" } else { "Nein" })
        $BtnReboot.IsEnabled = $Script:RebootRequired

        Write-GuiLog "Installation abgeschlossen. ResultCode: $($InstallResult.ResultCode), RebootRequired: $($InstallResult.RebootRequired)"
        $TxtStatus.Text = "Installation abgeschlossen."
    }
    catch {
        Write-GuiLog "FEHLER bei Installation: $($_.Exception.Message)"
        $TxtStatus.Text = "Fehler bei Installation"
    }
    finally {
        Set-UiBusy $false $TxtStatus.Text
    }
})

$BtnReboot.Add_Click({
    $Answer = [System.Windows.MessageBox]::Show("Computer jetzt neu starten?", "Neustart", "YesNo", "Question")
    if ($Answer -eq "Yes") {
        Restart-Computer -Force
    }
})

$BtnClose.Add_Click({
    $Window.Close()
})

Write-GuiLog "GUI gestartet. COM API bereit."
[void]$Window.ShowDialog()
