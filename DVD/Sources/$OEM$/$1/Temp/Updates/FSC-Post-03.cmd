net start WSearch
cls

@echo off
@MODE CON: COLS=70 LINES=18
@Color 4f
PUSHD "%~dp0"

SET FSC_PHASE=04/06


:: =============================================================================
:: Script Name : FSC-Post-03.cmd
:: Path        : "D:\Sources\$OEM$\$1\Temp\Updates\FSC-Post-03.cmd"
:: Version     : 2.4
:: Date        : 14.06.2026
:: Author      : Franksoft
::
:: Purpose
:: -----------------------------------------------------------------------------
:: FSC Deployment Phase 04/06
::
:: - CleanUP
:: - Windows Update (Start) WinUpdate_FSC.cmd
:: - "C:\ProgramData\Franksoft\Scripts\WinUpdate_FSC.cmd"
::
:: Log
:: -----------------------------------------------------------------------------
:: %ProgramData%\Franksoft\Logs\Franksoft Client.txt"
:: =============================================================================

SET "NT=%TIME: =0%"
SET "NT=%NT:~0,8%"

set "FSC_REG=HKLM\SOFTWARE\Franksoft\Setup"
set "FSC_SCRIPT_NAME=%~nx0"
set "FSC_SCRIPT_PATH=%~f0"

reg add "%FSC_REG%\%FSC_SCRIPT_NAME%" /f >nul 2>nul

reg add "%FSC_REG%\%FSC_SCRIPT_NAME%" /v "Script Name" /t REG_SZ /d "%FSC_SCRIPT_NAME%" /f >nul
reg add "%FSC_REG%\%FSC_SCRIPT_NAME%" /v "Script Path" /t REG_SZ /d "%FSC_SCRIPT_PATH%" /f >nul
reg add "%FSC_REG%\%FSC_SCRIPT_NAME%" /v "FSC Phase" /t REG_SZ /d "%FSC_PHASE%" /f >nul
reg add "%FSC_REG%\%FSC_SCRIPT_NAME%" /v "Start" /t REG_SZ /d "%DATE% %NT%" /f >nul

set "WallPaper_Exe=%ProgramData%\Franksoft\Scripts\WallP.exe"
set "FSC_Wallpaper=%ProgramData%\Franksoft\Logos\FSC_DEP\FSPost_03.png"
if exist "%FSC_Wallpaper%" cmd /c start "" "%WallPaper_Exe%" "%FSC_Wallpaper%" CENTER"

SET "DesktopOK_VBS=%ProgramData%\Franksoft\Scripts\DesktopOK\DesktopOK_Start.vbs"
IF Exist "%DesktopOK_VBS%" "%DesktopOK_VBS%"

SET "_null=1>nul 2>nul"
SET "FSC-Tools-Local=%ProgramData%\Franksoft"
SET "FSC_Scripts_Local=%FSC-Tools-Local%\Scripts"

SET "FSC-LOG=%FSC-Tools-Local%\Logs\Franksoft Client.txt"
SET FSC-Counter-Start=04
SET FSC-Counter-End=04
SET "Status=Phase %FSC-Counter-Start%/%FSC-Counter-End%"

IF NOT Exist "%FSC-Tools-Local%\Logs" MD "%FSC-Tools-Local%\Logs"

:: Brightness 40% Hellikeit
Powershell (Get-WmiObject -Namespace root/WMI -Class WmiMonitorBrightnessMethods).WmiSetBrightness(1,40) %_null%

set "WallPaper_Exe=%ProgramData%\Franksoft\Scripts\WallP.exe"
set "FSC_Wallpaper=%ProgramData%\Franksoft\Logos\FSC_DEP\FSPost_03.png"
if exist "%FSC_Wallpaper%" cmd /c start "" "%WallPaper_Exe%" "%FSC_Wallpaper%" CENTER"

IF NOT Exist "%SystemDrive%\%~nx0_DBG" MD "%SystemDrive%\%~nx0_DBG"

