net start WSearch
cls

@Echo off
@MODE CON: COLS=70 LINES=12
@Color 4f
Pushd "%~dp0"

SET FSC_PHASE=03/06
:: =============================================================================
:: Script Name : FSC-Post-02.cmd
:: Path        : "D:\Sources\$OEM$\$1\Temp\Updates\FSC-Post-02.cmd"
:: Version     : 2.4
:: Date        : 14.06.2026
:: Author      : Franksoft
::
:: Purpose     : FSC Deployment main script 02/03
:: -----------------------------------------------------------------------------
:: FSC Deployment Phase 03/06
::
:: - wait for MSI Reapir from FSC-Post-01.cmd SW Deployment
:: - FSC Config
::
:: Log
:: -----------------------------------------------------------------------------
:: %ProgramData%\Franksoft\Logs\Franksoft Client.txt"
:: =============================================================================

set "FSC_REG=HKLM\SOFTWARE\Franksoft\Setup"
set "FSC_SCRIPT_NAME=%~nx0"
set "FSC_SCRIPT_PATH=%~f0"

reg add "%FSC_REG%\%FSC_SCRIPT_NAME%" /f >nul 2>nul

reg add "%FSC_REG%\%FSC_SCRIPT_NAME%" /v "Script Name" /t REG_SZ /d "%FSC_SCRIPT_NAME%" /f >nul
reg add "%FSC_REG%\%FSC_SCRIPT_NAME%" /v "Script Path" /t REG_SZ /d "%FSC_SCRIPT_PATH%" /f >nul
reg add "%FSC_REG%\%FSC_SCRIPT_NAME%" /v "FSC Phase" /t REG_SZ /d "%FSC_PHASE%" /f >nul
reg add "%FSC_REG%\%FSC_SCRIPT_NAME%" /v "Start" /t REG_SZ /d "%DATE% %NT%" /f >nul

set "WallPaper_Exe=%ProgramData%\Franksoft\Scripts\WallP.exe"
set "FSC_Wallpaper=%ProgramData%\Franksoft\Logos\FSC_DEP\FSPost_02.png"
if exist "%FSC_Wallpaper%" cmd /c start "" "%WallPaper_Exe%" "%FSC_Wallpaper%" CENTER"

SET "NT=%TIME: =0%"
SET "NT=%NT:~0,8%"

:: Brightness 40% Hellikeit
Powershell (Get-WmiObject -Namespace root/WMI -Class WmiMonitorBrightnessMethods).WmiSetBrightness(1,40) %_null%
REG Add "HKCU\Control Panel\Colors" /v Background /t REG_SZ /d "0 0 0" /f >NUL 2>&1

SET FSC_STAGE=02

SET FSC-Tools-Local=%ProgramData%\Franksoft
SET FSC-Scripts-Local=%FSC-Tools-Local%\Scripts


set "WallPaper_Exe=%ProgramData%\Franksoft\Scripts\WallP.exe"
set "FSC_Wallpaper=%ProgramData%\Franksoft\Logos\FSC_DEP\FSPost_02.png"
if exist "%FSC_Wallpaper%" cmd /c start "" "%WallPaper_Exe%" "%FSC_Wallpaper%" CENTER"


IF NOT Exist "%SystemDrive%\%~nx0_DBG" MD "%SystemDrive%\%~nx0_DBG"

SET FSC-Counter-Start=03
SET FSC-Counter-End=04
SET Status=Phase %FSC-Counter-Start%/%FSC-Counter-End%
SET FSC-Tools-Local=%ProgramData%\Franksoft
IF NOT Exist "%FSC-Tools-Local%\Logs" MD "%FSC-Tools-Local%\Logs"
SET FSC-LOG="%FSC-Tools-Local%\Logs\Franksoft Client.txt"

@Echo.>>%FSC-LOG%
@Echo Franksoft Client ^| Software Deployment ^| %Status% ^| Start >>%FSC-LOG%
@Echo.>>%FSC-LOG%

EVENTCREATE /T INFORMATION /SO Franksoft /ID 007 /L APPLICATION /D "Franksoft Client | Software Deployment | %Status% | Script: %~nx0" >NUL 2>NUL

SET FSC-Post-03-Script=FSC-Post-03.cmd
SET FSC-TITLE-01=Franksoft Client: Post-Deployment - Please wait...  - Script: %~nx0
SET FSC-TITLE-02=Franksoft Client: Post-Deployment Start - Script: %~nx0

SET "_null=1>nul 2>nul"

net session >nul 2>&1
IF %ErrorLevel% equ 0 (Set Admin-Status=Yes) else (Set Admin-Status=No) >NUL

