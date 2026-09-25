:: SourcePath of %0
:: %COMSPEC% /c start "" Notepad "Drivers\Install-Drv_2019.cmd"
@Echo Off

@CD /D %0\..

MD "%Public%\Desktop\Drv Installed %date%"

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

:: @Echo.
:: @echo.   Check 01/02
:: @Echo.
:: @echo.   BaseBoardManufacturerName..: = '%BaseBoardManufacturerName%'
:: @echo.   %%PC-VENDOR%%................: = '%PC-Vendor%'
:: @echo.   BaseBoardProductName.......: = '%BaseBoardProductName%'
:: @echo.   %%PC-MODEL%%.................: = '%PC-Model%'
:: @echo.   USB-Stick-Path.............: = '%USB-Stick-Path%'
:: @echo.   ASUS Check Variable........: = '%ASUS%'
:: @echo.   Driver Install Status .....: = '%INSTALLED%'
:: Pause >NUL

:: SET PC-VENDOR=%BaseBoardManufacturerName:~,2%
::----------------------------------------------------------------------------

IF "%PC-VENDOR%" == "ASUSTeK" GOTO ASUS
IF "%PC-VENDOR%" == "HP" GOTO HP
IF "%PC-VENDOR%" == "TOSHIBA" GOTO TOSHIBA
GOTO EndOfDrvInst

:: Asus Computer
:ASUS
Color 1f
Set T1=%Time:~0,-3%

SET DrvPath=%USB-Stick-Path%\Drivers\Asus\X79-DELUXE\2018
SET MSG=Install %PC-VENDOR% %PCFN% drivers please wait..
@Echo. 
@Echo.   :ASUS
@Echo.   PC Vendor ..: %PC-VENDOR%
@Echo.   PC Model ...: %PCFN%
@Echo.   DrvPath ....: %DrvPath%
@Echo.
@Echo.   Time .......: %Time:~0,-3%
@Echo.
@Echo.   %MSG%
@Echo.   

:: Delete
Pause
SET INSTALLED=1
GOTO EndOfDrvInst
Exit
:: Delete

@echo.
@Echo.   Install System drivers (DPInst)
@echo.   
@echo.     Start Time .......: %Time:~0,-3%
SET FN="%DrvPath%\DPInst64.exe"
IF EXIST %FN% Start /wait %FN%

SET DrvPath=%USB-Stick-Path%\Drivers\Asus\X79-DELUXE\2019
SET FN="%DrvPath%\DPInst64.exe"
IF EXIST %FN% Start /wait %FN%

@echo.     End Time .........: %Time:~0,-3%
@echo.
@Timeout 15 >NUL

SET INSTALLED=1
GOTO EndOfDrvInst
::----------------------------------------------------------------------------
:: HP Computer
:HP
FOR /f "tokens=3*" %%a in ('reg query "HKLM\HARDWARE\DESCRIPTION\System\BIOS" /V "SystemProductName" ^|findstr /ri "REG_SZ"') do SET HPProductName=%%a %%b
SET HPProductNameFull=%HPProductName%
SET HPProductName=%HPProductName:-=%
SET HPProductName=%HPProductName: =%
SET PC-Model=%HPProductName%

IF "%PC-Model%" == "HPProx2612G2" GOTO X2TAB
:: DBG:: SET PC-MODEL=FUTURE01
IF "%PC-Model%" == "FUTURE01" GOTO FUTURE01
GOTO ENDOFHP
::----------------------------------------
:: HP Tablet Pro x2 612 G2
:X2TAB
Set T1=%Time:~0,-3%
Color 06

SET DrvPath=%USB-Stick-Path%\Drivers\HP\Pro x2 612 G2
SET MSG=Install %HPProductNameFull% drivers please wait..
@Echo. 
@Echo.   :X2TAB (in :HP)
@Echo.   PC Vendor ..: %PC-VENDOR%
@Echo.   PC Model ...: %HPProductNameFull%
@Echo.   DrvPath ....: %DrvPath%
@Echo.
@Echo.   Time .......: %Time:~0,-3%
@Echo.
@Echo.   %MSG%
@Echo.   

:: Delete
Pause
SET INSTALLED=1
GOTO EndOfDrvInst
Exit
:: Delete

@Echo.   Install Hotkey drivers
:: Hotkey-Drivers
SET FN="%DrvPath%\Hotkey-Drivers.exe"
SET PM= /s /v"/qb! REBOOT=ReallySuppress"
IF EXIST %FN% %FN% %PM%
@Timeout 5 >NUL

@echo.
@Echo.   Install System drivers (DPInst)
@echo.   
@echo.     Start Time .......: %Time:~0,-3%
SET FN="%DrvPath%\DPInst64.exe"
IF EXIST %FN% Start /wait %FN%
@echo.     End Time .........: %Time:~0,-3%
@echo.
@Timeout 15 >NUL

@Echo.   Install Camera drivers
IF EXIST "%DrvPath%\CAMERA\Setup.bat" Call "%DrvPath%\CAMERA\Setup.bat"
@Timeout 10 >NUL

SET INSTALLED=1
GOTO EndOfDrvInst

