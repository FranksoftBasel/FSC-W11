'--------------------8<---------------------- 
' Script that reports installed updates that are 
' installed with Windows Update v5 technology 
' 
' Result will be written to %temp%\UpdateHistory.txt 
' and then launched in Notepad 
' 
' Author: Torgeir Bakken 
' Date 2004-08-12 
' 
Option Explicit 


Const OverwriteIfExist = -1 
Const OpenAsASCII   =  0 


Dim oWU, iTHCount, colUpdate, oUpdate, sStatus, iTotal 
Dim iSuccess, iFailed, iAborted, iUnknown, sErrorCode 
Dim oFSO, oShell, sFile, f 


On Error Resume Next 
Set oWU = CreateObject("Microsoft.Update.Searcher") 


If Err.Number <> 0 Then 
   MsgBox "WU5 programming interface does not exist.", _ 
          vbInformation + vbSystemModal, "Update history" 
   WScript.Quit 
End If 
On Error Goto 0 


iTHCount = oWU.GetTotalHistoryCount 
If iTHCount > 0 Then 


   Set oFSO = CreateObject("Scripting.FileSystemObject") 
   Set oShell = CreateObject("Wscript.Shell") 
   sFile = oShell.ExpandEnvironmentStrings(".") & "\Windows Updates.txt" 
   Set f = oFSO.CreateTextFile(sFile, _ 
                      OverwriteIfExist, OpenAsASCII) 


   iTotal = 0 
   iSuccess = 0 
   iFailed = 0 
   iAborted = 0 
   iUnknown = 0 


   f.WriteLine "Report run at " & Now 
     f.WriteLine "---------------------------------" _ 
           & "---------------------------------" 


   Set colUpdate = oWU.QueryHistory(0, iTHCount) 


   For Each oUpdate In colUpdate 
     f.WriteLine "Title:" & vbTab & vbTab & vbTab & oUpdate.Title 
     f.WriteLine "Description:" & vbTab & vbTab & oUpdate.Description 
     f.WriteLine "Date/Time in GMT:" & vbTab & oUpdate.Date 
     f.WriteLine "Install mechanism:" & vbTab & oUpdate.ClientApplicationID 


     sErrorCode = "" 
     Select Case oUpdate.ResultCode 
       Case 2 
         sStatus = "Succeeded" 
         iSuccess = iSuccess + 1 
       Case 4 
         sStatus = "Failed" 
         iFailed = iFailed + 1 
         sErrorCode = oUpdate.UnmappedResultCode 
       Case 5 
         sStatus = "Aborted" 
         iAborted = iAborted + 1 
       Case Else 
         sStatus = "Unknown" 
         iUnknown = iUnknown + 1 
     End Select 


     If sStatus = "Failed" Then 
       f.WriteLine "Install error:" & vbTab & vbTab & sErrorCode 
     End If 


     f.WriteLine "Install status:" & vbTab & vbTab & sStatus 
     f.WriteLine "---------------------------------" _ 
           & "---------------------------------" 


     iTotal = iTotal + 1 
   Next 


   f.WriteLine 
   f.WriteLine "Total number of updates found: " & iTotal 
   f.WriteLine "Number of updates succeeded: " & iSuccess 
   f.WriteLine "Number of updates failed: " & iFailed 
   f.WriteLine "Number of updates aborted: " & iAborted 


   f.Close 
   oShell.Run "notepad.exe " & """" & sFile & """", 1, False 
Else 


   MsgBox "No entries found in Update History.", _ 
          vbInformation + vbSystemModal, "Update history" 


End If 
'--------------------8<---------------------- 