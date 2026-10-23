REM ========================================================
REM   Driver deliverable installation
REM ========================================================

@ECHO OFF
SET "Template=v2.09.ps"
if defined FCC_LOG_FOLDER (SET "APP_LOG_FOLDER=%FCC_LOG_FOLDER%") else (SET "APP_LOG_FOLDER=%ProgramData%\hp\logs")
set PartNumber=
for /f "delims=" %%a in ('dir /a-d /b "%~dp0..\*.CVA" 2^>nul') do (if /i not "%%~a" == "" set PartNumber=%%~na)
if defined PartNumber (SET "APP_LOG=%APP_LOG_FOLDER%\%PartNumber%.LOG") else (SET "APP_LOG=%APP_LOG_FOLDER%\%~n0.log")
if not exist "%APP_LOG_FOLDER%" md "%APP_LOG_FOLDER%"

ECHO ############################################################# >> %APP_LOG%
ECHO  [%DATE%]                                                     >> %APP_LOG%
ECHO  [%TIME%] Beginning of the %~nx0, Ver: %Template%             >> %APP_LOG%
ECHO ############################################################# >> %APP_LOG%

set "ExtensionGuid={e2f84ce7-8efa-411c-aa69-97454ca4cb57}"
set "SoftwareComponenGuid={5c4c3332-344d-483c-8739-259e934c9cc8}"

rem
rem If CVA of DPB_Compliant=1, skip driver online due to offline has be installed.
rem
if defined DPB_Compliant echo ***INFO*** DPB Driver, skip the drivers installation. >> "%APP_LOG%" & goto :Other_Driver

rem
rem No need to install driver (online) during preinstall if it supports INF injection, and doesn't have NOINF.FLG
rem
set NOINFFLG=%~dp0..\NOINF.FLG
if defined FCCPath set NOINFFLG=%FCCPath%NOINF.FLG

if not exist "%NOINFFLG%" if exist "c:\system.sav\tweaks" if exist "c:\system.sav\flags\Proteus.FLG" (
    echo ***INFO*** For Preinstall, we've already injected the driver offline --^> skip the installation here. >> "%APP_LOG%"
    goto :Other_Driver
)

REM ------------------- Script Entry ------------------------
:DCH_Driver
echo [%TIME%] Search DCH driver >> %APP_LOG%
set "drv_root="
for /d %%D in ("%~dp0Driver*") do set "drv_root=%%~fD"

if not defined drv_root (
    echo [%TIME%] No Driver folder found, skip DCH driver install. >> %APP_LOG%
    goto Other_Driver
)

echo [%TIME%] Find %drv_root%, installing ... >> %APP_LOG%
if exist "%drv_root%\*.inf" call:DrvPolicy "%drv_root%" >> %APP_LOG%
if errorlevel 1 echo [%TIME%] Install failed. >> %APP_LOG% & goto RESULTFAILED
echo [%TIME%] Install success. >> %APP_LOG%

for /f "delims=" %%a in ('dir /ad /b /s "%drv_root%" 2^>nul') do (
	call:CheckParentHasDrvOrder "%%~a" "%drv_root%"
	if not errorlevel 1 (
		echo [%TIME%] Find %%~a, installing ... >> %APP_LOG%
		call:DrvPolicy "%%~a" >> %APP_LOG%
		if errorlevel 1 echo [%TIME%] Install failed. >> %APP_LOG% & goto RESULTFAILED
		echo [%TIME%] Install success. >> %APP_LOG%
	) else (
		echo [%TIME%] Skip %%~a due to parent having drvorder.txt >> %APP_LOG%
	)
)

:Other_Driver
if not exist "%~dp0legacy\legacydrv.cmd" GOTO UWPAPP
echo [%TIME%] Call "%~dp0legacy\legacydrv.cmd" >> %APP_LOG%
Pushd "%~dp0legacy"
call "%~dp0legacy\legacydrv.cmd"
Popd
if not [%errorlevel%] == [0] echo [%TIME%] legacydrv.cmd failed >> %APP_LOG% & goto RESULTFAILED
echo [%TIME%] legacydrv.cmd success >> %APP_LOG%

:UWPAPP
if not exist "%~dp0installapp.cmd" GOTO WIN32APP
echo [%TIME%] Call "%~dp0installapp.cmd" >> %APP_LOG%
call "%~dp0installapp.cmd"
if not [%errorlevel%] == [0] echo [%TIME%] installapp.cmd failed >> %APP_LOG% & goto RESULTFAILED
echo [%TIME%] installapp.cmd success >> %APP_LOG%

:WIN32APP
if not exist "%~dp0legacy\legacyapp.cmd" GOTO END
echo [%TIME%] call "%~dp0legacy\legacyapp.cmd" >> %APP_LOG%
Pushd "%~dp0legacy"
call "%~dp0legacy\legacyapp.cmd"
Popd
if not [%errorlevel%] == [0] echo [%TIME%] legacyapp.cmd failed >> %APP_LOG% & GOTO RESULTFAILED
echo [%TIME%] legacyapp.cmd success >> %APP_LOG%
GOTO END

