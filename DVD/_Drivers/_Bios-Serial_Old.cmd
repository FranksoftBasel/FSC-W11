::
:: Franksoft 2022
::

@echo off
MODE CON: COLS=80 LINES=12

SET "Ti=Mainboard and Bios INFO"
Title %TI%
cls

for /f "usebackq delims=" %%a in (`powershell -Command "(Get-CimInstance Win32_BIOS).SerialNumber"`) do set "Bios_Serial=%%a"
for /f "usebackq delims=" %%a in (`powershell -Command "(Get-CimInstance Win32_BaseBoard).SerialNumber"`) do set "MainBoard_Serial=%%a"

SET "RK=HKLM\HARDWARE\DESCRIPTION\System\BIOS"

for /f "tokens=3*" %%a in ('reg query "%RK%" /V "BaseBoardManufacturer" ^|findstr /ri "REG_SZ"') do Set "BaseBoardManufacturer=%%a %%b"
for /f "tokens=3*" %%a in ('reg query "%RK%" /V "BaseBoardProduct" ^|findstr /ri "REG_SZ"') do Set "BaseBoardProduct=%%a %%b"
for /f "tokens=3*" %%a in ('reg query "%RK%" /V "BIOSVendor" ^|findstr /ri "REG_SZ"') do Set "BIOSVendor=%%a %%b"
for /f "tokens=3*" %%a in ('reg query "%RK%" /V "BIOSVersion" ^|findstr /ri "REG_SZ"') do Set "BIOSVersion=%%a %%b"
for /f "tokens=3*" %%a in ('reg query "%RK%" /V "BIOSReleaseDate" ^|findstr /ri "REG_SZ"') do Set "BIOSReleaseDate=%%a %%b"
for /f "tokens=3*" %%a in ('reg query "%RK%" /V "SystemSKU" ^|findstr /ri "REG_SZ"') do Set "SystemSKU=%%a %%b"
for /f "tokens=3*" %%a in ('reg query "%RK%" /V "SystemProductName" ^|findstr /ri "REG_SZ"') do Set "SystemProductName=%%a %%b"

Echo.
echo Product Name ....: %SystemProductName%
echo Mainboard Vendor : %BaseBoardManufacturer%
echo Mainboard Model. : %BaseBoardProduct%
echo Mainboard Serial : %MainBoard_Serial%
echo BIOS Vendor..... : %BIOSVendor%
echo BIOS Version.... : %BIOSVersion%
echo BIOS Rel Date... : %BIOSReleaseDate%
echo BIOS Serial .... : %Bios_Serial%
echo BIOS SKU ....... : %SystemSKU%

echo.
pause
exit