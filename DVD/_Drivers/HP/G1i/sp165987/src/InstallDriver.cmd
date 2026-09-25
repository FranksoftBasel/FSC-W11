@echo off
REM templateversion=1.09.BPSASC
set versiondrv=1.09.BPSASC
set errcode=0

REM **************************************************************
REM DRV_Title - Avoid using space if possible
set DRV_Title=HPServicesScan.For.Commercial
REM **************************************************************

rem
rem Loggings of the driver installation are captured for debugging purpose
rem
set Log_Folder=%ProgramData%\HP\logs
if not exist "%Log_Folder%" md "%Log_Folder%"
set DRV_Log=%Log_Folder%\%DRV_Title%.log

echo. >> "%DRV_Log%"
echo ^>^> %~f0 >> "%DRV_Log%"
echo ^>^> %date% %time% >> "%DRV_Log%"
echo. >> "%DRV_Log%"

echo Installing "%DRV_Title%"... >> "%DRV_Log%"
echo. >> "%DRV_Log%"

echo *pushd "%~dp0driver" >> "%DRV_Log%"
pushd "%~dp0driver" >> "%DRV_Log%" 2>&1

:Install_INF

echo %windir%\system32\PNPUTIL.exe /add-driver hpsvcsscancomp.inf /install >> "%DRV_Log%" 2>&1
%windir%\system32\PNPUTIL.exe /add-driver hpsvcsscancomp.inf /install >> "%DRV_Log%" 2>&1
@echo %date% %time%  hpsvcsscancomp install result : Error Level "%errorlevel%"  Error Code %errcode%" >> "%DRV_Log%"
if %Errorlevel% NEQ 0 (set errcode=%Errorlevel%)
@echo %date% %time%  BASE - ErrorLevel "%errorlevel%"  Error Flag "%errcode%" >> "%DRV_Log%"
If %errcode% EQU 259 (set errcode=0)
@echo %date% %time%  BASE - ErrorLevel "%errorlevel%  Error Flag "%errcode%" >> "%DRV_Log%"

echo %windir%\system32\PNPUTIL.exe /add-driver hpsvcsscanext.inf /install >> "%DRV_Log%" 2>&1
%windir%\system32\PNPUTIL.exe /add-driver hpsvcsscanext.inf /install >> "%DRV_Log%" 2>&1
@echo %date% %time%  hpsvcsscanext install result : ErrorLevel "%errorlevel%"  Error Flag "%errcode%" >> "%DRV_Log%"
If %Errorlevel% NEQ 0 (set errcode=%Errorlevel%)
@echo %date% %time%  EXT - ErrorLevel "%errorlevel%"  Error Flag "%errcode%" >> "%DRV_Log%"
If %errcode% EQU 259 (set errcode=0)
@echo %date% %time%  EXT - ErrorLevel "%errorlevel%"  Error Flag "%errcode%" >> "%DRV_Log%"

rem
rem At this point, the current folder is src\driver. It's recommended to refer to any folders/files
rem under it using relative path (.\) to avoid potential space-character issues in paths.
rem

rem
rem No need to install driver here (online) during preinstall if it supports INF injection, and doesn't have NOINF.FLG
rem
set NOINFFLG=..\..\NOINF.FLG
if defined FCCPath set NOINFFLG=%FCCPath%NOINF.FLG

if not exist %NOINFFLG% if exist "c:\system.sav\tweaks" if exist "c:\system.sav\flags\Proteus.FLG" (
    echo ***INFO*** For Preinstall, we've already injected the driver offline --^> skip the installation here. >> "%DRV_Log%"
    goto lbl_CommonOps 
)

REM **************************************************************
rem Use pnputil to inject drivers online
rem Note: We only capture errorcode of the 1st error
rem
rem echo *%windir%\system32\pnputil.exe /add-driver ".\JFP\*.inf" /install >> "%DRV_Log%"
rem %windir%\system32\pnputil.exe /add-driver ".\JFP\*.inf" /install >> "%DRV_Log%" 2>&1
rem if %errcode% equ 0 set errcode=%errorlevel%
rem if %errcode% equ 259 set errcode=0
rem if %errcode% equ 3010 set errcode=0

REM Will move driver install back to here after offline driver injection has been tested and validated


rem echo *%windir%\system32\pnputil.exe /add-driver ".\SDP\*.inf" /install >> "%DRV_Log%"
rem %windir%\system32\pnputil.exe /add-driver ".\SDP\*.inf" /install >> "%DRV_Log%" 2>&1
rem if %errcode% equ 0 set errcode=%errorlevel%
rem if %errcode% equ 259 set errcode=0
rem if %errcode% equ 3010 set errcode=0
REM **************************************************************
rem
rem Or simply one command, using "/subdirs" flag
rem
rem %windir%\system32\pnputil.exe /add-driver ".\*.inf" /subdirs /install >> "%DRV_Log%" 2>&1
rem if %errcode% equ 0 set errcode=%errorlevel%
rem if %errcode% equ 259 set errcode=0
rem if %errcode% equ 3010 set errcode=0
goto lbl_CommonOps


:lbl_CommonOps
REM **************************************************************
REM *  COMPONENT OWNER TO UPDATE (OPTIONAL COMMANDS)             *
REM *    Please add addition IHV command below as needed.        *
REM **************************************************************


REM **************************************************************
if NOT "%errorlevel%"=="0" if NOT "%errorlevel%"=="3010" if NOT "%errorlevel%"=="259" set errcode=%errorlevel%


:end_InstallDrv

echo *popd >> "%DRV_Log%"
popd >> "%DRV_Log%" 2>&1

echo. >> "%DRV_Log%"
echo Done installing "%DRV_Title%"! >> "%DRV_Log%"

echo. >> "%DRV_Log%"
echo *exit /b %errcode% >> "%DRV_Log%"
echo. >> "%DRV_Log%"
echo ^<^< %~f0 >> "%DRV_Log%"
echo ^<^< %date% %time% >> "%DRV_Log%"
echo. >> "%DRV_Log%"

exit /b %errcode%

