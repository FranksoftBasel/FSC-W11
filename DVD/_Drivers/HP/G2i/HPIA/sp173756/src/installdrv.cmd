REM ========================================================
REM   Driver deliverable installation
REM 
REM   Template Version: V1.08.Share
REM ========================================================
REM templateversion=1.08.Share
set versiondrv=1.08.Share
set errcode=0
REM %Description of deliverable%
@ECHO OFF
REM ****************************************************
REM *      COMPONENT OWNER TO UPDATE (SW_TITLE)        *
REM ****************************************************
SET SW_TITLE=SW_TITLE
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
    SET "APP_LOG=%ProgramData%\HP\logs\%SW_TITLE%.log"
    if not exist "%ProgramData%\HP\logs" md "%ProgramData%\HP\logs"
)

rem
rem No need to install driver here (online) during preinstall if it supports INF injection, and doesn't have NOINF.FLG
rem NOINF.flg is only used for Preinstall.
REM For default FCC (non-softpaq)
set NOINFFLG=..\NOINF.FLG
REM Re-set Noinf path, use in softpaq in preinstall.
if defined FCCPath set NOINFFLG=%FCCPath%NOINF.FLG

if not exist %NOINFFLG% if exist "c:\system.sav\tweaks" if exist "c:\system.sav\flags\Proteus.FLG" (
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

if not exist %NOINFFLG% if exist "c:\system.sav\tweaks" if exist "c:\system.sav\flags\Proteus.FLG" (
	echo [%TIME%] pnputil.exe /add-driver drivers\netadapter\WwanNetM80.inf /install >> %APP_LOG%
	pnputil.exe /add-driver drivers\netadapter\WwanNetM80.inf /install >> %APP_LOG%

	echo [%TIME%] pnputil.exe /add-driver drivers\gnss\IntelGNSSDriver.inf /install >> %APP_LOG%
	pnputil.exe /add-driver drivers\gnss\IntelGNSSDriver.inf /install >> %APP_LOG%

	echo [%TIME%] pnputil.exe /add-driver drivers\wccd\WirelessCCD.inf /install >> %APP_LOG%
	pnputil.exe /add-driver drivers\wccd\WirelessCCD.inf /install >> %APP_LOG%

	echo [%TIME%] pnputil.exe /add-driver drivers\fwflashing\FwFlashDriver.inf /install >> %APP_LOG%
	pnputil.exe /add-driver drivers\fwflashing\FwFlashDriver.inf /install >> %APP_LOG%
		
)

echo. >> %APP_LOG%
echo [%DATE% %TIME%] === Start installing the fwupdate driver === >> %APP_LOG%

pnputil.exe /add-driver drivers\fwupdate\FwUpdateDriver.inf /install >> %APP_LOG% 2>&1

echo [%TIME%] Copying HP_Version.dll to System32 >> %APP_LOG%
copy /y .\HP_Version.dll C:\Windows\System32\drivers >> %APP_LOG% 2>&1

rem Start DLMRH01-19305 add copy script for MIPI/Disable band/SAR&ATT image in installer script
rem content: copy plt.bin,all_att/sar_table to C:\\ProgramData\\HP\\DLMRH01
rem ==============================
set "SRC_ROOT=%~dp0"
set "SRC_BIN=%SRC_ROOT%plt.bin"
set "SRC_SAR=%SRC_ROOT%all_sar_table"
set "SRC_ATT=%SRC_ROOT%all_att_table"

set "DST1=%ProgramData%\HP\DLMRH01"

echo. >> %APP_LOG%
echo [%TIME%] ===== Install DLMRH01 data ===== >> %APP_LOG%
echo [%TIME%] SRC_ROOT = %SRC_ROOT% >> %APP_LOG%
echo [%TIME%] DST1     = %DST1% >> %APP_LOG%
echo.

if not exist "%SRC_BIN%" (
    echo [%TIME%][ERROR] Missing file: %SRC_BIN% >> %APP_LOG%
)

if not exist "%SRC_SAR%" (
    echo [%TIME%][ERROR] Missing folder: %SRC_SAR% >> %APP_LOG%
)

if not exist "%SRC_ATT%" (
    echo [%TIME%][ERROR] Missing folder: %SRC_ATT% >> %APP_LOG%
)

mkdir "%DST1%" 2>nul

copy /Y "%SRC_BIN%" "%DST1%\plt.bin" >> %APP_LOG% 2>&1
if errorlevel 1 (
    echo [%TIME%][ERROR] Failed to copy plt.bin to %DST1% >> %APP_LOG%
)

copy /Y "%SRC_BIN%" "%DST1%\SARATT_version" >> %APP_LOG% 2>&1
if errorlevel 1 (
    echo [%TIME%][ERROR] Failed to copy SARATT_version to %DST1% >> %APP_LOG%
)

robocopy "%SRC_SAR%" "%DST1%\all_sar_table" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /NP >> %APP_LOG% 2>&1
if errorlevel 8 (
    echo [%TIME%][ERROR] Failed to copy all_sar_table to %DST1% >> %APP_LOG%
)

robocopy "%SRC_ATT%" "%DST1%\all_att_table" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /NP >> %APP_LOG% 2>&1
if errorlevel 8 (
    echo [%TIME%][ERROR] Failed to copy all_att_table to %DST1% >> %APP_LOG%
)
rem End DLMRH01-19305 add copy script for MIPI/Disable band/SAR&ATT image in installer script 
rem ==============================

REM call WaitForFWFlashComplete.bat

echo [%DATE% %TIME%] === Done installing the fwupdate driver === >> %APP_LOG%




REM ****************************************************
if NOT "%errorlevel%"=="0" set errcode=%errorlevel%
GOTO END

:DrvInst
echo *%windir%\system32\Pnputil.exe /add-driver "%~1" /install >> %APP_LOG%
%windir%\system32\Pnputil.exe /add-driver "%~1" /install >> %APP_LOG%
echo Result=%errorlevel% >> %APP_LOG%
if /i [%errorlevel%] == [0] exit /b 0
if /i [%errorlevel%] == [9] exit /b 0
if /i [%errorlevel%] == [259] exit /b 0
if /i [%errorlevel%] == [3010] exit /b 0
exit /b 1
GOTO:EOF

:ChkDrvClassGuid
for /f "eol=; tokens=1,2 delims== " %%i in ('%windir%\system32\findstr.exe /i /r /c:"^ClassGuid" "%~1"') do (
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

