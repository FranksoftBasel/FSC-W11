@echo off
set versiondrv=1.05
set errcodefusion=0

REM **************************************************************
REM DRV_Title - Avoid using space if possible
set DRV_Title=HSA.Fusion.For.Commercial
REM **************************************************************

rem
rem Loggings of the Fusion driver installation are captured for debugging purpose
rem
set Log_Folder=%programdata%\HP\logs
if not exist "%Log_Folder%" md "%Log_Folder%"
set DRV_Log=%Log_Folder%\%DRV_Title%.log
REM SET CMDLog=%Log_Folder%\cmdline.txt


echo. >> "%DRV_Log%"
echo ^>^> %~f0 >> "%DRV_Log%"
echo ^>^> %date% %time% >> "%DRV_Log%"
echo. >> "%DRV_Log%"

echo Installing "%DRV_Title%"... >> "%DRV_Log%"
echo. >> "%DRV_Log%"


echo *pushd "%~dp0Fusion" >> "%DRV_Log%"
pushd "%~dp0Fusion" >> "%DRV_Log%" 2>&1

:Install_INF
md c:\hp\bridge\
md c:\programdata\hp\bridge\
md c:\programdata\hp\registration\
md c:\hp\HPQWare\bridge\



if not exist oobeparts\ GOTO SkipOOBEParts
xcopy ".\oobeparts\oobe1.txt" "c:\hp\bridge" /s/e/y >> "%DRV_Log%" 2>&1
If %Errorlevel% NEQ 0 (set errcodefusion=%Errorlevel%)
@echo %date% %time%  copy oobe1.txt : Error Level "%errcodefusion%" >> "%DRV_Log%"
xcopy ".\oobeparts\sub1.txt" "c:\hp\bridge" /s/e/y >> "%DRV_Log%" 2>&1
If %Errorlevel% NEQ 0 (set errcodefusion=%Errorlevel%)
@echo %date% %time%  copy sub1.txt : Error Level "%errcodefusion%" >> "%DRV_Log%"
xcopy ".\oobeparts\oobe2.txt" "c:\programdata\hp\bridge" /s/e/y
If %Errorlevel% NEQ 0 (set errcodefusion=%Errorlevel%)
@echo %date% %time%  copy oobe2.txt : Error Level "%errcodefusion%" >> "%DRV_Log%"
xcopy ".\oobeparts\sub2.txt" "c:\programdata\hp\bridge" /s/e/y >> "%DRV_Log%" 2>&1
If %Errorlevel% NEQ 0 (set errcodefusion=%Errorlevel%)
@echo %date% %time%  copy sub2.txt : Error Level "%errcodefusion%" >> "%DRV_Log%"
xcopy ".\oobeparts\oobe3.txt" "c:\programdata\hp\registration" /s/e/y >> "%DRV_Log%" 2>&1
If %Errorlevel% NEQ 0 (set errcodefusion=%Errorlevel%)
@echo %date% %time%  copy oobe3.txt : Error Level "%errcodefusion%" >> "%DRV_Log%"
xcopy ".\oobeparts\sub3.txt" "c:\programdata\hp\registration" /s/e/y >> "%DRV_Log%" 2>&1
If %Errorlevel% NEQ 0 (set errcodefusion=%Errorlevel%)
@echo %date% %time%  copy sub3.txt : Error Level "%errcodefusion%" >> "%DRV_Log%"
xcopy ".\oobeparts\oobe4.txt" "c:\hp\HPQWare\bridge" /s/e/y >> "%DRV_Log%" 2>&1
If %Errorlevel% NEQ 0 (set errcodefusion=%Errorlevel%)
@echo %date% %time%  copy oobe4.txt : Error Level "%errcodefusion%" >> "%DRV_Log%"
xcopy ".\oobeparts\sub4.txt" "c:\hp\HPQWare\bridge" /s/e/y >> "%DRV_Log%" 2>&1
If %Errorlevel% NEQ 0 (set errcodefusion=%Errorlevel%)
@echo %date% %time%  copy sub4.txt : Error Level "%errcodefusion%" >> "%DRV_Log%"
echo.>> "%DRV_Log%"

