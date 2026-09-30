Call GetArguments(ArgArray)


If IsArray(ArgArray) then

	For Each ArrayElement In ArgArray
		Wscript.Echo GetMSIProperties(ArrayElement)
	Next

Else

	WScript.Echo "Drag and drop MSI-File over the Script"

End if


' ----------------------------------------
Private Function GetMSIProperties(strMSIFile)

Dim oWI : Set oWI = CreateObject("WindowsInstaller.Installer")
Dim oDB : Set oDB = oWI.OpenDatabase(strMSIFile, 2)
Dim oView : Set oView = oDB.OpenView("Select * From Property")
Dim oRecord
oView.Execute

	Do
		Set oRecord = oView.Fetch

			If oRecord Is Nothing Then Exit Do

			iColumnCount = oRecord.FieldCount
			rowData = Empty
			delim = "  "

			For iColumn = 1 To iColumnCount
				If iColumn = iColumnCount Then delim = vbLf
				rowData = rowData & oRecord.StringData(iColumn) & delim
			Next

			strMessage = strMessage & rowData
	Loop

Set oRecord = Nothing
Set oView = Nothing
Set oDB = Nothing
Set oWI = Nothing

GetMSIProperties = strMessage

End Function



' ----------------------------------------
Private Function GetArguments(SourceArray)

Dim iCount : iCount = 0

	If wscript.arguments.count > 0 then

		ReDim ArgArray(wscript.arguments.count -1)

		For Each Argument in wscript.arguments

			ArgArray(iCount) = Argument
			iCount = iCount +1
		Next


	iCount = Null
	GetArguments = ArgArray
		

	End if

End Function
