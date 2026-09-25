@echo off
pushd "%~dp0"

set "LOGFILE=%~dp0%~n0-%date:~-4,4%-%date:~3,2%-%date:~0,2%-%random%.log"

echo GFX Install Start : %time%>>"%LOGFILE%"

"%~dp0gfx_win_101.7085.exe" -s -o -f --noExtras --terminateProcesses --unsigned

echo GFX Install End   : %time%>>"%LOGFILE%"

