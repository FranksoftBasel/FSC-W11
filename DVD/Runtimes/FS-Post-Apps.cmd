:: Called by FSC-Post-01.cmd

@echo off
chcp 850
CLS
setlocal EnableExtensions

SET FSC_PHASE=02/06

:: =============================================================================
:: Script Name : FS-Post-Apps.cmd
:: Version     : 1.3
:: Date        : 19.03.2022
:: Author      : Franksoft
:: Modules     : Called from PSC-Post-01.cmd  :FS-Apps-Deployment
::
:: Purpose
:: -----------------------------------------------------------------------------
:: FSC Deployment Phase 03/09
:: 
:: Software Deployment 
::
:: Log
:: -----------------------------------------------------------------------------
:: No Log
:: =============================================================================
SET "NT=%TIME: =0%"
SET "NT=%NT:~0,8%"

SET "FSC_REG=HKLM\SOFTWARE\Franksoft\Setup"
SET "FSC_SCRIPT_NAME=%~nx0"
SET "FSC_SCRIPT_PATH=%~f0"

REG add "%FSC_REG%\%FSC_SCRIPT_NAME%" /f >nul 2>nul

REG add "%FSC_REG%\%FSC_SCRIPT_NAME%" /v "Script Name" /t REG_SZ /d "%FSC_SCRIPT_NAME%" /f >nul 2>nul
REG add "%FSC_REG%\%FSC_SCRIPT_NAME%" /v "Script Path" /t REG_SZ /d "%FSC_SCRIPT_PATH%" /f >nul 2>nul
REG add "%FSC_REG%\%FSC_SCRIPT_NAME%" /v "FSC Phase" /t REG_SZ /d "%FSC_PHASE%" /f >nul 2>nul
REG add "%FSC_REG%\%FSC_SCRIPT_NAME%" /v "Start" /t REG_SZ /d "%DATE% %NT%" /f >nul 2>nul

SET "DesktopOK_VBS=%ProgramData%\Franksoft\Scripts\DesktopOK\DesktopOK_Start.vbs"
IF Exist "%DesktopOK_VBS%" "%DesktopOK_VBS%"

IF Exist "%Temp%\FSRunOnce_Done" EXIT

SET TITLE01=Franksoft Client: Post Software-Deployment - Please wait..
TITLE %TITLE01%
@MODE CON: COLS=70 LINES=8

:: SET FSC_STAGE=FSC_POST_DEP_APPS_RUNONCE

call :Admin

SET FSC_ROOT=%ProgramData%\Franksoft
If Not Exist %FSC_ROOT%\Logs MD %FSC_ROOT%\Logs
SET FSC_LOG="%FSC_ROOT%\Logs\Franksoft Client.txt"

echo. 
echo. 
echo.  %TITLE01%
echo. 


:: Check USB Drive
for %%i in (B D E F G H I J K L M N O P Q R S T U V W X Y Z) do @IF Exist %%i:\Sources\setup.exe set USB_Stick_Path=%%i:

::::::::: ----- Start FS RunOnceEx ----- :::::::::

SET SourcePath=%~dp0Install

SET ROE=HKLM\Software\Microsoft\Windows\CurrentVersion\RunOnceEx
SET /A i=100

	REG ADD %ROE% /v Title /d "Franksoft Client | Software-Deployment" /f >NUL
	REG ADD %ROE% /v Flags /t REG_DWORD /d "00000003" /f >NUL

IF Not Exist "%ProgramFiles(x86)%\Common Files\Adobe AIR" (
	REG ADD %ROE%\%i% /ve /d "Adobe AIR" /f >NUL
	REG ADD %ROE%\%i% /v "001" /d "%SourcePath%\Adobe\AIR\FS-Loader.ExE" /f >NUL
	SET /A i+=1
)

IF Not Exist "%ProgramFiles(x86)%\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe" (
	REG ADD %ROE%\%i% /ve /d "Adobe Reader DC MUI" /f >NUL
	REG ADD %ROE%\%i% /v "001" /d "%SourcePath%\Adobe\ReaderDC_GE\FS-Wrapper.exe" /f >NUL
	REG ADD %ROE%\%i% /v "002" /d "REGEDIT /S %SourcePath%\Adobe\ReaderDC_GE\Acrobat_GPO.reg" /f >NUL
	SET /A i+=1
)
	
