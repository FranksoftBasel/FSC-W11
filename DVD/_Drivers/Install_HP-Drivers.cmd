@echo off
chcp 65001 >NUL
TITLE Install Drivers - Script: %~nx0 - Time: %TIME%

:: =============================================================================
:: Script Name : Install_HP-Drivers.cmd
:: Version     : 2.0
:: Date        : 26.09.2026
:: Author      : Franksoft
::
:: Changelog
:: -----------------------------------------------------------------------------
:: v2.0 - 26.09.2026
:: - Bestehendes Script logisch bereinigt und nach Funktion gruppiert
:: - USB-/DVD-Laufwerk wird direkt über %~d0 ermittelt
:: - Erneute Suche nach \Sources\setup.exe entfernt
:: - HP EliteBook 830 und 860 verwenden weiterhin bewusst denselben G10/860
::   Treibersatz
:: - G1i-Erkennung mit FINDSTR /C: präzisiert
:: - Existenzprüfung des ausgewählten Treiberscripts vor CALL ergänzt
:: - Pushd/Popd bereinigt
:: - Registry Start-/End-Tracking beibehalten
:: - Nicht mehr verwendeter :HP830 Block am Dateiende als Legacy auskommentiert
:: - ExitCode des aufgerufenen Treiberscripts wird protokolliert
::
:: Purpose
:: -----------------------------------------------------------------------------
:: Ermittelt das HP Modell und startet das passende FSC Treiberscript.
::
:: Aktuelles Mapping:
:: - HP EliteBook / Elite x360 830  -> G10\860\G10_860_Drivers_Hp.cmd
:: - HP EliteBook 860              -> G10\860\G10_860_Drivers_Hp.cmd
:: - HP EliteBook 850              -> G08\850\G8_Drivers_Hp.cmd
:: - HP EliteBook 8 G1i 13 / 16   -> G1i\HP_EliteBook_8_G1i_Drivers.cmd
::
:: Called by:
:: - SetupComplete.cmd
:: =============================================================================

setlocal
pushd "%~dp0"


:: =============================================================================
:: [01] INITIALIZATION / LOGGING
:: =============================================================================

SET "FSC_PHASE=01/06"

SET "NT=%TIME: =0%"
SET "NT=%NT:~0,8%"

SET "FSC_REG=HKLM\SOFTWARE\Franksoft\Setup"
SET "FSC_SCRIPT_NAME=%~nx0"
SET "FSC_SCRIPT_PATH=%~f0"

SET "FSC_LOG=%ProgramData%\Franksoft\Logs\Franksoft Client.txt"
SET "FSC_Driver_LOG=%ProgramData%\Franksoft\Logs\Franksoft-Driver-Inst.txt"

IF NOT EXIST "%ProgramData%\Franksoft\Logs" (
    MD "%ProgramData%\Franksoft\Logs" >NUL 2>&1
)

REG ADD "%FSC_REG%\%FSC_SCRIPT_NAME%" /f >NUL 2>&1
REG ADD "%FSC_REG%\%FSC_SCRIPT_NAME%" /v "Script Name" /t REG_SZ /d "%FSC_SCRIPT_NAME%" /f >NUL 2>&1
REG ADD "%FSC_REG%\%FSC_SCRIPT_NAME%" /v "Script Path" /t REG_SZ /d "%FSC_SCRIPT_PATH%" /f >NUL 2>&1
REG ADD "%FSC_REG%\%FSC_SCRIPT_NAME%" /v "FSC Phase" /t REG_SZ /d "%FSC_PHASE%" /f >NUL 2>&1
REG ADD "%FSC_REG%\%FSC_SCRIPT_NAME%" /v "Start" /t REG_SZ /d "%DATE% %NT%" /f >NUL 2>&1


:: =============================================================================
:: [02] DRIVER SOURCE
:: Funktion:
:: - Das Script liegt direkt unter \_Drivers
:: - Der Laufwerksbuchstabe wird deshalb direkt aus %~d0 übernommen
:: =============================================================================

SET "USB-Stick-Path=%~d0"
SET "Driver-Root=%USB-Stick-Path%\_Drivers"


:: =============================================================================
:: [03] HARDWARE INFORMATION
:: =============================================================================

SET "REG_Path=HKLM\SYSTEM\HardwareConfig\Current"
SET "REG_KEY1=SystemProductName"
SET "REG_KEY2=BIOSVersion"
SET "REG_KEY3=BIOSReleaseDate"

for /f "tokens=2*" %%A in ('reg query "%REG_Path%" /v %REG_KEY1% 2^>NUL') do SET "SystemProductName=%%B"
for /f "tokens=2*" %%A in ('reg query "%REG_Path%" /v %REG_KEY2% 2^>NUL') do SET "BIOS_Version=%%B"
for /f "tokens=2*" %%A in ('reg query "%REG_Path%" /v %REG_KEY3% 2^>NUL') do SET "BIOS_ReleaseDate=%%B"

SET "MODEL=%SystemProductName%"

TITLE Install Drivers for - %SystemProductName% - Start: %TIME:~0,8%

ECHO Modell: %MODEL%


:: =============================================================================
:: [04] MODEL MAPPING
:: Funktion:
:: - 830 und 860 verwenden bewusst denselben G10/860 Treibersatz
:: - 850 verwendet den G8 Treibersatz
:: - EliteBook 8 G1i 13/16 verwendet den gemeinsamen G1i Treibersatz
:: =============================================================================

