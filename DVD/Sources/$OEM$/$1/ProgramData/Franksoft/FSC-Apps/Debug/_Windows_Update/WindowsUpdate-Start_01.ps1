# Delivery Optimization Service starten (DoSvc)
Start-Service -Name DoSvc

# Optional prüfen
Get-Service -Name DoSvc

# Danach Windows-Update-Modul installieren und Updates ausführen
Set-ExecutionPolicy RemoteSigned -Force
Install-PackageProvider NuGet -Force
Install-Module PSWindowsUpdate -Force
Import-Module PSWindowsUpdate
Install-WindowsUpdate -AcceptAll

pause