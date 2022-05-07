##################
### Parameters ###
##################
$debug = $false
$debug = $true 

#################
### FUNCTIONS ###
#################
 
Function Show-Frontend {
    $Form.Add_Shown({$Form.Activate()})
    [void] $Form.ShowDialog()
}

Function Set-WindowSize{
    param(
        [int]$newXSize,
        [int]$newYSize
       )
    [Console]::WindowHeight=$newXSize;
    [Console]::WindowWidth=$newYSize;
    #[Console]::WindowHeight=15
    #[Console]::WindowWidth=$newYSize
}

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

#ENABLE BULTIN POWERSHELL V% SUPPORT
if((Get-Host).Version.Major -eq "5"){
    $Powershellv5Legacy = $true
    $StartNavigation = $true
    Write-Host -ForegroundColor Red "Please install and run with powershell v7"
}

##################
### HASHTABLES ###
##################

$SystemData = @{
    Stanton = "ArcCorp; Crusader; Hurston; Microtech; Daymar; Yela; Cellin; Arial; Aberdeen; Ita; Magda; Clio; Euterpe; Calliope"
}

$QuantummarkerDataGroup = @{
    "ArcCorp" = "18587664739.856;-22151916920.3125;0"
    "Crusader" = "-18962176000;-2664959999.99999;0"
    "Hurston" = "12850457093;0;0"
    "Microtech" = "22462016306.0103;37185625645.8346;0"
    "Delamar" = "-10531703478.4293;18241438663.8409;0"
    "Lagrange - ARC-L1" = "16729134637.3846;-19937006924.8913;8076.625"
    "Lagrange - ARC-L2" = "20446718503.3901;-24367450990.706;8076.625"
    "Lagrange - ARC-L3" = "-25043446883.5029;14458841787.628;8076.625"
    "Lagrange - ARC-L4" = "28478354915.6557;5021502482.91174;8076.625"
    "Lagrange - ARC-L5" = "-9890422516.16967;-27173732225.14;8076.625"
    "Lagrange - CRU-L1" = "-17065957375.9999;-2398463999.99999;0"
    #"CRU-L2" = "0;0;0"
    "Lagrange - CRU-L3" = "18962176000;2664960000;0"
    "Lagrange - CRU-L4" = "-7173168639.99999;-17754204160;0"
    "Lagrange - CRU-L5" = "-11789008988.2602;15089246106.7638;0"
    "Lagrange - MIC-L1" = "20215808582.526974;33466996827.765518;767.452183"
    "Lagrange - HUR-L1" = "11565411328;0;0"
    "Lagrange - HUR-L2" = "14135502848;0;0"
    "Lagrange - HUR-L3" = "-12850457600;-1123.42272949218;0"
    "Lagrange - HUR-L4" = "6425228288;11128823808;0"
    "Lagrange - HUR-L5" = "6425227776;11128823808;0"
    #"Stanton-Star" = "136049.868;-1294427.422;2923345.358"
}

$RestStopData = @{
    "ARC-L1-Station" = "-1946.17884540557;-3262.39273452758;3147.92219238728"
    #"ARC-L2-Station" = "0;0;0"
    #"ARC-L3-Station" = "0;0;0"
    #"ARC-L4-Station" = "0;0;0"
    #"ARC-L5-Station" = "0;0;0"
    "CRU-L1-Station" = "-1279569.56942379;-2246919.81820762;-4195881.97904336"
    #"CRU-L2-Station" = "0;0;0"
    #"CRU-L3-Station" = "0;0;0"
    "CRU-L4-Station" = "5141933.59375;-4184999.51171875;3520767.02117919"
    "CRU-L5-Station" = "-1239225.44282674;521321607363224;278730649909377"
    "HUR-L1-Station" = "-1740752.25543975;-3262392.73452758;3147922.19238728"
    "HUR-L2-Station" = "-3496591.01748466;5084344.7265625;2490051.99572071"
    "HUR-L3-Station" = "3834139.85588029;-5216795.82729935;-4718270.97439393"
    "HUR-L4-Station" = "-1088098.63078594;2058350.3563404;1317405.78842163"
    "HUR-L5-Station" = "-6886053.22265625;-5700833.0078125;0448659.982681274"
    "MIC-L1-Station" = "-1946178.84540557;-3262392.73452758;3147922.19238728"
}


