Option Explicit
'~ On Error Resume Next
RequireAdmin

Dim objReg
Set objReg=GetObject("winmgmts:{impersonationLevel=impersonate}!\\.\root\default:StdRegProv")

RegWrite "HKCR\DesktopBackground\Shell\Energieoptionen-Menu-FS", "Icon", "REG_SZ", "powercpl.dll"
RegWrite "HKCR\DesktopBackground\Shell\Energieoptionen-Menu-FS", "MUIVerb", "REG_SZ", "Energiesparplan ändern"
RegWrite "HKCR\DesktopBackground\Shell\Energieoptionen-Menu-FS", "Position", "REG_SZ", "Bottom"
RegWrite "HKCR\DesktopBackground\Shell\Energieoptionen-Menu-FS", "SubCommands", "REG_SZ", ""
RegWrite "HKCR\DesktopBackground\Shell\Energieoptionen-Menu-FS\Shell\01PowerSaver", "Icon", "REG_SZ", "powercpl.dll"
RegWrite "HKCR\DesktopBackground\Shell\Energieoptionen-Menu-FS\Shell\01PowerSaver", "MUIVerb", "REG_SZ", "Energiesparmodus"
RegWrite "HKCR\DesktopBackground\Shell\Energieoptionen-Menu-FS\Shell\01PowerSaver\Command", "", "REG_SZ", "powercfg.exe /S a1841308-3541-4fab-bc81-f71556f20b4a"
RegWrite "HKCR\DesktopBackground\Shell\Energieoptionen-Menu-FS\Shell\02Balanced", "Icon", "REG_SZ", "powercpl.dll"
RegWrite "HKCR\DesktopBackground\Shell\Energieoptionen-Menu-FS\Shell\02Balanced", "MUIVerb", "REG_SZ", "Ausbalanciert"
RegWrite "HKCR\DesktopBackground\Shell\Energieoptionen-Menu-FS\Shell\02Balanced\Command", "", "REG_SZ", "powercfg.exe /S 381b4222-f694-41f0-9685-ff5bb260df2e"
RegWrite "HKCR\DesktopBackground\Shell\Energieoptionen-Menu-FS\Shell\03HighPerformance", "Icon", "REG_SZ", "powercpl.dll"
RegWrite "HKCR\DesktopBackground\Shell\Energieoptionen-Menu-FS\Shell\03HighPerformance", "MUIVerb", "REG_SZ", "Höchstleistung"
RegWrite "HKCR\DesktopBackground\Shell\Energieoptionen-Menu-FS\Shell\03HighPerformance\Command", "", "REG_SZ", "powercfg.exe /S 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c"
RegWrite "HKCR\DesktopBackground\Shell\Energieoptionen-Menu-FS\Shell\04NoSleep", "Icon", "REG_SZ", "powercpl.dll"
RegWrite "HKCR\DesktopBackground\Shell\Energieoptionen-Menu-FS\Shell\04NoSleep", "MUIVerb", "REG_SZ", "Nicht Ausschalten"
RegWrite "HKCR\DesktopBackground\Shell\Energieoptionen-Menu-FS\Shell\04NoSleep\Command", "", "REG_SZ", "cmd /c powercfg.exe /S e5bf7999-365f-410a-9c75-65c8f6efee86"

Function RegWrite(reg_keyname, reg_valuename,reg_type,ByVal reg_value)
	Dim aRegKey, Return
	aRegKey = RegSplitKey(reg_keyname)
	If IsArray(aRegKey) = 0 Then
		RegWrite = 0
		Exit Function
	End If

	Return = RegWriteKey(aRegKey)
	If Return = 0 Then
		RegWrite = 0
		Exit Function
	End If

	Select Case reg_type
		Case "REG_SZ"
			Return = objReg.SetStringValue(aRegKey(0),aRegKey(1),reg_valuename,reg_value)
		Case "REG_EXPAND_SZ"
			Return = objReg.SetExpandedStringValue(aRegKey(0),aRegKey(1),reg_valuename,reg_value)
		Case "REG_BINARY"
			If IsArray(reg_value) = 0 Then reg_value = Array()
			Return = objReg.SetBinaryValue(aRegKey(0),aRegKey(1),reg_valuename,reg_value)

		Case "REG_DWORD"
			If IsNumeric(reg_value) = 0 Then reg_value = 0
			Return = objReg.SetDWORDValue(aRegKey(0),aRegKey(1),reg_valuename,reg_value)

		Case "REG_MULTI_SZ"
			If IsArray(reg_value) = 0 Then
				If Len(reg_value) = 0 Then
					reg_value = Array()
				Else
					reg_value = Array(reg_value)
				End If
			End If
			Return = objReg.SetMultiStringValue(aRegKey(0),aRegKey(1),reg_valuename,reg_value)

		'Case "REG_QWORD"
			'Return = oReg.SetQWORDValue(aRegKey(0),aRegKey(1),reg_valuename,reg_value)
		Case Else
			RegWrite = 0
			Exit Function
	End Select

	If (Return <> 0) Or (Err.Number <> 0) Then
		RegWrite = 0
		Exit Function
	End If
	RegWrite = 1