@Echo.>>"%FSC-LOG%"
@Echo Franksoft Client ^| Software Deployment ^| %Status% ^| Start>>"%FSC-LOG%"
@Echo.>>"%FSC-LOG%"

EVENTCREATE /T INFORMATION /SO Franksoft /ID 007 /L APPLICATION /D "Franksoft Client | Software Deployment | %Status% | Script: %~nx0" >NUL 2>NUL

SET FSC-Post-05-Script=FSC_END.VBS
SET FSC-TITLE-LOG=Franksoft Client: Post-Deployment - Setup Phase: %Status% - Start

SET FSC-TITLE-01=Franksoft Client: Post-Deployment - Please wait...  - Script: %~nx0
SET FSC-TITLE-02=Franksoft Client: Post-Deployment Start - Script: %~nx0

SET FSC-Tools-Local=%ProgramData%\Franksoft
SET FSC-Scripts-Local=%FSC-Tools-Local%\Scripts


Openfiles %_null%
IF %ErrorLevel% equ 0 (Set Admin-Status=Yes) else (Set Admin-Status=No) %_null%

:: GET Windows Setup USB Drive letter
@REM for %%i in (B D E F G H I J K L M N O P Q R S T U V W X Y Z) do @IF Exist %%i:\Sources\setup.exe set USB-Stick-Path=%%i:
for %%i in (
    B D E F G H I J K L M N O P Q R S T U V W X Y Z
) do (
    if exist %%i:\Sources\setup.exe (
        set "USB-Stick-Path=%%i:"
    )
)

:: Add Windows 11 ProductName
REG ADD "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v ProductName /t REG_SZ /d "Windows 11 Pro" /f >NUL

SET FSC-Scripts-USB=%USB-Stick-Path%\sources\$OEM$\$1\ProgramData\Franksoft\Scripts

@Color 4f

TITLE %FSC-TITLE-02%

echo. 
echo. 
echo.    Franksoft Client: Post-Deployment - Please wait...
echo. 

:: Warte auf explorer.exe UND dass der Desktop geladen ist

:WAIT_EXPLORER
:: Pr fen, ob explorer.exe l uft
tasklist /FI "IMAGENAME eq explorer.exe" | find /I "explorer.exe" >nul
if errorlevel 1 (
    timeout /t 1 >nul
    goto WAIT_EXPLORER
)

:WAIT_DESKTOP
:: Pr fen, ob der Explorer ein Fenster (Desktop) hat
powershell -command ^
    "$e = Get-Process explorer -ErrorAction SilentlyContinue; if ($e -and $e.MainWindowHandle -ne 0) { exit 0 } else { exit 1 }"
if errorlevel 1 (
    timeout /t 1 >nul
    goto WAIT_DESKTOP
)

IF Exist "%DesktopOK_VBS%" "%DesktopOK_VBS%"
@Timeout 3 >NUL

@Color 4f

SET "NT=%TIME: =0%"
SET "NT=%NT:~0,8%"

SET FSC_Scripts_USB=%USB-Stick-Path%\sources\$OEM$\$1\ProgramData\Franksoft\Scripts

SET TaskBandFolder=%AppData%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar

Openfiles %_null%
IF %ErrorLevel% equ 0 (Set Admin-Status=Yes) else (Set Admin-Status=No) >NUL

powercfg -change -monitor-timeout-ac 10 >NUL
powercfg -change -monitor-timeout-dc 5 >NUL

powercfg -change -disk-timeout-ac 22 >NUL
powercfg -change -disk-timeout-dc 11 >NUL

powercfg -change -standby-timeout-ac 20 >NUL
powercfg -change -standby-timeout-dc 15 >NUL

:: Get Windows Product Name (Home,Pro,Ent)
:: RegVal: Windows 10 Pro
SET RK=HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion
for /f "tokens=3*" %%a in ('reg query "%RK%" /V "ProductName" ^|findstr /ri "REG_SZ"') do Set FullProductName=%%a %%b
SET RK=

