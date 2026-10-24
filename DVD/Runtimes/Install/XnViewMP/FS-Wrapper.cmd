@echo off

:: =========================================================
:: OPTIONAL START MINIMIZED
:: =========================================================
if not "%1"=="7" start /min cmd /c ""%~0" 7 %*" & exit /b

SET "NAME=XnView MP"
SET "INSTALLER=XnViewMP-win-x64_v1.12.1"

Title Bitte warten - %Namex% Installation...

@MODE CON: COLS=60 LINES=6
setlocal

@echo. 
@echo.  ==============================================
@echo.   Bitte warte bis %Namex% Installiert wurde
@echo.  ==============================================


"%~dp0%INSTALLER%.exe" /Silent /LOADINF="FS-Wrapper.inf" /MERGETASKS=!desktopicon



Pushd "%~dp0"

IF NOT Exist "%AppData%\XnViewMP" MD "%AppData%\XnViewMP"
copy CU\xnview.ini "%AppData%\XnViewMP" 


REM ============================================================
REM CleanUp
REM ============================================================

SET "STM=C:\ProgramData\Microsoft\Windows\Start Menu\Programs\XnView MP"
SET "STM2=C:\ProgramData\Microsoft\Windows\Start Menu\Programs"

copy "%STM%\%Namex%.lnk" "%STM2%" /Y
RD /S/Q "%STM%"
del /F/Q "%Public%\Desktop\XnView MP.lnk"

endlocal
exit /b 0
