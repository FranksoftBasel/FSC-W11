@echo on
REM templateversion=1.07.BPSASC
set versionapp=1.07.BPSASC
set errcode=0
set APP_Title=IntelAPP

FOR /F "tokens=2 delims=._" %%i in ('type "%~dp0\app\AUMIDs.txt"') DO SET APP_Title=%%i
REM =============================================================================
REM  REMOVE REM FROM NEXT LINE AND DEFINE YOUR OWN LOG FILE NAME
REM  BY DEFAULT, THIS WILL USE THE STRING WITHIN AUMIDs.txt as APP_Title.
REM SET APP_Title=Intel IMSS
REM =============================================================================
rem
rem Loggings of the UWP installation are captured in these logs for debugging purpose
rem
set Log_Folder=%programdata%\hp\logs\UWP
if not exist "%Log_Folder%" md "%Log_Folder%"
set APP_Log=%Log_Folder%\%APP_Title%.log
set APPDISM_Log=%Log_Folder%\%APP_Title%_DISM.log
set DISMCMD=%WINDIR%\System32\DISM.exe /scratchdir:"%Log_Folder%" /LogPath:"%APPDISM_Log%"

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

set DISM_Command=/Add-ProvisionedAppxPackage /PackagePath:".\57727fd555e34654b417020f639888b8.appxbundle" /LicensePath:".\57727fd555e34654b417020f639888b8_License1.xml" /DependencyPackagePath:".\Microsoft.VCLibs.140.00.UWPDesktop_14.0.33728.0_x64__8wekyb3d8bbwe.appx" /region="all"

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
echo *powershell -executionpolicy bypass -command "& {Get-AppxPackage *%DisplayName%* -AllUsers}" | find /i "%DisplayName%" >> "%APP_Log%"
powershell -executionpolicy bypass -command "& {Get-AppxPackage *%DisplayName%* -AllUsers}" | find /i "%DisplayName%" >> "%APP_Log%" 2>&1
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