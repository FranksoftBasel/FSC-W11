@echo off
setlocal EnableExtensions DisableDelayedExpansion

:: ============================================================================
:: Franksoft Client (FSC) - HP G08 Driver Installation
:: ============================================================================
:: File        : HP_G08_Drivers.cmd
:: Version     : 1.6
:: Date        : 19.10.2026
:: Author      : Franksoft
:: Target      : HP EliteBook 8 G08 / Windows 11
::
:: Purpose     : Test the actual RETURN time and ExitCode of each install.cmd.
::               Only install.cmd in FIRST-LEVEL driver folders is executed.
::               No additional WAIT mechanism; original CALL is retained.
::
:: Changelog:
:: v1.6 Final - 18.10.2026
:: v1.4 DEBUG - 18.10.2026
:: - Summary at end of console and debug log: Anzahl, Zeit, Errors, Success
:: - Includes Audio in total count and result statistics
:: - Intel NPU ExitCode 14 / MSI 3010 = success with reboot required
:: - Keep raw non-zero count for diagnostics; no forced WAIT added
:: v1.3 DEBUG - 16.10.2026
:: - START/RETURN timestamp, duration and raw ExitCode for every install.cmd
:: - FIRST folder level only; deeper install.cmd files are not called directly
:: - Record directories without install.cmd as SKIP
:: - Separate debug log; existing FSC production log remains untouched
:: - Current G08 Realtek audio installer retained (sp174331_Audio.exe)
:: - No PowerShell Start-Process -Wait and no forced pauses
:: ============================================================================

:: Audio Driver
:: 
set "FSC_AUDIO=sp174165_Audio.exe"

set "FSC_ROOT=%~dp0"
set "FSC_LOG_DIR=%ProgramData%\Franksoft\Logs"
set "FSC_LOG=%FSC_LOG_DIR%\FSC-Drivers-HP-G08.log"
set /a FSC_TOTAL=0, FSC_SKIPPED=0, FSC_NONZERO=0, FSC_SUCCESS=0, FSC_ERRORS=0, FSC_REBOOT=0, FSC_AUDIO_TOTAL=0, FSC_AUDIO_SKIPPED=0 >nul

if not exist "%FSC_LOG_DIR%" md "%FSC_LOG_DIR%" >nul 2>&1
if not exist "%FSC_LOG_DIR%" (
    echo [ERROR] Cannot create the log folder: "%FSC_LOG_DIR%"
    endlocal & exit /b 3
)

:: No automatic UAC relaunch: a debug run must stay in this console.
openfiles >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Administrator rights required. Open CMD as Administrator.
    >>"%FSC_LOG%" echo [ERROR] %DATE% %TIME% - No administrator rights
    endlocal & exit /b 5
)

for /f "tokens=3*" %%A in ('reg query "HKLM\HARDWARE\DESCRIPTION\System\BIOS" /v "SystemProductName" 2^>nul ^| findstr /i "SystemProductName"') do set "FSC_MODEL=%%A %%B"
if not defined FSC_MODEL set "FSC_MODEL=Unknown"

TITLE FSC HP G08 Driver - %FSC_MODEL%

echo.
echo ============================================================================
echo  Franksoft Client - HP G08 Driver Installation
echo ============================================================================
echo  Model : %FSC_MODEL%
echo  Root  : %FSC_ROOT%
echo  Log   : %FSC_LOG%
echo  Time  : %DATE% %TIME%
echo ============================================================================
echo.

>>"%FSC_LOG%" echo.
>>"%FSC_LOG%" echo ============================================================================
>>"%FSC_LOG%" echo [RUN] %DATE% %TIME% - %~nx0
>>"%FSC_LOG%" echo [MODEL] %FSC_MODEL%
>>"%FSC_LOG%" echo [ROOT] %FSC_ROOT%
>>"%FSC_LOG%" echo ============================================================================

