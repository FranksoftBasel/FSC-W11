@echo off
color 2f
Title RustDesk installation bitte warten..

@MODE CON: COLS=55 LINES=14
chcp 65001 >nul

:: =========================
:: Admin Check
:: =========================
net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -NoProfile -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

set "InstallerFile=%~dp0rustdesk-1.4.7-x86_64.exe"

:: =========================
:: 1. Installation
:: =========================
powershell -NoProfile -Command "Write-Host ' '"
powershell -NoProfile -Command "Write-Host ' 1. RustDesk-Installation bitte warten...'"

start /wait "" "%InstallerFile%" --silent-install

:: =========================
:: 1.1 Dienst konfigurieren
:: =========================
powershell -NoProfile -Command "Write-Host ' 1.1 RustDesk-Dienst auf Manuell setzen...'"
sc config RustDesk start= demand >nul 2>&1

:: =========================
:: 2. Verknüpfung kopieren
:: =========================
powershell -NoProfile -Command "Write-Host ' 2. Verknüpfung ins Startmenü Programme kopieren...'"

set "RDLNK=%ProgramData%\Microsoft\Windows\Start Menu\Programs\RustDesk\RustDesk.lnk"

if exist "%RDLNK%" (
    copy /Y "%RDLNK%" "%ProgramData%\Microsoft\Windows\Start Menu\Programs\" >nul 2>&1
)

timeout /t 3 >nul

:: =========================
:: 3. Startmenü Ordner löschen
:: =========================
powershell -NoProfile -Command "Write-Host ' 3. Ordner im Startmenü entfernen...'"
rd /S /Q "%ProgramData%\Microsoft\Windows\Start Menu\Programs\RustDesk" >nul 2>&1

:: =========================
:: 4. RustDesk stoppen
:: =========================
powershell -NoProfile -Command "Write-Host ' 4. RustDesk beenden...'"
net stop RustDesk >nul 2>&1
taskkill /F /IM rustdesk.exe >nul 2>&1

:: =========================
:: 5. Autostart entfernen
:: =========================
powershell -NoProfile -Command "Write-Host ' 5. Autostart-Verknüpfung löschen...'"
del /F /Q "%ProgramData%\Microsoft\Windows\Start Menu\Programs\Startup\RustDesk Tray.lnk" >nul 2>&1

powershell -NoProfile -Command "Write-Host 'Fertig ✔' -ForegroundColor Green"

exit /b 0