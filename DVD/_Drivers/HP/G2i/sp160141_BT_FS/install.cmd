:: Pushd "%~dp0"
:: "%~dp0FS-Wrapper.exe"


SET "DRV_Installer=%~dp0FS-Wrapper"
SET "ILOG=%ProgramData%\Franksoft\Logs\Drivers\Bluetooth_Intel_v%VER%_%DATE%_%RANDOM%.log"


pushd "%~dp0"

SET VER=24.70.0.4

MD %ProgramData%\Franksoft\Logs\Drivers\

echo ======================================== > "%ILOG%"
echo Start: %date% %time% >> "%ILOG%"
echo ======================================== >> "%ILOG%"

"%DRV_Installer%.exe" >> "%ILOG%"

echo ======================================== >> "%ILOG%"
echo Ende:  %date% %time% >> "%ILOG%"
echo Exit-Code: %errorlevel% >> "%ILOG%"
echo ======================================== >> "%ILOG%"


