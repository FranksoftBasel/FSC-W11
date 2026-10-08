@echo off

IF Not Exist "%ProgramData%\Franksoft\Logs\Drivers" MD "%ProgramData%\Franksoft\Logs\Drivers"

SET NAME=gfx_win_101.9033
SET "ILOG=%ProgramData%\Franksoft\Logs\Drivers\%NAME%_%DATE%_%RANDOM%.log"

Title Install %Name%.exe
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