:: 2023
:: Get Edition Product Name (Professional,Home,Enterprise)
:: RegVal: Professional
SET RK=HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion
for /f "tokens=3*" %%a in ('reg query "%RK%" /V "EditionID" ^|findstr /ri "REG_SZ"') do Set EditionLong=%%a %%b
SET RK=

:: Get Windows Build or Version (1809,1903,2004,21h2,22h2)
:: RegVal: 21H2
SET RK=HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion
:: for /f "tokens=3" %%a in ('reg query "%RK%"  /V "DisplayVersion" ^|findstr /ri "REG_SZ"') do Set OSVER=%%a
for /f "tokens=3" %%a in ('reg query "%RK%"  /V "DisplayVersion" ^|findstr /ri "REG_SZ"') do Set OSVER=%%a
SET RK=

::: GET Current Windows PowerPlan
rem Aktives Energieschema auslesen und Namen extrahieren
for /f "tokens=*" %%i in ('powercfg /getactivescheme') do (
    for /f "tokens=2 delims=()" %%a in ("%%i") do set "CurrentPowerScheme=%%a"
)

:: >>> Sleep wait for Windows Shell
@Color 4f
@REM @TimeOut 14
@MODE CON: COLS=70 LINES=15
CLS
@Color 1e

Title %FSC-TITLE-02%

@Echo.
@echo.  %FSC-TITLE-02%
@Echo. 

@Echo. - Phase ID:       %Status% (Start)      >>"%FSC-LOG%"
@Echo. - Timestamp:      %Date% %NT%           >>"%FSC-LOG%"
@Echo. - User:           %UserName%            >>"%FSC-LOG%"
@echo. - IsAdmin:        %Admin-Status%        >>"%FSC-LOG%"
@Echo. - Power Profile:  %CurrentPowerScheme%  >>"%FSC-LOG%"
@Echo. - Script Path:    %~dp0%~nx0            >>"%FSC-LOG%"
@Echo. >>"%FSC-LOG%"


@Echo. - System: Disable User Experiences and Telemetry
@Echo. - System: Disable User Experiences and Telemetry>>"%FSC-LOG%"

sc config DiagTrack start= disabled %_null%
sc config dmwappushservice start= disabled %_null%
sc stop DiagTrack %_null%
sc stop dmwappushservice %_null%

reg add HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection\ /v AllowTelemetry /t REG_DWORD /d 0 /f %_null%
reg add HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection\ /v DoNotShowFeedbackNotIFications /t REG_DWORD /d 1 /f %_null%
:::--<< ::::: **** Do not enable, Windows SETUP Crash since 1809 ******

:: Delete Defender Policy
REG delete "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\NotIFications" /f %_null%

DEL /F/Q "%SYSTEMROOT%\System32\oobe\info\backgrounds\DefBkInfo.txt" %_null%

:: Delete Franksoft Support Folder in STM
SET Folder2REM="%ProgramData%\Microsoft\Windows\Start Menu\Programs\Support"
IF Exist %Folder2REM% RD %Folder2REM% /S/Q %_null%

@REM :::: Copy FS Team Viewer QS Remote Support
@REM SET FS-TVQS=%USB-Stick-Path%\Runtimes\Install\TeamViewer\fss.EXE
@REM SET TVQSUPD=%USB-Stick-Path%\Runtimes\Install\TeamViewer\TeamViewerQS_de_FSCUPD.exe

@REM IF Exist "%FS-TVQS%" (
@REM 	@Echo. - Update: TeamViewer Quick Support
@REM 	@Echo. - Update: TeamViewer Quick Support>>"%FSC-LOG%"
@REM 	"%FS-TVQS%"
@REM 	IF Exist "%TVQSUPD%" Copy /Y "%TVQSUPD%" "%FSC-Tools-Local%\Support\TeamViewerQS_de.exe" %_null%
@REM ) else (
@REM 	@Echo. * TeamViewer Quick Support NOT Updated
@REM 	@Echo. * TeamViewer Quick Support NOT Updated>>"%FSC-LOG%"
@REM )

