SET NAME=FS-Wrapper

IF NOT Exist "%ProgramData%\Franksoft\Logs\Drivers" MD "%ProgramData%\Franksoft\Logs\Drivers"
pushd "%~dp0"

SET "DRV_Installer=%~dp0%NAME%"
SET "ILOG=%ProgramData%\Franksoft\Logs\Drivers\%DRV_Installer%_%DATE%_%RANDOM%.log"

echo ======================================== > "%ILOG%"
echo Start: %date% %time% >> "%ILOG%"
echo ======================================== >> "%ILOG%"

"%DRV_Installer%.exe" >> "%ILOG%"

echo ======================================== >> "%ILOG%"
echo Ende:  %date% %time% >> "%ILOG%"
echo Exit-Code: %errorlevel% >> "%ILOG%"
echo ======================================== >> "%ILOG%"