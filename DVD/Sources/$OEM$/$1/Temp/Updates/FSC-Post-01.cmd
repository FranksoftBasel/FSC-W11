net start WSearch
cls

@Echo off

TITLE Franksoft Client: Post-Deployment - Please wait... Script: %~nx0

@MODE CON: COLS=70 LINES=25
@Color 4f
Pushd %~dp0
SET "_null=1>nul 2>nul"
SET FSC_PHASE=02/06


@REM :: Minimize CMD
if not "%1"=="7" start /min cmd /c ""%~0" 7 %*" & exit /b


SET FSC-Counter-Start=02
SET FSC-Counter-End=04
SET Status=Phase %FSC-Counter-Start%/%FSC-Counter-End%

SET FSC-Tools-Local=%ProgramData%\Franksoft
SET FSC-Scripts-Local=%FSC-Tools-Local%\Scripts
IF NOT Exist "%FSC-Tools-Local%\Logs" MD "%FSC-Tools-Local%\Logs"
SET FSC-LOG="%FSC-Tools-Local%\Logs\Franksoft Client.txt"

REG Add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /d 0 /f %_null%
IF Exist "%FSC-Scripts-Local%\FS\FST_HKCU.reg" Regedit /s "%FSC-Scripts-Local%\FS\FST_HKCU.reg"

SET "DesktopOK_VBS=%ProgramData%\Franksoft\Scripts\DesktopOK\DesktopOK_Start.vbs"
IF Exist "%DesktopOK_VBS%" "%DesktopOK_VBS%"


:: =============================================================================
:: Script Name : FSC-Post-01.cmd
:: Path        : "D:\Sources\$OEM$\$1\Temp\Updates\FSC-Post-01.cmd"
:: Version     : 2.4
:: Date        : 14.06.2026
:: Author      : Franksoft
::
:: Purpose
:: -----------------------------------------------------------------------------
:: FSC Deployment Phase 02/06
::
:: - FSC Config
:: - FSC Software Deployment
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

REG Add "%FSC_REG%\%FSC_SCRIPT_NAME%" /f %_null%
REG Add "%FSC_REG%\%FSC_SCRIPT_NAME%" /v "Script Name" /t REG_SZ /d "%FSC_SCRIPT_NAME%" /f %_null%
REG Add "%FSC_REG%\%FSC_SCRIPT_NAME%" /v "Script Path" /t REG_SZ /d "%FSC_SCRIPT_PATH%" /f %_null%
REG Add "%FSC_REG%\%FSC_SCRIPT_NAME%" /v "FSC Phase" /t REG_SZ /d "%FSC_PHASE%" /f %_null%
REG Add "%FSC_REG%\%FSC_SCRIPT_NAME%" /v "Start" /t REG_SZ /d "%DATE% %NT%" /f %_null%


IF Not Exist "%SystemDrive%\%~nx0_DBG" MD "%SystemDrive%\%~nx0_DBG"
:: IF Exist "%FSC-Scripts-Local%\HideDesktopIcons.exe" "%FSC-Scripts-Local%\HideDesktopIcons.exe"

set "WallPaper_Exe=%FSC-Tools-Local%\Scripts\WallP.exe"
set "FSC_Wallpaper=%FSC-Tools-Local%\Logos\FSC_DEP\FSPost_01.png"
if exist "%FSC_Wallpaper%" cmd /c start "" "%WallPaper_Exe%" "%FSC_Wallpaper%" CENTER"

SET "EDGE_LNK_PD=%PUBLIC%\Desktop\Microsoft Edge.lnk"
SET "EDGE_LNK_CU=%USERPROFILE%\Desktop\Microsoft Edge.lnk"

IF EXIST "%EDGE_LNK_PD%" DEL /F /Q "%EDGE_LNK_PD%" %_null%
IF EXIST "%EDGE_LNK_CU%" DEL /F /Q "%EDGE_LNK_CU%" %_null%

:: Brightness 40% Hellikeit
Powershell (Get-WmiObject -Namespace root/WMI -Class WmiMonitorBrightnessMethods).WmiSetBrightness(1,40) %_null%
REG Add "HKCU\Control Panel\Colors" /v Background /t REG_SZ /d "0 0 0" /f %_null%

set "USB_Stick_Path="
for %%i in (B D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    if exist "%%i:\Sources\setup.exe" (
        set "USB_Stick_Path=%%i:"
        goto :FoundUSB
    )
)

:FoundUSB
if not defined USB_Stick_Path (
    Color 4F
	echo. Kein Windows-Installationsmedium gefunden
	Pause
)


@Echo Franksoft Client ^| Software Deployment ^| %Status% ^| Start>>%FSC-LOG%
@Echo.>>%FSC-LOG%

EVENTCREATE /T INFORMATION /SO Franksoft /ID 007 /L APPLICATION /D "Franksoft Client | Software Deployment | %Status% | Script: %~nx0" >NUL 2>NUL

SET FSC-Post-02-Script=FSC-Post-02.cmd
SET FSC-TITLE-01=Franksoft Client: Post-Deployment - Please wait...  - Script: %~nx0
SET FSC-TITLE-02=Franksoft Client: Post-Deployment Start - Script: %~nx0

SET "NT=%TIME: =0%"
SET "NT=%NT:~0,8%"

SET "REGKEY-RunOnce=HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce"
SET "FSC-LOG-PE=%USB_Stick_Path%\Sources\$OEM$\$1\Temp\WinPE\Windows Setup Log_%DATE%.log"
SET "FSC-LOG-PE-MSG=Franksoft Client:  - %NT% - Phase %FSC_PHASE% Franksoft Post-Deployment - Start"
IF EXIST "%USB_Stick_Path%\Sources\$OEM$\$1\Temp\WinPE\PE-LogFile.cmd" (
    @echo. %FSC-LOG-PE-MSG%>>"%FSC-LOG-PE%"
)

net session %_null%
IF %ErrorLevel% equ 0 (Set Admin-Status=Yes) else (Set Admin-Status=No) %_null%

SET "FSC-Scripts-USB=%USB_Stick_Path%\sources\$OEM$\$1\ProgramData\Franksoft\Scripts"

IF Exist "%FSC-Scripts-Local%\WinKey.exe" "%FSC-Scripts-Local%\WinKey.exe"

:: TaskBar Shortcuts

SET "TBAND=%ProgramData%\Franksoft\Scripts\TaskBar\Taskband.reg"
SET "TLNK=%ProgramData%\Franksoft\Scripts\TaskBar\Taskband.exe"

