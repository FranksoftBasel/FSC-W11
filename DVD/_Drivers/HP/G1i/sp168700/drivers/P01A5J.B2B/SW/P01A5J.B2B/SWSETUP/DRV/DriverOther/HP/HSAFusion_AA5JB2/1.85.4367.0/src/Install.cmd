@echo off
REM To prevent all commands in a batch file, including the echo off command, from displaying on the screen, on the first line of the batch file type: @echo off

If "%log%"=="" set log=c:\system.sav\logs\CEPS
REM Re-assign your log folder to %FCC_LOG_FOLDER% if it exists
if exist %FCC_LOG_FOLDER% set log=%FCC_LOG_FOLDER%

If NOT Exist "%log%" md "%log%"
SET MY_LOG=%log%\HPFusion.log
SET CMDLog=%log%\cmdline.txt


SET PNPID=HPIC000C
SET "DevDesc=HP Application Driver"



SET tblock=%~dp0

echo %cd% >> "%MY_LOG%"
echo.>> "%MY_LOG%"
pushd "%tblock%"
echo %cd% >> "%MY_LOG%"
echo.>> "%MY_LOG%"

echo [%time%-%date%]  ********************** >> "%MY_LOG%"
echo [%time%-%date%]   HSA Fusion Driver  >> "%MY_LOG%"
echo [%time%-%date%]  ********************** >> "%MY_LOG%"
echo.>> "%MY_LOG%"
echo [%time%-%date%]  Running "%0" version 2.22.4.28 from "%tblock%" >> "%MY_LOG%"
echo.>> "%MY_LOG%"
echo.>> "%MY_LOG%"

SET errflg=2
SET errflg1=2
SET errflg2=2
echo [%time%-%date%]  Setting errflg to "%errflg%", unknown status >> "%MY_LOG%"
echo.>> "%MY_LOG%"
echo.>> "%MY_LOG%"



:Install_INF

REM xcopy ".\x64\Logging.dll" "C:\Program Files\HP\HP Application Enabling Services" /s/e/y >> "%MY_LOG%" 2>&1
REM If %Errorlevel% NEQ 0 (set errflg=%Errorlevel%)
REM @echo %date% %time%  copy Logging.dll : Error Level "%errflg%" >> "%MY_LOG%"

if not exist oobeparts\ GOTO SkipOOBEParts

REM md "C:\Program Files\HP\HP Application Enabling Services\"

md c:\hp\bridge\
md c:\programdata\hp\bridge\
md c:\programdata\hp\registration\
md c:\hp\HPQWare\bridge\


xcopy ".\oobeparts\oobe1.txt" "c:\hp\bridge" /s/e/y >> "%MY_LOG%" 2>&1
echo %date% %time%  xcopy oobe1.txt : Error Level "%errorlevel%" >> "%MY_LOG%"

xcopy ".\oobeparts\sub1.txt" "c:\hp\bridge" /s/e/y >> "%MY_LOG%" 2>&1
echo %date% %time%  xcopy sub1.txt : Error Level "%errorlevel%" >> "%MY_LOG%"

xcopy ".\oobeparts\oobe2.txt" "c:\programdata\hp\bridge" /s/e/y >> "%MY_LOG%" 2>&1
echo %date% %time%  xcopy oobe2.txt : Error Level "%errorlevel%" >> "%MY_LOG%"

xcopy ".\oobeparts\sub2.txt" "c:\programdata\hp\bridge" /s/e/y >> "%MY_LOG%" 2>&1
echo %date% %time%  xcopy sub2.txt : Error Level "%errorlevel%" >> "%MY_LOG%"

xcopy ".\oobeparts\oobe3.txt" "c:\programdata\hp\registration" /s/e/y >> "%MY_LOG%" 2>&1
echo %date% %time%  xcopy oobe3.txt : Error Level "%errorlevel%" >> "%MY_LOG%"

xcopy ".\oobeparts\sub3.txt" "c:\programdata\hp\registration" /s/e/y >> "%MY_LOG%" 2>&1
echo %date% %time%  xcopy sub3.txt : Error Level "%errorlevel%" >> "%MY_LOG%"

xcopy ".\oobeparts\oobe4.txt" "c:\hp\HPQWare\bridge" /s/e/y >> "%MY_LOG%" 2>&1
echo %date% %time%  xcopy oobe4.txt : Error Level "%errorlevel%" >> "%MY_LOG%"