SET "NT=%TIME: =0%"
SET "NT=%NT:~0,8%"

::: DEBUG not Working
SET FSC-Shortcuts-USB=%USB-Stick-Path%\sources\$OEM$\$1\ProgramData\Franksoft\Shortcuts
SET FileExplorer-LNK-USB=%FSC-Shortcuts-USB%\File Explorer.lnk
SET TaskBandFolder=%AppData%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar

@REM :: Windows Explorer Ico 
@REM @Attrib -r -s -h "%TaskBandFolder%\*.*" %_null%
@REM IF Exist "%FileExplorer-LNK-USB%" (
@REM     Copy "%FileExplorer-LNK-USB%" "%TaskBandFolder%" /y %_null%
@REM )

:: TaskBar Shortcuts

SET "TBAND=%ProgramData%\Franksoft\Scripts\TaskBar\Taskband.reg"
SET "TLNK=%ProgramData%\Franksoft\Scripts\TaskBar\Taskband.exe"

IF Exist "%TLNK%" "%TLNK%"
IF Exist "%TBAND%" regedit /s "%TBAND%"

:: SET FSC-MSG=Franksoft Client: %Status% %0

Attrib -r -s "%FSC-Tools-Local%\*.*" /S /D %_null%
Attrib -r -s "%PUBLIC%\Desktop\*.*" /S /D %_null%
Attrib -r -s "%AppData%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\*.*" /S /D %_null%

IF Exist "%FSC-Tools-Local%\Apps\A" rd /S/q "%FSC-Tools-Local%\Apps\A"
IF Exist "%FSC-Scripts-Local%\A" rd /S/q "%FSC-Scripts-Local%\A"

:: Copy JumpList (Franksoft mod)
SET "FPATH=%AppData%\Microsoft\Windows\Recent\AutomaticDestinations"
SET "FILE2COPY=%FSC-Scripts-Local%\f01b4d95cf55d32a.automaticDestinations-ms"

IF Exist "%FILE2COPY%" (
    @Echo. - Windows Explorer: Copy JumpList "Franksoft mod">>"%FSC-LOG%"
    Copy /Y "%FILE2COPY%" "%FPATH%" %_null%
) ELSE (
        @Echo. * NOT found Windows Explorer: "%FILE2COPY%">>"%FSC-LOG%"
)

@SET FPATH=
@SET FILE2COPY=


SET DVD-Drive-Script=%USB-Stick-Path%\sources\$OEM$\$$\Setup\Scripts\ChangeCDRomDriveLetter.ps1

IF EXIST "%DVD-Drive-Script%" IF EXIST Z: (
    @Echo. - Execute DVD-Drive Change letter Script
    @Echo. - Execute DVD-Drive Change letter Script >>"%FSC-LOG%"
    Copy /y "%DVD-Drive-Script%" "%TEMP%" %_null%
    PowerShell -EP ByPass -NoLogo -WindowStyle Hidden -File "%TEMP%\ChangeCDRomDriveLetter.ps1" %_null%
) ELSE (
    @Echo. + NO CD or DVD Drive found
    @Echo. + NO CD or DVD Drive found>>"%FSC-LOG%"
)

IF Exist Z: (
    @Echo. - DVD Drive letter is Z:\>>"%FSC-LOG%"
)

@schtasks /Delete /TN "UnlockStartLayout" /F %_null%
@schtasks /Delete /TN "ShowAllTrayIcons" /F %_null%

@Echo. - Logging: Deployment State
@Echo. - Logging: Deployment State>>"%FSC-LOG%"

SET "Status=Phase %FSC-Counter-Start%/%FSC-Counter-End%"
SET "FSC-Status-LOG=%CounterStart%/%CounterEnd%"