FOR %%A IN (%MODEL%) DO (
    IF /I "%%A"=="830" GOTO HP860
    IF /I "%%A"=="850" GOTO HP850
    IF /I "%%A"=="860" GOTO HP860
)

ECHO %MODEL% | FINDSTR /I /C:"EliteBook 8 G1i 13" >NUL && GOTO HPG1I
ECHO %MODEL% | FINDSTR /I /C:"EliteBook 8 G1i 16" >NUL && GOTO HPG1I

GOTO ERROR


:: =============================================================================
:: [05] DRIVER TARGETS
:: =============================================================================

:HPG1I
SET "MODELL=G1i"
SET "Driver_Source=%Driver-Root%\HP\G1i"
SET "FSC_HP_Driver_Script=%Driver_Source%\HP_EliteBook_8_G1i_Drivers.cmd"
GOTO FSC_Driver_Start


:HP850
SET "MODELL=850"
SET "Driver_Source=%Driver-Root%\HP\G08\850"
SET "FSC_HP_Driver_Script=%Driver_Source%\G8_Drivers_Hp.cmd"
GOTO FSC_Driver_Start


:HP860
SET "MODELL=860"
SET "Driver_Source=%Driver-Root%\HP\G10\860"
SET "FSC_HP_Driver_Script=%Driver_Source%\G10_860_Drivers_Hp.cmd"
GOTO FSC_Driver_Start


:: =============================================================================
:: [06] DRIVER SCRIPT VALIDATION / INSTALLATION
:: =============================================================================

:FSC_Driver_Start

COLOR 0A

ECHO. __________________________________________________________________
ECHO.
ECHO.  Install Drivers for %SystemProductName%
ECHO. __________________________________________________________________
ECHO.
ECHO. - Date/Time : %DATE% - %NT%
ECHO. - Script    : %FSC_HP_Driver_Script%
ECHO. - LogFile   : %FSC_Driver_LOG%
ECHO. - Modell    : %SystemProductName%
ECHO. - Mapping   : %MODELL%
ECHO. - Source    : %Driver_Source%
ECHO. ^> BIOS
ECHO. - Version   : %BIOS_Version%
ECHO. - BIOS Date : %BIOS_ReleaseDate%

ECHO.>>"%FSC_LOG%"
ECHO. [DRIVER] Model        : %SystemProductName%>>"%FSC_LOG%"
ECHO. [DRIVER] Mapping      : %MODELL%>>"%FSC_LOG%"
ECHO. [DRIVER] Driver Source: %Driver_Source%>>"%FSC_LOG%"
ECHO. [DRIVER] Driver Script: %FSC_HP_Driver_Script%>>"%FSC_LOG%"

IF NOT EXIST "%FSC_HP_Driver_Script%" (
    ECHO. [ERROR] Driver Script not found: %FSC_HP_Driver_Script%
    ECHO. [ERROR] Driver Script not found: %FSC_HP_Driver_Script%>>"%FSC_LOG%"
    SET "FSC_DRIVER_EXITCODE=2"
    GOTO END
)

CALL "%FSC_HP_Driver_Script%"
SET "FSC_DRIVER_EXITCODE=%ERRORLEVEL%"

ECHO. [DRIVER] ExitCode     : %FSC_DRIVER_EXITCODE%>>"%FSC_LOG%"

GOTO END


:: =============================================================================
:: [07] NO SUPPORTED DRIVER MAPPING
:: =============================================================================

:ERROR

COLOR 4E

ECHO.
ECHO. No supported HP Driver Mapping found for:
ECHO. %SystemProductName%
ECHO.

ECHO.>>"%FSC_LOG%"
ECHO. [ERROR] No supported HP Driver Mapping found for: %SystemProductName%>>"%FSC_LOG%"

SET "FSC_DRIVER_EXITCODE=1"


:: =============================================================================
:: [08] FINALIZATION
:: =============================================================================

:END

SET "NT=%TIME: =0%"
SET "NT=%NT:~0,8%"

REG ADD "%FSC_REG%\%FSC_SCRIPT_NAME%" /v "End" /t REG_SZ /d "%DATE% %NT%" /f >NUL 2>&1
REG ADD "%FSC_REG%\%FSC_SCRIPT_NAME%" /v "ExitCode" /t REG_SZ /d "%FSC_DRIVER_EXITCODE%" /f >NUL 2>&1

popd
endlocal & EXIT /B 0


:: =============================================================================
:: LEGACY / DEAKTIVIERT
:: -----------------------------------------------------------------------------
:: Der folgende HP830 Block bleibt zu Dokumentationszwecken erhalten.
:: 830 und 860 verwenden aktuell bewusst denselben G10/860 Treibersatz.
:: Der aktive Sprung lautet deshalb:
::
::     IF /I "%%A"=="830" GOTO HP860
::
:: =============================================================================

:: :HP830
:: SET "MODELL=830"
:: SET "Driver_Source=%USB-Stick-Path%\_Drivers\HP\G10\830"
:: SET "FSC_HP_Driver_Script=%Driver_Source%\G10_830_Drivers_Hp.cmd"
:: GOTO FSC_Driver_Start
