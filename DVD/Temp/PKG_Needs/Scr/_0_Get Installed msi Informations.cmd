@echo off
@color f9
@title Windows Installer System Inventory Tool
::MODE CON: COLS=160 LINES=50


:: GET ProductCode
Set /p PID=<PID.txt

:: Check Installed SW via ProductCode
:: msiinv.exe -p "%PID%"
msiinv.exe -p "Adobe Acrobat Reader DC"
:: msiinv.exe -p "Adobe Acrobat Reader DC" | find "Product code:"

@Pause
@exit

rem msiinv.exe -p "LightroomCC"
rem msiinv.exe -p "{3234-23424-234234-23423}"