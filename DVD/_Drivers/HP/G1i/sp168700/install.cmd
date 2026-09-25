@echo off
COLOR 1F
MODE CON COLS=130 LINES=30

set spblock=%~dp0
set SPLog=c:\system.sav\logs\HPApplicationEnablingServices_Softpaq.log
if not exist c:\system.sav\logs\ md c:\system.sav\logs\ 
REM DO NOT LEAVE TRAILING SPACES
SET PNPID=HPIC000C
SET "DevDesc=HP Application Enabling Services"



if exist "%SPLog%" copy /y "%SPLog%" "%SPLog%_%date:/=-%_%time::=-%.log" > nul
del /f /q "%SPLog%" >nul 2>&1










echo %cd% >> "%SPLog%"
echo.>> "%SPLog%"
pushd "%spblock%"
echo %cd% >> "%SPLog%"
echo.>> "%SPLog%"

echo [%time%-%date%]  Running %0 version 2.23.5.10 from "%SPblock%" >> "%SPLog%"
echo.>> "%SPLog%"



set HPSAFolder=HP Application Enabling Services
REM set HPSAFile=None
REM set HPSATargetingFile=No

REM initialization	
REM set dismerror=2	

REM Exit Code to return
REM not 0 - failed
REM 259 - HPSA exit code
REM 0 - pass

REM 2 - Unknown - Default
set Exit_Code=2

del /f /q FAILURE.FLG >nul 2>&1




set PrivilegeType=Standard

:CheckPrivileges 
NET FILE 1>NUL 2>NUL
set error_level=%errorlevel%

if "%error_level%"=="0" set PrivilegeType=Admin
REM if equal 1 for example
if "%error_level%" NEQ "0" set PrivilegeType=Standard

if /i "%PrivilegeType%"=="Standard" echo [%time%-%date%]  "Standard" privileges >> "%SPLog%"
echo.>> "%SPLog%"

if "%PrivilegeType%"=="Standard" set Exit_Code=9999

if "%PrivilegeType%"=="Standard" (
echo.
echo.
echo [%time%-%date%]  %0 script launched with insufficient privileges >> "%SPLog%"
GOTO END
) else ( goto gotAdmin )


:gotAdmin
     echo [%time%-%date%]  Got Admin privileges >> "%SPLog%"



set SystemProfile=No

REM SYSTEM profile will have $ at the end
echo ^%username%|findstr /i /e /c:"$"
set error_level=%errorlevel%

if "%error_level%"=="0" echo [%time%-%date%]  Running in the SYSTEM profile, "%username%" >> "%SPLog%"
if "%error_level%"=="0" set SystemProfile=Yes

if "%error_level%" NEQ "0" echo [%time%-%date%]  Running in the user profile, "%username%" >> "%SPLog%"
echo.>> "%SPLog%"

REM UI support - legacy
set SilentInstall=No

REM Adding support for HPUP.exe
REM Disabling this since HPUP.exe does not support UI
REM if "%1"=="-s" set SilentInstall=Yes
REM Artificially setting SilentInstall to Yes
REM Note: If install.cmd script is changed, HPUP.exe will not respect the install.cmd
set SilentInstall=Yes

if "%SystemProfile%"=="Yes" set SilentInstall=Yes


REM 0 Update successful, no reboot required
REM 259 Update failed
REM 9995 System already up-to-date
REM 9996 Platform not supported
REM 9997/9998 OS not supported
REM 9999 User does not have Admin privileges
REM 3010 Update successful, reboot required
REM 3015 Update successful, shutdown required



echo.>> "%SPLog%"


cls
echo.
echo ==============================================================================
echo ==                                                                          ==
echo == Please close and save your opening documents and applications, before    ==
echo == pressing any key to continue the SoftPAQ update process.                 ==
echo ==                                                                          ==
echo == Please do not close the program execution window, shut down or remove    ==
echo == the external power from your system during the SoftPAQ update process.   ==
echo ==                                                                          ==
echo ==============================================================================
echo.

if /i "%SilentInstall%"=="No" (
pause
echo.
echo Proceeding...
)




:HPHWCheck

REM echo [%time%-%date%]  Collect ComputerSystem Manufacturer information >> "%SPLog%"
REM echo.>> "%SPLog%"

REM del /f /q manufacturer.txt >nul 2>&1
REM wmic baseboard get manufacturer|more > manufacturer.txt
REM echo [%time%-%date%]  wmic baseboard get manufacturer Error Level="%errorlevel%" >> "%SPLog%"