IF Exist "%TLNK%" "%TLNK%"
IF Exist "%TBAND%" regedit /s "%TBAND%"

@Color 4f

TITLE %FSC-TITLE-02%

echo. 
echo. 
echo.    Franksoft Client: Post-Deployment - Please wait...
echo. 

@taskkill /im powershell.exe /f %_null%

:: Warte auf explorer.exe UND dass der Desktop geladen ist

:WAIT_EXPLORER
:: Prüfen, ob explorer.exe läuft
tasklist /FI "IMAGENAME eq explorer.exe" | find /I "explorer.exe" %_null%
if errorlevel 1 (
    timeout /t 1 >nul
    goto WAIT_EXPLORER
)

:WAIT_DESKTOP
:: Prüfen, ob der Explorer ein Fenster (Desktop) hat
powershell -command ^
    "$e = Get-Process explorer -ErrorAction SilentlyContinue; if ($e -and $e.MainWindowHandle -ne 0) { exit 0 } else { exit 1 }"
if errorlevel 1 (
    timeout /t 1 >nul
    goto WAIT_DESKTOP
)

IF Exist "%DesktopOK_VBS%" "%DesktopOK_VBS%"
@Timeout 3
IF Exist "%DesktopOK_VBS%" "%DesktopOK_VBS%"

@Color 4f

REG delete "HKCU\Control Panel\International\User Profile\fr-CH" /f %_null%

SET "FILE2DEL_DT_INI=%UserProfile%\Desktop\desktop.ini"
@attrib -r -s -h "%FILE2DEL_DT_INI%" %_null%
IF Exist "%FILE2DEL_DT_INI%" del "%FILE2DEL_DT_INI%" /F/Q %_null%

SET "FILE2DEL_DT_INI=%Public%\Desktop\desktop.ini"
@attrib -r -s -h "%FILE2DEL_DT_INI%" %_null%
IF Exist "%FILE2DEL_DT_INI%" del "%FILE2DEL_DT_INI%" /F/Q %_null%
SET FILE2DEL_DT_INI=

:: Add Sysinternals Eula
REG Add "HKCU\SOFTWARE\Sysinternals\Autologon" /v EulaAccepted /t REG_DWORD /d 1 /f %_null%
REG Add "HKCU\SOFTWARE\Sysinternals\PsExec" /v EulaAccepted /t REG_DWORD /d 1 /f %_null%

@Color 4f

:::::::::: ----- SET Needed Variables ----- ::::::::::

:: Get Windows Product Name (Windows 11 Home,Pro,Ent)
:: Windows 11 Pro
SET RK=HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion
for /f "tokens=3*" %%a in ('reg query "%RK%" /V "ProductName" ^|findstr /ri "REG_SZ"') do Set FullProductName=%%a %%b
SET RK=

:: Get Edition Product Name (Professional,Home,Enterprise)
:: Professional
SET RK=HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion
for /f "tokens=3*" %%a in ('reg query "%RK%" /V "EditionID" ^|findstr /ri "REG_SZ"') do Set EditionLong=%%a %%b
SET RK=

:: Get Windows Build or Version (1809,1903,2004,21h2,22h2)
:: 21H2
SET RK=HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion
:: for /f "tokens=3" %%a in ('reg query "%RK%"  /V "DisplayVersion" ^|findstr /ri "REG_SZ"') do Set OSVER=%%a
for /f "tokens=3" %%a in ('reg query "%RK%"  /V "DisplayVersion" ^|findstr /ri "REG_SZ"') do Set OSVER=%%a
SET RK=

:::::::::: ----- END: SET Needed Variables ----- ::::::::::

::: GET Current Windows PowerPlan
rem Aktives Energieschema auslesen und Namen extrahieren
for /f "tokens=*" %%i in ('powercfg /getactivescheme') do (
    for /f "tokens=2 delims=()" %%a in ("%%i") do set "CurrentPowerScheme=%%a"
)

SET FILE2DEL_DT_INI="%UserProfile%\Desktop\desktop.ini"
Attrib -r -s -h %FILE2DEL_DT_INI% %_null%
IF Exist %FILE2DEL_DT_INI% Del %FILE2DEL_DT_INI% /F/Q %_null%
SET FILE2DEL_DT_INI=

SET FILE="%Public%\Desktop\desktop.ini"
Attrib -r -s -h %FILE2DEL_DT_INI% %_null%
IF Exist %FILE2DEL_DT_INI% Del %FILE2DEL_DT_INI% /F/Q %_null%
SET FILE2DEL_DT_INI=

:: Add Windows 11 ProductName
REG Add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v ProductName /t REG_SZ /d "Windows 11 Pro" /f

SET "NT=%TIME: =0%"
SET "NT=%NT:~0,8%"

CLS
@Color 1e

Title %FSC-TITLE-02%

@Echo.
@Echo.   %FSC-TITLE-02%
@Echo. 

@Echo. - Phase ID:       %Status% (Start)      >>%FSC-LOG%
@Echo. - Timestamp:      %Date% %NT%           >>%FSC-LOG%
@Echo. - User:           %UserName%            >>%FSC-LOG%
@echo. - IsAdmin:        %Admin-Status%        >>%FSC-LOG%
@Echo. - Power Profile:  %CurrentPowerScheme%  >>%FSC-LOG%
@Echo. - Script Path:    %~dp0%~nx0            >>%FSC-LOG%
@Echo. >>%FSC-LOG%


@Echo. - Logging: Deployment State>>%FSC-LOG%

:: Set Windows Sound Volume to 33%
Set VolApp1=%FSC-Tools-Local%\Scripts\SetVol.vbs
If Exist "%VolApp1%" (
		@Echo. - Audio Volume: Set Muted
		@Echo. - Audio Volume: Set Muted>>%FSC-LOG%
		Start "" "%VolApp1%"
) else (
		@Echo. * Audio Volume: NOT found %VolApp1%
		@Echo. * Audio Volume: NOT found %VolApp1%>>%FSC-LOG%
)

SET NotepadCFG_Source=%ProgramData%\Franksoft\UWP\Notepad\Notepad-CFG.exe
SET NotepadCFG_Dest=%LocalAppData%\Packages\Microsoft.WindowsNotepad_8wekyb3d8bbwe\Settings

IF EXIST "%NotepadCFG_Source%" (
    @echo. - Config: Windows Notepad default settings
    @echo. - Config: Windows Notepad default settings >> %FSC-LOG%
    cmd /c start "" /min notepad
	timeout 3 >NUL
	taskkill /im notepad.exe /f %_null%
	taskkill /im notepad.exe /f %_null%
	"%NotepadCFG_Source%"
) ELSE (
    @echo. * ERROR: Notepad config not found %NotepadCFG_Source%
    @echo. * ERROR: Notepad config not found %NotepadCFG_Source%>>%FSC-LOG%
)