:FUTURE01
Color 03
Set T1=%Time:~0,-3%
SET DrvPath=%USB-Stick-Path%\Drivers\HP\Pro x2 612 G2
SET MSG=Install %PC-VENDOR% %PCFN% drivers please wait..
@Echo. 
@Echo.   :FUTURE01 (in :HP)
@Echo.   PC Vendor ..: %PC-VENDOR%
@Echo.   PC Model ...: %HPProductName%
@Echo.   DrvPath ....: %DrvPath%
@Echo.
@Echo.   Time .......: %Time:~0,-3%
@Echo.
@Echo.   %MSG%
@Echo.   
SET INSTALLED=1
GOTO EndOfDrvInst

::----------------------------------------------------------------------------

:TOSHIBA
Set T1=%Time:~0,-3%
SET DrvPath=%USB-Stick-Path%\Drivers\TOSHIBA\PORTEGE Z10T-A
SET MSG=Install %PC-VENDOR% %PCFN% drivers please wait..
@Echo. 
@Echo.   :TOSHIBA
@Echo.   PC Vendor ..: %PC-VENDOR%
@Echo.   PC Model ...: %PCFN%
@Echo.   DrvPath ....: %DrvPath%
@Echo.
@Echo.   Time .......: %Time:~0,-3%
@Echo.
@Echo.   %MSG%
@Echo.   

:: Delete
Pause
SET INSTALLED=1
GOTO EndOfDrvInst
Exit
:: Delete

SET MSIP=/qb! /norestart

SET MSI1="%DrvPath%\DTSPremiumSoundInstaller.msi"
SET MST1=TRANSFORMS=DTSPremiumSoundInstaller.mst
IF EXIST %MSI1% Msiexec /i %MSI1% %MST1% %MSIP%

SET MSI1="%DrvPath%\System Driver\TC30846800B\x64\TOSHIBA System Driver.msi"
SET MST1=TRANSFORMS="TOSHIBA System Driver.mst"
IF EXIST %MSI1% Msiexec /i %MSI1% %MST1% %MSIP%

SET MSI1="%DrvPath%\TOSHIBA_System_Settings.msi"
SET MST1=TRANSFORMS=TOSHIBA_System_Settings.mst
IF EXIST %MSI1% Msiexec /i %MSI1% %MST1% %MSIP%

SET MSI1="%DrvPath%\TOSHIBA_Function_Key.msi"
SET MST1=TRANSFORMS=TOSHIBA_Function_Key.mst
IF EXIST %MSI1% Msiexec /i %MSI1% %MST1% %MSIP%

SET FN="%DrvPath%\Display Utility\19.40.05.TCJ0022500A.exe"
SET PM=/Silent
IF EXIST %FN% %FN% %PM%

@Timeout 5

SET FN="%DrvPath%\installiert\Bluetooth\Intel Bluetooth Service\ibtusb.inf"
IF EXIST %FN% pnputil.exe /add-driver %FN%

@Timeout 5

SET FN="%DrvPath%\installiert\HIDClass\Hotkey Driver\Thotkey.inf"
IF EXIST %FN% pnputil.exe /add-driver %FN%
@Timeout 10

@echo.
@Echo.   DPInst Install please wait... 
@echo.   
@echo.     Start Time .......: %Time:~0,-3%

:: Delete
Pause
SET INSTALLED=1
GOTO EndOfDrvInst
Exit
:: Delete

SET FN="%DrvPath%\installiert\DPInst64.exe"
:: start "" "%DrvPath%\installiert\DPInst64.exe"
IF EXIST %FN% %FN%

SET FN="%DrvPath%\igfxDTCM.reg"
IF EXIST %FN% Regedit /s %FN%

@echo.     End Time .........: %Time:~0,-3%
@echo.

SET INSTALLED=1
Set T2=%Time:~0,-3%
GOTO EndOfDrvInst

::- END ----------------------------------------------
:EndOfDrvInst
CLS
IF %INSTALLED% equ 0 ( Color 4e) ELSE ( Color 2f)

IF %INSTALLED% equ 0 ( @echo. ) ELSE ( dir C:\ >NUL)
IF %INSTALLED% equ 0 ( @echo.   NO Drivers INSTALLED !!!) ELSE ( dir c:\ >NUL)
IF %INSTALLED% equ 0 ( @echo. ) ELSE ( dir C:\ >NUL)

Set T2=%Time:~0,-3%

@echo.   
:: @echo.   BaseBoardManufacturerName..: = '%BaseBoardManufacturerName%'
@echo.   %%PC-VENDOR%%................: = '%PC-Vendor%'
:: @echo.   BaseBoardProductName.......: = '%BaseBoardProductName%'
@echo.   %%PC-MODEL%%.................: = '%PC-Model%'
@echo.   USB-Stick-Path.............: = '%USB-Stick-Path%'
:: @echo.   ASUS Check Variable........: = '%ASUS%'
@echo.   Driver Install Status .....: = '%INSTALLED%'
@echo.   
@echo.   Start Time ................: %T1%
@echo.   End Time ..................: %T2%
@echo.   
Pause
Exit

::::::::::::: Install Drivers 2019 END :::::::::::::::::::
Exit
::::::::::::: Install Drivers 2018 START :::::::::::::::::::

@Title Install Drivers, please wait....

@Echo.
@Echo. - Write FSC info to Eventlog
EVENTCREATE /T INFORMATION /so Franksoft /ID 007 /l application /d "Franksoft Drv Inst Start %0" >Nul

SET MSG1=Install Drivers for

:: OLD GOTO Menu
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