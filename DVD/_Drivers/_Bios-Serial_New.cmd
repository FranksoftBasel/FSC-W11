::
:: Franksoft System Info
:: 2026
::

@echo off
setlocal EnableExtensions
MODE CON: COLS=100 LINES=35
Title Franksoft System Info
cls

echo Lade Systeminformationen...
echo.

:: ---------------- Datum / Zeit ----------------

for /f %%a in ('powershell -NoProfile -Command "(Get-Date).ToString('yyyy-MMMM-dd_HH-mm-ss',[cultureinfo]'de-CH')"') do set "DATUM=%%a"

:: ---------------- BIOS / Board ----------------

for /f "usebackq delims=" %%a in (`powershell -NoProfile -ExecutionPolicy Bypass -Command "(Get-CimInstance Win32_BIOS).SerialNumber"`) do set "Bios_Serial=%%a"
for /f "usebackq delims=" %%a in (`powershell -NoProfile -ExecutionPolicy Bypass -Command "(Get-CimInstance Win32_BaseBoard).SerialNumber"`) do set "MainBoard_Serial=%%a"
for /f "usebackq delims=" %%a in (`powershell -NoProfile -ExecutionPolicy Bypass -Command "(Get-CimInstance Win32_ComputerSystemProduct).UUID"`) do set "UUID=%%a"

:: ---------------- CPU / RAM / Windows ----------------

for /f "usebackq delims=" %%a in (`powershell -NoProfile -ExecutionPolicy Bypass -Command "(Get-CimInstance Win32_Processor).Name"`) do set "CPU=%%a"
for /f "usebackq delims=" %%a in (`powershell -NoProfile -ExecutionPolicy Bypass -Command "[math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory/1GB,2)"`) do set "RAM=%%a GB"
for /f "usebackq delims=" %%a in (`powershell -NoProfile -ExecutionPolicy Bypass -Command "(Get-CimInstance Win32_OperatingSystem).Caption"`) do set "WindowsName=%%a"
for /f "usebackq delims=" %%a in (`powershell -NoProfile -ExecutionPolicy Bypass -Command "(Get-CimInstance Win32_OperatingSystem).BuildNumber"`) do set "WindowsBuild=%%a"

:: ---------------- Registry BIOS Infos ----------------

SET "RK=HKLM\HARDWARE\DESCRIPTION\System\BIOS"

for /f "tokens=3*" %%a in ('reg query "%RK%" /V "BaseBoardManufacturer" ^| findstr /ri "REG_SZ"') do set "BaseBoardManufacturer=%%a %%b"
for /f "tokens=3*" %%a in ('reg query "%RK%" /V "BaseBoardProduct" ^| findstr /ri "REG_SZ"') do set "BaseBoardProduct=%%a %%b"
for /f "tokens=3*" %%a in ('reg query "%RK%" /V "BIOSVendor" ^| findstr /ri "REG_SZ"') do set "BIOSVendor=%%a %%b"
for /f "tokens=3*" %%a in ('reg query "%RK%" /V "BIOSVersion" ^| findstr /ri "REG_SZ"') do set "BIOSVersion=%%a %%b"
for /f "tokens=3*" %%a in ('reg query "%RK%" /V "BIOSReleaseDate" ^| findstr /ri "REG_SZ"') do set "BIOSReleaseDate=%%a %%b"
for /f "tokens=3*" %%a in ('reg query "%RK%" /V "SystemSKU" ^| findstr /ri "REG_SZ"') do set "SystemSKU=%%a %%b"
for /f "tokens=3*" %%a in ('reg query "%RK%" /V "SystemProductName" ^| findstr /ri "REG_SZ"') do set "SystemProductName=%%a %%b"

:: ---------------- Log Datei ----------------

SET "LOG=%~dp0%DATUM%-%COMPUTERNAME%_System_Info.txt"

echo Franksoft System Info>"%LOG%"
echo =====================>>"%LOG%"
echo.>>"%LOG%"

echo Datum ...........: "%DATUM%">>"%LOG%"
echo Computername ....: "%COMPUTERNAME%">>"%LOG%"
echo Windows .........: "%WindowsName%">>"%LOG%"
echo Windows Build ...: "%WindowsBuild%">>"%LOG%"
echo.>>"%LOG%"

echo Hersteller ......: "%BaseBoardManufacturer%">>"%LOG%"
echo Modell ..........: "%SystemProductName%">>"%LOG%"
echo System SKU ......: "%SystemSKU%">>"%LOG%"
echo UUID ............: "%UUID%">>"%LOG%"
echo.>>"%LOG%"

echo CPU .............: "%CPU%">>"%LOG%"
echo RAM .............: "%RAM%">>"%LOG%"
echo.>>"%LOG%"

echo Mainboard Vendor : "%BaseBoardManufacturer%">>"%LOG%"
echo Mainboard Model. : "%BaseBoardProduct%">>"%LOG%"
echo Mainboard Serial : "%MainBoard_Serial%">>"%LOG%"
echo.>>"%LOG%"

echo BIOS Vendor..... : "%BIOSVendor%">>"%LOG%"
echo BIOS Version.... : "%BIOSVersion%">>"%LOG%"
echo BIOS Rel Date... : "%BIOSReleaseDate%">>"%LOG%"
echo BIOS Serial .... : "%Bios_Serial%">>"%LOG%"
echo.>>"%LOG%"

echo MAC-Adressen:>>"%LOG%"
powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-CimInstance Win32_NetworkAdapterConfiguration | Where-Object {$_.IPEnabled} | ForEach-Object { '  ' + $_.Description + ' = ' + $_.MACAddress }" >>"%LOG%"

echo.>>"%LOG%"
echo Laufwerke:>>"%LOG%"
powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-CimInstance Win32_DiskDrive | ForEach-Object { '  ' + $_.Model + ' - ' + [math]::Round($_.Size/1GB,0) + ' GB' }" >>"%LOG%"

cls
type "%LOG%"

echo.
echo Info wurde gespeichert unter:
echo %LOG%
echo.
pause
exit