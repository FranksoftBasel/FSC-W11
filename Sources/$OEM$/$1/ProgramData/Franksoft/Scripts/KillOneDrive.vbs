On Error Resume Next

Dim oShell : Set oShell = CreateObject("WScript.Shell")
oShell.Run "taskkill /im onedrive.exe /f",0