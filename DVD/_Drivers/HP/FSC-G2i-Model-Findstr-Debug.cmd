@echo off
setlocal EnableExtensions DisableDelayedExpansion
chcp 850 >nul
TITLE Franksoft Client - G2i Model FINDSTR Debug

:: =============================================================================
:: Franksoft Client - G2i Model FINDSTR Debug
:: Version : 1.0
:: Purpose : Modellnamen aus der FSC-Registry-Quelle anzeigen und drei
::           FINDSTR-Varianten pruefen. Keine Treiberinstallation.
:: =============================================================================

set "REG_PATH=HKLM\SYSTEM\HardwareConfig\Current"
set "MODEL="

for /f "tokens=2,*" %%A in ('reg query "%REG_PATH%" /v "SystemProductName" 2^>nul') do (
    if /i "%%A"=="REG_SZ" set "MODEL=%%B"
)

echo.
echo ================================================================
echo  Franksoft Client - G2i Model FINDSTR Debug
echo ================================================================
echo  Quelle : %REG_PATH%
if not defined MODEL (
    echo  [ERROR] SystemProductName wurde nicht gefunden.
    echo ================================================================
    pause
    endlocal & exit /b 2
)
echo  Modell : "%MODEL%"
echo ================================================================
echo.

:: 1: Urspruengliche spezifische Flip-Erkennung
 echo(%MODEL% | findstr /I /C:"EliteBook 8 Flip G2i" >nul
set "RC1=%ERRORLEVEL%"
if "%RC1%"=="0" (echo  [MATCH]   1. EliteBook 8 Flip G2i) else (echo  [NO MATCH] 1. EliteBook 8 Flip G2i  [RC=%RC1%])

:: 2: Alte Abfrage vor v2.8
 echo(%MODEL% | findstr /I /C:"EliteBook 8 G2i" >nul
set "RC2=%ERRORLEVEL%"
if "%RC2%"=="0" (echo  [MATCH]   2. EliteBook 8 G2i) else (echo  [NO MATCH] 2. EliteBook 8 G2i  [RC=%RC2%])

:: 3: Aktuelle Root-Abfrage (v2.8)
 echo(%MODEL% | findstr /I /C:"G2i" >nul
set "RC3=%ERRORLEVEL%"
if "%RC3%"=="0" (echo  [MATCH]   3. G2i) else (echo  [NO MATCH] 3. G2i  [RC=%RC3%])

echo.
echo  FINDSTR: RC 0 = Treffer, RC 1 = kein Treffer, RC 2 = Fehler
echo  Es wurden keine Treiber oder Systemeinstellungen veraendert.
echo ================================================================
echo.
pause
endlocal & exit /b 0
