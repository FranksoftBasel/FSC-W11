@echo off

@echo off
MODE CON: COLS=70 LINES=12


SET Ti=Mainboard and Bios INFO
Title %TI%
cls

set torun=wmic bios get serialnumber /format:value
for /f "tokens=2 delims==" %%a in ('%torun%') do set Bios_Serial=%%a

set torun=wmic baseboard get serialnumber /format:value
for /f "tokens=2 delims==" %%a in ('%torun%') do set MainBoard_Serial=%%a

:: Set OUTFile=%TEMP%\Bios.txt
:: reg query "HKLM\HARDWARE\DESCRIPTION\System\BIOS" >"%OUTFile%"
:: findstr /i "dMa" "%OUTFile%" & findstr /i "dPr" "%OUTFile%" & findstr /i "eda" "%OUTFile%"

SET RK=HKLM\HARDWARE\DESCRIPTION\System\BIOS
for /f "tokens=3*" %%a in ('reg query "%RK%" /V "BaseBoardManufacturer" ^|findstr /ri "REG_SZ"') do Set BaseBoardManufacturer=%%a %%b

for /f "tokens=3*" %%a in ('reg query "%RK%" /V "BaseBoardProduct" ^|findstr /ri "REG_SZ"') do Set BaseBoardProduct=%%a %%b

for /f "tokens=3*" %%a in ('reg query "%RK%" /V "BIOSVendor" ^|findstr /ri "REG_SZ"') do Set BIOSVendor=%%a %%b

for /f "tokens=3*" %%a in ('reg query "%RK%" /V "BIOSVersion" ^|findstr /ri "REG_SZ"') do Set BIOSVersion=%%a %%b

for /f "tokens=3*" %%a in ('reg query "%RK%" /V "BIOSReleaseDate" ^|findstr /ri "REG_SZ"') do Set BIOSReleaseDate=%%a %%b

for /f "tokens=3*" %%a in ('reg query "%RK%" /V "SystemSKU" ^|findstr /ri "REG_SZ"') do Set SystemSKU=%%a %%b

@Echo. 

@echo. Mainboard Vendor : %BaseBoardManufacturer%
@echo. Mainboard Model. : %BaseBoardProduct%
@echo. Mainboard Serial : %MainBoard_Serial%
@echo. BIOS Vendor..... : %BIOSVendor%
@echo. BIOS Version.... : %BIOSVersion%
@echo. BIOS Rel Date... : %BIOSReleaseDate%
@echo. BIOS Serial .... : %Bios_Serial%
@echo. BIOS SKU ....... : %SystemSKU%


@echo.

pause

wmic bios get /format:list

Pause