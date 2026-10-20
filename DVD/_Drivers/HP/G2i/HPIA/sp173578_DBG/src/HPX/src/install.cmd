REM Turn off messages displayed on screen while DASH
@echo off
pushd %~dp0
:: ---------------------------------------------------------------------------
:: HPX is a UWP to replace myHP with the same PFN. It is a new "HP App" for Setup, Use and Support of all HP devices.
:: ----------------------------------------------------------------------------

REM Define general info for component
set project_name=HPX

REM Define log folder
set log=%ProgramData%\hp\logs\UWP
if not exist "%log%" md "%log%"
set MyLog=%log%\%project_name%.log
set DismLog=%log%\%project_name%_dism.log
set utilFolder=c:\hp\HPQWare\util


PowerShell.exe -ExecutionPolicy Bypass -File HPXCFG.PS1 
if exist NO_CORP.FLG (
	Echo [%DATE%] [%TIME%] The NO_CORP.FLG exists, it skips myhp installation  >> %MyLog%
	if exist C:\SYSTEM.SAV\TWEAKS (
		Echo [%DATE%] [%TIME%] C:\SYSTEM.SAV\TWEAKS exists, exit b  >> %MyLog%
		popd
		exit /b 0
   )
   Echo [%DATE%] [%TIME%] C:\SYSTEM.SAV\TWEAKS doesn't exists >> %MyLog%
)
Echo [%DATE%] [%TIME%] NO_Corp.flg doesn't exist, it still installs myhp  >> %MyLog%



set CEPS_AppxBundle=/PackagePath:"%~dp0Metro\61881752472146d9971d3985070f2da4.msixbundle"
set CEPS_License=/LicensePath:"%~dp0Metro\61881752472146d9971d3985070f2da4_License1.xml"

REM Define dependency lib full file name and path
set CEPS_ParamDotNet_x64=/DependencyPackagePath:"%~dp0Metro\Microsoft.NET.Native.Framework.2.2_2.2.29512.0_x64__8wekyb3d8bbwe.appx"
set CEPS_ParamDotNet_x86=/DependencyPackagePath:"%~dp0Metro\Microsoft.NET.Native.Framework.2.2_2.2.29512.0_x86__8wekyb3d8bbwe.appx"
set CEPS_ParamDotNet_arm64=/DependencyPackagePath:"%~dp0Metro\Microsoft.NET.Native.Framework.2.2_2.2.29512.0_arm64__8wekyb3d8bbwe.appx"
set CEPS_ParamDotNet_arm=/DependencyPackagePath:"%~dp0Metro\Microsoft.NET.Native.Framework.2.2_2.2.29512.0_arm__8wekyb3d8bbwe.appx"
set CEPS_ParamVCLibs_x64=/DependencyPackagePath:"%~dp0Metro\Microsoft.VCLibs.140.00_14.0.33519.0_x64__8wekyb3d8bbwe.appx"
set CEPS_ParamVCLibs_x86=/DependencyPackagePath:"%~dp0Metro\Microsoft.VCLibs.140.00_14.0.33519.0_x86__8wekyb3d8bbwe.appx"
set CEPS_ParamVCLibs_arm64=/DependencyPackagePath:"%~dp0Metro\Microsoft.VCLibs.140.00_14.0.33519.0_arm64__8wekyb3d8bbwe.appx"
set CEPS_ParamVCLibs_arm=/DependencyPackagePath:"%~dp0Metro\Microsoft.VCLibs.140.00_14.0.33519.0_arm__8wekyb3d8bbwe.appx"
set CEPS_ParamRuntime_x64=/DependencyPackagePath:"%~dp0Metro\Microsoft.NET.Native.Runtime.2.2_2.2.28604.0_x64__8wekyb3d8bbwe.appx"
set CEPS_ParamRuntime_x86=/DependencyPackagePath:"%~dp0Metro\Microsoft.NET.Native.Runtime.2.2_2.2.28604.0_x86__8wekyb3d8bbwe.appx"
set CEPS_ParamRuntime_arm64=/DependencyPackagePath:"%~dp0Metro\Microsoft.NET.Native.Runtime.2.2_2.2.28604.0_arm64__8wekyb3d8bbwe.appx"
set CEPS_ParamRuntime_arm=/DependencyPackagePath:"%~dp0Metro\Microsoft.NET.Native.Runtime.2.2_2.2.28604.0_arm__8wekyb3d8bbwe.appx"
set CEPS_ParamUIXaml_x64=/DependencyPackagePath:"%~dp0Metro\Microsoft.UI.Xaml.2.8_8.2501.31001.0_x64__8wekyb3d8bbwe.appx"
set CEPS_ParamUIXaml_x86=/DependencyPackagePath:"%~dp0Metro\Microsoft.UI.Xaml.2.8_8.2501.31001.0_x86__8wekyb3d8bbwe.appx"
set CEPS_ParamUIXaml_arm64=/DependencyPackagePath:"%~dp0Metro\Microsoft.UI.Xaml.2.8_8.2501.31001.0_arm64__8wekyb3d8bbwe.appx"
set CEPS_ParamUIXaml_arm=/DependencyPackagePath:"%~dp0Metro\Microsoft.UI.Xaml.2.8_8.2501.31001.0_arm__8wekyb3d8bbwe.appx"
set CEPS_ParamVCLibsUWPDesktop_x64=/DependencyPackagePath:"%~dp0Metro\Microsoft.VCLibs.140.00.UWPDesktop_14.0.33728.0_x64__8wekyb3d8bbwe.appx"
set CEPS_ParamVCLibsUWPDesktop_x86=/DependencyPackagePath:"%~dp0Metro\Microsoft.VCLibs.140.00.UWPDesktop_14.0.33728.0_x86__8wekyb3d8bbwe.appx"
set CEPS_ParamVCLibsUWPDesktop_arm64=/DependencyPackagePath:"%~dp0Metro\Microsoft.VCLibs.140.00.UWPDesktop_14.0.33728.0_arm64__8wekyb3d8bbwe.appx"
set CEPS_ParamVCLibsUWPDesktop_arm=/DependencyPackagePath:"%~dp0Metro\Microsoft.VCLibs.140.00.UWPDesktop_14.0.33728.0_arm__8wekyb3d8bbwe.appx"


