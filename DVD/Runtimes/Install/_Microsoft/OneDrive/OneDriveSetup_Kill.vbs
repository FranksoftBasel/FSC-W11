
Option Explicit
Dim objWMIService, objProcess, colProcess
Dim strComputer, strProcessKill 
strComputer = "."
strProcessKill = "'OneDrive.exe'" 

Set objWMIService = GetObject("winmgmts:" _
& "{impersonationLevel=impersonate}!\\" _ 
& strComputer & "\root\cimv2") 

Set colProcess = objWMIService.ExecQuery _
("Select * from Win32_Process Where Name = " & strProcessKill )
For Each objProcess in colProcess
objProcess.Terminate()
Next 
WScript.Quit 
' End of WMI Example of a Kill Process 

