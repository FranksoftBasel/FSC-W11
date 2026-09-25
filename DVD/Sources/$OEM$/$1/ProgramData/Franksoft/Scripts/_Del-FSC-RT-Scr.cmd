@echo off
setlocal EnableExtensions DisableDelayedExpansion

title Franksoft Cleanup

@echo off
setlocal EnableExtensions

:: =========================================================
:: ADMIN PRÜFUNG / UAC ELEVATION
:: =========================================================
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Starte mit Administratorrechten...
    powershell -NoProfile -ExecutionPolicy Bypass -Command ^
        "Start-Process -WindowStyle Minimized -FilePath '%ComSpec%' -ArgumentList '/c ""%~f0"" FSCM %*' -Verb RunAs"
    exit /b
)

:: =========================================================
:: MINIMIERT STARTEN
:: =========================================================
if /I not "%1"=="FSCM" (
    start /min "" cmd /c ""%~f0" FSCM %*"
    exit /b
)

if /I not "%~d0"=="C:" exit /b

echo.
echo ==========================================
echo        FRANKSOFT CLEANUP
echo ==========================================
echo.


set "LIST=%~dp0FSC-Cleanup.txt"
set "LOG=%ProgramData%\Franksoft\Logs\Cleanup_FSC.log"

if not exist "%ProgramData%\Franksoft\Logs" md "%ProgramData%\Franksoft\Logs"

echo ==================================================>>"%LOG%"
echo [%DATE% %TIME%] Franksoft Cleanup Start>>"%LOG%"

if not exist "%LIST%" (
    echo FSC-Cleanup.txt nicht gefunden.
    echo [%DATE% %TIME%] ERROR FSC-Cleanup.txt nicht gefunden>>"%LOG%"
    exit /b 1
)

for /f "usebackq eol=# delims=" %%I in ("%LIST%") do (
    set "RAW=%%I"
    call :CleanupItem
)

echo [%DATE% %TIME%] Franksoft Cleanup Ende>>"%LOG%"
echo Fertig.
exit /b 0


:CleanupItem
set "ITEM=%RAW%"

rem Anführungszeichen entfernen
set "ITEM=%ITEM:"=%"

rem Variablen aus FSC-Cleanup.txt expandieren
call set "ITEM=%ITEM%"

if "%ITEM%"=="" exit /b 0

echo Prüfe: "%ITEM%"
echo [%DATE% %TIME%] CHECK "%ITEM%">>"%LOG%"

rem Ordner exakt
if exist "%ITEM%\" (
    echo Lösche Ordner: "%ITEM%"
    echo [%DATE% %TIME%] DELETE DIR "%ITEM%">>"%LOG%"
    rd /s /q "%ITEM%" >>"%LOG%" 2>&1
    exit /b 0
)

rem Datei exakt
if exist "%ITEM%" (
    echo Lösche Datei: "%ITEM%"
    echo [%DATE% %TIME%] DELETE FILE "%ITEM%">>"%LOG%"
    del /f /q "%ITEM%" >>"%LOG%" 2>&1
    exit /b 0
)

rem Wildcard Dateien
for %%F in ("%ITEM%") do (
    if exist "%%~fF" (
        echo Lösche Datei: "%%~fF"
        echo [%DATE% %TIME%] DELETE FILE "%%~fF">>"%LOG%"
        del /f /q "%%~fF" >>"%LOG%" 2>&1
    )
)

rem Wildcard Ordner
for /d %%D in ("%ITEM%") do (
    if exist "%%~fD\" (
        echo Lösche Ordner: "%%~fD"
        echo [%DATE% %TIME%] DELETE DIR "%%~fD">>"%LOG%"
        rd /s /q "%%~fD" >>"%LOG%" 2>&1
    )
)

exit /b 0