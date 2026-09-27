# ==================================================================================================
# Franksoft - FSC Adobe Acrobat Reader MUI Update Downloader
# Version : 1.5-4
#
# Webzugriff: curl.exe statt Invoke-WebRequest
# Log: C:\ProgramData\Franksoft\Logs\AdobeReaderUpdate.log
#
# Changelog:
#   v1.5-4 - 27.09.2026
#          - Log-Pfad in der finalen Konsolen-Zusammenfassung hinzugefuegt
#
#   v1.5-3 - 27.09.2026
#          - MSI UI von /passive auf /qb! umgestellt
#          - Basic UI mit Fortschrittsanzeige
#          - Cancel-Button wird ausgeblendet
#          - MSIFASTINSTALL=7 und /norestart bleiben erhalten
#
#   v1.5-2 - 27.09.2026
#          - MSIFASTINSTALL=7 zur MSP-Installation hinzugefuegt
#
#   v1.5-1 - 27.09.2026
#          - MSI Installation von /qb- auf /passive umgestellt
#          - Fortschrittsanzeige bleibt sichtbar
#          - Keine Benutzerinteraktion / kein nutzbarer Abbrechen-Button
#          - /norestart bleibt unveraendert
#
#   v1.5 - 27.09.2026
#          - Automatische Adobe Reader Architektur-Erkennung
#          - 32-Bit Reader -> x86 MUI MSP (AcroRdrDCUpd..._MUI.msp)
#          - 64-Bit Reader -> x64 MUI MSP (AcroRdrDCx64Upd..._MUI.msp)
#          - Produktname und Architektur werden im FSC Log protokolliert
#          - Falsche/alte MSP-Dateien werden nicht automatisch geloescht
#
#   v1.4-1 - 27.09.2026
#          - Adobe Release Index Parser korrigiert
#          - Linktext darf jetzt zusaetzliches HTML-Markup enthalten
#          - Erste vollstaendige Adobe Versionsnummer xx.xxx.xxxxx wird verwendet
#          - Zugehoeriger href wird unabhaengig vom Link-Inhalt ermittelt
#
#   v1.4 - 27.09.2026
#          - Webzugriff komplett auf curl.exe umgestellt
#          - HTML Connect Timeout 10s / Gesamt-Timeout 30s
#          - curl Exit Codes werden geloggt
#          - Release HTML-Dateien bleiben fuer Debugging erhalten
#          - MSP Download ebenfalls ueber curl.exe
#   v1.3 - Versionsvergleich vor Download/Installation; Script immer Exit 0
#   v1.2 - MSP Installation mit msiexec /qb-; MSI Exit Code Logging
#   v1.1 - FSC Logging / Vorher-Nachher-Versionen
#   v1.0 - Adobe Release Notes / MUI MSP Download
#
# Franksoft Client Deployment
# Copyright (c) Franksoft 1997-2027
# ==================================================================================================

$ErrorActionPreference = "Stop"
$IndexUrl = "https://www.adobe.com/devnet-docs/acrobatetk/tools/ReleaseNotesDC/index.html"
$DownloadDir = "C:\Temp\Adobe"
$LogDir = "C:\ProgramData\Franksoft\Logs"
$LogFile = Join-Path $LogDir "AdobeReaderUpdate.log"
$IndexHtml = Join-Path $DownloadDir "AdobeReleaseIndex.html"
$ReleaseHtml = Join-Path $DownloadDir "AdobeReleasePage.html"
$CurlConnectTime = 10
$CurlHtmlMaxTime = 30

# ==================================================================================================
# FUNCTION: Verzeichnisse vorbereiten
# ==================================================================================================
try {
    if (!(Test-Path $LogDir)) { New-Item $LogDir -ItemType Directory -Force | Out-Null }
    if (!(Test-Path $DownloadDir)) { New-Item $DownloadDir -ItemType Directory -Force | Out-Null }
} catch {}

# ==================================================================================================
# FUNCTION: FSC Logging
# ==================================================================================================
function Write-Log {
    param([Parameter(Mandatory=$true)][string]$Message)
    try { Add-Content $LogFile "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] $Message" -Encoding UTF8 } catch {}
}

