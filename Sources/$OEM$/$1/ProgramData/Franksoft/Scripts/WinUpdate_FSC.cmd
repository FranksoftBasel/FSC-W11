@echo off
setlocal EnableExtensions

SET FSC_PHASE=05/06
chcp 850 >NUL
COLOR 04
@MODE CON: COLS=74 LINES=12
TITLE Franksoft Client: Windows Update - Prepare

@SET DBG=0


@echo.  
@echo.  
@Echo. Please wait for Franksoft Client: Windows Update - Prepare
@Echo. 

@SET "FSC_VERSION=2.4"

:: =============================================================================
:: Script Name : WinUpdate_FSC.cmd
:: Path        : C:\Temp\Updates\WinUpdate_FSC.cmd
:: Version     : %FSC_VERSION%
:: Date        : 21.09.2026
:: Author      : Franksoft
:: Modules     : PowerShell-Modul PSWindowsUpdate
::
:: Purpose     : FSC Windows Update
:: -----------------------------------------------------------------------------
:: FSC Deployment Phase 05/06
::
:: Microsoft Updates
:: WinGet Package Updates
:: Windows Update in max. 12 Runden
::
:: Log
:: -----------------------------------------------------------------------------
:: %ProgramData%\Franksoft\Logs\Franksoft Client.txt
:: %ProgramData%\Franksoft\Logs\WinUpdate_FSC.log
:: =============================================================================

Powershell (Get-WmiObject -Namespace root/WMI -Class WmiMonitorBrightnessMethods).WmiSetBrightness(1,40)

SET "NT=%TIME: =0%"
SET "NT=%NT:~0,8%"

set "REG_FSCWU=HKLM\SOFTWARE\Franksoft\WindowsUpdate"
set "REG_WUPCOUNT=HKLM\SOFTWARE\Franksoft\WupCount"
set "FSC_REG=HKLM\SOFTWARE\Franksoft\Setup"
set "FSC_SCRIPT_NAME=%~nx0"
set "FSC_SCRIPT_PATH=%~f0"

REG Add "%FSC_REG%\%FSC_SCRIPT_NAME%" /f >nul 2>nul

REG Add "%FSC_REG%\%FSC_SCRIPT_NAME%" /v "Script Name" /t REG_SZ /d "%FSC_SCRIPT_NAME%" /f >nul
REG Add "%FSC_REG%\%FSC_SCRIPT_NAME%" /v "Script Path" /t REG_SZ /d "%FSC_SCRIPT_PATH%" /f >nul
REG Add "%FSC_REG%\%FSC_SCRIPT_NAME%" /v "FSC Phase" /t REG_SZ /d "%FSC_PHASE%" /f >nul
REG Add "%FSC_REG%\%FSC_SCRIPT_NAME%" /v "Start" /t REG_SZ /d "%DATE% %NT%" /f >nul

IF NOT Exist "%TEMP%\WinUpdatesView_List" (
        Call "%ProgramData%\Franksoft\Scripts\WinUpdatesView_List.cmd" before >NUL 2>NUL
        MD "%TEMP%\WinUpdatesView_List"
)

TITLE Franksoft Client: Windows Update - Script: %~nx0 - %NT%

SET FSC_LOG="%ProgramData%\Franksoft\Logs\Franksoft Client.txt"
SET FSC_LOG_UPD="%ProgramData%\Franksoft\Logs\WinUpdate_FSC.log"

:: SET FSC WUP Wallpaper
REG Add "HKCU\Control Panel\Colors" /v Background /t REG_SZ /d "0 0 0" /f >NUL 2>&1
SET WallP_exe=%ProgramData%\Franksoft\Scripts\WallP.exe
SET WallPaper=%ProgramData%\Franksoft\Logos\WindowsUpdate_FSC_Logo_01.png
IF EXIST "%WallP_exe%" IF EXIST "%WallPaper%" (
    "%WallP_exe%" "%WallPaper%" FIT
) ELSE (
    @Echo.   - Franksoft: WallPaper NOT found %WallPaper%>>%FSC_LOG%
)
SET WallPaper=

net start dosvc 1>NUL 2>NUL
Timeout 10 >NUL
CLS

