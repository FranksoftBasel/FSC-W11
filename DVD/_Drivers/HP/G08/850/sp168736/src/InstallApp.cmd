@echo on
cls
set version=1.05
set versionapp=v8.10.50.0
set errcode=0

FOR /F "tokens=2 delims=._" %%i in ('type "%~dp0\app\AUMIDs.txt"') DO SET APP_Title=%%i
REM =============================================================================
REM  REMOVE REM FROM NEXT LINE AND DEFINE YOUR OWN LOG FILE NAME
REM  BY DEFAULT, THIS WILL USE THE STRING WITHIN AUMIDs.txt as APP_Title.
SET APP_Title=HP_Hotkey_System_Information
REM =============================================================================
rem
rem Loggings of the UWP installation are captured in these logs for debugging purpose
rem
set Log_Folder=%~d0\programdata\hp\logs\UWP
if not exist "%Log_Folder%" md "%Log_Folder%"

set APP_Log=%Log_Folder%\%APP_Title%.log
set APPDISM_Log=%Log_Folder%\%APP_Title%_DISM.log
set DISMCMD=%WINDIR%\System32\DISM.exe /scratchdir:"%Log_Folder%" /LogPath:"%APPDISM_Log%"

rem set APPX_NAME=332f98ad6dbe422c8589c7044a822c2e
set APPX_NAME=332f98ad6dbe422c8589c7044a822c2e
set VCLIBS_DEPENDENCY=Microsoft.VCLibs.140.00_14.0.33519.0


echo %date% %time% APP File Name = %APP_Log%
echo %date% %time% APP File Name = %APPX_NAME% >> %APP_Log%
echo %date% %time% Libs Dependency = %VCLIBS_DEPENDENCY%
echo %date% %time% Libs Dependency = %VCLIBS_DEPENDENCY% >> %APP_Log%


:: Checking Added that App will be installed if there is ACPI\HPQ8002 node is present
REG QUERY HKLM\SYSTEM\CurrentControlSet\Enum\ACPI /f "HPQ8002"
if %ERRORLEVEL% == 0 ( goto install ) else ( goto notinstall )

echo %date% %time% Node Status = %ERRORLEVEL%
echo %date% %time% Node Status = %ERRORLEVEL% >> %APP_Log%

:install
echo %date% %time% HP PS2 Internal KB(HPQ8002) Found. So App will be installed.
echo %date% %time% HP PS2 Internal KB(HPQ8002) Found. So App will be installed. >> %APP_Log%
echo %date% %time% Installing HP System Information Application
echo %date% %time% Installing HP System Information Application >> %APP_Log%



echo %date% %time% Parameter Value = [%1] >> %APP_Log%
	
rem
rem The parameter passed from the caller, if any, is assumed to be the target offline image:
rem     <path_to_offline_image>
rem
rem to specify an offline Windows image to which the installation is targeted.
rem
set Param1=%1

echo *pushd "%~dp0app" >> "%APP_Log%"
pushd "%~dp0app" >> "%APP_Log%" 2>&1

echo. >> "%APP_Log%"
echo ^>^> %~f0 >> "%APP_Log%"
echo ^>^> %date% %time% >> "%APP_Log%"
echo. >> "%APP_Log%"

echo Installing "%APP_Title%"... >> "%APP_Log%"
echo. >> "%APP_Log%"

if defined Param1 goto lbl_Offline


:lbl_Online

set TargetImage=/online
goto lbl_CommonOps


:lbl_Offline

set TargetImage=/image:%Param1%
goto lbl_CommonOps


:lbl_CommonOps
SET apploc=%~dp0app
SET arch=x64
if "%processor_architecture%"=="arm64" set arch=arm64
setlocal EnableDelayedExpansion
FOR /R ".\" %%i in (*.*xbundle) DO SET package=%%~nxi
FOR /R ".\" %%i in (*.xml) DO SET License1XML=%%~nxi
FOR /R ".\" %%i in (*_%arch%__8wekyb3d8bbwe*) DO (
    SET DependencyPackage=!DependencyPackage! /DependencyPackagePath:"%apploc%\%%~nxi"
)
set basename=%License1XML:~,-13%
if not defined package (
    FOR /R ".\" %%i in (%basename%.*) DO SET package=%%~nxi
)
setlocal disabledelayedExpansion

SET DISM_Command=/Add-ProvisionedAppxPackage /PackagePath:"%apploc%\%package%" /region="all" /LicensePath:"%apploc%\%License1XML%" %DependencyPackage%

REM GET APPID FOR INSTALLATION CHECK
FOR /F "delims=_" %%i in (.\AUMIDs.txt) do set DisplayName=%%i
set AppInstalled=0

REM App installation 
echo *%DISMCMD% %TargetImage% %DISM_Command% >> "%APP_Log%"
%DISMCMD% %TargetImage% %DISM_Command% >> "%APP_Log%" 2>&1
set errcode=%errorlevel% 
echo returncode=%errcode% >> "%APP_Log%"
if "%errcode%"=="0" goto :End_InstallApp

REM VERIFY INSTALL STATUS - Previous errcode could fail due to newer version is already installed
echo *%DISMCMD% %TargetImage% /get-provisionedappxpackages | find /i "%DisplayName%" >> "%APP_Log%"
%DISMCMD% %TargetImage% /get-provisionedappxpackages | find /i "%DisplayName%" >> "%APP_Log%" 2>&1
if not errorlevel 1 (
  set AppInstalled=1
  echo Override previous error if a version of the appx is already installed >> "%APP_Log%"
  set errcode=0
)
if "%errcode%"=="0" goto :End_InstallApp
echo *powershell -executionpolicy bypass -command "& {Get-AppxPackage *%DisplayName%*}" | find /i "%DisplayName%" >> "%APP_Log%"
powershell -executionpolicy bypass -command "& {Get-AppxPackage *%DisplayName%*}" | find /i "%DisplayName%" >> "%APP_Log%" 2>&1
if not errorlevel 1 (
  set AppInstalled=1
  echo Override previous error if a version of the appx is already installed >> "%APP_Log%"
  set errcode=0
)

:end_InstallApp

echo *popd >> "%APP_Log%"
popd >> "%APP_Log%" 2>&1

echo. >> "%APP_Log%"
echo Done installing "%APP_Title%"! >> "%APP_Log%"

echo. >> "%APP_Log%"
echo *exit /b %errcode% >> "%APP_Log%"
echo. >> "%APP_Log%"
echo ^<^< %~f0 >> "%APP_Log%"
echo ^<^< %date% %time% >> "%APP_Log%"
echo. >> "%APP_Log%"

exit /b %errcode%