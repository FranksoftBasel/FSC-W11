@echo off
setlocal EnableExtensions

:: ============================================================================
:: Franksoft Client (FSC) - Intel Graphics Driver (G1i)
:: ============================================================================
:: File        : Install.cmd
:: Version     : 1.1
:: Date        : 17.10.2026
:: Author      : Franksoft
:: Target      : HP EliteBook 8 G1i / Windows 11
:: Purpose     : Install Intel Graphics driver from pre-extracted Intel package
:: Method      : Direct Installer.exe call; no SFX, no optional Intel extras
:: Changelog   : v1.1 - Replace gfx_win_101.xxxx.exe SFX with Installer.exe
::                   - Disable optional extras (--noExtras)
::                   - Keep FSC logging and propagate actual installer exit code
:: ============================================================================

set "FSC_GFX_INSTALLER=%~dp0Installer.exe"
set "FSC_GFX_LOGDIR=%ProgramData%\Franksoft\Logs\Drivers"
set "FSC_GFX_LOG=%FSC_GFX_LOGDIR%\Intel_GFX_Direct_%RANDOM%.log"

if not exist "%FSC_GFX_LOGDIR%" mkdir "%FSC_GFX_LOGDIR%" >nul 2>&1

if not exist "%FSC_GFX_INSTALLER%" (
    echo [ERROR] Intel Installer.exe nicht gefunden: "%FSC_GFX_INSTALLER%"
    >>"%FSC_GFX_LOG%" echo [ERROR] %DATE% %TIME% - Installer.exe nicht gefunden: "%FSC_GFX_INSTALLER%"
    endlocal & exit /b 2
)

>>"%FSC_GFX_LOG%" echo ================================================================
>>"%FSC_GFX_LOG%" echo Intel Graphics - Direct Installer
>>"%FSC_GFX_LOG%" echo Start : %DATE% %TIME%
>>"%FSC_GFX_LOG%" echo Source: "%FSC_GFX_INSTALLER%"
>>"%FSC_GFX_LOG%" echo Args  : -s --noExtras --terminateProcesses
>>"%FSC_GFX_LOG%" echo ================================================================

echo [GFX] Installing Intel Graphics without optional extras...
echo [GFX] Log: "%FSC_GFX_LOG%"

pushd "%~dp0" || (endlocal & exit /b 3)
"%FSC_GFX_INSTALLER%" -s --noExtras --terminateProcesses >>"%FSC_GFX_LOG%" 2>&1
set "FSC_GFX_RC=%ERRORLEVEL%"
popd

>>"%FSC_GFX_LOG%" echo Ende     : %DATE% %TIME%
>>"%FSC_GFX_LOG%" echo Exit-Code: %FSC_GFX_RC%
>>"%FSC_GFX_LOG%" echo ================================================================
echo [GFX] ExitCode: %FSC_GFX_RC%

endlocal & exit /b %FSC_GFX_RC%
