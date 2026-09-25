@echo off

chcp 1252 1>NUL 2>NUL
:: =========================================================
:: OPTIONAL START MINIMIZED
:: =========================================================
:: if not "%1"=="7" start /min cmd /c ""%~0" 7 %*" & exit /b


SET FSC-Ver=3.3
Title Franksoft Defender Update
:: =====================================================================================
:: FSC-DefenderUpdate-Debug-V3.cmd
:: Version : %FSC-Ver%
:: Date    : 13.06.2026 23:15
:: Author  : Franksoft
:: =====================================================================================

setlocal EnableExtensions EnableDelayedExpansion

set "LOGDIR=%ProgramData%\Franksoft\Logs"
set "LOGFILE=%LOGDIR%\DefenderUpdate_FSC.log"

if not exist "%LOGDIR%" md "%LOGDIR%"

set "SIG_BEFORE="
set "SIGDATE_BEFORE="
set "SIG_AFTER="
set "SIGDATE_AFTER="

set "ERR_STATUS1=-"
set "ERR_UPDATE=-"
set "ERR_MPCMD=nicht ausgefuehrt"
set "ERR_STATUS2=-"

for /f "delims=" %%A in ('powershell -NoProfile -ExecutionPolicy Bypass -Command "try{(Get-MpComputerStatus).AntivirusSignatureVersion}catch{}" 2^>nul') do set "SIG_BEFORE=%%A"
for /f "delims=" %%A in ('powershell -NoProfile -ExecutionPolicy Bypass -Command "try{(Get-MpComputerStatus).AntivirusSignatureLastUpdated}catch{}" 2^>nul') do set "SIGDATE_BEFORE=%%A"

if "!SIG_BEFORE!"=="" (
    for /f "tokens=3" %%A in ('reg query "HKLM\SOFTWARE\Microsoft\Windows Defender\Signature Updates" /v AVSignatureVersion 2^>nul') do set "SIG_BEFORE=%%A"
)

if "!SIGDATE_BEFORE!"=="" (
    for /f "delims=" %%A in ('powershell -NoProfile -Command "(Get-ChildItem 'C:\ProgramData\Microsoft\Windows Defender\Definition Updates' -Filter mpavbase.vdm -Recurse -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1).LastWriteTime.ToString('dd.MM.yyyy HH:mm')" 2^>nul') do set "SIGDATE_BEFORE=%%A"
)

if "!SIG_BEFORE!"=="" set "SIG_BEFORE=nicht auslesbar"
if "!SIGDATE_BEFORE!"=="" set "SIGDATE_BEFORE=nicht auslesbar"


echo.>>"%LOGFILE%"
echo ===============================================================================>>"%LOGFILE%"
echo Franksoft Windows Defender Update>>"%LOGFILE%"
echo ===============================================================================>>"%LOGFILE%"
echo Script Name  : %~nx0>>"%LOGFILE%"
echo Script Path  : %~f0>>"%LOGFILE%"
echo Version      : %FSC-Ver%>>"%LOGFILE%"
echo Computer     : %COMPUTERNAME%>>"%LOGFILE%"
echo User         : %USERNAME%>>"%LOGFILE%"
echo Start Time   : %DATE% %TIME%>>"%LOGFILE%"
echo ===============================================================================>>"%LOGFILE%"
echo.>>"%LOGFILE%"

@echo.   - Franksoft Defender Update Debug V%FSC-Ver%
@echo.   - Check Vorheriger Defender Status...

echo Defender Status vor Update:>>"%LOGFILE%"
powershell.exe -NoProfile -ExecutionPolicy Bypass ^
 "Get-MpComputerStatus | Select AntivirusSignatureVersion,AntivirusSignatureLastUpdated,AMEngineVersion,AMProductVersion | Format-List" >> "%LOGFILE%" 2>&1

set "ERR_STATUS1=!ERRORLEVEL!"
echo Get-MpComputerStatus RC vor Update: !ERR_STATUS1!>>"%LOGFILE%"
echo.>>"%LOGFILE%"

@echo.   - Starte Update-MpSignature...

echo Update-MpSignature:>>"%LOGFILE%"
powershell.exe -NoProfile -ExecutionPolicy Bypass ^
 "Update-MpSignature -Verbose" >> "%LOGFILE%" 2>&1

set "ERR_UPDATE=!ERRORLEVEL!"
@echo.   - Rueckgabecode Update-MpSignature: !ERR_UPDATE!
echo Rueckgabecode Update-MpSignature: !ERR_UPDATE!>>"%LOGFILE%"
echo.>>"%LOGFILE%"

