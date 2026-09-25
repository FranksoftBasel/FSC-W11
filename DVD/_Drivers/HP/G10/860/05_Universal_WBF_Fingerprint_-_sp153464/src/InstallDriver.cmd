@echo off
REM templateversion=1.07.BPSASC
set versiondrv=1.07.BPSASC
set errcode=0

REM **************************************************************
REM DRV_Title - Avoid using space if possible
set DRV_Title=HP Universal WBF Fingerprint Driver
REM **************************************************************

rem
rem Loggings of the driver installation are captured for debugging purpose
rem
set Log_Folder=%programdata%\HP\logs
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

rem echo *%windir%\system32\pnputil.exe /add-driver ".\SDP\*.inf" /install >> "%DRV_Log%"
rem %windir%\system32\pnputil.exe /add-driver ".\SDP\*.inf" /install >> "%DRV_Log%" 2>&1
rem if %errcode% equ 0 set errcode=%errorlevel%
rem if %errcode% equ 259 set errcode=0
rem if %errcode% equ 3010 set errcode=0
REM **************************************************************
rem
rem Or simply one command, using "/subdirs" flag
rem

ERASE /F /Q CHKRESULT.txt

.\devcon hwids "USB\VID_04F3&PID*" >CHKRESULT.txt

for /f "tokens=1" %%a in ('Findstr "USB\VID_04F3&PID_" .\CHKRESULT.txt') do (set ID=%%a)

::::ELAN:::
If "%ID%" == "USB\VID_04F3&PID_0C5E" GOTO ELAN
If "%ID%" == "USB\VID_04F3&PID_0C7E" GOTO ELAN
If "%ID%" == "USB\VID_04F3&PID_0C82" GOTO ELAN
If "%ID%" == "USB\VID_04F3&PID_0C9F" GOTO ELAN
If "%ID%" == "USB\VID_04F3&PID_0CA3" GOTO ELAN

ERASE /F /Q CHKRESULT.txt

.\devcon hwids "USB\VID_06CB&PID*" >CHKRESULT.txt

for /f "tokens=1" %%a in ('Findstr "USB\VID_06CB&PID_" .\CHKRESULT.txt') do (set ID=%%a)

::::SYNA:::
If "%ID%" == "USB\VID_06CB&PID_00C0" GOTO SYNA
If "%ID%" == "USB\VID_06CB&PID_00C4" GOTO SYNA
If "%ID%" == "USB\VID_06CB&PID_00DF" GOTO SYNA
If "%ID%" == "USB\VID_06CB&PID_00D8" GOTO SYNA
If "%ID%" == "USB\VID_06CB&PID_00E9" GOTO SYNA
If "%ID%" == "USB\VID_06CB&PID_00F0" GOTO SYNA
If "%ID%" == "USB\VID_06CB&PID_0103" GOTO SYNA
If "%ID%" == "USB\VID_06CB&PID_0104" GOTO SYNA
If "%ID%" == "USB\VID_06CB&PID_0106" GOTO SYNA
If "%ID%" == "USB\VID_06CB&PID_0107" GOTO SYNA
If "%ID%" == "USB\VID_06CB&PID_010A" GOTO SYNA

:ELAN
%windir%\system32\pnputil.exe /add-driver ".\x64\ELAN\*.inf" /subdirs /install >> "%DRV_Log%" 2>&1
if %errcode% equ 0 set errcode=%errorlevel%
if %errcode% equ 1 set errcode=0
if %errcode% equ 259 set errcode=0
if %errcode% equ 3010 set errcode=0
goto lbl_CommonOps

:SYNA
%windir%\system32\pnputil.exe /add-driver ".\x64\SYNA\*.inf" /subdirs /install >> "%DRV_Log%" 2>&1
if %errcode% equ 0 set errcode=%errorlevel%
if %errcode% equ 1 set errcode=0
if %errcode% equ 259 set errcode=0
if %errcode% equ 3010 set errcode=0
goto lbl_CommonOps


:lbl_CommonOps
rem
rem Insert operations common to both online and offline here, if any.
rem
rem echo *xcopy /fhrkyiv ".\ibtusb.sys" "C:\Windows\System32\Drivers\" >> "%DRV_Log%"
rem xcopy /fhrkyiv ".\ibtusb.sys" "C:\Windows\System32\Drivers\" >> "%DRV_Log%" 2>&1
if NOT "%errorlevel%"=="0" if NOT "%errorlevel%"=="3010" set errcode=%errorlevel%


REM **************************************************************
if NOT "%errorlevel%"=="0" if NOT "%errorlevel%"=="3010" set errcode=%errorlevel%


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

