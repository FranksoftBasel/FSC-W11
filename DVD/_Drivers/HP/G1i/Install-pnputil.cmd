:: bcdedit /set nointegritychecks on

@echo off
setlocal enabledelayedexpansion

:: ========================
:: Pfade und Variablen
:: ========================
set "DRIVER_DIR=%~dp0"
set "LOG_FILE=%~dp0driver_install_log_%date%_%random%.txt"

:: ========================
:: Prüfen ob Adminrechte
:: ========================
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo.
    echo [INFO] Adminrechte erforderlich. Starte neu mit Administratorrechten...
    echo.
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: ========================
:: Protokoll starten
:: ========================
echo [START] Treiberinstallation am %DATE% um %TIME% > "%LOG_FILE%"
echo Quelle: %DRIVER_DIR% >> "%LOG_FILE%"
echo. >> "%LOG_FILE%"

:: ========================
:: Treiber installieren
:: ========================
echo [INFO] Starte Treiberinstallation...
pnputil /add-driver "%DRIVER_DIR%*.inf" /subdirs /install >> "%LOG_FILE%" 2>&1

echo. >> "%LOG_FILE%"
echo [DONE] Vorgang abgeschlossen am %DATE% um %TIME% >> "%LOG_FILE%"

:: ========================
:: Abschlussanzeige
:: ========================
echo.
echo ------------------------------------------
echo [FERTIG] Alle Treiber wurden installiert.
echo Logdatei: %LOG_FILE%
echo ------------------------------------------
pause