REM Don't use for now
REM wmic computersystem get manufacturer|more > manufacturer.txt

REM if exist manufacturer.txt type manufacturer.txt >> "%SPLog%"

REM findstr /i /c:"hp" manufacturer.txt >nul 2>&1
REM set error_level=%errorlevel%

REM del /f /q manufacturer.txt >nul 2>&1

REM if "%error_level%" NEQ "0" echo [%time%-%date%]  This is not an HP system. Exiting softpaq installation >> "%SPLog%"
REM if "%error_level%" NEQ "0" set Exit_Code=9996
REM if "%error_level%" NEQ "0" echo This is not an HP system. > FAILURE.FLG
REM if "%error_level%" NEQ "0" GOTO END

REM echo [%time%-%date%]  This is an HP system >> "%SPLog%"


REM Production


echo.>> "%SPLog%"
echo.>> "%SPLog%"

echo [%time%-%date%]  Performing hpdc.exe rescan to rePNP Fusion if it was just removed >> "%SPLog%"
hpdc.exe rescan >> "%SPLog%" 2>&1
echo.>> "%SPLog%"
echo.>> "%SPLog%"


echo [%time%-%date%]  Collecting PNPID of HSA Fusion Base device, - Fusion needs HPIC0003 Consumer or HPIC000C Commercial. Will be used as information only. This has been proven to be not reliable >> "%SPLog%"
echo [%time%-%date%]  Value of 0 returned, PNPID found. >> "%SPLog%"
echo [%time%-%date%]  Value of 1 returned, PNPID not found. >> "%SPLog%"
echo.>> "%SPLog%"
REM if FUSION PNPIDs are not present go to end

echo [%time%-%date%]  HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Enum\ACPI\HPIC0003 >> "%SPLog%"
reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Enum\ACPI\HPIC0003" >> "%SPLog%" 2>&1
echo [%time%-%date%]  reg query consumer Error Level = "%errorlevel%" >> "%SPLog%"
echo.>> "%SPLog%"

echo [%time%-%date%]  HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Enum\ACPI\HPIC000C >> "%SPLog%"
reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Enum\ACPI\HPIC000C" >> "%SPLog%" 2>&1
echo [%time%-%date%]  reg query commercial Error Level = "%errorlevel%" >> "%SPLog%"
echo.>> "%SPLog%"

echo [%time%-%date%]  HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Enum\ACPI\HPIC0003 >> "%SPLog%"
reg query "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Enum\ACPI\HPIC0003" >> "%SPLog%" 2>&1
echo [%time%-%date%]  reg query consumer Error Level = "%errorlevel%" >> "%SPLog%"
echo.>> "%SPLog%"

echo [%time%-%date%]  HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Enum\ACPI\HPIC000C >> "%SPLog%"
reg query "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Enum\ACPI\HPIC000C" >> "%SPLog%" 2>&1
echo [%time%-%date%]  reg query commercial Error Level = "%errorlevel%" >> "%SPLog%"
echo.>> "%SPLog%"






echo [%time%-%date%]  Checking to see if the Fusion PNPID is present >> "%SPLog%"

Set FusionPNPID=No
REM ACPI\HPIC000C

REM if findstr errorlevel 0, can't find the device
REM if findstr errorlevel 1, found the device

hpdc.exe find "ACPI\%PNPID%"|findstr /i /c:"No matching devices found." >nul
set error_level=%errorlevel%

REM if findstr errorlevel 0, can't find the device
REM if findstr errorlevel 1, found the device

if "%error_level%"=="1" Set FusionPNPID=Yes
if "%error_level%"=="1" echo [%time%-%date%]  Supported device, %DevDesc%, found >> "%SPLog%"

if "%FusionPNPID%"=="No" (
echo [%time%-%date%]  No Fusion PNPID, ACPI\%PNPID%, found, Exiting driver installation. Returning errflg=9996 >> "%SPLog%"
set errflg=9996
echo [%time%-%date%]  errflg="%errflg%" >> "%SPLog%"
GOTO END
) 

echo.>> "%SPLog%"
echo.>> "%SPLog%"

echo.>> "%SPLog%"
echo.>> "%SPLog%"


:ExitHPHWCheck
echo.>> "%SPLog%"

:DrvInstallation

echo [%time%-%date%]  Gathering driver installers >> "%SPLog%"
echo.>> "%SPLog%"

del /f /q installers.txt >nul 2>&1

dir /a /b /s install.cmd|findstr /i /c:".B2"|findstr /i /c:"\\src\\"|findstr /i /c:"\\drivers\\" > installers.txt

