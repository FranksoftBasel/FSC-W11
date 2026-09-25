REM ========================================================
REM   Driver deliverable installation
REM 
REM   Template Version: V1.03c
REM ========================================================
set versiondrv=1.03c
set errcode=0
REM %Description of deliverable%
@ECHO OFF
REM ****************************************************
REM *      COMPONENT OWNER TO UPDATE (SW_TITLE)        *
REM ****************************************************
SET SW_TITLE=Qualcomm_Snapdragon_X55_WWAN_Driver
REM ****************************************************
set DriverPrefix=dchu_
REM MODIFY SET DRIVERPREFIX AS NEEDED
if not exist "%~dp0%driverprefix%" set DriverPrefix=driver

rem
rem Set up the log folder/file
rem
if defined FCC_LOG_FOLDER (
    SET "APP_LOG=%FCC_LOG_FOLDER%\%~n0.log"
    if not exist "%FCC_LOG_FOLDER%" md "%FCC_LOG_FOLDER%"
) else (
    SET "APP_LOG=%~d0\programdata\HP\logs\%SW_TITLE%.log"
    if not exist "%~d0\programdata\HP\logs" md "%~d0\programdata\HP\logs"
)

rem
rem No need to install driver here (online) during preinstall if it supports INF injection, and doesn't have NOINF.FLG
rem
if not exist "..\NOINF.FLG" if exist "c:\system.sav\tweaks" if exist "c:\system.sav\flags\Proteus.FLG" (
    echo ***INFO*** For Preinstall, we've already injected the driver offline --^> skip the installation here. >> "%APP_Log%"
    goto lbl_CommonOps 
)

ECHO ############################################################# >> %APP_LOG%
ECHO  [%DATE%]                                                     >> %APP_LOG%
ECHO  [%TIME%] Beginning of the %~nx0                              >> %APP_LOG%
ECHO ############################################################# >> %APP_LOG%

set "ExtensionGuid={e2f84ce7-8efa-411c-aa69-97454ca4cb57}"
set "SoftwareComponenGuid={5c4c3332-344d-483c-8739-259e934c9cc8}"

REM ------------------- DO NOT MODIFY SECTION ------------------------
:INSTALL
if not exist "%~dp0%DriverPrefix%*" echo [%TIME%] No DCHU driver found. >> %APP_LOG% & goto END
for /f "delims=" %%a in ('dir /ad /b "%~dp0%driverprefix%*"') do (
	echo [%TIME%] Search BASE driver in "%~dp0%%~a\*.inf" >> %APP_LOG%
        dir /a-d /b /s "%~dp0%%~a\*.inf" >nul 2>&1
        if errorlevel 1 echo [%TIME%] No .inf found. >> %APP_LOG% & goto RESULTFAILED
	for /f "delims=" %%i in ('dir /a-d /b /s "%~dp0%%~a\*.inf"') do (
		echo [%TIME%] Check %%~i driver category. >> %APP_LOG%
		call:ChkDrvClassGuid "%%~i" "%ExtensionGuid% %SoftwareComponenGuid%"
		if errorlevel 1 (
			echo [%TIME%] Driver category match, install it. >> %APP_LOG%
			call:DrvInst "%%~i"
			if errorlevel 1 echo [%TIME%] %%~i driver install failed. >> %APP_LOG% & goto RESULTFAILED
			echo [%TIME%] %%~i driver install success. >> %APP_LOG%
		) else (
			echo [%TIME%] Driver category mismatch. >> %APP_LOG%
		)
	)
	echo. >> %APP_LOG%
	echo [%TIME%] Search EXTENSION driver in "%~dp0%%~a\*.inf" >> %APP_LOG%
	for /f "delims=" %%i in ('dir /a-d /b /s "%~dp0%%~a\*.inf"') do (
		echo [%TIME%] Check %%~i driver category. >> %APP_LOG%
		call:ChkDrvClassGuid "%%~i" "%ExtensionGuid%"
		if not errorlevel 1 (
			echo [%TIME%] Driver category match, install it. >> %APP_LOG%
			call:DrvInst "%%~i"
			if errorlevel 1 echo [%TIME%] %%~i driver install failed. >> %APP_LOG% & goto RESULTFAILED
			echo [%TIME%] %%~i driver install success. >> %APP_LOG%
		) else (
			echo [%TIME%] Driver category mismatch. >> %APP_LOG%
		)
	)
	echo. >> %APP_LOG%
	echo [%TIME%] Search COMPONENT driver in "%~dp0%%~a\*.inf" >> %APP_LOG%
	for /f "delims=" %%i in ('dir /a-d /b /s "%~dp0%%~a\*.inf"') do (
		echo [%TIME%] Check %%~i driver category. >> %APP_LOG%
		call:ChkDrvClassGuid "%%~i" "%SoftwareComponenGuid%"
		if not errorlevel 1 (
			echo [%TIME%] Driver category match, install it. >> %APP_LOG%
			call:DrvInst "%%~i"
			if errorlevel 1 echo [%TIME%] %%~i driver install failed. >> %APP_LOG% & goto RESULTFAILED
			echo [%TIME%] %%~i driver install success. >> %APP_LOG%
		) else (
			echo [%TIME%] Driver category mismatch. >> %APP_LOG%
		)
	)
)
REM RESET errorlevel as PREVIOUS section could return 1 for non component drivers.
set errorlevel=0
REM ----------------------------------------------------------------------------------------------------
:lbl_CommonOps
REM ****************************************************
REM *  COMPONENT OWNER TO UPDATE (OPTIONAL COMMANDS)   *
REM *    Please add addition IHV command below.        *
REM ****************************************************

