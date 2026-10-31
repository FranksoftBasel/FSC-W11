@echo off
setlocal EnableExtensions

:: =========================================================
:: Script  : FS-Wrapper.cmd - XnView MP
:: Version : 1.1
:: Date    : 31.10.2026
:: Author  : Franksoft
:: Wait for setup, verify installed EXE, then return Exit 0.
:: =========================================================

set "NAME=XnView MP"
set "INSTALLER=XnViewMP-win-x64_v1.12.1"
set "SETUP_EXE=%~dp0%INSTALLER%.exe"
set "SETUP_INF=%~dp0FS-Wrapper.inf"
set "INSTALL_DIR=%ProgramW6432%\XnViewMP"
if not defined ProgramW6432 set "INSTALL_DIR=%ProgramFiles%\XnViewMP"
set "APP_EXE=%INSTALL_DIR%\xnviewmp.exe"

TITLE Bitte warten - %NAME% Installation...
echo.
echo ==============================================
echo Bitte warten bis %NAME% installiert wurde
echo ==============================================

if not exist "%SETUP_EXE%" (
    echo FEHLER: Setup nicht gefunden: "%SETUP_EXE%"
    exit /b 2
)
if not exist "%SETUP_INF%" (
    echo FEHLER: INF nicht gefunden: "%SETUP_INF%"
    exit /b 2
)

:: Synchronous: do not relaunch this wrapper in the background.
start "" /wait "%SETUP_EXE%" /Silent /NORESTART /LOADINF="%SETUP_INF%" /MERGETASKS=!desktopicon
set "SETUP_RC=%ERRORLEVEL%"
echo Setup ExitCode: %SETUP_RC%
if not "%SETUP_RC%"=="0" if not "%SETUP_RC%"=="3010" (
    echo FEHLER: XnView Setup fehlgeschlagen.
    exit /b %SETUP_RC%
)

:: Verify only after the installer has finished.
if not exist "%APP_EXE%" (
    echo FEHLER: Installierte EXE nicht gefunden: "%APP_EXE%"
    exit /b 1
)
echo OK: "%APP_EXE%"

:: Current-user configuration.
if not exist "%APPDATA%\XnViewMP" md "%APPDATA%\XnViewMP"
if exist "%~dp0CU\xnview.ini" (
    copy /Y "%~dp0CU\xnview.ini" "%APPDATA%\XnViewMP\xnview.ini" >nul
    if errorlevel 1 (
        echo FEHLER: xnview.ini konnte nicht kopiert werden.
        exit /b 1
    )
)

:: Existing shortcut cleanup.
set "STM=%ProgramData%\Microsoft\Windows\Start Menu\Programs\XnView MP"
set "STM2=%ProgramData%\Microsoft\Windows\Start Menu\Programs"
if exist "%STM%\%NAME%.lnk" (
    copy /Y "%STM%\%NAME%.lnk" "%STM2%\%NAME%.lnk" >nul
    if not errorlevel 1 rd /S /Q "%STM%"
)
if exist "%PUBLIC%\Desktop\XnView MP.lnk" del /F /Q "%PUBLIC%\Desktop\XnView MP.lnk"

echo %NAME% Installation abgeschlossen. ExitCode: 0
endlocal
exit /b 0
