Add-Type -Name Window -Namespace Console -MemberDefinition '
[DllImport("Kernel32.dll")]
public static extern IntPtr GetConsoleWindow();

[DllImport("user32.dll")]
public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);
'

# Fenstertitel = Scriptname
$Host.UI.RawUI.WindowTitle = [System.IO.Path]::GetFileName($PSCommandPath)

$consolePtr = [Console.Window]::GetConsoleWindow()
[Console.Window]::ShowWindow($consolePtr, 2)

$runKeys = @(
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run",
    "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
)

$names = @(
    "*Unat*",
    "*Sykpe*",
    "*One*"
)

foreach ($key in $runKeys) {
    foreach ($name in $names) {
        Get-ItemProperty -Path $key -ErrorAction SilentlyContinue |
            Get-Member -MemberType NoteProperty |
            Where-Object { $_.Name -like $name } |
            ForEach-Object {
                Remove-ItemProperty -Path $key -Name $_.Name -ErrorAction SilentlyContinue
            }
    }
}