SET MSSnipCFG_Source=%ProgramData%\Franksoft\UWP\ScreenSketch\SnippingCfg.exe

IF EXIST "%MSSnipCFG_Source%" (
    @echo. - Config: Windows Snipping tool
    @echo. - Config: Windows Snipping tool>>%FSC-LOG%
	taskkill /im SnippingTool.exe /f %_null%
	taskkill /im SnippingTool.exe /f %_null%
	"%MSSnipCFG_Source%"
) ELSE (
    @echo. * ERROR: MSSnip config not found %MSSnipCFG_Source%
    @echo. * ERROR: MSSnip config not found %MSSnipCFG_Source%>>%FSC-LOG%
)

SET "Intel_GFX_CFG_Source=%ProgramData%\Franksoft\UWP\Intel\Video\Intel-GFX-UserSettings.exe"
SET "Intel_GFX_CFG_Dest=%LocalAppData%\Intel\IntelGraphicsSoftware\UserSettings"

IF EXIST "%Intel_GFX_CFG_Source%" (
    @echo. - Config: Intel Graphics user settings >> %FSC-LOG%
    @attrib -s -r -h "%Intel_GFX_CFG_Dest%\*.*" /S /D %_null%
    @rd /s /q "%Intel_GFX_CFG_Dest%" %_null%
    @md "%Intel_GFX_CFG_Dest%" %_null%
    "%Intel_GFX_CFG_Source%"
) ELSE (
    @echo. * ERROR: Intel Graphics settings not found - "%Intel_GFX_CFG_Source%" >> %FSC-LOG%
)

@echo. - Windows: Disable Windows System Restore
@echo. - Windows: Disable Windows System Restore >> %FSC-LOG%

:: powershell -NoProfile -ExecutionPolicy Bypass -Command "Disable-ComputerRestore -Drive 'C:\'" %_null%
start "" /min powershell -NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -Command "Disable-ComputerRestore -Drive 'C:\'" %_null%
vssadmin delete shadows /all /quiet %_null%

:: FSC Settings HKCU/HKLM
SET MSG=Registry: Apply HKLM Franksoft Settings
SET REGFile=%FSC-Scripts-Local%\FS\FST_HKLM.REG

IF Exist "%REGFile%" (
	@Echo. - %MSG%
	@Echo. - %MSG%>>%FSC-LOG%
	Regedit /s "%REGFile%" %_null%
) ELSE (
	@Echo. * Registry: NOT found %MSG% "%REGFile%"
	@Echo. * Registry: NOT found %MSG% "%REGFile%">>%FSC-LOG%
)
SET MSG=
SET REGFile=

SET REGFile=%FSC-Scripts-Local%\FS\FST_HKCU.REG
SET MSG=Registry: Apply HKCU Franksoft Settings

IF Exist "%REGFile%" (
	@Echo. - %MSG%
	@Echo. - %MSG%>>%FSC-LOG%
	Regedit /s "%REGFile%" %_null%
) ELSE (
	@Echo. * Registry: NOT found %MSG% "%REGFile%"
	@Echo. * Registry: NOT found %MSG% "%REGFile%">>%FSC-LOG%
)
SET MSG=
SET REGFile=

SET MSG=Keyboard: Remove Layout "Swiss French"
SET REGFile=%FSC-Scripts-Local%\FS\Del-fr-layout.reg
IF Exist "%REGFile%" (
	@Echo. - %MSG%
	@Echo. - %MSG%>>%FSC-LOG%
	regedit /S "%REGFile%"
) ELSE (
	@Echo. * Keyboard: NOT found  %MSG% "%REGFile%"
	@Echo. * Keyboard: NOT found %MSG% "%REGFile%">>%FSC-LOG%
)	
SET MSG=
SET REGFile=

:: -----------------------------------------------------------------------------------------------

:: Disable "Open with" / association prompts
SET FSC_FTA_DIR=%FSC-Scripts-Local%\FS\FTA
SET FSC_FTA_CFG=%FSC_FTA_DIR%\NoNewAppAlert.REG
SET FSC_FTA_AA_MSG=Disable "Open with" / association prompts "%FSC_FTA_CFG%"

IF Exist "%FSC_FTA_CFG%" (
	@Echo. - Config: "%FSC_FTA_AA_MSG%" >>%FSC-LOG%
	Regedit /s "%FSC_FTA_CFG%" %_null%
) ELSE (
	@Echo. * Config: Not found "%FSC_FTA_CFG%" >>%FSC-LOG%
)

::  Register Windows Photo Viewer
SET FSC_FTA_DIR=%FSC-Scripts-Local%\FS\FTA
SET FTA_EXE=%FSC_FTA_DIR%\SetUserFTA.exe
SET FTA_Assoc_PhotoViewer_CFG=%FSC_FTA_DIR%\WindowsPhotoViewer-Extensions.txt
SET FSC_FTA_REGFile=%FSC_FTA_DIR%\WindowsPhotoViewer-CFG.reg

IF Exist "%FSC_FTA_REGFile%" IF Exist "%FTA_EXE%" IF Exist "%FTA_Assoc_PhotoViewer_CFG%" (
	@echo. - Default Apps: Configure Windows Photo Viewer associations >> %FSC-LOG%
	Regedit /s "%FSC_FTA_REGFile%" %_null%
	"%FTA_EXE%" "%FTA_Assoc_PhotoViewer_CFG%" %_null%
) ELSE (
	@echo. * Default Apps: NOT found "%FSC_FTA_REGFile%">> %FSC-LOG%
)
SET FTA_EXE=
SET FTA_Assoc_PhotoViewer_CFG=
SET REGFile=

SET FSC_TS_CFG=%FSC-Tools-Local%\Scripts\TaskManagerCFG.json
SET TS_CFG_DIR=%LocalAppData%\Microsoft\Windows\TaskManager
IF NOT EXIST "%TS_CFG_DIR%" MD "%TS_CFG_DIR%"
IF Exist "%FSC_TS_CFG%" (
	Copy /Y "%FSC_TS_CFG%" "%TS_CFG_DIR%\settings.json" %_null%
	@Echo. - FSC: Task Manager configuration >> %FSC-LOG%
) ELSE (
	@Echo. * FSC: ERROR Task Manager configuration not found %FSC_TS_CFG% >> %FSC-LOG%
)