:: ==================================================================
:: Script Name 	: installdrv.cmd
:: Author 		: Foxconn CNSBG
:: Descriptions : This area will judgement for MHI is exist or not and install FOTA and also check FOTA update is running or not..
:: ==================================================================

@echo off
setlocal enabledelayedexpansion
chcp 65001
 
REM ==================================================================
REM Global variables
REM ==================================================================
set version=0.0.2.0
set /a ContinueFlag=0
set /a RestartFLAGbefore=0 
set /a RestartFLAGafter=0
set /a RestartFLAG=0
set /a Installmethod=0
set /a fotaflag=0
set /a fotaready=0
set /a fotatimming=0

REM ==================================================================
REM Check the priviledge first
REM ==================================================================
call :helpmessage
net session >nul 2>&1
if %errorLevel% NEQ 0 (
	echo Please run this script with Administrator priviledge !!
	CALL :writelog "echo Please run this script with Administrator priviledge !!"
	pause
	exit /b 0
)

Set curpath="%~dp0"

CD /D ""%curpath%""

REM ==================================================================
REM Entry Point
REM ==================================================================
call :checkppkgbefore
call :ScanOSVer
call :checkppkgafter

if exist Drivers\FOTA (
	rmdir Drivers\FOTA /s /q 1>>nul 2>>nul
)

devcon rescan 1>>nul 2>>nul

call :moduleexist
call :chkfotaexist
if %ContinueFlag% EQU 0 (
	if %Installmethod% EQU 0 (
		echo [Check FAIL] There have no MHIhost be detected !!
		CALL :writelog "[Check FAIL] There have no MHIhost be detected !!"
		set ferrorlevel=1
	) else (
		if !fotaready! EQU 1 (
			echo [Check PASS] Detect FOTA HW-ID but is MSFT name, start update driver !!
			CALL :writelog "[Check PASS] Detect FOTA HW-ID but is MSFT name, start update driver !!"
			call :mbfwdriverinstaller
		) else if !fotaready! EQU 2 (
			echo [Check PASS] Detect FOTA HW-ID but is MSFT name without running, start update driver !!
			CALL :writelog "[Check PASS] Detect FOTA HW-ID but is MSFT name without running, start update driver !!"
			call :mbfwdriverinstaller
		) else if !fotaready! EQU 3 (
			echo [Check WARN] Detect FOTA HW-ID and should installed before !!
			CALL :writelog "[Check WARN] Detect FOTA HW-ID and should installed before !!"
			set ferrorlevel=259
		)
	)
	call :DriverInstallEnd
) else (
	echo [Check FAIL] The OS is not Win10 System !!
	CALL :writelog "[Check FAIL] The OS is not Win10 System !!"
	set ferrorlevel=1
	call :DriverInstallEnd
)