End Function

Function RegWriteKey(RegKeyName)
	Dim Return
	If IsArray(RegKeyName) = 0 Then
		RegKeyName = RegSplitKey(RegKeyName)
	End If

	If (IsArray(RegKeyName) = 0) Or (UBound(RegKeyName) <> 1) Then
		RegWriteKey = 0
		Exit Function
	End If

	Return = objReg.CreateKey(RegKeyName(0),RegKeyName(1))
	If (Return <> 0) Or (Err.Number <> 0) Then
		RegWriteKey = 0
		Exit Function
	End If
	RegWriteKey = 1
End Function

Function RegDelete(reg_keyname, reg_valuename)
	Dim Return,aRegKey
	aRegKey = RegSplitKey(reg_keyname)
	If IsArray(aRegKey) = 0 Then
		RegDelete = 0
		Exit Function
	End If

	Return = objReg.DeleteValue(aRegKey(0),aRegKey(1),reg_valuename)
	If (Return <> 0) And (Err.Number <> 0) Then
		RegDelete = 0
		Exit Function
	End If
	RegDelete = 1
End Function

Function RegDeleteKey(reg_keyname)
	Dim Return,aRegKey
	aRegKey = RegSplitKey(reg_keyname)
	If IsArray(aRegKey) = 0 Then
		RegDeleteKey = 0
		Exit Function
	End If

	'On Error Resume Next
	Return = RegDeleteSubKey(aRegKey(0),aRegKey(1))
	'On Error Goto 0
	If Return = 0 Then
		RegDeleteKey = 0
		Exit Function
	End If
	RegDeleteKey = 1
End Function

Function RegDeleteSubKey(strRegHive, strKeyPath)
	Dim Return,arrSubkeys,strSubkey
    objReg.EnumKey strRegHive, strKeyPath, arrSubkeys
    If IsArray(arrSubkeys) <> 0 Then
        For Each strSubkey In arrSubkeys
            RegDeleteSubKey strRegHive, strKeyPath & "\" & strSubkey
        Next
    End If

	Return = objReg.DeleteKey(strRegHive, strKeyPath)
	If (Return <> 0) Or (Err.Number <> 0) Then
		RegDeleteSubKey = 0
		Exit Function
	End If
	RegDeleteSubKey = 1
End Function

Function RegSplitKey(RegKeyName)
	Dim strHive, strInstr, strLeft
	strInstr=InStr(RegKeyName,"\")
	If strInstr = 0 Then Exit Function
	strLeft=left(RegKeyName,strInstr-1)

	Select Case strLeft
		Case "HKCR","HKEY_CLASSES_ROOT"	strHive = &H80000000
		Case "HKCU","HKEY_CURRENT_USER"	strHive = &H80000001
		Case "HKLM","HKEY_LOCAL_MACHINE"	strHive = &H80000002
		Case "HKU","HKEY_USERS" 	strHive = &H80000003
		Case "HKCC","HKEY_CURRENT_CONFIG"	strHive = &H80000005
	  Case Else Exit Function
	End Select

    RegSplitKey = Array(strHive,Mid(RegKeyName,strInstr+1))
End Function

Function RequireAdmin()
	Dim reg_valuename, WShell, Cmd, CmdLine, I

	GetObject("winmgmts:{impersonationLevel=impersonate}!\\.\root\default:StdRegProv")_
	.EnumValues &H80000003, "S-1-5-19\Environment",  reg_valuename
	If IsArray(reg_valuename) <> 0 Then
		RequireAdmin = 1
		Exit Function
	End If

	Set Cmd = WScript.Arguments
	For I = 0 to Cmd.Count - 1
		If Cmd(I) = "/admin" Then
			Wscript.Echo "To script you must have administrator rights!"
			'RequireAdmin = 0
			'Exit Function
			WScript.Quit
		End If
		CmdLine = CmdLine & Chr(32) & Chr(34) & Cmd(I) & Chr(34)
	Next
	CmdLine = CmdLine & Chr(32) & Chr(34) & "/admin" & Chr(34)

	Set WShell= WScript.CreateObject( "WScript.Shell")
	CreateObject("Shell.Application").ShellExecute WShell.ExpandEnvironmentStrings(_
	"%SystemRoot%\System32\WScript.exe"),Chr(34) & WScript.ScriptFullName & Chr(34) & CmdLine, "", "runas"
	WScript.Quit
End Function