REM ========================================================
REM   Driver uninstallation
REM ========================================================

@ECHO OFF
SET "Template=v2.05.ps"
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
REM Create folders
SET errflg=0
SET "pblock=%~dp0"
pushd "%pblock%"
md c:\hp\bridge
md c:\programdata\hp\bridge
md c:\programdata\hp\registration
md c:\hp\HPQWare\bridge
pushd "legacy"
xcopy ".\oobeparts\oobe1.txt" "c:\hp\bridge" /s/e/y >> "%APP_LOG%" 2>&1
If %Errorlevel% NEQ 0 (set errflg=%Errorlevel%)
@echo %date% %time%  copy oobe1.txt : Error Level "%errflg%" >> "%APP_LOG%"
xcopy ".\oobeparts\sub1.txt" "c:\hp\bridge" /s/e/y >> "%APP_LOG%" 2>&1
If %Errorlevel% NEQ 0 (set errflg=%Errorlevel%)
@echo %date% %time%  copy sub1.txt : Error Level "%errflg%" >> "%APP_LOG%"
xcopy ".\oobeparts\oobe2.txt" "c:\programdata\hp\bridge" /s/e/y >> "%APP_LOG%" 2>&1
If %Errorlevel% NEQ 0 (set errflg=%Errorlevel%)
@echo %date% %time%  copy oobe2.txt : Error Level "%errflg%" >> "%APP_LOG%"
xcopy ".\oobeparts\sub2.txt" "c:\programdata\hp\bridge" /s/e/y >> "%APP_LOG%" 2>&1
If %Errorlevel% NEQ 0 (set errflg=%Errorlevel%)
@echo %date% %time%  copy sub2.txt : Error Level "%errflg%" >> "%APP_LOG%"
xcopy ".\oobeparts\oobe3.txt" "c:\programdata\hp\registration" /s/e/y >> "%APP_LOG%" 2>&1
If %Errorlevel% NEQ 0 (set errflg=%Errorlevel%)
@echo %date% %time%  copy oobe3.txt : Error Level "%errflg%" >> "%APP_LOG%"
xcopy ".\oobeparts\sub3.txt" "c:\programdata\hp\registration" /s/e/y >> "%APP_LOG%" 2>&1
If %Errorlevel% NEQ 0 (set errflg=%Errorlevel%)
@echo %date% %time%  copy sub3.txt : Error Level "%errflg%" >> "%APP_LOG%"
xcopy ".\oobeparts\oobe4.txt" "c:\hp\HPQWare\bridge" /s/e/y >> "%APP_LOG%" 2>&1
If %Errorlevel% NEQ 0 (set errflg=%Errorlevel%)
@echo %date% %time%  copy oobe4.txt : Error Level "%errflg%" >> "%APP_LOG%"
xcopy ".\oobeparts\sub4.txt" "c:\hp\HPQWare\bridge" /s/e/y >> "%APP_LOG%" 2>&1
If %Errorlevel% NEQ 0 (set errflg=%Errorlevel%)
@echo %date% %time%  copy sub4.txt : Error Level "%errflg%" >> "%APP_LOG%"
echo.>> "%APP_LOG%"

