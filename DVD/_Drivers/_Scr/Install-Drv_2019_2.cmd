:: SourcePath of %0
:: %COMSPEC% /c start "" Notepad "Drivers\Install-Drv_2019.cmd"
@Echo Off

@CD /D %0\..

SET INSTALLED=0

FOR %%i in (B C D E F G H I J K L M N O P Q R S T U V W X Y Z) do IF EXIST %%i:\Drivers\DPInst64.exe SET USB-Stick-Path=%%i:
SET USB-Stick-Path=%USB-Stick-Path: =%

SET V01=BaseBoardManufacturer
FOR /f "tokens=3*" %%a in ('reg query "HKLM\HARDWARE\DESCRIPTION\System\BIOS" /V "%V01%" ^|findstr /ri "REG_SZ"') do SET PC-Vendor=%%a
SET PC-Vendor=%PC-Vendor:-=%
SET PC-Vendor=%PC-Vendor: =%
:: @echo. PC-Vendor '%PC-Vendor%'

SET V02=BaseBoardProduct
FOR /f "tokens=3*" %%a in ('reg query "HKLM\HARDWARE\DESCRIPTION\System\BIOS" /V "%V02%" ^|findstr /ri "REG_SZ"') do SET PC-Model=%%a %%b
SET PCFN=%PC-Model%
SET PC-Model=%PC-Model:-=%
SET PC-Model=%PC-Model: =%
:: @echo. PC-Model '%PC-Model%'

@Echo.
@echo.   Check 01/02
@Echo.


:: @echo.   BaseBoardManufacturerName..: = '%BaseBoardManufacturerName%'
@echo.   %%PC-VENDOR%%................: = '%PC-Vendor%'
:: @echo.   BaseBoardProductName.......: = '%BaseBoardProductName%'
@echo.   %%PC-MODEL%%.................: = '%PC-Model%'
@echo.   USB-Stick-Path.............: = '%USB-Stick-Path%'
:: @echo.   ASUS Check Variable........: = '%ASUS%'
@echo.   Driver Install Status .....: = '%INSTALLED%'

Pause >NUL

:: SET PC-VENDOR=%BaseBoardManufacturerName:~,2%

::----------------------------------------------------
IF "%PC-VENDOR%" == "ASUSTeK" GOTO ASUS
IF "%PC-VENDOR%" == "HP" GOTO HP
IF "%PC-VENDOR%" == "TOSHIBA" GOTO TOSHIBA
GOTO EndOfDrvInst

:ASUS
Color 1f
@Echo. 
@Echo. :ASUS
@Echo.   %%PC-VENDOR%% = %PC-VENDOR%
@Echo. 
SET INSTALLED=1
GOTO EndOfDrvInst
::----------------------------------------------------

:HP
FOR /f "tokens=3*" %%a in ('reg query "HKLM\HARDWARE\DESCRIPTION\System\BIOS" /V "SystemProductName" ^|findstr /ri "REG_SZ"') do SET HPProductName=%%a%%b
SET HPProductName=%HPProductName:-=%
SET HPProductName=%HPProductName: =%
SET PC-Model=%HPProductName%

IF "%PC-Model%" == "HPProx2612G2" GOTO X2TAB
:: DBG:: SET PC-MODEL=FUTURE01
IF "%PC-Model%" == "FUTURE01" GOTO FUTURE01
GOTO ENDOFHP

:X2TAB
Color 06
@Echo. 
@Echo. :X2TAB (in :HP)
@echo.   %%PC-VENDOR%%     = %PC-VENDOR%
@Echo.   %%PC-Model%%      = %PC-Model%
@Echo.   %%HPProductName%% = %HPProductName%
SET INSTALLED=1
GOTO ENDOFHP

:FUTURE01
Color 03
@Echo. :FUTURE01 (in :HP)
@Echo.   %%PC-VENDOR%%     = %PC-VENDOR%
@Echo.   %%PC-Model%%      = %PC-Model%
@Echo.   %%HPProductName%% = %HPProductName%
SET INSTALLED=1
GOTO ENDOFHP

