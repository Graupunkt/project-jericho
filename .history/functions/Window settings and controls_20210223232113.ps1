#########################################
### RESIZES CURRENT POWERSHELL WINDOW ###
#########################################
Function Set-WindowSize{
    param(					#Input parameters
        [int]$newXSize,		#Input for horizontal size of the window
        [int]$newYSize		#Input for vertical size of the window
       )
    [Console]::WindowHeight=$newXSize # sets current window to new size in characters
    [Console]::WindowWidth=$newYSize  # sets current window to new size in lines
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
    [void] [System.Reflection.Assembly]::LoadWithPartialName("WindowsBase")
    [void] [System.Reflection.Assembly]::LoadWithPartialName("PresentationFramework")
    [void] [System.Reflection.Assembly]::LoadWithPartialName("PresentationCore")

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

function Set-ConsoleOpacity
{
    param(
        [ValidateRange(10,100)]
        [int]$Opacity
    )

    # Check if pinvoke type already exists, if not import the relevant functions
    try {
        $Win32Type = [Win32.WindowLayer]
    } catch {
        $Win32Type = Add-Type -MemberDefinition @'
            [DllImport("user32.dll")]
            public static extern int SetWindowLong(IntPtr hWnd, int nIndex, int dwNewLong);

            [DllImport("user32.dll")]
            public static extern int GetWindowLong(IntPtr hWnd, int nIndex);

            [DllImport("user32.dll")]
            public static extern bool SetLayeredWindowAttributes(IntPtr hwnd, uint crKey, byte bAlpha, uint dwFlags);
'@ -Name WindowLayer -Namespace Win32 -PassThru
    }

    # Calculate opacity value (0-255)
    $OpacityValue = [int]($Opacity * 2.56) - 1

    # Grab the host windows handle
    $ThisProcess = Get-Process -Id $PID
    $WindowHandle = $ThisProcess.MainWindowHandle

    # "Constants"
    $GwlExStyle  = -20;
    $WsExLayered = 0x80000;
    $LwaAlpha    = 0x2;

    if($Win32Type::GetWindowLong($WindowHandle,-20) -band $WsExLayered -ne $WsExLayered){
        # If Window isn't already marked "Layered", make it so
        [void]$Win32Type::SetWindowLong($WindowHandle,$GwlExStyle,$Win32Type::GetWindowLong($WindowHandle,$GwlExStyle) -bxor $WsExLayered)
    }

    # Set transparency
    [void]$Win32Type::SetLayeredWindowAttributes($WindowHandle,0,$OpacityValue,$LwaAlpha)
}

function Set-CrosshairOnScreen {
    param ($InputAngleHorizontal, $InputAngleVertical, $LocationName, $LocationDistance)
    #$InputAngleHorizontal = 348
    #$InputAngleVertical = 21

    #PRE REQUESTS
    Add-Type -AssemblyName System.Windows.Forms

    #DETERMINE FIELD OF VIEW
    $HorizontalViewAngle = 188 #115° fiedl of view in game settings
    $VerticalViewAngle = 42 * 2 #37° Up and 37° down

    #GET MAIN SCREEN RESOLTUION
    $MainScreenResolution = ([System.Windows.Forms.Screen]::AllScreens)[0]
    $MainScreenWidth = $MainScreenResolution.WorkingArea.Width
    $MainScreenHeight = $MainScreenResolution.WorkingArea.Height

    #CALCULATIONS
    # IF ANGLE IS ABOVE 180° CONVERT INTO NEGATIV ANGLE
    if ($InputAngleHorizontal -gt 180){$InputAngleHorizontal = (360 - $InputAngleHorizontal) * -1}
    $PixelsPerAngleX = $MainScreenWidth  / $HorizontalViewAngle
    $PixelsPerAngleY = $MainScreenHeight / $VerticalViewAngle

    $CenterScreenX = $MainScreenWidth  / 2
    $CenterScreenY = $MainScreenHeight / 2
    #Placement of the Crosshair, where 0,0 is the center of the screen
    #$CrosshairXPixels = ($InputAngleHorizontal * $PixelsPerAngleX) + $CenterScreenX
    #$CrosshairYPixels = ($InputAngleVertical * -1 * $PixelsPerAngleY) + $CenterScreenY
    $CrosshairXPixels = $CenterScreenX + ($InputAngleHorizontal * $PixelsPerAngleX)
    $CrosshairYPixels = $CenterScreenY + ($InputAngleVertical * -1 * $PixelsPerAngleY) 
    #$CrosshairXPixels
    #$CrosshairYPixels
    return $CrosshairXPixels, $CrosshairYPixels
    Start-process "Crosshair Overlay.exe" -ArgumentList "$CrosshairXPixels $CrosshairYPixels"
}