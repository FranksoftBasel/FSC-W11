@echo off
@SET FSN=Franksoft Client Windows Update
@Title %FSN%
:: Skript mit Adminrechten neu starten, falls nötig

>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo.
    echo [INFO] Adminrechte erforderlich. Starte das Skript neu mit Administratorrechten...
    powershell -Command "Start-Process '%~f0' -Verb runAs"
    exit /b
)

:: Ab hier läuft das Skript mit Administratorrechten
Pushd "%~dp0"

setlocal
set "TASKNAME=Franksoft Windows Update"
set "XMLTEMPLATE=WinUpd-Task.xml"

:: Aufgabe erstellen
echo [INFO] Erstelle geplante Aufgabe "%TASKNAME%"...
schtasks /create /tn "%TASKNAME%" /xml "%XMLTEMPLATE%"

if %errorlevel%==0 (
    echo [OK] Aufgabe wurde erfolgreich erstellt.
) else (
    echo [FEHLER] Beim Erstellen der Aufgabe ist ein Fehler aufgetreten.
    goto :END
)

:: === Eigenständiger Block: Aufgabe starten ===
echo.
echo [INFO] Starte Aufgabe "%TASKNAME%"...
schtasks /run /tn "%TASKNAME%"

if %errorlevel%==0