icacls "c:\hp\bridge\oobe1.txt" /inheritance:r /grant:r *S-1-5-18:(F) /grant:r *S-1-5-32-544:(F) /grant:r *S-1-5-20:(R,W) >> "%DRV_Log%" 2>&1
If %Errorlevel% NEQ 0 (set errcodefusion=%Errorlevel%)
@echo %date% %time%  modify oobe1.txt permissions : Error Level "%errcodefusion%" >> "%DRV_Log%"
icacls "c:\hp\bridge\oobe1.txt" /setowner *S-1-5-18 >> "%DRV_Log%" 2>&1
If %Errorlevel% NEQ 0 (set errcodefusion=%Errorlevel%)
@echo %date% %time%  modify oobe1.txt owner : Error Level "%errcodefusion%" >> "%DRV_Log%"
icacls "c:\hp\bridge\sub1.txt" /inheritance:r /grant:r *S-1-5-18:(F) /grant:r *S-1-5-32-544:(F) /grant:r *S-1-5-20:(R,W) >> "%DRV_Log%" 2>&1
If %Errorlevel% NEQ 0 (set errcodefusion=%Errorlevel%)
@echo %date% %time%  modify sub1.txt permissions : Error Level "%errcodefusion%" >> "%DRV_Log%"
icacls "c:\hp\bridge\sub1.txt" /setowner *S-1-5-18 >> "%DRV_Log%" 2>&1
If %Errorlevel% NEQ 0 (set errcodefusion=%Errorlevel%)
@echo %date% %time%  modify sub1.txt owner : Error Level "%errcodefusion%" >> "%DRV_Log%"
icacls "c:\hp\bridge" /deny Everyone:(OI)(CI)(DE,DC) >> "%DRV_Log%" 2>&1
If %Errorlevel% NEQ 0 (set errcodefusion=%Errorlevel%)
@echo %date% %time%  /deny Everyone:(OI)(CI)(DE,DC) : Error Level "%errcodefusion%" >> "%DRV_Log%"
If %errcodefusion% EQU 1332 (set errcodefusion=0)
@echo %date% %time%  /deny Everyone:(OI)(CI)(DE,DC) : Error Level "%errcodefusion%" >> "%DRV_Log%"
icacls "c:\hp\bridge" /setowner *S-1-5-18 >> "%DRV_Log%" 2>&1
If %Errorlevel% NEQ 0 (set errcodefusion=%Errorlevel%)
@echo %date% %time%  modify folder owner : Error Level "%errcodefusion%" >> "%DRV_Log%"
icacls "c:\programdata\hp\bridge\oobe2.txt" /inheritance:r /grant:r *S-1-5-18:(F) /grant:r *S-1-5-32-544:(F) /grant:r *S-1-5-20:(R,W) >> "%DRV_Log%" 2>&1
If %Errorlevel% NEQ 0 (set errcodefusion=%Errorlevel%)
@echo %date% %time%  modify oobe2.txt permissions : Error Level "%errcodefusion%" >> "%DRV_Log%"
icacls "c:\programdata\hp\bridge\oobe2.txt" /setowner *S-1-5-18 >> "%DRV_Log%" 2>&1
If %Errorlevel% NEQ 0 (set errcodefusion=%Errorlevel%)
@echo %date% %time%  modify oobe2.txt owner : Error Level "%errcodefusion%" >> "%DRV_Log%"
icacls "c:\programdata\hp\bridge\sub2.txt" /inheritance:r /grant:r *S-1-5-18:(F) /grant:r *S-1-5-32-544:(F) /grant:r *S-1-5-20:(R,W) >> "%DRV_Log%" 2>&1
If %Errorlevel% NEQ 0 (set errcodefusion=%Errorlevel%)
@echo %date% %time%  modify sub2.txt permissions : Error Level "%errcodefusion%" >> "%DRV_Log%"
icacls "c:\programdata\hp\bridge\sub2.txt" /setowner *S-1-5-18 >> "%DRV_Log%" 2>&1
If %Errorlevel% NEQ 0 (set errcodefusion=%Errorlevel%)
@echo %date% %time%  modify sub2.txt owner : Error Level "%errcodefusion%" >> "%DRV_Log%"
icacls "c:\programdata\hp\registration\oobe3.txt" /inheritance:r /grant:r *S-1-5-18:(F) /grant:r *S-1-5-32-544:(F) /grant:r *S-1-5-20:(R,W) >> "%DRV_Log%" 2>&1
If %Errorlevel% NEQ 0 (set errcodefusion=%Errorlevel%)
icacls "c:\programdata\hp\bridge" /deny Everyone:(OI)(CI)(DE,DC) >> "%DRV_Log%" 2>&1
If %Errorlevel% NEQ 0 (set errcodefusion=%Errorlevel%)
@echo %date% %time%  /deny Everyone:(OI)(CI)(DE,DC) : Error Level "%errcodefusion%" >> "%DRV_Log%"
If %errcodefusion% EQU 1332 (set errcodefusion=0)
@echo %date% %time%  /deny Everyone:(OI)(CI)(DE,DC) : Error Level "%errcodefusion%" >> "%DRV_Log%"
icacls "c:\programdata\hp\bridge" /setowner *S-1-5-18 >> "%DRV_Log%" 2>&1
If %Errorlevel% NEQ 0 (set errcodefusion=%Errorlevel%)
@echo %date% %time%  modify folder owner : Error Level "%errcodefusion%" >> "%DRV_Log%"
@echo %date% %time%  modify oobe3.txt permissions : Error Level "%errcodefusion%" >> "%DRV_Log%"
icacls "c:\programdata\hp\registration\oobe3.txt" /setowner *S-1-5-18 >> "%DRV_Log%" 2>&1
If %Errorlevel% NEQ 0 (set errcodefusion=%Errorlevel%)
@echo %date% %time%  modify oobe3.txt owner : Error Level "%errcodefusion%" >> "%DRV_Log%"
icacls "c:\programdata\hp\registration\sub3.txt" /inheritance:r /grant:r *S-1-5-18:(F) /grant:r *S-1-5-32-544:(F) /grant:r *S-1-5-20:(R,W) >> "%DRV_Log%" 2>&1
If %Errorlevel% NEQ 0 (set errcodefusion=%Errorlevel%)
@echo %date% %time%  modify sub3.txt permissions : Error Level "%errcodefusion%" >> "%DRV_Log%"
icacls "c:\programdata\hp\registration\sub3.txt" /setowner *S-1-5-18 >> "%DRV_Log%" 2>&1
If %Errorlevel% NEQ 0 (set errcodefusion=%Errorlevel%)
@echo %date% %time%  modify sub3.txt owner : Error Level "%errcodefusion%" >> "%DRV_Log%"
icacls "c:\programdata\hp\registration" /deny Everyone:(OI)(CI)(DE,DC) >> "%DRV_Log%" 2>&1
If %Errorlevel% NEQ 0 (set errcodefusion=%Errorlevel%)
@echo %date% %time%  /deny Everyone:(OI)(CI)(DE,DC) : Error Level "%errcodefusion%" >> "%DRV_Log%"
If %errcodefusion% EQU 1332 (set errcodefusion=0)
@echo %date% %time%  /deny Everyone:(OI)(CI)(DE,DC) : Error Level "%errcodefusion%" >> "%DRV_Log%"
icacls "c:\programdata\hp\registration" /setowner *S-1-5-18 >> "%DRV_Log%" 2>&1
If %Errorlevel% NEQ 0 (set errcodefusion=%Errorlevel%)
@echo %date% %time%  modify folder owner : Error Level "%errcodefusion%" >> "%DRV_Log%"
icacls "c:\hp\HPQWare\bridge\oobe4.txt" /inheritance:r /grant:r *S-1-5-18:(F) /grant:r *S-1-5-32-544:(F) /grant:r *S-1-5-20:(R,W) >> "%DRV_Log%" 2>&1
If %Errorlevel% NEQ 0 (set errcodefusion=%Errorlevel%)
@echo %date% %time%  modify oobe4.txt permissions : Error Level "%errcodefusion%" >> "%DRV_Log%"
icacls "c:\hp\HPQWare\bridge\oobe4.txt" /setowner *S-1-5-18 >> "%DRV_Log%" 2>&1
If %Errorlevel% NEQ 0 (set errcodefusion=%Errorlevel%)
@echo %date% %time%  modify oobe4.txt owner : Error Level "%errcodefusion%" >> "%DRV_Log%"
icacls "c:\hp\HPQWare\bridge\sub4.txt" /inheritance:r /grant:r *S-1-5-18:(F) /grant:r *S-1-5-32-544:(F) /grant:r *S-1-5-20:(R,W) >> "%DRV_Log%" 2>&1
If %Errorlevel% NEQ 0 (set errcodefusion=%Errorlevel%)
@echo %date% %time%  modify sub4.txt permissions : Error Level "%errcodefusion%" >> "%DRV_Log%"
icacls "c:\hp\HPQWare\bridge\sub4.txt" /setowner *S-1-5-18 >> "%DRV_Log%" 2>&1
If %Errorlevel% NEQ 0 (set errcodefusion=%Errorlevel%)
@echo %date% %time%  modify sub4.txt owner : Error Level "%errcodefusion%" >> "%DRV_Log%"
icacls "c:\hp\HPQWare\bridge" /deny Everyone:(OI)(CI)(DE,DC) >> "%DRV_Log%" 2>&1
If %Errorlevel% NEQ 0 (set errcodefusion=%Errorlevel%)
@echo %date% %time%  /deny Everyone:(OI)(CI)(DE,DC) : Error Level "%errcodefusion%" >> "%DRV_Log%"
If %errcodefusion% EQU 1332 (set errcodefusion=0)
@echo %date% %time%  /deny Everyone:(OI)(CI)(DE,DC) : Error Level "%errcodefusion%" >> "%DRV_Log%"
icacls "c:\hp\HPQWare\bridge" /setowner *S-1-5-18 >> "%DRV_Log%" 2>&1
If %Errorlevel% NEQ 0 (set errcodefusion=%Errorlevel%)
@echo %date% %time%  modify folder owner : Error Level "%errcodefusion%" >> "%DRV_Log%"
echo.>> "%DRV_Log%"

