@echo off
:: rem regedit.exe /e "%cd%\%ComputerName%_%UserName%_%date%.reg"

:: rd "%temp%" /S/Q

regedit.exe /e "%TEMP%\%ComputerName%_%UserName%_%date%.reg"

explorer "%Temp%"