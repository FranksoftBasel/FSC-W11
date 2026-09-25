@echo off

SET NAME=gfx_win_101.8991
SET "ILOG=%~dp0%NAME%_%DATE%_%RANDOM%.log"

Tilte Install %Name%.exe
@echo. 
@echo. Install Intel video Driver...
@echo. 

echo ======================================== > "%ILOG%"
echo Start: %date% %time% >> "%ILOG%"
echo ======================================== >> "%ILOG%"

"%~dp0%NAME%.exe" -s -f --terminateProcesses >> "%ILOG%" 2>&1

echo ======================================== >> "%ILOG%"
echo Ende:  %date% %time% >> "%ILOG%"
echo Exit-Code: %errorlevel% >> "%ILOG%"
echo ======================================== >> "%ILOG%"