if not "!ERR_UPDATE!"=="0" (
    echo Update-MpSignature fehlgeschlagen - Fallback MpCmdRun.exe...
    echo Update-MpSignature fehlgeschlagen - Fallback MpCmdRun.exe...>>"%LOGFILE%"

    for /f "delims=" %%A in ('powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$p=Get-ChildItem 'C:\ProgramData\Microsoft\Windows Defender\Platform' -Directory -ErrorAction SilentlyContinue | Sort-Object Name -Descending | Select-Object -First 1; if($p){Join-Path $p.FullName 'MpCmdRun.exe'}"') do set "MPCMD=%%A"

    if exist "!MPCMD!" (
        echo MpCmdRun: !MPCMD!>>"%LOGFILE%"
        "!MPCMD!" -SignatureUpdate >>"%LOGFILE%" 2>&1
        set "ERR_MPCMD=!ERRORLEVEL!"
        echo Rueckgabecode MpCmdRun: !ERR_MPCMD!>>"%LOGFILE%"
    ) else (
        echo ERROR: MpCmdRun.exe nicht gefunden.>>"%LOGFILE%"
        set "ERR_MPCMD=99"
    )

    echo.>>"%LOGFILE%"
)

for /f "delims=" %%A in ('powershell -NoProfile -ExecutionPolicy Bypass -Command "try{(Get-MpComputerStatus).AntivirusSignatureVersion}catch{}" 2^>nul') do set "SIG_AFTER=%%A"
for /f "delims=" %%A in ('powershell -NoProfile -ExecutionPolicy Bypass -Command "try{(Get-MpComputerStatus).AntivirusSignatureLastUpdated}catch{}" 2^>nul') do set "SIGDATE_AFTER=%%A"

if "!SIG_AFTER!"=="" (
    for /f "tokens=3" %%A in ('reg query "HKLM\SOFTWARE\Microsoft\Windows Defender\Signature Updates" /v AVSignatureVersion 2^>nul') do set "SIG_AFTER=%%A"
)

if "!SIG_AFTER!"=="" set "SIG_AFTER=nicht auslesbar"
if "!SIGDATE_AFTER!"=="" set "SIGDATE_AFTER=nicht auslesbar"

@echo.   - Neuer Defender Status...
echo Defender Status nach Update:>>"%LOGFILE%"
powershell.exe -NoProfile -ExecutionPolicy Bypass ^
 "Get-MpComputerStatus | Select AntivirusSignatureVersion,AntivirusSignatureLastUpdated,AMEngineVersion,AMProductVersion | Format-List" >> "%LOGFILE%" 2>&1

set "ERR_STATUS2=!ERRORLEVEL!"
echo Get-MpComputerStatus RC nach Update: !ERR_STATUS2!>>"%LOGFILE%"
echo.>>"%LOGFILE%"

@echo.   - Letzte Defender Events...
echo Defender Eventlog letzte 10 Events:>>"%LOGFILE%"
powershell.exe -NoProfile -ExecutionPolicy Bypass ^
 "Get-WinEvent -LogName 'Microsoft-Windows-Windows Defender/Operational' -MaxEvents 10 | Select TimeCreated,Id,Message | Format-List" >> "%LOGFILE%" 2>&1

echo.>>"%LOGFILE%"
echo ===============================================================================>>"%LOGFILE%"
echo Franksoft Windows Defender Update - Zusammenfassung>>"%LOGFILE%"
echo ===============================================================================>>"%LOGFILE%"
echo.>>"%LOGFILE%"
echo Signatur vorher : !SIG_BEFORE!>>"%LOGFILE%"
echo Datum vorher    : !SIGDATE_BEFORE!>>"%LOGFILE%"
echo.>>"%LOGFILE%"
echo Signatur nachher: !SIG_AFTER!>>"%LOGFILE%"
echo Datum nachher   : !SIGDATE_AFTER!>>"%LOGFILE%"
echo.>>"%LOGFILE%"
echo RC Status vorher: !ERR_STATUS1!>>"%LOGFILE%"
echo RC Update       : !ERR_UPDATE!>>"%LOGFILE%"
echo RC MpCmdRun     : !ERR_MPCMD!>>"%LOGFILE%"
echo RC Status nachh.: !ERR_STATUS2!>>"%LOGFILE%"
echo ===============================================================================>>"%LOGFILE%"

echo.>>"%LOGFILE%"
echo Fertig - %DATE% %TIME%>>"%LOGFILE%"

endlocal
exit /b 0