SET "NT=%TIME: =0%"
SET "NT=%NT:~0,8%"

IF Not Exist "C:\%~nx0" MD "C:\%~nx0"

SET FSC_TITLE_01=Franksoft Client: Windows Update - Prepare WLAN
SET FSC_TITLE_0x=Franksoft Client: Windows Update - Time: %NT:~0,8%
SET FSC_TITLE_LOG=Franksoft Client: Windows Update Start  - Time: %NT:~0,8%

@Echo. ============================================================>>%FSC_LOG_UPD%
@Echo. WinUpdate_FSC.cmd Start - Time: %NT:~0,8%>>%FSC_LOG_UPD%
@Echo. - Version:       %FSC_VERSION%>>%FSC_LOG_UPD%
@Echo. - Computer:      %COMPUTERNAME%>>%FSC_LOG_UPD%
@Echo. - User:          %USERNAME%>>%FSC_LOG_UPD%
@Echo. ============================================================>>%FSC_LOG_UPD%

REM -----------------------------------------------------------------------------
REM Windows Update phase counter - Registry only
REM HKLM\SOFTWARE\Franksoft\WupCount
REM   Phase01    REG_SZ   1..12
REM   WinGetDone REG_SZ   1
REM -----------------------------------------------------------------------------

REM A completed previous deployment means this is a new FSC WU run.
REM Reset only the WupCount state; WindowsUpdate history values stay untouched.
SET "FSC_PREV_RESULT="
FOR /F "tokens=2,*" %%A IN ('REG QUERY "%REG_FSCWU%" /v LastResult 2^>NUL ^| FIND /I "LastResult"') DO SET "FSC_PREV_RESULT=%%B"
IF /I "%FSC_PREV_RESULT%"=="Success" (
    REG DELETE "%REG_WUPCOUNT%" /f >NUL 2>NUL
)

REG Add "%REG_WUPCOUNT%" /f >NUL 2>NUL

SET "Status2=0"
FOR /F "tokens=2,*" %%A IN ('REG QUERY "%REG_WUPCOUNT%" /v Phase01 2^>NUL ^| FIND /I "Phase01"') DO SET "Status2=%%B"

REM Validate numeric value
SET /A Status2=%Status2%+0 2>NUL
IF %Status2% LSS 0 SET "Status2=0"

REM Safety: if phase 12 was already completed but Finish was interrupted, finish now.
IF %Status2% GEQ 12 (
    SET "Status=12"
    SET "UpdatePhase=12/12"
    SET "PHASE_NAME=Phase12"
    GOTO Finish
)

REM Increase exactly once for this Windows Update boot/run.
SET /A Status2+=1
REG Add "%REG_WUPCOUNT%" /v Phase01 /t REG_SZ /d "%Status2%" /f >NUL

SET "Status=%Status2%"
IF %Status2% LSS 10 (
    SET "UpdatePhase=0%Status2%/12"
    SET "PHASE_NAME=Phase0%Status2%"
) ELSE (
    SET "UpdatePhase=%Status2%/12"
    SET "PHASE_NAME=Phase%Status2%"
)

@Echo. - Registry WU Counter: %UpdatePhase%>>%FSC_LOG_UPD%

Title %FSC_TITLE_0x% - Phase ID: %UpdatePhase%

SET "DesktopOK_PATH=%ProgramData%\Franksoft\Scripts\DesktopOK"
SET "DesktopOK_VBS=%DesktopOK_PATH%\DesktopOK_Start.vbs"
IF EXIST "%DesktopOK_VBS%" "%DesktopOK_VBS%"

Openfiles 2>NUL 1>&2
IF %ErrorLevel% equ 0 (Set Admin-Status=Yes) else (Set Admin-Status=No)

:: GET Windows Setup USB Drive letter
for %%i in (B D E F G H I J K L M N O P Q R S T U V W X Y Z) do @IF Exist %%i:\Sources\setup.exe set USB_Stick_Path=%%i:

SET "NT=%TIME: =0%"
SET "NT=%NT:~0,8%"

:: Set Windows Sound Volume to 33%
Set VolApp1=%FSC-Tools-Local%\Scripts\SetVol.vbs
If Exist "%VolApp1%" Start "" "%VolApp1%"

