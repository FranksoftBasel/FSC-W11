@echo off
SET Namex=XnView MP

Title Bitte warten - %Namex% Installation...

@MODE CON: COLS=60 LINES=6
setlocal

@echo. 
@echo.  ==============================================
@echo.   Bitte warte bis %Namex% Installiert wurde
@echo.  ==============================================


"%~dp0XnViewMP-win-x64.exe" /Silent /LOADINF="FS-Wrapper.inf"

copy CU\xnview.ini "%AppData%\XnViewMP" 


REM ============================================================
REM CleanUp
REM ============================================================

SET "STM=C:\ProgramData\Microsoft\Windows\Start Menu\Programs\XnView MP"
SET "STM2=C:\ProgramData\Microsoft\Windows\Start Menu\Programs"

copy "%STM%\%Namex%.lnk" "%STM2%" /Y
RD /S/Q "%STM%"

endlocal
exit /b 0
