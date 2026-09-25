@echo off
set versiondrv=1.05
set errcode=0

REM **************************************************************
REM DRV_Title - Avoid using space if possible
set DRV_Title=IntelMEDRV
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
if not exist ..\..\NOINF.FLG if exist "c:\system.sav\tweaks" if exist "c:\system.sav\flags\Proteus.FLG" (
    echo ***INFO*** For Preinstall, we've already injected the driver offline --^> skip the installation here. >> "%DRV_Log%"
    goto lbl_CommonOps 
)

rem
rem Use pnputil to inject drivers online
rem Note: We only capture errorcode of the 1st error
rem
:: echo pnputil.exe -i -a .\IntelACM_ADL_PW_1.18.11.0.INF >> "%DRV_Log%"
pnputil.exe -i -a .\IntelACM_ADL_PW_1.18.11.0.INF >> "%DRV_Log%" 2>&1
if %errcode% equ 0 set errcode=%errorlevel%
if %errcode% equ 259 set errcode=0


goto lbl_CommonOps


:lbl_CommonOps
REM **************************************************************
REM *  COMPONENT OWNER TO UPDATE (OPTIONAL COMMANDS)             *
REM *    Please add addition IHV command below as needed.        *
REM **************************************************************


REM **************************************************************
if NOT "%errorlevel%"=="0" if NOT "%errorlevel%"=="3010" set errcode=%errorlevel%
rem
:: echo *xcopy "TXTACMDetailFile.exe" "C:\Program Files\Intel\TXT\" /y >> "%DRV_Log%"
xcopy "TXTACMDetailFile.exe" "C:\Program Files\Intel\TXT\" /y >> "%DRV_Log%" 2>&1

rem if %errcode% equ 0 set errcode=%errorlevel%


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

