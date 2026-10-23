@echo off
del *.log
MEInfoWin64.exe > meinfo.log
goto FindLP

:FindLP
findstr /i /c:"FW Version" meinfo.log |findstr /i /c:"LP"
if errorlevel 1 goto FindH
if errorlevel 0 goto LP

:FindH
findstr /i /c:"FW Version" meinfo.log |findstr /i /c:"H"
if errorlevel 1 goto Error
if errorlevel 0 goto H

:LP
echo.
FWUpdLcl64.exe -f ../ME/ME_11.8_Corporate_C0_LP_Production.bin -allowsv -y
goto Success

:H
FWUpdLcl64.exe -f ../ME/ME_11.8_Corporate_D0_H_Production.bin -allowsv -y
goto Success

:Error
echo "Cannot get ME info for the HW SKU. Updating Stop !!"
echo.
goto End

:Success
xcopy "MEFWDetailFile.exe" "C:\Program Files\Intel\Intel(R) Management Engine Components\" /y
echo.
echo Update complete. You must reboot your computer in order for the Management Engine firmware update to be effective. 
echo.


goto End

:End
del *.log
echo.
echo This window will close in 15 seconds.
Timeout /T 15