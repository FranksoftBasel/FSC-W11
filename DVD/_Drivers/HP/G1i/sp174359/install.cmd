@echo off
rem Check if need elevation and handle if needed
>NUL 2>&1 REG.exe query "HKU\S-1-5-19" || (
ECHO SET UAC = CreateObject ^ ("Shell.Application"^) > "%TEMP%\Getadmin.vbs"
ECHO UAC.ShellExecute "%~f0", "%1", "", "runas", 1 >> "%TEMP%\Getadmin.vbs"
"%TEMP%\Getadmin.vbs"
DEL / f / q "%TEMP%\Getadmin.vbs" 2>NUL
Exit / b
)

rem Switch to batch file directory
pushd %~dp0
@set _HpSoftPaqPath="%~dp0"

rem Make a symbolic link at the root of the system drive
pushd "%SystemDrive%\"
@set _HpNewPath="sp174359"
>NUL 2>&1 mklink /D %_HpNewPath% %_HpSoftpaqPath%
if %ERRORLEVEL% EQU 0 (
	pushd "%_HpNewPath%"
	Goto :continue
) else (
	pushd %_HpSoftpaqPath%
	 GoTo :skip
)
:skip
@set _HpNewPath=%_HpSoftpaqPath%
:continue

pushd bin
"HPUP.exe"
set _HpExitCode=%ERRORLEVEL%
popd
popd
rmdir %_HpNewPath%
popd

rem ERRORLEVEL
rem 0:SUCCESS:NOREBOOT=Driver install successfully
rem 259:SUCCESS:NOREBOOT=Re-install driver
rem 3010:SUCCESS:NOREBOOT=Unknown reason

:done
popd
set ERRORLEVEL=%_HpExitCode%
@set _HpExitCode=
@set _HpNewPath=
@set _HpSoftPaqPath=
exit /b %ERRORLEVEL%
