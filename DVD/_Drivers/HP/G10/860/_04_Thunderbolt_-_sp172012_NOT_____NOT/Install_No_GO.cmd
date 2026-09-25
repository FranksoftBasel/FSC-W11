@echo off
setlocal
set "_curPath=%~dp0"
pushd "%_curPath%"

REM Check if 'silent' parameter is passed
set "isSilent=0"
if /i "%1"=="silent" set "isSilent=1"
if /i "%2"=="silent" set "isSilent=1"
if /i "%3"=="silent" set "isSilent=1"
if /i "%4"=="silent" set "isSilent=1"
if /i "%5"=="silent" set "isSilent=1"
if /i "%6"=="silent" set "isSilent=1"
if /i "%7"=="silent" set "isSilent=1"

REM Detect system architecture
set "arch=%PROCESSOR_ARCHITECTURE%"
if /i "%PROCESSOR_ARCHITECTURE%"=="x86" (
    if not "%PROCESSOR_ARCHITEW6432%"=="" set "arch=%PROCESSOR_ARCHITEW6432%"
)
if /i "%PROCESSOR_ARCHITECTURE%"=="amd64" (
    if not "%PROCESSOR_ARCHITEW6432%"=="" set "arch=%PROCESSOR_ARCHITEW6432%"
)

REM Select MSI file based on system architecture
if /i "%arch%"=="x86" goto set_bitness_32
if /i "%arch%"=="amd64" goto set_bitness_64
if /i "%arch%"=="IA64" goto set_bitness_64
if /i "%arch%"=="EM64T" goto set_bitness_64
if /i "%arch%"=="arm" goto set_bitness_32
if /i "%arch%"=="arm64" goto set_bitness_64
goto Default

:set_bitness_32
set "_msiPath=Manageability\HPFirmwareInstaller.msi"
goto Finish

:set_bitness_64
:Default
set "_msiPath=Manageability\HPFirmwareInstaller64.msi"
goto Finish

:Finish

REM Copy .cat files to system catroot folder
set "catTargetPath=C:\Windows\System32\catroot\{F750E6C3-38EE-11D1-85E5-00C04FC295EE}"

if not exist "%catTargetPath%" (
    echo Target catroot folder does not exist.
    goto :exit_fail
)

if not exist "Manageability\OCIApps-All.cat" (
    echo OCIApps-All.cat is missing.
    goto :exit_fail
)
copy "Manageability\OCIApps-All.cat" "%catTargetPath%"
if %ERRORLEVEL% neq 0 (
    echo Failed to copy OCIApps-All.cat.
    goto :exit_fail
)
echo OCIApps-All.cat copied successfully.

if not exist "Manageability\HPWmiProvider.cat" (
    echo HPWmiProvider.cat is missing.
    goto :exit_fail
)
copy "Manageability\HPWmiProvider.cat" "%catTargetPath%"
if %ERRORLEVEL% neq 0 (
    echo Failed to copy HPWmiProvider.cat.
    goto :exit_fail
)
echo HPWmiProvider.cat copied successfully.

REM Install MSI silently
msiexec /i "%_msiPath%" /qn
set "_retCode=%ERRORLEVEL%"
if not "%_retCode%"=="0" (
    echo MSI installation failed. Error code: %_retCode%
    goto :exit_fail
)

REM Check if HPAccessoryWMIProvider is already installed via ProductCode
REG QUERY "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{53447511-F496-4CCD-B6A2-155DEA4FDC15}" >nul 2>&1
if %ERRORLEVEL%==0 (
    echo HPAccessoryWMIProvider is already installed. Skipping installation.
) else (
    echo HPAccessoryWMIProvider not found. Starting installation...
    pushd Manageability
    HPAccessoryWMIProvider.exe /S /v"/qn REBOOT=ReallySuppress"
    set "_retCode=%ERRORLEVEL%"
    popd
    if not "%_retCode%"=="0" (
        echo HPAccessoryWMIProvider installation failed. Error code: %_retCode%
        goto :exit_fail
    )
    echo HPAccessoryWMIProvider installed successfully.
)

REM Run HPFirmwareInstaller with or without silent switch
if "%isSilent%"=="1" (
    HPFirmwareInstaller.exe -s
) else (
    HPFirmwareInstaller.exe
)
set "_retCode=%ERRORLEVEL%"

:exit_fail
popd
exit /b %_retCode%
