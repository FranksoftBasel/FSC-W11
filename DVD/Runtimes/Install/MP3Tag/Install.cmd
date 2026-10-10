
@echo off
setlocal EnableExtensions EnableDelayedExpansion

title Mp3tag 3.36.1 - Silent Installation

set "SETUP=%~dp0mp3tag-v3.36.1-setup.exe"
set "INI=%~dp0Mp3tagSetup.ini"
set "MP3TAG=C:\Program Files (x86)\Mp3tag\Mp3tag.exe"

echo ==================================================
echo          Mp3tag 3.36.1 Installation
echo ==================================================
echo.
echo [INFO] Starte die Installation...
echo [INFO] Desktop-Verknuepfung wird nicht erstellt.
echo.

if not exist "%SETUP%" (
    echo [FEHLER] Mp3tag-Setup wurde nicht gefunden!
    echo.
    echo Erwartete Datei:
    echo %SETUP%
    echo.
    pause
    exit /b 1
)

if not exist "%INI%" (
    echo [FEHLER] Mp3tagSetup.ini wurde nicht gefunden!
    echo.
    echo Erwartete Datei:
    echo %INI%
    echo.
    pause
    exit /b 1
)

echo [INFO] Setup gefunden.
echo [INFO] Konfigurationsdatei gefunden.
echo [INFO] Fuehre Installation im Silent-Modus aus...
echo.

"%SETUP%" /S

echo.
echo [INFO] Warte auf Abschluss der Installation...
echo.

set /a WAITCOUNT=0

:WAIT_FOR_MP3TAG
if exist "%MP3TAG%" goto INSTALL_OK

set /a WAITCOUNT+=1

if !WAITCOUNT! GEQ 60 goto INSTALL_ERROR

timeout /t 1 /nobreak >nul
goto WAIT_FOR_MP3TAG


:INSTALL_OK
echo ==================================================
echo Installationspruefung
echo ==================================================
echo.
echo [OK] Mp3tag 3.36.1 wurde erfolgreich installiert.
echo.
echo [OK] Gefunden:
echo      %MP3TAG%
echo.
echo ==================================================
echo Installation abgeschlossen.
echo ==================================================
echo.
echo Fenster wird in 5 Sekunden geschlossen...
echo.

timeout /t 5 /nobreak

exit /b 0


:INSTALL_ERROR
echo ==================================================
echo Installationspruefung
echo ==================================================
echo.
echo [FEHLER] Mp3tag wurde nach 60 Sekunden nicht gefunden!
echo.
echo Erwartete Datei:
echo %MP3TAG%
echo.
echo ==================================================
echo Installation fehlgeschlagen.
echo ==================================================
echo.
echo Fenster wird in 5 Sekunden geschlossen...
echo.

timeout /t 5 /nobreak

exit /b 1