REM The following is required in all INSTALL.CMD files
if exist c:\system.sav\util\SetVariables.cmd Call c:\system.sav\util\SetVariables.cmd
set version=1.05
set versionbuild=v8.10.50.393,A.1
Set block=%~dp0
CD /D "%block%"
REM Remove the REM from the next line if your component does not support Silent Install (Application Recovery)
REM Erase /F /Q *.CVA
REM Add the command-line to have your component to be installed properly

REM **************************************************************
REM DRV_Title - Avoid using space if possible
set DRV_Title=Hotkey_Installer
REM **************************************************************

rem
rem Loggings of the driver installation are captured for debugging purpose
rem
set Log_Folder=%programdata%\HP\logs
if not exist "%Log_Folder%" md "%Log_Folder%"
set DRV_Log=%Log_Folder%\%DRV_Title%.log

Pushd src
if exist "%~dp0src\InstallFusion.cmd" (
	echo "Found InstallFusion.cmd" >> "%DRV_Log%"
	echo "Installing Fusion Build" %versionbuild% >> "%DRV_Log%"
	call "%~dp0src\InstallFusion.cmd"
	echo. >> "%DRV_Log%"
	echo %~f0 >> "%DRV_Log%"
	echo %date% %time% >> "%DRV_Log%"
	echo. >> "%DRV_Log%"
	echo "errorlevel " %errorlevel%
	if %errorlevel% NEQ 0 goto :END
)
if exist "%~dp0src\InstallDriver.cmd" (
	echo "Found InstallDriver.cmd" >> "%DRV_Log%"
	echo "Installing Hotkey Build" %versionbuild% >> "%DRV_Log%"
	call "%~dp0src\InstallDriver.cmd"
	echo. >> "%DRV_Log%"
	echo %~f0 >> "%DRV_Log%"
	echo %date% %time% >> "%DRV_Log%"
	echo. >> "%DRV_Log%"
	echo "errorlevel " %errorlevel%
	if %errorlevel% NEQ 0 goto :END
)
if exist "%~dp0src\InstallApp.cmd" (
	echo "Found InstallApp.cmd" >> "%DRV_Log%"
	echo "Installing Hotkey Build" %versionbuild% >> "%DRV_Log%"
	call "%~dp0src\InstallApp.cmd"
	echo. >> "%DRV_Log%"
	echo %~f0 >> "%DRV_Log%"
	echo %date% %time% >> "%DRV_Log%"
	echo. >> "%DRV_Log%"
	echo "errorlevel " %errorlevel%
	if %errorlevel% NEQ 0 goto :END
) 

:END
echo *popd >> "%DRV_Log%"
popd >> "%DRV_Log%" 2>&1

echo. >> "%DRV_Log%"
echo Done installing "%DRV_Title%"! >> "%DRV_Log%"

echo %~f0 >> "%DRV_Log%"
echo %date% %time% >> "%DRV_Log%"

REM Erase failure flag file when install succeeded. Most applications return zero to indicate success.
ECHO %ERRORLEVEL% >> "%DRV_Log%"

REM Erase failure flag file when install succeeded. Most applications return zero to indicate success.
EXIT /B %ERRORLEVEL%
