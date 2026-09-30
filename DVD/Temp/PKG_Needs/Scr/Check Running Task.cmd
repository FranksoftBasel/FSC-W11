@echo off
color 1f

SET TL=PROCESS MONITOR

Title %TL%

set "INPUT1=HPUP.exe"
set "INPUT2=setup.exe"
set "COUNT=0"
set "STARTTIME=%time:~0,-3%"

:start
set /a COUNT+=1
cls

echo ==========================================
echo   %TL%
echo ==========================================
powershell -NoProfile -Command "Write-Host '  Process 1 : %INPUT1%' -ForegroundColor Green"
powershell -NoProfile -Command "Write-Host '  Process 2 : %INPUT2%' -ForegroundColor Green"
echo   Start Time: %STARTTIME%
echo   Current   : %time:~0,-3%
powershell -NoProfile -Command "Write-Host '  Loops     : %COUNT%' -ForegroundColor Red"
echo ==========================================
echo.

tasklist /FI "IMAGENAME eq %INPUT1%" /NH
tasklist /FI "IMAGENAME eq %INPUT2%" /NH

timeout /t 5
goto start