GOTO :EOF

REM ==================================================================
REM Initial the log for install steps
REM ==================================================================
:writelog
set msg=%1

for /f "delims=" %%a in ('powershell get-date -format "{yyyyMMddHHmmss}"') do @set psdate=%%a
echo [%psdate:~0,4%/%psdate:~4,2%/%psdate:~6,2% %psdate:~8,2%:%psdate:~10,2%:%psdate:~12,2%]%msg% >> install_log.log

GOTO :EOF


REM ==================================================================
REM Initial the log for install steps
REM ==================================================================
:helpmessage
echo ==================================================================
echo                   Talisker Driver install script                  
echo                                                  Version : %version%
echo                                                   Author : Foxconn
echo ==================================================================
CALL :writelog "=================================================================="
CALL :writelog "                   Talisker Driver install script                 "
CALL :writelog "                                                 Version : %version%"
CALL :writelog "                                                  Author : Foxconn"
CALL :writelog "=================================================================="

GOTO :EOF

REM ==================================================================
REM Check the patch is installed before or not
REM ==================================================================
:checkppkgbefore
powershell "(Get-ProvisioningPackage).PackageName" | find /c "PCIE_ROOT_PORT_ppkg" > install_temp.txt
for /f "delims=" %%a in ('type install_temp.txt') do @set InstallBefore=%%a

if %InstallBefore% EQU 1 (
	CALL :writelog "DisableGenConstraint.ppkg installed before."
	set /a RestartFLAGbefore=1
)

del /F /Q install_temp.txt 1>>nul 2>>nul

if %RestartFLAGbefore% EQU 0 (
	CALL :writelog "[Check PPKG] The system was not installed the DisableGenConstraint.ppkg before"
) else (
	CALL :writelog "[Check PPKG] The system was installed the DisableGenConstraint.ppkg before"
)

GOTO :EOF

REM ==================================================================
REM Check the flag to judge if need reboot message or not
REM ==================================================================
:checkppkgafter
powershell "(Get-ProvisioningPackage).PackageName" | find /c "PCIE_ROOT_PORT_ppkg" > install_temp.txt
for /f "delims=" %%a in ('type install_temp.txt') do @set Installafter=%%a
	
if %Installafter% EQU 1 (
	CALL :writelog "DisableGenConstraint.ppkg installed after."
	set /a RestartFLAGafter=1
)

del /F /Q install_temp.txt 1>>nul 2>>nul

CALL :writelog "Record the Flag RestartFLAGbefore[%RestartFLAGbefore%] , RestartFLAGafter[%RestartFLAGafter%] ."

if %RestartFLAGbefore% EQU 0 (
	if %RestartFLAGafter% EQU 0 (
		CALL :writelog "[Check PPKG] The system finally have no DisableGenConstraint.ppkg and no need to reboot the OS."
	) else (
		CALL :writelog "[Check PPKG] The system have no DisableGenConstraint.ppkg before but installed at this time."
		set /a RestartFLAG=1
	)
)

if %RestartFLAGbefore% NEQ 0 (
	if %RestartFLAGafter% EQU 0 (
		CALL :writelog "[Check PPKG] The system have DisableGenConstraint.ppkg before but uninstalled during install command."
	) else (
		CALL :writelog "[Check PPKG] The system have DisableGenConstraint.ppkg before and install again."
	)
)


