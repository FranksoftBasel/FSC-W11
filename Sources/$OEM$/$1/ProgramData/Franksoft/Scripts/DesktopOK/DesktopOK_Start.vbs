Set WshShell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")

' Äquivalent zu %~dp0 – also Verzeichnis der VBS-Datei
scriptPath = fso.GetParentFolderName(WScript.ScriptFullName)

' Pfad zur CMD-Datei im gleichen Ordner
cmdFile = Chr(34) & scriptPath & "\DesktopOK_Start.cmd" & Chr(34)

' 7 = minimiert starten, False = nicht warten
WshShell.Run cmdFile, 7, False
