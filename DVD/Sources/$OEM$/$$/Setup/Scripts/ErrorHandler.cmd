Color 4f
TITLE %~nx0 TIme: %TIME%
SET DBG=1
IF %DBG%==1 MD "%SystemDrive%\Desktop\_%~nx0_"

xcopy C:\Windows\Panther %SystemDrive%\_Panter_LOGS\ /S/Y