:: Called by SetupComplete.cmd
:: @echo off
Title Install Drivers - Script: %~nx0 Time: %TIME%

pushd "%~dp0"

SET DEBUG=0

SET FSC_PHASE=01/06

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

for %%i in (B D E F G H I J K L M N O P Q R S T U V W X Y Z) do @IF Exist %%i:\Sources\setup.exe set USB-Stick-Path=%%i:

SET FSC_Driver_LOG=%ProgramData%\Franksoft\Logs\Franksoft-Driver-Inst.txt
:: Future work (logging)
SET FSC_LOG=%ProgramData%\Franksoft\Logs\Franksoft Client.txt

SET REG_Path=HKLM\SYSTEM\HardwareConfig\Current
SET REG_KEY1=SystemProductName
SET REG_KEY2=BIOSVersion
SET REG_KEY3=BIOSReleaseDate

for /f "tokens=2*" %%A in ('reg query "%REG_Path%" /v %REG_KEY1% 2^>nul') do SET SystemProductName=%%B
for /f "tokens=2*" %%A in ('reg query "%REG_Path%" /v %REG_KEY2% 2^>nul') do SET BIOS_Version=%%B
for /f "tokens=2*" %%A in ('reg query "%REG_Path%" /v %REG_KEY3% 2^>nul') do SET BIOS_ReleaseDate=%%B

Title Install Drivers for - %SystemProductName% - Start: %TIME:~0,8% 

set "MODEL=%SystemProductName%"
echo Modell: %MODEL%

:: ------------- HP EliteBook G10 -------------::

for %%A in (%MODEL%) do (
    if "%%A"=="830" goto HP860
    if "%%A"=="850" goto HP850
    if "%%A"=="860" goto HP860
)

:: ------------- HP EliteBook 8 G1i -------------::
echo %MODEL% | findstr /i "EliteBook 8 G1i 13" >nul && goto HPG1I
echo %MODEL% | findstr /i "EliteBook 8 G1i 16" >nul && goto HPG1I

goto ERROR

:: --------------------------------------------------------------------------------::
:: ------------- HP EliteBook 8 G1i -------------::

:HPG1I

SET MODELL=G1i
SET Driver_Source=%USB-Stick-Path%\_Drivers\HP\G1i
SET FSC_HP_Driver_Script=%Driver_Source%\HP_EliteBook_8_G1i_Drivers.cmd
Goto :FSC_Driver_Start

:HP830
SET MODELL=830
SET Driver_Source=%USB-Stick-Path%\_Drivers\HP\G10\830
SET FSC_HP_Driver_Script=%Driver_Source%\G10_830_Drivers_Hp.cmd
Goto :FSC_Driver_Start

:HP850
SET MODELL=850
SET Driver_Source=%USB-Stick-Path%\_Drivers\HP\G08\850
SET FSC_HP_Driver_Script=%Driver_Source%\G8_Drivers_Hp.cmd
Goto :FSC_Driver_Start
-

:HP860
SET MODELL=860
SET Driver_Source=%USB-Stick-Path%\_Drivers\HP\G10\860
SET FSC_HP_Driver_Script=%Driver_Source%\G10_860_Drivers_Hp.cmd
Goto :FSC_Driver_Start

:FSC_Driver_Start
@color 0A
@Echo. __________________________________________________________________
@Echo.
@Echo.  Install Drivers for %SystemProductName%
@Echo. __________________________________________________________________
@Echo.
@Echo. - Date/Time : %DATE% - %NT%
@Echo. - Script    : %FSC_HP_Driver_Script%
@Echo. - LogFile   : %FSC_Driver_LOG%
@Echo. - Modell    : %SystemProductName%
@Echo. ^> BIOS
@Echo. - Version   : %BIOS_Version%
@Echo. - BIOS Date : %BIOS_ReleaseDate%

pushd "%~dp0"
Call "%FSC_HP_Driver_Script%"
goto END

:: --------------------------------------------------------------------------------::

:ERROR
@Echo.
@Echo. No Driver Found in %Driver_Source%
@Echo.
goto END

:END

SET "NT=%TIME: =0%"
SET "NT=%NT:~0,8%"

REG ADD "%FSC_REG%\%FSC_SCRIPT_NAME%" /v "End" /t REG_SZ /d "%DATE% %NT%" /f >nul
