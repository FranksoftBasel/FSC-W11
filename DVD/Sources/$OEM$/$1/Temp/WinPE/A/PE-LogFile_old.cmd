@echo off
setlocal EnableExtensions
chcp 850 >nul

SET FSC_PHASE=00/06

:: =============================================================================
:: Script Name : PE-LogFile.cmd
:: Version     : 1.4
:: Date        : 17.06.2026
:: Author      : Franksoft
:: =============================================================================

:: Get Nice Time HH:mm:ss
SET "NT=%TIME: =0%"
SET "NT=%NT:~0,8%"

SET "OutFile=%~dp0Windows Setup Log_%DATE%.log"

set "FSC_SCRIPT_NAME=%~nx0"
set "FSC_SCRIPT_PATH=%~f0"

:: Registry Keys
set "FSC_REG_TEMP=HKLM\FSCTEMP"
set "FSC_REG_PE=HKLM\FSCTEMP\Franksoft\Setup"
set "FSC_REG=HKLM\SOFTWARE\Franksoft\Setup"

:: Parameter pruefen
if "%1"=="" goto Hilfe

if /I "%1"=="A" goto AbschnittA
if /I "%1"=="B" goto AbschnittB
if /I "%1"=="C" goto AbschnittC
if /I "%1"=="D" goto AbschnittD
if /I "%1"=="E" goto AbschnittE
if /I "%1"=="F" goto AbschnittF
if /I "%1"=="G" goto AbschnittG

goto Hilfe


:AbschnittA
@Echo. *** Franksoft Windows Setup Logging Started ***>>"%OutFile%"
@Echo.>>"%OutFile%"
@Echo. Script: %FSC_SCRIPT_PATH%>>"%OutFile%"
@Echo. Date..: %DATE%>>"%OutFile%"
@Echo. Time..: %NT%>>"%OutFile%"
@Echo.>>"%OutFile%"

set "FSC_TARGET_DRIVE="
set "FSC_TARGET_HIVE="
set "FSC_HIVE_LOADED=0"

if exist "C:\Windows\System32\Config\SOFTWARE" (
    set "FSC_TARGET_DRIVE=C:"
    set "FSC_TARGET_HIVE=C:\Windows\System32\Config\SOFTWARE"
)

if not defined FSC_TARGET_DRIVE if exist "D:\Windows\System32\Config\SOFTWARE" (
    set "FSC_TARGET_DRIVE=D:"
    set "FSC_TARGET_HIVE=D:\Windows\System32\Config\SOFTWARE"
)

@Echo. Target Drive: %FSC_TARGET_DRIVE%>>"%OutFile%"
@Echo. Target Hive.: %FSC_TARGET_HIVE%>>"%OutFile%"
@Echo.>>"%OutFile%"

if defined FSC_TARGET_HIVE (
    reg load "%FSC_REG_TEMP%" "%FSC_TARGET_HIVE%" >nul 2>nul
    if not errorlevel 1 set "FSC_HIVE_LOADED=1"
)

if "%FSC_HIVE_LOADED%"=="1" (
    reg add "%FSC_REG_PE%\%FSC_SCRIPT_NAME%" /f >nul
    reg add "%FSC_REG_PE%\%FSC_SCRIPT_NAME%" /v "Script Name" /t REG_SZ /d "%FSC_SCRIPT_NAME%" /f >nul
    reg add "%FSC_REG_PE%\%FSC_SCRIPT_NAME%" /v "Script Path" /t REG_SZ /d "%FSC_SCRIPT_PATH%" /f >nul
    reg add "%FSC_REG_PE%\%FSC_SCRIPT_NAME%" /v "Debug Drive" /t REG_SZ /d "%FSC_TARGET_DRIVE%" /f >nul
    reg add "%FSC_REG_PE%\%FSC_SCRIPT_NAME%" /v "Debug Hive" /t REG_SZ /d "%FSC_TARGET_HIVE%" /f >nul
    reg add "%FSC_REG_PE%\%FSC_SCRIPT_NAME%" /v "Start" /t REG_SZ /d "%DATE% %TIME%" /f >nul
    reg add "%FSC_REG_PE%\%FSC_SCRIPT_NAME%" /v "Phase 01/07 windowsPE" /t REG_SZ /d "%DATE% %TIME%" /f >nul
)

