chcp 850
SET FSC_PHASE=01/06
:: =============================================================================
:: Script Name : SetupComplete.cmd
:: Path        : "D:\Sources\$OEM$\$$\Setup\Scripts\SetupComplete.cmd"
:: Version     : 6.8
:: Date        : 14.06.2026
:: Author      : Franksoft
::
:: Purpose
:: -----------------------------------------------------------------------------
:: FSC Deployment Phase 01/06
::
:: Install:
:: - Runtimes C++
:: - Drivers
::
:: LogFile      : %ProgramData%\Franksoft\Logs\Franksoft Client.txt"
:: =============================================================================

TITLE Franksoft Deployment - %~nx0 Time: %TIME%
setlocal EnableDelayedExpansion

SET "NT=%TIME: =0%"
SET "NT=%NT:~0,8%"

:: Do NOT CHANGE
set "FSC_DIR=%ProgramData%\Franksoft"
if not exist "%FSC_DIR%\Logs" md "%FSC_DIR%\Logs"
set FSC-LOG="%FSC_DIR%\Logs\Franksoft Client.txt"

set "FSC-LOG-Progress=%FSC_DIR%\Logs\SetupComplete-Progress.txt"
set "PSEXEC=%FSC_DIR%\Sysinternals\PsExec.exe"

set "FSC_REG=HKLM\SOFTWARE\Franksoft\Setup"
set "FSC_SCRIPT_NAME=%~nx0"
set "FSC_SCRIPT_PATH=%~f0"

reg add "%FSC_REG%\%FSC_SCRIPT_NAME%" /f
reg add "%FSC_REG%\%FSC_SCRIPT_NAME%" /v "Script Name" /t REG_SZ /d "%FSC_SCRIPT_NAME%" /f
reg add "%FSC_REG%\%FSC_SCRIPT_NAME%" /v "Script Path" /t REG_SZ /d "%FSC_SCRIPT_PATH%" /f
reg add "%FSC_REG%\%FSC_SCRIPT_NAME%" /v "FSC Phase" /t REG_SZ /d "%FSC_PHASE%" /f
reg add "%FSC_REG%\%FSC_SCRIPT_NAME%" /v "Start" /t REG_SZ /d "%DATE% %NT%" /f


echo 10^| Windows Setup Finalisierung %TIME%>>"%FSC-LOG-Progress%"


PUSHD "%~dp0"
IF Not Exist "%SystemDrive%\%~nx0_DBG" MD "%SystemDrive%\%~nx0_DBG"

Openfiles
IF %ErrorLevel% equ 0 (Set Admin-Status=Yes) else (Set Admin-Status=No)

SET FSC-Counter-Start=01
SET FSC-Counter-End=04
SET Status=Phase %FSC-Counter-Start%/%FSC-Counter-End%
SET FSC-Tools-Local=%ProgramData%\Franksoft
SET FSC-Scripts-Local=%FSC-Tools-Local%\Scripts
SET FSC-Scripts-USB=%USB-Stick-Path%\sources\$OEM$\$1\ProgramData\Franksoft\Scripts

SET REG_Path_01=HKLM\SYSTEM\HardwareConfig\Current
SET REG_KEY_01=SystemProductName
for /f "tokens=2*" %%A in ('reg query "%REG_Path_01%" /v %REG_KEY_01% 2^>nul') do SET SystemProductName=%%B

SET REG_Path_01=HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion
SET REG_KEY_01=CurrentBuild
for /f "tokens=2*" %%A in ('reg query "%REG_Path_01%" /v %REG_KEY_01% 2^>nul') do SET CurrentBuild=%%B

@echo.>>%FSC-LOG%
@Echo Franksoft Client ^| Windows Deployment ^| %Status% ^| Start>>%FSC-LOG%

EVENTCREATE /T INFORMATION /so Franksoft /ID 007 /l application /d "Franksoft Client | Windows Deployment | %Status% | Start | Script: %~nx0"


:: GET Windows Setup Source USB
for %%i in (
    A B D E F G H I J K L M N O P Q R S T U V W X Y Z
) do (
    if exist %%i:\Sources\setup.exe (
        set "USB-Stick-Path=%%i:"
    )
)

