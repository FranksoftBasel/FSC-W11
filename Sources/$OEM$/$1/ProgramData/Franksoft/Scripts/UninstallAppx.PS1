Write-Host "Starte AppX Deinstallation..."

$Apps = @(
"Microsoft.549981C3F5F10",
"Microsoft.YourPhone",
"Microsoft.XboxGamingOverlay",
"Microsoft.XboxSpeechToTextOverlay",
"Microsoft.GetHelp",
"Microsoft.Getstarted",
"Microsoft.People",
"Microsoft.Wallet",
"Microsoft.WindowsFeedbackHub",
"MicrosoftTeams",
"Microsoft.Todos",
"Microsoft.ZuneMusic"
)

foreach ($App in $Apps) {
    Get-AppxPackage -AllUsers $App -ErrorAction SilentlyContinue |
        Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue
}



Write-Host "Fertig."


## LOG
## powershell -NoProfile -ExecutionPolicy Bypass -File "C:\ProgramData\Franksoft\Scripts\UninstallAppx.PS1" *> "C:\ProgramData\Franksoft\Logs\UninstallAppx.log"
