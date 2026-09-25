@echo off


@echo. 
@echo.

bcdedit /set testsigning on

@echo Reboot NOW
@echo. 
@echo.

Pause

SET DPinst-LOG=C:\Windows\DPINST.LOG

openfiles >nul 2>&1
if %errorlevel% NEQ 0 (
    echo Dieses Skript erfordert Administratorrechte.
    echo Starte Skript mit Administratorrechten...
    powershell -Command "Start-Process cmd -ArgumentList '/c, %~s0' -Verb runAs"
    exit
)

Pushd "%~dp0"

:: %~dp0DPInst64.exe /C:"%~dp0_Drivers_Install_%Date%_%Random%.log"


"%~dp0DPInst64.exe"

If Exist "%DPinst-LOG%" copy "%DPinst-LOG%" "%~dp0DPINST_%DATE%_%Random%.LOG"