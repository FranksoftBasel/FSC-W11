If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{   
#"No Administrative rights, it will display a popup window asking user for Admin rights"

$arguments = "& '" + $myinvocation.mycommand.definition + "'"
Start-Process "$psHome\powershell.exe" -Verb runAs -ArgumentList $arguments

break
}


$drive = Get-WmiObject -Class win32_volume -Filter "SerialNumber= '4027687136'"
Set-WmiInstance -input $drive -Arguments @{DriveLetter="A:"}


# Get Drive Serial
# $drive = Get-WmiObject -Class win32_volume -Filter "DriveLetter = 'A:'"
# $drive = Get-WmiObject -Class win32_volume -Filter "DriveLetter = 'A:'" findstr /i Serial