If Not Exist "%ProgramFiles%\Desktop Restore\dkticnsr.dll" (
	REG ADD %ROE%\%i% /ve /d "Desktop Restore" /f >NUL
	REG ADD %ROE%\%i% /v "001" /d "%SourcePath%\DesktopRestore\DesktopRestoreInstall.exe /NOCANCEL /NORESTART /SILENT /SUPPRESSMSGBOXES /NOICONS" /f >NUL
)
	REG ADD %ROE%\%i% /v "002" /d "REGEDIT /S %SourcePath%\DesktopRestore\DesktopRestore.reg" /f >NUL
	SET /A i+=1

	REG ADD %ROE%\%i% /ve /d "Visual C++ Redist AIO" /f >NUL
	REG ADD %ROE%\%i% /v "001" /d "%SourcePath%\_Microsoft\VisualCppRedist_AIO.exe /y" /f >NUL
	SET /A i+=1

	REG ADD %ROE%\%i% /ve /d "Google Chrome" /f >NUL
	REG ADD %ROE%\%i% /v "001" /d "%SourcePath%\Chrome\FS-Wrapper.exe" /f >NUL
	REG ADD %ROE%\%i% /v "002" /d "REGEDIT /S %SourcePath%\Chrome\CU\Chrome-HKCU_FSC-01.reg" /f >NUL
	SET /A i+=1

	SET "HyperSnap=%ProgramFiles(x86)%\HyperSnap 6\HprSnap6.exe"
	IF Not Exist "%HyperSnap%" (
	REG ADD %ROE%\%i% /ve /d "Hyper Snap" /f >NUL
	REG ADD %ROE%\%i% /v "001" /d "%SourcePath%\HyperSnap\FS-Loader.exe" /f >NUL
	SET /A i+=1
	)

	REG ADD %ROE%\%i% /ve /d "Microsoft Edge" /f >NUL
	REG ADD %ROE%\%i% /v "001" /d "%SourcePath%\_Microsoft\Edge\KillEdge.vbs" /f >NUL
	REG ADD %ROE%\%i% /v "002" /d "%SourcePath%\_Microsoft\Edge\FS-Wrapper.exe" /f >NUL
	REG ADD %ROE%\%i% /v "003" /d "REGEDIT /S %SourcePath%\_Microsoft\Edge\CU\MS-EDGE-HKCU_FSC-01.reg" /f >NUL
	SET /A i+=1

	REG ADD %ROE%\%i% /ve /d "Microsoft OneDrive" /f >NUL
	REG ADD %ROE%\%i% /v "001" /d "%SourcePath%\_Microsoft\OneDrive\OneDriveSetup_Kill.vbs" /f >NUL
	REG ADD %ROE%\%i% /v "002" /d "%SourcePath%\_Microsoft\OneDrive\OneDrive_Wrapper.exe" /f >NUL
	SET /A i+=1

	SET "WT=%SourcePath%\_Microsoft\Terminal\Microsoft.WindowsTerminal_Install.cmd"
	IF Exist "%WT%" (
	REG ADD %ROE%\%i% /ve /d "Microsoft Terminal" /f >NUL
	REG ADD %ROE%\%i% /v "001" /d "%WT%" /f >NUL
	SET /A i+=1
	)

	SET "MPC=%SourcePath%\MPC-HC\FS-Loader.exe"
	IF Exist "%MPC%" (
	REG ADD %ROE%\%i% /ve /d "Media Player Classic" /f >NUL
	REG ADD %ROE%\%i% /v "001" /d "%MPC%" /f >NUL
	SET /A i+=1
	)

	SET "SG=%SourcePath%\SafeGuardPC\FS-Wrapper.exe"
	IF Exist "%SG%" (
	REG ADD %ROE%\%i% /ve /d "SafeGuard PrivateCrypto" /f >NUL
	REG ADD %ROE%\%i% /v "001" /d "%SG%" /f >NUL
	SET /A i+=1
	)

	SET "VLC=%SourcePath%\VLC_media_Player\FS-Wrapper.exe"
	IF Exist "%VLC%" (
    	REG ADD %ROE%\%i% /ve /d "VLC Media Player" /f >NUL
    	REG ADD %ROE%\%i% /v "001" /d "%VLC%" /f >NUL
    	SET /A i+=1
	)

	IF NOT Exist "%ProgramFiles(x86)%\7-Zip\7zFM.exe" (
    	REG ADD %ROE%\%i% /ve /d "7-Zip" /f >NUL
    	REG ADD %ROE%\%i% /v "001" /d "%SourcePath%\7Zip\FS-Wrapper.exe" /f >NUL
    S	ET /A i+=1
	)

	IF Not Exist "%ProgramFiles%\WinRAR\WinRAR.exe" (	
	REG ADD %ROE%\%i% /ve /d "WinRAR" /f >NUL
::	REG ADD %ROE%\%i% /v "001" /d "%SourcePath%\WinRar\FS-Wrapper.exe" /f >NUL
	REG ADD %ROE%\%i% /v "001" /d "%SourcePath%\WinRar\Install-WinRAR.cmd" /f >NUL
	SET /A i+=1
	)

	IF Not Exist "%ProgramFiles%\RustDesk\rustdesk.exe" (	
	REG ADD %ROE%\%i% /ve /d "RustDesk" /f >NUL
	REG ADD %ROE%\%i% /v "001" /d "%SourcePath%\RustDesk\FS-Wrapper.exe" /f >NUL
	SET /A i+=1
	)

	IF Not Exist "%ProgramFiles(x86)%\Intel\Driver and Support Assistant\x86\DSAServiceHelper.exe" (	
	REG ADD %ROE%\%i% /ve /d "Intel Driver and Support Assistant" /f >NUL
	REG ADD %ROE%\%i% /v "001" /d "%SourcePath%\Intel\DriverSuppAs\FS-Loader.cmd" /f >NUL
	SET /A i+=1
	)