xcopy ".\oobeparts\sub4.txt" "c:\hp\HPQWare\bridge" /s/e/y >> "%MY_LOG%" 2>&1
echo %date% %time%  xcopy sub4.txt : Error Level "%errorlevel%" >> "%MY_LOG%"

echo.>> "%MY_LOG%"
echo.>> "%MY_LOG%"


icacls "c:\hp\bridge\oobe1.txt" /inheritance:r /grant:r *S-1-5-18:(F) /grant:r *S-1-5-32-544:(F) /grant:r *S-1-5-20:(R,W) >> "%MY_LOG%" 2>&1
echo %date% %time%  icacls modify oobe1.txt permissions : Error Level "%errorlevel%" >> "%MY_LOG%"

icacls "c:\hp\bridge\oobe1.txt" /setowner *S-1-5-18 >> "%MY_LOG%" 2>&1
echo %date% %time%  icacls modify oobe1.txt owner : Error Level "%errorlevel%" >> "%MY_LOG%"

icacls "c:\hp\bridge\sub1.txt" /inheritance:r /grant:r *S-1-5-18:(F) /grant:r *S-1-5-32-544:(F) /grant:r *S-1-5-20:(R,W) >> "%MY_LOG%" 2>&1
echo %date% %time%  icacls modify sub1.txt permissions : Error Level "%errorlevel%" >> "%MY_LOG%"

icacls "c:\hp\bridge\sub1.txt" /setowner *S-1-5-18 >> "%MY_LOG%" 2>&1
echo %date% %time%  icacls modify sub1.txt owner : Error Level "%errorlevel%" >> "%MY_LOG%"


icacls "c:\hp\bridge" /deny Everyone:(OI)(CI)(DE,DC) >> "%MY_LOG%" 2>&1
echo %date% %time%  icacls /deny Everyone:(OI)(CI)(DE,DC) : Error Level "%errorlevel%" >> "%MY_LOG%"
REM If %errorlevel% EQU 1332 (set errorlevel=0)

icacls "c:\hp\bridge" /setowner *S-1-5-18 >> "%MY_LOG%" 2>&1
echo %date% %time%  icacls modify folder owner : Error Level "%errorlevel%" >> "%MY_LOG%"



icacls "c:\programdata\hp\bridge\oobe2.txt" /inheritance:r /grant:r *S-1-5-18:(F) /grant:r *S-1-5-32-544:(F) /grant:r *S-1-5-20:(R,W) >> "%MY_LOG%" 2>&1
echo %date% %time%  icacls modify oobe2.txt permissions : Error Level "%errorlevel%" >> "%MY_LOG%"

icacls "c:\programdata\hp\bridge\oobe2.txt" /setowner *S-1-5-18 >> "%MY_LOG%" 2>&1
echo %date% %time%  icacls modify oobe2.txt owner : Error Level "%errorlevel%" >> "%MY_LOG%"

icacls "c:\programdata\hp\bridge\sub2.txt" /inheritance:r /grant:r *S-1-5-18:(F) /grant:r *S-1-5-32-544:(F) /grant:r *S-1-5-20:(R,W) >> "%MY_LOG%" 2>&1
echo %date% %time%  icacls modify sub2.txt permissions : Error Level "%errorlevel%" >> "%MY_LOG%"

icacls "c:\programdata\hp\bridge\sub2.txt" /setowner *S-1-5-18 >> "%MY_LOG%" 2>&1
echo %date% %time%  icacls modify sub2.txt owner : Error Level "%errorlevel%" >> "%MY_LOG%"


icacls "c:\programdata\hp\bridge" /deny Everyone:(OI)(CI)(DE,DC) >> "%MY_LOG%" 2>&1
echo %date% %time%  icacls /deny Everyone:(OI)(CI)(DE,DC) : Error Level "%errorlevel%" >> "%MY_LOG%"

icacls "c:\programdata\hp\bridge" /setowner *S-1-5-18 >> "%MY_LOG%" 2>&1
echo %date% %time%  icacls modify folder owner : Error Level "%errorlevel%" >> "%MY_LOG%"


icacls "c:\programdata\hp\registration\oobe3.txt" /inheritance:r /grant:r *S-1-5-18:(F) /grant:r *S-1-5-32-544:(F) /grant:r *S-1-5-20:(R,W) >> "%MY_LOG%" 2>&1
echo %date% %time%  icacls modify oobe3.txt permissions : Error Level "%errorlevel%" >> "%MY_LOG%"

