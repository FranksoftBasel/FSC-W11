@echo off
@MODE CON: COLS=40 LINES=10
chcp 65001
TITLE FSC WinUPD On or OFF 
cls
@Echo. 
@Echo. Franksoft Client Windows Update
@Echo. 
@Echo. Wählen Sie eine Option:
@Echo.
@Echo. 1. Windows Update = On
@Echo. 2. Windows Update = Off
@Echo.
set /p choice="Geben Sie 1 oder 2 ein: "

if "%choice%"=="1" (
    @color 2f
    IF EXIST WinUpd_0.txt del /F/Q WinUpd_0.txt
    IF EXIST WinUpd_1.txt del /F/Q WinUpd_1.txt
    @echo Dummy > WinUpd_1.txt
) else if "%choice%"=="2" (
    @color 4f
    IF EXIST WinUpd_0.txt del /F/Q WinUpd_0.txt
    IF EXIST WinUpd_1.txt del /F/Q WinUpd_1.txt
    @echo Dummy > WinUpd_0.txt
) else (
    echo Ungültige Auswahl! Bitte wählen Sie 1 oder 2.
    exit /b
)