IF Exist %USB_Stick_Path%\Wallpaper (
	Echo. - Copy: New Wallpapers
    Echo. - Copy: New Wallpapers>>%FSC-LOG%
    Xcopy /s %USB_Stick_Path%\Wallpaper %SystemRoot%\Web\Wallpaper /y %_null%
) ELSE (
	Echo. * NOT Found FSC Wallpapers %USB_Stick_Path%\Wallpaper >>%FSC-LOG%
)

SET FSC_ShellBags_CFG=%FSC-Scripts-Local%\FS\ShellBags.reg
IF Exist "%FSC_ShellBags_CFG%" (
	@Echo. - Windows Explorer:
	@Echo.    Config Shell Bags
	@Echo. - Windows Explorer:>>%FSC-LOG%
	@Echo.    Config Shell Bags>>%FSC-LOG%
	Regedit /s "%FSC_ShellBags_CFG%"
) ELSE (
	@Echo. * NOT found "%FSC_ShellBags_CFG%"
	@Echo. * NOT found "%FSC_ShellBags_CFG%">>%FSC-LOG%
)	

:: TaskBar Shortcuts

SET "TBAND=%ProgramData%\Franksoft\Scripts\TaskBar\Taskband.reg"
SET "TLNK=%ProgramData%\Franksoft\Scripts\TaskBar\Taskband.exe"

IF Exist "%TLNK%" "%TLNK%"
IF Exist "%TBAND%" regedit /s "%TBAND%"


SET FileToExecute=%FSC-Scripts-Local%\Rexplorer_x64.exe
IF Exist "%FileToExecute%" (
	@Echo.    Kill and Restart
	@Echo.    Kill and Restart>>%FSC-LOG%
	"%FileToExecute%"
	@Timeout 3 >NUL
) ELSE (
	Echo. * NOT found  "%FileToExecute%">>%FSC-LOG%
)
SET FileToExecute=

IF Exist "%DesktopOK_VBS%" "%DesktopOK_VBS%"
IF Exist "%FSC-Scripts-Local%\WinKey.exe" "%FSC-Scripts-Local%\WinKey.exe"
IF Exist "%DesktopOK_VBS%" "%DesktopOK_VBS%"

@SET Explorer_JumpList_PATH=%AppData%\Microsoft\Windows\Recent\AutomaticDestinations
@SET FSC_Explorer_JumpList=%FSC-Scripts-Local%\f01b4d95cf55d32a.automaticDestinations-ms
If Exist %FSC_Explorer_JumpList% (
	@Echo.    Copy Franksoft mod JumpList
	@Echo.    Copy Franksoft mod JumpList>>%FSC-LOG%
	@Copy /Y "%FSC_Explorer_JumpList%" "%Explorer_JumpList_PATH%" %_null%
) else (	
	@Echo. * NOT found "%FSC_Explorer_JumpList%">>%FSC-LOG%
)
@SET Explorer_JumpList_PATH=
@SET FSC_Explorer_JumpList=

::::::::::::  MOVE SOON  AIIII ::::::::::::::::::::::
:: Powerplan, Duplicate and Config by FS 

@Echo. - Power Profile:
@Echo. - Power Profile:>>%FSC-LOG%
@Echo.    Add: "High Performance" Profile
@Echo.    Add: "High Performance" Profile>>%FSC-LOG%
@Powercfg /DUPLICATESCHEME 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c e5bf7999-365f-410a-9c75-65c8f6efee86 %_null%
@Powercfg -changename e5bf7999-365f-410a-9c75-65c8f6efee86 "Franksoft Deployment" %_null%
SET FSC-MSG=

@Echo.    Change: Name "Franksoft Deployment"
@Echo.    Change: Name "Franksoft Deployment">>%FSC-LOG%
Powercfg -setactive e5bf7999-365f-410a-9c75-65c8f6efee86 %_null%

@Echo.    Config: "Franksoft Deployment" Power Profile
@Echo.    Config: "Franksoft Deployment" Power Profile>>%FSC-LOG%

:: (Netzschalter und Zuklappen)
:: powercfg  -query e5bf7999-365f-410a-9c75-65c8f6efee86 4f971e89-eebd-4455-a8de-9e59040e7347 5ca83367-6e45-459f-a27b-476b1d01c936

@Powercfg /SETDCVALUEINDEX SCHEME_CURRENT SUB_BUTTONS LIDACTION 000 %_null%
@Powercfg /SETACVALUEINDEX SCHEME_CURRENT SUB_BUTTONS LIDACTION 000 %_null%

:: (Bildschirm ausschalten nach)
:: powercfg  -query e5bf7999-365f-410a-9c75-65c8f6efee86 7516b95f-f776-4464-8c53-06167f40cc99 3c0bc021-c8a8-4e07-a973-6b14cbcb2b7e

@Powercfg /SETACVALUEINDEX SCHEME_CURRENT SUB_VIDEO VIDEOIDLE 300 %_null%
@Powercfg /SETDCVALUEINDEX SCHEME_CURRENT SUB_VIDEO VIDEOIDLE 300 %_null%

:: (Energiespartastenaktion)
:: powercfg  -query e5bf7999-365f-410a-9c75-65c8f6efee86 4f971e89-eebd-4455-a8de-9e59040e7347 96996bc0-ad50-47ec-923b-6f41874dd9eb

@Powercfg /SETDCVALUEINDEX SCHEME_CURRENT SUB_BUTTONS SBUTTONACTION 000 %_null%
@Powercfg /SETACVALUEINDEX SCHEME_CURRENT SUB_BUTTONS SBUTTONACTION 000 %_null%

@Powercfg /SETACVALUEINDEX SCHEME_CURRENT SUB_BUTTONS PBUTTONACTION 001 %_null%
@Powercfg /SETDCVALUEINDEX SCHEME_CURRENT SUB_BUTTONS PBUTTONACTION 001 %_null%

:: Disable Monitor Timeout
powercfg -change -monitor-timeout-ac 0 >NUL
powercfg -change -monitor-timeout-dc 0 >NUL

:: Disable HardDisk Timeout
powercfg -change -disk-timeout-ac 0 >NUL
powercfg -change -disk-timeout-dc 0 >NUL

:: Disable Sleep Timeout (Energiesparmodus)
powercfg -change -standby-timeout-ac 0 >NUL
powercfg -change -standby-timeout-dc 0 >NUL

:: Aktives Energieschema auslesen und Namen extrahieren
for /f "tokens=*" %%i in ('powercfg /getactivescheme') do (
    for /f "tokens=2 delims=()" %%a in ("%%i") do set "CurrentPowerScheme=%%a"
)

