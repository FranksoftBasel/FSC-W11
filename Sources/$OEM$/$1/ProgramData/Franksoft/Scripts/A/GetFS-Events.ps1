#  =============================================================================
#  Script Name : GetFS-Events.ps1
#  Path        : %ProgramData%\Franksoft\Scripts\GetFS-Events.ps1
#  Version     : 1.1
#  Date        : 12.06.2022
#  Author      : Franksoft
# 
#  Purpose     : Franksoft Event 007 Log Reader (deutsche Ausgabe)
#  -----------------------------------------------------------------------------
#  FSC Deployment Phase 06/06
# 
#  - FSC Config
#  - FSC Software Deployment
# 
#  Log
#  -----------------------------------------------------------------------------
#  suche "Franksoft Deployment Events:"
#  %ProgramData%\Franksoft\Logs\Franksoft Client.txt"
#  %ProgramData%\Franksoft\Logs\FS-Events.txt
#  =============================================================================

$OutputPath = "C:\ProgramData\Franksoft\Logs\FS-Events.txt"

# Inhalte vorbereiten
$output = @()
$output += "Franksoft Client Deployment Event ID 007"
$output += "+--------+---------------------+----------------+-----------+-----------------------+"
$output += "| Index  | Time                | Type           | Source    | Script                |"
$output += "+--------+---------------------+----------------+-----------+-----------------------+"

# Events holen
$events = Get-WinEvent -LogName Application -MaxEvents 1000 |
    Where-Object {
        $_.ProviderName -eq 'Franksoft' -and $_.Id -eq 7
    } |
    Sort-Object TimeCreated

$index = 1

foreach ($event in $events) {
    $time = $event.TimeCreated.ToString("yyyy-MM-dd HH:mm:ss")
    $message = $event.Message

    # Scriptnamen aus "Script: ..." extrahieren
    if ($message -match "Script: ([\w\-\\\.]+)") {
        $scriptName = [System.IO.Path]::GetFileName($matches[1])
    } else {
        $scriptName = "N/A"
    }

    # Eintragstyp auf Deutsch
    switch ($event.LevelDisplayName) {
        "Information" { $entryType = "Informationen" }
        "Warning"     { $entryType = "Warnung" }
        "Error"       { $entryType = "Fehler" }
        default       { $entryType = $event.LevelDisplayName }
    }

    # Zeile formatieren
    $line = ("| {0,-6} | {1,-19} | {2,-14} | {3,-9} | {4,-21} |" -f `
        $index, $time, $entryType, $event.ProviderName, $scriptName)

    $output += $line
    $index++
}

$output += "+--------+---------------------+----------------+-----------+-----------------------+"

# In Datei schreiben (UTF-8 ohne BOM, falls gewünscht)
$output | Set-Content -Path $OutputPath -Encoding UTF8