:: ==========================================================================
:: Run timer - calculated using Windows CMD only (no PowerShell or WMI)
set "FSC_RUN_START_TIME=%TIME: =0%"
call :ToCentiseconds "%FSC_RUN_START_TIME%" FSC_RUN_START_CS

:: [01] DRIVER INSTALLATIONS - ONLY IMMEDIATE CHILD DIRECTORIES
:: ==========================================================================
:: Note: CALL waits until the respective batch file has returned.
::       Separately launched installation processes may outlive the batch.

pushd "%FSC_ROOT%"
if errorlevel 1 (
    echo [ERROR] Cannot access: "%FSC_ROOT%"
    >>"%FSC_LOG%" echo [ERROR] Could not access "%FSC_ROOT%"
    endlocal & exit /b 4
)

for /d %%D in ("%FSC_ROOT%*") do (
    if exist "%%~fD\install.cmd" (
        call :RunDriver "%%~fD\install.cmd"
    ) else (
        echo [SKIP  ] No install.cmd: "%%~fD"
        >>"%FSC_LOG%" echo [SKIP  ] No install.cmd: "%%~fD"
        set /a FSC_SKIPPED+=1 >nul
    )
)

:: ==========================================================================
:: [02] AUDIO - SAME COMMAND LINE AS CURRENT G08 SCRIPT
:: ==========================================================================
:: Current source audio SoftPaq: sp174331_Audio.exe
:: Do not replace by a different installer during this debug run.

cd /d "%FSC_ROOT%"
if exist "%FSC_ROOT%%FSC_AUDIO%" (
    call :RunAudio "%FSC_ROOT%%FSC_AUDIO%"
) else (
    set /a FSC_AUDIO_SKIPPED+=1 >nul
    echo [AUDIO ] SKIP - "%FSC_AUDIO%" not found in driver root
    >>"%FSC_LOG%" echo [AUDIO ] SKIP - "%FSC_AUDIO%" not found in driver root
)

:: ==========================================================================
:: [03] SUMMARY - EXECUTED PACKAGES INCLUDING AUDIO
:: ==========================================================================
set "FSC_RUN_END_TIME=%TIME: =0%"
call :ToCentiseconds "%FSC_RUN_END_TIME%" FSC_RUN_END_CS
set /a "FSC_RUN_CS=FSC_RUN_END_CS-FSC_RUN_START_CS" >nul
if %FSC_RUN_CS% LSS 0 set /a "FSC_RUN_CS+=8640000" >nul
set /a "FSC_RUN_H=FSC_RUN_CS/360000" >nul
set /a "FSC_RUN_M=(FSC_RUN_CS%%360000)/6000" >nul
set /a "FSC_RUN_S=(FSC_RUN_CS%%6000)/100" >nul
set /a "FSC_RUN_C=FSC_RUN_CS%%100" >nul
set "FSC_RUN_H=0%FSC_RUN_H%"
set "FSC_RUN_M=0%FSC_RUN_M%"
set "FSC_RUN_S=0%FSC_RUN_S%"
set "FSC_RUN_C=0%FSC_RUN_C%"
set "FSC_RUN_DURATION=%FSC_RUN_H:~-2%:%FSC_RUN_M:~-2%:%FSC_RUN_S:~-2%.%FSC_RUN_C:~-2%"
set /a "FSC_COUNT=FSC_TOTAL+FSC_AUDIO_TOTAL" >nul

echo.
echo ------------------------------------------------------------
echo  Franksoft Client - HP G08 Driver - SUMMARY
echo ------------------------------------------------------------
echo  Anzahl .......... %FSC_COUNT%  ^(%FSC_TOTAL% install.cmd + %FSC_AUDIO_TOTAL% Audio^)
echo  Zeit ............ %FSC_RUN_DURATION%
echo  Errors .......... %FSC_ERRORS%
echo  Success ......... %FSC_SUCCESS%
echo  Reboot .......... %FSC_REBOOT%  ^(in Success enthalten^)
echo  Skip ............ %FSC_SKIPPED% Ordner / %FSC_AUDIO_SKIPPED% Audio
echo  NonZero ......... %FSC_NONZERO%  ^(inkl. Reboot-Codes^)
echo  Log ............. %FSC_LOG%
echo ------------------------------------------------------------