:: Hellikeit 40%
Powershell (Get-WmiObject -Namespace root/WMI -Class WmiMonitorBrightnessMethods).WmiSetBrightness(1,40) %_null%

SET OpenShell_SOURCE=%USB_Stick_Path%\Runtimes\Install\ClassicShell
SET File2RUN=%OpenShell_SOURCE%\FS-Wrapper.exe
SET OS_CU_CFG=%OpenShell_SOURCE%\OpenShell_Settings_CU.reg
IF Exist "%File2RUN%" IF Exist "%OS_CU_CFG%" (
	@Echo. - Install: Open Shell
	@Echo. - Install: Open Shell>>%FSC-LOG%
	%File2RUN%
	Regedit /S "%OS_CU_CFG%"
) else (
	@Echo. * NOT Installed Open Shell
	@Echo. * NOT Installed Open Shell>>%FSC-LOG%
)
SET File2RUN=

SET SevenZipLoader=%USB_Stick_Path%\Runtimes\Install\7Zip\FS-Wrapper.exe
IF Exist "%SevenZipLoader%" (
	@Echo. - Install: 7-Zip
	@Echo. - Install: 7-Zip>>%FSC-LOG%
	"%SevenZipLoader%"
) else (
	@Echo. * NOT Installed 7-Zip
	@Echo. * NOT Installed 7-Zip>>%FSC-LOG%
)

SET DesktopRestore_Path=%USB_Stick_Path%\Runtimes\Install\DesktopRestore
SET DesktopRestore_Src=%DesktopRestore_Path%\DesktopRestoreInstall.exe
SET DesktopRestore_CFG=%DesktopRestore_Path%\DesktopRestore.reg

IF Exist "%DesktopRestore_Src%" IF Not Exist "%ProgramFiles%\Desktop Restore\DesktopCmd.exe" (
	@Echo. - Install: Desktop Restore
	@Echo. - Install: Desktop Restore>>%FSC-LOG%
	Regedit /s "%DesktopRestore_CFG%"
) else (	
	@Echo. + Desktop Restore allready Installed 
	@Echo. + Desktop Restore allready Installed >>%FSC-LOG%
	Regedit /s "%DesktopRestore_CFG%"
)

:::: Add FS Team Viewer QS
@REM SET FS-TVQS=%USB_Stick_Path%\Runtimes\Install\TeamViewer\fss.EXE

@REM IF Exist "%FS-TVQS%" (
@REM 	"%FS-TVQS%"
@REM 	@Echo. - Install: TeamViewer Quick Support
@REM 	@Echo. - Install: TeamViewer Quick Support>>%FSC-LOG%
@REM ) else (
@REM 	@Echo. * NOT Installed TeamViewer Quick Support
@REM 	@Echo. * NOT Installed TeamViewer Quick Support NOT found %FS-TVQS%>>%FSC-LOG%
@REM )

@REM SET TVQSUPD=%USB_Stick_Path%\Runtimes\Install\TeamViewer\TeamViewerQS_de_FSCUPD.exe
@REM IF Exist "%TVQSUPD%" (
@REM 	@Echo. - Update: TeamViewer Quick Support
@REM 	Copy /Y "%TVQSUPD%" "%FSC-Tools-Local%\Support\TeamViewerQS_de.exe" %_null%
@REM ) else (
@REM 	@Echo. * Update: NOT Updated TeamViewer Quick Support>>%FSC-LOG%
@REM )

:: Microsoft Edge Start
SET EDGE_SOURCE=%USB_Stick_Path%\Runtimes\Install\_Microsoft\Edge
SET EDGE_Path_Local=%LOCALAPPDATA%\Microsoft\Edge\User Data\Default
SET EDGE_FavIcons=%EDGE_SOURCE%\CU\Favicons
SET EDGE_Bookmarks=%EDGE_SOURCE%\CU\Bookmarks
SET EDGE_ADM_User=%EDGE_SOURCE%\CU\MS-EDGE-HKCU_FSC-01.reg

IF Exist "%EDGE_SOURCE%\MicrosoftEdgeEnterpriseX64.msi" (
	@Echo. - Install: Microsoft Edge
	@Echo. - Install: Microsoft Edge>>%FSC-LOG%
	"%EDGE_SOURCE%\FS-Wrapper.exe"
) ELSE (
	@Echo. * NOT found Microsoft Edge Source "%EDGE_SOURCE%\MicrosoftEdgeEnterpriseX64.msi">>%FSC-LOG%
)

If Exist "%Public%\Desktop\Microsoft Edge.lnk" (
	DEL /F/Q "%Public%\Desktop\Microsoft Edge.lnk" %_null%
)
If Exist "%UserProfile%\Desktop\Microsoft Edge.lnk" (
	DEL /F/Q "%UserProfile%\Desktop\Microsoft Edge.lnk" %_null%
)

IF Exist "%DesktopOK_VBS%" "%DesktopOK_VBS%"

:: Microsoft Edge WebView2
setlocal EnableExtensions EnableDelayedExpansion

set "TARGET_VER=149.0.4022.80"
set "WEBVSETUP=%EDGE_SOURCE%\MicrosoftEdgeWebView2RuntimeInstallerX64.exe"
:: set "WEBVSETUP=D:\Sources\$OEM$\$1\Temp\Updates\MicrosoftEdgeWebView2RuntimeInstallerX64.exe
set "WEBVIEW2_VER="

for /f "skip=2 tokens=3" %%i in ('reg query "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft EdgeWebView" /v DisplayVersion 2^>nul') do set "WEBVIEW2_VER=%%i"

@REM echo WebView2 installed: [%WEBVIEW2_VER%]
@REM echo WebView2 target   : [%TARGET_VER%]

if not defined WEBVIEW2_VER (
    echo. - Install: Microsoft Edge WebView2
    echo. - Install: Microsoft Edge WebView2>>"%FSC-LOG%"
    "%WEBVSETUP%" /silent /install
) else (
    powershell -NoProfile -ExecutionPolicy Bypass -Command "if([version]'%WEBVIEW2_VER%' -lt [version]'%TARGET_VER%'){exit 1}else{exit 0}"
	SET FSC-LOG="%FSC-Tools-Local%\Logs\Franksoft Client.txt"

    if errorlevel 1 (
        echo. - Update: Microsoft Edge WebView2 %WEBVIEW2_VER% auf %TARGET_VER%
        echo. - Update: Microsoft Edge WebView2 %WEBVIEW2_VER% auf %TARGET_VER%>>%FSC-LOG%
        "%WEBVSETUP%" /silent /install
    ) else (
        echo. * Error: Not Update Microsoft Edge WebView2 %WEBVIEW2_VER%
        echo. * Error: Not Update Microsoft Edge WebView2 %WEBVIEW2_VER%>>%FSC-LOG%
    )
)


