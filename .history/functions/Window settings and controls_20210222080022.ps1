#########################################
### RESIZES CURRENT POWERSHELL WINDOW ###
#########################################
Function Set-WindowSize{
    param(
        [int]$newXSize,
        [int]$newYSize
       )
    [Console]::WindowHeight=$newXSize
    [Console]::WindowWidth=$newYSize
    #[Console]::WindowHeight=15
    #[Console]::WindowWidth=$newYSize
}

##############################################################
### MOVES CURRENT POWERSHELL WINDOW TO A SPECIFIC LOCATION ###
##############################################################
function Move-Window {
    param(
     [int]$newX,
     [int]$newY
    )
    BEGIN {
    $signature = @'

[DllImport("user32.dll")]
public static extern bool MoveWindow(
    IntPtr hWnd,
    int X,
    int Y,
    int nWidth,
    int nHeight,
    bool bRepaint);

[DllImport("user32.dll")]
public static extern IntPtr GetForegroundWindow();

[DllImport("user32.dll")]
public static extern bool GetWindowRect(
    HandleRef hWnd,
    out RECT lpRect);

public struct RECT
{
    public int Left;        // x position of upper-left corner
    public int Top;         // y position of upper-left corner
    public int Right;       // x position of lower-right corner
    public int Bottom;      // y position of lower-right corner
}

'@
    
    Add-Type -MemberDefinition $signature -Name Wutils -Namespace WindowsUtils
    
    }
    PROCESS{
     $phandle = [WindowsUtils.Wutils]::GetForegroundWindow()
    
     $o = New-Object -TypeName System.Object
     $href = New-Object -TypeName System.RunTime.InteropServices.HandleRef -ArgumentList $o, $phandle
    
     $rct = New-Object WindowsUtils.Wutils+RECT
    
     [WindowsUtils.Wutils]::GetWindowRect($href, [ref]$rct)
     
     $width = $rct.Right - $rct.Left
     $height = 700
    <#
     $height = $rct.Bottom = $rct.Top
     
     $rct.Right
     $rct.Left
     $rct.Bottom
     $rct.Top
     
     $width
     $height
    #>
     [WindowsUtils.Wutils]::MoveWindow($phandle, $newX, $newY, $width, $height, $true)
    
    }
}

##############################################
### KEEPS CURRENT POWERSHELL ALWAYS ON TOP ###
############################################## 
function Set-ConsoleAlwaysOnTop {
$signature = @'
[DllImport("user32.dll")]
public static extern bool SetWindowPos(
    IntPtr hWnd,
    IntPtr hWndInsertAfter,
    int X,
    int Y,
    int cx,
    int cy,
    uint uFlags);
'@

    $type = Add-Type -MemberDefinition $signature -Name SetWindowPosition -Namespace SetWindowPos -Using System.Text -PassThru
    $handle = (Get-Process -id $Global:PID).MainWindowHandle
    $alwaysOnTop = New-Object -TypeName System.IntPtr -ArgumentList (-1)
    $type::SetWindowPos($handle, $alwaysOnTop, 0, 0, 0, 0, 0x0003)
}

Function Set-ConsoleBordersRemoval {
Add-Type –assemblyName WindowsBase
Add-Type –assemblyName PresentationFramework
Add-Type –assemblyName PresentationCore
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")

$code = @"
[DllImport("user32.dll", SetLastError = true)] 
public static extern int GetWindowLong(IntPtr hWnd, int nIndex); 
[DllImport("user32.dll")] 
public static extern int SetWindowLong(IntPtr hWnd, int nIndex, int dwNewLong);
"@
Add-Type -MemberDefinition $code -Name Win32Util -Namespace System

$WS_BORDER = 0x00800000
$WS_DLGFRAME = 0x00400000
$WS_CAPTION = $WS_BORDER -bor $WS_DLGFRAME
$WS_THICKFRAME = 0x00040000
$WS_MINIMIZE = 0x20000000
$WS_MAXIMIZE = 0x01000000
$WS_SYSMENU = 0x00080000
$WS_EX_DLGMODALFRAME = 0x00000001
$WS_EX_CLIENTEDGE = 0x00000200
$WS_EX_STATICEDGE = 0x00020000

$GWL_EXSTYLE = -20
$GWL_STYLE = -16

$MainWindowHandle = ([system.diagnostics.process]::GetCurrentProcess()).MainWindowHandle

$style = [System.Win32Util]::GetWindowLong($MainWindowHandle,$GWL_STYLE)
[System.Win32Util]::SetWindowLong($MainWindowHandle,$GWL_STYLE, $style -band -bnot($WS_CAPTION -bor $WS_THICKFRAME -bor $WS_MINIMIZE -bor $WS_MAXIMIZE -bor $WS_SYSMENU))
}