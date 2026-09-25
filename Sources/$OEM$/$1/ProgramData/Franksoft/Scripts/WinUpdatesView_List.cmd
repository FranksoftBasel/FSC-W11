@echo off
setlocal EnableExtensions

:: =============================================================================
:: Script Name : WinUpdatesView_List.cmd
:: Parameter   : before / after
:: Version     : 1.0
:: Date        : 15.06.2026
:: Author      : Franksoft
:: Modules     : WinUpdatesView.exe
::
:: Purpose
:: -----------------------------------------------------------------------------
:: FSC Deployment Phase 05/09
:: Microsoft WinGet Package Updates
::
:: Log
:: -----------------------------------------------------------------------------
:: C:\ProgramData\Franksoft\Logs\WindowsUpdate
:: =============================================================================

title Franksoft WinUpdatesView Export

pushd "%~dp0"

set "TOOL=%~dp0WinUpdatesView.exe"
set "LOGROOT=%ProgramData%\Franksoft\Logs\WindowsUpdate"
set "STAMP=%DATE:~-4%_%DATE:~3,2%_%DATE:~0,2%_%TIME:~0,2%_%TIME:~3,2%_%TIME:~6,2%"
set "STAMP=%STAMP: =0%"

::for /f %%i in ('powershell -NoProfile -Command "(Get-Date).ToString(\"yyyy-MM-dd_HH-mm-ss\")"') do set "TS=%%i"

if not exist "%LOGROOT%" md "%LOGROOT%"

if "%~1"=="" (
    set "PREFIX=All"
) else (
    set "PREFIX=%~1"
)

set "CSV=%LOGROOT%\WinUpdatesView_%PREFIX%_%STAMP%.csv"
set "TXT=%LOGROOT%\WinUpdatesView_%PREFIX%_%STAMP%.txt"
set "HTML=%LOGROOT%\WinUpdatesView_%PREFIX%_%STAMP%.html"
set "LOG=%LOGROOT%\WinUpdatesView_%PREFIX%_%STAMP%.log"

echo [%DATE% %TIME%] WinUpdatesView Export Start > "%LOG%"
echo Tool: %TOOL%>>"%LOG%"

if not exist "%TOOL%" (
    echo ERROR: WinUpdatesView.exe nicht gefunden: %TOOL%>>"%LOG%"
    echo WinUpdatesView.exe nicht gefunden.
    pause
    exit /b 1
)

"%TOOL%" /scomma "%CSV%" /sort "~Install Date"
"%TOOL%" /stext  "%TXT%" /sort "~Install Date"
"%TOOL%" /shtml  "%HTML%" /sort "~Install Date"

echo CSV : %CSV%>>"%LOG%"
echo TXT : %TXT%>>"%LOG%"
echo HTML: %HTML%>>"%LOG%"
echo [%DATE% %TIME%] WinUpdatesView Export Ende>>"%LOG%"

echo.
echo Export fertig:
echo %CSV%
echo %TXT%
echo %HTML%
echo.

popd
exit /b 0