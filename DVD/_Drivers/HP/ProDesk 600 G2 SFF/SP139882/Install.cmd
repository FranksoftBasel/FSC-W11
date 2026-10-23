del *.log
wmic os get osarchitecture > os.log
goto Find32

:Find32
find "32" os.log > null
if errorlevel 1 goto Find64
if errorlevel 0 goto 32bit

:Find64
find "64" os.log > null
if errorlevel 1 goto Error
if errorlevel 0 goto 64bit

:32bit
cd FW32
update32.bat
goto End

:64bit
cd FW64
update64.bat
goto End

Error:
Echo "Cannot get OS info. Updating stop !!"
echo This window will close in 15 seconds.
Timeout /T 15
goto End

:End
del *.log
exit /b 0