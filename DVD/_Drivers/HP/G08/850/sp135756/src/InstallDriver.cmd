@echo off
set versiondrv=1.00
set errcode=0

REM DRV_Title - Avoid using space if possible
set DRV_Title=IntelSerialIO

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
echo *pnputil.exe /add-driver ".\x64\*.inf" /install >> "%DRV_Log%"
pnputil.exe /add-driver ".\x64\*.inf" /install >> "%DRV_Log%" 2>&1
if %errcode% equ 0 set errcode=%errorlevel%
if %errcode% equ 259 set errcode=0


rem
rem Or simply one command, using "/subdirs" flag
rem
rem pnputil.exe /add-driver ".\*.inf" /subdirs /install >> "%DRV_Log%" 2>&1
rem if %errcode% equ 0 set errcode=%errorlevel%
rem if %errcode% equ 259 set errcode=0
goto lbl_CommonOps


:lbl_CommonOps

rem
rem Insert operations common to both online and offline here, if any.
rem
rem echo *xcopy /fhrkyiv ".\iaLPSS2_I2C_TGL.sys" "C:\Windows\System32\Drivers\" >> "%DRV_Log%"
rem xcopy /fhrkyiv ".\iaLPSS2_I2C_TGL.sys" "C:\Windows\System32\Drivers\" >> "%DRV_Log%" 2>&1


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

