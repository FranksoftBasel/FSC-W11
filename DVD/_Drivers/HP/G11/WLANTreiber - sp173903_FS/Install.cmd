SET NAME=WiFi-24.70.0-Driver
SET "DRV_Installer=%~dp0%NAME%"
SET "ILOG=%ProgramData%\Franksoft\Logs\Drivers\%NAME%_%DATE%_%RANDOM%.log"

pushd "%~dp0"

IF Not Exist "%ProgramData%\Franksoft\Logs\Drivers" MD "%ProgramData%\Franksoft\Logs\Drivers"

echo ======================================== > "%ILOG%"
echo Start: %date% %time% >> "%ILOG%"
echo ======================================== >> "%ILOG%"

"%DRV_Installer%.exe" -s >> "%ILOG%"

echo ======================================== >> "%ILOG%"
echo Ende:  %date% %time% >> "%ILOG%"
echo Exit-Code: %errorlevel% >> "%ILOG%"
echo ======================================== >> "%ILOG%"

POPD