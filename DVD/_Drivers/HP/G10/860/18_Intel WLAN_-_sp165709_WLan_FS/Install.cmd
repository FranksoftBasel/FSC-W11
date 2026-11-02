SET NAME=WiFi-24.70.0-Driver64


pushd "%~dp0"

SET "DRV_Installer=%~dp0%NAME%"
SET "ILOG=%ProgramData%\Franksoft\Logs\Drivers\%NAME%_%DATE%_%RANDOM%.log"

echo ======================================== > "%ILOG%"
echo Start: %date% %time% >> "%ILOG%"
echo ======================================== >> "%ILOG%"

"%DRV_Installer%.exe" -s >> "%ILOG%"

echo ======================================== >> "%ILOG%"
echo Ende:  %date% %time% >> "%ILOG%"
echo Exit-Code: %errorlevel% >> "%ILOG%"
echo ======================================== >> "%ILOG%"