::	REG ADD %ROE%\%i% /v "003" /d "CMD /C  IF Exist %TVUPD% Copy /y %TVUPD% %FS-TV-LocalPath%\TeamViewerQS_de.exe" /f >NUL
::	SET /A i+=1

SET "NT=%TIME: =0%"
SET "NT=%NT:~0,8%"

	REG ADD %ROE%\%i% /ve /d "Franksoft Settings" /f >NUL
	REG ADD %ROE%\%i% /v "001" /d "CMD /C MD %Temp%\FSRunOnce_Done" /f >NUL
	SET /A i+=1

:: Registry Logging after last RUEx Task	
	REG ADD "%ROE%\%i%" /ve /d "Franksoft Logging" /f >NUL
	REG ADD "%ROE%\%i%" /v "001" /d "CMD /C reg add \"%FSC_REG%\%FSC_SCRIPT_NAME%\" /v End /t REG_SZ /d \"%DATE% %NT%\" /f" /f >NUL
	SET /A i+=1

:: DBG pause
:: 	REG ADD %ROE%\%i% /ve /d "DBG Pause" /f >NUL
:: 	REG ADD %ROE%\%i% /v "002" /d "Notepad" /f >NUL
:: 	SET /A i+=1

:: Title for FSC_LOG "  - Franksoft Software Deployment Start : %TIME%"
SET FSC_LOG_MSG=Software Deployment

@Echo. -  %FSC_LOG_MSG% Script: %~dp0%~nx0>>%FSC_LOG%

:: DBG: Start now 
:: %SystemRoot%\System32\runonce.exe /Explorer

:Admin
reg query "HKU\S-1-5-19\Environment" >nul 2>&1
if not %errorlevel% EQU 0 (
    cls
    powershell.exe -windowstyle hidden -noprofile "Start-Process '%~dpnx0' -Verb RunAs"
    exit
)

:: Called by FSC-Post-01.cmd