# ==================================================================================================
# FUNCTION: HTML ueber curl.exe herunterladen
# ==================================================================================================
function Get-CurlHtml {
    param([string]$Url,[string]$Destination)
    Write-Log "curl URL            : $Url"
    Write-Log "curl Ziel           : $Destination"
    & curl.exe -L --fail --silent --show-error --connect-timeout $CurlConnectTime --max-time $CurlHtmlMaxTime --output $Destination $Url
    $Code=$LASTEXITCODE
    Write-Log "curl Exit Code      : $Code"
    if($Code -ne 0){ throw "curl.exe Fehler - Exit Code $Code - $Url" }
    if(!(Test-Path $Destination)){ throw "curl Zieldatei fehlt: $Destination" }
    $f=Get-Item $Destination
    if($f.Length -eq 0){ throw "HTML-Datei ist leer: $Destination" }
    Write-Log "HTML Dateigroesse   : $($f.Length) Bytes"
}

Write-Host ""
Write-Host "Franksoft - Adobe Acrobat Reader MUI Update Downloader"
Write-Host "======================================================"
Write-Host "Version 1.5-4"
Write-Host ""
Write-Log "======================================================================"
Write-Log "Franksoft Adobe Acrobat Reader MUI Update Downloader v1.5-4 gestartet"
Write-Log "======================================================================"

