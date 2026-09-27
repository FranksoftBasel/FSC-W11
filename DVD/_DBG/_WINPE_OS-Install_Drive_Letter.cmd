SET Path=%Path%;D:\boot

reg query HKLM\SYSTEM\Setup /v "WorkingDirectory"

SET RK=HKLM\SYSTEM\Setup
for /f "tokens=3*" %%a in ('reg query "%RK%" /V "WorkingDirectory" ^|findstr /ri "REG_SZ"') do Set FullProductName=%%a %%b

@echo. %FullProductName:~0,3%
@echo.
@echo.
pause