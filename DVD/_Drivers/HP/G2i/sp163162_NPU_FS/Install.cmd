pushd "%~dp0"

SET "DrvName=Installer-NPU"
SET "DRV_Installer=%~dp0%DrvName%"
SET "ILOG=%ProgramData%\Franksoft\Logs\Drivers\%DrvName%_%DATE%_%RANDOM%.log"

IF NOT Exist "%ProgramData%\Franksoft\Logs\Drivers" MD "%ProgramData%\Franksoft\Logs\Drivers"


echo ======================================== > "%ILOG%"
echo Start: %date% %time% >> "%ILOG%"
echo ======================================== >> "%ILOG%"

"%DRV_Installer%.exe" -s >> "%ILOG%"

echo ======================================== >> "%ILOG%"
echo Ende:  %date% %time% >> "%ILOG%"
echo Exit-Code: %errorlevel% >> "%ILOG%"
echo ======================================== >> "%ILOG%"