icacls "c:\hp\bridge\oobe1.txt" /inheritance:r /grant:r *S-1-5-18:(F) /grant:r *S-1-5-32-544:(F) /grant:r *S-1-5-20:(R,W) >> "%APP_LOG%" 2>&1
If %Errorlevel% NEQ 0 (set errflg=%Errorlevel%)
@echo %date% %time%  modify oobe1.txt permissions : Error Level "%errflg%" >> "%APP_LOG%"
icacls "c:\hp\bridge\oobe1.txt" /setowner *S-1-5-18 >> "%APP_LOG%" 2>&1
If %Errorlevel% NEQ 0 (set errflg=%Errorlevel%)
@echo %date% %time%  modify oobe1.txt owner : Error Level "%errflg%" >> "%APP_LOG%"
icacls "c:\hp\bridge\sub1.txt" /inheritance:r /grant:r *S-1-5-18:(F) /grant:r *S-1-5-32-544:(F) /grant:r *S-1-5-20:(R,W) >> "%APP_LOG%" 2>&1
If %Errorlevel% NEQ 0 (set errflg=%Errorlevel%)
@echo %date% %time%  modify sub1.txt permissions : Error Level "%errflg%" >> "%APP_LOG%"
icacls "c:\hp\bridge\sub1.txt" /setowner *S-1-5-18 >> "%APP_LOG%" 2>&1
If %Errorlevel% NEQ 0 (set errflg=%Errorlevel%)
@echo %date% %time%  modify sub1.txt owner : Error Level "%errflg%" >> "%APP_LOG%"
icacls "c:\hp\bridge" /deny Everyone:(OI)(CI)(DE,DC) >> "%APP_LOG%" 2>&1
If %Errorlevel% NEQ 0 (set errflg=%Errorlevel%)
@echo %date% %time%  /deny Everyone:(OI)(CI)(DE,DC) : Error Level "%errflg%" >> "%APP_LOG%"
If %errflg% EQU 1332 (set errflg=0)
@echo %date% %time%  /deny Everyone:(OI)(CI)(DE,DC) : Error Level "%errflg%" >> "%APP_LOG%"
icacls "c:\hp\bridge" /setowner *S-1-5-18 >> "%APP_LOG%" 2>&1
If %Errorlevel% NEQ 0 (set errflg=%Errorlevel%)
@echo %date% %time%  modify folder owner : Error Level "%errflg%" >> "%APP_LOG%"
icacls "c:\programdata\hp\bridge\oobe2.txt" /inheritance:r /grant:r *S-1-5-18:(F) /grant:r *S-1-5-32-544:(F) /grant:r *S-1-5-20:(R,W) >> "%APP_LOG%" 2>&1
If %Errorlevel% NEQ 0 (set errflg=%Errorlevel%)
@echo %date% %time%  modify oobe2.txt permissions : Error Level "%errflg%" >> "%APP_LOG%"
icacls "c:\programdata\hp\bridge\oobe2.txt" /setowner *S-1-5-18 >> "%APP_LOG%" 2>&1
If %Errorlevel% NEQ 0 (set errflg=%Errorlevel%)
@echo %date% %time%  modify oobe2.txt owner : Error Level "%errflg%" >> "%APP_LOG%"
icacls "c:\programdata\hp\bridge\sub2.txt" /inheritance:r /grant:r *S-1-5-18:(F) /grant:r *S-1-5-32-544:(F) /grant:r *S-1-5-20:(R,W) >> "%APP_LOG%" 2>&1
If %Errorlevel% NEQ 0 (set errflg=%Errorlevel%)
@echo %date% %time%  modify sub2.txt permissions : Error Level "%errflg%" >> "%APP_LOG%"
icacls "c:\programdata\hp\bridge\sub2.txt" /setowner *S-1-5-18 >> "%APP_LOG%" 2>&1
If %Errorlevel% NEQ 0 (set errflg=%Errorlevel%)
@echo %date% %time%  modify sub2.txt owner : Error Level "%errflg%" >> "%APP_LOG%"
icacls "c:\programdata\hp\registration\oobe3.txt" /inheritance:r /grant:r *S-1-5-18:(F) /grant:r *S-1-5-32-544:(F) /grant:r *S-1-5-20:(R,W) >> "%APP_LOG%" 2>&1
If %Errorlevel% NEQ 0 (set errflg=%Errorlevel%)
icacls "c:\programdata\hp\bridge" /deny Everyone:(OI)(CI)(DE,DC) >> "%APP_LOG%" 2>&1
If %Errorlevel% NEQ 0 (set errflg=%Errorlevel%)
@echo %date% %time%  /deny Everyone:(OI)(CI)(DE,DC) : Error Level "%errflg%" >> "%APP_LOG%"
If %errflg% EQU 1332 (set errflg=0)
@echo %date% %time%  /deny Everyone:(OI)(CI)(DE,DC) : Error Level "%errflg%" >> "%APP_LOG%"
icacls "c:\programdata\hp\bridge" /setowner *S-1-5-18 >> "%APP_LOG%" 2>&1
If %Errorlevel% NEQ 0 (set errflg=%Errorlevel%)
@echo %date% %time%  modify folder owner : Error Level "%errflg%" >> "%APP_LOG%"
@echo %date% %time%  modify oobe3.txt permissions : Error Level "%errflg%" >> "%APP_LOG%"
icacls "c:\programdata\hp\registration\oobe3.txt" /setowner *S-1-5-18 >> "%APP_LOG%" 2>&1
If %Errorlevel% NEQ 0 (set errflg=%Errorlevel%)
@echo %date% %time%  modify oobe3.txt owner : Error Level "%errflg%" >> "%APP_LOG%"
icacls "c:\programdata\hp\registration\sub3.txt" /inheritance:r /grant:r *S-1-5-18:(F) /grant:r *S-1-5-32-544:(F) /grant:r *S-1-5-20:(R,W) >> "%APP_LOG%" 2>&1
If %Errorlevel% NEQ 0 (set errflg=%Errorlevel%)
@echo %date% %time%  modify sub3.txt permissions : Error Level "%errflg%" >> "%APP_LOG%"
icacls "c:\programdata\hp\registration\sub3.txt" /setowner *S-1-5-18 >> "%APP_LOG%" 2>&1
If %Errorlevel% NEQ 0 (set errflg=%Errorlevel%)
@echo %date% %time%  modify sub3.txt owner : Error Level "%errflg%" >> "%APP_LOG%"
icacls "c:\programdata\hp\registration" /deny Everyone:(OI)(CI)(DE,DC) >> "%APP_LOG%" 2>&1
If %Errorlevel% NEQ 0 (set errflg=%Errorlevel%)
@echo %date% %time%  /deny Everyone:(OI)(CI)(DE,DC) : Error Level "%errflg%" >> "%APP_LOG%"
If %errflg% EQU 1332 (set errflg=0)
@echo %date% %time%  /deny Everyone:(OI)(CI)(DE,DC) : Error Level "%errflg%" >> "%APP_LOG%"
icacls "c:\programdata\hp\registration" /setowner *S-1-5-18 >> "%APP_LOG%" 2>&1
If %Errorlevel% NEQ 0 (set errflg=%Errorlevel%)
@echo %date% %time%  modify folder owner : Error Level "%errflg%" >> "%APP_LOG%"
icacls "c:\hp\HPQWare\bridge\oobe4.txt" /inheritance:r /grant:r *S-1-5-18:(F) /grant:r *S-1-5-32-544:(F) /grant:r *S-1-5-20:(R,W) >> "%APP_LOG%" 2>&1
If %Errorlevel% NEQ 0 (set errflg=%Errorlevel%)
@echo %date% %time%  modify oobe4.txt permissions : Error Level "%errflg%" >> "%APP_LOG%"
icacls "c:\hp\HPQWare\bridge\oobe4.txt" /setowner *S-1-5-18 >> "%APP_LOG%" 2>&1
If %Errorlevel% NEQ 0 (set errflg=%Errorlevel%)
@echo %date% %time%  modify oobe4.txt owner : Error Level "%errflg%" >> "%APP_LOG%"
icacls "c:\hp\HPQWare\bridge\sub4.txt" /inheritance:r /grant:r *S-1-5-18:(F) /grant:r *S-1-5-32-544:(F) /grant:r *S-1-5-20:(R,W) >> "%APP_LOG%" 2>&1
If %Errorlevel% NEQ 0 (set errflg=%Errorlevel%)
@echo %date% %time%  modify sub4.txt permissions : Error Level "%errflg%" >> "%APP_LOG%"
icacls "c:\hp\HPQWare\bridge\sub4.txt" /setowner *S-1-5-18 >> "%APP_LOG%" 2>&1
If %Errorlevel% NEQ 0 (set errflg=%Errorlevel%)
@echo %date% %time%  modify sub4.txt owner : Error Level "%errflg%" >> "%APP_LOG%"
icacls "c:\hp\HPQWare\bridge" /deny Everyone:(OI)(CI)(DE,DC) >> "%APP_LOG%" 2>&1
If %Errorlevel% NEQ 0 (set errflg=%Errorlevel%)
@echo %date% %time%  /deny Everyone:(OI)(CI)(DE,DC) : Error Level "%errflg%" >> "%APP_LOG%"
If %errflg% EQU 1332 (set errflg=0)
@echo %date% %time%  /deny Everyone:(OI)(CI)(DE,DC) : Error Level "%errflg%" >> "%APP_LOG%"
icacls "c:\hp\HPQWare\bridge" /setowner *S-1-5-18 >> "%APP_LOG%" 2>&1
If %Errorlevel% NEQ 0 (set errflg=%Errorlevel%)
@echo %date% %time%  modify folder owner : Error Level "%errflg%" >> "%APP_LOG%"
echo.>> "%APP_LOG%"