IF NOT EXIST "%EDGE_Path_Local%" MD "%EDGE_Path_Local%"
IF EXIST "%EDGE_Bookmarks%" (
    ECHO.    Config: Edge: Copy Bookmarks
    ECHO.    Config: Edge: Copy Bookmarks>>%FSC-LOG%
    COPY /Y "%EDGE_FavIcons%" "%EDGE_Path_Local%" %_null%
    COPY /Y "%EDGE_Bookmarks%" "%EDGE_Path_Local%" %_null%
) ELSE (
    ECHO.    * NOT found Edge: Copy Bookmarks
    ECHO.    * NOT found Edge: Copy Bookmarks>>%FSC-LOG%
)

If Exist "%EDGE_ADM_User%" (
	@Echo.    Config: Edge: Add User GPO
	@Echo.    Config: Edge: Add User GPO>>%FSC-LOG%
	Regedit /s "%EDGE_ADM_User%" %_null%
) else (
	@Echo.   * NOT found Edge: Add User GPO
	@Echo.   * NOT found Edge: Add User GPO>>%FSC-LOG%
)
SET "EdgeApp=%ProgramFiles(x86)%\Microsoft\Edge\Application\msedge.exe"
SET "Edge_Kill_Scr=%ProgramData%\Franksoft\Scripts\KillEdge.vbs"
SET "MinAppSW=%ProgramData%\Franksoft\Scripts\GUIPropView.exe"
SET "Edge_Min_Syntax=/Action Minimize Class:Chrome_WidgetWin_1 Process:msedge.exe Visible:Yes"

IF Exist "%MinAppSW%" IF Exist "%EdgeApp%" IF EXIST "%Edge_Kill_Scr%" (
	@Echo.    Config: Edge: Start and Kill
	@Echo.    Config: Edge: Start and Kill>>%FSC-LOG%
		Start "" MSEDGE
		Timeout 2 >NUL
		Start "" "%MinAppSW%" %Edge_Min_Syntax%
		Timeout 1 >NUL
		%Edge_Kill_Scr%
) ELSE (
	    @Echo.    * NOT found Edge: Start and Kill>>%FSC-LOG%
)

SET EdgeApp=
SET Edge_Kill_Scr=
SET MinAppSW=
SET Edge_Min_Syntax=

::::-------------- MS Edge END ::::---------------------------------------------

SET "PD=%PUBLIC%\Desktop"
SET "UPD=%USERPROFILE%\Desktop"

DEL /F/Q "%PD%\Microsoft Edge.lnk" %_null%
DEL /F/Q "%UPD%\Microsoft Edge.lnk" %_null%

::::-------------- CHROME Start ::::---------------------------------------------

SET FS-Wrapper-Chrome=%USB_Stick_Path%\Runtimes\Install\Chrome\FS-Wrapper.exe
IF Exist "%FS-Wrapper-Chrome%" (
	@Echo. - Install: Google Chrome
	@Echo. - Install: Google Chrome>>%FSC-LOG%
	"%FS-Wrapper-Chrome%"
	DEL /F/Q "%PD%\*Chrome*.lnk" %_null%
	DEL /F/Q "%UPD%\*Chrome*.lnk" %_null%
) else (
	@Echo. * NOT Installed Google Chrome
	@Echo. * NOT Installed Google Chrome>>%FSC-LOG%
)

DEL /F/Q "%PD%\*Chrome*.lnk" %_null%
DEL /F/Q "%UPD%\*Chrome*.lnk" %_null%

:: Chrome User files
SET CHROME_CU_Path_USB=%USB_Stick_Path%\Runtimes\Install\Chrome\CU
SET CHROME_CU_Path_Local=%LOCALAPPDATA%\Google\Chrome\User Data\Default
SET CHROME_Bookmarks=%CHROME_CU_Path_USB%\Bookmarks
SET CHROME_FavIcons=%CHROME_CU_Path_USB%\Favicons
SET CHROME_CU_ADM=%CHROME_CU_Path_USB%\Chrome-HKCU_FSC-01.reg
SET CHROME_CU_ADD1=%CHROME_CU_Path_USB%\Chrome-User_Extensions.reg

IF Not Exist "%CHROME_CU_Path_Local%" MD "%CHROME_CU_Path_Local%" >NUL

IF Exist "%CHROME_Bookmarks%" (
	@Echo.    Config: Chrome: Copy Bookmarks
	@Echo.    Config: Chrome: Copy Bookmarks>>%FSC-LOG%
	Copy /Y "%CHROME_Bookmarks%" "%CHROME_CU_Path_Local%" %_null%
) else (
	@Echo.    * NOT found Chrome: Copy Bookmarks>>%FSC-LOG%
)

IF Exist "%CHROME_FavIcons%" (
	Copy /Y "%CHROME_FavIcons%" "%CHROME_CU_Path_Local%" %_null%
	Copy /Y "%CHROME_CU_Path_USB%\First Run" "%CHROME_CU_Path_Local%" %_null%
)

IF Exist "%CHROME_CU_ADM%" (
	@Echo.    Config: Chrome: Add User GPO
	@Echo.    Config: Chrome: Add User GPO>>%FSC-LOG%
	Regedit /s "%CHROME_CU_ADM%" %_null%
	Regedit /s "%CHROME_CU_ADD1%" %_null%
) else (
	@Echo.    d* NOT found Config: Chrome: Add User GPO>>%FSC-LOG%
)

SET FSC_FTA_DIR=%FSC-Scripts-Local%\FS\FTA
IF Exist "%FSC_FTA_DIR%\SetDefaultBrowser.exe" (
	@Echo.    Config: Chrome: FTA: Change default Browser to Chrome
	@Echo.    Config: Chrome: FTA: Change default Browser to Chrome>>%FSC-LOG%
	"%FSC_FTA_DIR%\SetDefaultBrowser.exe" HKLM "Google Chrome" %_null%
	"%FSC_FTA_DIR%\SetUserFTA.exe" .URL InternetShortcut %_null%
	"%FSC_FTA_DIR%\SetUserFTA.exe" .mht ChromeHTML %_null%
) else (
	@Echo.    * NOT found Chrome: FTA: Change>>%FSC-LOG%
)