REG Add "HKCU\SOFTWARE\Sysinternals\Autologon" /v EulaAccepted /t REG_DWORD /d 1 /f
REG Add "HKCU\SOFTWARE\Sysinternals\PsExec" /v EulaAccepted /t REG_DWORD /d 1 /f

SET RK=HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion
for /f "tokens=3*" %%a in ('reg query "%RK%" /V "ProductName" ^|findstr /ri "REG_SZ"') do Set FullProductName=%%a %%b
SET RK=

SET RK=HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion
for /f "tokens=3*" %%a in ('reg query "%RK%" /V "EditionID" ^|findstr /ri "REG_SZ"') do Set EditionLong=%%a %%b
SET RK=

SET RK=HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion
for /f "tokens=3" %%a in ('reg query "%RK%"  /V "DisplayVersion" ^|findstr /ri "REG_SZ"') do Set WinRelease=%%a
SET RK=

for /f "tokens=4 delims=[] " %%i in ('ver') do set "WIN_VER=%%i"

if /i "%PROCESSOR_ARCHITECTURE%"=="AMD64" (
    set "BITNESS=x64"
) else (
    set "BITNESS=x86"
)

:::: Power Settings ::::::::::::::::::::::::::::::::::::::::::::::::::::::
Powercfg -change -monitor-timeout-ac 0
Powercfg -change -monitor-timeout-dc 0
Powercfg -change -disk-timeout-ac 0
Powercfg -change -disk-timeout-dc 0
Powercfg -change -standby-timeout-ac 0
Powercfg -change -standby-timeout-dc 0

REG ADD HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\238C9FA8-0AAD-41ED-83F4-97BE242C8F20\9d7815a6-7ee4-497e-8888-515a05f02364 /v Attributes /t REG_DWORD /d 2 /f

powercfg -change -hibernate-timeout-ac 45
powercfg -change -hibernate-timeout-dc 30

for /f "tokens=*" %%i in ('powercfg /getactivescheme') do (
    for /f "tokens=2 delims=()" %%a in ("%%i") do set "CurrentPowerScheme=%%a"
)

reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f
netsh advfirewall firewall add rule name="Remote Desktop" dir=in action=allow protocol=TCP localport=3389

SET "NT=%TIME: =0%"
SET "NT=%NT:~0,8%"

@echo. +------------------------------------------------------------+>>%FSC-LOG%
@echo.                                                   >>%FSC-LOG%
@echo.  Phase ID:      %Status% (Start)                  >>%FSC-LOG%
@echo.  Script Path:   %~dp0%~nx0                        >>%FSC-LOG%
@echo.  Timestamp:     %Date% %NT%                       >>%FSC-LOG%
@echo.                                                   >>%FSC-LOG%
@echo. +------------------------------------------------------------+>>%FSC-LOG%
@echo.  ComputerName:  %ComputerName%                    >>%FSC-LOG%
@echo.  Modell:        %SystemProductName%               >>%FSC-LOG%
@echo.  OS:            %FullProductName%                 >>%FSC-LOG%
@echo.  Bitness:       %Bitness%                         >>%FSC-LOG%
@echo.  Version:       %WIN_VER%                         >>%FSC-LOG%
@echo.  Release:       %WinRelease%                      >>%FSC-LOG%
@echo.  Build:         %CurrentBuild%                    >>%FSC-LOG%
@echo.  User:          %UserName%                        >>%FSC-LOG%
@echo.  IsAdmin:       %Admin-Status%                    >>%FSC-LOG%
@echo.  Power Plan:    %CurrentPowerScheme%              >>%FSC-LOG%
@echo. +------------------------------------------------------------+>>%FSC-LOG%
@Echo. >>%FSC-LOG%

@Echo. [INFO] Logging Deployment State>>%FSC-LOG%

IF Exist "%~dp0PowerPlanFS.cmd" (
    @Echo.>>%FSC-LOG%
    @Echo. [WINDOWS] Power Configuration>>%FSC-LOG%
    @Echo.    config Script: "%~dp0PowerPlanFS.cmd">>%FSC-LOG%
    CMD /c "%~dp0PowerPlanFS.cmd"
    TimeOut 3
    @Echo.    change Power Plan to %CurrentPowerScheme%>>%FSC-LOG%
    @Echo.    enable Hibernate option>>%FSC-LOG%
) ELSE (
    @Echo. [WINDOWS] Power Configuration>>%FSC-LOG%
    @Echo.    [ERROR] Not found %~dp0PowerPlanFS.cmd>>%FSC-LOG%
)