REM only stop Fusion services when Image state is incomplete.
set "ImageState=IMAGE_STATE"
for /f "tokens=3" %%A IN ('REG QUERY "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Setup\State" /v ImageState') DO SET "ImageState=%%A"
echo [%date%-%time%]  for Error Level="%errorlevel%" >> "%APP_LOG%"
echo [%date%-%time%]  ImageState="%ImageState%" >> "%APP_LOG%"
if not "%ImageState%"=="IMAGE_STATE_COMPLETE" (
    echo [%date%-%time%]  Stop Fusion services  >> "%APP_LOG%"
	sc stop hpsysinfocap >> "%APP_LOG%" 2>&1
	sc stop hpapphelpercap >> "%APP_LOG%" 2>&1
	sc stop hpnetworkcap >> "%APP_LOG%" 2>&1
	sc stop hpdiagscap >> "%APP_LOG%" 2>&1

	taskkill /f /im sysinfocap.exe >> "%APP_LOG%" 2>&1
	taskkill /f /im apphelpercap.exe >> "%APP_LOG%" 2>&1
	taskkill /f /im networkcap.exe >> "%APP_LOG%" 2>&1
	taskkill /f /im diagscap.exe >> "%APP_LOG%" 2>&1

    echo [%date%-%time%]  Service Stop Error Level="%errorlevel%" >> "%APP_LOG%"
)

