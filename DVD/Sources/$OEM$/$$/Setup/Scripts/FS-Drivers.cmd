TITLE %~nx0 TIme: %TIME%

@echo off

:: GET Nice Time
FOR /F "tokens=1-3 delims=:.," %%A IN ("%TIME%") DO (
    set H=%%A
    set M=%%B
    set S=%%C
)

SET H=%H: =%
IF %H% LSS 10 SET H=0%H%
SET NT=%H%:%M%:%S%

:: Check USB Drive Driver Path
for %%i in (B C D E F G H I J K L M N O P Q R S T U V W X Y Z) do @IF Exist %%i:\_Drivers\Franksoft_Drivers1.txt set USB-Stick-Path-Drivers=%%i:
SET DRVPATH=%USB-Stick-Path-Drivers%\_Drivers
SET FSDRV-Condition-File=%DRVPATH%\Franksoft_Drivers1.txt

SET FSC-FSTools-Local=%ProgramData%\Franksoft
SET FSC-LOG="%FSC-FSTools-Local%\Logs\Franksoft Client.txt"
SET FS-Drivers-LOG="%PUBLIC%\Desktop\Franksoft DriverInst.txt"

SET FSC-Scripts-Local=%FSC-FSTools-Local%\Scripts
SET FSC-Scripts-USB=%USB-Stick-Path%\sources\$OEM$\$1\ProgramData\Franksoft\Scripts

for /f "tokens=3*" %%a in ('reg query "HKLM\HARDWARE\DESCRIPTION\System\BIOS" /v "SystemProductName" ^| findstr /i "SystemProductName"') do (
    set "ProductName=%%a %%b"
)

:: Get Product Name model number
@echo %ProductName% | findstr /i "G8" >nul

IF errorlevel 1 (
    Color 46
    @Echo. 
    @Echo. *** NOT G8 ***
    @Echo. 
    @REM Pause 
    @REM GOTO NextDrv
) ELSE (
    Color 20
    @Echo. 
    @Echo. +++ G8 +++
    @Echo. 
    GOTO HP-G8-00-Drivers
)

:: Get Product Name model number
@echo %ProductName% | findstr /i "G10" >nul

IF errorlevel 1 (
    Color 46
    @Echo. 
    @Echo. *** NOT G10 ***
    @Echo. 
    @REM Pause 
    @REM GOTO NoDriverFound
) ELSE (
    Color 20
    @Echo. 
    @Echo. +++ G10 +++
    @Echo. 
    GOTO HP-G10-00-Drivers
)


:: Get Product Name model number
@echo %ProductName% | findstr /i "G11" >nul

IF errorlevel 1 (
    Color 46
    @Echo. 
    @Echo. *** NOT G11 ***
    @Echo. 
    @REM Pause 
    @REM GOTO NoDriverFound
) ELSE (
    Color 20
    @Echo. 
    @Echo. +++ G11 +++
    @Echo. 
    GOTO HP-G11-00-Drivers
)


:: ******************************************************************************************
:: START: Driver Installation for HP EliteBook 860 G10 Notebook PC

:HP-G10-00-Drivers

@echo. 
@echo. HP-G10-00-Drivers
@echo. 

SET PCMODELL=%ProductName%
SET FSC-LOG="%ProgramData%\Franksoft\Logs\Franksoft Client.txt"
SET FSDRVLOG="%Public%\Desktop\FS-Driver-Inst.txt"

@Echo. PCMODELL = %PCMODELL%


SET DRV-INST-Scr_01=%DRVPATH%\HP\G10\860\2025\HP\G10_Drivers_Hp.cmd
SET DRV-INST-Scr_02=%DRVPATH%\HP\G10\860\2025\HP\Installed_After_Setup\002\Install-All-G10.cmd

SET TXT01=  Install Drivers

IF Exist "%DRV-INST-Scr_01%" (
    @Echo. - %TXT01%: Modell: %PCMODELL%
    @Echo. - %TXT01%: Modell: %PCMODELL%>>%FSC-LOG%
    @Echo. - %TXT01%: Script: %DRV-INST-Scr_01%>>%FSC-LOG%
    @Echo. - %TXT01%: Start : %TIME:~0,8%>>%FSC-LOG%
    call "%DRV-INST-Scr_01%" >>"%FSDRVLOG%"
    call "%DRV-INST-Scr_02%" >>"%FSDRVLOG%"
    MD "%TEMP%\G10" >NUL
) ELSE (
    @Echo. * %TXT01%: %PCMODELL%>>%FSC-LOG%
    @Echo. * %TXT01%: NOT found Script "%DRV-INST-Scr_01%">>%FSC-LOG%
)