:: GET Windows Setup USB Drive letter
@REM for %%i in (B D E F G H I J K L M N O P Q R S T U V W X Y Z) do @IF Exist %%i:\Sources\setup.exe set USB-Stick-Path=%%i:
for %%i in (
    B D E F G H I J K L M N O P Q R S T U V W X Y Z
) do (
    if exist %%i:\Sources\setup.exe (
        set "USB-Stick-Path=%%i:"
    )
)

SET FSC-Scripts-USB=%USB-Stick-Path%\sources\$OEM$\$1\ProgramData\Franksoft\Scripts

SET "FSC_DRVI_LOG=%Public%\Desktop\FS-Driver-Inst.txt"
SET "FSC_LOG_PATH=%FSC_LOG_PAT%"

IF EXIST "%FSC_DRVI_LOG%" (
    COPY /Y "%FSC_DRVI_LOG%" "%FSC_LOG_PATH%" 1>NUL 2>NUL
    DEL /f/q "%FSC_DRVI_LOG%" >NUL
)

@Color 4f

TITLE %FSC-TITLE-02%

echo. 
echo. 
echo.    Franksoft Client: Post-Deployment - Please wait...
echo. 

setlocal enabledelayedexpansion

rem ==========================================================
rem 1) Warten bis die Desktop-Shell (Explorer) wirklich steht
rem ==========================================================
echo.
echo.  - Warte auf die Windows-Desktop-Shell

:WAIT_EXPLORER
tasklist /FI "IMAGENAME eq explorer.exe" | find /I "explorer.exe" >nul
if errorlevel 1 (
    timeout /t 1 >nul
    goto WAIT_EXPLORER
)

:WAIT_DESKTOP
powershell -NoProfile -Command ^
  "$e = Get-Process explorer -ErrorAction SilentlyContinue; if ($e -and $e.MainWindowHandle -ne 0) { exit 0 } else { exit 1 }"
if errorlevel 1 (
    timeout /t 1 >nul
    goto WAIT_DESKTOP
)
echo.  - Explorer ist bereit, Desktop geladen!

rem ==========================================================
rem 2) msiexec.exe-Check:
rem    Wenn >=2 Instanzen: 3 Versuche mit 30/20/10s warten
rem ==========================================================
set /a tries=0

:CHECK_MSI
for /f %%A in ('tasklist /FI "IMAGENAME eq msiexec.exe" ^| find /I /C "msiexec.exe"') do set "MSI_COUNT=%%A"
if not defined MSI_COUNT set "MSI_COUNT=0"

if !MSI_COUNT! GEQ 2 (
    if !tries! LSS 3 (
        set /a tries+=1

        rem Wartezeit je nach Versuch
        if !tries! EQU 1 set waitTime=30
        if !tries! EQU 2 set waitTime=20
        if !tries! EQU 3 set waitTime=10

        echo.  ^> * msiexec.exe-Instanzen: !MSI_COUNT! ^> Warte !waitTime!s - Versuch !tries!/3...
        timeout /t !waitTime! >nul
        goto CHECK_MSI
    ) else (
        echo.  ^> * Nach 3 Versuchen laufen noch !MSI_COUNT! msiexec.exe...
    )
) else (
        echo.  ^> + msiexec.exe-Instanzen ^< 2
)

cls
TITLE %FSC-TITLE-02%

echo. 
echo.    %FSC-TITLE-02% - Start
echo. 

SET "DesktopOK_PATH=%FSC-Scripts-Local%\DesktopOK"
SET "DesktopOK_VBS=%DesktopOK_PATH%\DesktopOK_Start.vbs"
IF Exist "%DesktopOK_VBS%" "%DesktopOK_VBS%"

@Color 4f

:: Get Windows Product Name (Home,Pro,Ent)
:: Windows 10 Pro
SET RK=HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion
for /f "tokens=3*" %%a in ('reg query "%RK%" /V "ProductName" ^|findstr /ri "REG_SZ"') do Set FullProductName=%%a %%b
SET RK=

:: 2023
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

::: GET Current Windows PowerPlan
rem Aktives Energieschema auslesen und Namen extrahieren
for /f "tokens=*" %%i in ('powercfg /getactivescheme') do (
    for /f "tokens=2 delims=()" %%a in ("%%i") do set "CurrentPowerScheme=%%a"
)

SET "NT=%TIME: =0%"
SET "NT=%NT:~0,8%"

@Echo. - Phase ID:       %Status% (Start)      >>%FSC-LOG%
@Echo. - Timestamp:      %Date% %NT%           >>%FSC-LOG%
@Echo. - User:           %UserName%            >>%FSC-LOG%
@echo. - IsAdmin:        %Admin-Status%        >>%FSC-LOG%
@Echo. - Power Profile:  %CurrentPowerScheme%  >>%FSC-LOG%
@Echo. - Script Path:    %~dp0%~nx0            >>%FSC-LOG%
@Echo. >>%FSC-LOG%