:: Check and Connect
SET WFWI_Profile_Path=%ProgramData%\Franksoft\FSC-Apps\Wlan
SET WFWI_Profile=%WFWI_Profile_Path%\WLAN-BatMan.xml
SET WFWI_Connect_Script=%WFWI_Profile_Path%\Connect-Batman.cmd

IF Exist "%TEMP%\Wlan-Connected-01" GOTO START2

IF EXIST "%WFWI_Profile%" IF EXIST "%WFWI_Connect_Script%" (
        Echo.
        echo.   - WLAN: Import Franksoft WLAN Profile
        CMD /c "%WFWI_Connect_Script%" >NUL
        MD %TEMP%\Wlan-Connected-01 >NUL
        Timeout 4 >NUL
) ELSE (
        Echo. - WLAN Profile File not found: %WFWI_Profile% >>%FSC_LOG%
        Timeout 10 >NUL
)

:START2
Color 60
CLS
echo.
echo.
echo.  Franksoft Client: Windows Update Prepare
echo.

If Not Exist "%Temp%\Timeout1Done" @Timeout 12

SET NT=
SET "NT=%TIME: =0%"
SET "NT=%NT:~0,8%"

REM Registry tracking for current phase
REG Add "%REG_FSCWU%" /v CurrentRound /t REG_DWORD /d %Status% /f >NUL
REG Add "%REG_FSCWU%" /v CurrentPhase /t REG_SZ /d "%PHASE_NAME%" /f >NUL
REG QUERY "%REG_FSCWU%" /v FirstStart%PHASE_NAME% >NUL 2>NUL
IF ERRORLEVEL 1 REG Add "%REG_FSCWU%" /v FirstStart%PHASE_NAME% /t REG_SZ /d "%DATE% %NT%" /f >NUL
REG Add "%REG_FSCWU%" /v LastStart%PHASE_NAME% /t REG_SZ /d "%DATE% %NT%" /f >NUL
REG Add "%REG_FSCWU%" /v LastResult /t REG_SZ /d "Running" /f >NUL

SET FSC_LOG="%ProgramData%\Franksoft\Logs\Franksoft Client.txt"

REM WinGet was proven working in FSC 2.0 at update round 3.
REM Run it once as soon as round 3 is reached; WinGetDone prevents duplicates.
REM This also recovers automatically if a manual/extra start skips exact round 3.
SET "FSC_WINGET_DONE=0"
REG QUERY "%REG_WUPCOUNT%" /v WinGetDone >NUL 2>NUL && SET "FSC_WINGET_DONE=1"
IF %Status% GEQ 3 IF "%FSC_WINGET_DONE%"=="0" CALL :RunWinGet

IF "%Status%"=="4" (
    cmd /c start /min chrome
    Timeout 4 >NUL
    Taskkill /im Chrome.exe /f >NUL
    cmd /c start /min chrome
    Timeout 2 >NUL
    Taskkill /im Chrome.exe /f >NUL
    @echo.   - Install DotNet 3.5
    @echo.   - Install DotNet 3.5>>%FSC_LOG%
    Dism.exe /online /enable-feature /featurename:NetFX3
)

SET "FSC_RUN_PHASE=%Status%"
SET FSC_TITLE=Franksoft Client: Windows Update: Phase %UpdatePhase%
SET FSC_TITLE_0x=%FSC_TITLE%
SET FSC_LOG="%ProgramData%\Franksoft\Logs\Franksoft Client.txt"

@Echo. %FSC_TITLE_LOG%>>%FSC_LOG%
@Echo. >>%FSC_LOG%
@Echo. - FSC Phase ID:   %UpdatePhase%>>%FSC_LOG%
@Echo. - Timestamp:      %Date% %NT%>>%FSC_LOG%
@Echo. - Executed by:    %UserName%>>%FSC_LOG%
@Echo. - Admin Status:   %Admin-Status%>>%FSC_LOG%
@Echo. - Script Path:    %~dp0%~nx0>>%FSC_LOG%
@Echo. >>%FSC_LOG%

If Not Exist "%Temp%\Timeout1Done" MD "%Temp%\Timeout1Done"

:::::::::::::::::::::::::::::::::::::::::: START ::::::::::::::::::::::::::::::::::::::::::