:SkipOOBEParts

REM only stop Fusion services when Image state is incompleted.
set ImageState=IMAGE_STATE
for /f "tokens=3" %%A IN ('REG QUERY "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Setup\State" /v ImageState') DO SET ImageState=%%A
echo [%date%-%time%]  for Error Level="%errorlevel%" >> "%DRV_Log%"
echo [%date%-%time%]  ImageState="%ImageState%" >> "%DRV_Log%"
if not "%ImageState%"=="IMAGE_STATE_COMPLETE" (
    echo [%date%-%time%]  Stop Fusion services  >> "%DRV_Log%"
	sc stop hpsysinfocap >> "%DRV_Log%" 2>&1
	sc stop hpapphelpercap >> "%DRV_Log%" 2>&1
	sc stop hpnetworkcap >> "%DRV_Log%" 2>&1
	sc stop hpdiagscap >> "%DRV_Log%" 2>&1

	taskkill /f /im sysinfocap.exe >> "%DRV_Log%" 2>&1
	taskkill /f /im apphelpercap.exe >> "%DRV_Log%" 2>&1
	taskkill /f /im networkcap.exe >> "%DRV_Log%" 2>&1
	taskkill /f /im diagscap.exe >> "%DRV_Log%" 2>&1

    echo [%date%-%time%]  Service Stop Error Level="%errorlevel%" >> "%DRV_Log%"
)


