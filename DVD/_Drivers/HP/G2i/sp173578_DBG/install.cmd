REM The following is required in all INSTALL.CMD files
echo off

if not exist C:\system.sav\logs mkdir C:\system.sav\logs
if exist c:\system.sav\util\SetVariables.cmd Call c:\system.sav\util\SetVariables.cmd
Set block=%~dp0
CD /D "%block%"

REM Remove the REM from the next line if your component does not support Silent Install (Application Recovery)
REM Erase /F /Q *.CVA

REM Add the command-line to have your component to be installed properly

Pushd src
CALL install.cmd
Popd

REM Erase failure flag file when install succeeded. Most applications return zero to indicate success.


EXIT /B %ERRORLEVEL%