icacls "c:\programdata\hp\registration\oobe3.txt" /setowner *S-1-5-18 >> "%MY_LOG%" 2>&1
echo %date% %time%  icacls modify oobe3.txt owner : Error Level "%errorlevel%" >> "%MY_LOG%"

icacls "c:\programdata\hp\registration\sub3.txt" /inheritance:r /grant:r *S-1-5-18:(F) /grant:r *S-1-5-32-544:(F) /grant:r *S-1-5-20:(R,W) >> "%MY_LOG%" 2>&1
echo %date% %time%  icacls modify sub3.txt permissions : Error Level "%errorlevel%" >> "%MY_LOG%"

icacls "c:\programdata\hp\registration\sub3.txt" /setowner *S-1-5-18 >> "%MY_LOG%" 2>&1
echo %date% %time%  icacls modify sub3.txt owner : Error Level "%errorlevel%" >> "%MY_LOG%"


icacls "c:\programdata\hp\registration" /deny Everyone:(OI)(CI)(DE,DC) >> "%MY_LOG%" 2>&1
echo %date% %time%  icacls /deny Everyone:(OI)(CI)(DE,DC) : Error Level "%errorlevel%" >> "%MY_LOG%"

icacls "c:\programdata\hp\registration" /setowner *S-1-5-18 >> "%MY_LOG%" 2>&1
echo %date% %time%  icacls modify folder owner : Error Level "%errorlevel%" >> "%MY_LOG%"



icacls "c:\hp\HPQWare\bridge\oobe4.txt" /inheritance:r /grant:r *S-1-5-18:(F) /grant:r *S-1-5-32-544:(F) /grant:r *S-1-5-20:(R,W) >> "%MY_LOG%" 2>&1
echo %date% %time%  icacls modify oobe4.txt permissions : Error Level "%errorlevel%" >> "%MY_LOG%"

icacls "c:\hp\HPQWare\bridge\oobe4.txt" /setowner *S-1-5-18 >> "%MY_LOG%" 2>&1
echo %date% %time%  icacls modify oobe4.txt owner : Error Level "%errorlevel%" >> "%MY_LOG%"

icacls "c:\hp\HPQWare\bridge\sub4.txt" /inheritance:r /grant:r *S-1-5-18:(F) /grant:r *S-1-5-32-544:(F) /grant:r *S-1-5-20:(R,W) >> "%MY_LOG%" 2>&1
echo %date% %time%  icacls modify sub4.txt permissions : Error Level "%errorlevel%" >> "%MY_LOG%"

icacls "c:\hp\HPQWare\bridge\sub4.txt" /setowner *S-1-5-18 >> "%MY_LOG%" 2>&1
echo %date% %time%  icacls modify sub4.txt owner : Error Level "%errorlevel%" >> "%MY_LOG%"


icacls "c:\hp\HPQWare\bridge" /deny Everyone:(OI)(CI)(DE,DC) >> "%MY_LOG%" 2>&1
echo %date% %time%  icacls /deny Everyone:(OI)(CI)(DE,DC) : Error Level "%errorlevel%" >> "%MY_LOG%"
REM If %errorlevel% EQU 1332 (set errorlevel=0)

icacls "c:\hp\HPQWare\bridge" /setowner *S-1-5-18 >> "%MY_LOG%" 2>&1
echo %date% %time%  icacls modify folder owner : Error Level "%errorlevel%" >> "%MY_LOG%"


echo.>> "%MY_LOG%"

:SkipOOBEParts

echo.>> "%MY_LOG%"
echo.>> "%MY_LOG%"

echo [%time%-%date%]  Performing hpdc.exe rescan to rePNP Fusion if it was just removed >> "%MY_LOG%"
hpdc.exe rescan >> "%MY_LOG%" 2>&1
echo.>> "%MY_LOG%"
echo.>> "%MY_LOG%"

REM debug
REM pause



echo [%time%-%date%]  Collecting PNPID of HSA Fusion Base device, - Fusion needs HPIC0003 Consumer or HPIC000C Commercial. Will be used as information only. This has been proven to be not reliable >> "%MY_LOG%"
echo [%time%-%date%]  Value of 0 returned, PNPID found. >> "%MY_LOG%"
echo [%time%-%date%]  Value of 1 returned, PNPID not found. >> "%MY_LOG%"
echo.>> "%MY_LOG%"
REM if FUSION PNPIDs are not present go to end

