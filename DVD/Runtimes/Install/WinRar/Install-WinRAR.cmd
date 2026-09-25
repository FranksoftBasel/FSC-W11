@echo off

Title WinRAR Installation

:: if not "%1"=="7" start /min cmd /c ""%~0" 7 %*" & exit /b

net session >nul 2>&1
if not "%errorlevel%"=="0" (
    echo.
    echo Administratorrechte erforderlich...
    powershell -Command "Start-Process '%~f0' -ArgumentList 'ELEVATED' -Verb RunAs"
    exit /b
)

set "WR_INSTALLER=winrar-x64-723d.exe"
pushd "%~dp0"

regedit /s "WinRAR_CU_CFG.reg"

"%WR_INSTALLER%" /S /ALLUSERS

if exist "rarreg.key" (
    copy /y "rarreg.key" "%ProgramFiles%\WinRAR\" >nul
)

if exist "SetUserFTA.exe" (
    SetUserFTA.exe .rar WinRAR
    SetUserFTA.exe .zip WinRAR
    SetUserFTA.exe .7z WinRAR
)

rd /s /q "%AppData%\Microsoft\Windows\Start Menu\Programs\WinRAR" 2>nul
rd /s /q "%ProgramData%\Microsoft\Windows\Start Menu\Programs\WinRAR" 2>nul

popd
exit /b 0