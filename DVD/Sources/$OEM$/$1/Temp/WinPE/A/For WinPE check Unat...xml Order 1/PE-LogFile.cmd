@echo off
:: Purp...: FS PE Log Gen
:: Version: 1.0b
:: Date...: 06.03.2025

:: SET NT=%TIME: =0%
SET OutFile=%~dp0Windows Setup Log_%DATE%.log
FOR /F "tokens=1-3 delims=:.," %%A IN ("%TIME%") DO SET NT=%%A:%%B:%%C

:: Prüfen, ob ein Parameter übergeben wurde
if "%1"=="" goto Hilfe

:: Sprung zu den entsprechenden Abschnitten basierend auf dem Parameter
if "%1"=="A" goto AbschnittA
if "%1"=="B" goto AbschnittB
if "%1"=="C" goto AbschnittC
if "%1"=="D" goto AbschnittD
if "%1"=="E" goto AbschnittE
if "%1"=="F" goto AbschnittF
if "%1"=="G" goto AbschnittG

:: Falls kein gültiger Parameter übergeben wurde, Hilfe anzeigen
goto Hilfe

:AbschnittA

@Echo. >>"%OutFile%"
@Echo. *** Franksoft Windows Setup Phases Logging start ***>>"%OutFile%"
@Echo. >>"%OutFile%"
@Echo. Script: %~f0 >>"%OutFile%"
@Echo. Date..: %DATE% >>"%OutFile%"
@Echo. Time..: %NT%>>"%OutFile%"
@Echo. >>"%OutFile%"

@Echo. Windows Setup: 1 windowsPE Phase started  %NT%>>"%OutFile%"
goto Ende

:AbschnittB
goto Ende

:AbschnittC
@Echo. Windows Setup: 3 generalize Phase started %NT%>>"%OutFile%"
goto Ende

:AbschnittD
@Echo. Windows Setup: 4 specialize Phase started %NT%>>"%OutFile%"
goto Ende

:AbschnittE
@Echo. Windows Setup: 5 auditSystem Phase start  %NT%>>"%OutFile%"
goto Ende

:AbschnittF
@Echo. Windows Setup: 6 auditUser Phase started  %NT%>>"%OutFile%"
goto Ende

:AbschnittG
@Echo. Windows Setup: 7 oobeSystem Phase started %NT%>>"%OutFile%"
@Echo. >>"%OutFile%"

@Echo. Date..: %DATE% >>"%OutFile%"
@Echo. Time..: %NT%>>"%OutFile%"

@Echo. >>"%OutFile%"
@Echo. *** Franksoft Windows Setup Phases Logging end ***>>"%OutFile%"
goto Ende


:Hilfe
echo Nutzung: %~nx0 [A|B|C|D|E]
echo Beispiel: %~nx0 A (springt zu Abschnitt A)
goto Ende

:Ende
exit /b