>>"%FSC_LOG%" echo [DONE  ] %DATE% %FSC_RUN_END_TIME%
>>"%FSC_LOG%" echo ------------------------------------------------------------
>>"%FSC_LOG%" echo  Franksoft Client - HP G08 Driver DEBUG - SUMMARY
>>"%FSC_LOG%" echo ------------------------------------------------------------
>>"%FSC_LOG%" echo  Anzahl .......... %FSC_COUNT%  ^(%FSC_TOTAL% install.cmd + %FSC_AUDIO_TOTAL% Audio^)
>>"%FSC_LOG%" echo  Zeit ............ %FSC_RUN_DURATION%
>>"%FSC_LOG%" echo  Errors .......... %FSC_ERRORS%
>>"%FSC_LOG%" echo  Success ......... %FSC_SUCCESS%
>>"%FSC_LOG%" echo  Reboot .......... %FSC_REBOOT%  ^(in Success enthalten^)
>>"%FSC_LOG%" echo  Skip ............ %FSC_SKIPPED% Ordner / %FSC_AUDIO_SKIPPED% Audio
>>"%FSC_LOG%" echo  NonZero ......... %FSC_NONZERO%  ^(inkl. Reboot-Codes^)
>>"%FSC_LOG%" echo ------------------------------------------------------------

popd
endlocal & exit /b 0

:: ==========================================================================
:: [04] RUN ONE INSTALL.CMD AND TRACE THE RETURN
:: ==========================================================================
:RunDriver
set /a FSC_TOTAL+=1 >nul
setlocal DisableDelayedExpansion
set "FSC_ITEM=%~1"
set "FSC_START_TIME=%TIME: =0%"
call :ToCentiseconds "%FSC_START_TIME%" FSC_START_CS

echo [START ] %DATE% %FSC_START_TIME% - "%FSC_ITEM%"
>>"%FSC_LOG%" echo [START ] %DATE% %FSC_START_TIME% - "%FSC_ITEM%"

:: The original synchronous CMD call is retained, not replaced.
call "%FSC_ITEM%"
set "FSC_RC=%ERRORLEVEL%"
set "FSC_END_TIME=%TIME: =0%"
call :ToCentiseconds "%FSC_END_TIME%" FSC_END_CS
set /a "FSC_ELAPSED=FSC_END_CS-FSC_START_CS"
if %FSC_ELAPSED% LSS 0 set /a "FSC_ELAPSED+=8640000"
set /a "FSC_SECONDS=FSC_ELAPSED/100"
set /a "FSC_CENTI=FSC_ELAPSED-FSC_SECONDS*100"
set "FSC_PAD=0%FSC_CENTI%"
set "FSC_PAD=%FSC_PAD:~-2%"

echo [RETURN] %DATE% %FSC_END_TIME% - ExitCode=%FSC_RC% - Duration=%FSC_SECONDS%.%FSC_PAD%s - "%FSC_ITEM%"
>>"%FSC_LOG%" echo [RETURN] %DATE% %FSC_END_TIME% - ExitCode=%FSC_RC% - Duration=%FSC_SECONDS%.%FSC_PAD%s - "%FSC_ITEM%"

