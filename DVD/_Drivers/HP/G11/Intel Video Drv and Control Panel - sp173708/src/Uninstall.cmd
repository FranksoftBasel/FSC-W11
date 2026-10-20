REM ========================================================
REM   Driver uninstallation
REM ========================================================

@ECHO OFF
SET "Template=v2.08.ps"
SET "TARGETIMAGE="
if /i not "%~1" == "" if exist "%~1" SET "TARGETIMAGE=%~1"
if defined FCC_LOG_FOLDER (SET "APP_LOG_FOLDER=%FCC_LOG_FOLDER%") else ( if defined TARGETIMAGE (SET "APP_LOG_FOLDER=%TARGETIMAGE%\programdata\hp\logs") else (SET "APP_LOG_FOLDER=%ProgramData%\hp\logs"))
set PartNumber=
for /f "delims=" %%a in ('dir /a-d /b "%~dp0..\*.CVA" 2^>nul') do (if /i not "%%~a" == "" set PartNumber=%%~na)
if defined PartNumber (SET "APP_LOG=%APP_LOG_FOLDER%\%PartNumber%.LOG") else (SET "APP_LOG=%APP_LOG_FOLDER%\%~n0.log")
if not exist "%APP_LOG_FOLDER%" md "%APP_LOG_FOLDER%"

ECHO ############################################################# >> %APP_LOG%
ECHO  [%DATE%]                                                     >> %APP_LOG%
ECHO  [%TIME%] Beginning of the %~nx0, Ver: %Template%             >> %APP_LOG%
ECHO ############################################################# >> %APP_LOG%

echo Driver uninstalling ... >> "%APP_LOG%"
echo. >> "%APP_LOG%"

rem
rem At this point, the current folder is src. It's recommended to refer to any folders/files
rem under it using relative path (.\) to avoid potential space-character issues in paths.
rem

rem
rem <TODO> Insert uninstall operations here, if any
rem Assuming that the uninstallation should not cause reboot automatically nor require reboot
rem before the installation of the new driver


GOTO END


:RESULTFAILED
ECHO ERRORLEVEL=%ERRORLEVEL% >> %APP_LOG%
EXIT /B 1
GOTO END

:END
EXIT /B 0