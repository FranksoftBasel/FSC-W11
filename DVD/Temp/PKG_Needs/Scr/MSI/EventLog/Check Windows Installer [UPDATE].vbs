Option Explicit

Dim objFso, objFolder, objWMI, objItem, objShell, strEventLog
Dim strFile, strComputer, strFolder, strFileName, strPath
Dim intEvent, intNumberID, intRecordNum, colLoggedEvents, Product, TempFolder

' --------------------------------------------------------
' Set the folder and file name
' Set numbers
intNumberID = 1022 ' Event ID Number
intRecordNum = 0

Set objShell = WScript.CreateObject("WScript.Shell")
TempFolder=objShell.Environment("PROCESS").Item("TEMP")

strComputer = "."
strFileName = "Updated MSI's" & ".txt"
strFolder = TempFolder & "\"
strPath = strFolder & strFileName
strEventLog = "'Application'"

' -----------------------------------------------------
' Section to create folder and hold file.

'Wscript.Echo TempFolder

Set objFso = CreateObject("Scripting.FileSystemObject")
If objFSO.FolderExists(strFolder) Then
Set objFolder = objFSO.GetFolder(strFolder)
Else
Set objFolder = objFSO.CreateFolder(strFolder)
Wscript.Echo "Folder created " & strFolder
End If

' Convert the Tine and Date from UTC to Local
Function ConvWbemTime(IntervalFormat) 
   Dim sYear, sMonth, sDay, sHour, sMinutes, sSeconds 
   sYear = mid(IntervalFormat, 1, 4) 
   sMonth = mid(IntervalFormat, 5, 2) 
   sDay = mid(IntervalFormat, 7, 2) 
   sHour = mid(IntervalFormat, 9, 2) + 2
   sMinutes = mid(IntervalFormat, 11, 2) 
   sSeconds = mid(IntervalFormat, 13, 2) 

  ' Returning format yyyy-mm-dd hh:mm:ss 
    ConvWbemTime = sHour & ":" & sMinutes & " / "& sDay & "." & sMonth & "." & sYear 
End Function



'Wscript.Echo " Press OK and Wait 30 seconds (ish)"
Set strFile = objFso.CreateTextFile(strPath, True)
Set objWMI = GetObject("winmgmts:" & "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")
Set colLoggedEvents = objWMI.ExecQuery ("Select * from Win32_NTLogEvent Where Logfile = " & strEventLog)

' -----------------------------------------
' Next section loops through ID properties

For Each objItem in colLoggedEvents
If objItem.EventCode = intNumberID Then

'strFile.WriteLine("CN       : " & objItem.ComputerName) 
strFile.WriteLine("EventCode: " & objItem.EventCode)
strFile.WriteLine("User Name: " & objItem.User) 
'strFile.WriteLine("Time     : " & objItem.TimeWritten) 

strFile.WriteLine "Time/Date: " & ConvWbemTime(objItem.TimeGenerated)

' Set Space in The Product Name (Product: to Product  :)
Product = replace(objItem.Message,":","  :")

strFile.WriteLine Product

strFile.WriteLine (" ")
intRecordNum = intRecordNum +1
End If
Next

' Confirms the script has completed and opens the file
Set objShell = CreateObject("WScript.Shell")
objShell.run ("Explorer" &" " & strPath & "\" )

WScript.Quit
