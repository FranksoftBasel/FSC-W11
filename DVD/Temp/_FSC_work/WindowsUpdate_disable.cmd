@Echo off
for /f "tokens=6 delims=[]. " %%G in ('ver') do if %%G lss 10240 goto :WIN78
if not exist "%WINDIR%\System32\UsoClient.exe" GOTO WIN78

net stop wuauserv
net stop UsoSvc
for %%i in (
 %windir%\System32\wuaueng.dll %windir%\System32\UsoClient.exe
) do (
 takeown.exe /f %%i /a
 icacls.exe %%i /reset
 icacls.exe %%i /inheritance:r
)

Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\WaaSMedicSvc" /v "Start" /t REG_DWORD /d "0x4" /f
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "WUServer" /t REG_SZ /d "127.0.0.1" /f
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "WUStatusServer" /t REG_SZ /d "127.0.0.1" /f
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "ElevateNonAdmins" /t REG_DWORD /d "0x0" /f
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "AUOptions" /t REG_DWORD /d "0x1" /f
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "AutoInstallMinorUpdates" /t REG_DWORD /d "0x0" /f
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoUpdate" /t REG_DWORD /d "0x1" /f
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoRebootWithLoggedOnUsers" /t REG_DWORD /d "0x1" /f
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v "ElevateNonAdmins" /t REG_DWORD /d "0x0" /f
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v "AUOptions" /t REG_DWORD /d "0x1" /f
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v "AutoInstallMinorUpdates" /t REG_DWORD /d "0x0" /f
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v "NoAutoUpdate" /t REG_DWORD /d "0x1" /f
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v "NoAutoRebootWithLoggedOnUsers" /t REG_DWORD /d "0x1" /f
exit

:WIN78
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v "ElevateNonAdmins" /t REG_DWORD /d "0x0" /f
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v "AUOptions" /t REG_DWORD /d "0x1" /f
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v "AutoInstallMinorUpdates" /t REG_DWORD /d "0x0" /f
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v "NoAutoUpdate" /t REG_DWORD /d "0x1" /f
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v "NoAutoRebootWithLoggedOnUsers" /t REG_DWORD /d "0x1" /f