:RUN
SET NT=
SET "NT=%TIME: =0%"
SET "NT=%NT:~0,8%"

@COLOR 20

:: Franksoft Windows Update Phase %Status% Time: %NT%
:: Franksoft Client: Windows Update Prepare

@echo.   - Windows Update Start

EVENTCREATE /T INFORMATION /so Franksoft /ID 007 /l application /d "Franksoft Client: Windows Update Start Phase: %Status% %~nx0" 1>NUL 2>NUL

@echo.   - Set Performance Power Scheme
@echo.   - Set Performance Power Scheme>>%FSC_LOG%

:: @echo. - Set Performance Power Scheme>>%FSC_LOG%
Powercfg -SetActive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
powercfg -change -monitor-timeout-ac 0 >NUL
powercfg -change -monitor-timeout-dc 0 >NUL

:: Disable UAC
REG Add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v EnableLUA /t REG_DWORD /d 0 /f >NUL

:: Get PS Policy
:: @FOR /F "tokens=* USEBACKQ" %%F IN (`Powershell.exe Get-ExecutionPolicy`) DO (
:: SET EP=%%F
:: )

:: SET NuGetCFG=%AppData%\NuGet\nuget.config
SET NuGetCFG=%ProgramFiles%\PackageManagement\ProviderAssemblies\nuget
If Not Exist "%NuGetCFG%" @echo. - Install: PS Module PackageProvider "NuGet"
:: If Not Exist "%NuGetCFG%" Start /min "" Powershell.exe Install-PackageProvider -Name "NuGet" -Confirm:$false -Force -Verbose >NUL
:: If Not Exist "%NuGetCFG%" Powershell.exe Install-PackageProvider -Name "NuGet" -Confirm:$false -Force -Verbose >NUL
If Not Exist "%NuGetCFG%" Powershell.exe Install-PackageProvider -Name "NuGet" -Confirm:$false -Force >NUL

SET PSWINUPDPATH=%ProgramFiles%\WindowsPowerShell\Modules\PSWindowsUpdate
If Not Exist "%PSWINUPDPATH%" @echo. - Install: PS Module PSWindowsUpdate
If Not Exist "%PSWINUPDPATH%" Powershell.exe Install-Module PSWindowsUpdate -Force >NUL

If Not Exist "%PSWINUPDPATH%" @echo. - Install: PS Module PSWindowsUpdate 
If Not Exist "%PSWINUPDPATH%" Powershell.exe Import-Module PSWindowsUpdate -Force >NUL

:: Defender Updadte

SET "FSC_DEFENDER_MARKER=%TEMP%\FSC_DefenderUpdateDone"
set "WinDefenderUpdate=%ProgramData%\Franksoft\Scripts\DefenderUpdate.cmd"

if exist "%FSC_DEFENDER_MARKER%" (
    echo.   - Defender Update: already done>>%FSC_LOG%
    IF DEFINED FSC_LOG_UPD echo.   - Defender Update: already done>>%FSC_LOG_UPD%
) ELSE (
    if exist "%WinDefenderUpdate%" (
        echo.   - Update: Microsoft Defender Signatur
        echo.   - Update: Microsoft Defender Signatur>>%FSC_LOG%
        IF DEFINED FSC_LOG_UPD echo.   - Update: Microsoft Defender Signatur>>%FSC_LOG_UPD%

        call "%WinDefenderUpdate%"

        echo.   - Defender Update ReturnCode: %ERRORLEVEL%>>%FSC_LOG%
        IF DEFINED FSC_LOG_UPD echo.   - Defender Update ReturnCode: %ERRORLEVEL%>>%FSC_LOG_UPD%

        MD "%FSC_DEFENDER_MARKER%" >NUL 2>NUL
    ) ELSE (
        echo.   * Defender Update Script not found: %WinDefenderUpdate%>>%FSC_LOG%
        IF DEFINED FSC_LOG_UPD echo.   * Defender Update Script not found: %WinDefenderUpdate%>>%FSC_LOG_UPD%
    )
)

SET "FSC_DEFENDER_MARKER=%TEMP%\FSC_DefenderUpdateDone"
:: Defender Update END

SET NT=%TIME: =0%