SET "ChromeAppP=%ProgramFiles%\Google\Chrome\Application\chrome.exe"
SET "MinAppSW=%FSC-Scripts-Local%\GUIPropView.exe"
SET "Chrome_Kill_Scr=%FSC-Scripts-Local%\KillChrome.vbs"

SET "Chrome_Min_Syntax=/Action Minimize Class:Chrome_WidgetWin_1 Process:chrome.exe Visible:Yes"

IF Exist "%MinAppSW%" IF Exist "%ChromeAppP%" (
::		@Echo. - Start and Kill Chrome 3x
		Start "" Chrome
		Timeout 2 >NUL
		Start "" "%MinAppSW%" %Chrome_Min_Syntax%
		Timeout 1 >NUL
		%Chrome_Kill_Scr%
		Timeout 1 >NUL
		DEL /F/Q "%PD%\*Chrome*.lnk" %_null%
		DEL /F/Q "%UPD%\*Chrome*.lnk" %_null%
		Start "" Chrome
		Timeout 2 >NUL
		Start "" "%MinAppSW%" %Chrome_Min_Syntax%
		Timeout 1 >NUL
		%Chrome_Kill_Scr%
		Timeout 1 >NUL
)

DEL /F/Q "%PD%\*Chrome*.lnk" %_null%
DEL /F/Q "%UPD%\*Chrome*.lnk" %_null%

SET MinAppSW=

:: Google Chrome END

:: Copy Franksoft VCard
SET "FN=%USB_Stick_Path%\Runtimes\Install\FSC\Vcard.png"
IF Exist "%FN%" (
	@Echo. - Copy: Franksoft VCard to %PUBLIC%\Desktop>>%FSC-LOG%
	Copy /y "%FN%" "%UserProfile%\Pictures" %_null%
	Copy /y "%FN%" "%PUBLIC%\Desktop" %_null%
)
SET FN=

@Echo. - OneDrive: Disable Autostart>>%FSC-LOG%
@reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\Run /v OneDrive /f %_null%

SET "FILE=%UPD%\desktop.ini"
@attrib -r -s -h "%FILE%" %_null%
IF Exist "%FILE%" del "%FILE%" /F/Q %_null%

SET "FILE=%PD%\desktop.ini"
@attrib -r -s -h "%FILE% %"_null%
IF Exist "%FILE%" del "%FILE%" /F/Q %_null%
SET FILE=

@Attrib -r -s -h "%UserProfile%\Pictures\*.*" /S %_null%
IF Exist "%FSC-Scripts-Local%\Wallpaper.lnk" Copy /y "%FSC-Scripts-Local%\Wallpaper.lnk" "%UserProfile%\Pictures" %_null%

SET "PSDefPara1=-EP ByPass -NoLogo -NonInteractive -WindowStyle Hidden -File"

IF Exist "%FSC-Scripts-Local%\DelReg.vbs" (
	@Echo. - Remove First Logon Commands from Registry>>%FSC-LOG%
	start /wait wscript.exe "%FSC-Scripts-Local%\DelReg.vbs" %_null%
	start /wait powershell.exe "%PSDefPara1%" "%FSC-Scripts-Local%\DelReg.ps1" %_null%
) ELSE (
		@Echo. * NOT found %FSC-Scripts-Local%\DelReg.vbs>>%FSC-LOG%
)

:: UnInstall MS Apps Appx (Get Office,GetSkype,Finance Apps)
IF Exist "%FSC-Scripts-Local%\UninstallAppx.PS1" (
	@Echo. - Uninstall Default Microsoft Apps
	@Echo. - Uninstall Default Microsoft Apps>>%FSC-LOG%
	cmd /c start /wait powershell.exe "%PSDefPara1%" "%FSC-Scripts-Local%\UninstallAppx.PS1" %_null%
	@TIMEOUT 5 >NUL
) ELSE (
	@Echo. * NOT found Uninstall Default Microsoft Apps Script: UninstallAppx.PS1>>%FSC-LOG%
)
SET FSC-MSG=

::::::::: < FSC-Software-Deployment Start  Regedit RunOnce< :::::::::

SET "FSC-Runtimes-USB=%USB_Stick_Path%\Runtimes"
SET "FS-Post-Apps.cmd_SCR=%FSC-Runtimes-USB%\FS-Post-Apps.cmd"
SET "FS-Post-Apps_Check=%USB_Stick_Path%\FSC_Apps_1.txt"

SET FSC_SW_DEP_MSG=Franksoft Software Deployment

@dir "%FS-Post-Apps_Check%" >NUL
@REM @Echo. "%FS-Post-Apps_Check%" 
@REM @echo %errorlevel%

IF errorlevel 1 (
	@Echo. * Not selected %FSC_SW_DEP_MSG%
	@Echo. * Not selected %FSC_SW_DEP_MSG%>>%FSC-LOG%
	MD "%PUBLIC%\Desktop\FS-Post-Apps=0" >NUL
	GOTO EndWPI
) ELSE (
    GOTO FS-Apps-Deployment
)

:FS-Apps-Deployment
		@Echo. ^>  %FSC_SW_DEP_MSG% Start : %Time:~0,-3%
		@Echo. ^>  %FSC_SW_DEP_MSG% Start : %Time:~0,-3%>>%FSC-LOG%
		Call "%FS-Post-Apps.cmd_SCR%"
::		MD "%PUBLIC%\Desktop\FS-Post-Apps=1" %_null%
		@TimeOut 2 %_null%
		runonce.exe /Explorer
::		"%FSC-Runtimes-USB%\RunOnceExProcess_Ex.lnk"
::		MD "%TEMP%\WPION" %_null%
		GOTO WFSCRU

:WFSCRU
:: @echo. in :WFSCRU
:: wait until "%Temp%\FSRunOnce_Done" is created by calling FS-Post-Apps.cmd
If Not Exist "%Temp%\FSRunOnce_Done" (Timeout 10 >NUL) else Goto EndWPI
Goto WFSCRU

:EndWPI
:: END OF FS-Post-Apps.cmd

IF EXIST "%Temp%\FSRunOnce_Done" (
	@Echo. ^>  %FSC_SW_DEP_MSG% End   : %Time:~0,-3%
	@Echo. ^>  %FSC_SW_DEP_MSG% End   : %Time:~0,-3%>>%FSC-LOG%
)

IF NOT EXIST "%Temp%\FSRunOnce_Done" (
	@Echo.    * Not Activated %FSC_SW_DEP_MSG% Script: %FS-Post-Apps_Check%>>%FSC-LOG%
)
SET FSC_SW_DEP_MSG=
::::::::: > End of WPI > :::::::::

Color 2F

