@echo off
:: Prüfen, ob das Skript mit Administratorrechten ausgeführt wird
openfiles >nul 2>&1
if %errorlevel% NEQ 0 (
    echo Dieses Skript erfordert Administratorrechte.
    echo Starte Skript mit Administratorrechten...
    powershell -Command "Start-Process cmd -ArgumentList '/c, %~s0' -Verb runAs"
    exit
)

for /f "tokens=3*" %%a in ('reg query "HKLM\HARDWARE\DESCRIPTION\System\BIOS" /v "SystemProductName" ^| findstr /i "SystemProductName"') do (
    set "ProductName=%%a %%b"
)

SET FS-LOG=%ProgramData%\Franksoft\Logs\Franksoft Client.txt
SET FS-LOG-DRIVERS=%Public%\Desktop\FS-Driver-Inst.txt
SET PCMODELL=%ProductName%

@echo on

@echo. 
@echo. Start of %0
@echo. 

Pushd "%~dp0"
for /r %%d in (.) do if exist "%%d\HPUP.exe" call "%%d\HPUP.exe"

@echo. 
@echo. --------------------------------
@echo. errorlevel........ %errorlevel%
@echo. ProductName....... %ProductName%
:: @echo. DRVPATH........... %DRVPATH%
:: @echo. DRV-INST-Scr...... %DRV-INST-Scr%
@echo. FS-LOG-DRIVERS.... %FS-LOG-DRIVERS%
@echo. Running Sript %%0.. %0
@echo. --------------------------------