@MODE CON: COLS=70 LINES=20
Cls
@Color 1e

Title %FSC-TITLE-02%

@Echo.
@Echo.   %FSC-TITLE-02%
@Echo. 


SET "FILE2DEL=%Public%\Desktop\Google Chrome.lnk"
If Exist "%FILE2DEL%" del "%FILE2DEL%" /F/Q %_null%
SET FILE2DEL=

SET "FILE2DEL=%UserProfile%\Desktop\Google Chrome.lnk"
If Exist "%FILE2DEL%" del "%FILE2DEL%" /F/Q %_null%
SET FILE2DEL=

SET "FILE=%UserProfile%\Desktop\desktop.ini"
IF Exist "%FILE%" attrib -r -s -h "%FILE%" %_null%
IF Exist "%FILE%" del "%FILE%" /F/Q %_null%
SET FILE=

SET "FILE=%Public%\Desktop\desktop.ini"
IF Exist "%FILE%" attrib -r -s -h "%FILE%" %_null%
IF Exist "%FILE%" del "%FILE%" /F/Q %_null%
SET FILE=

@Echo. - Windows System Restore: Disable
@Echo. - Windows System Restore: Disable>>%FSC-LOG%
start "" /min powershell -NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -Command "Disable-ComputerRestore -Drive 'C:\'" %_null%
@vssadmin delete shadows /All /Quiet %_null%

:: SET .pdf FTA
SET "FS-MSG=Set Default App: Set .pdf extension to Acrobat Reader"
SET "FTA-exe=%ProgramData%\Franksoft\Scripts\FS\FTA\SetUserFTA.exe"
If EXIST "%FTA-exe%" (
    @Echo. - %FS-MSG%
    @Echo. - %FS-MSG%>>%FSC-LOG%
    "%FTA-exe%" .pdf AcroExch.Document.DC %_null%
    ) ELSE (
    @Echo. * NOT found %FTA-exe%
    @Echo. * NOT found %FTA-exe%>>%FSC-LOG%
)
SET FS-MSG=

IF Exist "%DesktopOK_VBS%" "%DesktopOK_VBS%"

SET "CounterS=%FSC-Counter-Start%/%FSC-Counter-End%"
SET "ELEVATE-EXE=%ProgramData%\Franksoft\Scripts\elevate.exe"
SET "REGKEY-RunOnce=HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce"
SET "FSC-MSG=FSC: Add FSC Logon Script %CounterS% : %FSC-Post-03-Script%"
SET "FSC-Script-P3=%SystemDrive%\Temp\Updates\%FSC-Post-03-Script%"

:: RUO ADD 1
:: SET Wallpaper for Next Logon
SET "REGKEY-RunOnce=HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce"
SET "WallPaper_CMD=%FSC_FSTools_Local%\Scripts\WallP.cmd"
if exist "%WallPaper_CMD%" call "%WallPaper_CMD%"

:: RUO ADD 2
IF EXIST "%FSC-Script-P3%" IF EXIST "%ELEVATE-EXE%" (
    @Echo. - %FSC-MSG%
	@Echo. - %FSC-MSG%>>%FSC-LOG%
    @REG ADD "%REGKEY-RunOnce%" /v FSC-Post-03 /d "%ELEVATE-EXE% %FSC-Script-P3%" /f >NUL
) ELSE (
   	@Echo. * NOT found %FSC-Script-P3%
	@Echo. * NOT found %FSC-Script-P3%>>%FSC-LOG%
)

SET "NotepadCFG_Source=%ProgramData%\Franksoft\UWP\Notepad\Notepad-CFG.exe"
SET "NotepadCFG_Dest=%LocalAppData%\Packages\Microsoft.WindowsNotepad_8wekyb3d8bbwe\Settings"

IF EXIST "%NotepadCFG_Source%" (
    @echo. - Configure: Windows Notepad default settings
    @echo. - Configure: Windows Notepad default settings >> %FSC-LOG%
    cmd /c start "" /min notepad
	timeout 3 >NUL
	taskkill /im notepad.exe /f 1>NUL 2>NUL
	"%NotepadCFG_Source%"
) ELSE (
    @echo. * ERROR: Notepad config not found %NotepadCFG_Source%
    @echo. * ERROR: Notepad config not found %NotepadCFG_Source%>>%FSC-LOG%
)

@TimeOut 5 >NUL
Color 2F

@Echo. - Reboot in 15sec...
@Echo. - System: Reboot Initiated>>%FSC-LOG%

:: Open RUN
:: Start "" %windir%\explorer.exe shell:::{2559a1f3-21d7-11d4-bdaf-00c04f60b9f0}