@Echo. - Power Plan: Change to "Ausbalanciert"
@Echo. - Power Plan: Change to "Ausbalanciert">>"%FSC-LOG%"
Powercfg -setactive 381b4222-f694-41f0-9685-ff5bb260df2e %_null%

powercfg -change -monitor-timeout-ac 15 >NUL
powercfg -change -monitor-timeout-dc 10 >NUL

powercfg -change -disk-timeout-ac 15 >NUL
powercfg -change -disk-timeout-dc 10 >NUL

powercfg /change standby-timeout-ac 20 >NUL
powercfg /change standby-timeout-dc 15 >NUL

:: Hibernate CFG
powercfg -change -hibernate-timeout-ac 45 >NUL
powercfg -change -hibernate-timeout-dc 30 >NUL

::---Do not MOVE!!!
SET CounterS=%CounterStart%/%CounterEnd%
SET REGKEY-RunOnce=HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce
SET FSC_Script_P3_WinUPD=%FSC_Scripts_Local%\WinUpd-Task.cmd
SET FSC_Windows_Update_Task_MSG=FSC: Create scheduled task Franksoft Windows Update
SET DesktopOK=%ProgramData%\Franksoft\Scripts\DesktopOK\DesktopOK_Start.vbs

:: Add Final FSC Scripts
SET Audio_SCR=%FSC_Scripts_Local%\PlayAudio.vbs
SET FSC-ENDMSG_VBS=%FSC_Scripts_Local%\FSC-Complete.VBS

:: Start Windows Update Script after FSC End
IF EXIST "%USB-Stick-Path%\WinUpd_1.txt" (
    SET "WINUPD2=1"
) ELSE (
    SET "WINUPD2=0"
    @echo. - Windows: Enable Windows System Restore
    @echo. - Windows: Enable Windows System Restore >> %FSC-LOG%
    start "" /min powershell -NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -Command "Enable-ComputerRestore -Drive 'C:\'" %_null%
)


IF "%WINUPD2%"=="1" (
    @Echo. - %FSC_Windows_Update_Task_MSG%
    @Echo. + Franksoft: Windows Update: Activated>>"%FSC-LOG%"
    @Echo. - %FSC_Windows_Update_Task_MSG%>>"%FSC-LOG%"
    @REG ADD "%REGKEY-RunOnce%" /v FSC_WindowsUpdate_Script /d "%FSC_Script_P3_WinUPD%" /f %_null%
) ELSE (
    @Echo. * Franksoft: Windows Update: NOT Activated>>"%FSC-LOG%"

    IF EXIST "%Audio_SCR%" (
        REG ADD "%REGKEY-RunOnce%" /v 01-FSC_END_Sound /d "%Audio_SCR%" /f >NUL
    )
    IF EXIST "%DesktopOK%" (
        REG ADD "%REGKEY-RunOnce%" /v 02-DesktopOK /d "%DesktopOK%" /f >NUL
    )

    REG ADD "%REGKEY-RunOnce%" /v 03-FSC_END_CleanMgr /d "cleanmgr /sagerun:65535" /f >NUL

    IF EXIST "%FSC-ENDMSG_VBS%" (
        REG ADD "%REGKEY-RunOnce%" /v 04-FSC_END_MSG /d "%FSC-ENDMSG_VBS%" /f >NUL
    )
)

SET NT=
SET "NT=%TIME: =0%"
SET "NT=%NT:~0,8%"

:: Do not move 
SET Status=Phase %FSC-Counter-Start%/%FSC-Counter-End%

EVENTCREATE /T INFORMATION /SO Franksoft /ID 007 /L APPLICATION /D "Franksoft Client | Software Deployment | %Status% | Script: %~nx0" >NUL 2>NUL

Color 2F

@Echo.>>"%FSC-LOG%"

@Echo. - Reboot in 15sec...
@Echo. - System: Reboot Initiated>>"%FSC-LOG%"