GOTO :EOF


REM ==================================================================
REM Get following information further judgements
REM os_major (10) 	: Get the OS major version via powershell, should be win10
REM os_build (19041) : Get the OS build code via powershell, the ppkg file should more than 19041
REM ==================================================================
:ScanOSVer
for /f "tokens=*" %%a in ('powershell "[environment]::OSVersion.Version.Major"') do set os_major=%%a
for /f "tokens=*" %%a in ('powershell "[environment]::OSVersion.Version.Build"') do set os_build=%%a

if %os_major% GEQ 10 (
	echo [Check PASS] The OS Major version [%os_major%] is valid to install !!
	CALL :writelog "[Check PASS] The OS Major version [%os_major%] is valid to install !!"
	
	if %os_build% GEQ 19041 (
		echo [Check PASS] The OS Build version [%os_build%] is valid to install !!
		CALL :writelog "[Check PASS] The OS Build version [%os_build%] is valid to install !!"
		
		:: Run powershell with commands and ensure the returns as "LastResult:" tag
		CALL :writelog "===== Install Patch DisableGenConstraint.ppkg ====="
		powershell "(Get-ProvisioningPackage).PackageName" | find /c "PCIE_ROOT_PORT_ppkg" > install_temp.txt
		for /f "delims=" %%a in ('type install_temp.txt') do @set InstallorNot=%%a
		if !InstallorNot! EQU 1 (
			CALL :writelog "This system already have patch DisableGenConstraint.ppkg."
		) else (
			Powershell.exe Install-ProvisioningPackage -PackagePath DisableGenConstraint.ppkg -ForceInstall -QuietInstall > install_patch.log
			for /f "tokens=*" %%a in ('findstr /C:"LastResult:Error" install_patch.log') do set PatchResult=%%a
			if [!PatchResult!] == [] (
				echo [Check PASS] Install patch successful !!
				CALL :writelog "[Check PASS] Install patch successful !!"
				type install_patch.log >> install_log.log
				del install_patch.log
			) else (
				echo [Check FAIL] Fail to install patch, please check the log "install_log.log" for detail message !!
				CALL :writelog "[Check FAIL] Fail to install patch, please check the log "install_log.log" for detail message !!"
				type install_patch.log >> install_log.log
				del install_patch.log
			)
		)
		del /F /Q install_temp.txt 1>>nul 2>>nul
		echo. >> install_log.log
	) else (
		echo [Check WARN] The OS Build version [%os_build%] is invalid to install the patch !!
		CALL :writelog "[Check WARN] The OS Build version [%os_build%] is invalid to install the patch !!"
	)
) else (
	echo [Check WARN] The OS Major version [%os_major%] is invalid to install the patch !!
	CALL :writelog "[Check WARN] The OS Major version [%os_major%] is invalid to install the patch !!"
	set /a ContinueFlag=1
)

GOTO :EOF


REM ==================================================================
REM Check the patch is installed before or not
REM ==================================================================
:moduleexist
devcon status "PCI\VEN_103C&DEV_877F&SUBSYS_877F103C" | find "matching device" > device1_exist.log
for /f "tokens=1,2,3,4" %%i in (device1_exist.log) do set ExistDevice1=%%i

devcon status "PCI\VEN_03F0&DEV_0A6C&SUBSYS_877F103C" | find "matching device" > device2_exist.log
for /f "tokens=1,2,3,4" %%i in (device2_exist.log) do set ExistDevice2=%%i

CALL :writelog "MHIHost ExistDevice1 : %ExistDevice1%"
CALL :writelog "MHIHost ExistDevice2 : %ExistDevice2%"

