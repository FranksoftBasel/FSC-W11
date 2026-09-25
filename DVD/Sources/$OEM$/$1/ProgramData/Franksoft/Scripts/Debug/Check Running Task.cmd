@echo off
Color 1f
MODE CON: COLS=82 LINES=10
@Title Check Running Process:   Start time: %TIME:~0,-3%


Set MSG1=not found..
Set TTimer=5

SET INPUT1=Msiexec.exe
SET INPUT2=Setup.exe


:Start 
@Cls
@Title Check Running Process: Process to search '%input1%', %input2% - Time: %TIME:~0,-3%

@QPROCESS "%INPUT1%" 1>nul 2>nul
:: IF %ERRORLEVEL% EQU 0 (Tasklist /FI "IMAGENAME eq %INPUT1%") Else (Echo. - %INPUT1% %MSG1%)
IF %ERRORLEVEL% EQU 0 (@Color 2f&ECHO TaskName:&Tasklist /NH /FO TABLE /FI "IMAGENAME eq %INPUT1%") Else (@Color 0f&Echo. %CRLF%&Echo. %INPUT1% %MSG1%..)

@QPROCESS "%INPUT2%" 1>nul 2>nul
IF %ERRORLEVEL% EQU 0 (Tasklist /FI "IMAGENAME eq %INPUT2%") Else (Dir >NUL)
:: IF %ERRORLEVEL% EQU 0 (Tasklist /FI "IMAGENAME eq %INPUT2%") Else (Echo. - %INPUT2% %MSG1%)

Timeout %TTimer% >NUL
Goto Start


:: Color Game Console
:: https://stackoverflow.com/questions/33573277/randomizing-text-color-and-background-color-in-batch-file
:: set /a rand1=%random% %% 16
:: set /a rand2=%random% %% 16
:: set HEX=0123456789ABCDEF
:: call set hexcolors=%%HEX:~%rand1%,1%%%%HEX:~%rand2%,1%%
::  Rem only Font Color. call set hexcolors=%%HEX:~%rand2%,1%%
:: color %hexcolors%
