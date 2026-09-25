
:: SourcePath of %0
:: %COMSPEC% /c start "" Notepad "Drivers\Install-Drv_2019.cmd"

:: @echo off


FOR /f "tokens=3*" %%a in ('reg query "HKLM\HARDWARE\DESCRIPTION\System\BIOS" /V "BaseBoardProduct" ^|findstr /ri "REG_SZ"') do SET BaseBoardProductName=%%a %%b>NUL
FOR /f "tokens=3*" %%a in ('reg query "HKLM\HARDWARE\DESCRIPTION\System\BIOS" /V "BaseBoardManufacturer" ^|findstr /ri "REG_SZ"') do SET BaseBoardManufacturerName=%%a >NUL

SET PC-Model=%BaseBoardProductName%
SET PC-Model=%PC-Model: =%
SET PC-Model=%PC-Model:-=%

@echo. BaseBoardProductName ..: = %BaseBoardProductName%
@echo. PC-Model ..............: = %PC-Model%

:: DBG
Pause
Exit

:: GET USB Drive letter %USB-Stick-Path%

:: DBG
for %%i in (B C D E F G H I J K L M N O P Q R S T U V W X Y Z) do IF EXIST %%i:\Work\FSC\W10\1903\Drivers\DPInst64.exe SET USB-Stick-Path=%%i:
:: DBG
::for %%i in (B C D E F G H I J K L M N O P Q R S T U V W X Y Z) do IF EXIST %%i:\Drivers\DPInst64.exe SET USB-Stick-Path=%%i:

::: if "%USB-Stick-Path%" == "" (
::: 
::: 
::: 	    color 4e
:::     	@echo.
:::     	@echo No Drivers Found for %BaseBoardManufacturerName%%BaseBoardProductName%
:::     	@echo.
:::     	goto :End
::: ) else (
::: 	    color 2f
:::     	@echo.
:::     	@echo Let's GO
:::     	@echo.
::: 	goto :InstDrv
::: )

:InstDrv
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
@:: CMDLINE
Title Run as Admin

:: Install Drivers START 

@CD /D %0\..
Color e0

@Title Install Drivers, please wait....

@Echo.
@Echo. - Write FSC info to Eventlog
EVENTCREATE /T INFORMATION /so Franksoft /ID 007 /l application /d "Franksoft Drv Inst Start %0" >Nul

SET MSG1=Install Drivers for 

:: FOR /f "tokens=3*" %%a in ('reg query "HKLM\HARDWARE\DESCRIPTION\System\BIOS" /V "BaseBoardProduct" ^|findstr /ri "REG_SZ"') do SET BaseBoardProductName=%%a >NUL

:: FOR /f "tokens=*" %%f in ('wmic BASEBOARD get Product /format:list ^| find "="') do SET "%%f"
:: FOR /f "tokens=*" %%f in ('wmic CSProduct get name /format:list ^| find "="') do SET "%%f"

:: @echo. %BaseBoardProductName%

SET PC-Model=%BaseBoardProductName%
SET PC-Model=%PC-Model: =%

@Echo. - %%PC-Model%% = '%PC-Model%'

if '%PC-Model%' == 'X79-DELUXE' Goto Asus_X79-DELUXE
if '%PC-Model%' == 'PORTEGEZ10TA' Goto PORTEGEZ10TA
if '%PC-Model%' == 'LatitudeE5470' Goto LatitudeE5470
if '%PC-Model%' == 'HP Compaq dc7900 Small Form Factor' Goto dc7900
if '%PC-Model%' == 'HPProBook6560b' Goto HPProBook6560b
if '%PC-Model%' == 'HPProBook6540b' Goto HPProBook6540b
if '%PC-Model%' == 'HPEliteBook8470p' Goto HPEliteBook8470p

@echo. %%PC-Model%% = '%PC-Model%'


Goto Error


:Error
Color 0C
@echo. 
@echo. PC Not Supportet
@echo. 
@Timeout 10
Goto End


:HPEliteBook8470p
@echo. 
@echo. %MSG1% HP EliteBook 8470p
@echo. 

FOR %%i in (B C D E F G H I J K L M N O P Q R S T U V W X Y Z) do if exist %%i:\sources\setup.exe SET DrvPath=%%i:
Start "" "%DrvPath%\Drivers\HP\8740P\x64\accelerometer\setup.exe" /quiet /norestart
Start "" "%DrvPath%\Drivers\HP\8740P\x64\DPInst64.exe"

