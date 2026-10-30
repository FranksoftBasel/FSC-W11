# ============================================================================
# Script : FSC-AppSnapshot.ps1
# Version: 1.0
# Date   : 25.10.2026
# Time   : 17:00:00
# Author : Franksoft
# Windows PowerShell 5.1. Read-only inventory; never uses Win32_Product.
# Before is immutable per Windows installation and user. After is refreshed.
# ============================================================================
[CmdletBinding()]
param([Parameter(Mandatory=$true)][ValidateSet('Before','After')][string]$Stage)
$ErrorActionPreference = 'Stop'
try {
    $root = Join-Path $env:ProgramData 'Franksoft\Logs\AppSnapshots'
    $null = New-Item -ItemType Directory -Path $root -Force
    $sid = [Security.Principal.WindowsIdentity]::GetCurrent().User.Value
    $os = Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion'
    $session = '{0}|{1}|{2}' -f $env:COMPUTERNAME,$os.InstallDate,$sid
    $path = Join-Path $root ($Stage + '.json')
    if ($Stage -eq 'Before' -and (Test-Path -LiteralPath $path)) {
        $previous = Get-Content -LiteralPath $path -Raw | ConvertFrom-Json
        if ($previous.Session -eq $session) { Write-Host 'Before-Snapshot bleibt erhalten.'; exit 0 }
    }
    $apps = @()
    foreach ($hive in @('LocalMachine','CurrentUser')) {
        foreach ($view in @('Registry64','Registry32')) {
            $base = [Microsoft.Win32.RegistryKey]::OpenBaseKey([Microsoft.Win32.RegistryHive]::$hive,[Microsoft.Win32.RegistryView]::$view)
            try {
                $uninstall = $base.OpenSubKey('SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall')
                if ($null -eq $uninstall) { continue }
                try {
                    foreach ($child in $uninstall.GetSubKeyNames()) {
                        $key = $uninstall.OpenSubKey($child)
                        try {
                            $name = [string]$key.GetValue('DisplayName','')
                            if (-not $name -or $key.GetValue('SystemComponent',0) -eq 1 -or $key.GetValue('ParentKeyName','')) { continue }
                            $version = [string]$key.GetValue('DisplayVersion','')
                            $publisher = [string]$key.GetValue('Publisher','')
                            # MSI product GUIDs can change on upgrades. Compare product family instead.
                            $family = $name
                            if ($version) { $family = $family -replace [regex]::Escape($version),'' }
                            $family = ($family -replace '\s+',' ').Trim()
                            $apps += [pscustomobject]@{ Id="Win32|$hive|$view|$publisher|$family"; Name=$name; Version=$version; Publisher=$publisher; Source="$hive/$view" }
                        } finally { if ($key) { $key.Dispose() } }
                    }
                } finally { $uninstall.Dispose() }
            } finally { $base.Dispose() }
        }
    }
    # Current user only: run Before and After under the same deployment account.
    foreach ($app in @(Get-AppxPackage -ErrorAction Stop | Where-Object { -not $_.IsFramework -and -not $_.IsResourcePackage })) {
        $apps += [pscustomobject]@{Id="Appx|$($app.PackageFamilyName)";Name=$app.Name;Version=[string]$app.Version;Publisher=$app.Publisher;Source='Store/Appx'}
    }
    $snapshot = [ordered]@{Schema=1;Session=$session;UserSid=$sid;Stage=$Stage;Captured=(Get-Date).ToString('o');Apps=@($apps | Sort-Object -Property @('Id','Version') -Unique)}
    # Preserve earlier captures, including previous deployment data.
    if (Test-Path -LiteralPath $path) { Copy-Item -LiteralPath $path -Destination ($path + '.' + (Get-Date -Format 'yyyyMMdd-HHmmss-fffffff') + '.bak') }
    $tempPath = $path + '.' + [guid]::NewGuid().ToString('N') + '.tmp'
    $snapshot | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath $tempPath -Encoding UTF8
    Move-Item -LiteralPath $tempPath -Destination $path -Force
    Write-Host "$Stage App-Snapshot: $($snapshot.Apps.Count) Eintraege; $path"
    exit 0
} catch { Write-Error $_; exit 1 }