@Echo. Windows Setup Time - %NT% - Phase 01/07 windowsPE>>"%OutFile%"

if "%FSC_HIVE_LOADED%"=="1" (
    reg unload "%FSC_REG_TEMP%" >nul 2>nul
)

goto Ende


:AbschnittB
@Echo. Windows Setup Time - %NT% - Phase 02/07 offlineServicing>>"%OutFile%"
reg add "%FSC_REG%\%FSC_SCRIPT_NAME%" /f >nul
reg add "%FSC_REG%\%FSC_SCRIPT_NAME%" /v "Phase 02/07 offlineServicing" /t REG_SZ /d "%DATE% %TIME%" /f >nul
goto Ende


:AbschnittC
@Echo. Windows Setup Time - %NT% - Phase 03/07 generalize>>"%OutFile%"
reg add "%FSC_REG%\%FSC_SCRIPT_NAME%" /f >nul
reg add "%FSC_REG%\%FSC_SCRIPT_NAME%" /v "Phase 03/07 generalize" /t REG_SZ /d "%DATE% %TIME%" /f >nul
goto Ende


:AbschnittD
@Echo. Windows Setup Time - %NT% - Phase 04/07 specialize>>"%OutFile%"
reg add "%FSC_REG%\%FSC_SCRIPT_NAME%" /f >nul
reg add "%FSC_REG%\%FSC_SCRIPT_NAME%" /v "Phase 04/07 specialize" /t REG_SZ /d "%DATE% %TIME%" /f >nul
goto Ende


:AbschnittE
@Echo. Windows Setup Time - %NT% - Phase 05/07 auditSystem>>"%OutFile%"
reg add "%FSC_REG%\%FSC_SCRIPT_NAME%" /f >nul
reg add "%FSC_REG%\%FSC_SCRIPT_NAME%" /v "Phase 05/07 auditSystem" /t REG_SZ /d "%DATE% %TIME%" /f >nul
goto Ende


:AbschnittF
@Echo. Windows Setup Time - %NT% - Phase 06/07 auditUser>>"%OutFile%"
reg add "%FSC_REG%\%FSC_SCRIPT_NAME%" /f >nul
reg add "%FSC_REG%\%FSC_SCRIPT_NAME%" /v "Phase 06/07 auditUser" /t REG_SZ /d "%DATE% %TIME%" /f >nul
goto Ende


:AbschnittG
@Echo. Windows Setup Time - %NT% - Phase 07/07 oobeSystem End>>"%OutFile%"
@Echo.>>"%OutFile%"
@Echo. Date..: %DATE%>>"%OutFile%"
@Echo. Time..: %NT%>>"%OutFile%"

reg add "%FSC_REG%\%FSC_SCRIPT_NAME%" /f >nul
reg add "%FSC_REG%\%FSC_SCRIPT_NAME%" /v "Phase 07/07 oobeSystem End" /t REG_SZ /d "%DATE% %TIME%" /f >nul
reg add "%FSC_REG%\%FSC_SCRIPT_NAME%" /v "End" /t REG_SZ /d "%DATE% %TIME%" /f >nul

goto FS-END


:FS-END
@Echo.>>"%OutFile%"
@Echo. *** Franksoft Windows Setup Logging End ***>>"%OutFile%"

goto Ende


:Hilfe
@Echo.>>"%OutFile%"
@Echo. PE-LogFile.cmd Hilfe>>"%OutFile%"
@Echo. Parameter fehlt oder ist ungueltig.>>"%OutFile%"
@Echo. Gueltig: A B C D E F G>>"%OutFile%"
goto Ende


:Ende
exit /b 0