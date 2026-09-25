if not "%1"=="7" start /min cmd /c ""%~0" 7 %*" & exit /b

goto ok

@echo off
set "THEME=%~dp0Franksoft Hell.theme"
powershell -NoProfile -WindowStyle Hidden -Command "Start-Process '%THEME%'"

:ok

@echo off

start "" "%~dp0Franksoft Dunkel.theme"

powershell -NoProfile -Command ^
"while (-not (Get-Process ApplicationFrameHost -ErrorAction SilentlyContinue)) { Start-Sleep -Milliseconds 1000 }; Stop-Process -Name ApplicationFrameHost -Force"