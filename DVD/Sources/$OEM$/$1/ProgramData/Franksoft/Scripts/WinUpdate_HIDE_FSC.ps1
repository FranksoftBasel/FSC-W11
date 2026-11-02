# Als Administrator ausführen

$KBs = @(
    "KB5127648",
    "KB5094126"
)

if (!(Get-Module -ListAvailable -Name PSWindowsUpdate)) {
    Install-Module PSWindowsUpdate -Force -Scope AllUsers
}

Import-Module PSWindowsUpdate

foreach ($KB in $KBs) {
    Hide-WindowsUpdate -KBArticleID $KB -Confirm:$false
    Write-Host "$KB wurde ausgeblendet." -ForegroundColor Green
}