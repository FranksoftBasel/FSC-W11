@echo off
:: Überprüfen, ob winget installiert ist
where winget >nul 2>nul
if %errorlevel% neq 0 (
    echo "winget ist nicht installiert"
    :: Installiere App Installer (winget), wenn es nicht installiert ist
    powershell -Command "Get-AppxPackage Microsoft.DesktopAppInstaller | Add-AppxPackage -ForceUpdateFromAnyVersion"
) else (
    echo "winget ist bereits installiert."
)


Timeout 5