REM kill the "DesktopExtension.exe" process to avoid installation error
Echo [%DATE%] [%TIME%] Kill the "DesktopExtension.exe" process...  >> %MyLog%
taskkill.exe /F /IM "DesktopExtension.exe"
Echo [%DATE%] [%TIME%] The error level is %errorlevel%.  >> %MyLog%
Set errorlevel = 0
Echo [%DATE%] [%TIME%] The error level is set to %errorlevel%.  >> %MyLog%

:installStart
REM Installation starts
ECHO ############################################################# >> %MyLog%
ECHO  [%DATE%] [%TIME%] Beginning of %project_name% installation   >> %MyLog%
ECHO ############################################################# >> %MyLog%

Echo [%DATE%] [%TIME%] Starting Install package %project_name%  >> %MyLog%

REM Check OS Architecture for DISM parameter of dependency library
set CEPS_OSArch=CEPS_UtilityFail
REM Check OS Architecture for DISM parameter of dependency library
call %utilFolder%\AttributeQueryOSArchitecture.cmd >> %MyLog%

ECHO [%DATE%] [%TIME%] CPU and OS Architecture is "%CEPS_OSArch%"  >> %MyLog%

if "%CEPS_OSArch%"=="ARM" Echo [%DATE%] [%TIME%] ====ARMOS====== >> %MyLog% & goto ARMOS
if "%CEPS_OSArch%"=="x64" Echo [%DATE%] [%TIME%] ====Win64OS==== >> %MyLog% & goto Win64OS
if "%CEPS_OSArch%"=="x86" Echo [%DATE%] [%TIME%] ====Win86OS==== >> %MyLog% & goto Win86OS

:Win64OS
Echo [%DATE%] [%TIME%] Starting install DISM X64 package  >> %MyLog%

DISM.exe /Online /Add-ProvisionedAppxPackage %CEPS_AppxBundle% %CEPS_ParamDotNet_x64% %CEPS_ParamDotNet_x86% %CEPS_ParamRuntime_x64% %CEPS_ParamRuntime_x86% %CEPS_ParamVCLibs_x64% %CEPS_ParamVCLibs_x86% %CEPS_ParamUIXaml_x64% %CEPS_ParamUIXaml_x86% %CEPS_ParamVCLibsUWPDesktop_x64% %CEPS_License% /Region="All" /LogPath:%DISMLog%

