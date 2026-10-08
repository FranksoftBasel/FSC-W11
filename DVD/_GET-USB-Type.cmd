FSC-Post-01.cmd

set "OUTFILE=USB-HW-Type_%RANDOM%.txt"

powershell.exe -NoProfile -ExecutionPolicy Bypass -Command ^
 "Get-Disk | Where-Object { $_.BusType -eq 'USB' } | Select-Object Number, FriendlyName, SerialNumber, @{N='SizeGB';E={[math]::Round($_.Size / 1GB, 2)}}, BusType, PartitionStyle | Format-Table -AutoSize | Out-String -Width 250 | Out-File -FilePath '%OUTFILE%' -Encoding UTF8"

echo.
echo USB Hardware Report:
echo %OUTFILE%
echo.

