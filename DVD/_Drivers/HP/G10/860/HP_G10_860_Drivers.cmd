:: ============================================================================
:: Franksoft Client (FSC) - HP Driver Installation
:: ============================================================================
:: Script    : HP-G10-Drivers.cmd
:: Version   : 1.1
:: Date      : 14.10.2026
:: Author    : Franksoft
:: Target    : HP EliteBook 830 / 860 G10
:: Changelog : v1.1 - Filename unified; install.cmd only at first folder level
:: ============================================================================

@echo off
TITLE Script: %~nx0 - Time: %TIME%

openfiles >nul 2>&1
if %errorlevel% NEQ 0 (
    echo Check Admin permissions
    powershell -Command "Start-Process cmd -ArgumentList '/c, %~s0' -Verb runAs"
    exit
)

for /f "tokens=3*" %%a in ('reg query "HKLM\HARDWARE\DESCRIPTION\System\BIOS" /v "SystemProductName" ^| findstr /i "SystemProductName"') do (
    set "ProductName=%%a %%b"
)

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


Pushd "%~dp0"
for /d %%D in ("%~dp0*") do (
    if exist "%%~fD\install.cmd" (
        echo Installing: %%~fD\install.cmd
        call "%%~fD\install.cmd"
    )
)

:: Audio

Pushd "%~dp0"

SET AUDIO_DRV=sp174175_Audio.exe

IF EXIST "%AUDIO_DRV%" (
	@echo. >>"%FSC_Driver_Inst_LOG%"
	@echo. Install Audio Driver.. %AUDIO_DRV% Start Time %time:~0,8%>>"%FSC_Driver_Inst_LOG%"
	"%AUDIO_DRV%" /s /e cmd.exe /a /c ""HPUP.exe""
)

@echo. >>"%FSC_Driver_Inst_LOG%"
@echo. Phase ................ End >>"%FSC_Driver_Inst_LOG%"
@echo. Time ................. %time:~0,8%>>"%FSC_Driver_Inst_LOG%"
@echo. Product Name ......... %ProductName%>>"%FSC_Driver_Inst_LOG%"
@echo. Driver Path .......... %~dp0>>"%FSC_Driver_Inst_LOG%"
@echo. Script ............... %~f0>>"%FSC_Driver_Inst_LOG%"
@echo. FSC DriverInst LOG ... %FSC_Driver_Inst_LOG%>>"%FSC_Driver_Inst_LOG%"
@echo. 
@echo. ---------------------------------------------------------------->>"%FSC_Driver_Inst_LOG%"