echo [%time%-%date%]  HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Enum\ACPI\HPIC0003 >> "%MY_LOG%"
reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Enum\ACPI\HPIC0003" >> "%MY_LOG%" 2>&1
echo [%time%-%date%]  reg query consumer Error Level = "%errorlevel%" >> "%MY_LOG%"
echo.>> "%MY_LOG%"

echo [%time%-%date%]  HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Enum\ACPI\HPIC000C >> "%MY_LOG%"
reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Enum\ACPI\HPIC000C" >> "%MY_LOG%" 2>&1
echo [%time%-%date%]  reg query commercial Error Level = "%errorlevel%" >> "%MY_LOG%"
echo.>> "%MY_LOG%"

echo [%time%-%date%]  HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Enum\ACPI\HPIC0003 >> "%MY_LOG%"
reg query "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Enum\ACPI\HPIC0003" >> "%MY_LOG%" 2>&1
echo [%time%-%date%]  reg query consumer Error Level = "%errorlevel%" >> "%MY_LOG%"
echo.>> "%MY_LOG%"

echo [%time%-%date%]  HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Enum\ACPI\HPIC000C >> "%MY_LOG%"
reg query "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Enum\ACPI\HPIC000C" >> "%MY_LOG%" 2>&1
echo [%time%-%date%]  reg query commercial Error Level = "%errorlevel%" >> "%MY_LOG%"
echo.>> "%MY_LOG%"


GOTO SkipVirtual
REM Use new code to cycle through root\System PNPIDs

:SkipVirtual

REM Production


echo [%time%-%date%]  Checking to see if the Fusion PNPID is present >> "%MY_LOG%"

set FusionPNPID=No
REM ACPI\HPIC000C

REM if findstr errorlevel 0, can't find the device
REM if findstr errorlevel 1, found the device

hpdc.exe find "ACPI\%PNPID%"|findstr /i /c:"No matching devices found." >nul
set error_level=%errorlevel%

REM if findstr errorlevel 0, can't find the device
REM if findstr errorlevel 1, found the device

if "%error_level%"=="1" set FusionPNPID=Yes
if "%error_level%"=="1" echo [%time%-%date%]  Supported device, %DevDesc%, found >> "%MY_LOG%" 

if /i "%FusionPNPID%"=="No" (
REM Depricating this since some customers may turn off the Fusion PNPID in BIOS and Fusion Partner apps may decide to bundle Fusion so app updates still need to be updated even though Fusion cannot be.
REM echo [%time%-%date%]  No Fusion PNPID, %PNPID%, found, Exiting driver installation. Returning errflg=9996 >> "%MY_LOG%"
REM set errflg=9996
REM GOTO END

echo [%time%-%date%]  No Fusion PNPID, %PNPID%, found. However, some customers may turn off the Fusion PNPID in BIOS and Fusion Partner apps may decide to bundle Fusion so app updates still need to be updated even though Fusion cannot be. >> "%MY_LOG%"
set errflg=0
echo [%time%-%date%]  errflg="%errflg%" >> "%MY_LOG%"

) 

echo.>> "%MY_LOG%"
echo.>> "%MY_LOG%"

:StoppingFusionServices

REM Skipping this per the HPSA Team
GOTO SkipStoppingFusionServices

echo [%time%-%date%]  Stopping Fusion Services >> "%MY_LOG%"
sc stop hpsysinfocap >> "%MY_LOG%" 2>&1
sc stop hpapphelpercap >> "%MY_LOG%" 2>&1
sc stop hpnetworkcap >> "%MY_LOG%" 2>&1
sc stop hpdiagscap >> "%MY_LOG%" 2>&1

taskkill /f /im sysinfocap.exe >> "%MY_LOG%" 2>&1
taskkill /f /im apphelpercap.exe >> "%MY_LOG%" 2>&1
taskkill /f /im networkcap.exe >> "%MY_LOG%" 2>&1
taskkill /f /im diagscap.exe >> "%MY_LOG%" 2>&1
taskkill /f /im BridgeCommunication.exe >> "%MY_LOG%" 2>&1

:SkipStoppingFusionServices


:Install_INF


