@echo off
pushd "%~dp0"

:: set "LOGFILE=%~dp0%~n0-%date:~-4,4%-%date:~3,2%-%date:~0,2%-%random%.log"

"%~dp0Intel-Driver-and-Support-Assistant-Installer.exe" /Silent
