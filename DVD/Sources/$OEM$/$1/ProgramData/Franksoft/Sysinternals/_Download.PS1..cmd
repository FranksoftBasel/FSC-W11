::: 2018; As .ps1 Invoke-WebRequest -OutFile SysinternalsSuite.zip https://download.sysinternals.com/files/SysinternalsSuite.zip
::: 2018; For /F "Tokens=1-7 Delims=/:. " %%d In ("%Date% %Time%") Do Set DateAndTime=%%d.%%e.%%f-%%g.%%h.%%i.%%j

@Echo Off
@Title Download SysinternalsSuite.zip
@MODE CON: COLS=100 LINES=30

:: Add Zero to Time if not 00.hh.mm.ss
SET NT=%TIME: =0%

:: Replace String ":" to "."
SET String=%NT%
:: here : to . (:=.)
SET String=%String::=.%
SET NT1=%String%
SET NT2=%String:~0,8%

:: SET Backup Dir
Set BkDir=%DATE%-%NT2%

@Echo. 
@Echo. 
@Echo. - Move Files
If Not Exist "%BkDir%" MD "%BkDir%"
@move *.exe "%BkDir%" 1>nul 2>nul
@move *.chm "%BkDir%" 1>nul 2>nul
@move *.sys "%BkDir%" 1>nul 2>nul
@move *.hlp "%BkDir%" 1>nul 2>nul
@move *.cnt "%BkDir%" 1>nul 2>nul
@move *.txt "%BkDir%" 1>nul 2>nul
@move *.DLL "%BkDir%" 1>nul 2>nul

@Echo. - Download Archive
::: Download
Start /min /WAIT Powershell.exe -WindowStyle Hidden -Command (new-object System.Net.WebClient).DownloadFile('https://download.sysinternals.com/files/SysinternalsSuite.zip','SysinternalsSuite.zip')

@Echo. - Extract Archive
Powershell.exe -nologo -noprofile -WindowStyle Hidden -command "& { Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::ExtractToDirectory('SysinternalsSuite.zip', '.'); }"
::: Delete Source

@Echo. - Delete Archive
DEL %~DP1sys*.zip
