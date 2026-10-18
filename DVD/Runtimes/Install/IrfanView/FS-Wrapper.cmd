@echo off
SET "Namex=IrfanView"
SET "SETUPName=iview476g_x64_setup"
SET "PlugInName=iview476_plugins_x64_setup"

Title Bitte warten - %Namex% Installation...

@MODE CON: COLS=60 LINES=6
setlocal

@echo. 
@echo.  ==============================================
@echo.   Bitte warte bis %Namex% Installiert wurde
@echo.  ==============================================

"%~dp0%SETUPName%.exe" /silent /group=1 /allusers=1
"%~dp0%PlugInName%.exe" /silent /allusers=1

REM ============================================================
REM CleanUp
REM ============================================================

SET "STM=%ProgramData%\Microsoft\Windows\Start Menu\Programs\%Namex%"

del /f /q "%STM%\*ber*"
del /f /q "%STM%\*PlugIns*"
del /f /q "%STM%\*Sprachen*"
del /f /q "%STM%\*neu*"
del /f /q "%STM%\*deinstallieren*"
del /f /q "%STM%\*Kommand*"

endlocal
exit /b 0