@Echo. >>%FSC-LOG%
@Echo. [WINDOWS] Customer Experience Improvement Program>>%FSC-LOG%
@Echo.    Disabled>>%FSC-LOG%
@Echo. >>%FSC-LOG%

SET TN-Path=\Microsoft\Windows\Customer Experience Improvement Program
schtasks /Change /TN "%TN-Path%\Consolidator" /Disable
schtasks /Change /TN "%TN-Path%\UsbCeip" /Disable

echo 45^| Runtime Installation %TIME%>>"%FSC-LOG-Progress%"

SET CPFILEPath=%USB-Stick-Path%\Runtimes\Install\_Microsoft
SET CPFILEPath0=%CPFILEPath%\VisualCppRedist_AIO.exe
SET CPFILEPath1=%CPFILEPath%\vc_redist.x86-2015-2019.exe
SET CPFILEPath2=%CPFILEPath%\vc_redist.x64-2015-2019.exe

@Echo. [SOFTWARE] Install Visual C++ Redistributable Runtimes>>%FSC-LOG%

IF Exist %CPFILEPath0% (
    @Echo.    All-in-One May Package 2026>>%FSC-LOG%
    "%CPFILEPath0%" /y
) else (
    @Echo.    [ERROR] Not found %CPFILEPath0%>>%FSC-LOG%
)

IF Exist %CPFILEPath1% (
    @Echo.    Microsoft Visual C++ 2015-2019 Redistributable x86>>%FSC-LOG%
    "%CPFILEPath1%" /passive
) else (
    @Echo.    [ERROR] Not found %CPFILEPath1% >>%FSC-LOG%
)

IF Exist %CPFILEPath2% (
    @Echo.    Microsoft Visual C++ 2015-2019 Redistributable x64>>%FSC-LOG%
    "%CPFILEPath2%" /passive
) else (
    @Echo.    [ERROR] NOT found %CPFILEPath2%>>%FSC-LOG%
)

SET File2Run=%USB-Stick-Path%\Runtimes\Install\VMware\tools\InstallVMwareTools.EXE
IF Exist "%File2Run%" "%File2Run%"
SET File2Run=

IF Exist "%ProgramFiles%\VMware\VMware Tools\vmtoolsd.exe" (
    @Echo.    VMware Tools Installed>>%FSC-LOG%
)

echo 65^| Security / Windows Settings %TIME%>>"%FSC-LOG-Progress%"

@Echo.>>%FSC-LOG%
@Echo. [WINDOWS] Security>>%FSC-LOG%

SET "FN=%~dp0Defender_Exclusion.cmd"
IF EXIST "%FN%" (
    @Echo.    Add Defender Exclusions:>>%FSC-LOG%
    @Echo.      * C:\ProgramData\Franksoft>>%FSC-LOG%
    @Echo.      * C:\Temp>>%FSC-LOG%
    @Echo.      * %TEMP%>>%FSC-LOG%
    @Echo.      * D:\>>%FSC-LOG%
    CALL "%FN%"
) ELSE (
    @Echo.    [ERROR] NOT found Defender Exclusions FILE: %FN%>>%FSC-LOG%
)

SET FSC_REGFile_UAC=%~dp0UAC-OFF.reg
IF Exist "%FSC_REGFile_UAC%" (
    @Echo.>>%FSC-LOG%
    @Echo.    Windows UAC disabled>>%FSC-LOG%
    Regedit /s "%FSC_REGFile_UAC%"
) ELSE (
    @Echo.    [ERROR] NOT found FSC UAC File: %FSC_REGFile_UAC%>>%FSC-LOG%
)
SET FSC_REGFile_UAC=

SET "FN=%~dp0FS-Log.inf"
IF Exist "%FN%" (
    @Echo.    Set access permissions on "%FSC-Tools-Local%" Script: %FN%>>%FSC-LOG%
    SECEDIT.EXE /CONFIGURE /CFG "%FN%" /DB "%TEMP%\FSC-acl_%RANDOM%.db"
) else (
    @Echo.    [ERROR] NOT found Set access permissions File: %FN%>>%FSC-LOG%
)