if %errorlevel% NEQ 0 Echo [%DATE%] [%TIME%] DISM Install Failed Errorlevel=%errorlevel%.  >> %MyLog% & goto INSFAIL
if %errorlevel% equ 0 Echo [%DATE%] [%TIME%] DISM Install package complete  >> %MyLog%
goto END

:Win86OS
Echo [%DATE%] [%TIME%] Starting install DISM X86 package  >> %MyLog%

DISM.exe /Online /Add-ProvisionedAppxPackage %CEPS_AppxBundle% %CEPS_ParamDotNet_x86%  %CEPS_ParamRuntime_x86%  %CEPS_ParamVCLibs_x86% %CEPS_ParamUIXaml_x86% %CEPS_ParamVCLibsUWPDesktop_x86% %CEPS_License% /Region="All" /LogPath:%DISMLog%

if %errorlevel% NEQ 0 Echo [%DATE%] [%TIME%] DISM Install Failed Errorlevel=%errorlevel%.  >> %MyLog% & goto INSFAIL
if %errorlevel% equ 0 Echo [%DATE%] [%TIME%] DISM Install package complete  >> %MyLog%
goto END

:ARMOS
Echo [%DATE%] [%TIME%] Starting install DISM ARM package  >> %MyLog%

DISM.exe /Online /Add-ProvisionedAppxPackage %CEPS_AppxBundle% %CEPS_ParamDotNet_arm64% %CEPS_ParamRuntime_arm64% %CEPS_ParamVCLibs_arm64% %CEPS_ParamUIXaml_arm64% %CEPS_ParamVCLibsUWPDesktop_arm64% %CEPS_License% /Region="All" /LogPath:%DISMLog%

if %errorlevel% NEQ 0 Echo [%DATE%] [%TIME%] DISM Install Failed Errorlevel=%errorlevel%.  >> %MyLog% & goto INSFAIL
if %errorlevel% equ 0 Echo [%DATE%] [%TIME%] DISM Install package complete  >> %MyLog%
goto END


:END
REM Do not remove this as this is to solve a OOBE related issue
echo ==================== Write BuildID begin =================>> %MyLog%
set dpsPath=""
set BuildIDReg=%~dp0\BuildID.reg

setlocal enabledelayedexpansion
for /f "tokens=*" %%a in ('dir c:\system.sav\*_DPS /b /s') do set dpsPath=%%a
if Exist "%dpsPath%" (
	echo %date% %time%  Try to parse "%dpsPath%" ... >> %MyLog%
	for /f "tokens=1,2 eol=: delims==" %%a in ( "%dpsPath%" ) do if "%%a"=="; BuildID" set BuildID=%%b
	for /l %%a in (1,1,31) do if "!BuildID:~-1!"==" " set BuildID=!BuildID:~0,-1!
)
if not Exist "%dpsPath%" (
	echo %date% %time%  Cannot find c:\system.sav\*_DPS >> %MyLog%
) else if not Exist c:\system.sav\flags\BtBDisableJSKey.flg (
	if defined BuildID (
		echo %date% %time%  Write BuildID="!BuildID!" to registry >> %MyLog%
		echo Windows Registry Editor Version 5.00 > "%BuildIDReg%"
		echo [HKEY_LOCAL_MACHINE\SOFTWARE\HP\System Properties] >> "%BuildIDReg%"
		echo "BuildID"="!BuildID!" >> "%BuildIDReg%"

		C:\Windows\SysWOW64\regedt32.exe /c /s "%BuildIDReg%"
		del /f /q "%BuildIDReg%"

	) else (
		echo %date% %time%  Cannot find BuildID in "%dpsPath%" >> %MyLog%
	)
) else (
	echo %date% %time%  BtBDisableJSKey.flg found, ignore to write BuildID="!BuildID!" to registry >> %MyLog%
)
endlocal


echo ====================  Write BuildID finish ================= >> %MyLog%
REM Installation finish
ECHO ############################################################# >> %MyLog%
ECHO  [%DATE%] [%TIME%] End of %project_name% installation                 >> %MyLog%
ECHO ############################################################# >> %MyLog%
popd
exit /b %errorlevel%


:INSFAIL
ECHO [%DATE%] [%TIME%] %project_name% Install FAIL Exit. >> %MyLog%
popd
exit /B 1