findstr /i /c:"drivers" installers.txt >nul
set error_level=%errorlevel%

if "%error_level%" NEQ "0" echo [%time%-%date%]  No driver bits found. Exiting >> "%SPLog%"
if "%error_level%" NEQ "0" set Exit_Code=0
if "%error_level%" NEQ "0" GOTO ExitDrvInstallation

echo [%time%-%date%]  Software bits found. >> "%SPLog%"


:StoppingFusionServices

REM Disabling this per the HPSA Team
GOTO SkipStoppingFusionServices
echo [%time%-%date%]  Stopping HSA Fusion services before installing updates >> "%SPLog%"

sc stop HPDiagsCap >> "%SPLog%" 2>&1
sc stop HPAppHelperCap >> "%SPLog%" 2>&1
sc stop HPNetworkCap >> "%SPLog%" 2>&1
sc stop HPSysInfoCap >> "%SPLog%" 2>&1
taskkill /f /im DiagsCap.exe >> "%SPLog%" 2>&1
taskkill /f /im apphelpercap.exe >> "%SPLog%" 2>&1
taskkill /f /im networkcap.exe >> "%SPLog%" 2>&1
taskkill /f /im sysinfocap.exe >> "%SPLog%" 2>&1
taskkill /f /im bridgecommunication.exe >> "%SPLog%" 2>&1

:SkipStoppingFusionServices


set pnputilreturncode=2

setlocal enabledelayedexpansion

if exist pnputilreturncode.txt del /f /q pnputilreturncode.txt

for /f "tokens=1 delims=	" %%a in ( installers.txt ) do (

if "%SilentInstall%"=="Yes" (
echo Calling "%%a" -s >> "%SPLog%"
call "%%a" -s >> "%SPLog%" 2>&1
set error_level=!errorlevel!
)

if "%SilentInstall%"=="No" (
echo Calling "%%a" >> "%SPLog%"
call "%%a" >> "%SPLog%" 2>&1
set error_level=!errorlevel!
)

echo.>> "%SPLog%"

echo [%time%-%date%]  Installation returned error_level="!error_level!" >> "%SPLog%"

if "!error_level!" == "0" echo [%time%-%date%]  Installation succeeded with error_level="!error_level!" >> "%SPLog%"
if "!error_level!" == "259" echo [%time%-%date%]  Installation succeeded with error_level="!error_level!" >> "%SPLog%"
if "!error_level!" == "3010" echo [%time%-%date%]  Installation succeeded with error_level="!error_level!" >> "%SPLog%"
if "!error_level!" == "259" set error_level="0"
if "!error_level!" == "3010" set error_level="0"
if "!error_level!" == "0" echo [%time%-%date%]  Installation succeeded with error_level="!error_level!" >> "%SPLog%"

REM slash reboot not used
REM if "!error_level!" == "1641" echo [%time%-%date%]  Installation succeeded with error_level="!error_level!" >> "%SPLog%"
REM if "!error_level!" == "1641" set error_level="0"

echo ^!error_level!> pnputilreturncode.txt	
)
endlocal

echo.>> "%SPLog%"
echo [%time%-%date%]  for loop Error Level="%errorlevel%" >> "%SPLog%"
	
REM Debug
for /f "tokens=1 delims=	" %%a in ( pnputilreturncode.txt ) do set pnputilreturncode=%%a

echo [%time%-%date%]  pnputilreturncode="%pnputilreturncode%" >> "%SPLog%"
	
REM echo [%time%-%date%]  Starting HSA Fusion services after installing updates just in case any failed to install, start >> "%SPLog%"
REM sc start HPSysInfoCap >> "%SPLog%" 2>&1
REM sc start HPNetworkCap >> "%SPLog%" 2>&1	
REM sc start HPAppHelperCap >> "%SPLog%" 2>&1
	
:ExitDrvInstallation

echo [%time%-%date%]  Starting HSA Fusion services after installing updates just in case any failed to install, start >> "%SPLog%"

sc start HPSysInfoCap >> "%SPLog%" 2>&1
sc start HPNetworkCap >> "%SPLog%" 2>&1
sc start HPAppHelperCap >> "%SPLog%" 2>&1
sc start HPDiagsCap >> "%SPLog%" 2>&1

:ExitDrvInstallation


echo [%time%-%date%]  Exiting softpaq installation. >> "%SPLog%"


		
REM Changed logic 2.21.10.17

if "%pnputilreturncode%" NEQ "0" set exit_code=1%pnputilreturncode%

