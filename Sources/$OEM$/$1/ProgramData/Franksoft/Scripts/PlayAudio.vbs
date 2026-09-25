On Error Resume Next

Set oPlayer = CreateObject("WMPlayer.OCX")

'Sound path
oPlayer.URL = "C:\Windows\Media\Windows Proximity Notification.wav"

WScript.Sleep(5000)

'Play the music
oPlayer.controls.play 
While oPlayer.playState <> 1 ' 1 = Stopped
  WScript.Sleep 100
Wend
oPlayer.close