If WScript.Arguments.length = 0 Then
   Set objShell = CreateObject("Shell.Application")
   'Pass a bogus argument, say [ uac]
   objShell.ShellExecute "wscript.exe", Chr(34) & _
      WScript.ScriptFullName & Chr(34) & " uac", "", "runas", 1
Else

Set LogFileSet = GetObject("winmgmts:{impersonationLevel=impersonate,(Security)}").execQuery("select * from Win32_NTEventLogFile ")

for each Logfile in LogFileSet: 
RetVal = LogFile.ClearEventlog() 
next

End If

