@echo off
REM :: Intel(R) IPF Providers for Device Management Drivers Installer Script
REM :: Copyright (C) 2022-2026 Intel Corporation All Rights Reserved
REM ::
REM :: This script may be used to automatically install or uninstall all the drivers for the
REM :: Intel(R) IPF Providers for Device Management Drivers, which include the following providers:
REM ::                     1. Intel AMT IPF Provider
REM ::                     2. Intel Firmware Measurement IPF Provider
REM ::                     3. Intel PBI IPF Provider
REM ::                     4. Intel Platform Feature Info IPF Provider
REM ::                     5. Intel Platform Health IPF Provider
REM ::                     6. Intel PSR IPF Provider
REM ::                     7. Intel TDT IPF Provider
REM ::                     8. Intel TEP IPF Provider
REM ::                     9. Intel UPID IPF Provider

REM :: Driver INFs may also be installed manually if desired.
REM ::
REM :: NOTE: This script must be run by an Administrator with "Run as Administrator"
REM ::       Privileges, either from Windows Explorer or from a CMD.EXE Prompt.
REM ::
REM :: Usage: setup.cmd [silent] [install / uninstall / reinstall / help]
REM ::

setlocal enabledelayedexpansion
pushd "%~dp0"

REM :: Script Configuration
set "DRIVERLIST=manageability_security_ipf_providers_ext.inf manageability_security_ipf_providers_sw.inf"
set /a FAILURES=0
set /a N_UNINSTALL=0
set /a PAUSE=1

REM :: Error Code Constants
set /a ERROR_SUCCESS=0
set /a ERROR_ALREADY_INSTALLED=259
set /a ERROR_NO_MATCHING_DEVICES=1168
set /a ERROR_SUCCESS_REBOOT_REQUIRED=3010
set /a ERROR_SUCCESS_REBOOT_INITIATED=1641
set /a ERROR_FILE_NOT_INSTALLED_INF=-536870340

REM :: Validate administrator privileges
fsutil dirty query %systemdrive% >nul 2>&1
if !errorlevel! neq 0 (
    echo.
    echo +++
    echo +++ ERROR: This script must be run as Administrator
    echo +++ Please right-click and select "Run as Administrator"
    echo +++
    pause
    exit /b 1
)

call :main %*
goto :exit

:main

    if /i "%~1"=="silent" (
        set /a PAUSE=0
        shift
    )

    if "%~1"=="" (
        call :install
        if !FAILURES! neq 0 (
            call :error
        ) else (
            call :success
        )
    ) else (
        for %%o in (install uninstall reinstall help --help -help -h) do (
            if /i "%~1"=="%%o" (
                call :%%o
                if !FAILURES! neq 0 call :error
                exit /b 0
            )
        )
        echo ERROR: Unknown parameter "%~1"
        echo.
        call :help
        exit /b 1
    )
exit /b 0

