@MODE CON: COLS=200
@echo. 
@echo. - Last 20 Windows Events (Application,System,Security)
@echo. 

powershell Get-EventLog -Log Application -newest 20
powershell Get-EventLog -Log System -newest 20
powershell Get-EventLog -Log Security -newest 20

pause
exit

cmd /k powershell Get-EventLog -Log Application -Source "MsiInstaller" -newest 20 -Width 250

New-EventLog -Log Application -Source "MsiInstaller"
Get-EventLog -Log Application -Source "MsiInstaller" -newest 20 -InstanceId 11707




Get-EventLog -LogName application -After (get-date).addminutes(-15)
Get-EventLog -LogName application -After (get-date).addminutes(-15) -EntryType error
Get-EventLog -LogName application -After (get-date).addminutes(-15) -EntryType error -Source "directory synchronization"



Get-EventLog -List

Get-EventLog -LogName System -Newest 5

DBG:
Get-EventLog -LogName application -EntryType error -newest 20