REM https://docs.microsoft.com/en-us/windows-hardware/drivers/devtest/pnputil-return-values

echo [%time%-%date%]  PNPUTIL Error levels >> "%MY_LOG%"
echo [%time%-%date%]  ERROR_SUCCESS (0): The requested operation completed successfully. >> "%MY_LOG%"
echo [%time%-%date%]  ERROR_SUCCESS_REBOOT_REQUIRED (3010): The requested operation completed successfully and a system reboot is required. For example, if the /install /add-driver options were specified, one or more devices were successfully installed and a system reboot is required to finalize installation. >> "%MY_LOG%"
echo [%time%-%date%]  ERROR_SUCCESS_TBD (259): Driver package is up-to-date on all applicable targets. >> "%MY_LOG%"
REM Not used
REM echo [%time%-%date%]  ERROR_SUCCESS_REBOOT_INITIATED (1641): The operation was successful and a system reboot is underway because the reboot option was specified. >> "%MY_LOG%"
echo.>> "%MY_LOG%"

c:\windows\system32\pnputil.exe /add-driver "Base\hpcustomcapdriver.inf" /install >> "%MY_LOG%" 2>&1
set error_level=%errorlevel%
echo [%time%-%date%]  Fusion base, hpcustomcapdriver.inf install result : pnputil Error Level "%error_level%" >> "%MY_LOG%"
set errflg1=%error_level%
If "%errflg1%"=="87" set errflg1=0
If "%errflg1%"=="259" set errflg1=0
If "%errflg1%"=="3010" set errflg1=0
echo [%time%-%date%]  errflg1="%errflg1%" >> "%MY_LOG%"
echo.>> "%MY_LOG%"


c:\windows\system32\pnputil.exe /add-driver "Ext\hpcustomcapext.inf" /install >> "%MY_LOG%" 2>&1
set error_level=%errorlevel%
echo [%time%-%date%]  Fusion Ext, hpcustomcapext.inf install result : pnputil Error Level "%error_level%" >> "%MY_LOG%"
echo.>> "%MY_LOG%"

REM Will not be used for Fusion for the time being.
REM Works well in restoring services if they are deleted. PNPUtil does not work.
REM devcon.exe update "Comp\hpcustomcapcomp.inf" "swc\hpic000c" >> "%MY_LOG%" 2>&1
REM set error_level=%errorlevel%
REM echo [%time%-%date%]  Fusion Comp, hpcustomcapcomp.inf install result : devcon Error Level "%error_level%" >> "%MY_LOG%"
REM set errflg2=%error_level%
REM If "%errflg2%"=="87" set errflg2=0
REM If "%errflg2%"=="259" set errflg2=0
REM If "%errflg2%"=="3010" set errflg2=0
REM echo [%time%-%date%]  errflg2="%errflg2%" >> "%MY_LOG%"
REM echo.>> "%MY_LOG%"


c:\windows\system32\pnputil.exe /add-driver "Comp\hpcustomcapcomp.inf" /install >> "%MY_LOG%" 2>&1
set error_level=%errorlevel%
echo [%time%-%date%]  Fusion Comp, hpcustomcapcomp.inf install result : pnputil Error Level "%error_level%" >> "%MY_LOG%"
set errflg2=%error_level%
If "%errflg2%"=="87" set errflg2=0
If "%errflg2%"=="259" set errflg2=0
If "%errflg2%"=="3010" set errflg2=0
echo [%time%-%date%]  errflg2="%errflg2%" >> "%MY_LOG%"
echo.>> "%MY_LOG%"


if /i "%FusionPNPID%"=="No" echo [%time%-%date%]  Artificially setting errflg1=0 and errflg2=0 since there is no Fusion PNPID >> "%MY_LOG%"
if /i "%FusionPNPID%"=="No" set errflg1=0
if /i "%FusionPNPID%"=="No" set errflg2=0
if /i "%FusionPNPID%"=="No" goto ExitCheckforMissingFusionCapsafterPnPUtil


:CheckforMissingFusionCapsafterPnPUtil
REM only need to check Comp

echo Checking for Fusion Services by trying to Start Fusion Services even if they're already started 
echo [%time%-%date%]  Checking for Fusion Services by trying to Start Fusion Services even if they're already started >> "%MY_LOG%"



set exit_code=0