@Echo. 
@Echo.  Reboot in 15sec...
@Echo. 
@Echo. 

:: ADD Second FSC SCR to RunOnce
SET CounterS=%FSC-Counter-Start%/%FSC-Counter-End%
SET ELEVATE-EXE=%FSC-Scripts-Local%\elevate.exe
SET REGKEY-RunOnce=HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce
SET FSC-MSG=FSC: Add FSC Logon Script %CounterS% : %FSC-Post-02-Script%
SET FSC-Script-P2=%SystemDrive%\Temp\Updates\%FSC-Post-02-Script%

:: SET Wallpaper for Next Logon
SET "WallPaper_CMD=%FSC_FSTools_Local%\Scripts\WallP.cmd"
if exist "%WallPaper_CMD%" call "%WallPaper_CMD%"

IF EXIST "%FSC-Script-P2%" IF EXIST "%ELEVATE-EXE%" (
		@Echo. - %FSC-MSG%
		@Echo. - %FSC-MSG%>>%FSC-LOG%
		@REG Add "%REGKEY-RunOnce%" /v FSC-Post-02 /d "%ELEVATE-EXE% %FSC-Script-P2%" /f >NUL
) ELSE (
		MD "%PUBLIC%\Desktop\NOT found FSC-Post-02.cmd" >NUL
		@Echo. * NOT found %FSC-Post-02-Script%
		@Echo. * NOT found %FSC-Post-02-Script%>>%FSC-LOG%
)

@Echo. - Logging: Deployment State>>%FSC-LOG%
@Echo. - System: Reboot Initiated>>%FSC-LOG%

::: GET Current Windows PowerPlan
rem Aktives Energieschema auslesen und Namen extrahieren
for /f "tokens=*" %%i in ('powercfg /getactivescheme') do (
    for /f "tokens=2 delims=()" %%a in ("%%i") do set "CurrentPowerScheme=%%a"
)

SET Status=Phase %FSC-Counter-Start%/%FSC-Counter-End%

SET NT=
SET "NT=%TIME: =0%"
SET "NT=%NT:~0,8%"

@Echo.>>%FSC-LOG%
@Echo. - Phase ID:       %Status% (End)      >>%FSC-LOG%
@Echo. - Timestamp:      %Date% %NT%           >>%FSC-LOG%
@Echo. - User:           %UserName%            >>%FSC-LOG%
@echo. - IsAdmin:        %Admin-Status%        >>%FSC-LOG%
@Echo. - Power Profile:  %CurrentPowerScheme%  >>%FSC-LOG%
@Echo. - Script Path:    %~dp0%~nx0            >>%FSC-LOG%
@Echo. >>%FSC-LOG%

@Echo Franksoft Client ^| Software Deployment ^| %Status% ^| End >>%FSC-LOG%
@Echo.>>%FSC-LOG%
@Echo ************************************************************************************* >>%FSC-LOG%

EVENTCREATE /T INFORMATION /SO Franksoft /ID 007 /L APPLICATION /D "Franksoft Client | Software Deployment | %Status% | Script: %~nx0" >NUL 2>NUL


IF Exist "%DesktopOK_VBS%" "%DesktopOK_VBS%"

IF Exist "%FSC-Scripts-Local%\FS\FST_HKCU.reg" Regedit /s "%FSC-Scripts-Local%\FS\FST_HKCU.reg" %_null%

:: Wallpaper Clear
SET "WallP_exe=%FSC-Scripts-Local%\WallP.exe"
IF EXIST "%WallP_exe%" (
    "%WallP_exe%" None
)

:: NOT
@REM :: Add DesktopOK to RunOnce
@REM If Exist "%DesktopOK_VBS%" (
@REM     REG Add "%REGKEY-RunOnce%" /v 002-FSC-DesktopOK /d "cmd /c %DesktopOK_VBS%" /f >NUL
@REM )

IF Exist "%DesktopOK_VBS%" "%DesktopOK_VBS%"

SET FSC_Defender_RegPath=HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Systray
REG Delete "%FSC_Defender_RegPath%" /f %_null%
SET FSC_Defender_RegPath=

Cmd /c "%NotepadCFG_Source%" %_null%

SET "IMG=%ProgramData%\Franksoft\Logos\Logon\02-G.png"
SET "CSP=HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP"
SET "POL=HKLM\SOFTWARE\Policies\Microsoft\Windows\System"

:: CSP-key add
REG Add "%CSP%" /f %_null%

:: Lockscreen add
REG Add "%CSP%" /v LockScreenImagePath /t REG_SZ /d "%IMG%" /f %_null%
REG Add "%CSP%" /v LockScreenImageUrl /t REG_SZ /d "%IMG%" /f %_null%
REG Add "%CSP%" /v LockScreenImageStatus /t REG_DWORD /d 1 /f %_null%

:: Lockscreen activate
REG Add "%POL%" /v DisableLogonBackgroundImage /t REG_DWORD /d 0 /f %_null%

:: FSC HKLM time logging
:: + 15 Sec 
for /f "tokens=*" %%i in ('powershell -NoProfile -Command "$t=[TimeSpan]::Parse('%NT%'); $n=$t.Add([TimeSpan]::FromSeconds(15)); $n.ToString('hh\:mm\:ss')"') do set "NT=%%i"
REG Add "%FSC_REG%\%FSC_SCRIPT_NAME%" /v "End" /t REG_SZ /d "%DATE% %NT%" /f %_null%

IF Exist "%SystemDrive%\%~nx0_DBG" RD /S/Q "%SystemDrive%\%~nx0_DBG"

REG Add "HKCU\Control Panel\Colors" /v Background /t REG_SZ /d "0 0 0" /f %_null%

:: Brightness 40% Hellikeit
Powershell (Get-WmiObject -Namespace root/WMI -Class WmiMonitorBrightnessMethods).WmiSetBrightness(1,40) %_null%

SET FSC_Shutdown_Ps1=%ProgramData%\Franksoft\Scripts\FS-Shutdown.ps1
SET FS-Shutdown-Syntax=Start "" /min Powershell.exe -EP ByPass -NoLogo -NonInteractive -NoProfile -WindowStyle Hidden -File "%FSC_Shutdown_Ps1%"
IF Exist "%FSC_Shutdown_Ps1%" (
	%FS-Shutdown-Syntax%
) ELSE (
	MD "%PUBLIC%\Desktop\NOT-FOUND_FS-Shutdown.ps1" >NUL
	IF Not Exist "%PUBLIC%\Desktop\%~nx0_DBG" MD "%PUBLIC%\Desktop\%~nx0_DBG"
)

Exit