@Echo.    Set Password Never Expires=True for the local user "Admin".>>%FSC-LOG%
Powershell -ExecutionPolicy Bypass -Command "Get-LocalUser -Name 'Admin' | Set-LocalUser -PasswordNeverExpires $true"

SET Sysinternals_Path=%ProgramData%\Franksoft\Sysinternals

@Echo. >>%FSC-LOG%
@Echo. [WINDOWS] Environment Variables>>%FSC-LOG%
@Echo.    Add to OS Path Variable %Sysinternals_Path% >>%FSC-LOG%
IF NOT Exist "%Sysinternals_Path%" MD "%Sysinternals_Path%"
IF Exist "%Sysinternals_Path%" Setx /M PATH "%PATH%;%Sysinternals_Path%"

SET FSC_TASK_FILE01=%~dp0Microsoft_Store_Update.xml
IF Exist "%FSC_TASK_FILE01%" (
    @Echo.    Add scheduled task: Microsoft Store Updates
    @Echo.    Add scheduled task: Microsoft Store Updates >>%FSC-LOG%
    schtasks /create /tn "Microsoft Store Update" /xml "%FSC_TASK_FILE01%"
    TimeOut 3
) ELSE (
    @Echo.    [ERROR] NOT found File: %FSC_TASK_FILE01%>>%FSC-LOG%
)

@Echo.    Change volume label from drive C:\ to "System">>%FSC-LOG%
label %SystemDrive% System

IF Exist "%~dp0FSInfo.VBS" (
    @Echo. >>%FSC-LOG%
    @Echo. [FRANKSOFT] Registry >>%FSC-LOG%
    @Echo.    Add Franksoft Client and Hardware Info to HKLM\SOFTWARE\Franksoft >>%FSC-LOG%
    "%~dp0FSInfo.VBS"
) else (
    @Echo.    [ERROR] NOT found  Franksoft Client and Hardware Info File: "%~dp0FSInfo.VBS">>%FSC-LOG%
)

SET FSC_FSTools_Local=%ProgramData%\Franksoft
SET FSC_Scripts_Local=%FSC_FSTools_Local%\Scripts
Set VolApp1=%FSC_Scripts_Local%\WinAudio3.ExE
If Exist "%VolApp1%" (
    @Echo.    Mute Audio Volume>>%FSC-LOG%
    cmd /c Start "" "%VolApp1%" 1966
) else (
    @Echo.    [ERROR] NOT found Mute Audio Volume File: %VolApp1%>>%FSC-LOG%
)

SET REG-PATH-01=HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop

@Echo.    Windows Explorer Quick Access: Remove Catalog link>>%FSC-LOG%
reg delete %REG-PATH-01%\NameSpace\{e88865ea-0e1c-4e20-9aa6-edcd0212c87c} /f

echo 80^| Finalisierung / First Logon %TIME%>>"%FSC-LOG-Progress%"

SET FSC_REGFile_01=%~dp0FS-Cust.reg
@Echo. >>%FSC-LOG%
@Echo. [FRANKSOFT] First Logon Settings>>%FSC-LOG%

IF Exist "%FSC_REGFile_01%" (
    @Echo.    Apply FSC First Logon Settings>>%FSC-LOG%
    Regedit /s "%FSC_REGFile_01%"
) ELSE (
    @Echo.    [ERROR] NOT found FSC First Logon Settings File: %FSC_REGFile_01%>>%FSC-LOG%
)
SET FSC_REGFile_01=

SET "IMG=%ProgramData%\Franksoft\Logos\Logon\01-R.png"
SET "CSP=HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP"
SET "POL=HKLM\SOFTWARE\Policies\Microsoft\Windows\System"

IF Exist "%IMG%" (
    @Echo.>>%FSC-LOG%
    @Echo. [FRANKSOFT] Lockscreen>>%FSC-LOG%
    @Echo.    Add FSC Windows Deployment Lockscreen>>%FSC-LOG%
    @Echo.    File: %IMG%>>%FSC-LOG%

    reg add "%CSP%" /f
    reg add "%CSP%" /v LockScreenImagePath /t REG_SZ /d "%IMG%" /f
    reg add "%CSP%" /v LockScreenImageUrl /t REG_SZ /d "%IMG%" /f
    reg add "%CSP%" /v LockScreenImageStatus /t REG_DWORD /d 1 /f
    reg add "%POL%" /v DisableLogonBackgroundImage /t REG_DWORD /d 0 /f
) ELSE (
    @Echo.>>%FSC-LOG%
    @Echo. [FRANKSOFT] Lockscreen>>%FSC-LOG%
    @Echo.    [ERROR] NOT found Windows Lockscreen File: %IMG%>>%FSC-LOG%
)

