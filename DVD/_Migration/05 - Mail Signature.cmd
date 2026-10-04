@echo off
if exist "%Appdata%\Microsoft\Signatures\" explorer "%Appdata%\Microsoft\Signatures\"
goto end
exit