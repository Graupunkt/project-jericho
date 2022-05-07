#########################################
### RESIZES CURRENT POWERSHELL WINDOW ###
<#<#<#<#<#<#<#<#<#<#<#<#<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER newXSize
Parameter description

.PARAMETER newYSize
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER newXSize
Parameter description

.PARAMETER newYSize
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER newXSize
Parameter description

.PARAMETER newYSize
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER newXSize
Parameter description

.PARAMETER newYSize
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER newXSize
Parameter description

.PARAMETER newYSize
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER newXSize
Parameter description

.PARAMETER newYSize
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER newXSize
Parameter description

.PARAMETER newYSize
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER newXSize
Parameter description

.PARAMETER newYSize
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER newXSize
Parameter description

.PARAMETER newYSize
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER newXSize
Parameter description

.PARAMETER newYSize
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER newXSize
Parameter description

.PARAMETER newYSize
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER newXSize
Parameter description

.PARAMETER newYSize
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER newXSize
Parameter description

.PARAMETER newYSize
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>#######################################

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
#MOVES CURRENT POWERSHELL WINDOW TO A SPECIFIC LOCATION
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
#KEEPS CURRENT POWERSHELL ALWAYS ON TOP    
function Keep-ConsoleOnTop {
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