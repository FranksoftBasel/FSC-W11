@echo off

cd %cd%
set here=%CD%


if exist "D:\Data\_My_Files_2010" (
start "" TrueCrypt.exe /v D:\Data\_My_Files_2010 /ls /a /e /q
) else (
start "" TrueCrypt\TrueCrypt.exe /v E:\Data\_My_Files_2010 /ls /a /e /q
)


exit