REM sc start hpdiagscap >> "%MY_LOG%" 2>&1
REM set error_level=%errorlevel%
REM if "%error_level%"=="0" echo [%time%-%date%]  hpdiagscap is START_PENDING or RUNNING and returned error_level="%error_level%" >> "%MY_LOG%"
REM if "%error_level%"=="1056" echo [%time%-%date%]  hpdiagscap is already RUNNING and returned error_level="%error_level%" >> "%MY_LOG%"
REM if "%error_level%"=="2" echo [%time%-%date%]  hpdiagscap is STOPPED because it's either disabled or can't start and returned error_level="%error_level%" >> "%MY_LOG%"
REM if "%error_level%"=="2" set exit_code=1
REM if "%error_level%"=="1060" echo [%time%-%date%]  hpdiagscap does not exist and returned error_level="%error_level%" >> "%MY_LOG%"
REM if "%error_level%"=="1060" set exit_code=1
REM echo.>> "%MY_LOG%"
REM echo.>> "%MY_LOG%"

sc start hpnetworkcap >> "%MY_LOG%" 2>&1
set error_level=%errorlevel%

REM debug
REM set error_level=2

if "%error_level%"=="0" echo [%time%-%date%]  hpnetworkcap is START_PENDING or RUNNING and returned error_level="%error_level%" >> "%MY_LOG%"
if "%error_level%"=="1056" echo [%time%-%date%]  hpnetworkcap is already RUNNING and returned error_level="%error_level%" >> "%MY_LOG%"
if "%error_level%"=="2" echo [%time%-%date%]  hpnetworkcap is STOPPED because it's either disabled or can't start and returned error_level="%error_level%" >> "%MY_LOG%"
if "%error_level%"=="2" set exit_code=1
if "%error_level%"=="1060" echo [%time%-%date%]  hpnetworkcap does not exist and returned error_level="%error_level%" >> "%MY_LOG%"
if "%error_level%"=="1060" set exit_code=1
echo.>> "%MY_LOG%"
echo.>> "%MY_LOG%"

sc start hpapphelpercap >> "%MY_LOG%" 2>&1
set error_level=%errorlevel%
if "%error_level%"=="0" echo [%time%-%date%]  hpapphelpercap is START_PENDING or RUNNING and returned error_level="%error_level%" >> "%MY_LOG%"
if "%error_level%"=="1056" echo [%time%-%date%]  hpapphelpercap is already RUNNING and returned error_level="%error_level%" >> "%MY_LOG%"
if "%error_level%"=="2" echo [%time%-%date%]  hpapphelpercap is STOPPED because it's either disabled or can't start and returned error_level="%error_level%" >> "%MY_LOG%"
if "%error_level%"=="2" set exit_code=1
if "%error_level%"=="1060" echo [%time%-%date%]  hpapphelpercap does not exist and returned error_level="%error_level%" >> "%MY_LOG%"
if "%error_level%"=="1060" set exit_code=1
echo.>> "%MY_LOG%"
echo.>> "%MY_LOG%"

sc start hpsysinfocap >> "%MY_LOG%" 2>&1
set error_level=%errorlevel%
if "%error_level%"=="0" echo [%time%-%date%]  hpsysinfocap is START_PENDING or RUNNING and returned error_level="%error_level%" >> "%MY_LOG%"
if "%error_level%"=="1056" echo [%time%-%date%]  hpsysinfocap is already RUNNING and returned error_level="%error_level%" >> "%MY_LOG%"
if "%error_level%"=="2" echo [%time%-%date%]  hpsysinfocap is STOPPED because it's either disabled or can't start and returned error_level="%error_level%" >> "%MY_LOG%"
if "%error_level%"=="2" set exit_code=1
if "%error_level%"=="1060" echo [%time%-%date%]  hpsysinfocap does not exist and returned error_level="%error_level%" >> "%MY_LOG%"
if "%error_level%"=="1060" set exit_code=1
echo.>> "%MY_LOG%"
echo.>> "%MY_LOG%"


if "%exit_code%" NEQ "1" GOTO ExitCheckforMissingFusionCapsafterPnPUtil


echo [%time%-%date%]  Calling hpdc.exe to restore the missing FusionCap. >> "%MY_LOG%"

REM Will not be used for Fusion for the time being.
REM Works well in restoring services if they are deleted. PNPUtil does not work.

