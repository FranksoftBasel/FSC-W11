echo off


REM The following is required in all INSTALL.CMD files
if not defined FAILURE.FLG set FAILURE.FLG=%~dp0failure.flg
REM templateversion=1.07.BPSASC
set version=1.07.BPSASC
Set block=%~dp0
CD /D "%block%"
REM Remove the REM from the next line if your component does not support Silent Install (Application Recovery)
REM Erase /F /Q *.CVA
REM Add the command-line to have your component to be installed properly




Pushd src
if exist "%~dp0src\Uninstall.cmd" call "%~dp0src\Uninstall.cmd"
if %errorlevel% NEQ 0 goto :END
if exist "%~dp0src\InstallDriver.cmd" call "%~dp0src\InstallDriver.cmd"
if %errorlevel% NEQ 0 goto :END
if exist "%~dp0src\InstallApp.cmd" call "%~dp0src\InstallApp.cmd"





:END
Popd
REM For return code on non-preinstall environment, please refernce log under c:\programdata\hp\logs
if exist %~dp0HPUP.exe if not exist %~d0\system.sav\tweaks goto :EXIT
REM Erase failure flag file when install succeeded. Most applications return zero to indicate success.

:EXIT
EXIT /B %ERRORLEVEL%
