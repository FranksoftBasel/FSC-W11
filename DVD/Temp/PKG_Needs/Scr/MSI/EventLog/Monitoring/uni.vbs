strComputer = "."
Set objWMIService = GetObject("winmgmts:" _
    & "{impersonationLevel=impersonate, (Security)}!\\" & _
        strComputer & "\root\cimv2")

Set colMonitoredEvents = objWMIService.ExecNotificationQuery _    
    ("Select * from __instancecreationevent where " _
        & "TargetInstance isa 'Win32_NTLogEvent' " _
            & "and TargetInstance.EventCode = '11724' ")

Do
    Set objLatestEvent = colMonitoredEvents.NextEvent
     strAlertToSend = objLatestEvent.TargetInstance.User _ 
         & " Msi UnInstalled."
     Wscript.Echo strAlertToSend
Loop
