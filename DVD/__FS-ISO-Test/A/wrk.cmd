
Mode con:cols=70 lines=18
Color 9f

SET IsoRelease=22H2
SET IsoOut=FSC%IsoRelease%.iso
Set LogFile=%~dp0FSC%IsoRelease%.txt
SET StartT=%time:~0,-3%

@chcp 437 >NUL

Title **DO not Close this Window**** ^| Build FSC%IsoRelease%.iso 

@Echo.
@echo.      ษอออออออออออออออออออออออออออออออป
@echo.      บ                               บ
@echo.      บ  Build FSC %IsoRelease% please wait   บ
@echo.      บ                               บ
@echo.      ศอออออออออออออออออออออออออออออออผ
@echo.
@echo.      Start: %StartT%

@echo. Date...: %Date% >> "%LogFile%"
@echo. Start..: %Time% >> "%LogFile%"

@Del "%temp%\*.iso" /S 2>NUL 1>&2

@Copy FSC%IsoRelease%.bak FSC%IsoRelease%.iso /y >NUL

@start "" cmd /c "Mode con:cols=70 lines=10&color 6f&Title Start Time: %time:~0,-3% &Timeout 60"

SET TD1=%TEMP%\%Random%

Copy "%IsoOut%" "%TD1%" /y >NUL

:: START /wait ULTRAISO -IN FSC1903.iso -newdir boot -chdir "/boot" -f "Scripts.rar"
:: START /wait ULTRAISO -IN C:\Users\Admin\AppData\Local\Temp\6392\FSC1903.iso -newdir boot -chdir "/boot" -directory "F:\Work\FSC\W10\1903\boot"

:: SET ISO="C:\Users\Admin\AppData\Local\Temp\14625\FSC1903.iso"
SET ISO="%TD1%\FSC%IsoRelease%.iso"

:: Set DVD-ROM Source
SET DP1=F:\Work\FSC\W10\%IsoRelease%

FOR %%A IN ("%~dp0.") DO SET folder=%%~dpA
SET DP2=%folder:~0,-1%

@echo. DP1=%DP1%
@echo. DP2=%DP2%

pause
exit