if "%ExistDevice1%" NEQ "No" (
	CALL :writelog "MHI Device Exist (HW-ID is HP older VID), install drivers step by step !!"
	set /a Installmethod=1
) else (
	if "%ExistDevice2%" NEQ "No" (
		CALL :writelog "MHI Device Exist (HW-ID is HP newer VID), install drivers step by step !!"
		set /a Installmethod=2
	) else (
		CALL :writelog "MHI Device NOT Exist , install drivers at once !!"
	)
)

CALL :writelog "Installmethod : %Installmethod%"

if exist device1_exist.log (
	del device1_exist.log 1>>nul 2>>nul
)

if exist device2_exist.log (
	del device2_exist.log 1>>nul 2>>nul
)

GOTO :EOF

REM ==================================================================
REM Check the patch is installed before or not
REM ==================================================================
:chkfotaexist
devcon status "MBFW\{30334630-3041-3643-3034-3134464F5843}" | find "Driver is" > device_status.log
for /f "tokens=1,2,3" %%i in (device_status.log) do set DeviceStatus=%%k

del /F /Q device_status.log 1>>nul 2>>nul
		
devcon status "MBFW\{30334630-3041-3643-3034-3134464F5843}" | find "Name:" > device_name.log
for /f "delims=: tokens=1,2" %%i in (device_name.log) do set DeviceName=%%j
		
del /F /Q device_name.log 1>>nul 2>>nul

CALL :writelog "DeviceStatus : !DeviceStatus!"
CALL :writelog "DeviceName : !DeviceName!"
		
REM ===================================================================================
REM  Mark below orignal name checking codes, but set fotaready=1 to install MBFWdriver
REM ===================================================================================	
set /a fotaready=1	

REM ==================================================================
REM if "!DeviceName!" == " Mobile Broadband Firmware Device" (
REM 	if "!DeviceStatus!" == "running." (
REM 		set /a fotaready=1
REM 	) else (
REM 		set /a fotaready=2
REM 	)
REM ) else if "!DeviceName!" == " Qualcomm Snapdragon X55 5G Mobile Broadband Update Device" (
REM 	set /a fotaready=3
REM ) else (
REM 	if %fotatimming% GTR 9 (
REM 		echo [Check FAIL] Cannot detect FOTA Device !!
REM 		CALL :writelog "[Check FAIL] Cannot detect FOTA Device !!"
REM 		set ferrorlevel=1
REM 	) else (
REM 		REM echo [Check Again] Cannot detect FOTA Device, Wait and check again !!
REM 		CALL :writelog "[Check Again] Cannot detect FOTA Device, Wait and check again !!"
REM 		set /a fotatimming=%fotatimming%+1
REM 		timeout /t 1 >> nul
REM 		call :chkfotaexist
REM 	)
REM )
REM ==================================================================

GOTO :EOF

REM ==================================================================
REM Install mbfwdriver driver
REM ==================================================================
:mbfwdriverinstaller
CALL :writelog "===== Install mbfwdriver driver ====="
powershell -command "Expand-Archive -Force" Drivers\FOTA.zip Drivers 1>>nul 2>>nul
pnputil.exe /add-driver Drivers\FOTA\mbfwdriver.inf /install > driver_temp.log
if %ERRORLEVEL% EQU 0 (
	for /f "tokens=*" %%a in ('find /C "up-to-date" ^< "driver_temp.log"') do set DriverResult=%%a
	type driver_temp.log >> install_log.log
	CALL :writelog "Count the string "up-to-date" [!DriverResult!] !!"
	del driver_temp.log 1>>nul 2>>nul
	echo [STEP  PASS] Install driver [mbfwdriver] successful !!
	echo. >> install_log.log
	CALL :writelog "[STEP  PASS] Install driver [mbfwdriver] successful !!"
) else (
	for /f "tokens=*" %%a in ('find /C "up-to-date" ^< "driver_temp.log"') do set DriverResult=%%a
	type driver_temp.log >> install_log.log
	CALL :writelog "Count the string "up-to-date" [!DriverResult!] !!"
	del driver_temp.log 1>>nul 2>>nul
	if !DriverResult! NEQ 0 (
		echo [STEP  PASS] Install driver [mbfwdriver] successful !!
		echo. >> install_log.log
		CALL :writelog "[STEP  PASS] Install driver [mbfwdriver] successful !!"
	) else (
		echo [STEP  FAIL] Install driver [mbfwdriver] failed !!
		echo. >> install_log.log
		CALL :writelog "[STEP  FAIL] Install driver [mbfwdriver] failed !!"
	)
)

