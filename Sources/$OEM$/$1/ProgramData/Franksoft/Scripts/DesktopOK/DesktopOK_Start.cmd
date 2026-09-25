@echo off
@REM :: Minimize CMD
if not "%1"=="7" start /min cmd /c ""%~0" 7 %*" & exit /b

PUSHD "%~dp0"

SET DesktopOKPath=%~dp0
SET DesktopOK_APP=%DesktopOKPath%DesktopOK.exe
SET DesktopOK_CFG=%DesktopOKPath%FSC_Def.dok
If Exist "%DesktopOK_CFG%" If Exist "%DesktopOK_APP%" Start "" "%DesktopOK_APP%" /load "%DesktopOK_CFG%"
