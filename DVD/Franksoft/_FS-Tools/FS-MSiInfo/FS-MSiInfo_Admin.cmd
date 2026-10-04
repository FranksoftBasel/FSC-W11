@Echo Off
@MODE CON: COLS=60 LINES=8
@title Install Franksoft's MSI Info


(Net session >nul 2>&1)||(PowerShell start """%~0""" -verb RunAs & Exit /B)

"%~dp0FS-MSiInfo.exe" /install
"%~dp0Apps.exe"
:"%~dp0FS-MSiInfo.exe" install 
:@explorer %UserProfile%\Apps

:: Add Admin flag
REG ADD "HKCU\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v "%USERPROFILE%\Apps\FS-MSiInfo.exe" /t REG_SZ /d "~ RUNASADMIN" /f

Exit