Goto End


:Asus_X79-DELUXE

@Echo. - %MSG1% Asus_X79-DELUXE
Pause
Goto End

:PORTEGEZ10TA
SET DrvPath=%DrvPath%\Drivers\TOSHIBA\PORTEGE Z10T-A
color fa
@echo. 
@Echo. - %MSG1% Toshiba PORTEGE Z10T-A
@echo. - DrvPath = %DrvPath%

:: DBG
Pause
Exit



msiexec /i "%DrvPath%\DTSPremiumSoundInstaller.msi" TRANSFORMS=DTSPremiumSoundInstaller.mst /qb! /norestart
msiexec /i "%DrvPath%\System Driver\TC30846800B\x64\TOSHIBA System Driver.msi" TRANSFORMS="TOSHIBA System Driver.mst" /qb! /norestart
msiexec /i "%DrvPath%\TOSHIBA_System_Settings.msi" TRANSFORMS=TOSHIBA_System_Settings.mst /qb! /norestart
msiexec /i "%DrvPath%\TOSHIBA_Function_Key.msi" TRANSFORMS=TOSHIBA_Function_Key.mst /qb! /norestart

"%DrvPath%\Display Utility\19.40.05.TCJ0022500A.exe" /Silent

@timeout 10

pnputil.exe /add-driver "%DrvPath%\installiert\Bluetooth\Intel Bluetooth Service\ibtusb.inf"

@timeout 5

pnputil.exe /add-driver "%DrvPath%\installiert\HIDClass\Hotkey Driver\Thotkey.inf"
@timeout 10

@echo.
@echo Install Drivers please wait... \DPInst64.exe
@echo.

:: start "" "%DrvPath%\installiert\DPInst64.exe"
"%DrvPath%\installiert\DPInst64.exe"

if exist "%DrvPath%\igfxDTCM.reg" regedit /s "%DrvPath%\igfxDTCM.reg"

:: 12:49 21.10.2018

@Color 4F

@Echo.
@Echo. Reboot
@Echo.

goto End

:LatitudeE5470
@echo. 
@echo. %MSG1%Dell Latitude E5470
@echo. 
for %%i in (B C D E F G H I J K L M N O P Q R S T U V W X Y Z) do if exist %%i:\sources\setup.exe SET DrvPath=%%i:
@rem start "" "%DrvPath%\Drivers\Dell\Latitude E5470\W10\X64\DPInst64.exe"

"%DrvPath%\Drivers\Dell\Latitude E5470\W10\X64\DPInst64.exe"

goto end

:HPProBook6560b
@echo. 
@Echo. - %MSG1% HP Pro Book 6560b
@echo.
for %%i in (B C D E F G H I J K L M N O P Q R S T U V W X Y Z) do if exist %%i:\sources\setup.exe SET DrvPath=%%i:
start "" "%DrvPath%\Drivers\HP\ProBook 6560b\x64\DPInst64.exe"
goto end


:dc7900
@echo. 
@Echo. - %MSG1% HP DC 7900 SFF
@echo.
for %%i in (B C D E F G H I J K L M N O P Q R S T U V W X Y Z) do if exist %%i:\sources\setup.exe SET DrvPath=%%i:
start "" "%DrvPath%\Drivers\HP\dc7900\DPInst64.exe"
goto end

:HPProBook6540b
@echo. 
@Echo. - %MSG1% HP Pro Book 6540b
@echo.
for %%i in (B C D E F G H I J K L M N O P Q R S T U V W X Y Z) do if exist %%i:\sources\setup.exe SET DrvPath=%%i:
start "" "%DrvPath%\Drivers\HP\ProBook 6540b\DPInst64.exe"
goto end

:end


@EVENTCREATE /T INFORMATION /so Franksoft /ID 007 /l application /d "Franksoft Drv Inst End   %0" >Nul

@Color 4f

@Echo.
@Echo. - Time To REBOOT (manualy)
@Echo.
@Echo.


@Timeout 60

exit /b

:UACPrompt
   echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
   echo UAC.ShellExecute "cmd.exe", "/c %~s0 %~1", "", "runas", 1 >> "%temp%\getadmin.vbs"

   "%temp%\getadmin.vbs"
del "%temp%\getadmin.vbs"
exit /B`