::: GET Current Windows PowerPlan
for /f "tokens=*" %%i in ('powercfg /getactivescheme') do (
    for /f "tokens=2 delims=()" %%a in ("%%i") do set "CurrentPowerScheme=%%a"
)

SET NT=
SET "NT=%TIME: =0%"
SET "NT=%NT:~0,8%"

@Echo.>>"%FSC-LOG%"

@Echo. - Phase ID:       %Status% (End)        >>"%FSC-LOG%"
@Echo. - Timestamp:      %Date% %NT%           >>"%FSC-LOG%"
@Echo. - User:           %UserName%            >>"%FSC-LOG%"
@echo. - IsAdmin:        %Admin-Status%        >>"%FSC-LOG%"
@Echo. - Power Profile:  %CurrentPowerScheme%  >>"%FSC-LOG%"
@Echo. - Script Path:    %~dp0%~nx0            >>"%FSC-LOG%"
@Echo. >>"%FSC-LOG%"

@Echo Franksoft Client ^| Software Deployment ^| %Status% ^| Completed>>"%FSC-LOG%"
@Echo.>>"%FSC-LOG%"
@Echo ************************************************************************************* >>"%FSC-LOG%"


:: FSC LOGGING
SET FSC-LOG-PE=%USB-Stick-Path%\Sources\$OEM$\$1\Temp\WinPE\Windows Setup Log_%DATE%.log
SET FSC-LOG-PE-MSG=Franksoft Client:  - %NT% - Phase 07/07 Franksoft Post-Deployment - Completed successfully
IF EXIST "%USB-Stick-Path%\Sources\$OEM$\$1\Temp\WinPE\PE-LogFile.cmd" (
    @echo. %FSC-LOG-PE-MSG%>>"%FSC-LOG-PE%"
    @echo. >>"%FSC-LOG-PE%"
    @echo.*** Franksoft Windows Setup Script: %~nx0 Logging END ***>>"%FSC-LOG-PE%"
)

SET "FN=%Public%\Desktop\FS-Driver-Inst.txt"
IF exist "%FN%" (
    copy /Y "%FN%" "%FSC-Tools-Local%\Logs"
    copy /Y "%FSC-Tools-Local%\Logs\FS-Driver-Inst.lnk" %PUBLIC%\Desktop >NUL
    Del /F/Q "%FN%" 1>nul 2>nul
)
SET FN=

SET "FSC-REG-Path=HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
SET "FSC-EnableUAC=%FSC_Scripts_Local%\EnableUAC.reg"

::: *** Do Not Move *** :::
:: ========================= Windows Update OFF =================================


:: Add RunOnce Final FSC Scripts
SET "REGKEY-RunOnce=HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce"
SET "FSC-END-02=%FSC-Scripts-Local%\%FSC-Post-05-Script%"

If Exist "%DesktopOK_VBS%" (
    REG ADD "%REGKEY-RunOnce%" /v 01-FSC-DesktopOK /d "cmd /c %DesktopOK_VBS%" /f >NUL
)

If "%WINUPD2%"=="0" If Exist "%FSC-END-02%" (
    REG ADD "%REGKEY-RunOnce%" /v 02-FSC_END_CleanMgr /d "cleanmgr /sagerun:65535" /f >NUL
    REG ADD "%REGKEY-RunOnce%" /v 03-FSC-END-MSG /d "%FSC-END-02%" /f >NUL
)

IF "%WINUPD2%"=="0" IF Exist "%FSC-EnableUAC%" (
    Regedit /s "%FSC-EnableUAC%"
    REG ADD "%FSC-REG-Path%" /v EnableLUA /t REG_DWORD /d 1 /f 1>NUL 2>NUL
)
If Exist "%DesktopOK_VBS%" (
    REG ADD "%REGKEY-RunOnce%" /v 99-FSC-DesktopOK /d "cmd /c %DesktopOK_VBS%" /f >NUL
)