:reinstall
    echo.
    echo ***
    echo *** Performing Clean Reinstall of Intel^(R^) IPF Providers for Device Management Drivers
    echo *** Phase 1: Uninstalling existing drivers...
    echo ***
    
    REM Store the original failure count for monitoring uninstall-specific failures.
    set /a UNINSTALL_FAILURES_START=!FAILURES!
    
    REM Perform uninstall phase (silent mode to suppress completion message)
    call :uninstall silent
    
    REM Calculate uninstall-specific failures
    set /a UNINSTALL_FAILURES=!FAILURES!-!UNINSTALL_FAILURES_START!
    
    REM Check if uninstall phase had critical failures
    if !UNINSTALL_FAILURES! gtr 0 (
        echo.
        echo +++
        echo +++ WARNING: Uninstall phase completed with !UNINSTALL_FAILURES! failure^(s^)
        echo +++ Continuing with installation phase...
        echo +++
        REM Reset failures for install phase (uninstall failures shouldn't block install)
        set /a FAILURES=!UNINSTALL_FAILURES_START!
    ) else (
        echo *** Uninstall phase completed successfully
        if !N_UNINSTALL! gtr 0 (
            echo *** Removed !N_UNINSTALL! existing driver^(s^)
        ) else (
            echo *** No existing drivers found to remove
        )
    )
    
    echo.
    echo ***
    echo *** Phase 2: Installing drivers...
    echo ***
    
    REM Store failure count before install phase
    set /a INSTALL_FAILURES_START=!FAILURES!
    
    REM Perform install phase
    call :install_core
    
    REM Calculate install-specific failures
    set /a INSTALL_FAILURES=!FAILURES!-!INSTALL_FAILURES_START!
    
    REM Final status reporting
    echo.
    if !INSTALL_FAILURES! equ 0 (
        echo ***
        echo *** Clean Reinstall Completed Successfully
        echo ***
        if !N_UNINSTALL! gtr 0 (
            echo *** Replaced !N_UNINSTALL! existing driver^(s^)
        ) else (
            echo *** Installed drivers ^(no previous versions found^)
        )
        echo ***
    ) else (
        echo +++
        echo +++ Reinstall completed with issues:
        if !UNINSTALL_FAILURES! gtr 0 echo +++   - Uninstall phase: !UNINSTALL_FAILURES! failure^(s^)
        if !INSTALL_FAILURES! gtr 0 echo +++   - Install phase: !INSTALL_FAILURES! failure^(s^)
        echo +++
    )
    echo.
exit /b 0

:install
    echo.
    echo ***
    echo *** Installing Intel^(R^) IPF Providers for Device Management Drivers
    echo ***
    
    call :install_core
exit /b 0

:install_core
    for %%p in (%DRIVERLIST%) do (
        echo.
        echo ***
        echo *** Installing %%p ...
        echo ***
        echo.
        
        if not exist "%%p" (
            echo +++
            echo +++ ERROR: Driver file %%p not found in current directory
            echo +++
            set /a FAILURES=!FAILURES!+1
        ) else (
            pnputil /add-driver "%%p" /install
            call :handle_install_result !errorlevel! "%%p"
        )
    )
    
    if !FAILURES! equ 0 (
        echo.
        echo ***
        echo *** Install Process Complete
        echo ***
        echo.
    )
exit /b 0

:handle_install_result
    set "ERROR_CODE=%~1"
    set "INF_FILE=%~2"
    
    if %ERROR_CODE% equ %ERROR_SUCCESS% goto :success_verify
    if %ERROR_CODE% equ %ERROR_ALREADY_INSTALLED% goto :already_installed
    if %ERROR_CODE% equ %ERROR_NO_MATCHING_DEVICES% goto :no_matching_devices
    if %ERROR_CODE% equ %ERROR_SUCCESS_REBOOT_REQUIRED% goto :reboot_required
    if %ERROR_CODE% equ %ERROR_SUCCESS_REBOOT_INITIATED% goto :reboot_initiated
    if %ERROR_CODE% equ %ERROR_FILE_NOT_INSTALLED_INF% goto :inf_install_failed
    goto :generic_error
    
    :success_verify
        echo *** Successfully added %INF_FILE% to driver store
        call :verify_driver_installed_safe "%INF_FILE%"
        if !DRIVER_FOUND! neq 1 (
            echo +++
            echo +++ ERROR: Driver %INF_FILE% not found after installation - unsupported platform
            echo +++
            set /a FAILURES=!FAILURES!+1
            call :uninstall_specific_inf "%INF_FILE%"
        ) else (
            echo *** Driver %INF_FILE% verified and loaded successfully
        )
        goto :end_handle
    
    :already_installed
        echo *** Driver %INF_FILE% already installed ^(skipping verification^)
        goto :end_handle
    
    :no_matching_devices
        echo *** Driver %INF_FILE%: No matching devices found for this INF
        echo *** This is normal on platforms that don't support this driver
        goto :end_handle
    
    :reboot_required
        echo *** Driver %INF_FILE% installed successfully - REBOOT REQUIRED
        echo *** Please restart the system to complete driver installation
        set "REBOOT_REQUIRED=1"
        goto :end_handle
    
    :reboot_initiated
        echo *** Driver %INF_FILE% installed successfully - SYSTEM REBOOT INITIATED
        echo *** System will restart automatically to complete installation
        set "REBOOT_INITIATED=1"
        goto :end_handle
    
    :inf_install_failed
        echo +++
        echo +++ ERROR: INF file %INF_FILE% installation failed - file not properly installed
        echo +++
        set /a FAILURES=!FAILURES!+1
        goto :end_handle
    
    :generic_error
        echo +++
        echo +++ ERROR: pnputil install failed with error code %ERROR_CODE%
        echo +++
        set /a FAILURES=!FAILURES!+1
        goto :end_handle
    
    :end_handle
exit /b 0

:verify_driver_installed_safe
    set "TARGET_INF=%~1"
    set /a DRIVER_FOUND=0
    set /a RETRY_COUNT=3
    set /a RETRY_DELAY=2
    
    for /l %%i in (1,1,%RETRY_COUNT%) do (
        if %%i gtr 1 (
            echo *** Driver verification attempt %%i, waiting !RETRY_DELAY! seconds...
            call :delay_seconds !RETRY_DELAY!
        )
        
        REM Method 1: Try exact token matching first (fastest)
        for /f "tokens=*" %%a in ('pnputil /enum-drivers 2^>nul') do (
            set "LINE=%%a"
            for %%t in (!LINE!) do (
                set "TOKEN=%%t"
                REM Remove common trailing punctuation
                if "!TOKEN:~-1!"=="," set "TOKEN=!TOKEN:~0,-1!"
                if "!TOKEN:~-1!"==";" set "TOKEN=!TOKEN:~0,-1!"
                
                REM Extract filename and compare exactly
                for %%f in ("!TOKEN!") do (
                    set "FILENAME=%%~nxf"
                    if /i "!FILENAME!"=="%TARGET_INF%" (
                        set /a DRIVER_FOUND=1
                        echo *** Driver verification successful - exact match found
                        goto :verify_complete
                    )
                )
            )
        )
        
        REM Method 2: Fallback to substring with validation
        pnputil /enum-drivers 2>nul | findstr /i /c:"%TARGET_INF%" >nul 2>&1
        if !errorlevel! equ 0 (
            echo *** Driver verification successful - substring match (validate manually if needed)
            set /a DRIVER_FOUND=1
            goto :verify_complete
        )
        
        if %%i lss %RETRY_COUNT% (
            echo *** Driver verification attempt %%i failed, retrying...
        )
    )
    
    :verify_complete
exit /b 0

:delay_seconds
    set "DELAY_TIME=%~1"
    
    REM Validate delay time
    if "%DELAY_TIME%"=="" goto :delay_done
    if %DELAY_TIME% leq 0 goto :delay_done
    
    REM timeout command (Windows Vista+, most reliable)
    REM timeout /t SECONDS /nobreak >nul 2>&1
    REM   /t SECONDS  = Wait for specified number of seconds (1-99999)
    REM   /nobreak    = Ignore Ctrl+C keypresses (prevents accidental interruption)
    REM   >nul 2>&1   = Hide all output (both stdout and stderr)
    REM Why: Purpose-built for delays, most accurate timing, clean implementation
    timeout /t %DELAY_TIME% /nobreak >nul 2>&1
    if !errorlevel! equ 0 goto :delay_done
    
    REM choice command (universal fallback, all Windows versions)
    REM choice /t SECONDS /d CHOICE /n >nul 2>&1
    REM   /t SECONDS  = Timeout after specified seconds (0-9999)
    REM   /d y        = Default to 'y' when timeout expires (required with /t)
    REM   /n          = Don't display choice list [Y,N] - silent operation
    REM   >nul 2>&1   = Hide all output (both stdout and stderr)
    REM Why: Universal compatibility (DOS/Win95+), reliable timing, user-interruptible
    choice /t %DELAY_TIME% /d y /n >nul 2>&1
    if !errorlevel! neq 9009 goto :delay_done
    
    REM If both methods fail, continue without delay (shouldn't happen on modern systems)
    echo *** WARNING: Unable to create delay - continuing immediately
    
    :delay_done
exit /b 0

:uninstall
    echo.
    echo ***
    echo *** Uninstall Intel^(R^) IPF Providers for Device Management Drivers
    echo ***
    echo.

    for %%i in (%DRIVERLIST%) do (
        call :uninstall_specific_inf "%%i"
    )
    
    if !N_UNINSTALL! equ 0 (
        echo *** No drivers found to uninstall
    ) else (
        echo *** Successfully processed !N_UNINSTALL! driver^(s^)
    )
    
    REM Only show completion message if not called from reinstall (not silent)
    if not "%~1"=="silent" (
        echo.
        echo ***
        echo *** Uninstall Process Complete
        echo ***
        echo.
    )
exit /b 0

:uninstall_specific_inf
    set "TARGET_INF=%~1"
    
    REM Find the OEM name for this INF file
    call :find_oem_name "%TARGET_INF%"
    
    if defined OEM_NAME (
        echo.
        echo *** IPF Providers for Device Management driver found: %TARGET_INF% ^(OEM: %OEM_NAME%^)
        echo *** Uninstalling %OEM_NAME% ...
        echo.
        
        pnputil /delete-driver "%OEM_NAME%" /uninstall
        if !errorlevel! equ 0 (
            set /a N_UNINSTALL=!N_UNINSTALL!+1
        ) else (
            echo +++ ERROR: Failed to uninstall %OEM_NAME% ^(error code: !errorlevel!^)
            set /a FAILURES=!FAILURES!+1
        )
    ) else (
        echo *** Driver %TARGET_INF% is not currently installed
    )
exit /b 0

:find_oem_name
    set "SEARCH_INF=%~1"
    set "OEM_NAME="
    
    if "%SEARCH_INF%"=="" goto :oem_found
    
    REM Find our INF, then get its OEM from the same block
    set "RECENT_OEM="
    
    for /f "tokens=*" %%a in ('pnputil /enum-drivers 2^>nul') do (
        set "LINE=%%a"
        
        REM Try simpler regex pattern. Anchoring does not work.
        for %%t in (!LINE!) do (
            REM Simpler regex: just look for oem + digits + .inf
            echo "%%t" | findstr /r /c:"oem[0-9][0-9]*\.inf" >nul 2>&1
            if !errorlevel! equ 0 (
                set "RECENT_OEM=%%t"
            )
        )
        
        REM When we find our target INF, use the most recent OEM
        if "!LINE:%SEARCH_INF%=!" neq "!LINE!" (
            set "OEM_NAME=!RECENT_OEM!"
            goto :oem_found
        )
    )
    
    :oem_found
exit /b 0

:success
    echo.
    echo ***
    echo *** Operation completed successfully
    echo ***
    if defined REBOOT_REQUIRED (
        echo *** IMPORTANT: System restart required to complete driver installation
        echo *** Please reboot your system when convenient
    )
    if defined REBOOT_INITIATED (
        echo *** NOTICE: System reboot has been automatically initiated
    )
    echo.
    call :pause
exit /b 0

:error
    echo.
    echo +++
    echo +++ ERROR: Operation completed with !FAILURES! failure^(s^)
    echo +++
    echo +++ TROUBLESHOOTING:
    echo +++  1. Ensure this script is run as Administrator
    echo +++  2. Verify INF files are present in the same directory as this script
    echo +++  3. Check that the platform supports these drivers
    echo +++  4. Review any error messages above for specific issues
    echo +++
    if defined REBOOT_REQUIRED (
        echo +++ NOTE: Some drivers may require system restart despite errors
    )
    echo.
    call :pause
exit /b 1

:pause
    if !PAUSE! equ 1 (
        echo Press any key to continue...
        pause >nul
    )
exit /b 0

:help
:--help
:-help
:-h
    echo.
    echo *** Intel^(R^) IPF Providers for Device Management Drivers Setup Script
    echo *** Copyright ^(C^) 2022-2026 Intel Corporation All Rights Reserved
    echo.
    echo    Usage: %~nx0 [silent] [option]
    echo.
    echo    Managed Drivers:
    for %%d in (%DRIVERLIST%) do echo      - %%d
    echo.
    echo    Options:
    echo      silent       = Silent operation ^(no pause^)
    echo      install      = Install drivers [default]
    echo      uninstall    = Uninstall drivers
    echo      reinstall    = Uninstall then install drivers
    echo      help         = Display this help screen
    echo.
    echo    Requirements:
    echo      - Administrator privileges required
    echo      - INF files must be in same directory as script
    echo      - Supported platform required for driver loading
    echo.
    echo    Notes:
    echo      - 'reinstall' can be used when updating drivers or troubleshooting driver issues
    echo      - Uninstall failures during reinstall will not prevent installation phase
    echo      - System may require restart after driver installation
    echo.
exit /b 0

:exit
popd
endlocal
exit /b !errorlevel!