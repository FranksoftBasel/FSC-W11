@echo off

setlocal enabledelayedexpansion

REM === Set path and file ===
set "apploc=%~dp0app"
set "logdir=%ProgramData%\HP\logs\UWP"
if not exist "%logdir%" mkdir "%logdir%"

REM === Read AUMID and set APP name ===
for /f "tokens=2 delims=_" %%i in (%apploc%\AUMIDs.txt) do (
    set "DisplayName=%%i"
    goto :gotname
)
:gotname

set "APP_Log=%logdir%\%DisplayName%.log"
set "APPDISM_Log=%logdir%\%DisplayName%_DISM.log"
set "DISM_BASE=%WINDIR%\System32\Dism.exe /LogPath:%APPDISM_Log% /ScratchDir:%logdir%"

REM === Determine if GUI installation is required (using PowerShell)===
set "installgui=false"
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$devs = Get-PnpDevice | Where-Object { $_.InstanceId -match 'DEV_467F|DEV_9A0B|DEV_09AB' }; if ($devs) { exit 0 } else { exit 1 }"
if %errorlevel%==0 (
    set "installgui=true"
)

if "%installgui%"=="false" (
    echo [INFO] Does not meet GUI device conditions, ending installation >> "%APP_Log%"
    goto :eof
)

REM === Automatically obtain the main appx, license and dependency ===
for %%f in ("%apploc%\*.appxbundle") do set "package=%%f"
for %%f in ("%apploc%\*.xml") do set "license=%%f"

set "dependency="

for %%f in ("%apploc%\*x64__8wekyb3d8bbwe*" "%apploc%\*arm64__8wekyb3d8bbwe*") do (
    set "dependency=!dependency! /DependencyPackagePath:%%f"
)

REM === Combine DISM commands and execute ===
set "DISM_CMD=/Add-ProvisionedAppxPackage /PackagePath:"%package%" /Region:all /LicensePath:"%license%" %dependency%"
echo [%date% %time%] Installing %DisplayName% >> "%APP_Log%"
echo %DISM_BASE% /Online %DISM_CMD% >> "%APP_Log%"
%DISM_BASE% /Online %DISM_CMD% >> "%APP_Log%" 2>&1

REM === Installed end ===
echo [%date% %time%] The installer is complete. >> "%APP_Log%"
