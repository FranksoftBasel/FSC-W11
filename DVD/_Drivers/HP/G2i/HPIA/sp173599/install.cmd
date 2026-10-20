echo off
REM The following is required in all INSTALL.CMD files
if not defined FAILURE.FLG set FAILURE.FLG=%~dp0failure.flg
Set "Template=2.08.ps"
Set block=%~dp0
CD /D "%block%"
REM Remove the REM from the next line if your component does not support Silent Install (Application Recovery)
REM Erase /F /Q *.CVA
REM Add the command-line to have your component to be installed properly

Pushd src
if exist "Uninstall.cmd" call "%~dp0src\Uninstall.cmd"
if %errorlevel% NEQ 0 goto :END
if exist "InstallDrv.cmd" call "%~dp0src\InstallDrv.cmd"
if %errorlevel% NEQ 0 goto :END

:END
Popd
REM For return code on non-preinstall environment, please refernce log under c:\programdata\hp\logs
if exist %~dp0HPUP.exe if not exist %~d0\system.sav\tweaks goto :EXIT
REM Erase failure flag file when install succeeded. Most applications return zero to indicate success.

:EXIT
EXIT /B %ERRORLEVEL%