echo %cd% >> "%DRV_Log%"
echo.>> "%DRV_Log%"
PNPUTIL.exe /add-driver hpcustomcapdriver.inf /install >> "%DRV_Log%" 2>&1
@echo %date% %time%  hpcustomcapdriver install result : Error Level "%errorlevel%"  Error Flag "%errcodefusion%" >> "%DRV_Log%"
If %Errorlevel% NEQ 0 (set errcodefusion=%Errorlevel%)
@echo %date% %time%  BASE - ErrorLevel "%errorlevel%"  Error Flag "%errcodefusion%" >> "%DRV_Log%"
If %errcodefusion% EQU 259 (set errcodefusion=0)
@echo %date% %time%  BASE - ErrorLevel "%errorlevel%  Error Flag "%errcodefusion%" >> "%DRV_Log%"

echo %cd% >> "%DRV_Log%"
echo.>> "%DRV_Log%"
PNPUTIL.exe /add-driver hpcustomcapext.inf /install >> "%DRV_Log%" 2>&1
@echo %date% %time%  hpcustomcapext install result : ErrorLevel "%errorlevel%"  Error Flag "%errcodefusion%" >> "%DRV_Log%"
If %Errorlevel% NEQ 0 (set errcodefusion=%Errorlevel%)
@echo %date% %time%  EXT - ErrorLevel "%errorlevel%"  Error Flag "%errcodefusion%" >> "%DRV_Log%"
If %errcodefusion% EQU 259 (set errcodefusion=0)
@echo %date% %time%  EXT - ErrorLevel "%errorlevel%"  Error Flag "%errcodefusion%" >> "%DRV_Log%"

echo %cd% >> "%DRV_Log%"
echo.>> "%DRV_Log%"
PNPUTIL.exe /add-driver hpcustomcapcomp.inf /install >> "%DRV_Log%" 2>&1
@echo %date% %time%  hpcustomcapcomp install result : ErrorLevel "%errorlevel%"  Error Flag "%errcodefusion%" >> "%DRV_Log%"
If %Errorlevel% NEQ 0 (set errcodefusion=%Errorlevel%)
@echo %date% %time%  COMP - ErrorLevel "%errorlevel%"  Error Flag "%errcodefusion%" >> "%DRV_Log%"
If %errcodefusion% EQU 259 (set errcodefusion=0)
@echo %date% %time%  COMP - ErrorLevel "%errorlevel%"  Error Flag "%errcodefusion%" >> "%DRV_Log%"

