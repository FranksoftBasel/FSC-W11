Set objShell = CreateObject("Wscript.Shell")
strPath = Wscript.ScriptFullName

Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objFile = objFSO.GetFile(strPath)

strFolder = objFSO.GetParentFolderName(objFile)

RunCmd1 = "Powershell.exe -executionpolicy Bypass -File " & strFolder & "\" & "DelReg.ps1"
objShell.run RunCmd1,0

Set objShell = Nothing