SET DPinst-LOG=C:\Windows\DPINST.LOG

openfiles >nul 2>&1
if %errorlevel% NEQ 0 (
    echo Dieses Skript erfordert Administratorrechte.
    echo Starte Skript mit Administratorrechten...
    powershell -Command "Start-Process cmd -ArgumentList '/c, %~s0' -Verb runAs"
    exit
)

%~dp0BiosConfigUtility64.exe /set:"%~dp0Bios-Settings-G10_DEF.txt" /cpwdfile:"%~dp0AFI-PW.bin"

pause