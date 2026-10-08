@echo off
set "THEME=%~dp0Franksoft Blau.theme"
powershell -NoProfile -WindowStyle Hidden -Command "Start-Process '%THEME%'"

:ok

start "" "%THEME%"

powershell -NoProfile -Command ^
"while (-not (Get-Process ApplicationFrameHost -ErrorAction SilentlyContinue)) { Start-Sleep -Milliseconds 1000 }; Stop-Process -Name ApplicationFrameHost -Force"