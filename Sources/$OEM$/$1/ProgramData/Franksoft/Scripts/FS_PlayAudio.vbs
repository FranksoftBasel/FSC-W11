On Error Resume Next
strWaveFile = CreateObject("WScript.Shell").ExpandEnvironmentStrings("%WINDIR%") & "\Media\FSC-NT5-Beta.wav"

If CreateObject("Scripting.FileSystemObject").FileExists(strWaveFile) Then

    Set objShell = CreateObject("Wscript.Shell")

    ' Sound versteckt abspielen
    objShell.Run _
        "powershell -c (New-Object Media.SoundPlayer '" & strWaveFile & "').PlaySync();", _
        0, _
        True

    Set objShell = Nothing

End If