@echo.   - Check Windows Updates
@echo.   - Get-WindowsUpdate>>%FSC_LOG%
IF DEFINED FSC_LOG_UPD @echo.   - Get-WindowsUpdate>>%FSC_LOG_UPD%
Powershell.exe Get-WindowsUpdate -ComputerName %COMPUTERNAME% -Confirm:$false -Force >NUL


Title %FSC_TITLE_LOG% - Phase ID: %UpdatePhase%

@color 2f

@CLS
@echo.  
@echo.  
@echo.  Franksoft Client: Windows Update Run - Time:%NT:~0,8%
echo. 
@echo.   - Install Windows Updates
@echo.   - Install Windows Updates>>%FSC_LOG%
IF DEFINED FSC_LOG_UPD @echo.   - Install Windows Updates>>%FSC_LOG_UPD%
@echo. 
@echo. 
Powershell.exe Install-WindowsUpdate -ComputerName %COMPUTERNAME% -IgnoreReboot -Confirm:$false -Verbose -AcceptAll >NUL
@echo.   - Install-WindowsUpdate ReturnCode: %ERRORLEVEL%>>%FSC_LOG%
IF DEFINED FSC_LOG_UPD @echo.   - Install-WindowsUpdate ReturnCode: %ERRORLEVEL%>>%FSC_LOG_UPD%

SET "NT=%TIME: =0%"
SET "NT=%NT:~0,8%"

@echo. >>%FSC_LOG%
@echo. Franksoft Client: Windows Update Reboot - Time: %NT:~0,8%>>%FSC_LOG%

REG Add "%REG_FSCWU%" /v LastEnd%PHASE_NAME% /t REG_SZ /d "%DATE% %NT%" /f >NUL
REG Add "%REG_FSCWU%" /v LastResult /t REG_SZ /d "Reboot" /f >NUL

IF "%FSC_RUN_PHASE%"=="12" GOTO Finish
Goto Reboot

:: -------------------------------------------------------------------------------------------------------------------------

:Finish

Title %FSC_TITLE_LOG%  - Phase ID: %UpdatePhase% - Time: %NT%

SET RK_UAC=HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System
SET FSC_UAC_DEF=%ProgramData%\Franksoft\Scripts\UAC-DEF.reg

REG Add "%REG_FSCWU%" /v CurrentPhase /t REG_SZ /d "Finish" /f >NUL
REG Add "HKCU\Control Panel\Colors" /v Background /t REG_SZ /d "7 25 99" /f >NUL

If Exist "%FSC_UAC_DEF%" (
    @Echo.>>%FSC_LOG%
    @Echo.   - Windows: Enable UAC
    @Echo.   - Windows: Enable UAC>>%FSC_LOG%
    Regedit /s "%FSC_UAC_DEF%"
    REG Add %RK_UAC% /v EnableLUA /t REG_DWORD /d 1 /f >NUL
) ELSE (
    @Echo.   * NOT found Windows: Enable UAC "%FSC_UAC_DEF%">>%FSC_LOG%
    REG Add %RK_UAC% /v EnableLUA /t REG_DWORD /d 1 /f >NUL
)

:: SET Last Wallpaper
SET WallP_exe=%ProgramData%\Franksoft\Scripts\WallP.exe
SET WallPaper=%SystemRoot%\Web\4K\Wallpaper\Windows\FSC_Final_W11_01.jpg
IF EXIST "%WallP_exe%" IF EXIST "%WallPaper%" (
    @Echo.   - Franksoft: Set default WallPaper >>%FSC_LOG%
    "%WallP_exe%" "%WallPaper%" CENTER
) ELSE (
    @Echo.   * Franksoft: WallPaper NOT found %WallPaper%>>%FSC_LOG%
)

@echo.   - Windows: Enable Windows System Restore
@echo.   - Windows: Enable Windows System Restore >>%FSC_LOG%
cmd /c start "" powershell -NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -Command "Enable-ComputerRestore -Drive 'C:\'" >NUL

@Echo.   - Power Plan: Change to Balanced
@Echo.   - Power Plan: Change to Balanced>>%FSC_LOG%

Powercfg -SetActive 381b4222-f694-41f0-9685-ff5bb260df2e >NUL

