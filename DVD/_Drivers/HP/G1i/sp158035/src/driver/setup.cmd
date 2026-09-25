@echo OFF
REM :: Intel(R) Manageability and Security IPF Extention Providers Drivers Installer Script
REM :: Copyright (c) 2020-2024 Intel Corporation All Rights Reserved
REM ::
REM :: This script may be used to automatically install or uninstall all the drivers for the
REM :: Intel(R) Manageability and Security IPF Extention Providers Drivers, which include the following providers:
REM ::                			1. Manageability IPF AMT Provider
REM ::                			2. Manageability IPF PSR Provider
REM ::                			3. Manageability IPF UPID Provider
REM ::                			4. Manageability IPF PBI Provider
REM ::                			5. Security IPF TDT Provider
REM ::                			6. Security Security Discovery Provider
REM :: Driver INFs may also be installed manually if desired.
REM ::
REM :: NOTE: This script must be run by an Administrator with "Run as Administrator"
REM ::       Privileges, either from Windows Explorer or from a CMD.EXE Prompt.
REM ::
REM :: Usage: setup.cmd [silent] [ install / uninstall / help]
REM ::
setlocal enabledelayedexpansion
pushd %~dp0
set CURDIR=%~dp0

set DRIVERLIST=manageability_security_ipf_providers_ext.inf manageability_security_ipf_providers_sw.inf
set FAILURES=0
set N_UNINSTALL=0
set PAUSE=1

call :main %*
goto exit

:main
	if /i "%1"=="silent" (
		SET PAUSE=0
		shift
	)

	if "%1"=="" (
		call :install
		if !FAILURES! NEQ 0 (call :error) else (call :pause)
	) else (
		for %%o in (install uninstall help --help -help -h silent) do if /i "%1"=="%%o" (
			call :%%o
			if !FAILURES! NEQ 0 (call :error)
			exit /b
		)
	)
exit /b

:install
	echo.
	echo ***
	echo *** Installing Intel(R) Manageability and Security IPF Extention Providers Drivers
	echo ***
	
	
	for %%p in (%DRIVERLIST%) do (
			echo.
			echo.
			echo ***                          
			echo *** Installing %%p ......... ***
			echo ***
			echo.
			pnputil /add-driver %%p /install 
			
			
		if !ERRORLEVEL! NEQ 0 if !ERRORLEVEL! NEQ 259 set /A FAILURES=!FAILURES!+1

		set LOADEDINF=0
		for /f "delims= tokens=1-3" %%i in ('pnputil /enum-devices /drivers') do (
			set PNPITEM=%%i
			if "!PNPITEM:~4,14!"=="Original Name:" (
				set ORIGINAL=!PNPITEM:~28,255!
				if "!ORIGINAL!"=="%%p" (
					set LOADEDINF=1
				)
			)				
		)

		if !FAILURES! EQU 0 if !LOADEDINF! NEQ 1 (
			echo +++
			echo +++ ERROR Installing %%p: UNSUPPORTED PLATFORM
			echo +++
			echo.
			set /A FAILURES=!FAILURES!+1
			call :uninstall %%p
			exit /b
		)
	)
	)
	echo.
	echo ***
	echo *** Install Complete for: 
	echo ***            Intel(R) Manageability and Security IPF Extention Providers Drivers 
	echo ***
	echo.
exit /b

:uninstall
		echo.
		echo ***
		echo *** Uninstall Intel(R) Manageability and Security IPF Extention Providers Drivers
		echo ***
		echo.

	for %%i in (%DRIVERLIST%) do (
		for /f "delims= tokens=1-3" %%p in ('pnputil /enum-drivers') do (
			set PNPITEM=%%p
			if "!PNPITEM:~0,15!"=="Published Name:" (
				set OEMINF=!PNPITEM:~20,255!
			)
			if "!PNPITEM:~0,14!"=="Original Name:" (
				set ORIGINAL=!PNPITEM:~20,255!
				if "!ORIGINAL!"=="%%i" (
					echo.
					echo *** Manageability Providers driver found :    %%i
					echo.
					echo *** Uninstalling %%i [!OEMINF!] ...
					echo.
					pnputil /delete-driver !OEMINF! /uninstall
					if ERRORLEVEL 1 set /A FAILURES=!FAILURES!+1
					echo.
					set /A N_UNINSTALL=!N_UNINSTALL!+1
				)				
			)
		)
	)
	if "!N_UNINSTALL!"=="0" echo *** Intel(R) Manageability and Security IPF Extension Providers not installed. No drivers to uninstall.
	if "%1"=="" (
		echo.
		echo ***
		echo *** Uninstall Process Complete
		echo ***
		echo.
	)
exit /b

:error
	echo.
	echo +++
	echo +++ ERROR: There is(are) %FAILURES% Failure(s) Installing/Uninstalling Drivers.
	echo +++
	echo +++ NOTE:
	echo +++  1. This Script must be started with the "Run as Administrator" option from
	echo +++     Windows Explorer or a CMD Prompt in order to Install/Uninstall Drivers.
	echo +++  2. Drivers will only Install and Load on Supported Platforms.
	echo +++  3. Drivers will Install successfully only when the INF files and setup.cmd 
	echo +++     file are in the same directory.
	echo +++
	echo.
	call :pause
exit /b

:pause
	if "%PAUSE%"=="1" pause
exit /b

:help
:--help
:-help
:-h
	echo.
	echo *** Intel(R) Manageability and Security IPF Extention Providers Drivers Setup Script
	echo *** (c) Copyright 2024 Intel Corporation All Rights Reserved
	echo.
	echo    Usage: setup [silent] [option]
	echo. 
	echo    Options:
	echo    silent       = Do a Silent Install/Uninstall (no pause)
	echo    install      = Install Intel(R) Manageability and Security IPF Extention Providers Drivers [default]
	echo    uninstall    = Uninstall Intel(R) Manageability and Security IPF Extention Providers Drivers
	echo    help         = Display this Help screen
	echo.
	echo    NOTE: This Script must be run by an Administrator with the
	echo    "Run as Administrator" option, in Explorer or CMD.EXE.
	echo.
exit /b

:exit
popd
endlocal