:DrvPolicy
set "drvfolder=%~1"
if not exist "%drvfolder%\drvorder.txt" (
	echo [%TIME%] Search BASE driver in "%drvfolder%\*.inf"
	for /f "delims=" %%i in ('dir /a-d /b "%drvfolder%\*.inf" 2^>nul') do (
		echo [%TIME%] Check "%drvfolder%\%%~i" driver category.
		call:ChkDrvClassGuid "%drvfolder%\%%~i" "%ExtensionGuid% %SoftwareComponenGuid%"
		if errorlevel 1 (
			echo [%TIME%] Driver category match, install it.
			call:DrvInst "%drvfolder%\%%~i"
			if errorlevel 1 echo [%TIME%] %%~i driver install failed. & exit /b 1
			echo [%TIME%] %%~i driver install success.
		) else (
			echo [%TIME%] Driver category mismatch.
		)
	)
	echo.
	echo [%TIME%] Search EXTENSION driver in "%drvfolder%\*.inf"
	for /f "delims=" %%i in ('dir /a-d /b "%drvfolder%\*.inf" 2^>nul') do (
		echo [%TIME%] Check "%drvfolder%\%%~i" driver category.
		call:ChkDrvClassGuid "%drvfolder%\%%~i" "%ExtensionGuid%"
		if not errorlevel 1 (
			echo [%TIME%] Driver category match, install it.
			call:DrvInst "%drvfolder%\%%~i"
			if errorlevel 1 echo [%TIME%] %%~i driver install failed. & exit /b 1
			echo [%TIME%] %%~i driver install success.
		) else (
			echo [%TIME%] Driver category mismatch.
		)
	)
	echo.
	echo [%TIME%] Search COMPONENT driver in "%drvfolder%\*.inf"
	for /f "delims=" %%i in ('dir /a-d /b "%drvfolder%\*.inf" 2^>nul') do (
		echo [%TIME%] Check "%drvfolder%\%%~i" driver category.
		call:ChkDrvClassGuid "%drvfolder%\%%~i" "%SoftwareComponenGuid%"
		if not errorlevel 1 (
			echo [%TIME%] Driver category match, install it. 
			call:DrvInst "%drvfolder%\%%~i"
			if errorlevel 1 echo [%TIME%] %%~i driver install failed. & exit /b 1
			echo [%TIME%] %%~i driver install success. 
		) else (
			echo [%TIME%] Driver category mismatch.
		)
	)
) else (
	echo.
	echo [%TIME%] Install driver by drvorder.txt
	for /f "delims=" %%i in ('type "%drvfolder%\drvorder.txt"') do (
		echo [%TIME%] Check "%drvfolder%\%%~i"
		if not exist "%drvfolder%\%%~i" echo could not found the inf file. & exit /b 1
		echo [%TIME%] Install "%drvfolder%\%%~i"
		call:DrvInst "%drvfolder%\%%~i"
		if errorlevel 1 echo [%TIME%] %%~i driver install failed. & exit /b 1
		echo [%TIME%] Driver install success.
	)
)
exit /b 0
GOTO:EOF

:DrvInst
if not exist "%~dp0hpnewdevice.exe" goto Pnputil
echo %~dp0hpnewdevice.exe "%~1"
"%~dp0hpnewdevice.exe" "%~1"
echo Result=%errorlevel%
exit /b %errorlevel%
GOTO:EOF
:Pnputil
echo %windir%\system32\Pnputil.exe /add-driver "%~1" /install
%windir%\system32\Pnputil.exe /add-driver "%~1" /install
echo Result=%errorlevel%
if /i [%errorlevel%] == [0] exit /b 0
if /i [%errorlevel%] == [259] exit /b 0
if /i [%errorlevel%] == [3010] exit /b 0
exit /b 1
GOTO:EOF

:CheckParentHasDrvOrder
set "anc=%~1"
set "root=%~2"
:CheckParentHasDrvOrderLoop
for %%I in ("%anc%\..") do set "parent=%%~fI"
if exist "%parent%\drvorder.txt" exit /b 1
if /i "%parent%"=="%root%" exit /b 0
if "%parent%"=="%anc%" exit /b 0
set "anc=%parent%"
goto CheckParentHasDrvOrderLoop

:ChkDrvClassGuid
for /f "eol=; tokens=1,2 delims== " %%i in ('%windir%\system32\find.exe /i "ClassGuid" "%~1" ^| %windir%\system32\findstr.exe /i /r /c:"^ClassGuid"') do (
    echo ClassGuid=%%~j
    for %%x in (%~2) do (if /i [%%~i^=%%~j] == [ClassGuid^=%%~x]  exit /b 0)
)
exit /b 1
GOTO:EOF

:RESULTFAILED
ECHO ERRORLEVEL=%ERRORLEVEL% >> %APP_LOG%
EXIT /B 1
GOTO END

:END
EXIT /B 0