timeout /t 1 >> nul
echo. >> install_log.log
devcon rescan 1>>nul 2>>nul
timeout /t 1 >> nul

CALL :writelog "[STEP Check] Checking the mbfwdriver is running or not !!"
set /a waitcounter=0
:waitformbfwdriver
devcon status "MBFW\{30334630-3041-3643-3034-3134464F5843}" | find "Driver is" > device_status.log
for /f "tokens=1,2,3" %%i in (device_status.log) do set DeviceStatus=%%k

CALL :writelog "Checking the mbfwdriver"
CALL :writelog "DeviceStatus : %DeviceStatus%"
if "%DeviceStatus%" == "running." (
	REM Wait time after ensure FOTA driver is running to check fota_running.txt
	timeout /t 10 >> nul
	call :addregisters
) else (
	if %waitcounter% LEQ 10 (
		set /a waitcounter=%waitcounter% + 1
		timeout /t 1 >> nul
		call :waitformbfwdriver
	) else (
		CALL :writelog "[ Critical ] *************************************************"
		CALL :writelog "[ Critical ] mbfwdriver status is abnormal, please check it !!"
		CALL :writelog "[ Critical ] *************************************************"
		call :addregisters
	)
)

del /F /Q device_status.log 1>>nul 2>>nul

GOTO :EOF

REM ==================================================================
REM Add Registers
REM ==================================================================
:addregisters
CALL :writelog "===== Add register into registry ====="
reg.exe add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Cellular\MVSettings\DeviceSpecific\CellUX" /v EnableLTEReportingOnNSA /t REG_DWORD /d 0x00000004 /f  >> install_log.log
if %ERRORLEVEL% EQU 0 (
	echo [STEP  PASS] Add register EnableLTEReportingOnNSA successful !!
	echo. >> install_log.log
	CALL :writelog "[STEP  PASS] Add register EnableLTEReportingOnNSA successful !!"
) else (
	echo [STEP  WARN] Add register EnableLTEReportingOnNSA failed !!
	echo. >> install_log.log
	CALL :writelog "[STEP  WARN] Add register EnableLTEReportingOnNSA failed !!"
)
echo. >> install_log.log

call :fotaupgrade

GOTO :EOF

REM ==================================================================
REM Check FOTA update
REM ==================================================================
:fotaupgrade
CALL :writelog "===== Check FOTA update ====="
set /a FOTAwaittime=0
:fotawaiting
if %FOTAwaittime% GTR 90 (
	if exist C:\fota_running.txt (
		echo [STEP  WARN] firmware update process over 90 seconds, Current: %FOTAwaittime% !!
		CALL :writelog "[STEP  WARN] fota_running.txt still exist over 90 seconds, Current: %FOTAwaittime% !!"
		set /a FOTAwaittime=%FOTAwaittime%+3
		timeout /t 3 >> nul
		CALL :fotawaiting
	) else (
		echo [STEP  PASS] FW upgrade PASS !!
		CALL :writelog "[STEP  PASS] FW upgrade PASS !!"
		CALL :movelogtopath
	)
) else (
	if exist C:\fota_running.txt (
		set /a fotaflag=1
		echo [STEP Check] start wait for FW upgrade, Current: %FOTAwaittime% !!
		CALL :writelog "[STEP Check] Found fota_running.txt , start wait for FW upgrade, Current: %FOTAwaittime% !!"
		set /a FOTAwaittime=%FOTAwaittime%+3
		timeout /t 3 >> nul
		call :fotawaiting
	) else (
		if %fotaflag% EQU 0 (
			echo [STEP Check] There have no FW upgrade process be generated during 10 seconds !!
			CALL :writelog "[STEP Check] There have no fota_running.txt be generated during 10 seconds !!"
			CALL :movelogtopath
		) else (
			echo [STEP  PASS] FW upgrade PASS !!
			CALL :writelog "[STEP  PASS] FW upgrade PASS !!"
			CALL :movelogtopath
		)
	)
)

