@echo off
setlocal EnableExtensions EnableDelayedExpansion

:: ============================================================
:: Franksoft Boot (FSB)
:: Windows Setup Launcher - Outside ISO / Ventoy WIMBOOT
:: ============================================================
::
:: Purpose:
::   Starts Windows Setup from the unpacked MCT/FSC structure
::   on the FSB data partition and explicitly supplies
::   autounattend.xml.
::
:: Boot path:
::   Ventoy -> FSC-Setup.wim -> startnet.cmd
::          -> find FSB -> setup.exe /unattend
::
:: Expected FSB structure:
::   \autounattend.xml
::   \setup.exe
::   \sources\boot.wim
::
:: DEBUG:
::   1 = detailed output + pause before Windows Setup
::   0 = automatic execution
::
:: ============================================================

set "DEBUG=0"
set "FSB="

echo.
echo ============================================================
echo  Franksoft Boot - Windows Setup Launcher
echo ============================================================
echo.
echo DEBUG = %DEBUG%
echo.

echo [INFO] Initialisiere WinPE...
wpeinit

if "%DEBUG%"=="1" (
    echo [DEBUG] wpeinit beendet.
    echo.
)

echo [INFO] Suche FSB...

for %%D in (C D E F G H I J K L M N O P Q R S T U V W Y Z) do (
    if "%DEBUG%"=="1" echo [DEBUG] Pruefe %%D:\

    if exist "%%D:\autounattend.xml" (
        if exist "%%D:\setup.exe" (
            if exist "%%D:\sources\boot.wim" (
                set "FSB=%%D:"
                goto :FSB_FOUND
            )
        )
    )
)

echo.
echo [FEHLER] FSB wurde nicht gefunden.
echo.
echo Erwartete Dateien:
echo   \autounattend.xml
echo   \setup.exe
echo   \sources\boot.wim
echo.
echo Verfuegbare Laufwerke:
for %%D in (C D E F G H I J K L M N O P Q R S T U V W Y Z) do (
    if exist "%%D:\" echo   %%D:\
)
echo.
echo CMD bleibt fuer Debugging offen.
cmd.exe
goto :END

:FSB_FOUND
echo.
echo [OK] FSB gefunden: !FSB!
echo.

if "%DEBUG%"=="1" (
    echo ============================================================
    echo  DEBUG INFORMATION
    echo ============================================================
    echo.
    echo FSB:       !FSB!
    echo Setup:     !FSB!\setup.exe
    echo Unattend:  !FSB!\autounattend.xml
    echo Boot WIM:  !FSB!\sources\boot.wim
    echo.
    echo ------------------------------------------------------------
    echo Root-Verzeichnis:
    echo ------------------------------------------------------------
    dir "!FSB!\"
    echo.
    echo ------------------------------------------------------------
    echo Sources:
    echo ------------------------------------------------------------
    dir "!FSB!\sources"
    echo.
    echo ============================================================
    echo  ENTER = Windows Setup starten
    echo ============================================================
    pause
)

echo.
echo [INFO] Starte Windows Setup...
echo "!FSB!\setup.exe" /unattend:"!FSB!\autounattend.xml"
echo.

"!FSB!\setup.exe" /unattend:"!FSB!\autounattend.xml"
set "SETUP_RC=!ERRORLEVEL!"

echo.
echo [INFO] Windows Setup Rueckgabecode: !SETUP_RC!
echo.

if not "!SETUP_RC!"=="0" (
    echo [FEHLER] Windows Setup konnte nicht korrekt gestartet werden.
    echo.
    cmd.exe
)

:END
endlocal
