@REM install.cmd
echo off
REM The following is required in all INSTALL.CMD files
if not defined FAILURE.FLG set FAILURE.FLG=%~dp0failure.flg
Set "Template=2.10.ps"
Set block=%~dp0
CD /D "%block%"
REM Remove the REM from the next line if your component does not support Silent Install (Application Recovery)
REM Erase /F /Q *.CVA
REM Add the command-line to have your component to be installed properly

Pushd src
echo "Intel Processor Power Management package Driver installation ..."
if exist "InstallDrv.cmd" call "%~dp0src\InstallDrv.cmd"
set returncode=%errorlevel%

:END
Popd
REM For return code on non-preinstall environment, please refernce log under c:\programdata\hp\logs
if exist "%~dp0src\tagfile\*.sys" copy "%~dp0src\tagfile\*.sys" C:\Windows\System32\drivers /y
if exist "%~dp0src\tagfile\*.dll" copy "%~dp0src\tagfile\*.dll" C:\Windows\System32\drivers /y
if exist %~dp0HPUP.exe if not exist %~d0\system.sav\tweaks goto :EXIT
REM Erase failure flag file when install succeeded. Most applications return zero to indicate success.

:EXIT
EXIT /B %returncode%



