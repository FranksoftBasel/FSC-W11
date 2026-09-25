@echo off
setlocal EnableExtensions
chcp 850 >nul

SET FSC_PHASE=00/06

:: =============================================================================
:: Script Name : PE-LogFile.cmd
:: Version     : 1.6
:: Date        : 17.06.2026
:: Author      : Franksoft
::
:: Purpose     : Mini Windows Setup Log + Registry Tracking
:: -----------------------------------------------------------------------------
:: Phase A / 01 windowsPE schreibt Transfer-Datei
:: Phase D / 04 specialize liest Transfer-Datei und schreibt Start + Phase 01 + Phase 04
:: Phase G / 07 oobeSystem schreibt End
::
:: LogFile     : -%USB-STICK%-\Sources\$OEM$\$1\Temp\WinPE
:: Registry    : HKLM\SOFTWARE\Franksoft\Setup\PE-LogFile.cmd
:: =============================================================================

:: Get Nice Time HH:mm:ss
SET "NT=%TIME: =0%"
SET "NT=%NT:~0,8%"

SET "OutFile=%~dp0Windows Setup Log_%DATE%.log"
SET "FSC_PE_TRANSFER=%~dp0FSC_PE_Phase01.txt"

SET "FSC_SCRIPT_NAME=%~nx0"
SET "FSC_SCRIPT_PATH=%~f0"
SET "FSC_REG=HKLM\SOFTWARE\Franksoft\Setup"

:: =============================================================================
:: Parameter pr�fen
:: =============================================================================
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

@Echo. Windows Setup Time - %NT% - Phase 01/07 windowsPE>>"%OutFile%"

:: -----------------------------------------------------------------------------
:: Phase 01 Transfer-Datei schreiben
:: Diese Datei wird in Phase 04 wieder gelesen und danach gel�scht.
:: -----------------------------------------------------------------------------
> "%FSC_PE_TRANSFER%" echo Phase01Date=%DATE%
>>"%FSC_PE_TRANSFER%" echo Phase01Time=%NT%
>>"%FSC_PE_TRANSFER%" echo Phase01Stamp=%DATE% %NT%
>>"%FSC_PE_TRANSFER%" echo ScriptName=%FSC_SCRIPT_NAME%
>>"%FSC_PE_TRANSFER%" echo ScriptPath=%FSC_SCRIPT_PATH%

:: @Echo. PE Transfer File geschrieben: %FSC_PE_TRANSFER%>>"%OutFile%"

goto Ende

:AbschnittB
@Echo. Windows Setup Time - %NT% - Phase 02/07 offlineServicing>>"%OutFile%"

reg add "%FSC_REG%\%FSC_SCRIPT_NAME%" /f >nul 2>nul
reg add "%FSC_REG%\%FSC_SCRIPT_NAME%" /v "Phase 02/07 offlineServicing" /t REG_SZ /d "%DATE% %NT%" /f >nul 2>nul

goto Ende


:AbschnittC
@Echo. Windows Setup Time - %NT% - Phase 03/07 generalize>>"%OutFile%"

reg add "%FSC_REG%\%FSC_SCRIPT_NAME%" /f >nul 2>nul
reg add "%FSC_REG%\%FSC_SCRIPT_NAME%" /v "Phase 03/07 generalize" /t REG_SZ /d "%DATE% %NT%" /f >nul 2>nul

goto Ende


:AbschnittD
@Echo. Windows Setup Time - %NT% - Phase 04/07 specialize>>"%OutFile%"

SET "FSC_PHASE01_STAMP="
SET "FSC_PHASE01_SCRIPT="
SET "FSC_PHASE01_PATH="

if exist "%FSC_PE_TRANSFER%" (
    for /f "tokens=1,* delims==" %%A in ('type "%FSC_PE_TRANSFER%"') do (
        if /I "%%A"=="Phase01Stamp" set "FSC_PHASE01_STAMP=%%B"
        if /I "%%A"=="ScriptName" set "FSC_PHASE01_SCRIPT=%%B"
        if /I "%%A"=="ScriptPath" set "FSC_PHASE01_PATH=%%B"
    )
) else (
    @Echo. WARNUNG: PE Transfer File NICHT gefunden: %FSC_PE_TRANSFER%>>"%OutFile%"
)

reg add "%FSC_REG%\%FSC_SCRIPT_NAME%" /f >nul 2>nul
reg add "%FSC_REG%\%FSC_SCRIPT_NAME%" /v "Script Name" /t REG_SZ /d "%FSC_SCRIPT_NAME%" /f >nul 2>nul
reg add "%FSC_REG%\%FSC_SCRIPT_NAME%" /v "Script Path" /t REG_SZ /d "%FSC_SCRIPT_PATH%" /f >nul 2>nul

if defined FSC_PHASE01_STAMP (
    reg add "%FSC_REG%\%FSC_SCRIPT_NAME%" /v "Start" /t REG_SZ /d "%FSC_PHASE01_STAMP%" /f >nul 2>nul
    reg add "%FSC_REG%\%FSC_SCRIPT_NAME%" /v "Phase 01/07 windowsPE" /t REG_SZ /d "%FSC_PHASE01_STAMP%" /f >nul 2>nul
) else (
    @Echo. WARNUNG: Phase01Stamp leer, Start/Phase 01 nicht geschrieben>>"%OutFile%"
)

reg add "%FSC_REG%\%FSC_SCRIPT_NAME%" /v "Phase 04/07 specialize" /t REG_SZ /d "%DATE% %NT%" /f >nul 2>nul
reg add "%FSC_REG%\%FSC_SCRIPT_NAME%" /v "End" /t REG_SZ /d "%DATE% %NT%" /f >nul 2>nul

:: -----------------------------------------------------------------------------
:: PE Transfer-Datei l�schen
:: -----------------------------------------------------------------------------
if exist "%FSC_PE_TRANSFER%" (
    del /f /q "%FSC_PE_TRANSFER%" >nul 2>nul
)

goto Ende


:AbschnittE
@Echo. Windows Setup Time - %NT% - Phase 05/07 auditSystem>>"%OutFile%"

reg add "%FSC_REG%\%FSC_SCRIPT_NAME%" /f >nul 2>nul
reg add "%FSC_REG%\%FSC_SCRIPT_NAME%" /v "Phase 05/07 auditSystem" /t REG_SZ /d "%DATE% %NT%" /f >nul 2>nul

goto Ende


:AbschnittF
@Echo. Windows Setup Time - %NT% - Phase 06/07 auditUser>>"%OutFile%"

reg add "%FSC_REG%\%FSC_SCRIPT_NAME%" /f >nul 2>nul
reg add "%FSC_REG%\%FSC_SCRIPT_NAME%" /v "Phase 06/07 auditUser" /t REG_SZ /d "%DATE% %NT%" /f >nul 2>nul

goto Ende


:AbschnittG
@Echo. Windows Setup Time - %NT% - Phase 07/07 oobeSystem End>>"%OutFile%"
@Echo.>>"%OutFile%"
@Echo. Date..: %DATE%>>"%OutFile%"
@Echo. Time..: %NT%>>"%OutFile%"

reg add "%FSC_REG%\%FSC_SCRIPT_NAME%" /f >nul 2>nul
reg add "%FSC_REG%\%FSC_SCRIPT_NAME%" /v "Phase 07/07 oobeSystem End" /t REG_SZ /d "%DATE% %NT%" /f >nul 2>nul
reg add "%FSC_REG%\%FSC_SCRIPT_NAME%" /v "End" /t REG_SZ /d "%DATE% %NT%" /f >nul 2>nul

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