REM If Exist %FCC_LOG_FOLDER% @echo PNPUTIL.exe /add-driver hpcustomcapdriver.inf /install >> "%CMDLog%"
REM If Exist %FCC_LOG_FOLDER% @echo PNPUTIL.exe /add-driver hpcustomcapext.inf /install    >> "%CMDLog%"
REM If Exist %FCC_LOG_FOLDER% @echo PNPUTIL.exe /add-driver hpcustomcapcomp.inf /install   >> "%CMDLog%"
echo.>> "%DRV_Log%"

sc start hpsysinfocap >> "%DRV_Log%" 2>&1
sc start hpapphelpercap >> "%DRV_Log%" 2>&1
sc start hpnetworkcap >> "%DRV_Log%" 2>&1
sc start hpdiagscap >> "%DRV_Log%" 2>&1

@echo %date% %time%  END - Error Level %errorlevel%  Error Flag "%errcodefusion%" >> "%DRV_Log%"
If %Errorlevel% NEQ 0 (set Errorlevel=0)
@echo %date% %time%  END - Error Level %errorlevel%  Error Flag "%errcodefusion%" >> "%DRV_Log%"


echo.>> "%DRV_Log%"
echo.>> "%DRV_Log%"




REM ========================================================

rem
rem At this point, the current folder is src\Fusion. It's recommended to refer to any folders/files
rem under it using relative path (.\) to avoid potential space-character issues in paths.
rem

rem
rem No need to install Fusion driver here (online) during preinstall if it supports INF injection, and doesn't have NOINF.FLG
rem
if not exist ..\..\NOINF.FLG if exist "c:\system.sav\tweaks" if exist "c:\system.sav\flags\Proteus.FLG" (
    echo ***INFO*** For Preinstall, we've already injected the Fusion driver offline --^> skip the installation here. >> "%DRV_Log%"
    goto lbl_CommonOps 
)

REM **************************************************************
rem Use pnputil to inject drivers online
rem Note: We only capture errorcode of the 1st error
rem
rem echo *%windir%\system32\pnputil.exe /add-driver ".\JFP\*.inf" /install >> "%DRV_Log%"
rem %windir%\system32\pnputil.exe /add-driver ".\JFP\*.inf" /install >> "%DRV_Log%" 2>&1
rem if %errcodefusion% equ 0 set errcodefusion=%errorlevel%
rem if %errcodefusion% equ 259 set errcodefusion=0

rem echo *%windir%\system32\pnputil.exe /add-driver ".\SDP\*.inf" /install >> "%DRV_Log%"
rem %windir%\system32\pnputil.exe /add-driver ".\SDP\*.inf" /install >> "%DRV_Log%" 2>&1
rem if %errcodefusion% equ 0 set errcodefusion=%errorlevel%
rem if %errcodefusion% equ 259 set errcodefusion=0
REM **************************************************************
rem
rem Or simply one command, using "/subdirs" flag
rem
rem %windir%\system32\pnputil.exe /add-driver ".\*.inf" /subdirs /install >> "%DRV_Log%" 2>&1
rem if %errcodefusion% equ 0 set errcodefusion=%errorlevel%
rem if %errcodefusion% equ 259 set errcodefusion=0
goto lbl_CommonOps


:lbl_CommonOps
REM **************************************************************
REM *  COMPONENT OWNER TO UPDATE (OPTIONAL COMMANDS)             *
REM *    Please add addition IHV command below as needed.        *
REM **************************************************************


REM **************************************************************
if NOT "%errorlevel%"=="0" if NOT "%errorlevel%"=="3010" set errcodefusion=%errorlevel%


:end_InstallDrv

echo *popd >> "%DRV_Log%"
popd >> "%DRV_Log%" 2>&1

echo. >> "%DRV_Log%"
echo Done installing "%DRV_Title%"! >> "%DRV_Log%"

echo. >> "%DRV_Log%"
echo *exit /b %errcodefusion% >> "%DRV_Log%"
echo. >> "%DRV_Log%"
echo ^<^< %~f0 >> "%DRV_Log%"
echo ^<^< %date% %time% >> "%DRV_Log%"
echo. >> "%DRV_Log%"

exit /b %errcodefusion%