:: Disable Monitor Timeout
@Echo.   - Change: Monitor Timeout AC 10 - DC 5>>%FSC_LOG%
@Echo.   - Change: Monitor Timeout

powercfg -change -monitor-timeout-ac 10 >NUL
powercfg -change -monitor-timeout-dc 5 >NUL

:: Change HardDisk Timeout
powercfg -change -disk-timeout-ac 22 >NUL
powercfg -change -disk-timeout-dc 11 >NUL

:: Change Sleep Timeout (Energiesparmodus)
powercfg -change -standby-timeout-ac 20 >NUL
powercfg -change -standby-timeout-dc 15 >NUL

@Echo.   - Disable: Hybrid Standbymode>>%FSC_LOG%
@Echo.   - Disable: Hybrid Standbymode

SET "FSC_WINUP_Collect_PS1=%ProgramData%\Franksoft\Scripts\WinUpdatesView-FSC-Summary.ps1"

IF EXIST "%FSC_WINUP_Collect_PS1%" (
    @Echo.   - Collect Windows Updates to %ProgramData%\Franksoft\Logs\WindowsUpdate\WinUpdatesView_Summary.txt
    @Echo.   - Collect Windows Updates to %ProgramData%\Franksoft\Logs\WindowsUpdate\WinUpdatesView_Summary.txt>>%FSC_LOG%
    powershell.exe -ExecutionPolicy Bypass -File "%FSC_WINUP_Collect_PS1%" 1>NUL 2>NUL
) ELSE (
    @Echo.   * Collect Windows Updates Script NOT found %FSC_WINUP_Collect_PS1%>>%FSC_LOG%
)

:: Disable Hybrid Standby
powercfg -setacvalueindex SCHEME_CURRENT SUB_SLEEP HYBRIDSLEEP 0
powercfg -setdcvalueindex SCHEME_CURRENT SUB_SLEEP HYBRIDSLEEP 0
powercfg -SetActive SCHEME_CURRENT

SET NT=
SET "NT=%TIME: =0%"
SET "NT=%NT:~0,8%"

SET FSC_TITLE=Franksoft Client: Windows Update Completed - Time: %NT:~0,8%>>%FSC_LOG%

:: Add Final FSC Scripts
SET REGKEY-RunOnce=HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce
SET FSC_Scripts_Local=%ProgramData%\Franksoft\Scripts
SET Audio_SCR=%FSC_Scripts_Local%\PlayAudio.vbs
SET DesktopOK=%ProgramData%\Franksoft\Scripts\DesktopOK\DesktopOK_Start.vbs
SET FSC-ENDMSG_VBS=%FSC_Scripts_Local%\FSC-Complete.VBS
SET FSC_COMPLETE_PS1=%FSC_Scripts_Local%\FSC-Complete.ps1

REG Add "%REGKEY-RunOnce%" /v 01-FSC_END_Sound /d "CScript %Audio_SCR% //Nologo //T:05" /f >NUL
REG Add "%REGKEY-RunOnce%" /v 02-FSC_END_MSG /d "%DesktopOK%" /f >NUL
REG Add "%REGKEY-RunOnce%" /v 03-FSC_END_CleanMgr /d "cleanmgr /sagerun:65535" /f >NUL
REM Start FSC-Complete.ps1 directly; use VBS only as fallback
IF EXIST "%FSC_COMPLETE_PS1%" (
    REG Add "%REGKEY-RunOnce%" /v 04-FSC_END_MSG /d "Powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File \"%FSC_COMPLETE_PS1%\"" /f >NUL
) ELSE (
    REG Add "%REGKEY-RunOnce%" /v 04-FSC_END_MSG /d "%FSC-ENDMSG_VBS%" /f >NUL
)

EVENTCREATE /T INFORMATION /so Franksoft /ID 007 /l application /d "Franksoft Client: Windows Update Completed" 1>NUL 2>NUL

schtasks /delete /tn "Franksoft Windows Update" /f >NUL 2>NUL
IF Exist "C:\%~nx0" RD /S/Q "C:\%~nx0"

RD /S/Q "%TEMP%" >NUL 2>NUL
MD "%TEMP%" >NUL 2>NUL

