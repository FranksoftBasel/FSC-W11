$audioDevice = Get-CimInstance Win32_SoundDevice |
    Where-Object { $_.Status -eq "OK" }

if ($audioDevice) {
    & "C:\ProgramData\Franksoft\Scripts\SetVol.exe" 20
}
else {
    exit
}