IF Exist "%FSDRVLOG%" (
    @Echo. - %TXT01%: End   : %TIME:~0,8%
    @Echo. - %TXT01%: End   : %TIME:~0,8%>>%FSC-LOG%
    If Exist "%TEMP%\G10" Goto NoDriverFound
)

:: END: Driver Installation for HP EliteBook 860 G10 Notebook PC
:: ******************************************************************************************

:: ******************************************************************************************
:: START: Driver Installation for HP EliteBook 860 G8 Notebook PC

:HP-G8-00-Drivers

@echo. 
@echo. HP-G8-00-Drivers
@echo. 

SET PCMODELL=%ProductName%
SET FSC-LOG="%ProgramData%\Franksoft\Logs\Franksoft Client.txt"
SET FSDRVLOG="%Public%\Desktop\FS-Driver-Inst.txt"

@Echo. PCMODELL = %PCMODELL%


SET DRV-INST-Scr_01=%DRVPATH%\HP\G8\850\HP\G8_Drivers_Hp.cmd
SET DRV-INST-Scr_02=%DRVPATH%\HP\G8\850\Installed\DPInst64.exe

SET TXT01=  Install Drivers

IF Exist "%DRV-INST-Scr_01%" (
    @Echo. - %TXT01%: Modell: %PCMODELL%
    @Echo. - %TXT01%: Modell: %PCMODELL%>>%FSC-LOG%
    @Echo. - %TXT01%: Script: %DRV-INST-Scr_01%>>%FSC-LOG%
    @Echo. - %TXT01%: Start : %TIME:~0,8%>>%FSC-LOG%
    call "%DRV-INST-Scr_01%" >>"%FSDRVLOG%"
    call "%DRV-INST-Scr_02%" >>"%FSDRVLOG%"
    MD "%TEMP%\G8" >NUL
) ELSE (
    @Echo. * %TXT01%: %PCMODELL%>>%FSC-LOG%
    @Echo. * %TXT01%: NOT found Script "%DRV-INST-Scr_01%">>%FSC-LOG%
)

IF Exist "%FSDRVLOG%" (
    @Echo. - %TXT01%: End   : %TIME:~0,8%
    @Echo. - %TXT01%: End   : %TIME:~0,8%>>%FSC-LOG%
    If Exist "%TEMP%\G8" Goto NoDriverFound
)

:: END: Driver Installation for HP EliteBook 860 G8 Notebook PC
:: ******************************************************************************************


:: ******************************************************************************************
:: START: Driver Installation for HP EliteBook 860 G11 Notebook PC

:HP-G11-00-Drivers

@echo. 
@echo. HP-G11-00-Drivers
@echo. 

SET PCMODELL=%ProductName%
SET FSC-LOG="%ProgramData%\Franksoft\Logs\Franksoft Client.txt"
SET FSDRVLOG="%Public%\Desktop\FS-Driver-Inst.txt"

@Echo. PCMODELL = %PCMODELL%


SET DRV-INST-Scr_01=%DRVPATH%\HP\G11\830\HP\G11_Drivers_Hp.cmd
SET DRV-INST-Scr_02=%DRVPATH%\HP\G11\830\Installed\DPInst64.exe

SET TXT01=  Install Drivers

IF Exist "%DRV-INST-Scr_01%" (
    @Echo. - %TXT01%: Modell: %PCMODELL%
    @Echo. - %TXT01%: Modell: %PCMODELL%>>%FSC-LOG%
    @Echo. - %TXT01%: Script: %DRV-INST-Scr_01%>>%FSC-LOG%
    @Echo. - %TXT01%: Start : %TIME:~0,8%>>%FSC-LOG%
    call "%DRV-INST-Scr_01%" >>"%FSDRVLOG%"
    call "%DRV-INST-Scr_02%" >>"%FSDRVLOG%"
    MD "%TEMP%\G11" >NUL
) ELSE (
    @Echo. * %TXT01%: %PCMODELL%>>%FSC-LOG%
    @Echo. * %TXT01%: NOT found Script "%DRV-INST-Scr_01%">>%FSC-LOG%
)

IF Exist "%FSDRVLOG%" (
    @Echo. - %TXT01%: End   : %TIME:~0,8%
    @Echo. - %TXT01%: End   : %TIME:~0,8%>>%FSC-LOG%
    If Exist "%TEMP%\G11" Goto NoDriverFound
)

:: END: Driver Installation for HP EliteBook 860 G11 Notebook PC
:: ******************************************************************************************


:NoDriverFound


@echo. Ende