$PlanetData = @{
    #Planet     X Axis, Y-Axis, Z-Axsis, RotationSpeed, Rotation Adjustment, OrbitalMarkerRadius
    Daymar = "-18930539.54;-2610158.765;0;2.4800000;29.88665;430018"
}

<#
$HashtableOmRadius = @{
    "Delamar"   = "118890"   #Delamar   Delamar
    "Hurston"   = "1436000"  #Stanton1
    "Arial"     = "501528"   #Stanton1a
    "Aberdeen"  = "402696"   #Stanton1b
    "Magda"     = "494835"   #Stanton1c
    "Ita"       = "472445"   #Stanton1d
    "Crusader"  = "11733500" #Stanton2
    "Ceilin"    = "380520"   #Stanton2a
    "Daymar"    = "430018"   #Stanton2b
    "Yela"      = "455470"   #Stanton2c
    "ArcCorp"   = "1259000"  #Stanton3
    "Lyria"     = "328190"   #Stanton3a
    "Wala"      = "413047"   #Stanton3b
    "MicroTech" = "1439400"  #Stanton4
    "Calliope"  = "352238"   #Stanton4a
    "Clio"      = "489650"   #Stanton4b
    "Euterpe"   = "314050"   #Stanton4c
    }
#>

$PointsOfInterestInSpaceData = @{
    "Station - INS-Jericho" = "20196776944;33456387580;2895692"
    "ProcyonWreckSite" = "20196234302.339825;33456590828.301819;3063800.096146"
}

$PointsOfInterestOnPlanetsData = @{
    #Site                                   Planet, X-Coords, Y-Coords, Z-Coords
    "Daymar - Kudre Ore"                    = "Daymar;146.617154182309;-177.093294377514;-184.862263017951"
    "Daymar - Eager Flats Aid"              = "Daymar;200.545063565929;-104.917273995152;190.096594760393"
    "Daymar - Kudre Ore Mine"               = "Daymar;81.0076702389147;-280.683338081131;43.6486983371916"
    "Daymar - Shubin Mining SCD-1"          = "Daymar;126.025172040445;-149.58146894637;221.25334404046"
    "Daymar - Wolf Point Aid Shelter"       = "Daymar;-4.41978284451699;279.066633187614;95.7326590587272"
    "Daymar - Nuen Waste Management"        = "Daymar;-18.9432612462583;293.340930183354;25.4783997551309"
    "Daymar - ArcCorp Mining Area 141"      = "Daymar;-18.1669995110158;180.36216702036;-232.759931235018"
    "Daymar - Dunlow Ridge Aid Shelter"     = "Daymar;-51.8496231568687;280.931990013533;75.3312863846513"
    "Wreck - Javelin (Daymar)"              = "Daymar;102.055;267.619;-70.856"
}

#$PoisOnPlanetData = @{
#    #Site         Moon
#    "Kudre Ore Mine" = "Daymar"
#}

###############################
### PREREQUESTS, ASSEMBLIES ###
###############################
try {
    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")  
    Add-Type -assembly System.Windows.Forms
}
catch {
    Write-Warning -Message 'Unable to load required assemblies'
    return
}

#################
### FUNCTIONS ###
#################
#FUNCTION TO SHOW THE FRONTEND

# RUN SCRIPT WITH ADMIN PERMISSIONS
if(!$debug){
    #If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
    #    Start-Process powershell.exe "-noProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    #    Exit
    #}
}

$DataGroupDaymarRally = @(
    "Daymar - Rally 2952"    
    "Daymar - Rally 2952"    
    "Daymar - Rally 2952"
)

$DataGroupStanton7 = @(
    "Race1 - iron Brothers Bike Loop (Yela)"
    "Race2 - MicroTech Tundra Dash"
    "Race3 - Clio Challenge Cove"
    "Race4 - Nox Short Circuit (Wala)"
    "Race5 - Greycat Challenge (MT)"
    "Race6 - Magda Mountan Run"
    "Race7 - Lorville Loop"
)