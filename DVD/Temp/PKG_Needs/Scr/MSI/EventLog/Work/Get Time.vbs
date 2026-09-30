Set oEvents = GetObject("winmgmts:").ExecQuery ("select * from Win32_NTLogEvent where LogFile='Application'") 


For Each oEvent In oEvents 
   WScript.Echo "Event Number: " & oEvent.RecordNumber 
   WScript.Echo "Message: " & oEvent.Message 
   WScript.Echo "Time: " & ConvWbemTime(oEvent.TimeGenerated)
   ' Just list the first event (= the last in time) 
   Exit For 
 Next 


Function ConvWbemTime(IntervalFormat) 
   Dim sYear, sMonth, sDay, sHour, sMinutes, sSeconds 
   sYear = mid(IntervalFormat, 1, 4) 
   sMonth = mid(IntervalFormat, 5, 2) 
   sDay = mid(IntervalFormat, 7, 2) 
   sHour = mid(IntervalFormat, 9, 2) + 2
   sMinutes = mid(IntervalFormat, 11, 2) 
   sSeconds = mid(IntervalFormat, 13, 2) 


  ' Returning format yyyy-mm-dd hh:mm:ss 
   ConvWbemTime = sDay & "." & sMonth & "." & sYear & " " & sHour & ":" & sMinutes & ":" & sSeconds 
 End Function 

