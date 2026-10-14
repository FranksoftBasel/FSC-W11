:: ============================================================================
::  Franksoft Client (FSC) - HP Driver Installation
:: ============================================================================
::  Script       : HP-G1i-Drivers.cmd
::  Version      : 1.1
::  Updated      : 2026-10-14
::  Author       : Franksoft
::  Target       : HP EliteBook 8 G1i / Windows 11
::
::  Purpose      : Install HP driver packages from the local driver structure.
::  Privileges   : Administrator (UAC elevation if required)
::  Detection    : HKLM\HARDWARE\DESCRIPTION\System\BIOS
::                 Value: SystemProductName
::  Source       : Immediate subdirectories of the script directory
::  Log File     : %ProgramData%\Franksoft\Logs\Franksoft-Driver-Inst.txt
::
::  Workflow     : 01 - Check administrator permissions
::                 02 - Read hardware model from BIOS registry
::                 03 - Prepare installation log and model desktop folder
::                 04 - Run install.cmd in each immediate child directory
::                 05 - Install Realtek HD Audio SoftPaq (if present)
::                 06 - Record installation finish information
::
::  Changelog    : 2026-10-09 - Added structured documentation header.
::                              Driver installation logic unchanged.
::                 2026-10-14 - Unified CMD filename to HP-G1i-Drivers.cmd.
::                            - Restrict install.cmd calls to first folder level.
:: ============================================================================


:: @echo off
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

SET "FSC_LOG_Dir=%ProgramData%\Franksoft\Logs"
IF NOT EXIST "%FSC_LOG_Dir%" MD "%FSC_LOG_Dir%"
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

SET Audio_Drv=sp174332_Audio.exe

IF EXIST "%Audio_Drv%" (
	@echo. >>"%FSC_Driver_Inst_LOG%"
	@echo. Install Audio Driver %Audio_Drv% Start Time %time:~0,8%>>"%FSC_Driver_Inst_LOG%"
	"%Audio_Drv%" /s /e cmd.exe /a /c ""HPUP.exe""
)

IF EXIST "Realtek_HighDefinition_Audio_sp168787.exe" (
	@echo. Install Audio Driver.. Realtek_HighDefinition_Audio_sp168787.exe End   Time %time:~0,8%>>"%FSC_Driver_Inst_LOG%"
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

Popd
