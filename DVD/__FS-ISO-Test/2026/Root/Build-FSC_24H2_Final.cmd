@echo Off

Mode con:cols=70 lines=18
Color 9f

SET IsoRelease=25H2
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

@start "" cmd /c "Mode con:cols=70 lines=10&color 6f&Title Start Time: %time:~0,-3% &Timeout 75"

SET TD1=%temp%\%Random%
MD %TD1%

Copy "%IsoOut%" "%TD1%" /y >NUL

:: SET ISO="C:\Users\Admin\AppData\Local\Temp\14625\FSC1903.iso"
SET ISO="%TD1%\FSC%IsoRelease%.iso"

:: Set DVD-ROM Source
:: SET DP=F:\Work\FSC\W10\%IsoRelease%

:: FOR %%A IN ("%~dp0.") DO SET folder=%%~dpA
:: SET DP=%folder:~0,-1%

SET "DP=%~dp0"


:::: Start Adding FILES

:: Add boot Folder
SET DN=boot
SET DIR-2-Add=%DP%\%DN%
START /wait ULTRAISO -IN %ISO% -newdir %DN% -chdir "/%DN%" -directory "%DIR-2-Add%" -silent


:: *** Add Dummy Folder for Autounattended.cmd ***
:: SET DN=CD
:: START /wait ULTRAISO -IN %ISO% -chdir "/boot" -newdir %DN% -silent

:: Add efi Folder
SET DN=efi
SET DIR-2-Add=%DP%\%DN%
START /wait ULTRAISO -IN %ISO% -newdir %DN% -chdir "/%DN%" -directory "%DIR-2-Add%" -silent

@echo.       ^>Add Microsoft
SET DN=Microsoft
SET DIR-2-Add=%DP%\%DN%
START /wait ULTRAISO -IN %ISO% -newdir %DN% -chdir "/%DN%" -directory "%DIR-2-Add%" -silent

@echo.       ^>Add SOURCES aka i386
SET DN=Sources
SET DIR-2-Add=%DP%\%DN%
START /wait ULTRAISO -IN %ISO% -newdir %DN% -chdir "/%DN%" -directory "%DIR-2-Add%" -silent

:: Add Franksoft
SET DN=Franksoft
SET DIR-2-Add=%DP%\%DN%
START /wait /wait ULTRAISO -IN %ISO% -newdir %DN% -chdir "/%DN%" -directory "%DIR-2-Add%" -silent

:: Add Support
SET DN=Support
SET DIR-2-Add=%DP%\%DN%
START /wait /wait ULTRAISO -IN %ISO% -newdir %DN% -chdir "/%DN%" -directory "%DIR-2-Add%" -silent

:: Add Temp
SET DN=Temp
SET DIR-2-Add=%DP%\%DN%
START /wait /wait ULTRAISO -IN %ISO% -newdir %DN% -chdir "/%DN%" -directory "%DIR-2-Add%" -silent

:: Add Wism
SET DN=Wism
SET DIR-2-Add=%DP%\%DN%
START /wait /wait ULTRAISO -IN %ISO% -newdir %DN% -chdir "/%DN%" -directory "%DIR-2-Add%" -silent

:: Gen Final .iso
::START /wait ULTRAISO -IN %ISO% -file %DP%\Autorun.inf -file %DP%\Autounattend.xml -file %DP%\bootmgfw.efi -file %DP%\bootmgr -file %DP%\bootmgr.efi -file %DP%\Setup.exe -file "%DP%\Advanced Boot.lnk" -file "%DP%\RuckZuck.lnk" -file "%DP%\VMware Tools Setup.lnk" -file %DP%\lusrmgr.exe -file %DP%\Defender-Remover.exe -silent
START /wait ULTRAISO ^
  -IN %ISO% ^
  -file %DP%\Autorun.inf ^
  -file %DP%\Autounattend.xml ^
  -file %DP%\bootmgfw.efi ^
  -file %DP%\Apps ^
  -file %DP%\bootmgr ^
  -file %DP%\WinGet ^
  -file %DP%\bootmgr.efi ^
  -file %DP%\Setup.exe ^
  -file "%DP%\Advanced Boot.lnk" ^
  -file "%DP%\RuckZuck.lnk" ^
  -file "%DP%\VMware Tools Setup.lnk" ^
  -file "%DP%\Disable BitLocker" ^
  -file %DP%\lusrmgr.exe ^
  -file %DP%\Defender-Remover.exe ^
  -file %DP%\Runtimes ^
  -silent

@echo. End....: %time% >> "%LogFile%"
@echo. >> "%LogFile%"

@echo.       ^>Copy .iso back to ScriptDir
@Copy "%ISO%" %~dp0 /y

Color 2f
Start "" UltraIso "%IsoOut%"

SET EndT=%time:~0,-3%
Title Build FSC .iso Start Time:%StartT% ^>END Time:%EndT%
@echo.
@echo.       ^>Start.: %StartT% 
@echo.       ^<End...: %EndT%
@echo.

Timeout 20