:ENDOFHP
GOTO EndOfDrvInst

::----------------------------------------------------

:TOSHIBA
SET DrvPath=%USB-Stick-Path%\Drivers\TOSHIBA\PORTEGE Z10T-A

@Echo. 
@Echo.   :TOSHIBA
@Echo.   PC Vendor ..: %PC-VENDOR%
@Echo.   PC Model ...: %PCFN%
@Echo.   DrvPath ....: %DrvPath%
@Echo.
@Echo.   Time .......: %Time:~0,-3%
@Echo.
@Echo. 
@Echo.   Install %PC-VENDOR% %PCFN% drivers please wait..
@Echo.   

Pause
Exit



SET INSTALLED=1
GOTO EndOfDrvInst


::- END ----------------------------------------------
:EndOfDrvInst

IF %INSTALLED% equ 0 ( Color 4e) ELSE ( Color 2f)

@Echo.
@Echo ***************
@Echo. :EndOfDrvI 
@Echo. 

IF %INSTALLED% equ 0 ( @echo. ) ELSE ( dir c:\ >NUL)
IF %INSTALLED% equ 0 ( @echo.   NO Drivers INSTALLED) ELSE ( dir c:\ >NUL)
IF %INSTALLED% equ 0 ( @echo. ) ELSE ( dir c:\ >NUL)

@Echo.   Check 02/02
@Echo.

:: @echo.   BaseBoardManufacturerName..: = '%BaseBoardManufacturerName%'
@echo.   %%PC-VENDOR%%................: = '%PC-Vendor%'
:: @echo.   BaseBoardProductName.......: = '%BaseBoardProductName%'
@echo.   %%PC-MODEL%%.................: = '%PC-Model%'
@echo.   USB-Stick-Path.............: = '%USB-Stick-Path%'
:: @echo.   ASUS Check Variable........: = '%ASUS%'
@echo.   Driver Install Status .....: = '%INSTALLED%'
@echo.   
@echo.   
Pause
Exit


::::::::::::: Install Drivers :::::::::::::::::::


@Title Install Drivers, please wait....

@Echo.
@Echo. - Write FSC info to Eventlog
EVENTCREATE /T INFORMATION /so Franksoft /ID 007 /l application /d "Franksoft Drv Inst Start %0" >Nul

SET MSG1=Install Drivers for

if '%PC-Model%' == 'X79DELUXE' Goto Asus_X79DELUXE
if '%PC-Model%' == 'PORTEGEZ10TA' Goto PORTEGEZ10TA
if '%PC-Model%' == 'LatitudeE5470' Goto LatitudeE5470
if '%PC-Model%' == 'HP Compaq dc7900 Small Form Factor' Goto dc7900
if '%PC-Model%' == 'HPProBook6560b' Goto HPProBook6560b
if '%PC-Model%' == 'HPProBook6540b' Goto HPProBook6540b
if '%PC-Model%' == 'HPEliteBook8470p' Goto HPEliteBook8470p
if '%PC-Model%' == 'HPProx2612G2' Goto HPTABG2X
Goto Error


:Error
Color 0C
@echo. 
@echo. PC Not Supportet
@echo. 
@Timeout 10
Goto End

:HPTABG2X
@echo. 
@echo. %MSG1% %SystemProductName%
@echo. 

Pause
exit

:HPEliteBook8470p
@echo. 
@echo. %MSG1% HP EliteBook 8470p
@echo. 

FOR %%i in (B C D E F G H I J K L M N O P Q R S T U V W X Y Z) do if exist %%i:\sources\setup.exe SET DrvPath=%%i:
Start "" "%DrvPath%\Drivers\HP\8740P\x64\accelerometer\setup.exe" /quiet /norestart
Start "" "%DrvPath%\Drivers\HP\8740P\x64\DPInst64.exe"

Goto End


:Asus_X79DELUXE

@Echo. - %MSG1% Asus_X79DELUXE
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