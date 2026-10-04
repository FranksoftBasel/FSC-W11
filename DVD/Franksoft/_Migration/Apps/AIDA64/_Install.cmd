%~d0
cd %~dp0

Set ADV=5.70.3800

md "%ProgramFiles%\Aida64\%ADV%"
copy *.* "%ProgramFiles%\Aida64\%ADV%"
explorer "%ProgramFiles%\Aida64\%ADV%"


del "%ProgramFiles%\Aida64\%ADV%\rep*.exe"
del "%ProgramFiles%\Aida64\%ADV%\frank*.*"
del "%ProgramFiles%\Aida64\%ADV%\_Manual Report.cmd"
del "%ProgramFiles%\Aida64\%ADV%\Neu MS-Dos Batch.bat"
del "%ProgramFiles%\Aida64\%ADV%\_Install.cmd"
del "%ProgramFiles%\Aida64\%ADV%\_Manual Report (Drivers).cmd"

explorer.exe "%ProgramFiles%\Aida64\%ADV%"


exit