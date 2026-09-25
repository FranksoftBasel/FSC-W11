Set WshShell = CreateObject("WScript.Shell")
Set FSO = CreateObject("Scripting.FileSystemObject")

scriptPath = FSO.GetParentFolderName(WScript.ScriptFullName) & "\ClientI.ps1"

WshShell.Run _
    "powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File """ & scriptPath & """", _
    0, _
    False