'' Remove ' for ask for elevation 
'' Franksoft 01.03.2023

'If WScript.Arguments.Count = 0 Then
' Set objShell = CreateObject("Shell.Application")
' objShell.ShellExecute "wscript.exe", Chr(34) & WScript.ScriptFullName & Chr(34) & " Run", , "runas", 1
'Else

Set objShell = CreateObject("Wscript.Shell")
strPath = Wscript.ScriptFullName

Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objFile = objFSO.GetFile(strPath)

strFolder = objFSO.GetParentFolderName(objFile)

'RunCmd1 = "Powershell.exe -EP Bypass -windowstyle hidden -File " & strFolder & "\" & "GetFS-Events.ps1"
RunCmd1 = "Powershell.exe -EP Bypass -File " & strFolder & "\" & "GetFS-Events.ps1"
objShell.run RunCmd1,0

Set objShell = Nothing

'End If

