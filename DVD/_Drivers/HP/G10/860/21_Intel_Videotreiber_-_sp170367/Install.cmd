:: %~dp0Installer.exe -s -f --terminateProcesses

SET "ILOG=%temp%\Intel_Video_gfx_win_101.8826_%DATE%_%RANDOM%.log"

@echo off

echo ======================================== > "%ILOG%"
echo Start: %date% %time% >> "%ILOG%"
echo ======================================== >> "%ILOG%"
pushd "%~dp0"
"%~dp0installer.exe" -s -f --terminateProcesses >> "%ILOG%" 2>&1

echo ======================================== >> "%ILOG%"
echo Ende:  %date% %time% >> "%ILOG%"
echo Exit-Code: %errorlevel% >> "%ILOG%"
echo ======================================== >> "%ILOG%"