echo 95^| Driver Installation %TIME%>>"%FSC-LOG-Progress%"

@Echo. >>%FSC-LOG%
@Echo. [DRIVER] Installation Start Time: %NT%>>%FSC-LOG%

set "USB-Stick-Path_Drivers="

for %%i in (
    B C D E F G H I J K L M N O P Q R S T U V W X Y Z
) do (
    if exist %%i:\_Drivers\Franksoft_Drivers1.txt (
        set "USB-Stick-Path_Drivers=%%i:"
        goto :FoundDrivers
    )
)

goto :NEXT_AFTER_DRV

:FoundDrivers
@echo.    Search Drivers on USB Drive !USB-Stick-Path_Drivers!>>%FSC-LOG%
goto :NEXT_AFTER_DRV

:NEXT_AFTER_DRV

SET "NT=%TIME: =0%"
SET "NT=%NT:~0,8%"

::
:: Call Driver Script
::
SET Drivers-Path=%USB-Stick-Path_Drivers%\_Drivers
SET FSC_DRV_Script=%Drivers-Path%\Install_HP-Drivers.cmd

IF Exist "%FSC_DRV_Script%" (
    @Echo.    ^>  Start Time: %NT% >>%FSC-LOG%
    @Echo.    ^>  Script: %FSC_DRV_Script% >>%FSC-LOG%
    Call "%FSC_DRV_Script%"
) ELSE (
    @Echo. [ERROR] NOT found Driver Script %FSC_DRV_Script%>>%FSC-LOG%
)

SET "NT=%TIME: =0%"
SET "NT=%NT:~0,8%"

IF Exist "%FSC_DRV_Script%" (
    TimeOut 5
    @Echo.    ^>  End   Time: %NT% >>%FSC-LOG%
)

SET FSC_DRV_Script=
@Echo. [DRIVER] Installation End Time:   %NT%>>%FSC-LOG%

@Echo.>>%FSC-LOG%
@Echo. [INFO] Logging Deployment State>>%FSC-LOG%
@Echo. [ACTION] Reboot Initiated>>%FSC-LOG%

SET "NT=%TIME: =0%"
SET "NT=%NT:~0,8%"

@Echo.>>%FSC-LOG%
@echo. +------------------------------------------------+>>%FSC-LOG%
@echo.  Phase ID:      %Status% (End)            >>%FSC-LOG%
@echo.  Script Path:   %~dp0%~nx0                >>%FSC-LOG%
@echo.  Timestamp:     %Date% %NT%               >>%FSC-LOG%
@echo.  User:          %UserName%                >>%FSC-LOG%
@echo.  Power Plan:    %CurrentPowerScheme%      >>%FSC-LOG%
@echo. +------------------------------------------------+>>%FSC-LOG%
@Echo. >>%FSC-LOG%

@Echo Franksoft Client ^| Windows Deployment ^| %Status% ^| End>>%FSC-LOG%
@Echo.>>%FSC-LOG%
@Echo ************************************************************************************* >>%FSC-LOG%
@Echo.>>%FSC-LOG%

set "FSC_REG=HKLM\SOFTWARE\Franksoft\Setup"
set "FSC_SCRIPT_NAME=%~nx0"
set "FSC_SCRIPT_PATH=%~f0"
reg add "%FSC_REG%\%FSC_SCRIPT_NAME%" /v "End" /t REG_SZ /d "%DATE% %NT%" /f

EVENTCREATE /T INFORMATION /so Franksoft /ID 007 /l application /d "Franksoft Client | Windows Deployment | %Status% | End | Script: %~nx0"

REG delete HKCU\Software\Policies\Microsoft\Windows\Explorer /v DisableNotIFicationCenter /f

IF Exist "%SystemDrive%\%~nx0_DBG" RD "%SystemDrive%\%~nx0_DBG"

Powershell Set-WinHomeLocation 223

sc config WinDefend start= auto
sc start WinDefend

Endlocal

