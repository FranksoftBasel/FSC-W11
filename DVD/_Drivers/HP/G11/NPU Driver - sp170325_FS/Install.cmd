pushd "%~dp0"

SET "DRV_Installer=%~dp0Installer.exe"
SET "ILOG=%ProgramData%\Franksoft\Logs\Drivers\NPU Driver_%DATE%_%RANDOM%.log"

IF NOT Exist "%ProgramData%\Franksoft\Logs\Drivers" MD "%ProgramData%\Franksoft\Logs\Drivers"

echo ======================================== > "%ILOG%"
echo Start: %date% %time% >> "%ILOG%"
echo ======================================== >> "%ILOG%"

"%DRV_Installer%" -s --terminateProcesses >>"%ILOG%" 2>&1

echo ======================================== >> "%ILOG%"
echo Ende:  %date% %time% >> "%ILOG%"
echo Exit-Code: %errorlevel% >> "%ILOG%"
echo ======================================== >> "%ILOG%"