
Option Explicit
Const ForReading = 1, ForWriting = 2, ForAppending = 8
Const TristateUseDefault = -2, TristateTrue = -1, TristateFalse = 0
      
Dim index, Txt(), newPath
Dim objFSO, fi, args, objShell
Dim strFile, counter, dummyVar, sTemp,objLogFile,objEntries, nCount, installer

Set objShell = CreateObject("Shell.Application")
Set objFSO = WScript.CreateObject("Scripting.FileSystemObject")
Set objShell = WScript.CreateObject("WScript.Shell")
Set objEntries = CreateObject("Scripting.Dictionary")
Set installer  	= Wscript.CreateObject("WindowsInstaller.Installer")

Set args = WScript.Arguments

'                                                    MainStream
' --------------------------------------------------------------------------------------------------

strFile = args.Item(0)
objEntries.RemoveAll
'debug

counter = 0
RepairCustumAction strFile
WScript.Quit()

'                                                    SubRoutines
' --------------------------------------------------------------------------------------------------


Function RepairCustumAction(path)
Dim database, strInsert, view1,record, oAllPropertiesToAdd, oAllExistingProperties,oAllPropertiesToRemove
Dim oAllPropertiesToRemoveFirst
Dim strQuery, view, a, i, k
Set oAllPropertiesToAdd = CreateObject("Scripting.Dictionary")
Set oAllPropertiesToRemove = CreateObject("Scripting.Dictionary")
Set oAllPropertiesToRemoveFirst = CreateObject("Scripting.Dictionary")
Set oAllExistingProperties = CreateObject("Scripting.Dictionary")


' hier alle Properties die aktualisiert werden sollen (werden überschrieben)
oAllPropertiesToRemoveFirst.Add "LIMITUI","1"
oAllPropertiesToRemoveFirst.Add "REBOOT","ReallySuppress"
oAllPropertiesToRemoveFirst.Add "ROOTDRIVE","C:\"

' hier die einzutragenden Properties aktualisieren (wenn vorhanden, kein überschreiben !!!!!!!!!!!!!!!!!!!!!!!!!!!
oAllPropertiesToAdd.Add "LIMITUI","1"
oAllPropertiesToAdd.Add "REBOOT","ReallySuppress"
oAllPropertiesToAdd.Add "ROOTDRIVE","C:\"
' hier die einzutragenden Properties aktualisieren !!!!!!!!!!!!!!!!!!!!!!!!!!!


'alle vorhandenen Properties lesen
Set database = installer.OpenDatabase(path, 1)

strQuery = "SELECT `Property`,`Value` FROM `Property` "
Set view = database.OpenView(strQuery)
view.Execute
Set record = view.Fetch
Do Until record Is Nothing
	oAllExistingProperties.Add record.StringData(1),record.StringData(2)
	Set record = view.Fetch 	
Loop

If oAllExistingProperties.Count > 0 Then
	k = oAllPropertiesToRemoveFirst.Keys
	For i=0 To oAllPropertiesToRemoveFirst.Count-1
		If (oAllExistingProperties.Exists(k(i)) = True) Then
			strInsert = "Delete from `Property` where `Property`='" & k(i) & "'"
			Set view1 = database.OpenView(strInsert)
			view1.Execute
			view1.Close
		End If
	Next
End If

' noch mal leeren, damit aktueller Stand da ist
oAllExistingProperties.RemoveAll
strQuery = "SELECT `Property`,`Value` FROM `Property` "
Set view = database.OpenView(strQuery)
view.Execute
Set record = view.Fetch
Do Until record Is Nothing
	oAllExistingProperties.Add record.StringData(1),record.StringData(2)
	Set record = view.Fetch 	
Loop

a = oAllPropertiesToAdd.Items
k = oAllPropertiesToAdd.Keys
For i=0 To oAllPropertiesToAdd.Count-1
	If (oAllExistingProperties.Exists(k(i)) = False) Then
		strInsert = "Insert into `Property` (`Property`.`Property`,`Property`.`Value`) values ('" & k(i) & "','" & a(i) & "')"
		Set view1 = database.OpenView(strInsert)
		view1.Execute
		view1.Close
	End If
Next
		
database.Commit()			

MsgBox("Datei wurde aktualisiert !")
End Function
'**************************************************************************************************
