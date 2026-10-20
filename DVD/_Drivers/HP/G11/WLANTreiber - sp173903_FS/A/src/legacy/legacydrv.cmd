REM ========================================================
REM   Legacy driver install
REM ========================================================

@ECHO OFF
SET "Template=v2.09.ps"
CHCP 437 >nul
if defined FCC_LOG_FOLDER (SET "APP_LOG_FOLDER=%FCC_LOG_FOLDER%") else (SET "APP_LOG_FOLDER=%ProgramData%\hp\logs")
set PartNumber=
for /f "delims=" %%a in ('dir /a-d /b /s "%~dp0..\..\*.CVA" 2^>nul') do (if /i not "%%~a" == "" set PartNumber=%%~na)
if not defined APP_LOG if defined PartNumber (SET "APP_LOG=%APP_LOG_FOLDER%\%PartNumber%.LOG") else (SET "APP_LOG=%APP_LOG_FOLDER%\%~n0.log")
if not exist "%APP_LOG_FOLDER%" md "%APP_LOG_FOLDER%"

ECHO ############################################################# 
ECHO  [%DATE%] %PartNumber%                                        
ECHO  [%TIME%] Beginning of the %~nx0, Ver: %Template%             
ECHO ############################################################# 

REM ------------------- Script Entry ------------------------
SET errorlevel=

cmd.exe /C copy /Y .\IntelWLANdriver.dll "C:\Windows\System32\drivers"

rem <TODO> Set the function name in FuncName variable
Set "FuncName="
rem <TODO> Set the function fail message in FuncErrorMsg variable
Set "FuncErrorMsg="
ECHO [%TIME%] Start - %FuncName% >>%APP_LOG%

rem <TODO> Insert install command here, if any
rem Assuming that the installation should not cause reboot automatically nor require reboot

IF errorlevel 1 (CALL:RESULTFAILED "%FuncErrorMsg%") ELSE (CALL:RESULTPASSED)
ECHO [%TIME%] End - %FuncName% >>%APP_LOG%
	
GOTO END

:RESULTPASSED
ECHO RESULT=PASSED 
EXIT /B

:RESULTFAILED
IF /i "%~1" == "" (SET "ErrorMessage=Unknown, Err=[%errorlevel%]") ELSE (SET "ErrorMessage=%~1, Err=[%errorlevel%]")
ECHO ErrorMessage=%ErrorMessage% 
ECHO RESULT=FAILED 
EXIT /B

:END
ECHO ############################################################# 
ECHO [%DATE%] %PartNumber%                                         
ECHO [%TIME%] Completed of the %~f0                                
ECHO ############################################################# 

POPD
@ECHO ON
