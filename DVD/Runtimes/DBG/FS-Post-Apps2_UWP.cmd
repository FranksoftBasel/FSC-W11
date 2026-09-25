@Echo off
TITLE Setting-up RunOnceEx
CLS

IF EXIST "%WINDIR%\SysWOW64" (
    SET ARCH=x64
) ElSE (
    SET ARCH=x86
)



call :Admin

SET Win_Title=Franksoft Client UWP Apps-Deployment


::::::::: ----- SET Needed FSC Variables ----- :::::::::

:: Check USB Drive
for %%i in (B D E F G H I J K L M N O P Q R S T U V W X Y Z) do @IF Exist %%i:\Sources\setup.exe set USB_Stick_Path=%%i:

SET FSLOG="%ProgramData%\Franksoft\Logs\Franksoft Client.txt"
If Not Exist %ProgramData%\Franksoft\Logs MD %ProgramData%\Franksoft\Logs

:: @Echo. >>%FSLOG%
:: @Echo. FSC Setup phase...: Franksoft Windows Client Post-Setup>>%FSLOG%
:: @Echo. Time/Date.........: %NT:~0,-3% - %Date%>>%FSLOG%
:: @Echo. User Name.........: %UserName%>>%FSLOG%
:: @Echo. User Is Admin.....: %Admin%>>%FSLOG%
:: @Echo. Power Scheme......: %CurPowerP%>>%FSLOG%
@Echo. - Franksoft Client Apps-Deployment Script Start .: Time: %Time:~0,-3% Script: %~dp0%~nx0
:: @Echo. >>%FSLOG%

::::::::: ----- Start FS RunOnceEx ----- :::::::::

SET SourcePath=%~dp0Install
:: @echo. SourcePath = %SourcePath%

SET TitleDialog="%Win_Title%"

:: FOR %%I IN (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) DO IF EXIST %%I:\sources\install.esd SET DRIVE=%%I:
:: IF "%DRIVE%" == "" FOR %%I IN (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) DO IF EXIST %%I:\sources\install.wim SET DRIVE=%%I:
:: IF "%DRIVE%" == "" FOR %%I IN (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) DO IF EXIST %%I:\sources\install.swm SET DRIVE=%%I:


SET ROE=HKLM\Software\Microsoft\Windows\CurrentVersion\RunOnceEx
SET i=100

	REG ADD %ROE% /v Title /d %TitleDialog% /f
	REG ADD %ROE% /v Flags /t REG_DWORD /d "00000024" /f

	REG ADD %ROE%\%i% /ve /d "Microsoft Terminal" /f
	REG ADD %ROE%\%i% /v "001" /d "%SourcePath%\_Microsoft\Terminal\Microsoft.WindowsTerminal.cmd" /f
	SET /A i+=1

	REG ADD %ROE%\%i% /ve /d "Microsoft Quick Assist" /f
	REG ADD %ROE%\%i% /v "001" /d "%SourcePath%\_Microsoft\MSQuickAssist_2025\QuickAssist_2024.cmd" /f
	SET /A i+=1

	REG ADD %ROE%\%i% /ve /d "Microsoft RemoteDesktop 2025" /f
	REG ADD %ROE%\%i% /v "001" /d "%SourcePath%\_Microsoft\Microsoft.RemoteDesktop_2025.cmd" /f
	SET /A i+=1


:: %SystemRoot%\System32\runonce.exe /Explorer
@Echo. - FSC RUO Script End ...: Time: %Time:~0,-3% Script: %~dp0%~nx0>>%FSLOG%

:: Start RU Process

start "" runonce.exe /Explorer
exit


:Admin
reg query "HKU\S-1-5-19\Environment" >nul 2>&1
if not %errorlevel% EQU 0 (
    cls
    powershell.exe -windowstyle hidden -noprofile "Start-Process '%~dpnx0' -Verb RunAs"
    exit
)


:Admin
reg query "HKU\S-1-5-19\Environment" >nul 2>&1
if not %errorlevel% EQU 0 (
    cls
    powershell.exe -windowstyle hidden -noprofile "Start-Process '%~dpnx0' -Verb RunAs"
    exit
)