echo Windows Registry Editor Version 5.00 > HPAppEnablingServicesExtensionInjectionAttempted.reg
echo.>> HPAppEnablingServicesExtensionInjectionAttempted.reg
echo [HKEY_LOCAL_MACHINE\SOFTWARE\HP\Bridge] >> HPAppEnablingServicesExtensionInjectionAttempted.reg
echo "HPAppEnablingServicesExtensionInjectionAttempted"=- >> HPAppEnablingServicesExtensionInjectionAttempted.reg
echo.>> HPAppEnablingServicesExtensionInjectionAttempted.reg

if exist AppEnablingServicesExtPre_x64\ (
echo %date% %time%  Copying over HP Application Enabling Services Extension x64 Preload >> "%APP_LOG%"
if not exist "c:\Program Files\HP\AppEnablingServicesExtPre\" md "c:\Program Files\HP\AppEnablingServicesExtPre\"
if exist "c:\Program Files\HP\AppEnablingServicesExtPre\x64\*" del /f /q "c:\Program Files\HP\AppEnablingServicesExtPre\x64\*.*"
if exist "c:\Program Files\HP\AppEnablingServicesExtPre\arm64\*" del /f /q "c:\Program Files\HP\AppEnablingServicesExtPre\arm64\*.*"
if exist "c:\Program Files\HP\AppEnablingServicesExtPre\*" del /f /q "c:\Program Files\HP\AppEnablingServicesExtPre\*.*"
xcopy /f /v /s /h /r /e /y "AppEnablingServicesExtPre_x64\" "c:\Program Files\HP\AppEnablingServicesExtPre\" >> "%APP_LOG%" 2>&1
attrib +h "C:\Program Files\HP\AppEnablingServicesExtPre" /d >> "%APP_LOG%" 2>&1
c:\Windows\regedit.exe /s HPAppEnablingServicesExtensionInjectionAttempted.reg >> "%APP_LOG%" 2>&1
)

if exist HPAppEnablingServicesExtensionInjectionAttempted.reg del /f /q HPAppEnablingServicesExtensionInjectionAttempted.reg
echo test
echo %cd%  >> "%APP_LOG%"

:Recovery

REM The DASH process clears the C:\SWSETUP\ folder anyway
REM if "%ImageState%"=="IMAGE_STATE_COMPLETE" echo [%time%-%date%]  We are at the desktop. We're not merging Recovery Push Button Recovery - Reset this PC for HP Consent Manager Launcher >> "%APP_LOG%"
REM if "%ImageState%"=="IMAGE_STATE_COMPLETE" GOTO ExitRecovery

REM BasicReset_BeforeImageApply. Runs the specified program at extensibility point A.
REM BasicReset_AfterImageApply. Runs the specified program at extensibility point B.      We will appy the patch here
REM FactoryReset_BeforeDiskFormat. Runs the specified program at extensibility point C.
REM FactpruReset_AfterImageApply. Runs the specified program at extensibility point D.    We will appy the patch here also

if "%ImageState%"=="IMAGE_STATE_COMPLETE" GOTO ExitRecovery
REM Debug
REM if "%ImageState%" NEQ "IMAGE_STATE_COMPLETE" GOTO ExitRecovery

echo [%time%-%date%]  Push Button Reset - Reset this PC - Restoring the HP Consent Manager Launcher Scheduled Task >> "%APP_LOG%"

REM Copy info folder to Windows Reset paths, it will be dumped back after Reset

md c:\Recovery\OEM\Point_B\AppEnablingServicesExtPre\ >> "%APP_LOG%" 2>&1
md c:\Recovery\OEM\Point_D\AppEnablingServicesExtPre\ >> "%APP_LOG%" 2>&1

xcopy /f /v /s /h /r /e /y "AppEnablingServicesExtPre_x64\" "c:\Recovery\OEM\Point_B\AppEnablingServicesExtPre\" >> "%APP_LOG%" 2>&1
xcopy /f /v /s /h /r /e /y "AppEnablingServicesExtPre_x64\" "c:\Recovery\OEM\Point_D\AppEnablingServicesExtPre\" >> "%APP_LOG%" 2>&1


REM Copy the Reset script to Reset path
copy /y FusionExtPreloadReset.cmd "C:\Recovery\OEM\Point_D\" >> "%APP_LOG%" 2>&1
copy /y FusionExtPreloadReset.cmd "C:\Recovery\OEM\Point_B\" >> "%APP_LOG%" 2>&1
echo.>> "%APP_LOG%"

:ExitRecovery

popd

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
ECHO ERRORLEVEL=%ERRORLEVEL% >> "%APP_LOG%"

popd

EXIT /B 1
GOTO END

:END
EXIT /B 0