::: GET Current Windows PowerPlan
rem Aktives Energieschema auslesen und Namen extrahieren
for /f "tokens=*" %%i in ('powercfg /getactivescheme') do (
    for /f "tokens=2 delims=()" %%a in ("%%i") do set "CurrentPowerScheme=%%a"
)

SET "Status=Phase %FSC-Counter-Start%/%FSC-Counter-End%"
SET "FSC-TITLE=Franksoft Client: Post-Deployment - %Status% - End"

SET NT=
SET "NT=%TIME: =0%"
SET "NT=%NT:~0,8%"

@Echo.>>%FSC-LOG%
@Echo. - Phase ID:       %Status% (End)        >>%FSC-LOG%
@Echo. - Timestamp:      %Date% %NT%           >>%FSC-LOG%
@Echo. - User:           %UserName%            >>%FSC-LOG%
@echo. - IsAdmin:        %Admin-Status%        >>%FSC-LOG%
@Echo. - Power Profile:  %CurrentPowerScheme%  >>%FSC-LOG%
@Echo. - Script Path:    %~dp0%~nx0            >>%FSC-LOG%
@Echo. >>%FSC-LOG%

@Echo Franksoft Client ^| Software Deployment ^| %Status% ^| End>>%FSC-LOG%
@Echo.>>%FSC-LOG%
@Echo ************************************************************************************* >>%FSC-LOG%

SET "Status=Phase %FSC-Counter-Start%/%FSC-Counter-End%"
EVENTCREATE /T INFORMATION /SO Franksoft /ID 007 /L APPLICATION /D "Franksoft Client | Software Deployment | %Status% | Script: %~nx0" >NUL 2>NUL


:: SET Wallpaper NONE
SET "File2Ex=%ProgramData%\Franksoft\Scripts\WallP.exe"
IF EXIST "%File2Ex%" "%File2Ex%" None %_null%

SET FSC-REG-Path=HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Systray
@REG Delete "%FSC-REG-Path%" /f %_null%
SET FSC-REG-Path=

SET "IMG=%ProgramData%\Franksoft\Logos\Logon\03-G.png"
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

@REM :: Add Desktop Ok to RunOnce
@REM If Exist "%DesktopOK_VBS%" (
@REM     REG ADD "%REGKEY-RunOnce%" /v 002-FSC-DesktopOK /d "cmd /c %DesktopOK_VBS%" /f >NUL
@REM )
@REM IF Exist "%DesktopOK_VBS%" "%DesktopOK_VBS%"

:: FSC HKLM time logging
:: + 15 Sec 
for /f "tokens=*" %%i in ('powershell -NoProfile -Command "$t=[TimeSpan]::Parse('%NT%'); $n=$t.Add([TimeSpan]::FromSeconds(15)); $n.ToString('hh\:mm\:ss')"') do set "NT=%%i"
REG Add "%FSC_REG%\%FSC_SCRIPT_NAME%" /v "End" /t REG_SZ /d "%DATE% %NT%" /f %_null%

IF Exist "%SystemDrive%\%~nx0_DBG" RD /S/Q "%SystemDrive%\%~nx0_DBG"

SET NotepadCFG_Source=%ProgramData%\Franksoft\UWP\Notepad\Notepad-CFG.exe
IF Exist "%NotepadCFG_Source%" Cmd /c "%NotepadCFG_Source%"

:: Brightness 40% Hellikeit
Powershell (Get-WmiObject -Namespace root/WMI -Class WmiMonitorBrightnessMethods).WmiSetBrightness(1,40) %_null%

:: TaskBar Shortcuts

SET "TBAND=%ProgramData%\Franksoft\Scripts\TaskBar\Taskband.reg"
SET "TLNK=%ProgramData%\Franksoft\Scripts\TaskBar\Taskband.exe"

IF Exist "%TLNK%" "%TLNK%"
IF Exist "%TBAND%" regedit /s "%TBAND%"


SET FSC_Shutdown_Ps1=%ProgramData%\Franksoft\Scripts\FS-Shutdown.ps1
SET FS-Shutdown-Syntax=Start "" /min Powershell.exe -EP ByPass -NoLogo -NonInteractive -NoProfile -WindowStyle Hidden -File "%FSC_Shutdown_Ps1%"
IF Exist "%FSC_Shutdown_Ps1%" (
	%FS-Shutdown-Syntax%
) ELSE (
	MD "%PUBLIC%\Desktop\NOT-FOUND_FS-Shutdown.ps1" >NUL
   	IF Not Exist "%PUBLIC%\Desktop\%~nx0_DBG" MD "%PUBLIC%\Desktop\%~nx0_DBG"
)


endlocal



Exit