if "%pnputilreturncode%"=="0" set exit_code=0


echo.>> "%SPLog%"

echo.>> "%SPLog%"

	

:END

del /f /q pnputilreturncode.txt >nul 2>&1
del /f /q manufacturer.txt >nul 2>&1
del /f /q version.txt >nul 2>&1
del /f /q installers.txt >nul 2>&1

echo [%time%-%date%]  Restarting ing HSA Fusion services >> "%SPLog%"

sc start HPSysInfoCap >> "%SPLog%" 2>&1
sc start HPNetworkCap >> "%SPLog%" 2>&1
sc start HPAppHelperCap >> "%SPLog%" 2>&1
sc start HPDiagsCap >> "%SPLog%" 2>&1


echo [%time%-%date%]  Finished running %0 with Exit_Code="%Exit_Code%" >> "%SPLog%"

REM 9999, 9997, 3010, 3015 can be implemented if needed

REM if 10==5 ( echo yes) else ( echo no )
REM IF EXIST Product.dat (
REM del Product.dat
REM ) ELSE (
REM echo The Product.dat file is missing.
REM )

REM Depricating since we need to know the real exit_code
REM if exist FAILURE.FLG if "%Exit_Code%" NEQ "9999" if "%Exit_Code%" NEQ "9998" if "%Exit_Code%" NEQ "9996" if "%Exit_Code%" NEQ "9995" if "%Exit_Code%" NEQ "3010" if "%Exit_Code%" NEQ "3015" if "%Exit_Code%" NEQ "0" set Exit_Code=259 
REM if not exist FAILURE.FLG if "%Exit_Code%" NEQ "9999" if "%Exit_Code%" NEQ "9998" if "%Exit_Code%" NEQ "9996" if "%Exit_Code%" NEQ "9995" if "%Exit_Code%" NEQ "3010" if "%Exit_Code%" NEQ "3015" if "%Exit_Code%" NEQ "0" set Exit_Code=259


if "%Exit_Code%"=="259" GOTO FailedUpdate
if "%Exit_Code%"=="0" GOTO SuccessfulUpdate
if "%Exit_Code%"=="3010" GOTO SuccessfulRestart
if "%Exit_Code%"=="3015" GOTO SuccessfulShutdown
if "%Exit_Code%"=="9995" GOTO SoftwareUpToDate
if "%Exit_Code%"=="9996" GOTO SystemNotSupported
if "%Exit_Code%"=="9998" GOTO OSNotSupported
if "%Exit_Code%"=="9999" GOTO NoAdminPrivileges

REM Not yet implemented
REM if "%Exit_Code%"=="9997" GOTO OSNotSupported


REM 0 Update successful, no reboot required
REM 259 Update failed
REM 3010 Update successful, reboot required
REM 3015 Update successful, shutdown required
REM 9995 System already up-to-date
REM 9996 Platform not supported
REM 9998 OS not supported
REM 9999 User does not have Admin privileges


if "%Exit_Code%" NEQ "0" if "%Exit_Code%" NEQ "259" if "%Exit_Code%" NEQ "3010" if "%Exit_Code%" NEQ "3015" if "%Exit_Code%" NEQ "9995" if "%Exit_Code%" NEQ "9996" if "%Exit_Code%" NEQ "9997" if "%Exit_Code%" NEQ "9998" if "%Exit_Code%" NEQ "9999" GOTO FailedUpdate

:Finished

REM for SCCM 
if "%Exit_Code%"=="0" set Exit_Code=3010
if "%Exit_Code%"=="3015" set Exit_Code=3010
if "%Exit_Code%"=="9995" set Exit_Code=3010

echo [%time%-%date%]  Finished running %0 with Exit_Code="%Exit_Code%" for HPSA >> "%SPLog%"
echo.>> "%SPLog%"
echo.>> "%SPLog%"


echo %cd% >> "%SPLog%"
echo.>> "%SPLog%"
popd
echo %cd% >> "%SPLog%"
echo.>> "%SPLog%"



if "%1"=="-debug" (
echo [%time%-%date%]  Collect debug logs >> "%SPLog%"
copy /y c:\system.sav\logs\HPFusion.log "%SPblock%" >> "%SPLog%" 2>&1
)


if "%1" NEQ "-debug" (
echo [%time%-%date%]  Deleting debug logs >> "%SPLog%"
del /f /q "%SPblock%\HPApplicationEnablingServices_Softpaq" >> "%SPLog%" 2>&1

del /f /q "%SPblock%\HPFusion.log" >> "%SPLog%" 2>&1
del /f /q "%SPblock%\cmdline.txt" >> "%SPLog%" 2>&1
)