try {
# ==================================================================================================
# FUNCTION: Installierte Adobe Acrobat Reader Version ermitteln
# ==================================================================================================
    Write-Host "Installierte Adobe Version wird ermittelt..."
    # Reader zuerst gezielt in beiden Uninstall-Zweigen suchen.
    # WOW6432Node = 32-Bit Anwendung auf 64-Bit Windows.
    $AdobeInstall64 = Get-ItemProperty `
        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*" `
        -ErrorAction SilentlyContinue |
        Where-Object {
            $_.DisplayName -match '^Adobe Acrobat Reader' -and $_.DisplayVersion
        } |
        Select-Object -First 1

    $AdobeInstall32 = Get-ItemProperty `
        "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*" `
        -ErrorAction SilentlyContinue |
        Where-Object {
            $_.DisplayName -match '^Adobe Acrobat Reader' -and $_.DisplayVersion
        } |
        Select-Object -First 1

    if ($AdobeInstall32) {
        $AdobeInstall = $AdobeInstall32
        $AdobeArchitecture = "x86"
    }
    elseif ($AdobeInstall64) {
        $AdobeInstall = $AdobeInstall64
        $AdobeArchitecture = "x64"
    }
    else {
        $AdobeInstall = $null
        $AdobeArchitecture = $null
    }

    if($AdobeInstall){
        $InstalledVersion=$AdobeInstall.DisplayVersion.Trim()
        Write-Host "Produkt     : $($AdobeInstall.DisplayName)"
        Write-Host "Installiert : $InstalledVersion"
        Write-Host "Architektur : $AdobeArchitecture"

        Write-Log "Adobe Produkt       : $($AdobeInstall.DisplayName)"
        Write-Log "Version installiert : $InstalledVersion"
        Write-Log "Architektur         : $AdobeArchitecture"
    } else {
        $InstalledVersion=$null
        Write-Host "Installiert : Adobe Acrobat Reader nicht gefunden" -ForegroundColor Yellow
        Write-Log "Adobe Produkt       : Nicht gefunden"
        Write-Log "Version installiert : Nicht gefunden"
        throw "Adobe Acrobat Reader wurde nicht gefunden."
    }

# ==================================================================================================
# FUNCTION: Adobe Release Index mit curl.exe herunterladen
# ==================================================================================================
    Write-Host ""
    Write-Host "Adobe Release Notes werden gelesen..."
    Get-CurlHtml $IndexUrl $IndexHtml

# ==================================================================================================
# FUNCTION: Aktuellsten Adobe Release aus HTML ermitteln
# ==================================================================================================
    $html = Get-Content $IndexHtml -Raw -Encoding UTF8

    # Adobe kann innerhalb des <a>-Elements zusaetzliches HTML-Markup verwenden.
    # Deshalb wird zuerst jedes Anchor-Element komplett gelesen und anschliessend
    # dessen sichtbarer Text von HTML-Tags bereinigt.
    $AnchorMatches = [regex]::Matches(
        $html,
        '(?is)<a\b[^>]*href=["''](?<href>[^"'']+)["''][^>]*>(?<text>.*?)</a>'
    )

    $ReleaseHref    = $null
    $ReleaseVersion = $null

    foreach ($Anchor in $AnchorMatches) {
        $LinkText = [regex]::Replace($Anchor.Groups["text"].Value, '<[^>]+>', '')
        $LinkText = [System.Net.WebUtility]::HtmlDecode($LinkText).Trim()

        $VersionMatch = [regex]::Match(
            $LinkText,
            '^(?<version>\d{2}\.\d{3}\.\d{5})\b'
        )

        if ($VersionMatch.Success) {
            $ReleaseVersion = $VersionMatch.Groups["version"].Value
            $ReleaseHref    = $Anchor.Groups["href"].Value
            break
        }
    }

    if (-not $ReleaseHref -or -not $ReleaseVersion) {
        throw "Kein Adobe Release-Link mit vollstaendiger Versionsnummer gefunden."
    }

    $ReleaseUrl = ([Uri]::new([Uri]$IndexUrl, $ReleaseHref)).AbsoluteUri
    Write-Host "Aktuell     : $ReleaseVersion"
    Write-Log "Version aktuell     : $ReleaseVersion"
    Write-Log "Release Notes       : $ReleaseUrl"

# ==================================================================================================
# FUNCTION: Installierte und aktuelle Adobe Version vergleichen
# ==================================================================================================
    $UpdateRequired=$true
    if($InstalledVersion){
        try {
            if(([Version]$InstalledVersion) -ge ([Version]$ReleaseVersion)){ $UpdateRequired=$false }
        } catch {
            Write-Log "Versionsvergleich fehlgeschlagen: $($_.Exception.Message)"
            $UpdateRequired=$true
        }
    }
    if(!$UpdateRequired){
        Write-Host ""
        Write-Host "Adobe Reader ist aktuell." -ForegroundColor Green
        Write-Host "Kein Download und keine Installation erforderlich."
        Write-Log "Update erforderlich  : NEIN"
        Write-Log "Script Exit Code     : 0"
        Write-Log "======================================================================"
        exit 0
    }
    Write-Host ""
    Write-Host "Update erforderlich." -ForegroundColor Yellow
    Write-Log "Update erforderlich  : JA"

# ==================================================================================================
# FUNCTION: Adobe Release-Seite mit curl.exe herunterladen
# ==================================================================================================
    Write-Host "Adobe Release-Seite wird gelesen..."
    Get-CurlHtml $ReleaseUrl $ReleaseHtml

# ==================================================================================================
# FUNCTION: Adobe Acrobat Reader x64 MUI MSP suchen
# ==================================================================================================
    $release=Get-Content $ReleaseHtml -Raw -Encoding UTF8

    if ($AdobeArchitecture -eq "x64") {
        # x64: Dateiname enthaelt explizit "x64"
        $MspPattern = '(?is)href=["''](?<href>[^"'']*AcroRdrDCx64Upd\d+_MUI\.msp(?:\?[^"'']*)?)["'']'
        $MspType = "x64 MUI"
    }
    elseif ($AdobeArchitecture -eq "x86") {
        # x86: Dateiname enthaelt KEIN "x64"
        $MspPattern = '(?is)href=["''](?<href>[^"'']*AcroRdrDCUpd\d+_MUI\.msp(?:\?[^"'']*)?)["'']'
        $MspType = "x86 MUI"
    }
    else {
        throw "Adobe Reader Architektur konnte nicht bestimmt werden."
    }

    $mm=[regex]::Match($release,$MspPattern)

    if(!$mm.Success){
        throw "Keine passende Adobe Acrobat Reader $MspType MSP-Datei gefunden."
    }

    $MspUrl=([Uri]::new([Uri]$ReleaseUrl,$mm.Groups["href"].Value)).AbsoluteUri
    $MspFile=[IO.Path]::GetFileName(([Uri]$MspUrl).AbsolutePath)

    Write-Log "MSP Typ             : $MspType"

# ==================================================================================================
# FUNCTION: Adobe Version aus MSP-Dateinamen ermitteln
# ==================================================================================================
    $vm=[regex]::Match($MspFile,'(?i)Upd(\d{2})(\d{3})(\d{5})')
    if($vm.Success){ $NewVersion="{0}.{1}.{2}" -f $vm.Groups[1].Value,$vm.Groups[2].Value,$vm.Groups[3].Value }
    else { $NewVersion=$ReleaseVersion }
    Write-Host ""
    Write-Host "MUI MSP gefunden:" -ForegroundColor Green
    Write-Host "  Typ      : $MspType"
    Write-Host "  Datei    : $MspFile"
    Write-Host "  Version  : $NewVersion"
    Write-Host "  Download : $MspUrl"
    Write-Log "MSP-Datei           : $MspFile"
    Write-Log "Version nachher     : $NewVersion"
    Write-Log "Download URL        : $MspUrl"

# ==================================================================================================
# FUNCTION: Adobe MUI MSP mit curl.exe herunterladen
# ==================================================================================================
    $DestinationFile=Join-Path $DownloadDir $MspFile
    Write-Log "Zielpfad            : $DestinationFile"
    if(Test-Path $DestinationFile){
        Write-Host ""
        Write-Host "MSP bereits vorhanden - Download wird uebersprungen." -ForegroundColor Yellow
        Write-Log "MSP bereits vorhanden - Download uebersprungen"
    } else {
        Write-Host ""
        Write-Host "MSP wird heruntergeladen..."
        Write-Log "MSP Download gestartet"
        & curl.exe -L --fail --silent --show-error --connect-timeout $CurlConnectTime --output $DestinationFile $MspUrl
        $CurlMspExitCode=$LASTEXITCODE
        Write-Log "MSP curl Exit Code  : $CurlMspExitCode"
        if($CurlMspExitCode -ne 0){ throw "MSP Download fehlgeschlagen - curl Exit Code $CurlMspExitCode" }
        Write-Host "Download erfolgreich." -ForegroundColor Green
        Write-Log "MSP Download erfolgreich"
    }
    if(!(Test-Path $DestinationFile)){ throw "MSP-Datei ist nicht vorhanden." }
    $File=Get-Item $DestinationFile
    if($File.Length -eq 0){ throw "MSP-Datei ist leer." }
    $SizeMB=[math]::Round($File.Length/1MB,2)
    Write-Log "Dateigroesse        : $SizeMB MB"

# ==================================================================================================
# FUNCTION: Adobe MUI MSP installieren
# ==================================================================================================
    Write-Host ""
    Write-Host "Adobe Reader MSP wird installiert..."
    Write-Log "MSP Installation gestartet"
    Write-Log "Befehl: msiexec.exe /p `"$DestinationFile`" MSIFASTINSTALL=7 /qb! /norestart"
    $proc=Start-Process msiexec.exe -ArgumentList "/p `"$DestinationFile`" MSIFASTINSTALL=7 /qb! /norestart" -Wait -PassThru
    $MsiExitCode=$proc.ExitCode
    Write-Host "MSI Exit Code : $MsiExitCode"
    Write-Log "MSI Exit Code       : $MsiExitCode"
    switch($MsiExitCode){
        0 { Write-Log "MSI Ergebnis        : Erfolgreich" }
        1641 { Write-Log "MSI Ergebnis        : Erfolgreich - Neustart initiiert" }
        3010 { Write-Log "MSI Ergebnis        : Erfolgreich - Neustart erforderlich" }
        default { Write-Log "MSI Ergebnis        : Installation beendet mit Exit Code $MsiExitCode" }
    }

# ==================================================================================================
# FUNCTION: Ergebnis und Logging
# ==================================================================================================
    Write-Host ""
    Write-Host "======================================================"
    Write-Host "Franksoft - Adobe Reader Update"
    Write-Host "======================================================"
    Write-Host "Version vorher  : $(if($InstalledVersion){$InstalledVersion}else{'Nicht gefunden'})"
    Write-Host "Version nachher : $NewVersion"
    Write-Host "Architektur     : $AdobeArchitecture"
    Write-Host "MSP Typ         : $MspType"
    Write-Host "MSP-Datei       : $MspFile"
    Write-Host "Groesse         : $SizeMB MB"
    Write-Host "MSI Exit Code   : $MsiExitCode"
    Write-Host "Log             : $LogFile"
    Write-Host ""
    Write-Log "Version vorher      : $(if($InstalledVersion){$InstalledVersion}else{'Nicht gefunden'})"
    Write-Log "Version nachher     : $NewVersion"
    Write-Log "Script Exit Code    : 0"
    Write-Log "======================================================================"
}
catch {
    Write-Host ""
    Write-Host "FEHLER:" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    Write-Host ""
    Write-Host "FSC wird fortgesetzt (Exit Code 0)." -ForegroundColor Yellow
    Write-Log "FEHLER: $($_.Exception.Message)"
    Write-Log "Script Exit Code    : 0"
    Write-Log "======================================================================"
}

# ==================================================================================================
# FUNCTION: FSC Exit - unabhaengig vom Ergebnis immer Exit Code 0
# ==================================================================================================
exit 0
