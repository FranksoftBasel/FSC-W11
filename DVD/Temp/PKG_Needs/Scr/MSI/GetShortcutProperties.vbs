'************************************************
' File:   GetShortcutProperties.vbs (WSH 2.0, VBScript) 
' Author:  (c) Günter Born
'
' Retrieves the properties of a shortcut file submitted
' as a parameter.
'
' A utility brought to you by G. Born: www.borncity.com
' The module is copyrighted and the property of the author.
' You have the royalty free right to use this module for
' your own purpose. The technology is discussed in the 
' Microsoft Press books:
' 
' Inside Windows Script Host (2. Auflage, MSP Germany)
' Microsoft Windows Script 2.0 Host Developer's Guide (MSP USA)
' Advanced Development with Microsoft Windows Script Host 2.0 (MSP USA)
'
' Disclaimer:
' USE AS-IS AT YOUR OWN RISK - WITHOUT ANY WARRANTY AND 
' SUPPORT! IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY 
' DAMAGE OR CONSEQUENCES FROM THE USE OF THIS MODULE.
'************************************************
Option Explicit 

Const Title = "Shortcut property viewer - by G. Born"
Dim WSHShell    ' Object variable
Dim objArgs, Shortcut

' Create a new WSHShell object
Set WSHShell = WScript.CreateObject("WScript.Shell")
' Try to retrieve the arguments
Set objArgs = Wscript.Arguments    ' create object

If objArgs.Count < 1 Then  ' no argument at all, quit with dialog
 WScript.Echo  " Sorry, no arguments found!" , vbCRLF & vbCRLF, _
  "Please drag the shortcut file to the script's icon,", _
  "or call the script using:", vbCRLF & vbCRLF, _
  "<host> GetShortcutProperties.vbs shortcut_file", vbCRLF & vbCRLF, _
  "like: CScript GetShortcutProperties.vbs C:\editor.lnk"

  WScript.Quit  ' Quit script!!!
End if

' Try to get the argument submitted to the script
If Not IsLnk (objArgs(0)) Then  ' Check, whether there is a valid link file
 WScript.Echo "Sorry, '" & objArgs(0) & "' its not a shortcut file"
 WScript.Quit
End If

' Try to create a shortcut file on the given location
' using the CreateShortcut method, if we use no save
' method, no update is done
Set Shortcut = WSHShell.CreateShortcut (objArgs(0))

MsgBox "File: " & objArgs(0)  & vbCRLF & vbCRLF & _
       "Arguments: " & vbTab & Shortcut.Arguments & vbCRLF & _ 
       "Description: " & vbTab & Shortcut.Description & vbCRLF & _
       "Full name: " & vbTab & Shortcut.FullName & vbCRLF & _
       "Hotkey: " & vbTab & Shortcut.Hotkey & vbCRLF & _
       "IconLocation: " & vbTab & Shortcut.IconLocation & vbCRLF & _
       "Target: " & vbTab & Shortcut.TargetPath & vbCRLF & _
       "WindowStyle: " & vbTab & Shortcut.WindowStyle & vbCRLF & _
       "Working directory: " & vbTab & Shortcut.WorkingDirectory & vbCRLF, _
       vbOkonly + vbInformation, Title

' ##################
Function IsLnk (name)
' Checks whether the extension is .lnk or not
' Returns true or false
 If (LCase(Right(name, 4)) = ".lnk") then 
  IsLnk = true
 Else 
  IsLnk = false   ' .lnk found
 End if
End Function
' End