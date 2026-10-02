@echo off
SET Namex=IrfanView

Title Bitte warten - %Namex% Installation...

@MODE CON: COLS=60 LINES=6
setlocal

@echo. 
@echo.  ==============================================
@echo.   Bitte warte bis %Namex% Installiert wurde
@echo.  ==============================================

"%~dp0iview475g_x64_setup.exe" /silent /group=1 /allusers=1

REM ============================================================
REM CleanUp
REM ============================================================

SET "STM=%ProgramData%\Microsoft\Windows\Start Menu\Programs\%Namex%"


del /f /q "%STM%\Über IrfanView.lnk"
del /f /q "%STM%\Verfügbare PlugIns.lnk"
del /f /q "%STM%\Verfügbare Sprachen.lnk"
del /f /q "%STM%\Was ist neu.lnk"
del /f /q "%STM%\IrfanView deinstallieren.lnk"


endlocal
exit /b 0
