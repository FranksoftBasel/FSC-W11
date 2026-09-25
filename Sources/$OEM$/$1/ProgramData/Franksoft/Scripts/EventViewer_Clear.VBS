If WScript.Arguments.Count = 0 Then
 Set objShell = CreateObject("Shell.Application")
 objShell.ShellExecute "wscript.exe", Chr(34) & WScript.ScriptFullName & Chr(34) & " Run", , "runas", 1
Else


Set LogFileSet = GetObject("winmgmts:{impersonationLevel=impersonate,(Security)}").execQuery("select * from Win32_NTEventLogFile ")

for each Logfile in LogFileSet: 
RetVal = LogFile.ClearEventlog() 
next

End If