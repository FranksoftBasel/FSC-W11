@Echo Off
Title Instal FS-MSiInfo Viewer - Start time: %TIME:~0,-3%
@MODE CON: COLS=57 LINES=4
CD %~dp0

"%~dp0FS-MSiInfo.exe" /install
"%~dp0Apps.exe"

::"%~dp0FS-MSiInfo.exe" install 
::@explorer %UserProfile%\Apps

Exit

:: Add Admin flag
:REG ADD "HKCU\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v "%USERPROFILE%\Apps\FS-MSiInfo.exe" /t REG_SZ /d "~ RUNASADMIN" /f


:: Disco Light :-)
:Start

set /a rand1=%random% %% 16
set /a rand2=%random% %% 16
set HEX=0123456789ABCDEF
call set hexcolors=%%HEX:~%rand1%,1%%%%HEX:~%rand2%,1%%
 Rem only Font Color. call set hexcolors=%%HEX:~%rand2%,1%%
color %hexcolors%

Goto Start

