@echo off
MODE CON: COLS=85 LINES=10

@title Check Running Process:   Start time: %time%
color 1f

SET INPUT1=powershell.exe

SET INPUT2=msiexec.exe



:start 
@cls
rem tasklist /FI "IMAGENAME eq powershell.exe"

@title Check Running Process:   Process to search '%input1%' and '%input2%'
tasklist /FI "IMAGENAME eq %INPUT1%"
tasklist /FI "IMAGENAME eq %INPUT2%"


timeout 5 >NUL
goto start
