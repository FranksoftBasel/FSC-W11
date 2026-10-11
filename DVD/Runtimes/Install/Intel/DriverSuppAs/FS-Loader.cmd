:: =========================================================
:: OPTIONAL START MINIMIZED
:: =========================================================
if not "%1"=="FSC" start /min cmd /c ""%~0" FSC %*" & exit /b


"%~dp0Intel-Driver-and-Support-Assistant-Installer.exe" /install /quiet /norestart