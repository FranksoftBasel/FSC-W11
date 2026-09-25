@echo off

if not "%1"=="7" start /min cmd /c ""%~0" 7 %*" & exit /b

call :isAdmin

if %errorlevel% == 0 (
    goto :run
) else (
    echo Requesting administrative privileges...
    goto :UACPrompt
)

exit /b

:isAdmin
    fsutil dirty query %systemdrive% >nul
exit /b

:run
pushd "%~dp0"

SET RT=Microsoft.UI.Xaml_8.2310.30001.0_X64_msix_en-US.msix
SET PKG01=Microsoft.WindowsTerminal_1.24.11321.0_8wekyb3d8bbwe.msixbundle

pushd "%~dp0"

powershell -WindowStyle Hidden -NoProfile -ExecutionPolicy Bypass -Command Add-AppxPackage "%RT%"
powershell -WindowStyle Hidden -NoProfile -ExecutionPolicy Bypass -Command Add-AppxPackage "%PKG01%"
:: powershell -WindowStyle Hidden -NoProfile -ExecutionPolicy Bypass -Command Add-AppxPackage "%~dp0Microsoft.UI.Xaml.2.8_8.2310.30001.0_x64.appx"



:: powershell -WindowStyle Hidden -NoProfile -ExecutionPolicy Bypass -Command Add-AppxPackage "%~dp0Microsoft.VCLibs.x64.14.00.Desktop.appx"
:: powershell -NoProfile -ExecutionPolicy Bypass -Command Add-AppxPackage "%~dp0Microsoft.VCLibs.x64.14.00.Desktop.appx"

:: powershell -WindowStyle Hidden -NoProfile -ExecutionPolicy Bypass -Command Add-AppxPackage "%~dp0Microsoft.WindowsTerminal_3001.22.10352.0_neutral_~_8wekyb3d8bbwe.Msixbundle"
:: powershell -NoProfile -ExecutionPolicy Bypass -Command Add-AppxPackage "%~dp0Microsoft.WindowsTerminal_3001.22.10352.0_neutral_~_8wekyb3d8bbwe.Msixbundle"



exit /b

:UACPrompt
   echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
   echo UAC.ShellExecute "cmd.exe", "/c %~s0 %~1", "", "runas", 1 >> "%temp%\getadmin.vbs"

   "%temp%\getadmin.vbs"
del "%temp%\getadmin.vbs"
exit /B`


