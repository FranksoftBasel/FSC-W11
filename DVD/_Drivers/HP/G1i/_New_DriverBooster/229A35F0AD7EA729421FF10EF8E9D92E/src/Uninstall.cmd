@echo off
rem DLMRH01-9982 [Windows]Adjust INF install package structure
:::Auto require administrator to avoid special path limitation
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

if '%errorlevel%' NEQ '0' (

    echo Applying run as administrator

    goto UACPrompt

) else ( goto gotAdmin )

:UACPrompt

    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"

    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"

    exit /B

:gotAdmin

    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )

    pushd "%CD%"

    CD /D "%~dp0"
echo got admin authoright

setlocal enabledelayedexpansion

cd /d "%~dp0"

if defined FCC_LOG_FOLDER (
    SET "APP_LOG=%FCC_LOG_FOLDER%\%~n0.log"
    if not exist "%FCC_LOG_FOLDER%" md "%FCC_LOG_FOLDER%"
) else (
    SET "APP_LOG=%~d0\programdata\HP\logs\uninstall_bat.log"
    if not exist "%~d0\programdata\HP\logs" md "%~d0\programdata\HP\logs"
)
echo App Log: %APP_LOG%
echo [%TIME%] Uninstall Bat Started >> %APP_LOG%

chcp 437 > nul

set targetDID=09C8
set targetVID=03F0

echo [%TIME%] Check DID=%targetDID% VID=%targetVID% >> %APP_LOG%

for /f "delims=" %%i in ('powershell -Command "$null -ne $(Get-PnpDevice | ? { $_.InstanceId -like '*VEN_%targetVID%&DEV_%targetDID%*' -and $_.Present -eq $true })"') do set T700CardExistBool=%%i
if /i "%T700CardExistBool%"=="False" (
    echo [%TIME%] T700 datacard does not exist on this laptop. >> %APP_LOG%
    echo [%TIME%] Script Aborting... >> %APP_LOG%
    EXIT /B 1
)

rem DLMRH01-12951 [Windows] Disable the Diag Driver's platform ID change feature
echo [%TIME%]Set Reg InstallationMode to 2 for setting installation mode to shipping driver >> %APP_LOG%
C:\Windows\System32\reg.exe add "HKLM\SOFTWARE\WOW6432Node\Intel\FwFlashService" /v "InstallationMode" /t REG_DWORD /d "2" /f 

echo [%TIME%] Add ToolFLashed Registry Flag to 0 >> %APP_LOG%
C:\Windows\System32\reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\WwanNet\TelephonyToolService" /v "ToolFlashed" /t REG_DWORD /d "0" /f

echo [%TIME%] Add EsimMitigationActive Registry Flag to 0 >> %APP_LOG%
C:\Windows\System32\reg.exe add "HKLM\SOFTWARE\WOW6432Node\Intel\FwFlashService" /v "EsimMitigationActive" /t REG_DWORD /d "0" /f

echo [%TIME%] Execute AuxiliaryDriverUninstall by powershell >> %APP_LOG%
powershell -ExecutionPolicy Bypass -File .\AuxiliaryDriverUninstall.ps1

rem Start DLMRH01-19305 add copy script for MIPI/Disable band/SAR&ATT image in installer script
rem content: remove C:\\ProgramData\\HP\\DLMRH01
rem ==============================
setlocal enableextensions

set "DST1=%ProgramData%\HP\DLMRH01"

echo. >> %APP_LOG%
echo [%TIME%] ===== Delete DLMRH01 data ===== >> %APP_LOG%
echo [%TIME%] DST1 = %DST1% >> %APP_LOG%
echo. >> %APP_LOG%

if exist "%DST1%" (
    rmdir /S /Q "%DST1%" >> %APP_LOG% 2>&1
)
rem End DLMRH01-19305 add copy script for MIPI/Disable band/SAR&ATT image in installer script 
rem ==============================

echo [%TIME%] Script Exiting... >> %APP_LOG%



