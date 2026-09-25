# ============================================================================
# FSC-Screenshot-V4.ps1
# Franksoft Client Deployment - Window Screenshot
#
# V4:
# - Wartet 10 Sekunden
# - Sucht "Franksoft Client Deployment"
# - DPI-aware
# - Verwendet DWM Extended Frame Bounds fuer die sichtbaren Fenstergrenzen
# - Erster Screenshot: FSC-Complete.png
# - Weitere: FSC-Complete_yyyy-MM-dd_HH-mm-ss.png
# ============================================================================

$ErrorActionPreference = "Stop"

$WindowTitle = "Franksoft Client Deployment"
$LogPath     = "C:\ProgramData\Franksoft\Logs"
$BaseFile    = Join-Path $LogPath "FSC-Complete.png"

try {
    Add-Type -AssemblyName System.Drawing

    if (-not ("FSCWindowCaptureV4" -as [type])) {
        Add-Type @"
using System;
using System.Text;
using System.Runtime.InteropServices;

public static class FSCWindowCaptureV4
{
    [StructLayout(LayoutKind.Sequential)]
    public struct RECT
    {
        public int Left;
        public int Top;
        public int Right;
        public int Bottom;
    }

    public delegate bool EnumWindowsProc(IntPtr hWnd, IntPtr lParam);

    [DllImport("user32.dll")]
    [return: MarshalAs(UnmanagedType.Bool)]
    public static extern bool EnumWindows(EnumWindowsProc lpEnumFunc, IntPtr lParam);

    [DllImport("user32.dll", CharSet = CharSet.Unicode)]
    public static extern int GetWindowText(
        IntPtr hWnd,
        StringBuilder lpString,
        int nMaxCount
    );

    [DllImport("user32.dll")]
    public static extern int GetWindowTextLength(IntPtr hWnd);

    [DllImport("user32.dll")]
    [return: MarshalAs(UnmanagedType.Bool)]
    public static extern bool IsWindowVisible(IntPtr hWnd);

    [DllImport("user32.dll")]
    [return: MarshalAs(UnmanagedType.Bool)]
    public static extern bool GetWindowRect(
        IntPtr hWnd,
        out RECT lpRect
    );

    [DllImport("user32.dll")]
    [return: MarshalAs(UnmanagedType.Bool)]
    public static extern bool SetProcessDPIAware();

    [DllImport("user32.dll")]
    public static extern IntPtr SetThreadDpiAwarenessContext(
        IntPtr dpiContext
    );

    [DllImport("dwmapi.dll")]
    public static extern int DwmGetWindowAttribute(
        IntPtr hwnd,
        int dwAttribute,
        out RECT pvAttribute,
        int cbAttribute
    );
}
"@
    }

    # Per-Monitor-V2 DPI Awareness
    try {
        [void][FSCWindowCaptureV4]::SetThreadDpiAwarenessContext([IntPtr](-4))
    }
    catch {
        try {
            [void][FSCWindowCaptureV4]::SetProcessDPIAware()
        }
        catch {}
    }

    # FSC-Complete vollstaendig anzeigen lassen
    Start-Sleep -Seconds 10

    $script:FoundHandle = [IntPtr]::Zero

    $Callback = [FSCWindowCaptureV4+EnumWindowsProc]{
        param([IntPtr]$hWnd, [IntPtr]$lParam)

        if ([FSCWindowCaptureV4]::IsWindowVisible($hWnd)) {
            $Length = [FSCWindowCaptureV4]::GetWindowTextLength($hWnd)

            if ($Length -gt 0) {
                $Builder = New-Object System.Text.StringBuilder ($Length + 1)

                [void][FSCWindowCaptureV4]::GetWindowText(
                    $hWnd,
                    $Builder,
                    $Builder.Capacity
                )

                if ($Builder.ToString() -eq $WindowTitle) {
                    $script:FoundHandle = $hWnd
                    return $false
                }
            }
        }

        return $true
    }

    [void][FSCWindowCaptureV4]::EnumWindows(
        $Callback,
        [IntPtr]::Zero
    )

    if ($script:FoundHandle -eq [IntPtr]::Zero) {
        throw "Fenster '$WindowTitle' wurde nicht gefunden."
    }

    # Sichtbare DWM-Fenstergrenzen statt unsichtbarem Resize-/Shadow-Rahmen.
    # DWMWA_EXTENDED_FRAME_BOUNDS = 9
    $Rect = New-Object FSCWindowCaptureV4+RECT
    $RectSize = [System.Runtime.InteropServices.Marshal]::SizeOf(
        [type][FSCWindowCaptureV4+RECT]
    )

    $DwmResult = [FSCWindowCaptureV4]::DwmGetWindowAttribute(
        $script:FoundHandle,
        9,
        [ref]$Rect,
        $RectSize
    )

    # Fallback auf GetWindowRect, falls DWM unerwartet nicht verfuegbar ist.
    if ($DwmResult -ne 0) {
        if (-not [FSCWindowCaptureV4]::GetWindowRect(
            $script:FoundHandle,
            [ref]$Rect
        )) {
            throw "Fenstergrenzen konnten nicht ermittelt werden."
        }
    }

    $Width  = $Rect.Right  - $Rect.Left
    $Height = $Rect.Bottom - $Rect.Top

    if (($Width -le 0) -or ($Height -le 0)) {
        throw "Ungueltige Fenstergroesse: ${Width}x${Height}"
    }

    if (-not (Test-Path -LiteralPath $LogPath)) {
        New-Item -ItemType Directory -Path $LogPath -Force | Out-Null
    }

    if (-not (Test-Path -LiteralPath $BaseFile)) {
        $OutputFile = $BaseFile
    }
    else {
        $TimeStamp  = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
        $OutputFile = Join-Path $LogPath "FSC-Complete_$TimeStamp.png"
    }

    $Bitmap = New-Object System.Drawing.Bitmap(
        $Width,
        $Height,
        [System.Drawing.Imaging.PixelFormat]::Format32bppArgb
    )

    $Graphics = [System.Drawing.Graphics]::FromImage($Bitmap)

    try {
        $Size = New-Object System.Drawing.Size($Width, $Height)

        $Graphics.CopyFromScreen(
            $Rect.Left,
            $Rect.Top,
            0,
            0,
            $Size,
            [System.Drawing.CopyPixelOperation]::SourceCopy
        )

        $Bitmap.Save(
            $OutputFile,
            [System.Drawing.Imaging.ImageFormat]::Png
        )
    }
    finally {
        $Graphics.Dispose()
        $Bitmap.Dispose()
    }

    Write-Host ""
    Write-Host "FSC Screenshot erfolgreich erstellt:"
    Write-Host $OutputFile
    Write-Host "Fenster:  $WindowTitle"
    Write-Host "Position: $($Rect.Left),$($Rect.Top)"
    Write-Host "Groesse:  $Width x $Height Pixel"

    exit 0
}
catch {
    Write-Host ""
    Write-Host "FSC Screenshot FEHLER:"
    Write-Host $_.Exception.Message
    exit 1
}
