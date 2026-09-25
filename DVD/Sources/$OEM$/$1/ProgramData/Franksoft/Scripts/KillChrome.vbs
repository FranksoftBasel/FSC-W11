On Error Resume Next

Dim oShell : Set oShell = CreateObject("WScript.Shell")
oShell.Run "taskkill /im Chrome.exe /f",0
oShell.Run "taskkill /im GUIPropView.exe /f",0