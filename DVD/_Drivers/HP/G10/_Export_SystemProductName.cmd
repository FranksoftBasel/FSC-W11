
@echo off
setlocal EnableDelayedExpansion

set "RK=HKLM\HARDWARE\DESCRIPTION\System\BIOS"

for /f "tokens=3*" %%a in ('reg query "%RK%" /v "SystemProductName" ^| findstr /ri "REG_SZ"') do set "SystemProductName=%%a %%b"

:: Ersetze evtl. ungültige Zeichen im Dateinamen
set "SystemProductName=!SystemProductName:\=_!"
set "SystemProductName=!SystemProductName:/=_!"
set "SystemProductName=!SystemProductName: =_!"

set "EXPORT_PATH=%~dp0HardwareConfig_!SystemProductName!.txt"
reg export "HKLM\SYSTEM\HardwareConfig\Current" "!EXPORT_PATH!" /y

echo Export abgeschlossen:
echo !EXPORT_PATH!





Exit
:: -----------------------------------------------------------------------

setlocal

:: Zielpfad für den Export
set "EXPORT_PATH=%~dp0_SystemProductName.txt"

:: Exportiere den Registry-Schlüssel
reg export "HKLM\SYSTEM\HardwareConfig\Current" "%EXPORT_PATH%" /y

echo Registry-Schlüssel exportiert nach:
echo %EXPORT_PATH%

pause
