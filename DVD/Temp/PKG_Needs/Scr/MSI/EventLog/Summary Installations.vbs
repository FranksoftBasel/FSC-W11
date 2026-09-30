strComputer = "."
Set objWMIService = GetObject("winmgmts:" _
    & "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")

Set colLoggedEvents = objWMIService.ExecQuery _
        ("Select * from Win32_NTLogEvent Where Logfile = 'Application' and " _
            & "EventCode = '11707'")

Wscript.Echo "Installed MSI Packages: " & colLoggedEvents.Count
