@echo off
set versiondrv=1.07.BPSASC
set errcode=0

REM **************************************************************
REM DRV_Title - Avoid using space if possible
set DRV_Title=IntelGFXDRV
REM **************************************************************
rem
rem Loggings of the driver uninstallation are captured for debugging purpose
rem
set Log_Folder=c:\programdata\HP\logs
if not exist "%Log_Folder%" md "%Log_Folder%"
set DRV_Log=%Log_Folder%\%DRV_Title%.log

echo. >> "%DRV_Log%"
echo ^>^> %~f0 >> "%DRV_Log%"
echo ^>^> %date% %time% >> "%DRV_Log%"
echo. >> "%DRV_Log%"

echo Uninstalling "%DRV_Title%"... >> "%DRV_Log%"
echo. >> "%DRV_Log%"

rem
rem At this point, the current folder is src. It's recommended to refer to any folders/files
rem under it using relative path (.\) to avoid potential space-character issues in paths.
rem

rem
rem No need to do any uninstall during preinstall
rem
if exist "c:\system.sav\tweaks" if exist "c:\system.sav\flags\Proteus.FLG" (
    echo ***INFO*** For Preinstall, the image is clean --^> skip the uninstallation here. >> "%DRV_Log%"
    goto end_UninstallDrv
)

REM **************************************************************
rem <TODO> Insert uninstall operations here, if any
rem Assuming that the uninstallation should not cause reboot automatically nor require reboot
rem before the installation of the new driver
REM **************************************************************


:end_UninstallDrv

echo. >> "%DRV_Log%"
echo Done uninstalling "%DRV_Title%"! >> "%DRV_Log%"

echo. >> "%DRV_Log%"
echo *exit /b %errcode% >> "%DRV_Log%"
echo. >> "%DRV_Log%"
echo ^<^< %~f0 >> "%DRV_Log%"
echo ^<^< %date% %time% >> "%DRV_Log%"
echo. >> "%DRV_Log%"

exit /b %errcode%