REM 7 character limit on exit code returned, e.g 1100020

exit /b %Exit_Code%


REM 0 Update successful, no reboot required
REM 259 Update failed
REM 3010 Update successful, reboot required
REM 3015 Update successful, shutdown required
REM 9995 System already up-to-date
REM 9996 Platform not supported
REM 9997/9998 OS not supported
REM 9999 User does not have Admin privileges



:SuccessfulUpdate

echo [%time%-%date%]  The software was successfully updated >> "%SPLog%"
cls
echo.
echo ==============================================================================
echo ==                                                                          ==
echo ==                   The software was successfully updated.                 ==
echo ==                                                                          ==
echo ==============================================================================
echo.
if "%SilentInstall%"=="No" echo Press any key to exit.
echo.
if "%SilentInstall%"=="No" pause >nul

GOTO Finished


:SuccessfulRestart

echo [%time%-%date%]  The software was successfully updated. A restart is required (3010--0) >> "%SPLog%"
cls
echo.
echo ==============================================================================
echo ==                                                                          ==
echo == The software was successfully updated. A restart is required (3010--0)   ==
echo ==                                                                          ==
echo ==============================================================================
echo.
if "%SilentInstall%"=="No" echo Press any key to exit.
echo.
if "%SilentInstall%"=="No" pause >nul

GOTO Finished


:SuccessfulShutdown

echo [%time%-%date%]  The software was successfully updated. A shutdown is required (3015) >> "%SPLog%"
cls
echo.
echo ==============================================================================
echo ==                                                                          ==
echo == The software was successfully updated. A shutdown is required (3015--0)  ==
echo ==                                                                          ==
echo ==============================================================================
echo.
if "%SilentInstall%"=="No" echo Press any key to exit.
echo.
if "%SilentInstall%"=="No" pause >nul

GOTO Finished



:SoftwareUpToDate

echo [%time%-%date%]  The software installed is already up to date (9995--0). >> "%SPLog%"
cls
echo.
echo ==============================================================================
echo ==                                                                          ==
echo ==         The software installed is already up to date (9995--0)           ==
echo ==                                                                          ==
echo ==============================================================================
echo.
if "%SilentInstall%"=="No" echo Press any key to exit.
echo.
if "%SilentInstall%"=="No" pause >nul

GOTO Finished



:FailedUpdate

echo [%time%-%date%]  An error occurred during the SoftPAQ Update process, error="%Exit_Code%" >> "%SPLog%"
cls
echo.
echo ==============================================================================
echo ==                                                                          ==
echo ==        An error occurred during the SoftPAQ Update process (%Exit_Code%)        ==
echo ==                                                                          ==
echo ==============================================================================
echo.
if "%SilentInstall%"=="No" echo Press any key to exit.
echo.
if "%SilentInstall%"=="No" pause >nul

GOTO Finished



:SystemNotSupported

echo [%time%-%date%]  This SoftPAQ does not support this system (9996). >> "%SPLog%"
cls
echo.
echo ==============================================================================
echo ==                                                                          ==
echo ==         This SoftPAQ does not support this system (9996)                 ==
echo ==                                                                          ==
echo ==============================================================================
echo.
if "%SilentInstall%"=="No" echo Press any key to exit.
echo.
if "%SilentInstall%"=="No" pause >nul

GOTO Finished



:OSNotSupported
echo [%time%-%date%]  This SoftPAQ does not support this Windows Operating System (9998). >> "%SPLog%"
cls
echo.
echo ==============================================================================
echo ==                                                                          ==
echo ==    This SoftPAQ supports Windows 10 1709 64-bit OS and up only (9998)    ==
echo ==                                                                          ==
echo ==============================================================================
echo.
if "%SilentInstall%"=="No" echo Press any key to exit.
echo.
if "%SilentInstall%"=="No" pause >nul

GOTO Finished


:NoAdminPrivileges
echo [%time%-%date%]  This SoftPAQ user does have administrative privileges (9999). >> "%SPLog%"
cls
echo.
echo ==============================================================================
echo ==                                                                          ==
echo ==    This SoftPAQ user does not have administrative privileges (9999)      ==
echo ==                                                                          ==
echo ==============================================================================
echo.
if "%SilentInstall%"=="No" echo Press any key to exit.
echo.
if "%SilentInstall%"=="No" pause >nul

GOTO Finished

endlocal
