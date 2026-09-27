@echo off
chcp 850 >nul
setlocal EnableExtensions

SET "MSGX=Franksoft Client: WinGET Software-Deployment - Please wait... ^| Script: %~nx0"

:: Adminrechte prfen
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Starte mit Administratorrechten neu...
    powershell -NoProfile -ExecutionPolicy Bypass -Command ^
        "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

SET FSC_PHASE=06/06

@echo.
@echo. %MSGX%
@echo.

:: =============================================================================
:: Franksoft Client Deployment
:: =============================================================================
:: Script Name : WinGetUpdate_FSC.cmd
:: Version     : 1.4
:: Date        : 27.09.2026
:: Author      : Franksoft
:: Copyright   : (c) Franksoft 1997-2027
::
:: Modules
:: -----------------------------------------------------------------------------
:: WinGetUpdate_FSC.ps1
:: WinGetApps.json
:: FSC-Adobe-Reader-MUI-Update.ps1
::
:: Purpose
:: -----------------------------------------------------------------------------
:: FSC Deployment Phase 06/06
::
:: - Microsoft WinGet Package Updates
:: - Adobe Acrobat Reader MUI Update
:: - Chrome Policy Update
::
:: Log
:: -----------------------------------------------------------------------------
:: %ProgramData%\Franksoft\Logs\WinGetUpdate_FSC.log
:: %ProgramData%\Franksoft\Logs\AdobeReaderUpdate.log
::
:: Changelog
:: -----------------------------------------------------------------------------
:: v1.4 - 27.09.2026
::        - FSC-Adobe-Reader-MUI-Update.ps1 integriert
::        - Adobe Acrobat Reader Update wird nach WinGet ausgefhrt
::        - CMD wartet auf vollst„ndigen Abschluss des Adobe Updates
::        - Adobe Update verwendet eigenen FSC Log
::
:: v1.3 - 27.09.2026
::        - Bisheriger produktiver Stand
:: =============================================================================

SET "NT=%TIME: =0%"
SET "NT=%NT:~0,8%"

SET "FSC_REG=HKLM\SOFTWARE\Franksoft\Setup"
SET "FSC_SCRIPT_NAME=%~nx0"
SET "FSC_SCRIPT_PATH=%~f0"

REG Add "%FSC_REG%\%FSC_SCRIPT_NAME%" /f >nul 2>nul

REG Add "%FSC_REG%\%FSC_SCRIPT_NAME%" /v "Script Name" /t REG_SZ /d "%FSC_SCRIPT_NAME%" /f >nul
REG Add "%FSC_REG%\%FSC_SCRIPT_NAME%" /v "Script Path" /t REG_SZ /d "%FSC_SCRIPT_PATH%" /f >nul
REG Add "%FSC_REG%\%FSC_SCRIPT_NAME%" /v "FSC Phase" /t REG_SZ /d "%FSC_PHASE%" /f >nul
REG Add "%FSC_REG%\%FSC_SCRIPT_NAME%" /v "Start" /t REG_SZ /d "%DATE% %NT%" /f >nul

echo.
echo Franksoft WinGet Updates
echo.

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%ProgramData%\Franksoft\Scripts\WinGetUpdate_FSC.ps1"

REM ==================================================================================================
REM ADOBE ACROBAT READER MUI UPDATE
REM ==================================================================================================

echo.
echo [Adobe Reader] Suche nach Updates...

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%ProgramData%\Franksoft\Scripts\FSC-Adobe-Reader-MUI-Update.ps1"

:: Chrome Policy Update

cmd /c start /min chrome
Timeout 2 >NUL
Taskkill /im Chrome.exe /f >NUL
cmd /c start /min chrome
Timeout 1 >NUL
Taskkill /im Chrome.exe /f >NUL

for %%i in (B D E F G H I J K L M N O P Q R S T U V W X Y Z) do @IF Exist %%i:\Sources\setup.exe set USB-Stick-Path=%%i:

SET ChromeCU=%USB-Stick-Path%\Runtimes\Install\Chrome\CU\Chrome-HKCU_FSC-01.reg
IF Exist "%ChromeCU%" Regedit /S "%ChromeCU%"

:: Chrome Policy Update

SET "NT=%TIME: =0%"
SET "NT=%NT:~0,8%"
REG Add "%FSC_REG%\%FSC_SCRIPT_NAME%" /v "End" /t REG_SZ /d "%DATE% %NT%" /f >nul

exit /b 0