RD /S/Q C:\Temp >NUL 2>NUL
MD C:\Temp >NUL 2>NUL

@Echo. >>%FSC_LOG%
@Echo. %FSC_TITLE%>>%FSC_LOG%
@Echo. >>%FSC_LOG%
@Echo.************************************************************************************* >>%FSC_LOG%
@Echo. >>%FSC_LOG%
IF DEFINED FSC_LOG_UPD @Echo. WinUpdate_FSC.cmd Finish erreicht - RunOnce/EndMsg vorbereitet>>%FSC_LOG_UPD%
IF DEFINED FSC_LOG_UPD @Echo. ============================================================>>%FSC_LOG_UPD%

SET "NT=%TIME: =0%"
SET "NT=%NT:~0,8%"

REG Add "%REG_FSCWU%" /v LastResult /t REG_SZ /d "Success" /f >NUL 2>NUL
REG Add "%REG_FSCWU%" /v DeploymentEnd /t REG_SZ /d "%DATE% %NT%" /f >NUL 2>NUL

Call "%ProgramData%\Franksoft\Scripts\WinUpdatesView_List.cmd" after >NUL 2>NUL
TITLE Franksoft Client: Windows Update - Script: %~nx0 - %NT%

Goto Reboot

:Reboot
SET TIMER=15
SET FSC-MSG01=Franksoft: Windows Update - Reboot in %Timer%Sec
SET PSShutDownScr=%ProgramData%\Franksoft\Scripts\FS-Shutdown.ps1
SET PSShutDownEx=Powershell.exe -EP ByPass -NoLogo -NonInteractive -NoProfile -WindowStyle Hidden -File "%PSShutDownScr%"

COLOR 20
@Echo.
@Echo.
@Echo.         %FSC-MSG01%
@Echo.
@Echo.

IF Exist "%DesktopOK_VBS%" "%DesktopOK_VBS%"

SET "NT=%TIME: =0%"
SET "NT=%NT:~0,8%"

REG Add "%FSC_REG%\%FSC_SCRIPT_NAME%" /v "End" /t REG_SZ /d "%DATE% %NT%" /f >nul

IF Exist "%PSShutDownScr%" ( 
            %PSShutDownEx% 
) else (
            Shutdown -r -f -t %Timer% /c "%FSC-MSG01%"
)

Exit /b

:RunWinGet
SET "FSC_WINGET_CMD=%ProgramData%\Franksoft\Scripts\WinGetUpdate_FSC.cmd"

IF NOT EXIST "%FSC_WINGET_CMD%" (
    Echo.   * WinGetUpdate_FSC.cmd NOT found: %FSC_WINGET_CMD%>>%FSC_LOG%
    IF DEFINED FSC_LOG_UPD Echo.   * WinGetUpdate_FSC.cmd NOT found: %FSC_WINGET_CMD%>>%FSC_LOG_UPD%
    EXIT /B 1
)

Echo.   - Call WinGetUpdate_FSC.cmd
Echo.   - Call WinGetUpdate_FSC.cmd>>%FSC_LOG%
IF DEFINED FSC_LOG_UPD Echo.   - Call WinGetUpdate_FSC.cmd>>%FSC_LOG_UPD%

CALL "%FSC_WINGET_CMD%"
SET "FSC_WINGET_RC=%ERRORLEVEL%"

Echo.   - WinGetUpdate_FSC.cmd ReturnCode: %FSC_WINGET_RC%>>%FSC_LOG%
IF DEFINED FSC_LOG_UPD Echo.   - WinGetUpdate_FSC.cmd ReturnCode: %FSC_WINGET_RC%>>%FSC_LOG_UPD%

REM Mark as done only after the CMD was actually found and executed.
REG Add "%REG_WUPCOUNT%" /v WinGetDone /t REG_SZ /d "1" /f >NUL

REM Keep the known-good Chrome post-update start/kill sequence from FSC 2.0.
cmd /c start /min chrome
Timeout 4 >NUL
Taskkill /im Chrome.exe /f >NUL 2>NUL
cmd /c start /min chrome
Timeout 2 >NUL
Taskkill /im Chrome.exe /f >NUL 2>NUL

EXIT /B %FSC_WINGET_RC%