GOTO :EOF

REM ==================================================================
REM Check FOTA update
REM ==================================================================
:movelogtopath
mkdir "C:\ProgramData\Qualcomm® Snapdragon™ X55 5G Modem\INF_Injection_Log" 1>>nul 2>>nul
copy /y install_log.log "C:\ProgramData\Qualcomm® Snapdragon™ X55 5G Modem\INF_Injection_Log\" 1>>nul 2>>nul
copy /y log.txt "C:\ProgramData\Qualcomm® Snapdragon™ X55 5G Modem\INF_Injection_Log\" 1>>nul 2>>nul

CALL :writelog "===== Copy file to target ====="
copy /y Drivers\SDx55_Version.dll %windir%\ >> install_log.log
if %ERRORLEVEL% EQU 0 (
	echo [STEP  PASS] Copy file [SDx55_Version.dll] to target successful !!
	CALL :writelog "[STEP  PASS] Copy file [SDx55_Version.dll] to target successful !!"
) else (
	echo [STEP  FAIL] Copy file [SDx55_Version.dll] to target failed !!
	CALL :writelog "[STEP  FAIL] Copy file [SDx55_Version.dll] to target failed !!"
)
echo. >> install_log.log

GOTO :EOF

REM ==================================================================
REM Judge for ERRORFLAG
REM ==================================================================
:DriverInstallEnd

if exist Drivers\FOTA (
	rmdir Drivers\FOTA /s /q 1>>nul 2>>nul
)

echo ==================== Driver Install Complete ====================
CALL :writelog "==================== Driver Install Complete ===================="
set errorlevel=%ferrorlevel%
echo errorlevel=%errorlevel%


REM ****************************************************
if NOT "%errorlevel%"=="0" set errcode=%errorlevel%
GOTO END

:DrvInst
echo *%windir%\system32\Pnputil.exe /add-driver "%~1" /install >> %APP_LOG%
%windir%\system32\Pnputil.exe /add-driver "%~1" /install >> %APP_LOG%
echo Result=%errorlevel% >> %APP_LOG%
if /i [%errorlevel%] == [0] exit /b 0
if /i [%errorlevel%] == [259] exit /b 0
if /i [%errorlevel%] == [3010] exit /b 0
exit /b 1
GOTO:EOF

:ChkDrvClassGuid
if exist c:\system.sav\util\rwini.exe (
    for /f "delims=" %%i in ('c:\system.sav\util\rwini.exe read /file:"%~1" /section:"version" key:"ClassGuid"') do (
        echo ClassGuid=%%~i >> %APP_LOG%.
		for %%x in (%~2) do (if /i [ClassGuid^=%%~i] == [ClassGuid^=%%~x] exit /b 0 )
    )
    exit /b 1
)
for /f "eol=; tokens=1,2 delims== " %%i in ('findstr.exe /i /r /c:"^ClassGuid" "%~1"') do (
    echo ClassGuid=%%~j >> %APP_LOG%
    for %%x in (%~2) do (if /i [%%~i^=%%~j] == [ClassGuid^=%%~x]  exit /b 0)
)
exit /b 1
GOTO:EOF

:RESULTFAILED
ECHO ERRRORLEVEL=%ERRORLEVEL% >> %APP_LOG%
EXIT /B 1
GOTO END

:END
EXIT /B %errcode%

