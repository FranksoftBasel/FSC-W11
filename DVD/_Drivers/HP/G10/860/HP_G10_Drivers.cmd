:: ============================================================================
:: Franksoft Client (FSC) - HP Driver Installation
:: ============================================================================
:: Script    : HP_G10_860_Drivers.cmd
:: Version   : 1.2
:: Date      : 15.10.2026
:: Author    : Franksoft
:: Target    : HP EliteBook 830 / 860 G10
:: Changelog : v1.1 - Filename unified; install.cmd only at first folder level
::             v1.2 - Original FOR /R + CALL restored (recursive)
::                    Group headings; no PowerShell WAIT wrappers
:: ============================================================================

@echo off
:: [01] INITIALIZATION / ADMINISTRATOR CHECK
TITLE Script: %~nx0 - Time: %TIME%

openfiles >nul 2>&1
if %errorlevel% NEQ 0 (
    echo Check Admin permissions
    powershell -Command "Start-Process cmd -ArgumentList '/c, %~s0' -Verb runAs"
    exit
)

:: [02] HARDWARE DETECTION
for /f "tokens=3*" %%a in ('reg query "HKLM\HARDWARE\DESCRIPTION\System\BIOS" /v "SystemProductName" ^| findstr /i "SystemProductName"') do (
    set "ProductName=%%a %%b"
)

:: [03] LOG INITIALIZATION
SET FSC_LOG_Dir=%ProgramData%\Franksoft\Logs
IF NOT EXIST "%FSC_LOG_Dir%" MD "%FSC_LOG_Dir%" >NUL
SET "FSC_Driver_Inst_LOG=%FSC_LOG_Dir%\Franksoft-Driver-Inst.txt"
SET Hardware-Modell=%ProductName%

IF NOT Exist "%PUBLIC%\Desktop\%ProductName%" MD "%PUBLIC%\Desktop\%ProductName%"

@echo. _________________________________________________>>"%FSC_Driver_Inst_LOG%"
@echo. >>"%FSC_Driver_Inst_LOG%"
@echo.   ^>^> Franksoft Client: Driver Installation   ^<^<>>"%FSC_Driver_Inst_LOG%"
@echo. _________________________________________________>>"%FSC_Driver_Inst_LOG%"
@echo. >>"%FSC_Driver_Inst_LOG%"

@echo. ---------------------------------------------------------------->>"%FSC_Driver_Inst_LOG%"
@echo. Phase ................ Start >>"%FSC_Driver_Inst_LOG%"
@echo. Time ................. %time:~0,8%>>"%FSC_Driver_Inst_LOG%"
@echo. Product Name ......... %ProductName%>>"%FSC_Driver_Inst_LOG%"
@echo. Driver Path .......... %~dp0>>"%FSC_Driver_Inst_LOG%"
@echo. Script ............... %~f0>>"%FSC_Driver_Inst_LOG%"
@echo. FSC DriverInst LOG ... %FSC_Driver_Inst_LOG%>>"%FSC_Driver_Inst_LOG%"
@echo.


:: [04] DRIVER INSTALLATION - ORIGINAL RECURSIVE CALL
Pushd "%~dp0"
for /r %%d in (.) do if exist "%%d\install.cmd" call "%%d\install.cmd"

:: [05] AUDIO INSTALLATION

Pushd "%~dp0"

SET AUDIO_DRV=sp174175_Audio.exe

IF EXIST "%AUDIO_DRV%" (
    @echo. >>"%FSC_Driver_Inst_LOG%"
    @echo. Install Audio Driver.. %AUDIO_DRV% Start Time %time:~0,8%>>"%FSC_Driver_Inst_LOG%"
    "%AUDIO_DRV%" /s /e cmd.exe /a /c ""HPUP.exe""
)

:: [06] FINALIZATION / LOGGING
@echo. >>"%FSC_Driver_Inst_LOG%"
@echo. Phase ................ End >>"%FSC_Driver_Inst_LOG%"
@echo. Time ................. %time:~0,8%>>"%FSC_Driver_Inst_LOG%"
@echo. Product Name ......... %ProductName%>>"%FSC_Driver_Inst_LOG%"
@echo. Driver Path .......... %~dp0>>"%FSC_Driver_Inst_LOG%"
@echo. Script ............... %~f0>>"%FSC_Driver_Inst_LOG%"
@echo. FSC DriverInst LOG ... %FSC_Driver_Inst_LOG%>>"%FSC_Driver_Inst_LOG%"
@echo.
@echo. ---------------------------------------------------------------->>"%FSC_Driver_Inst_LOG%"
