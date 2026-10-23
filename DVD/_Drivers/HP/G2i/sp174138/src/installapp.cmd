REM ========================================================
REM   UWP Appx deliverable installation
REM ========================================================

@ECHO OFF
SET "Template=v2.10.ps"
SET "TARGETIMAGE="
if /i not "%~1" == "" if exist "%~1" SET "TARGETIMAGE=%~1"
if defined FCC_LOG_FOLDER (SET "APP_LOG_FOLDER=%FCC_LOG_FOLDER%") else ( if defined TARGETIMAGE (SET "APP_LOG_FOLDER=%TARGETIMAGE%\programdata\hp\logs\app") else (SET "APP_LOG_FOLDER=%ProgramData%\hp\logs\app"))
set PartNumber=
for /f "delims=" %%a in ('dir /a-d /b "%~dp0..\*.CVA" 2^>nul') do (if /i not "%%~a" == "" set PartNumber=%%~na)
if defined PartNumber (SET "APP_LOG=%APP_LOG_FOLDER%\%PartNumber%.LOG") else (SET "APP_LOG=%APP_LOG_FOLDER%\%~n0.log")
if not exist "%APP_LOG_FOLDER%" md "%APP_LOG_FOLDER%"

ECHO ############################################################# >> %APP_LOG%
ECHO  [%DATE%]                                                     >> %APP_LOG%
ECHO  [%TIME%] Beginning of the %~nx0, Ver: %Template%             >> %APP_LOG%
ECHO ############################################################# >> %APP_LOG%

REM ------------------- Script Entry ------------------------
:INSTALL
if not exist "%APP_LOG_FOLDER%\scratchdir" md "%APP_LOG_FOLDER%\scratchdir"
SET DISMCMD=%WINDIR%\System32\DISM.exe /Online /scratchdir:"%APP_LOG_FOLDER%\scratchdir" /LogPath:"%APP_LOG_FOLDER%\dism.log"
if defined TARGETIMAGE SET DISMCMD=%WINDIR%\System32\DISM.exe /image:%TARGETIMAGE% /scratchdir:"%APP_LOG_FOLDER%\scratchdir" /LogPath:"%APP_LOG_FOLDER%\dism.log"
SET "DISMCMD=%DISMCMD:\\=\%"

for /f "delims=" %%i in ('dir /s /b /a-d "%WINDIR%\System32\WindowsPowerShell\powershell.exe"') do ( set "PowershellPath=%%~i" )
if defined TARGETIMAGE SET PowershellPath=

echo [%TIME%] UWP Application Install >> %APP_LOG%
set errorlevel=
for /d %%a in ("%~dp0APP" "%~dp0APP\*") do (
    echo [%TIME%] Search UWP Application in %%~fa >> %APP_LOG%
    dir "%%~fa" /a-d > nul 2>&1
    if not errorlevel 1 (
        call:UwpInst "%%~fa" >> %APP_LOG%
        if errorlevel 2 echo [%TIME%] Install failed. >> %APP_LOG% & goto RESULTFAILED
        if errorlevel 1 echo [%TIME%] No package found. >> %APP_LOG%
        echo [%TIME%] Install success. >> %APP_LOG%
    ) else (
        echo [%TIME%] No UWP App found >> %APP_LOG%
    )
)
if exist "%APP_LOG_FOLDER%\scratchdir" rd /q /s "%APP_LOG_FOLDER%\scratchdir"

GOTO END

:UwpInst
if not exist "%~1" echo [%TIME%] could not found the path & exit /b 1
set "Package="
set "LicenseFile="
set "DependencyPackages="

FOR /F "delims=" %%i in ('dir /a-d /b "%~1\*.*xbundle" 2^>nul') DO (call set "Package=%~1\%%~i")
FOR /F "delims=" %%i in ('dir /a-d /b "%~1\*.xml" 2^>nul') DO (call set "LicenseFile=%~1\%%~i")
FOR /F "delims=" %%i in ('dir /a-d /b "%~1\*_*__8wekyb3d8bbwe*" 2^>nul') DO (call set "DependencyPackages=%%DependencyPackages%% /DependencyPackagePath:"%~1\%%~i"")

if not defined Package if defined LicenseFile (	if exist "%LicenseFile:~0,-4%.appx" set "Package=%LicenseFile:~0,-4%.appx" )
if not defined Package if defined LicenseFile ( for /f "delims=" %%i in ('dir /a-d /b "%LicenseFile:_License1.xml=%.*"') do ( if exist "%~1\%%~i" call set "Package=%~1\%%~i" ) )

if not defined Package echo [%TIME%] Could not found the package & exit /b 1
if not defined LicenseFile echo [%TIME%] Could not found license file & exit /b 1

SET "DISM_Command=/Add-ProvisionedAppxPackage /PackagePath:"%Package%" /Region="all" /LicensePath:"%LicenseFile%"%DependencyPackages%"

echo [%TIME%] %DISMCMD% %DISM_Command%
echo [%TIME%] %DISMCMD% %DISM_Command% >> %APP_LOG_FOLDER%\cmdline.txt
%DISMCMD% %DISM_Command%
if [%errorlevel%] == [0] echo [%TIME%] DISM command success & exit /b 0

set "DisplayName="
if exist "%~1\AUMIDs.txt" FOR /F "usebackq delims=_" %%i in ("%~1\AUMIDs.txt") do set "DisplayName=%%i"
if not defined DisplayName echo [%TIME%] Could not found the DisplayName & exit /b 2
echo [%TIME%] %DISMCMD% /get-provisionedappxpackages ^| find /i "%DisplayName%" 
%DISMCMD% /get-provisionedappxpackages | find /i "%DisplayName%"
echo [%TIME%] ErrorCode=%errorlevel%
if [%errorlevel%] == [0] echo [%TIME%] Override previous error if a version of the appx is already installed & exit /b 0
if not defined PowershellPath echo [%TIME%] DISM command fail & exit /b 2

echo [%TIME%] %PowershellPath% -executionpolicy bypass -command "& {Get-AppxPackage *%DisplayName%* -AllUsers}" ^| find /i ": %DisplayName%"
%PowershellPath% -executionpolicy bypass -command "& {Get-AppxPackage *%DisplayName%* -AllUsers}" | find /i ": %DisplayName%"
echo [%TIME%] ErrorCode=%errorlevel%
if [%errorlevel%] == [0] echo [%TIME%] Override previous error if a version of the appx is already installed by other user & exit /b 0

echo [%TIME%] DISM command fail & exit /b 2
GOTO:EOF

:RESULTFAILED
ECHO ERRORLEVEL=%ERRORLEVEL% >> %APP_LOG%
EXIT /B 1
GOTO END

:END
EXIT /B 0