hpdc.exe dp_add "Comp\hpcustomcapcomp.inf" >> "%MY_LOG%" 2>&1
hpdc.exe update "Comp\hpcustomcapcomp.inf" "SWC\%PNPID%" >> "%MY_LOG%" 2>&1
set error_level=%errorlevel%
echo [%time%-%date%]  Fusion Comp, hpcustomcapcomp.inf install result : hpdc.exe Error Level "%error_level%" >> "%MY_LOG%"
set errflg2=%error_level%
If "%errflg2%"=="1" set errflg2=0
echo [%time%-%date%]  errflg2="%errflg2%" >> "%MY_LOG%"
echo.>> "%MY_LOG%"
echo.>> "%MY_LOG%"

echo [%time%-%date%]  Removing Fusion Comp PNPID >> "%MY_LOG%"
hpdc.exe remove "SWC\%PNPID%" >> "%MY_LOG%" 2>&1
echo.>> "%MY_LOG%"
echo.>> "%MY_LOG%"

echo [%time%-%date%]  Rescan for Fusion Comp PNPID to restore the latest Fusion driver. >> "%MY_LOG%"
hpdc.exe rescan >> "%MY_LOG%" 2>&1
echo.>> "%MY_LOG%"
echo.>> "%MY_LOG%"

echo [%time%-%date%]  Calling pnputil.exe a second time to gather the errflg2 for the softpaq>> "%MY_LOG%"
c:\windows\system32\pnputil.exe /add-driver "Comp\hpcustomcapcomp.inf" /install >> "%MY_LOG%" 2>&1
set error_level=%errorlevel%
echo [%time%-%date%]  Fusion Comp, hpcustomcapcomp.inf install result : pnputil Error Level "%error_level%" >> "%MY_LOG%"
set errflg2=%error_level%
If "%errflg2%"=="87" set errflg2=0
If "%errflg2%"=="259" set errflg2=0
If "%errflg2%"=="3010" set errflg2=0
echo [%time%-%date%]  errflg2="%errflg2%" >> "%MY_LOG%"
echo.>> "%MY_LOG%"
echo.>> "%MY_LOG%"
)

:ExitCheckforMissingFusionCapsafterPnPUtil


if "%errflg2%"=="0" set errflg=0
if "%errflg2%" NEQ "0" set errflg=1%errflg1%2%errflg2%



:ExitInstall_INF
echo.>> "%MY_LOG%"
echo.>> "%MY_LOG%"

echo [%time%-%date%]  Writing to "%CMDLog%" >> "%MY_LOG%"
If Exist "%FCC_LOG_FOLDER%" echo PNPUTIL.exe /add-driver Base\hpcustomcapdriver.inf /install >> "%CMDLog%"
If Exist "%FCC_LOG_FOLDER%" echo PNPUTIL.exe /add-driver Ext\hpcustomcapext.inf /install >> "%CMDLog%"
If Exist "%FCC_LOG_FOLDER%" echo PNPUTIL.exe /add-driver Comp\hpcustomcapcomp.inf /install >> "%CMDLog%"

If Exist "%FCC_LOG_FOLDER%" echo PNPUTIL.exe /add-driver Base\hpcustomcapdriver.inf /install >> "%MY_LOG%"
If Exist "%FCC_LOG_FOLDER%" echo PNPUTIL.exe /add-driver Ext\hpcustomcapext.inf /install >> "%MY_LOG%"
If Exist "%FCC_LOG_FOLDER%" echo PNPUTIL.exe /add-driver Comp\hpcustomcapcomp.inf /install >> "%MY_LOG%"
echo.>> "%MY_LOG%"
echo.>> "%MY_LOG%"


:END

echo [%time%-%date%]  Starting Fusion Services again just to be sure >> "%MY_LOG%"
sc start hpsysinfocap >> "%MY_LOG%" 2>&1
sc start hpapphelpercap >> "%MY_LOG%" 2>&1
sc start hpnetworkcap >> "%MY_LOG%" 2>&1
sc start hpdiagscap >> "%MY_LOG%" 2>&1

echo [%time%-%date%]  END - Error Flag="%errflg%" >> "%MY_LOG%"
echo.>> "%MY_LOG%"
echo.>> "%MY_LOG%"

echo %cd% >> "%MY_LOG%"
echo.>> "%MY_LOG%"
popd
echo %cd% >> "%MY_LOG%"
echo.>> "%MY_LOG%"

exit /b %errflg%
