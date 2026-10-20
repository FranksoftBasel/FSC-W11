ECHO Installing Fusion Driver
CALL installFusion.cmd
ECHO HSA Fusion Driver Installation Completed...

Echo calling Hotkey Installation
CALL installHotkey.cmd

ECHO Installing myHP and HPPK
CALL InstallHPX.cmd
ECHO HP Programmable Key Application Installation Completed...

REM Erase failure flag file when install succeeded. Most applications return zero to indicate success.

EXIT /B %ERRORLEVEL%

