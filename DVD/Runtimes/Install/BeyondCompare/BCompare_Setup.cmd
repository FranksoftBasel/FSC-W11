@echo off
setlocal EnableDelayedExpansion

:: =========================================================
:: OPTIONAL START MINIMIZED
:: =========================================================
:: if not "%1"=="7" start /min cmd /c ""%~0" 7 %*" & exit /b

:: =========================================================
:: ADMIN CHECK / UAC
:: =========================================================
call :Admin

:: =========================================================
:: ANSI ESCAPE CODE AKTIVIEREN
:: =========================================================
for /F %%a in ('echo prompt $E ^| cmd') do set "ESC=%%a"

:: =========================================================
:: SETUP PARAMETER
:: =========================================================
set "SetupPara=/SP- /SILENT /ALLUSERS /NORESTART /CLOSEAPPLICATIONS /NOCANCEL"

:: =========================================================
:: INSTALLIERTE DATEI
:: =========================================================
set "InstalledEXE=C:\Program Files\Beyond Compare 5\BCompare.exe"

:: =========================================================
:: EXE SUCHEN
:: =========================================================
for %%F in ("%~dp0BComp*.exe") do (
    set "InstallerFile=%%~fF"
    set "InstallerName=%%~nxF"
    goto :Found
)

color 4E
cls
echo =========================================================
echo                     FEHLER
echo =========================================================
echo =========================================================
echo Keine EXE gefunden
echo =========================================================
timeout /t 10 >nul
exit /b


:Found

:: =========================================================
:: SETUP VERSION
:: =========================================================
for /f "delims=" %%V in ('
    powershell -noprofile "(Get-Item '!InstallerFile!').VersionInfo.FileVersion"
') do set "SetupVersion=%%V"

:: =========================================================
:: INSTALLIERTE VERSION
:: =========================================================
set "InstalledVersion=NICHT INSTALLIERT"

if exist "%InstalledEXE%" (
    for /f "delims=" %%V in ('
        powershell -noprofile "(Get-Item '%InstalledEXE%').VersionInfo.FileVersion"
    ') do set "InstalledVersion=%%V"
)

:: =========================================================
:: STATUS
:: =========================================================
if /I "!SetupVersion!"=="!InstalledVersion!" (
    set "VersionStatus=GLEICHE VERSION INSTALLIERT"
) else (
    set "VersionStatus=UPDATE ERFORDERLICH"
)

:: =========================================================
:: ADMIN STATUS
:: =========================================================
reg query "HKU\S-1-5-19\Environment" >nul 2>&1
if %errorlevel% EQU 0 (
    set "AdminStatus=JA"
) else (
    set "AdminStatus=NEIN"
)

:: =========================================================
:: HEADER
:: =========================================================
title Beyond Compare Setup
cls

echo =========================================================
echo                 BEYOND COMPARE SETUP
echo =========================================================
echo.

echo Datei              : !InstallerName!
echo.

:: =========================================================
:: VERSIONEN FARBE
:: =========================================================

echo Setup Version      : !ESC![92m!SetupVersion!!ESC![0m

if /I "!SetupVersion!"=="!InstalledVersion!" (
    echo Installiert        : !ESC![92m!InstalledVersion!!ESC![0m
) else (
    echo Installiert        : !ESC![91m!InstalledVersion!!ESC![0m
)

echo Status             : !VersionStatus!
echo.
echo Benutzer           : %USERNAME%
echo Datum              : %date%
echo Zeit               : %time%
echo Admin Rechte       : !AdminStatus!
echo.
echo Setup Parameter    : !SetupPara!
echo.
echo =========================================================
echo.

:: =========================================================
:: ABGLEICH STOP (GLEICHE VERSION)
:: =========================================================
if /I "!SetupVersion!"=="!InstalledVersion!" (
    echo Version bereits installiert.
    timeout /t 5 >nul
    exit /b
)

:: =========================================================
:: INSTALLATION
:: =========================================================
"%InstallerFile%" !SetupPara!

regedit /s "%~dp0HKCU-RUN.reg"
copy /Y "%~dp0BCompare.vbs" "%ProgramFiles%\Beyond Compare 5"

echo.
echo =========================================================
echo                       FERTIG
echo =========================================================
echo.


exit /b


:Admin
reg query "HKU\S-1-5-19\Environment" >nul 2>&1
if not %errorlevel% EQU 0 (
    cls
    powershell.exe -windowstyle hidden -noprofile ^
    "Start-Process '%~dpnx0' -Verb RunAs"
    exit
)