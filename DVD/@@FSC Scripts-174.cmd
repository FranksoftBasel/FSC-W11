@Title Start VSCode

@Echo Off
@MODE CON: COLS=57 LINES=4

@Title Start VSCode

Set FileP1=sources\$OEM$
If not Exist %FileP1% Goto ExPlease

Set App=%COMSPEC% /c start "" "%cd%\Apps\VSCode-win32-x64-1.74.2\Code.exe"

%App% "%FileP1%\$$\Setup\Scripts\SetupComplete.cmd"
@Timeout 2

%App% "%FileP1%\$1\Temp\WinPE\PE-LogFile.cmd"
@Timeout 1
%App% "%FileP1%\$1\Temp\Updates\FSC-Post-01.cmd"
@Timeout 1
%App% "%FileP1%\$1\Temp\Updates\FSC-Post-02.cmd"
%App% "%FileP1%\$1\Temp\Updates\FSC-Post-03.cmd"
%App% "%FileP1%\$1\ProgramData\Franksoft\Scripts\WinUpdate_FSC.cmd"
%App% "%FileP1%\$1\ProgramData\Franksoft\Scripts\WinGetUpdate_FSC.cmd"
%App% "%FileP1%\$1\ProgramData\Franksoft\Scripts\WinGetApps.json
%App% "_Drivers\Install_HP-Drivers.cmd"

@Timeout 2
%App% "Runtimes\FS-Post-Apps.cmd"

:ExPlease
