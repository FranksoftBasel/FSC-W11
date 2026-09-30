If WScript.Arguments.length = 0 Then
   Set objShell = CreateObject("Shell.Application")
   'Pass a bogus argument, say [ uac]
   objShell.ShellExecute "wscript.exe", Chr(34) & _
      WScript.ScriptFullName & Chr(34) & " uac", "", "runas", 1
Else

strComputer = "."
Set objWMIService = GetObject("winmgmts:" _
    & "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")

Set colSoftware = objWMIService.ExecQuery _
    ("Select * from Win32_Product Where IdentifyingNumber = '{CD95F661-A5C4-44F5-A6AA-ECDD91C24119}'")

For Each objSoftware in colSoftware
    objSoftware.Uninstall()
Next

End If