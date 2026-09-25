@echo off
set versiondrv=1.05
set errcode=0

REM **************************************************************
REM DRV_Title - Avoid using space if possible
set DRV_Title=HPWBDUWP
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

rem echo *pushd "%~dp0driver" >> "%DRV_Log%"
rem pushd "%~dp0driver" >> "%DRV_Log%" 2>&1

rem
rem At this point, the current folder is src\driver. It's recommended to refer to any folders/files
rem under it using relative path (.\) to avoid potential space-character issues in paths.
rem

rem
rem No need to install driver here (online) during preinstall if it supports INF injection, and doesn't have NOINF.FLG
rem
if not exist ..\..\NOINF.FLG if exist "c:\system.sav\tweaks" if exist "c:\system.sav\flags\Proteus.FLG" (
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

rem echo *%windir%\system32\pnputil.exe /add-driver ".\SDP\*.inf" /install >> "%DRV_Log%"
rem %windir%\system32\pnputil.exe /add-driver ".\SDP\*.inf" /install >> "%DRV_Log%" 2>&1
rem if %errcode% equ 0 set errcode=%errorlevel%
rem if %errcode% equ 259 set errcode=0
REM **************************************************************
rem
rem Or simply one command, using "/subdirs" flag
rem
rem %windir%\system32\pnputil.exe /add-driver ".\*.inf" /subdirs /install >> "%DRV_Log%" 2>&1
rem if %errcode% equ 0 set errcode=%errorlevel%
rem if %errcode% equ 259 set errcode=0

pnputil.exe /a "%~dp0Base\WirelessButtonDriver.inf" /i >> %DRV_Log%

REG QUERY HKLM\SYSTEM\CurrentControlSet\Enum\PCI /f "ven_8086&dev_24f3"
IF %ERRORLEVEL% EQU 0 (set bIntel8260found=1) else (set bIntel8260found=0)
IF %bIntel8260found% EQU 1 (
REM Below Extension and Component drivers are needed only for Platforms which has Intel 8260
echo [%time%] Installing HP Wireless Button Extension Drivers >> %DRV_Log%
pnputil.exe /a "%~dp0Extension\WirelessButtonDriver_extension.inf" /i >> %DRV_Log%
pnputil.exe /a "%~dp0Extension\HPRadioMgr.inf" /i >> %DRV_Log%
)


goto lbl_CommonOps


:lbl_CommonOps
REM **************************************************************
REM *  COMPONENT OWNER TO UPDATE (OPTIONAL COMMANDS)             *
REM *    Please add addition IHV command below as needed.        *
REM **************************************************************


REM **************************************************************
if NOT "%errorlevel%"=="0" if NOT "%errorlevel%"=="3010" set errcode=%errorlevel%


:end_InstallDrv

rem echo *popd >> "%DRV_Log%"
rem popd >> "%DRV_Log%" 2>&1

echo. >> "%DRV_Log%"
echo Done installing "%DRV_Title%"! >> "%DRV_Log%"

echo. >> "%DRV_Log%"
echo *exit /b %errcode% >> "%DRV_Log%"
echo. >> "%DRV_Log%"
echo ^<^< %~f0 >> "%DRV_Log%"
echo ^<^< %date% %time% >> "%DRV_Log%"
echo. >> "%DRV_Log%"

exit /b %errcode%

