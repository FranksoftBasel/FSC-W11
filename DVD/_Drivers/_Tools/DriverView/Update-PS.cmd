cd %~dp0

Set Name32=driverview.zip
Set URL32=https://www.nirsoft.net/utils/%Name32%
:: Set NameOnly32=%name32:~-4%

del *.exe
del *.chm
del readme.txt


powershell.exe -Command (new-object System.Net.WebClient).DownloadFile('%URL32%','%Name32%')

::: Extract
powershell.exe -nologo -noprofile -command "& { Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::ExtractToDirectory('%Name32%', '.'); }"
del %Name32%

Set Name32-exe=%Name32%
Set Token=.

for /f %%a in ("%Name32-exe%") do set d=%%a
for /f "tokens=1,2 delims=%Token%" %%a in ("%Name32-exe%") do set FileName=%%a&set Extension=%%b



copy %FileName%.exe %FileName%-x86.exe /y
del %FileName%.%Extension%
del %FileName%.exe
del *.chm
del readme.txt



:: -- x64 --

Set Name64=%FileName%-x64.zip
Set URL64=https://www.nirsoft.net/utils/%FileName%-x64.zip



powershell.exe -Command (new-object System.Net.WebClient).DownloadFile('%URL64%','%Name64%')
powershell.exe -nologo -noprofile -command "& { Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::ExtractToDirectory('%Name64%', '.'); }"
del %Name64%


:::: Ren and Copy 
Set Name32-exe=%Name32%
Set Token=.

for /f %%a in ("%Name32-exe%") do set d=%%a
for /f "tokens=1,2 delims=%Token% " %%a in ("%Name32-exe%") do set FileName=%%a&set Extension=%%b&set

copy %FileName%.exe %FileName%-x64.exe /y

del %FileName%.exe