:: A successful non-zero code may indicate a pending reboot.
:: Intel NPU ExitCode 14 has been verified as "success, restart required".
:: 3010 is the standard MSI "success, restart required" code.
set "FSC_RESULT=ERROR"
if "%FSC_RC%"=="0" set "FSC_RESULT=SUCCESS"
if "%FSC_RC%"=="3010" set "FSC_RESULT=REBOOT"
if "%FSC_RC%"=="14" if /I "%~dp1"=="%FSC_ROOT%sp163162_NPU_FS\" set "FSC_RESULT=REBOOT"
echo [RESULT] %FSC_RESULT% - ExitCode=%FSC_RC% - "%FSC_ITEM%"
>>"%FSC_LOG%" echo [RESULT] %FSC_RESULT% - ExitCode=%FSC_RC% - "%FSC_ITEM%"
endlocal & call :RegisterResult "%FSC_RESULT%" "%FSC_RC%"
exit /b 0

:: ==========================================================================
:: [05] AUDIO TRACE
:: ==========================================================================
:RunAudio
set /a FSC_AUDIO_TOTAL+=1 >nul
setlocal DisableDelayedExpansion
set "FSC_AUDIO_FILE=%~1"
set "FSC_START_TIME=%TIME: =0%"
call :ToCentiseconds "%FSC_START_TIME%" FSC_START_CS

echo [AUDIO START ] %DATE% %FSC_START_TIME% - "%FSC_AUDIO_FILE%"
>>"%FSC_LOG%" echo [AUDIO START ] %DATE% %FSC_START_TIME% - "%FSC_AUDIO_FILE%"

"%FSC_AUDIO_FILE%" /s /e cmd.exe /a /c ""HPUP.exe""
set "FSC_RC=%ERRORLEVEL%"
set "FSC_END_TIME=%TIME: =0%"
call :ToCentiseconds "%FSC_END_TIME%" FSC_END_CS
set /a "FSC_ELAPSED=FSC_END_CS-FSC_START_CS"
if %FSC_ELAPSED% LSS 0 set /a "FSC_ELAPSED+=8640000"
set /a "FSC_SECONDS=FSC_ELAPSED/100"
set /a "FSC_CENTI=FSC_ELAPSED-FSC_SECONDS*100"
set "FSC_PAD=0%FSC_CENTI%"
set "FSC_PAD=%FSC_PAD:~-2%"

echo [AUDIO RETURN] %DATE% %FSC_END_TIME% - ExitCode=%FSC_RC% - Duration=%FSC_SECONDS%.%FSC_PAD%s
>>"%FSC_LOG%" echo [AUDIO RETURN] %DATE% %FSC_END_TIME% - ExitCode=%FSC_RC% - Duration=%FSC_SECONDS%.%FSC_PAD%s
set "FSC_RESULT=ERROR"
if "%FSC_RC%"=="0" set "FSC_RESULT=SUCCESS"
if "%FSC_RC%"=="3010" set "FSC_RESULT=REBOOT"
echo [AUDIO RESULT] %FSC_RESULT% - ExitCode=%FSC_RC%
>>"%FSC_LOG%" echo [AUDIO RESULT] %FSC_RESULT% - ExitCode=%FSC_RC%
endlocal & call :RegisterResult "%FSC_RESULT%" "%FSC_RC%"
exit /b 0

:: ==========================================================================
:: [06] UPDATE SUMMARY COUNTERS
:: ==========================================================================
:RegisterResult
if not "%~2"=="0" set /a FSC_NONZERO+=1 >nul
if /I "%~1"=="SUCCESS" set /a FSC_SUCCESS+=1 >nul
if /I "%~1"=="REBOOT" set /a FSC_SUCCESS+=1, FSC_REBOOT+=1 >nul
if /I "%~1"=="ERROR" set /a FSC_ERRORS+=1 >nul
exit /b 0

:: ==========================================================================
:: [07] CONVERT HH:MM:SS.CC TO CENTISECONDS (PURE CMD)
:: ==========================================================================
:ToCentiseconds
setlocal
set "FSC_CS=0"
for /f "tokens=1-4 delims=:." %%H in ("%~1") do (
    set /a "FSC_CS=(1%%H-100)*360000+(1%%I-100)*6000+(1%%J-100)*100+(1%%K-100)" >nul
)
endlocal & set "%~2=%FSC_CS%"
exit /b 0
