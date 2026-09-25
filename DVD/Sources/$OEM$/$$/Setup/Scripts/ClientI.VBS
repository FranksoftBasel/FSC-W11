' Autor 	: Frank@Franksoft.Net
' Description  	: Show Franksoft and HW Info
' Date     	: 29.04.2004
' Required 	: Applyed FSInfo.VBS from Post.bat

On Error Resume Next

Set WshShell = WScript.CreateObject("WScript.Shell")


Author = WshShell.RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Franksoft\Client Info\Author")
Mail = WshShell.RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Franksoft\Client Info\Mail")
Url = WshShell.RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Franksoft\Client Info\Url")
Support = WshShell.RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Franksoft\Client Info\Support")
InstallDate = WshShell.RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Franksoft\Client Info\InstallDate")
Release = WshShell.ExpandEnvironmentStrings("%fsrel%")


HWSet   = WshShell.RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Franksoft\HW Setup\Hardware Model")
CPU     = WshShell.RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Franksoft\HW Setup\Processor")
RAM     = WshShell.RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Franksoft\HW Setup\Total Physical Memory")
BiosVer = WshShell.RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Franksoft\HW Setup\Bios\Bios Version")
DispDev = WshShell.RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Franksoft\HW Setup\Display\DeviceName")
DDrvver = WshShell.RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Franksoft\HW Setup\Display\DriverVersion")
VMode	= WshShell.RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Franksoft\HW Setup\Display\VideoMode")

msgbox "FRANKSOFT Windows Client Information: " & vbcrlf & vbcrlf & "Author : " &  Author & vbcrlf & "InstallDate : " &  InstallDate &  vbcrlf & "Mail : " &  Mail &  vbcrlf & "Web : " & "www.Franksoft.Net"  & vbcrlf & "Release : " & Release & vbcrlf & vbcrlf & "HARDWARE INFO : " & vbcrlf & vbcrlf & "Model : " & HWSet & vbcrlf & "Processor : " & CPU & vbcrlf & "Physical Memory : " & RAM & vbcrlf & "Bios Version : " & BiosVer & vbcrlf & "Video Driver Version : " & DDrvver & vbcrlf & "Video Card : " & DispDev & vbcrlf & "Video Mode : " & VMode, 64, "Franksoft System Information"
'WScript.Echo "FRANKSOFT CLIENT INFO : " & vbcrlf & vbcrlf & "Author : " &  Author & vbcrlf & "Mail : " &  Mail &  vbcrlf & "Support : " & Support  & vbcrlf & "Release : " & Release & vbcrlf & vbcrlf & "HARDWARE INFO : " & vbcrlf & vbcrlf & "Model : " & HWSet & vbcrlf & "Processor : " & CPU & vbcrlf & "Bios Version : " & BiosVer & vbcrlf & "Video Driver Version : " & DDrvver & vbcrlf & "Video Card : " & DispDev & vbcrlf & "Video Mode : " & VMode, 64, "Franksoft 2004"
'WScript.Echo "Mail : " &  Mail



WScript.Quit(0)