:: SET Last Wallpaper
SET WallP_exe=%FSC-Scripts-Local%\WallP.exe
SET WallPaper=%SystemRoot%\Web\4K\Wallpaper\Windows\FSC_Final_W11_01.jpg
IF EXIST "%WallP_exe%" IF EXIST "%WallPaper%" (
    "%WallP_exe%" "%WallPaper%" CENTER
)

SET FSC-Folder2Del=%ProgramData%\Microsoft\Windows\Start Menu\Programs\Support
If Exist "%FSC-Folder2Del%" RD /S/Q "%FSC-Folder2Del%" 1>nul 2>nul
SET FSC-Folder2Del=

@REG Delete "HKCU\Control Panel\International\User Profile\fr-CH" /f 1>nul 2>nul

SET FSC-REG-Path=HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Systray
@REG Delete "%FSC-REG-Path%" /f 1>nul 2>nul
SET FSC-REG-Path=

DEL /F/Q "%SystemRoot%\Panther\*.xml" %_null%
RD /S/Q "%SystemRoot%\Panther\FastCleanup" %_null%
RD /S/Q "%SystemRoot%\Panther\setup.exe" %_null%

:: DELETE FSC DEP Logon Picture
SET "CSP=HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP"
SET "POL=HKLM\SOFTWARE\Policies\Microsoft\Windows\System"

REG delete "%CSP%" /v LockScreenImagePath /f %_null%
REG delete "%CSP%" /v LockScreenImageUrl /f %_null%
REG delete "%CSP%" /v LockScreenImageStatus /f %_null%

REG delete "%POL%" /v DisableLogonBackgroundImage /f %_null%

IF Exist "%SystemDrive%\%~nx0_DBG" RD /S/Q "%SystemDrive%\%~nx0_DBG"

:: FSC HKLM time logging
:: + 15 Sec 
for /f "tokens=*" %%i in ('powershell -NoProfile -Command "$t=[TimeSpan]::Parse('%NT%'); $n=$t.Add([TimeSpan]::FromSeconds(15)); $n.ToString('hh\:mm\:ss')"') do set "NT=%%i"
REG Add "%FSC_REG%\%FSC_SCRIPT_NAME%" /v "End" /t REG_SZ /d "%DATE% %NT%" /f >nul

:: Delete Theme cache
REG delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Wallpapers" /f %_null%
RD /s /q "%AppData%\Microsoft\Windows\Themes\CachedFiles" %_null%
DEL /f /q "%AppData%\Microsoft\Windows\Themes\TranscodedWallpaper" %_null%

:: Shutdown t-15
SET FSC_Shutdown_Ps1=%ProgramData%\Franksoft\Scripts\FS-Shutdown.ps1
SET FS-Shutdown-Syntax=Start "" /min Powershell.exe -EP ByPass -NoLogo -NonInteractive -NoProfile -WindowStyle Hidden -File "%FSC_Shutdown_Ps1%"

:: Brightness 40% Hellikeit
Powershell (Get-WmiObject -Namespace root/WMI -Class WmiMonitorBrightnessMethods).WmiSetBrightness(1,40) %_null%


IF Exist "%DesktopOK_VBS%" "%DesktopOK_VBS%"

:: TaskBar Shortcuts

SET "TBAND=%ProgramData%\Franksoft\Scripts\TaskBar\Taskband.reg"
SET "TLNK=%ProgramData%\Franksoft\Scripts\TaskBar\Taskband.exe"

IF Exist "%TLNK%" "%TLNK%"
IF Exist "%TBAND%" regedit /s "%TBAND%"


IF Exist "%FSC_Shutdown_Ps1%" (
	%FS-Shutdown-Syntax%
) ELSE (
    MD "%PUBLIC%\Desktop\NOT-FOUND_FS-Shutdown.ps1" >NUL
   	IF Not Exist "%PUBLIC%\Desktop\%~nx0_Error" MD "%PUBLIC%\Desktop\%~nx0_Error"
)

EXIT

:: Name And Extension ONLY of %0      %~nx0