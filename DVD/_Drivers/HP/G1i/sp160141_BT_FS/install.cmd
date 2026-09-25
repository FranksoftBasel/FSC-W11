:: Pushd "%~dp0"
:: "%~dp0FS-Wrapper.exe"

pushd "%~dp0"

SET "DRV_Installer=%~dp0FS-Wrapper"
SET "ILOG=%DRV_Installer%_%DATE%_%RANDOM%.log"

echo ======================================== > "%ILOG%"
echo Start: %date% %time% >> "%ILOG%"
echo ======================================== >> "%ILOG%"

"%DRV_Installer%.exe" >> "%ILOG%"

echo ======================================== >> "%ILOG%"
echo Ende:  %date% %time% >> "%ILOG%"
echo Exit-Code: %errorlevel% >> "%ILOG%"
echo ======================================== >> "%ILOG%"


