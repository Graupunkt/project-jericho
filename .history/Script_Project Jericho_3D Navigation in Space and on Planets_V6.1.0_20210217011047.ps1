# Script to use CIG Coordinate System with Status Update
# IF PLANETARY POI IS OF COURSE CHECK PLANETARYCYCLE ANGLE!
##################
### Parameters ###
##################

#TODO
#OUTSOURCE POI INTO CSV FILES, SO USERS CAN ADD THEIR OWN POIS
#INTEGRATE AUTOMATED FRONTEND FROM RACING TRACKER

# BENNY HENGE AUDITING
# 12.02.2021 = -626.977;134.199;-1.816
# 16.02.2021 = -626.638;135.733;-1.819

$ErrorActionPreference = 'SilentlyContinue'
$debug = $false
#$debug = $true 

#CLEAR ALL VARIABLES FROM RPEVIOUS RUN
#if($debug){
#    $DefaultVariables = Get-Variable -Scope GLOBAL
#    $DefaultVariables += "debug"
#    $DefaultVariables += "ErrorActionPreference"
#    $ExcludeList = $DefaultVariables.Name -join ','
#    Get-Variable -Exclude $ExcludeList | Clear-Variable 
#    Remove-Module *
#    if($error){$error.Clear()}
#}

#SELECT CURRENT POI / DESTINATION FROM HASBTABLE LINE 22
$DistanceGreen = 1000      # Set Distance in meters when values should turn green (1km)
$DistanceYellow = 100000    # Set Distance in meters when values should turn yellow (100km)
$QMDistanceGreen = 100000    # QM Distance Green
$QMDistanceYellow = 1000000   # QM Distance Yellow

#GLOBAL PARAMETERS
$CustomCoordsProvided = $false  #set to false per default, in case not selected or script is run again 
$StartNavigation = $false
$script:PlanetaryPoi = $false  
$Powershellv5Legacy = $false   
$ClipboardContent = ""          #set empty clipboard content, in case of rerun
$FinalInstructions = @()
$script:ListOfToolsToStart = @()
$script:CurrentQuantumMarker = @()
$PreviousTime = 0
$PreviousXPosition = 1
$PreviousYPosition = 1
$PreviousZPosition = 1
#$CurrentXPosition = 0
#$CurrentYPosition = 0
#$CurrentZPosition = 0
$PreviousZPosition = 0
$ScriptLoopCount = 0
#Set-StrictMode -Version 2.0    #Display all errors while directly running script
Set-Location -Path $PSScriptRoot

#################
### FUNCTIONS ###
#################
function Test-KeyPress
{
    param
    (
        # submit the key you want to detect
        [Parameter(Mandatory)]
        [ConsoleKey]
        $Key,

        [System.ConsoleModifiers]
        $ModifierKey = 0
    )

    # reading keys is a blocking function. To "unblock" it,
    # let's first check if a key press is available at all:
    if ([Console]::KeyAvailable)
    {
        # since a key was pressed, ReadKey() now is NOT blocking
        # anymore because there is already a pressed key waiting
        # to be picked up
        # submit $true as an argument to consume the key. Else,
        # the pressed key would be echoed in the console window
        # note that ReadKey() returns a ConsoleKeyInfo object
        # the pressed key can be found in its property "Key":
        # write-host "1"
         $pressedKey = [Console]::ReadKey($true)

        # if the pressed key is the key we are after...
        $isPressedKey = $key -eq $pressedKey.Key
        if ($isPressedKey)
        {

            # if you want an EXACT match of modifier keys,
            # check for equality (-eq)
            $pressedKey.Modifiers -eq $ModifierKey
            # if you want to ensure that AT LEAST the specified
            # modifier keys were pressed, but you don't care
            # whether other modifier keys are also pressed, use
            # "binary and" (-band). If all bits are set, the result
            # is equal to the tested bit mask:
            # ($pressedKey.Modifiers -band $ModifierKey) -eq $ModifierKey
        }
        else
        {
            # else emit a short beep to let the user know that
            # a key was pressed that was not expected
            # Beep() takes the frequency in Hz and the beep
            # duration in milliseconds:
            #[Console]::Beep(1800, 200)

            # return $false
            $false
        }
    }
}

function CalcEbenenwinkel {
        # Ship Previous, Ship Current, Destination
        # A              B             D
        Param ($ax, $ay, $az, $bx, $by, $bz, $dx , $dy, $dz)
        
        #Ebene 1
        #Vector AB
        $abx = $bx - $ax
        $aby = $by - $ay
        $abz = $bz - $az
        
        #Vector AC (C = Nullpunkt Planet)
        $acx = 0 - $ax
        $acy = 0 - $ay
        $acz = 0 - $az        
        
        #Ebene 2
        #Vector AD
        $adx = $dx - $ax
        $ady = $dy - $ay
        $adz = $dz - $az
        
        #Vector AC siehe oben
        
        
        #normalenvector einer ebene:
        #n1_x = ab_y * ac_z - ab_z * ac_y
        #n1_y = ab_z * ac_x - ab_x * ac_z
        #n1_z = ab_x * ac_y - ab_y * ac_x
        
        $n1x = $aby * $acz - $abz * $acy
        $n1y = $abz * $acx - $abx * $acz
        $n1z = $abx * $acy - $aby * $acx
         # für 2. ebene: ab = ad und ac ist gleich
        $n2x = $ady * $acz - $adz * $acy
        $n2y = $adz * $acx - $adx * $acz
        $n2z = $adx * $acy - $ady * $acx
        
        #Vectorprodukt
        $vectorproduct = $n1x * $n2x + $n1y * $n2y + $n1z * $n2z
        
        #Laenge Normale n1 = wurzel aus ( x^2 + y^2 + z^2)
        $length_n1 = [math]::Sqrt($n1x * $n1x + $n1y *$n1y + $n1z * $n1z)
        
        #Laenge Normale n2
        $length_n2 = [math]::Sqrt($n2x * $n2x + $n2y *$n2y + $n2z * $n2z)
        
        $winkel = [math]::acos(($vectorproduct/($length_n1 * $length_n2)))
        $winkel_degree = ($winkel * 180)/[math]::pi
        Return $winkel_degree
}



Function Show-Frontend {
    $Form.Add_Shown({$Form.Activate()})
    [void] $Form.ShowDialog()
}

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

$QuantummarkerDataGroup = @{
    "ArcCorp" = "18587664739.856;-22151916920.3125;0"
    "Crusader" = "-18962176000;-2664959999.99999;0"
    "Hurston" = "12850457093;0;0"
    "Microtech" = "22462016306.0103;37185625645.8346;0"
    #"Delamar" = "-10531703478.4293;18241438663.8409;0"
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

                                                                    #Calibrated Planets = Daymar, Crusader, Yela, Cellin ### Hurston, Aberdeen, Ita, Magda, Arial, MT, Calliope, Euterpe, Clio ### ArCorp, Lyria, 
                                                                    # Wala rotation speed seems wrong, 73m diavation within 3mins
                                                                    ### 2500m = 0.1 ### 300m = 0.02 ### 3m = 0.0005
$ObjectContainerData = @{                                           #If x has a negative offset, raise Rotation Adjustment     OrbitalMarkerRadius is also used to determine if the player is within the object container for now
    #PLANETS              X Axis,               Y-Axis,             Z-Axsis,            RotationSpeed,  Rotation Adjustment,    OrbitalMarkerRadius System     InternalName
    Aberdeen            = "12905757636;         40955551;           0;                  2.5999999;      116.76300;              400328;             Stanton"   #Stanton1b
    Arial               = "12892673309;         -31476129;          0;                  5.5100002;      38.42410;               500030;             Stanton"   #Stanton1a
    ArcCorp             = "18587664740;         -22151916920;       0;                  3.1099999;      230.71025;              1144204;            Stanton"   #Stanton3
    Calliope            = "22398369308;         37168840679;        0;                  4.5900002;      212.31500;              352245;             Stanton"   #Stanton4a
    Cellin              = "-18987611119;        -2709009661;        0;                  4.4499998;      253.47200;              380530;             Stanton"   #Stanton2a
    Clio                = "22476728221;         37091020074;        0;                  3.2500000;      311.60695;              489664;             Stanton"   #Stanton4b
    Crusader            = "-18962176000;        -2664959999.99999;  0;                  1;              1;                      11733500;           Stanton"   #Stanton2
    Daymar              = "-18930539540;        -2610158765;        0;                  2.4800000;      29.96940;               430026;             Stanton"   #Stanton2b
    Euterpe             = "22488109736;         37081123565;        0;                  4.2800002;      269.01801;              314061;             Stanton"   #Stanton4c
    Hurston             = "12850457093;         0;                  0;                  2.4800000;      19.16560;               1427047;            Stanton"   #Stanton1
    Ita                 = "12830194716;         114913609;          0;                  4.8499999;      243.08110;              472454;             Stanton"   #Stanton1d
    Lyria               = "18703607172;         -22121650134;       0;                  6.4299998;      359.34150;              328203;             Stanton"   #Stanton3a
    Magda               = "12792686359;         -74464581;          0;                  1.9400001;      242.45525;              494840;             Stanton"   #Stanton1c
    MicroTech           = "22462016306.0103;    37185625645.8346;   0;                  4.1199999;      217.08090;              1427047;            Stanton"   #Stanton4
    Wala                = "18379649310;         -22000466768;       0;                  6.3200002;      135.50625;              413056;             Stanton"   #Stanton3b
    Yela                = "-19022916799;        -2613996152;        0;                  1.8200001;      217.64550;              455483;             Stanton"   #Stanton2c #X and Y values where split, so adjust by -90° from 217.57101 to127.57101
    StantonStar         = "136049870;           1294427400;         2923345368;         0;              0;                      2500000;            Stanton"   #Stanton
    #REST STOPS
    "ARC-L1-Station"    = "-1946178.84540557;   -3262392.73452758;  3147922.19238728    0;              0;                      100000              Stanton"
    "CRU-L1-Station"    = "-1279569569.42379;   -2246919818.20762;  -4195881979.04336   0;              0;                      100000              Stanton"
    "HUR-L1-Station"    = "-1740752255.43975;   -3262392734.52758;  3147922192.38728    0;              0;                      100000              Stanton"
    "HUR-L2-Station"    = "-3496591017.48466;   5084344726.5625;    2490051995.72071    0;              0;                      100000              Stanton"
    "HUR-L3-Station"    = "3834139855.88029;    -5216795827.29935;  -4718270974.39393   0;              0;                      100000              Stanton"
    "HUR-L4-Station"    = "-1088098630.78594;   2058350356.3404;    1317405788.42163    0;              0;                      100000              Stanton"
    "HUR-L5-Station"    = "-6886053222.65625;   -5700833007.8125;   0448659982.681274   0;              0;                      100000              Stanton"
    "MIC-L1-Station"    = "-1946178845.40557;   -3262392734.52758;  3147922192.38728    0;              0;                      100000              Stanton"
    #LAGRANGE POINTS
    "Lagrange - ARC-L1" = "16729134637.3846;    -19937006924.8913;  8076.625            0;              0;                      1000000             Stanton"
    "Lagrange - ARC-L2" = "20446718503.3901;    -24367450990.706;   8076.625            0;              0;                      1000000             Stanton"
    "Lagrange - ARC-L3" = "-25043446883.5029;   14458841787.628;    8076.625            0;              0;                      1000000             Stanton"
    "Lagrange - ARC-L4" = "28478354915.6557;    5021502482.91174;   8076.625            0;              0;                      1000000             Stanton"
    "Lagrange - ARC-L5" = "-9890422516.16967;   -27173732225.14;    8076.625            0;              0;                      1000000             Stanton"
    "Lagrange - CRU-L1" = "-17065957375.9999;   -2398463999.99999;  0                   0;              0;                      1000000             Stanton"
    "Lagrange - CRU-L3" = "18962176000;         2664960000;         0                   0;              0;                      1000000             Stanton"
    "Lagrange - CRU-L4" = "-7173168639.99999;   -17754204160;       0                   0;              0;                      1000000             Stanton"
    "Lagrange - CRU-L5" = "-11789008988.2602;   15089246106.7638;   0                   0;              0;                      1000000             Stanton"
    "Lagrange - MIC-L1" = "20215808582.526974;  33466996827.765518; 767.452183          0;              0;                      1000000             Stanton"
    "Lagrange - HUR-L1" = "11565411328;         0;                  0                   0;              0;                      1000000             Stanton"
    "Lagrange - HUR-L2" = "14135502848;         0;                  0                   0;              0;                      1000000             Stanton"
    "Lagrange - HUR-L3" = "-12850457600;        -1123.42272949218;  0                   0;              0;                      1000000             Stanton"
    "Lagrange - HUR-L4" = "6425228288;          11128823808;        0                   0;              0;                      1000000             Stanton"
    "Lagrange - HUR-L5" = "6425227776;          11128823808;        0                   0;              0;                      1000000             Stanton"
    #>
}

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
    "Bennyhenge (Yela)"                     = "Yela;-626.638;135.733;-1.819"
    "NT999 (Yela)"                          = "Yela;-205.857;-73.781;224.297"
    "Kosso (Yela)"                          = "Yela;-31.289;118.130;288.314"
    "JumpTown (Yela)"                       = "Yela;-240.325;15.776;-200.406"
    "Valalol Spot on Hurston"               = "Hurston;-553.467;-77.910;-828.317"
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

$DataGroupDestinations = @(
    "Station - INS-Jericho"
    "Wreck - Procyon"
    "Wreck - Javelin (Daymar)"
    "Daymar - Shubin Mining SCD-1"
    "Daymar - Eager Flats Aid"
    "Daymar - Wolf Point Aid Shelter"
    "Bennyhenge (Yela)"
    "Valalol Spot on Hurston"
    "NT999 (Yela)"
    "Kosso (Yela)"
    "JumpTown (Yela)"   
)

$DataGroupQuantummarker = @(
    "ArcCorp"
    "Crusader"
    "Hurston"
    "Microtech"
    "Delamar"
    "Lagrange - ARC-L1"
    "Lagrange - ARC-L2"
    "Lagrange - ARC-L3"
    "Lagrange - ARC-L4"
    "Lagrange - ARC-L5"
    "Lagrange - CRU-L1"
    "Lagrange - CRU-L2"
    "Lagrange - CRU-L3"
    "Lagrange - CRU-L4"
    "Lagrange - CRU-L5"
    "Lagrange - HUR-L1"
    "Lagrange - HUR-L2"
    "Lagrange - HUR-L3"
    "Lagrange - HUR-L4"
    "Lagrange - HUR-L5"
    "Lagrange - MIC-L1" 
)
function Create_DynamicFormMainframe{
    
    # LOAD PRERQUESTS FOR SYSTEM WINDOWS FORMS
    try {
        [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
        [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")  
        Add-Type -assembly System.Windows.Forms
    }
    catch {
        Write-Warning -Message 'Unable to load required assemblies'
        return
    }
    if(!$script:MainForm -eq $null){Clear-Variable -Name $script:MainForm}
    

    #GET ALL VARIABLES (ARRAYS) THAT CONTAIN DATAGROUP IN THEIR NAME 
    $AllDGVariables = Get-Variable -Include "DataGroup*"
    $FinalGroupsForForm = @()
    foreach ($DGVariable in $AllDGVariables){
        $FinalGroupsForForm += New-Object psobject -Property @{
            Groups = $DGVariable.Name.Replace("DataGroup","")
            Options = $DGVariable.Value
        }
    }
    #$FinalGroupsForForm | FT -Property Groups, Options

    #Count Groups
    $NumberFormGroups = $FinalGroupsForForm.Groups.Count

    #Count max Options
    [System.Collections.ArrayList]$ListOfOptions = @()
    foreach ($FormGroup in $FinalGroupsForForm){
        $ListOfOptions.add($FormGroup.Options.Count) | Out-Null
    }

    #DEFINE SIZE, BORDERS & CO
    $GroupBoxWidth = 250
    $GroupBoxSpacing = 20
    $OptionHeight = 24
    $OptionWidth = 220
    $OptionSpacer = 5
    $CustomWidth = 720
    $CustomHeight = 20
    $script:MainFormVerticalSpace = 150
    $script:MainFormVerticalBorder = 10
    $script:MainFormHorizontalBorder = 10


    $NumberFormMostOptions = $ListOfOptions | Sort-Object -Descending | Select-Object -First 1
    $script:MainFormWidth = $GroupBoxSpacing + $script:MainFormHorizontalBorder + $NumberFormGroups * $GroupBoxWidth + $CustomWidth
    $script:MainFormHeight = $script:MainFormVerticalSpace + $script:MainFormVerticalBorder + $NumberFormMostOptions * $OptionHeight + $CustomHeight
    #CHECK IF GROUPS OR OPTIONS EXCEED SCREENSIZE
    $ScreenResolution = [System.Windows.Forms.Screen]::AllScreens | Where-Object {$_.DeviceName -like "*DISPLAY1"}  #GET MAX SCREEN RESOLUTION
    $MaxFormSizeWidth = $ScreenResolution[0].WorkingArea.Width         #GET MAX WIDTH FROM PRIMARY SCREEN
    $MaxFormSizeHeight = $ScreenResolution[0].WorkingArea.Height       #GET MAX HEIGHT FROM PRIMARY SCREEN

    #IF FORM EXCEEDS SCREEN SIZE
    if ($script:MainFormWidth -gt $MaxFormSizeWidth -OR $script:MainFormHeight -gt $MaxFormSizeHeight){
        Write-Warning "Current form will exceed screen limits $($MaxFormSizeWidth):$($MaxFormSizeHeight) Form $($script:MainFormWidth):$($script:MainFormHeight)"
    }

    #Create Final Border
    $script:MainForm = New-Object System.Windows.Forms.Form                                    # Create new object
    $script:MainForm_Drawing_Size = New-Object System.Drawing.Size
    $script:MainForm_Drawing_Size.Width = $script:MainFormWidth
    $script:MainForm_Drawing_Size.Height = $script:MainFormHeight + $script:MainFormVerticalBorder + $script:MainFormVerticalBorder * 6
    $script:MainForm.Size = $script:MainForm_Drawing_Size
    $script:MainForm.Text = "Project Jericho"                                                  # Window Title
    $script:MainForm.StartPosition = 'CenterScreen'                                            # Position on Screen

    #DYNAMIC BOXES, FOR EACH DATAGROUP ONE BOX TO THE RIGHT
    $GroupBoxCounter = 0
    foreach ($Group in $FinalGroupsForForm){
        $GroupBoxCounter++
        $ListOfGroupOptions = $Group.Options.Count

        #SET GROUPBOX 
        $groupBox = New-Object System.Windows.Forms.GroupBox
        #SET POSITION OF GROUPBOX
        $GroupBox_Drawing_Size = New-Object System.Drawing.Size
        $GroupBox_Drawing_Size.Width = $GroupBoxSpacing + (($GroupBoxCounter -1) * $GroupBoxWidth)
        $GroupBox_Drawing_Size.Height = $script:MainFormVerticalSpace 
        $groupBox.Location = $GroupBox_Drawing_Size
        $groupBox.text = $Group.Groups
        $groupBox.Name = "GroupBox_$($Group.Groups)"
        #SET SIZE OF OF GROUPBOX 
        $GroupBox_Option_Drawing_Size = New-Object System.Drawing.Size
        $GroupBox_Option_Drawing_Size.Width = $OptionWidth + $GroupBoxSpacing
        $GroupBox_Option_Drawing_Size.Height = $GroupBoxSpacing + 2 * $OptionSpacer + ($OptionHeight) * $ListOfGroupOptions
        $groupBox.size = $GroupBox_Option_Drawing_Size
        $script:MainForm.Controls.Add($groupBox)

        #SET OPTIONS
        $OptionCounter = 0
        foreach ($Option in $Group.Options){
            $OptionCounter++
            $script:OptionBox = New-Object System.Windows.Forms.CheckBox
            if($Group.Groups -like "*Destinations"){$script:OptionBox = New-Object System.Windows.Forms.RadioButton}
            #SET POSITION OF OPTION
            $Option_Drawing_Size = New-Object System.Drawing.Size
            $Option_Drawing_Size.Width = $OptionSpacer
            $Option_Drawing_Size.Height = $OptionCounter * $OptionHeight
            $OptionBox.Location = $Option_Drawing_Size
            #SET SIZE OF OPTION
            $OptionBox.size = New-Object System.Drawing.Size($OptionWidth,$OptionHeight) 
            $OptionBox.Text = $Option
            $OptionBox.Name = "Option_$($Option)"

            if($OptionBox.Name -like "*OptionB2"){$OptionBox.ForeColor = [System.Drawing.Color]::Gray}
            $groupBox.Controls.Add($OptionBox) 
        }
    }

    # DEFINE RUN BUTTON
    $RunButton = New-Object System.Windows.Forms.Button 
    $RunButton.Location = New-Object System.Drawing.Size(30,10) 
    $RunButton.Size = New-Object System.Drawing.Size(80,40) 
    $RunButton.Text = "RUN" 
    $MainForm.Controls.Add($RunButton)
    $RunButton.Add_Click({
        $script:StartNavigation = $true
        $MainForm.Close()
    })

    # DEFINE LOAD BUTTON, TO GIVE PREREQUESTS
    $LoadButton = New-Object System.Windows.Forms.Button 
    $LoadButton.Location = New-Object System.Drawing.Size(130,10) 
    $LoadButton.Size = New-Object System.Drawing.Size(80,40) 
    $LoadButton.Text = "LOAD" 
    $MainForm.Controls.Add($LoadButton)
    $LoadButton.Add_Click({
        foreach ($Box in $script:MainForm.Controls){
            foreach ($Checkbox in $Box.Controls){
                if($Checkbox.Name -like "*Lagrange - ARC-L3"){$Checkbox.Checked = $true;$Checkbox.ForeColor  = [System.Drawing.Color]::Green}
                if($Checkbox.Name -like "*Lagrange - MIC-L1"){$Checkbox.Checked = $true;$Checkbox.ForeColor  = [System.Drawing.Color]::Green}
                if($Checkbox.Name -like "*Hurston") {$Checkbox.Checked = $true;$Checkbox.ForeColor  = [System.Drawing.Color]::Green}
            }
        }
    })

    ### PROGRESS BAR ###
    # https://powershell.anovelidea.org/powershell/windows-forms/
    $StatusStrip = New-Object System.Windows.Forms.StatusStrip
    $StatusStrip.Name = 'StatusStrip'
    #$StatusStrip.AutoSize = $true
    $StatusStrip.AutoSize = $false
    $StatusStrip.
    $StatusStrip.Left = 0
    $StatusStrip.Visible = $true
    $StatusStrip.Enabled = $true
    $StatusStrip.Dock = [System.Windows.Forms.DockStyle]::Bottom
    $StatusStrip.Anchor = [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Left
    #$StatusStrip.LayoutStyle = [System.Windows.Forms.ToolStripLayoutStyle]::Table
    $StatusStrip.LayoutStyle = [System.Windows.Forms.ToolStripLayoutStyle]::HorizontalStackWithOverflow
    $StatusStrip.BorderSides = "Left"
    $StatusStrip.BorderStyle = "Etched"

    $Copyright = [System.Windows.Forms.ToolStripLabel]::new()
    $Copyright.Name = 'Copyright'
    $Copyright.Text = "© [VORA] Graupunkt, [DSC] Murphy, [IFE] Xabdiben"
    $Copyright.Width = 200
    $Copyright.Visible = $true

    $Progress = [System.Windows.Forms.ToolStripLabel]::new()
    $Progress.Name = 'Progress'
    $Progress.Text = $null
    $Progress.Text = "                                                                                              "
    $Progress.Width = 50
    $Progress.Visible = $true

    $ProgressBar = [System.Windows.Forms.ToolStripProgressBar]::new()
    $ProgressBar.Name = 'ProgressBar'
    $ProgressBar.Width = 50
    $ProgressBar.Visible = $false

    $SupportInfo = [System.Windows.Forms.ToolStripLabel]::new()
    $SupportInfo.Name = 'Copyright'
    $SupportInfo.Text = 'Support and Updates (Deutsch / English) @'
    $SupportInfo.Width = 400
    $SupportInfo.Visible = $true

    $SupportLink = [System.Windows.Forms.ToolStripLabel]::new()
    $SupportLink.Name = 'Support'
    $SupportLink.IsLink = $true
    $SupportLink.LinkBehavior = System.Windows.Forms.LinkBehavior.AlwaysUnderline
    $SupportLink.Text = "https://www.guilded.gg/projectjericho"
    $SupportLink.Tag = "https://www.guilded.gg/projectjericho"
    $SupportLink.Width = 50
    $SupportLink.Visible = $true
    $SupportLink.add_Click={
        [System.Diagnostics.Process]::Start($SupportLink.Text)
    }

    $StatusStrip.Items.AddRange(
        [System.Windows.Forms.ToolStripItem[]]@(
            $Copyright,
            $Progress,
            $ProgressBar,
            $SupportInfo,
            $SupportLink
        )
    )
    $MainForm.Controls.Add($StatusStrip) 

    ##################
    ### LEGEND BOX ###
    ##################
    $Legend = New-Object System.Windows.Forms.GroupBox
    $Legend.Location = New-Object System.Drawing.Size(240,5) 
    $Legend.size = New-Object System.Drawing.Size(250,120) 
    $Legend.text = "Legend" 
    $MainForm.Controls.Add($Legend)
    # LEGEND - FIRST ENTRY
    $Legend1 = New-Object System.Windows.Forms.Label 
    $Legend1.Location = new-object System.Drawing.Point(21,20) 
    $Legend1.size = New-Object System.Drawing.Size(100,20) 
    $Legend1.ForeColor = [System.Drawing.Color]::Gray
    $Legend1.Text = "No coordinates yet" 
    $Legend.Controls.Add($Legend1) 
    # 
    $Legend2 = New-Object System.Windows.Forms.Label 
    $Legend2.Location = new-object System.Drawing.Point(21,38) 
    $Legend2.size = New-Object System.Drawing.Size(190,20) 
    $Legend2.ForeColor = [System.Drawing.Color]::Blue
    $Legend2.Text = "QuantumMarker (starting point)" 
    $Legend.Controls.Add($Legend2)
    # 
    $Legend3 = New-Object System.Windows.Forms.Label 
    $Legend3.Location = new-object System.Drawing.Point(21,56) 
    $Legend3.size = New-Object System.Drawing.Size(190,20) 
    $Legend3.ForeColor = [System.Drawing.Color]::Green
    $Legend3.Text = "QuantumMarker (suggested)" 
    $Legend.Controls.Add($Legend3) 
    # 
    $Legend4 = New-Object System.Windows.Forms.CheckBox 
    $Legend4.Location = new-object System.Drawing.Point(5,74) 
    $Legend4.size = New-Object System.Drawing.Size(170,20) 
    $Legend4.Checked = $true 
    #$Legend4.Enabled = $false 
    $Legend4.AutoCheck = $false 
    $Legend4.Text = "QuantumMarker (selected)" 
    $Legend.Controls.Add($Legend4) 

    #################
    ### LIMIT BOX ###
    #################
    $Limits = New-Object System.Windows.Forms.GroupBox
    $Limits.Location = New-Object System.Drawing.Size(760,5) 
    $Limits.size = New-Object System.Drawing.Size(250,120) 
    $Limits.text = "Limits (meters)" 
    $MainForm.Controls.Add($Limits) 

    $LabelDistanceGreen = New-Object System.Windows.Forms.Label 
    $LabelDistanceGreen.Location = new-object System.Drawing.Point(5,28) 
    $LabelDistanceGreen.size = New-Object System.Drawing.Size(100,15) 
    $LabelDistanceGreen.ForeColor = [System.Drawing.Color]::Green
    $LabelDistanceGreen.Text = "Distance Green" 
    $Limits.Controls.Add($LabelDistanceGreen)

    $LimitDistanceGreen = New-Object System.Windows.Forms.TextBox 
    $LimitDistanceGreen.Location = new-object System.Drawing.Point(150,25) 
    $LimitDistanceGreen.size = New-Object System.Drawing.Size(70,20)  
    $LimitDistanceGreen.ForeColor = [System.Drawing.Color]::Gray
    $LimitDistanceGreen.Text = "{0:n0}" -f [Double]$DistanceGreen
    $LimitDistanceGreen.TextAlign = "Right"
    $Limits.Controls.Add($LimitDistanceGreen) 

    $LabelDistanceYellow = New-Object System.Windows.Forms.Label 
    $LabelDistanceYellow.Location = new-object System.Drawing.Point(5,48) 
    $LabelDistanceYellow.size = New-Object System.Drawing.Size(100,15) 
    $LabelDistanceYellow.ForeColor = [System.Drawing.Color]::Orange
    $LabelDistanceYellow.Text = "Distance Yellow" 
    $Limits.Controls.Add($LabelDistanceYellow)

    $LimitDistanceYellow = New-Object System.Windows.Forms.TextBox 
    $LimitDistanceYellow.Location = new-object System.Drawing.Point(150,45) 
    $LimitDistanceYellow.size = New-Object System.Drawing.Size(70,10) 
    $LimitDistanceYellow.TextAlign = "Right" 
    $LimitDistanceYellow.ForeColor = [System.Drawing.Color]::Gray
    $LimitDistanceYellow.Text = "{0:n0}" -f [Double]$DistanceYellow 
    $Limits.Controls.Add($LimitDistanceYellow) 

    $LabelQuantumGreen = New-Object System.Windows.Forms.Label 
    $LabelQuantumGreen.Location = new-object System.Drawing.Point(5,68) 
    $LabelQuantumGreen.size = New-Object System.Drawing.Size(100,15) 
    $LabelQuantumGreen.ForeColor = [System.Drawing.Color]::Green
    $LabelQuantumGreen.Text = "QuantumMarker Green" 
    $Limits.Controls.Add($LabelQuantumGreen)

    $LimitQuantumGreen = New-Object System.Windows.Forms.TextBox 
    $LimitQuantumGreen.Location = new-object System.Drawing.Point(150,65) 
    $LimitQuantumGreen.size = New-Object System.Drawing.Size(70,10) 
    $LimitQuantumGreen.TextAlign = "Right" 
    $LimitQuantumGreen.ForeColor = [System.Drawing.Color]::Gray
    $LimitQuantumGreen.Text = "{0:n0}" -f [Double]$QMDistanceGreen
    $Limits.Controls.Add($LimitQuantumGreen) 

    $LabelQuantumYellow = New-Object System.Windows.Forms.Label 
    $LabelQuantumYellow.Location = new-object System.Drawing.Point(5,88) 
    $LabelQuantumYellow.size = New-Object System.Drawing.Size(100,15) 
    $LabelQuantumYellow.ForeColor = [System.Drawing.Color]::Orange
    $LabelQuantumYellow.Text = "QuantumMarker Yellow" 
    $Limits.Controls.Add($LabelQuantumYellow)

    $LimitQuantumYellow = New-Object System.Windows.Forms.TextBox 
    $LimitQuantumYellow.Location = new-object System.Drawing.Point(150,85) 
    $LimitQuantumYellow.size = New-Object System.Drawing.Size(70,10) 
    $LimitQuantumYellow.TextAlign = "Right" 
    $LimitQuantumYellow.ForeColor = [System.Drawing.Color]::Gray
    $LimitQuantumYellow.Text = "{0:n0}" -f [Double]$QMDistanceYellow
    $Limits.Controls.Add($LimitQuantumYellow) 

    #####################
    ### 3RD PARTY BOX ###
    #####################
    $3rdPartyBox = New-Object System.Windows.Forms.GroupBox
    $3rdPartyBox.Location = New-Object System.Drawing.Size(1020,5) 
    $3rdPartyBox.size = New-Object System.Drawing.Size(200,120) 
    $3rdPartyBox.text = "3rd Party Tools Autostart" 
    $MainForm.Controls.Add($3rdPartyBox) 

    # First Tool
    $ToolShowLocation = New-Object System.Windows.Forms.CheckBox
    $ToolShowLocation.Location = new-object System.Drawing.Point(5,20) 
    $ToolShowLocation.size = New-Object System.Drawing.Size(185,20)
    $ToolShowLocation.Text = "Update Location Hotkey" 
    $3rdPartyBox.Controls.Add($ToolShowLocation) 

    # Second Tool
    $ToolAntilogoff = New-Object System.Windows.Forms.CheckBox
    $ToolAntilogoff.Location = new-object System.Drawing.Point(5,40) 
    $ToolAntilogoff.size = New-Object System.Drawing.Size(185,20)
    $ToolAntilogoff.Text = "Anti-Logoff" 
    $3rdPartyBox.Controls.Add($ToolAntilogoff) 

    # Third Tool
    $ToolShowOnTop = New-Object System.Windows.Forms.CheckBox
    $ToolShowOnTop.Location = new-object System.Drawing.Point(5,60) 
    $ToolShowOnTop.size = New-Object System.Drawing.Size(185,20)
    $ToolShowOnTop.Text = "ShowOnTop" 
    $3rdPartyBox.Controls.Add($ToolShowOnTop) 

    # Foruth Tool
    $ToolAutorun = New-Object System.Windows.Forms.CheckBox
    $ToolAutorun.Location = new-object System.Drawing.Point(5,80) 
    $ToolAutorun.size = New-Object System.Drawing.Size(185,20)
    $ToolAutorun.Text = "AutoRun Toggle" 
    $3rdPartyBox.Controls.Add($ToolAutorun) 

    ##########################
    ### CUSTOM COORDINATES ###
    ##########################
    $TextBox = New-Object System.Windows.Forms.GroupBox
    $TextBox.Location = New-Object System.Drawing.Size(500,5) 
    $TextBox.size = New-Object System.Drawing.Size(250,120) 
    $TextBox.text = "    Stanton Coordinates:" 
    $MainForm.Controls.Add($TextBox) 

    # BOX3 - FIRST RADIO BUTTON
    $CustomButton = New-Object System.Windows.Forms.CheckBox 
    $CustomButton.Location = new-object System.Drawing.Point(3,1) 
    $CustomButton.size = New-Object System.Drawing.Size(15,15)
    #$CustomButton.Checked = $true 
    $TextBox.Controls.Add($CustomButton) 

    # X LABEL
    $TextBoxLabel = New-Object System.Windows.Forms.Label
    $TextBoxLabel.Location = new-object System.Drawing.Point(5,28)
    $TextBoxLabel.size = New-Object System.Drawing.Size(15,15) 
    $TextBoxLabel.Text = "X ="
    $TextBox.Controls.Add($TextBoxLabel) 

    # X INPUT
    $TextBoxX = New-Object System.Windows.Forms.TextBox 
    $TextBoxX.Location = new-object System.Drawing.Point(20,25) 
    $TextBoxX.size = New-Object System.Drawing.Size(170,20)  
    $TextBox.Controls.Add($TextBoxX) 

    # Y LABEL
    $TextBoxLabel = New-Object System.Windows.Forms.Label
    $TextBoxLabel.Location = new-object System.Drawing.Point(5,48)
    $TextBoxLabel.size = New-Object System.Drawing.Size(15,15) 
    $TextBoxLabel.Text = "Y ="
    $TextBox.Controls.Add($TextBoxLabel) 
    # Y INPUT
    $TextBoxY = New-Object System.Windows.Forms.TextBox 
    $TextBoxY.Location = new-object System.Drawing.Point(20,45) 
    $TextBoxY.size = New-Object System.Drawing.Size(170,20)  
    $TextBox.Controls.Add($TextBoxY) 

    # Z LABEL
    $TextBoxLabel = New-Object System.Windows.Forms.Label
    $TextBoxLabel.Location = new-object System.Drawing.Point(5,68)
    $TextBoxLabel.size = New-Object System.Drawing.Size(15,15) 
    $TextBoxLabel.Text = "Z ="
    $TextBox.Controls.Add($TextBoxLabel) 
    # Z INPUT
    $TextBoxZ = New-Object System.Windows.Forms.TextBox 
    $TextBoxZ.Location = new-object System.Drawing.Point(20,65) 
    $TextBoxZ.size = New-Object System.Drawing.Size(170,20)  
    $TextBox.Controls.Add($TextBoxZ) 

    if ($ToolAntilogoff.Checked   -eq $true){$script:ListOfToolsToStart += "ToolAntilogoff"}
    if ($ToolShowLocation.Checked -eq $true){$script:ListOfToolsToStart += "ToolShowLocation"}
    if ($ToolShowOnTop.Checked    -eq $true){$script:ListOfToolsToStart += "ToolShowOnTop"}
    if ($ToolAutorun.Checked      -eq $true){$script:ListOfToolsToStart += "ToolAutorun"}

    $script:MainForm.ShowDialog()| Out-Null

}
Create_DynamicFormMainframe

#DEFINE VARIABLES AND ACTIONS FOR EACH BUTTON
foreach ($Box in $script:MainForm.Controls){
    if($Box.Name -like "*Destinations"){
        foreach ($Checkbox in $Box.Controls){
            #if($Checkbox.Name -like "*Jericho" -AND $Checkbox.Checked){$script:CurrentDestination = $Checkbox.Name.replace('Option_',"")}
            if($Checkbox.Checked){$script:CurrentDestination = $Checkbox.Name.replace('Option_',"")}
            if($Checkbox.Name -like "*Daymar*" -AND $Checkbox.Checked){$script:PlanetaryPoi = $true}
            if($Checkbox.Name -like "*Yela*" -AND $Checkbox.Checked){$script:PlanetaryPoi = $true}
            if($Checkbox.Name -like "*Hurston*" -AND $Checkbox.Checked){$script:PlanetaryPoi = $true}
            #if($Checkbox.Name -like "*Jericho" -AND $Checkbox.Checked){$script:CurrentDestination = "INS-Jericho"}
        }
    }
    if($Box.Name -like "*QuantumMarker"){
        foreach ($Checkbox in $Box.Controls){
            if($Checkbox.Checked){$script:CurrentQuantumMarker += $Checkbox.Name.replace('Option_',"")}
            #if($Checkbox.Name -like "*Jericho" -AND $Checkbox.Checked){$script:CurrentDestination = "INS-Jericho"}
        }
    }
}



###################
### MAIN SCRIPT ###
###################
#DETERMINE SCRIPT PATH WITHIN VSCODE, iSE OR POWERSHELL
if($env:TERM_PROGRAM -eq "vscode"){$script:ScriptDir = $psEditor.GetEditorContext().CurrentFile.Path -replace '[^\\]+$'}
if($psISE){$script:ScriptDir = Split-Path -Path $psISE.CurrentFile.FullPath}
if((Get-Host).Version.Major -gt "5"){$script:ScriptDir = $PSScriptRoot}
else{$script:ScriptDir = $PSScriptRoot}



#START 3RD PARTY TOOLS
foreach ($Tool in $script:ListOfToolsToStart){
    switch ($Tool){
        "ToolAntiLogoff" {$3rdPartyFileName = "Autoit Scripts\AntiLogoffScript_V2.ahk"}
        "ToolShowLocation" {$3rdPartyFileName = "Showlocation_Hotkey ALT-R or LEFTCTRL+ALT_RunAsAdmin.exe"}
        "ToolShowOnTop" {$3rdPartyFileName = "WindowTop.exe"}
        "ToolAutorun" {$3rdPartyFileName = "Autoit Scripts\autorun.ahk"}
    }
    if(get-process | Where-Object {$_.path -like "*$3rdPartyFileName"} -ea SilentlyContinue){
        #Process is already running
    }
    else{Start-process -FilePath "$ScriptDir\$3rdPartyFileName"}
}


if ($ScriptLoopCount -eq 0){
    #$ClipboardContent = ("Coordinates: X:0 y:0 z:0").split(":").Split(" ")
    #Add-Type -AssemblyName System.Windows.Forms
    $ScreenResolution = [System.Windows.Forms.Screen]::AllScreens
    $WindowSizeY = 30
    $WindowSizeX = 85
    $MaxX = $ScreenResolution[0].WorkingArea.Width -720 
    #$MaxY = $ScreenResolution[0].WorkingArea.Height
    Move-Window $MaxX 5 | Out-Null
    Set-WindowSize $WindowSizeY $WindowSizeX
    Keep-ConsoleOnTop | Out-Null
}

#CLEAR OLD VARIABLES
$SelectedDestination = @{}

if($debug){Write-Host "Start Navigation $StartNavigation"}
#CHECK CLIPBOARD FOR NEW VALUES 
while($StartNavigation) {
    # Checks for new clipboard conents every 1 Second
    #Diavation depends on script sleep time, this 1ms delay causes a diavation of +/- 3m at OM3 on Daymar
    if(!$debug){Start-Sleep -Milliseconds 1}

    ### KEY TO SAVE CURRENT COORDINATES TO TEXTFILE ###
    # CODE BY BIGCHEESE
    $pressed = Test-KeyPress -Key s -ModifierKey 'Shift'
    if ($pressed) { 
        $PoiName = Read-Host -Prompt 'Input the name of the POI: '
        $SystemName = Read-Host -Prompt 'Input the Systemname your currently in: '
        #IF ON A PLANET
        if($script:CurrentDetectedObjectContainer){$line_to_write = $PoiName + ';' + $CurrentDetectedObjectContainer + ';' + $CurrentPlanetaryXCoord + ';' +  $CurrentPlanetaryYCoord + ';' + $CurrentPlanetaryZCoord}
        if($script:CurrentDetectedObjectContainer){$line_to_write = "$SystemName;$CurrentDetectedObjectContainer;Type;$PoiName;$CurrentPlanetaryXCoord;$CurrentPlanetaryYCoord;$CurrentPlanetaryZCoord"}
        #IF IN SPACE
        else {$line_to_write = $NewName + ';in Space;' + $CurrentXPosition + ';' +  $CurrentYPosition + ';' + $CurrentZPosition}
        #WRITE CURRENT LINES TO TEXTFILE
        $line_to_write  >> 'own_pois.csv' 
        Write-Host "... saved to own_pois.csv"
    }

    #USE CUSTOM §D SPACE COORDINATES IF PROVIDED
    if($script:CustomCoordsProvided){
        if($TextBoxX.Text -and $TextBoxY.Text -and $TextBoxZ.Text){
            #SET DESTINATION TO CUSTOM COORDINATES
            $SelectedDestination = @{"Custom" = "$($TextBoxX.Text);$($TextBoxY.Text);$($TextBoxZ.Text)"}
            $DestCoordData = $SelectedDestination.Value -Split ";"
            $DestCoordDataX = $TextBoxX.Text
            $DestCoordDataY = $TextBoxY.Text
            $DestCoordDataZ = $TextBoxZ.Text
        }
        else{
            #IF COORDINATES ARE ENTERED WRONG
            $ErrorMessageCustomCoords = "Custom coordinates are missing correct values"
            Write-Host -ForegroundColor Red $ErrorMessageCustomCoords
            $LiveResults.Text = $ErrorMessageCustomCoords
            Show-Frontend
        }

    }

    #################################################
    ### POI ON ROTATING OBJECT CONTAINER, PLANETS ###
    #################################################
    elseif($script:PlanetaryPoi){
        #GET UTC SERVER TIME, ROUND MILLISECONDS IN 166ms steps (6 to 1 second conversion)

        $TimeModifier = 10 # tested 4, 5, 10, 20, 40, 50 100, 166, 250, 500, 1000 Best so Far 10 with Round, Even Better was truncate with 166
        #$DateTime = [DateTime](Get-Date -Millisecond ([math]::Round((Get-Date).Millisecond / $TimeModifier,0) * $TimeModifier))
        #$DateTime = [DateTime](Get-Date -Millisecond ([math]::Truncate((Get-Date).Millisecond / $TimeModifier) * $TimeModifier))
        $DateTime = [DateTime](Get-Date)
        $UTCServerTime = $DateTime.ToUniversalTime() 
        #$DateTime | fl *
        #$UTCServerTime | fl *
       
        #$SimulationServerStartTime = [DateTime] "01.01.2950 00:00:00"                                                # SET STARTTIME SIMULATION STARCITIZEN
        $SimulationUTCStartTime = [DateTime]"01.01.2020 00:00:00"                                                    # SET STARTTIME SIMULATION UTC
        $ElapsedUTCTimeSinceSimulationStart = New-Timespan -End $UTCServerTime -Start $SimulationUTCStartTime     # GET ELPASED TIME BETWEEN SIMULATION TIME AND CURRENT TIME
        #if ($debug){$ElapsedUTCTimeSinceSimulationStart = $UTCServerTime - $SimulationUTCStartTime}
        #$SimulationServerTime = $SimulationServerStartTime + ($ElapsedUTCTimeSinceSimulationStart * 6)            # GET ELPASED TIME SERVER SIMULATION
        #$ElapsedSimulationTimeSinceSimulationStart = New-Timespan -End $SimulationServerTime -Start $SimulationServerStartTime

        #GET ORBITAL COORDINATES
        $SelectedDestination = $PointsOfInterestOnPlanetsData.GetEnumerator() | Where-Object { $_.Key -eq $script:CurrentDestination }
        $PoiCoordData = $SelectedDestination.Value -Split ";"
        $PoiCoordDataPlanet = $PoiCoordData[0]
        $PoiCoordDataX = $PoiCoordData[1]
        $PoiCoordDataY = $PoiCoordData[2]
        $PoiCoordDataZ = $PoiCoordData[3]

        #GET THE SITES PLANET
        #$CurrentPlanet = ($PoisOnPlanetData.GetEnumerator() | Where-Object { $_.Key -eq $script:CurrentDestination }).Value



        #GET THE PLANETS COORDS IN STANTON
        #$SelectedPlanet = $ObjectContainerData.GetEnumerator() | Where-Object { $_.Key -eq $CurrentPlanet}
        $SelectedPlanet = $ObjectContainerData.GetEnumerator() | Where-Object { $_.Key -eq $PoiCoordDataPlanet}
        #$SelectedPlanet = $ObjectContainerData.GetEnumerator() | Where-Object { $_.Key -eq $script:CurrentDetectedObjectContainer}
        $PlanetDataParsed = $SelectedPlanet.Value -Split ";"
        $PlanetCoordDataX = $PlanetDataParsed[0]/1000
        $PlanetCoordDataY = $PlanetDataParsed[1]/1000
        $PlanetCoordDataZ = $PlanetDataParsed[2]/1000
        $PlanetRotationSpeed = $PlanetDataParsed[3]
        $PlanetRotationStart = $PlanetDataParsed[4]
        $PlanetOMRadius = $PlanetDataParsed[5]

  
        #FORMULA TO CALCULATE THE CURRENT STANTON X, Y, Z COORDNIATES FROM ROTATING PLANET
        #GET CURRENT ROTATION FROM ANGLE
        $LengthOfDayDecimal = [double]$PlanetRotationSpeed * 3600 / 86400  #CORRECT
        $JulianDate = $ElapsedUTCTimeSinceSimulationStart.TotalDays        #CORRECT
        $TotalCycles = $JulianDate / $LengthOfDayDecimal                   #CORRECT
        $CurrentCycleDez = $TotalCycles%1
        $CurrentCycleDeg = $CurrentCycleDez * 360
        #if (($CurrentCycleDeg + $PlanetRotationStart) -gt 360){$CurrentCycleAngle = 360 - [double]$PlanetRotationStart + [double]$CurrentCycleDeg}
        if (($CurrentCycleDeg + $PlanetRotationStart) -lt 360){$CurrentCycleAngle = [double]$PlanetRotationStart + [double]$CurrentCycleDeg}

        #CALCULATE THE RESULTING X Y COORDS 
        # /180 * PI = Conversion from 
        $PoiRotationValueX = [double]$PoiCoordDataX * ([math]::Cos($CurrentCycleAngle/180*[System.Math]::PI)) - [double]$PoiCoordDataY * ([math]::Sin($CurrentCycleAngle/180*[System.Math]::PI))
        $PoiRotationValueY = [double]$PoiCoordDataX * ([math]::Sin($CurrentCycleAngle/180*[System.Math]::PI)) + [double]$PoiCoordDataY * ([math]::Cos($CurrentCycleAngle/180*[System.Math]::PI))

        #SUBTRACT POI COORDS FROM PLANET COORDS
        $DestCoordDataX = ([double]$PlanetCoordDataX + $PoiRotationValueX) * 1000
        $DestCoordDataY = ([double]$PlanetCoordDataY + $PoiRotationValueY) * 1000
        $DestCoordDataZ = ([double]$PlanetCoordDataZ + $PoiCoordDataZ) * 1000

        $FinalPoiCoords = @{}
        $FinalPoiCoords = @{
            "$script:CurrentDestination" = "$DestCoordDataX;$DestCoordDataY;$DestCoordDataZ"
        }
        
        $FinalPlanetCoords = @{}
        $FinalPlanetDataX = [double]$PlanetCoordDataX * 1000
        $FinalPlanetDataY = [double]$PlanetCoordDataY * 1000
        $FinalPlanetDataZ = [double]$PlanetCoordDataZ * 1000
        $FinalPlanetCoords = @{
            "$CurrentPlanet" = "$FinalPlanetDataX;$FinalPlanetDataY;$FinalPlanetDataZ"
        }
        #ToDo
        #RE CALCULATE PREIOUS VALUES BASED ON ROTATION
        #CURRENTLY COURSE DIAVATION SHOWS 35° WHEN HEADING DIRECTLY TO THE TARGET. THIS IS CAUSED BY THE ROTATION AND THE PREVIOUS LOCATION NOT RECALCULATE ON ROTATIO

    }
    #GET DESTINATION COORDINATES FROM HASTABLES, FILTER FOR CURRENT DESTINATION
    else{
        #SELECT DESTINATION FROM EXISTING TABLE
        $SelectedDestination = $PointsOfInterestInSpaceData.GetEnumerator() | Where-Object { $_.Key -eq $script:CurrentDestination }
        $DestCoordData = $SelectedDestination.Value -Split ";"
        $DestCoordDataX = $DestCoordData[0]
        $DestCoordDataY = $DestCoordData[1]
        $DestCoordDataZ = $DestCoordData[2]
    }
    
    #START SCRIPT WITH COORDS 0,0,0 to Get all Values displayed
    if ($ScriptLoopCount -ge 1){
        $ClipboardContent = (Get-Clipboard).split(":").Split(" ") #GET CURRENT COORDS FROM CLIPBOARD
    }
    else {
        $ClipboardContent = ("Coordinates: X:0 y:0 z:0").split(":").Split(" ")
        $ScriptLoopCount ++
    }
    
    #CHECK IF CLIPBOARD CONTAINS COORDINATES
    if ($ClipboardContent -like "Coordinates"){
        $ClipboardContainsCoordinates = $true 
        $CurrentXPosition = $ClipboardContent[3]
        $CurrentYPosition = $ClipboardContent[5]
        $CurrentZPosition = $ClipboardContent[7]
        #if($debug){Write-Host "Clipboards contains coordinates"}
    }

    #CHECK IF ANY VALUE X,Y OR Z HAS CHANGED, IF NOT SKIP
    if(($CurrentXPosition -ne $PreviousXPosition -or $CurrentYPosition -ne $PreviousYPosition -or $CurrentZPosition -ne $PreviousZPosition) -and $ClipboardContainsCoordinates){
        if($debug){Write-Host "Coordinates differ from previous ones"
    }
    $ScriptFirstRun = $false
    if ($script:CustomCoordsProvided){
        $DestinationName = $SelectedDestination.Keys
    }
    else {
        $DestinationName = $SelectedDestination.Name
    }

    #GET CURRENT TIME AND SAVE PREVIOUS VALUES
    $CurrentTime = Get-Date
    if($PreviousTime){
        $LastUpdateRaw1 = $CurrentTime - $PreviousTime
    }
    else{
        $LastUpdateRaw1 = $Currenttime
    }
    switch ($LastUpdateRaw1){
        {$_.Hours} {$LastUpdate = '{0:00}h {1:00}min {2:00}sec' -f $LastUpdateRaw1.Hours,$LastUpdateRaw1.Minutes,$LastUpdateRaw1.Seconds; break}
        {$_.Minutes} {$LastUpdate = '{1:00}min {2:00}sec' -f $LastUpdateRaw1.Hours,$LastUpdateRaw1.Minutes,$LastUpdateRaw1.Seconds; break}
        {$_.Seconds} {$LastUpdate = '{2:00}sec' -f $LastUpdateRaw1.Hours,$LastUpdateRaw1.Minutes,$LastUpdateRaw1.Seconds; break}
    }
    if(!$env:TERM_PROGRAM -eq 'vscode') {
        Clear-Host
      }
    Write-Host "Updated: $($CurrentTime.ToString('HH:mm:ss')), last update: $LastUpdate, Destination: $DestinationName"
    

    #Total Distance Away
    #$PreviousDistanceTotalist = $curdist
    $CurrentDistanceTotal = [math]::Sqrt([math]::pow($CurrentXPosition - $DestCoordDataX,2) + [math]::pow($CurrentYPosition - $DestCoordDataY,2) + [math]::pow($CurrentZPosition - $DestCoordDataZ,2))
    $CurrentDistanceX = [math]::Sqrt([math]::pow($CurrentXPosition - $DestCoordDataX,2))
    $CurrentDistanceY = [math]::Sqrt([math]::pow($CurrentYPosition - $DestCoordDataY,2))
    $CurrentDistanceZ = [math]::Sqrt([math]::pow($CurrentZPosition - $DestCoordDataZ,2))
    
    $CurrentDistanceTotal = [Math]::abs($CurrentDistanceTotal)
    $CurrentDistanceX     = [Math]::abs($CurrentDistanceX)
    $CurrentDistanceY     = [Math]::abs($CurrentDistanceY)
    $CurrentDistanceZ     = [Math]::abs($CurrentDistanceZ)

    #GET DIFFERENCE IN DISTANCE
    #$CurrentDeltaTotal = $PreviousDistanceTotal - $CurrentDistanceTotal
    $CurrentDeltaX     = $PreviousDistanceX - $CurrentDistanceX
    $CurrentDeltaY     = $PreviousDistanceY - $CurrentDistanceY
    $CurrentDeltaZ     = $PreviousDistanceZ - $CurrentDistanceZ
    #$CurrentDeltaTotal = [math]::Sqrt([math]::pow($PreviousDistanceX - $CurrentDistanceX,2) + [math]::pow($PreviousDistanceY - $CurrentDistanceY,2) + [math]::pow($PreviousDistanceZ - $CurrentDistanceZ,2))
    #$CurrentDeltaTotal = [math]::Sqrt([math]::pow($CurrentDeltaX ,2) + [math]::pow($CurrentDeltaY,2) + [math]::pow($CurrentDeltaZ,2))
    
    $X2 = [math]::pow($CurrentDeltaX,2)
    $Y2 = [math]::pow($CurrentDeltaY,2)
    $Z2 = [math]::pow($CurrentDeltaZ,2)
    if ($CurrentDeltaX -lt 0){$X2 = $X2 * -1}
    if ($CurrentDeltaY -lt 0){$Y2 = $Y2 * -1}
    if ($CurrentDeltaZ -lt 0){$Z2 = $Z2 * -1}

    $CurrentDeltaTotal = [math]::Sqrt([math]::Abs($X2 + $Y2 + $Z2))
    if (($X2 + $Y2 + $Z2) -lt 0){$CurrentDeltaTotal = $CurrentDeltaTotal * -1}
    #$CurrentDeltaTotal


    #OUTPUT TO USER
    # Distance Indicator KM M Delta
    $Results = @()
    $Total = "" | Select-Object Type,Distance,Delta # Spacer1, Spacer2
    $Total.Type = "Total"
    #$Total.Indicator = $StatusIndicatorT
    $Total.Distance = $CurrentDistanceTotal
    $Total.Delta = $CurrentDeltaTotal
    #$Total.Spacer1 = " "
    #$Total.Spacer2 = " "
    if($debug){$Results += $Total}

    $X = "" | Select-Object Type,Distance,Delta # Spacer1, Spacer2
    $X.Type = "X-Axis"
    #$X.Indicator = $StatusIndicatorX
    $X.Distance = $CurrentDistanceX
    $X.Delta = $CurrentDeltaX
    #$X.Spacer1 = " "
    #$X.Spacer2 = " "
    if($debug){$Results += $X}

    $Y = "" | Select-Object Type,Distance,Delta # Spacer1, Spacer2
    $Y.Type = "Y-Axis"
    #$Y.Indicator = $StatusIndicatorY
    $Y.Distance = $CurrentDistanceY
    $Y.Delta = $CurrentDeltaY
    #$Y.Spacer1 = " "
    #$Y.Spacer2 = " "
    if($debug){$Results += $Y}

    $Z = "" | Select-Object Type,Distance,Delta # Spacer1, Spacer2
    $Z.Type = "Z-Axis"
    #$Z.Indicator = $StatusIndicatorZ
    $Z.Distance = $CurrentDistanceZ
    $Z.Delta = $CurrentDeltaZ
    #$Z.Spacer1 = " "
    #$Z.Spacer2 = " "
    if($debug){$Results += $Z}
    
    #######################
    ### GENERATE OUTPUT ###
    #######################
    if(!$Powershellv5Legacy){
        $EscapeCharacter = ([char]27)                                           #EXCAPE CHARACTER TO COLORIZE TABLE
        #DEFINE VIRTUAL TERMINAL SEQUENZCE COLOR
        $VTFontRed = "91"         #Light Red
        #$VTFontDarkRed = "31"     #Dark Red
        $VTFontYellow = "93"      
        #$VTFontDarkYellow = "33"  
        $VTFontGreen = "92"
        #$VTFontDarkGreen = "32"
        $VTFontBlue = "94"
        #$VTFontDarkBlue = "34"
        $VTFontGray = "38"        #Gray, Named as Extened Colour
        $VTFontDefault = "0"      #White Text Color
        #$VTFontBolt = "1"
        #$VTFontExtened = "38"
        $VTFontDarkGray = "90"
        #$Testcolor = $VTFontDarkGray
        #"$EscapeCharacter[${Testcolor}mTest"

        #Combine String
        $VTRed = "$EscapeCharacter[${VTFontRed}m"
        $VTYellow = "$EscapeCharacter[${VTFontYellow}m"
        $VTGreen = "$EscapeCharacter[${VTFontGreen}m"
        $VTBlue = "$EscapeCharacter[${VTFontBlue}m"
        $VTGray = "$EscapeCharacter[${VTFontGray}m"
        $VTDarkGray = "$EscapeCharacter[${VTFontDarkGray}m"
        $VTDefault = "$EscapeCharacter[${VTFontDefault}m"
    }
    else{
        $EscapeCharacter = ""
        $VTGray = ""
        $VTRed = ""
        $VTYellow = ""
        $VTGreen = ""
        $VTGray = ""
        $VTDarkGray = ""
        $VTDefault = ""
    }

    if($debug){
        $Results | Format-Table @{                                             
            Label ="$($VTDefault)Type";
            Expression ={"$($VTDefault)$($_.Type)      "}
        },
        @{
            Label = "$($VTDefault)Distance";                                  #NAME OF RESULTHEADING
            Expression = {switch ($_.Distance){                                 #COLORIZE DISTANCE BY LIMITS
                {$_ -le $DistanceGreen}  { $color = $VTGreen; break }               # When $_ is -1 its lwoer than 0 
                {$_ -le $DistanceYellow} { $color = $VTYellow; break }               #
                default { $color = $VTRed }                                       #
            }
            $DistanceTKM = [math]::Truncate($_.Distance/1000).ToString('N0')+"km"   #CONVERT DISTANCE IN KM
            $DistanceTM = ($_.Distance/1000).ToString('N3').split(',')[1]+"m "   #CONVERT DISTANCE IN M
            "$($color)$("$DistanceTKM $DistanceTM")"                          #RESULT COLOR FORMAT
            };

            #ALIGN NUMBERS TO THE RIGHT
            align ='right';
            width = 20
        },
        @{
            #Label = 'Delta';
            Label = "$($VTDefault)Delta";
            Expression = {switch ($_.Delta){
                {$_ -lt 0} { $color = $VTRed; break }     # COLOR RED IF WE GOT MORE FAR WAY
                {$_ -gt 0} { $color = $VTGreen; break }   # COLOR GREEN IF WE GOT CLOSER
                default { $color = $VTDefault }          # COLOR GRAY IF NOTHING CHANGED
            }
            $DeltaTotalKM  = [math]::Truncate($_.Delta/1000).ToString('N0')+"km"
            $DeltaTotalM   = ($_.Delta/1000).ToString('N3').split(',')[1]+"m "
            "    $($color)$("$DeltaTotalKM $DeltaTotalM")"
            };
            align = 'right'
        }
    }

    switch ($CurrentDistanceTotal){                                                   #COLORIZE DISTANCE BY LIMITS
        {$_ -le $DistanceGreen}  { $CDTcolor = $VTGreen; break }               # When $_ is -1 its lwoer than 0 
        {$_ -le $DistanceYellow} { $CDTcolor = $VTYellow; break }              #
        default { $CDTcolor = $VTRed }    
    }
    switch ($CurrentDeltaTotal){                                                   #COLORIZE DISTANCE BY LIMITS
        {$_ -le $DistanceGreen}  { $CDETcolor = $VTGreen; break }               # When $_ is -1 its lwoer than 0 
        {$_ -le $DistanceYellow} { $CDETcolor = $VTYellow; break }              #
        default { $CDETcolor = $VTRed }    
    }

    $DistanceTKM = [math]::Truncate($CurrentDistanceTotal/1000).ToString('N0')+"km" 
    $DistanceTM = ($CurrentDistanceTotal/1000).ToString('N3').split(',')[1]+"m"
    $DistanceDKM = [math]::Truncate($CurrentDeltaTotal/1000).ToString('N0')+"km" 
    $DistanceDM = ($CurrentDeltaTotal/1000).ToString('N3').split(',')[1]+"m"
    Write-Host ""
    #Write-Host "NAVIGATION"
    #Write-Host "Total Distance: ${CDTcolor}$("$DistanceTKM $DistanceTM") ${VTDefault}(since last update: $("$DistanceDKM $DistanceDM"))"

    ########################################
    ### SHOW DISTANCE TO QUaNTUM MARKERS ###
    ########################################
    $QMResults = @()
    foreach ($Marker in $script:CurrentQuantumMarker){
        $SelectedQuantumMarker = $QuantummarkerDataGroup.GetEnumerator() | Where-Object { $_.Key -eq $Marker }
        $QuantumMarkerCoords = $SelectedQuantumMarker.Value -Split ";"
        $QuantumMarkerDataX = $QuantumMarkerCoords[0]
        $QuantumMarkerDataY = $QuantumMarkerCoords[1]
        $QuantumMarkerDataZ = $QuantumMarkerCoords[2]
        $QuantumMarkerName = $SelectedQuantumMarker.Name -Split ";"

        #GET DISTANCES
        $QMDistanceFinal = [math]::Sqrt([math]::pow($QuantumMarkerDataX - $DestCoordDataX,2) + [math]::pow($QuantumMarkerDataY - $DestCoordDataY,2) + [math]::pow($QuantumMarkerDataZ - $DestCoordDataZ,2))
        $QMDistFinalKM = [math]::Truncate($QMDistanceFinal/1000).ToString('N0')+"km"               
        $QMDistFinalM  = ($QMDistanceFinal/1000).ToString('N3').split(',')[1]+"m" 

        #CONVERT DISTANCES IN KM AN DM
        $QMDistanceCurrent = [math]::Sqrt([math]::pow($CurrentXPosition - $QuantummarkerDataGroupX,2) + [math]::pow($CurrentYPosition - $QuantumMarkerDataY,2) + [math]::pow($CurrentZPosition - $QuantumMarkerDataZ,2))
        $QMDistCurrentKM = [math]::Truncate($QMDistanceCurrent/1000).ToString('N0')+"km"               
        $QMDistCurrentM  = ($QMDistanceCurrent/1000).ToString('N3').split(',')[1]+"m"   
        
        #$QMDistanceFinal - $QMDistanceCurrent
        #([Math]::abs($QMDistanceFinal - $_))
        #([Math]::abs(($QMDistanceFinal - $_)) -lt $QMDistanceGreen)
        #(([Math]::abs($QMDistanceFinal - $_)) -lt $QMDistanceYellow)

        switch ($QMDistanceCurrent){                                 #COLORIZE DISTANCE BY LIMITS
            {([Math]::abs($QMDistanceFinal - $_)) -lt $QMDistanceGreen}  { $QMcolor = $VTGreen; break } #92
            {([Math]::abs($QMDistanceFinal - $_)) -lt $QMDistanceYellow} { $QMcolor = $VTYellow; break }
            default { $QMcolor = $VTRed } #91
        }

        #switch ($QMDistanceCurrent){                                 #COLORIZE DISTANCE BY LIMITS
        #    {([Math]::abs($_) -lt $QMDistanceGreen)}  { $QMcolor = $VTFontGreen; break  } #92
        #    {([Math]::abs($_) -lt $QMDistanceYellow)} { $QMcolor = $VTFontYellow; break }
        #    default { write-host "3" } #91
        #}
        #$QMcolor

        #OUTPUT TO USER
        $QMCurrent = "" | Select-Object QuantumMarker,Current,Final
        $QMCurrent.QuantumMarker = "$QuantumMarkerName"
        $QMCurrent.Current = "${QMcolor}$("$QMDistCurrentKM $QMDistCurrentM")"
        $QMCurrent.Final = "     $([char]27)[92m$QMDistFinalKM $QMDistFinalM"
        $QMResults += $QMCurrent
    }
    $QMResults | Format-Table


    ################
    ### xabdiben ###
    ################
    function CalcDistance3d {
        Param ($x1, $y1, $z1, $x2, $y2, $z2)
        Return [math]::Sqrt(($x1 - $x2) * ($x1 - $x2) + ($y1 - $y2) * ($y1 - $y2) + ($z1 - $z2) * ($z1 - $z2) )
        }

    if ($PreviousXPosition -ne $null) {
        $xu = (($DestCoordDataX - $PreviousXPosition) * ($CurrentXPosition - $PreviousXPosition))+(($DestCoordDataY - $PreviousYPosition) * ($CurrentYPosition - $PreviousYPosition))+(($DestCoordDataZ - $PreviousZPosition) * ($CurrentZPosition - $PreviousZPosition))

        $xab_dist = CalcDistance3d $CurrentXPosition $CurrentYPosition $CurrentZPosition $PreviousXPosition $PreviousYPosition $PreviousZPosition 

        if ($xab_dist -lt 1) {
            $xab_dist=1
        }

        $xu = $xu/($xab_dist * $xab_dist)

        $closestX = [double]$PreviousXPosition + [double]$xu * ($CurrentXPosition - $PreviousXPosition)
        $closestY = [double]$PreviousYPosition + [double]$xu * ($CurrentYPosition - $PreviousYPosition)
        $closestZ = [double]$PreviousZPosition + [double]$xu * ($CurrentZPosition - $PreviousZPosition)

        #$c1 = CalcDistance3d $DestCoordDataX $DestCoordDataY $DestCoordDataZ $PreviousXPosition $PreviousYPosition $PreviousZPosition
        $c2 = CalcDistance3d $DestCoordDataX $DestCoordDataY $DestCoordDataZ $CurrentXPosition $CurrentYPosition $CurrentZPosition


        $pathError = CalcDistance3d $DestCoordDataX $DestCoordDataY $DestCoordDataZ $closestX $closestY $closestZ
        #Write-Host "Path Error = $pathError"
        $perrd = [math]::atan2($pathError, $c2) * 180.0 / [math]::pi
        $script:FinalAngle = [math]::Round($perrd,2)
    }

    ####################
    ### INSTRUCTIONS ###
    ####################
    #GET DISTANCES FROM ALL AVAIlABLE QM
    $AllQMResults = @()
    $FinalCoordArray = @{}
    $FirstCoordArray = @{}
    $Selection = @{}

    $Selection = $PointsOfInterestInSpaceData.GetEnumerator() | Where-Object {$_.Name -contains $SelectedDestination.Name}
    $FinalCoordArray += $QuantummarkerDataGroup  # ADD ALL QUANTUM MARKER TO FINAL ARRAY
    $FirstCoordArray += $FinalCoordArray    # ADD ALL QUANTUM MARKER TO FIRST ARRAY TO DETERMINE STARTPOINT
    $FirstCoordArray += $RestStopData       # ADD ALL RESTSTOPS TO FIRST ARRAY, THEY MIGHT COME IN HANDY AS STARTING POINT
    if($script:PlanetaryPoi){$FirstCoordArray += $FinalPoiCoords}
    if($script:PlanetaryPoi){$FirstCoordArray += $FinalPlanetCoords}

    #GET ALL COORDS FROM ALL QUNATUM MARKER AND SELECTED DESTINATION
    #foreach ($QMEntry in $FinalCoordArray.GetEnumerator()){
    foreach ($QMEntry in $FirstCoordArray.GetEnumerator()){
        $InstQuantumMarkerCoords = $QMEntry.Value -Split ";"
        $InstQuantumMarkerDataX  = $InstQuantumMarkerCoords[0]
        $InstQuantumMarkerDataY  = $InstQuantumMarkerCoords[1]
        $InstQuantumMarkerDataZ  = $InstQuantumMarkerCoords[2]

        $InstQMCurrent = "" | Select-Object QuantumMarker,X,Y,Z
        $InstQMCurrent.QuantumMarker = $QMEntry.Name
        $InstQMCurrent.X = $InstQuantumMarkerDataX
        $InstQMCurrent.Y = $InstQuantumMarkerDataY
        $InstQMCurrent.Z = $InstQuantumMarkerDataZ
        $AllQMResults += $InstQMCurrent
    }

    #CALCULATE DISTANCES BETWEEN ALLE ENTRIES FROM PREVIOUS ARRAY
    $AllQMDistances = @()
    foreach ($QMEntry in $AllQMResults.GetEnumerator()){
        foreach ($Entry in $AllQMResults.GetEnumerator()){
            $DistanceBetweenQM = [math]::Sqrt([math]::pow($QMEntry.X - $Entry.X,2) + [math]::pow($QMEntry.Y - $Entry.Y,2) + [math]::pow($QMEntry.Z - $Entry.Z,2))
            $DistanceBetweenQMX = [math]::Sqrt([math]::pow($QMEntry.X - $Entry.X,2))
            $DistanceBetweenQMY = [math]::Sqrt([math]::pow($QMEntry.Y - $Entry.Y,2))
            $DistanceBetweenQMZ = [math]::Sqrt([math]::pow($QMEntry.Z - $Entry.Z,2))
            $CurrentQMDistance = "" | Select-Object QuantumMarkerFrom,QuantumMarkerTo,Distance,DistanceX,DistanceY,DistanceZ
            $CurrentQMDistance.QuantumMarkerFrom = $QMEntry.QuantumMarker
            $CurrentQMDistance.QuantumMarkerTo = $Entry.QuantumMarker
            $CurrentQMDistance.Distance = $DistanceBetweenQM
            $CurrentQMDistance.DistanceX = $DistanceBetweenQMX
            $CurrentQMDistance.DistanceY = $DistanceBetweenQMY
            $CurrentQMDistance.DistanceZ = $DistanceBetweenQMZ
            $AllQMDistances += $CurrentQMDistance
        }
    }

    #FILTER FOR CLOSEST QM TO START FROM
    $AllQMDistancesSorted = $AllQMDistances | Where-Object {$_.Distance -ne 0} 
    $QMDistancesCurrent = $AllQMDistancesSorted | Where-Object {$_.QuantumMarkerFrom -contains $SelectedDestination.Name} 
    $ClosestQMStart = $QMDistancesCurrent | Sort-Object -Property Distance | Select-Object -First 1
    

    if ($script:PlanetaryPoi) {
        $OM1 = $OM2 = $OM3 = $OM4 = $OM5 = $OM6 = ""
        #$PlanetOMRadius = ($HashtableOmRadius.GetEnumerator() | Where-Object {$_.Name -eq "$CurrentPlanet"}).Value
        $PosX = [double]$PoiCoordDataX * 1000
        $PosY = [double]$PoiCoordDataY * 1000
        $PosZ = [double]$PoiCoordDataZ * 1000
        $OM1 = [math]::Pow(([math]::Pow("$PosX","2") + [math]::Pow("$PosY","2") + [math]::Pow($PosZ-$PlanetOMRadius,"2")),1/2)
        $OM1 = [math]::Round($OM1)
        $OM2 = [math]::Pow(([math]::Pow("$PosX","2") + [math]::Pow("$PosY","2") + [math]::Pow($PosZ-(-$PlanetOMRadius),"2")),1/2)
        $OM2 = [math]::Round($OM2)
        $OM3 = [math]::Pow(([math]::Pow("$PosX","2") + [math]::Pow($PosY-$PlanetOMRadius,"2") + [math]::Pow($PosZ,"2")),1/2)
        $OM3 = [math]::Round($OM3)
        $OM4 = [math]::Pow(([math]::Pow("$PosX","2") + [math]::Pow($PosY-(-$PlanetOMRadius),"2") + [math]::Pow($PosZ,"2")),1/2)
        $OM4 = [math]::Round($OM4)
        $OM5 = [math]::Pow(([math]::Pow($PosX-$PlanetOMRadius,"2") + [math]::Pow("$PosY","2") + [math]::Pow($PosZ,"2")),1/2)
        $OM5 = [math]::Round($OM5)
        $OM6 = [math]::Pow(([math]::Pow($PosX-(-$PlanetOMRadius),"2") + [math]::Pow("$PosY","2") + [math]::Pow($PosZ,"2")),1/2)
        $OM6 = [math]::Round($OM6)

        #SORT ORBITAL MARKERS BY DISTANCE
        $OmArray = @{}
        $OmArray.add("OM1",$OM1);$OmArray.add("OM2",$OM2);$OmArray.add("OM3",$OM3);$OmArray.add("OM4",$OM4);$OmArray.add("OM5",$OM5);$OmArray.add("OM6",$OM6)

        #GET CLOSEST ORBITAL MARKER
        $OMGSStart = ($OmArray.GetEnumerator() | Sort-Object Value | Select-Object -First 1).Name
        #$OMForAngles = ($OmArray.GetEnumerator() | Where-Object {$_.Key -ne "OM1" -AND  $_.Key -ne "OM2"} | Sort-Object Value | Select-Object -First 1).Name
        $OMGSDistanceToDestination = ($OmArray.GetEnumerator() | Sort-Object Value | Select-Object -First 1).Value
    }

    #########################################
    ### SET ANGLE AN ALIGNMENT FOR ANGLES ###
    #########################################
    #CONVERT CURRENT STANTON XYZ INTO PLANET XYZ
    $X2 = $CurrentXPosition / 1000
    $Y2 = $CurrentYPosition / 1000
    
    #HARDCODED PLANET VIA DESTINATION
    $A2 = ($PlanetCoordDataX - $X2)
    $B2 = ($PlanetCoordDataY - $Y2)

    $ReversedAngle = 360 - $CurrentCycleAngle
    $AngleRadian = $ReversedAngle/180*[System.Math]::PI

    $ShipRotationValueX1 = ([double]$A2 * ([math]::Cos($AngleRadian)) - [double]$B2 * ([math]::Sin($AngleRadian))) * -1
    $ShipRotationValueY1 = ([double]$A2 * ([math]::Sin($AngleRadian)) + [double]$B2 * ([math]::Cos($AngleRadian))) * -1
    $ShipRotationValueZ1 = $CurrentZPosition / 1000

    ##
    #$OCRotationValueX = [double]$script:CurrentDetectedOCX * ([math]::Cos($CurrentCycleAngle/180*[System.Math]::PI)) - [double]$script:CurrentDetectedOCY * ([math]::Sin($CurrentCycleAngle/180*[System.Math]::PI))
    #$OCRotationValueY = [double]$script:CurrentDetectedOCX * ([math]::Sin($CurrentCycleAngle/180*[System.Math]::PI)) + [double]$script:CurrentDetectedOCY * ([math]::Cos($CurrentCycleAngle/180*[System.Math]::PI))
    
    #################################################################
    ### DETERMINE THE CURRENTOBJECT CONTAINER FROM STANTON COORDS ###
    #################################################################
    $script:CurrentDetectedObjectContainer = ""
    #DETECT CURRENT OC
    foreach ($ObjectContainer in $ObjectContainerData.GetEnumerator()){
        $ObjectContainerX         = ($ObjectContainer.Value -replace " " -Split ";")[0] 
        $ObjectContainerY         = ($ObjectContainer.Value -replace " " -Split ";")[1]
        $ObjectContainerZ         = ($ObjectContainer.Value -replace " " -Split ";")[2]
        $ObjectContainerRotSpeed  = ($ObjectContainer.Value -replace " " -Split ";")[3]
        $ObjectContainerRotAdjust = ($ObjectContainer.Value -replace " " -Split ";")[4]
        $ObjectContainerOMRadius  = ($ObjectContainer.Value -replace " " -Split ";")[5]
        $OMRadiusExtra = 1.5

        $WithinX = $WithinY = $WithinZ = $false
        if([double]$ObjectContainerX -lt 0){if($CurrentXPosition -lt ([double]$ObjectContainerX - [double]$ObjectContainerOMRadius * $OMRadiusExtra) -AND $CurrentXPosition -gt ([double]$ObjectContainerX + [double]$ObjectContainerOMRadius * $OMRadiusExtra)){$WithinX = $true}}
        else {if([double]$CurrentXPosition -gt ([double]$ObjectContainerX - [double]$ObjectContainerOMRadius * $OMRadiusExtra) -AND [double]$CurrentXPosition -lt ([double]$ObjectContainerX + [double]$ObjectContainerOMRadius * $OMRadiusExtra)){$WithinX = $true}}

        if([double]$ObjectContainerY -lt 0){if($CurrentYPosition -lt ([double]$ObjectContainerY - [double]$ObjectContainerOMRadius * $OMRadiusExtra) -AND $CurrentYPosition -gt ([double]$ObjectContainerY + [double]$ObjectContainerOMRadius * $OMRadiusExtra)){$WithinY = $true}}
        else {if([double]$CurrentYPosition -gt ([double]$ObjectContainerY - [double]$ObjectContainerOMRadius * $OMRadiusExtra) -AND [double]$CurrentYPosition -lt ([double]$ObjectContainerY + [double]$ObjectContainerOMRadius * $OMRadiusExtra)){$WithinY = $true}}

        if([double]$ObjectContainerZ -lt 0){if($CurrentZPosition -lt ([double]$ObjectContainerZ - [double]$ObjectContainerOMRadius * $OMRadiusExtra) -AND $CurrentZPosition -gt ([double]$ObjectContainerZ + [double]$ObjectContainerOMRadius * $OMRadiusExtra)){$WithinZ = $true}}
        else {if([double]$CurrentZPosition -gt ([double]$ObjectContainerZ - [double]$ObjectContainerOMRadius * $OMRadiusExtra) -AND [double]$CurrentZPosition -lt ([double]$ObjectContainerZ + [double]$ObjectContainerOMRadius * $OMRadiusExtra)){$WithinZ = $true}}

        if($WithinX -and $WithinY -and $WithinZ){
            $script:CurrentDetectedObjectContainer = $ObjectContainer.Name
            $script:CurrentDetectedOCX  = $ObjectContainerX
            $script:CurrentDetectedOCY  = $ObjectContainerY
            $script:CurrentDetectedOCZ  = $ObjectContainerZ
            $script:CurrentDetectedOCRS = $ObjectContainerRotSpeed
            $script:CurrentDetectedOCAD  = $ObjectContainerRotAdjust
            #$ObjectContainer.Name
        }
        #DEBUG IF A COORD MIGH TBE CORRECT; BUT MATCHES NOT BECAUSE OF A TYPO
        if($WithinX -or $WithinY){
            #$ObjectContainer.Name
            #$ObjectContainerX
            #$ObjectContainerY
            #$ObjectContainerZ
            #Write-Host "Stanton Coords $CurrentXPosition $CurrentYPosition $CurrentZPosition"
        }
        #DEBUG2
        #Write-Host "$($ObjectContainer.Name) (X=$WithinX Y=$WithinY Z=$WithinZ)"
        #Write-Host "Stanton Coords $CurrentXPosition $CurrentYPosition $CurrentZPosition"
        #Write-Host "ObjectContainer $ObjectContainerX $ObjectContainerY $ObjectContainerZ"
        #Write-Host "$script:CurrentDetectedObjectContainer "
    }


    #GET DIFFERENCES BETWEEN PLANET CENTRE AND CURRENT POSITION
    $PlanetDifferenceinX = ($CurrentDetectedOCX - $CurrentXPosition)    #A2
    $PlanetDifferenceinY = ($CurrentDetectedOCY - $CurrentYPosition)    #B2
    #$PlanetDifferenceinZ = ($CurrentDetectedOCZ - $CurrentZPosition)    #C2

    $OCLengthOfDayDecimal = [double]$script:CurrentDetectedOCRS * 3600 / 86400  #CORRECT
    $OCJulianDate = $ElapsedUTCTimeSinceSimulationStart.TotalDays        #CORRECT
    $OCTotalCycles = $OCJulianDate / $OCLengthOfDayDecimal                   #CORRECT
    $OCCurrentCycleDez = $OCTotalCycles%1
    $OCCurrentCycleDeg = $OCCurrentCycleDez * 360
    $OCCurrentCycleAngle = [double]$script:CurrentDetectedOCAD + [double]$OCCurrentCycleDeg
    $OCReversedAngle = 360 - $OCCurrentCycleAngle
    $OCAngleRadian = $OCReversedAngle/180*[System.Math]::PI

    $PlanetRotationValueX1 = ([double]$PlanetDifferenceinX * ([math]::Cos($OCAngleRadian)) - [double]$PlanetDifferenceinY * ([math]::Sin($OCAngleRadian))) * -1
    $PlanetRotationValueY1 = ([double]$PlanetDifferenceinX * ([math]::Sin($OCAngleRadian)) + [double]$PlanetDifferenceinY * ([math]::Cos($OCAngleRadian))) * -1
    $PlanetRotationValueZ1 = $ShipRotationValueZ1

    #DISPLAY CURRENT COORDS OF STANTON, PLANETARY AND POI
    $CurrentPlanetaryXCoord = [math]::Round($PlanetRotationValueX1/1000, 3)
    $CurrentPlanetaryYCoord = [math]::Round($PlanetRotationValueY1/1000, 3)
    $CurrentPlanetaryZCoord = [math]::Round($PlanetRotationValueZ1, 3)
    $CurrentDestinationXCoord = [math]::Round($PoiCoordDataX, 3)
    $CurrentDestinationYCoord = [math]::Round($PoiCoordDataY, 3)
    $CurrentDestinationZCoord = [math]::Round($PoiCoordDataZ, 3)

    Write-Host "COORDINATES : X (+OM5/-OM6)  Y (+OM3/-OM4)  Z (+OM1/-OM2)"
    Write-Host "Stanton     : $([math]::Round($CurrentXPosition, 3)), $([math]::Round($CurrentYPosition, 3)), $([math]::Round($CurrentZPosition, 3))"
    if($script:CurrentDetectedObjectContainer){
        Write-Host "Container   : $CurrentDetectedObjectContainer `t= $CurrentPlanetaryXCoord;$CurrentPlanetaryYCoord;$CurrentPlanetaryZCoord"
    }
    else{Write-Host "Container   : n/a"}
    Write-Host "Destination : $PoiCoordDataPlanet `t= $CurrentDestinationXCoord;$CurrentDestinationYCoord;$CurrentDestinationZCoord"
    Write-Host ""

    #CALCUALTE LOCAL COURSE DIAVATION
    $XULocal = (($CurrentDestinationXCoord - $PreviousPlanetaryXCoord) * ($CurrentPlanetaryXCoord - $PreviousPlanetaryXCoord))+(($CurrentDestinationYCoord - $PreviousPlanetaryYCoord) * ($CurrentPlanetaryYCoord - $PreviousPlanetaryYCoord))+(($CurrentDestinationZCoord - $PreviousPlanetaryZCoord) * ($CurrentPlanetaryZCoord - $PreviousPlanetaryZCoord))
    $xab_distLocal = CalcDistance3d $CurrentPlanetaryXCoord $CurrentPlanetaryYCoord $CurrentPlanetaryZCoord $PreviousPlanetaryXCoord $PreviousPlanetaryYCoord $PreviousPlanetaryZCoord 
    if ($xab_distLocal -lt 1) {$xab_distLocal=1}
    $XULocal = $XULocal/($xab_distLocal * $xab_distLocal)
    $closestXLocal = [double]$PreviousPlanetaryXCoord + [double]$XULocal * ($CurrentPlanetaryXCoord - $PreviousPlanetaryXCoord)
    $closestYLocal = [double]$PreviousPlanetaryYCoord + [double]$XULocal * ($CurrentPlanetaryYCoord - $PreviousPlanetaryYCoord)
    $closestZLocal = [double]$PreviousPlanetaryZCoord + [double]$XULocal * ($CurrentPlanetaryZCoord - $PreviousPlanetaryZCoord)
    #$c1 = CalcDistance3d $DestCoordDataX $DestCoordDataY $DestCoordDataZ $PreviousXPosition $PreviousYPosition $PreviousZPosition
    $c2Local = CalcDistance3d $CurrentDestinationXCoord $CurrentDestinationYCoord $CurrentDestinationZCoord $CurrentPlanetaryXCoord $CurrentPlanetaryYCoord $CurrentPlanetaryZCoord
    $pathErrorLocal = CalcDistance3d $CurrentDestinationXCoord $CurrentDestinationYCoord $CurrentDestinationZCoord $closestXLocal $closestYLocal $closestZLocal
    #Write-Host "Path Error = $pathError"
    $perrdLocal = [math]::atan2($pathErrorLocal, $c2Local) * 180.0 / [math]::pi
    # above ok, below 0
    $FinalAngleLocal = [math]::Round($perrdLocal,2)
    
    #COLOR CODEING FOR ANGLES
    switch ($script:FinalAngle){
        {$_ -le 0.1}{ $FAcolor = $VTBlue; break }
        {$_ -le 3}  { $FAcolor = $VTGreen; break }
        {$_ -le 10} { $FAcolor = $VTYellow; break }
        {$_ -gt 10} { $FAcolor = $VTRed; break }
        default { $FAcolor = $VTGray }
    }
    switch ($FinalAngleLocal){
        {$_ -le 0.1}{ $FALcolor = $VTBlue; break }
        {$_ -le  3} { $FALcolor = $VTGreen; break }
        {$_ -le 10} { $FALcolor = $VTYellow; break }
        {$_ -gt 10} { $FALcolor = $VTRed; break }
        default { $FALcolor = $VTGray }
    }


    #OUTPUT COURSE
    Write-Host "COURSE / DEVIATION"
    Write-Host "Total Distance: ${CDTcolor}$("$DistanceTKM $DistanceTM") ${VTDefault}(Delta: $("$DistanceDKM $DistanceDM"))"
    Write-Host "Course Dev. Space : ${FAcolor}$("$script:FinalAngle°") ${VTDefault} `t(Previous: $PreviousAngle°)"
    Write-Host "Course Dev. Planet: ${FALcolor}$("$FinalAngleLocal°") ${VTDefault} `t(Previous: $PreviousAngleLocal°)"
    if($CurrentDeltaTotal -gt 0 -OR $CurrentDeltaTotal -lt 0){
        if($PreviousTime -gt 0){$CurrentETA = $CurrentDistanceTotal/($CurrentDeltaTotal/($CurrentTime - $PreviousTime).TotalSeconds)}
    }
    if($CurrentETA -gt 0){
        $ts =  [timespan]::fromseconds($CurrentETA)
        Write-Host "ETA = $($ts.Days) Days $($ts.Hours) Hours $($ts.Minutes) Minutes $($ts.Seconds) Seconds"
        Write-Host ""
    }
    else {
        Write-Host -ForegroundColor Red "ETA = Wrong way Pilot, turn around."
        Write-Host ""
    }
   
    Write-Host ""

    #DETERMINE CLOST CURRENT OM FOR ANGLE CALCULATIONS
    $OMShip1 = $OMShip2 = $OMShip3 = $OMShip4 = $OMShip5 = $OMShip6 = ""
    #$PlanetOMRadius = ($HashtableOmRadius.GetEnumerator() | Where-Object {$_.Name -eq "$CurrentPlanet"}).Value
    $PosShipX = [double]$ShipRotationValueX1 * 1000
    $PosShipY = [double]$ShipRotationValueY1 * 1000
    $PosShipZ = [double]$ShipRotationValueZ1 * 1000
    $ShipOM1 = [math]::Pow(([math]::Pow("$PosShipX","2") + [math]::Pow("$PosShipY","2") + [math]::Pow($PosShipZ-$PlanetOMRadius,"2")),1/2)
    $ShipOM1 = [math]::Round($ShipOM1)
    $ShipOM2 = [math]::Pow(([math]::Pow("$PosShipX","2") + [math]::Pow("$PosShipY","2") + [math]::Pow($PosZ-(-$PlanetOMRadius),"2")),1/2)
    $ShipOM2 = [math]::Round($ShipOM2)
    $ShipOM3 = [math]::Pow(([math]::Pow("$PosShipX","2") + [math]::Pow($PosShipY-$PlanetOMRadius,"2") + [math]::Pow($PosShipZ,"2")),1/2)
    $ShipOM3 = [math]::Round($ShipOM3)
    $ShipOM4 = [math]::Pow(([math]::Pow("$PosShipX","2") + [math]::Pow($PosShipY-(-$PlanetOMRadius),"2") + [math]::Pow($PosShipZ,"2")),1/2)
    $ShipOM4 = [math]::Round($ShipOM4)
    $ShipOM5 = [math]::Pow(([math]::Pow($PosShipX-$PlanetOMRadius,"2") + [math]::Pow("$PosShipY","2") + [math]::Pow($PosShipZ,"2")),1/2)
    $ShipOM5 = [math]::Round($ShipOM5)
    $ShipOM6 = [math]::Pow(([math]::Pow($PosShipX-(-$PlanetOMRadius),"2") + [math]::Pow("$PosShipY","2") + [math]::Pow($PosShipZ,"2")),1/2)
    $ShipOM6 = [math]::Round($ShipOM6)

    #SORT ORBITAL MARKERS BY DISTANCE
    $ShipOmArray = @{}
    $ShipOmArray.add("OM1",$ShipOM1);$ShipOmArray.add("OM2",$ShipOM2);$ShipOmArray.add("OM3",$ShipOM3);$ShipOmArray.add("OM4",$ShipOM4);$ShipOmArray.add("OM5",$ShipOM5);$ShipOmArray.add("OM6",$ShipOM6)

    #GET CLOSEST ORBITAL MARKER
    $ShipOMClosest = ($ShipOmArray.GetEnumerator() | Sort-Object Value | Select-Object -First 1).Name

    $DistanceShipToPlanetAlignment = [math]::Sqrt([math]::pow(($CurrentXPosition - $FinalPlanetDataX),2) + [math]::pow(($CurrentYPosition - $FinalPlanetDataY),2) + [math]::pow(($CurrentZPosition - $FinalPlanetDataZ),2))
    $DistancePoiToPlanet = [math]::Sqrt([math]::pow($DestCoordDataX - ([double]$PlanetCoordDataX * 1000),2) + [math]::pow($DestCoordDataY - ([double]$PlanetCoordDataY * 1000),2) + [math]::pow($DestCoordDataZ - ([double]$PlanetCoordDataZ * 1000),2))
    #$ClosestQM = $QMDistancesCurrent | Where-Object {$_.QuantumMarkerTo -NotContains $ClosestQMStart.QuantumMarkerTo} | Sort-Object -Property Distance | Select-Object -First 1 

    if($ShipOMClosest -eq "OM3" -OR $ShipOMClosest -eq "OM4"){     
        $TriangleYB = [double]$PoiCoordDataY - [double]$ShipRotationValueY1
        $TriangleYA = [double]$PoiCoordDataZ - [double]$ShipRotationValueZ1
        $TriangleYC = [math]::Sqrt([math]::pow($TriangleYA,2) + [math]::pow($TriangleYB,2)) 
        $TriangleYAlpha = [math]::ASin($TriangleYA / $TriangleYC) * 180 / [System.Math]::PI         
        #$TriangleYAlpha 

        $TriangleXA = $ShipRotationValueX1 + $PoiCoordDataX                                  
        $TriangleXB = [double]$PoiCoordDataY - [double]$ShipRotationValueY1                                                          
        $TriangleXC = [math]::Sqrt([math]::pow($TriangleXA,2) + [math]::pow($TriangleXB,2))  
        if($ShipOMClosest -eq "OM3"){$TriangleXAlpha = [math]::Sin($TriangleXA / $TriangleXC) * 180 / [System.Math]::PI * -1} 
        if($ShipOMClosest -eq "OM4"){$TriangleXAlpha = [math]::Sin($TriangleXA / $TriangleXC) * 180 / [System.Math]::PI} 
        if($TriangleXAlpha -lt 0){$TriangleXAlpha = 360 + $TriangleXAlpha}

        $FinalHorizontalAngle = [Math]::Round($TriangleXAlpha)
        $FinalVerticalAngle = [Math]::Round($TriangleYAlpha)

        Write-Host "ALIGNMENT FROM OM3/4"
        Write-Host "Planet: ${VTGreen}$($SelectedPlanet.Name)${VTDefault}, Orbital Marker: ${VTGreen}$ShipOMClosest${VTDefault}, Alignment: ${VTGreen}Planet Centre"
        Write-Host "Alignment Nose: ${VTGreen}Planet Centre${VTDefault}, Wings: ${VTGreen}OM5-6${VTDefault}, Top: ${VTGreen}OM-1"
        Write-Host "Turret Angle: ${VTGreen}$FinalVerticalAngle°${VTDefault} (Vertical)"
        Write-Host "Turret Angle: ${VTGreen}$FinalHorizontalAngle°${VTDefault} (Horizontal)"
    }

    if($ShipOMClosest -eq "OM5" -OR $ShipOMClosest -eq "OM6"){       
        if($ShipOMClosest -eq "OM6"){$TriangleYA = [double]$PoiCoordDataZ + [double]$ShipRotationValueZ1}
        $TriangleYA = [double]$PoiCoordDataZ - [double]$ShipRotationValueZ1
        if($ShipOMClosest -eq "OM6"){$TriangleYA = [double]$PoiCoordDataZ - [double]$ShipRotationValueZ1}
        $TriangleYB = [double]$PoiCoordDataX - [double]$ShipRotationValueX1
        $TriangleYC = [math]::Sqrt([math]::pow($TriangleYA,2) + [math]::pow($TriangleYB,2)) 
        $TriangleYAlpha = [math]::ASin($TriangleYA / $TriangleYC) * 180 / [System.Math]::PI         
        #$TriangleYAlpha 

        $TriangleXA = [double]$PoiCoordDataY - [double]$ShipRotationValueY1                                     
        $TriangleXB = [double]$PoiCoordDataX - [double]$ShipRotationValueX1                                                             
        $TriangleXC = [math]::Sqrt([math]::pow($TriangleXA,2) + [math]::pow($TriangleXB,2))        
        $TriangleXAlpha = [math]::ASin($TriangleXA / $TriangleXC) * 180 / [System.Math]::PI
        if($ShipOMClosest -eq "OM5"){$TriangleXAlpha = [math]::ASin($TriangleXA / $TriangleXC) * 180 / [System.Math]::PI} 
        if($ShipOMClosest -eq "OM6"){$TriangleXAlpha = [math]::ASin($TriangleXA / $TriangleXC) * 180 / [System.Math]::PI * -1}   
        if($TriangleXAlpha -lt 0){$TriangleXAlpha = 360 + $TriangleXAlpha}
        #$TriangleXAlpha

        $FinalHorizontalAngle = [Math]::Round($TriangleXAlpha)
        $FinalVerticalAngle = [Math]::Round($TriangleYAlpha)

        Write-Host "ALIGNMENT FROM OM5/6"
        Write-Host "Planet: ${VTGreen}$($SelectedPlanet.Name)${VTDefault}, Orbital Marker: ${VTGreen}$ShipOMClosest${VTDefault}, Alignment: ${VTGreen}Planet Centre"
        Write-Host "Alignment Nose: ${VTGreen}Planet Centre${VTDefault}, Wings: ${VTGreen}OM3-4${VTDefault}, Top: ${VTGreen}OM-1"
        Write-Host "Turret Angle: ${VTGreen}$FinalVerticalAngle°${VTDefault} (Vertical)"
        Write-Host "Turret Angle: ${VTGreen}$FinalHorizontalAngle°${VTDefault} (Horizontal)"
    }

    if($ShipOMClosest -eq "OM2" -OR $ShipOMClosest -eq "OM1"){                                      
        $TriangleYA = [double]$PoiCoordDataY - [double]$ShipRotationValueY1
        $TriangleYB = [double]$PoiCoordDataZ - [double]$ShipRotationValueZ1
        $TriangleYC = [math]::Sqrt([math]::pow($TriangleYA,2) + [math]::pow($TriangleYB,2)) 
        $TriangleYAlpha = [math]::ASin($TriangleYA / $TriangleYC) * 180 / [System.Math]::PI         

        $TriangleXA = [double]$PoiCoordDataX - [double]$ShipRotationValueX1                                      
        $TriangleXB = [double]$PoiCoordDataZ - [double]$ShipRotationValueZ1                                                           
        $TriangleXC = [math]::Sqrt([math]::pow($TriangleXA,2) + [math]::pow($TriangleXB,2))        
        if($ShipOMClosest -eq "OM1"){$TriangleXAlpha = [math]::ASin($TriangleXA / $TriangleXC) * 180 / [System.Math]::PI}
        if($ShipOMClosest -eq "OM2"){$TriangleXAlpha = [math]::ASin($TriangleXA / $TriangleXC) * 180 / [System.Math]::PI * -1}
        if($TriangleXAlpha -lt 0){$TriangleXAlpha = 360 + $TriangleXAlpha}

        $FinalHorizontalAngle = [Math]::Round($TriangleXAlpha)
        $FinalVerticalAngle = [Math]::Round($TriangleYAlpha)

        Write-Host "ALIGNMENT FROM OM1/2"
        Write-Host "Planet: ${VTGreen}$($SelectedPlanet.Name)${VTDefault}, Orbital Marker: ${VTGreen}$ShipOMClosest${VTDefault}"
        Write-Host "Alignment Nose: ${VTGreen}Planet Centre${VTDefault}, Wings: ${VTGreen}OM5-6${VTDefault}, Top: ${VTGreen}OM-3"
        Write-Host "Turret Angle: ${VTGreen}$FinalVerticalAngle°${VTDefault} (Vertical)"
        Write-Host "Turret Angle: ${VTGreen}$FinalHorizontalAngle°${VTDefault} (Horizontal)"
    }

    ### GET ANGLE ON A PLANET FOR GROUDN VEHICLES ###
    # CODE BY BIGCHEESE
    #Write-Host "CalcEbenenwinkel: " +  $PreviousPlanetaryXCoord + '; ' + $PreviousPlanetaryYCoord + '; ' + $PreviousPlanetaryZCoord + '; ' + $CurrentPlanetaryXCoord + '; ' + $CurrentPlanetaryYCoord + '; ' + $CurrentPlanetaryZCoord + '; ' + $PoiCoordDataX + '; ' + $PoiCoordDataY + '; ' + $PoiCoordDataZ
    Write-Host "-----------------------"
    $Previous_AngleGroundVehicles = $AngleGroundVehicles
    $AngleGroundVehiclesRAW = CalcEbenenwinkel $PreviousPlanetaryXCoord $PreviousPlanetaryYCoord $PreviousPlanetaryZCoord $CurrentPlanetaryXCoord $CurrentPlanetaryYCoord $CurrentPlanetaryZCoord $PoiCoordDataX $PoiCoordDataY $PoiCoordDataZ
    $AngleGroundVehicles = [math]::Round($AngleGroundVehiclesRAW)
    $Previous_DistanceGroundVehicles = $DistanceGroundVehicles
    $DistanceGroundVehiclesRAW = CalcDistance3d $CurrentPlanetaryXCoord $CurrentPlanetaryYCoord $CurrentPlanetaryZCoord $PoiCoordDataX $PoiCoordDataY $PoiCoordDataZ
    $DistanceGroundVehicles = [math]::Pow("$DistanceGroundVehiclesRAW","2")
    if ($AngleGroundVehicles -le $Previous_AngleGroundVehicles) {
    Write-Host "Angle to Destination: $AngleGroundVehicles Tendency: ${VTGreen}good${VTDefault}" 
    }
    else {
    Write-Host "Angle to Destination: $AngleGroundVehicles Tendency: ${VTRed}bad${VTDefault}" 
    }
    switch($DistanceGroundVehicles){
        {$_ -lt $Previous_DistanceGroundVehicles} {$TendencyColor = $VTGreen; $TendecyStatus = "got closer"; break }
        {$_ -gt $Previous_DistanceGroundVehicles} {$TendencyColor = $VTred; $TendecyStatus = "far away"; break }
        Default {$TendencyColor = $VTDarkGray; $TendecyStatus = "no change"}
    }
    Write-Host "Distance: $DistanceGroundVehicles km - Tendency: ${TendencyColor}$TendecyStatus${VTDefault}"

    
    #Minign Area 141
    #       H   V       Status
    #OM1    359 15      Correct, Correct #2
    #OM2    6   43      Correct, Correct #2
    #OM3    4   -43     Correct, Correct #2
    #OM4    359 -21     Correct, Correct #2
    #OM5    22  -26     Correct (2° Diavation Vert), Correct #2 (2° Diavation Vert)
    #OM6    336 -27     Correct (2° Diavation Vert), Correct #2 (2° Diavation Hori, (4° Diavation Vert))

    ##################################
    ### ANGLES FOR GROUND VEHICLES ###
    ##################################
    # a = total distance travelled between current and last point
    #Delta between previous and current ship location (planetary coords)
    $TriangleGroundA = 100 * [math]::Sqrt(([math]::pow($PerviousShipRotationValueX1,2) - [math]::pow($ShipRotationValueX1,2)) + ([math]::pow($PerviousShipRotationValueY1,2) - [math]::pow($ShipRotationValueY1,2)) + ([math]::pow($PerviousShipRotationValueZ1,2) - [math]::pow($ShipRotationValueZ1,2)))
    $TriangleGroundB = [math]::Sqrt([math]::Abs(([math]::pow($PoiRotationValueX,2) - [math]::pow($ShipRotationValueX1,2)) + ([math]::pow($PoiRotationValueY,2) - [math]::pow($ShipRotationValueY1,2)) + ([math]::pow($PoiRotationValueZ,2) - [math]::pow($ShipRotationValueZ1,2))))
    $TriangleGroundC = [math]::Sqrt([math]::pow($TriangleGroundA,2) + [math]::pow($TriangleGroundB,2))
        #100 * [math]::Sqrt(([math]::pow($PerviousShipRotationValueX1,2) - [math]::pow($ShipRotationValueX1,2)) + ([math]::pow($PerviousShipRotationValueY1,2) - [math]::pow($ShipRotationValueY1,2)) + ([math]::pow($PerviousShipRotationValueZ1,2) - [math]::pow($ShipRotationValueZ1,2))) 
   
    $AlphaPurple = [math]::Acos(([math]::Pow($TriangleGroundB, 2) + [math]::Pow($TriangleGroundC, 2) - [math]::Pow($TriangleGroundA, 2)) / (2 * $TriangleGroundB * $TriangleGroundC))
    $BetaPurple =  [math]::Acos(([math]::Pow($TriangleGroundC, 2) + [math]::Pow($TriangleGroundA, 2) - [math]::Pow($TriangleGroundB, 2)) / (2 * $TriangleGroundC * $TriangleGroundA))
    $GammaPurple = [math]::Acos(([math]::Pow($TriangleGroundA, 2) + [math]::Pow($TriangleGroundB, 2) - [math]::Pow($TriangleGroundC, 2)) / (2 * $TriangleGroundA * $TriangleGroundB))
    #$GroundVehicleAlpha = [Math]::Round([math]::ASin($TriangleGroundA / $TriangleGroundC) * 180 / [System.Math]::PI,2)
    $GroundVehicleAlpha = [Math]::Round($AlphaPurple * 180 / [System.Math]::PI,2)
    $GroundVehicleBeta = $BetaPurple * 180 / [System.Math]::PI
    $GroundVehicleGamma = $GammaPurple * 180 / [System.Math]::PI
    #Write-Host "Course Diavation: ${VTGreen}$GroundVehicleAlpha ${VTDefault}(Ground)"
    #Write-Host "Course Diavation: ${VTGreen}$GroundVehicleBeta ${VTDefault}(Ground)"
    #Write-Host "Course Diavation: ${VTGreen}$GroundVehicleGamma ${VTDefault}(Ground)"
    #Write-Host "A Delta POI Total $TriangleGrounda" 
    #Write-Host "B Diavation Total $TriangleGroundB" 
    #Write-Host "C Movement Total $TriangleGroundC"

    # now subtract the vertical angle diavation, to get only the x angle
    # planet x y z



    #$ClosestQMX = $QMDistancesCurrent | Where-Object {$_.QuantumMarkerTo -NotContains $ClosestQMStart.QuantumMarkerTo} | Sort-Object -Property DistanceX | Select-Object -First 1 
    #$ClosestQMY = $QMDistancesCurrent | Where-Object {$_.QuantumMarkerTo -NotContains $ClosestQMStart.QuantumMarkerTo} | Where-Object {$_.QuantumMarkerTo -NotContains $ClosestQMY.QuantumMarkerTo} | Sort-Object -Property DistanceY | Select-Object -First 1 
    #$ClosestQMZ = $QMDistancesCurrent | Where-Object {$_.QuantumMarkerTo -NotContains $ClosestQMStart.QuantumMarkerTo} | Where-Object {$_.QuantumMarkerTo -NotContains $ClosestQMY.QuantumMarkerTo} | Where-Object {$_.QuantumMarkerTo -NotContains $ClosestQMZ.QuantumMarkerTo}| Sort-Object -Property DistanceZ | Select-Object -First 1 
    #CLOSEST QM MARKER ON X AXIS
    $ClosestQMX = $QMDistancesCurrent | Sort-Object -Property DistanceX | Select-Object -First 1 
    #CLOSEST QM MARKER ON Y AXIS
    $ClosestQMY = $QMDistancesCurrent | Sort-Object -Property DistanceY | Select-Object -First 1 
    #CLOSEST QM MARKER ON Z AXIS
    $ClosestQMZ = $QMDistancesCurrent | Sort-Object -Property DistanceZ | Select-Object -First 1 

    #$QMXDistanceFinal = [math]::Sqrt([math]::pow($DestCoordDataX - $ClosestQMX.DistanceX,2) + [math]::pow($DestCoordDataY - $ClosestQMX.DistanceY,2) + [math]::pow($DestCoordDataZ - $ClosestQMX.DistanceZ,2))
    #$QMYDistanceFinal = [math]::Sqrt([math]::pow($ClosestQMY.DistanceX - $DestCoordDataX,2) + [math]::pow($ClosestQMY.DistanceY - $DestCoordDataY,2) + [math]::pow($ClosestQMY.DistanceZ - $DestCoordDataZ,2))
    #$QMZDistanceFinal = [math]::Sqrt([math]::pow($ClosestQMZ.DistanceX - $DestCoordDataX,2) + [math]::pow($ClosestQMZ.DistanceY - $DestCoordDataY,2) + [math]::pow($ClosestQMZ.DistanceZ - $DestCoordDataZ,2))

    #$InstructionDistanceQMX = [math]::Truncate($ClosestQMX.Distance/1000).ToString('N0')+"km" 
    #$InstructionDistanceQMY = [math]::Truncate($ClosestQMY.Distance/1000).ToString('N0')+"km" 
    #$InstructionDistanceQMZ = [math]::Truncate($ClosestQMZ.Distance/1000).ToString('N0')+"km" 
    Write-Host "" 
    if ($script:PlanetaryPoi) {
        $FinalInstructions = @()
        $StartingPoint  =  [ordered]@{Step = "1.";Type = "Start";Direction = "from"; QuantumMarker = $PoiCoordDataPlanet;Distance = "-";TargetDistance = [math]::Truncate($ClosestQMStart.Distance/1000).ToString('N0')+"km"}
        $FirstStep =       [ordered]@{Step = "2.";Type = "Jump";Direction = "to";QuantumMarker = $OMGSStart;Distance = "-";TargetDistance = [math]::Truncate($OMGSDistanceToDestination/1000).ToString('N0')+"km"}
        $SecondStep =      [ordered]@{Step = "3.";Type = "Fly";Direction = "to";QuantumMarker = "$($SelectedDestination.Name)";Distance = [math]::Truncate($CurrentDistanceTotal/1000).ToString('N0')+"km";TargetDistance = "0 m"}
        $FinalInstructions += New-Object -Type PSObject -Property $StartingPoint
        $FinalInstructions += New-Object -Type PSObject -Property $FirstStep
        $FinalInstructions += New-Object -Type PSObject -Property $SecondStep
        Write-Host "INSTRUCTIONS" -NoNewline
        Write-Host ($FinalInstructions | Format-Table -Property @{Name="Step"; Expression={$_.Step}; Align="Center"},Type,Direction,QuantumMarker,@{Name="Distance"; Expression={"   $($_.Distance)"}; Align="Right"},@{Name="TargetDistance"; Expression={$_.TargetDistance}; Align="Right"} | Out-String)
        $LiveResults.Text = ($FinalInstructions | Format-Table -Property @{Name="Step"; Expression={$_.Step}; Align="Center"},Type,Direction,QuantumMarker,@{Name="Distance"; Expression={$_.Distance}; Align="Right"},@{Name="TargetDistance"; Expression={$_.TargetDistance}; Align="Right"} | Out-String)
    }
       
    if ($ButtonDestinationJericho.Checked -eq $true) {
        $FinalInstructions = @()
        $StartingPoint  =  [ordered]@{Step = "1.";Type = "Start";Direction = "from"; QuantumMarker = "MIC-L1-STATION (Shallow Frontier)";JumpDistance = "-";TargetDistance = "0 m"}
        $FirstStep =       [ordered]@{Step = "2.";Type = "Jump";Direction = "to";QuantumMarker = "MIC-L1";JumpDistance = "5.961 km";TargetDistance = "6.782 km"}
        $SecondStep =      [ordered]@{Step = "3.";Type = "Jump";Direction = "to";QuantumMarker = "Hurston";JumpDistance = "689 km";TargetDistance = "34.269.072 km"}
        $ThirdStep =       [ordered]@{Step = "4.";Type = "Jump";Direction = "to";QuantumMarker = "ARC-L3";JumpDistance = "27.127 km";TargetDistance = "49.067.144 km"}
        $FourthStep =      [ordered]@{Step = "5.";Type = "Fly";Direction = "to";QuantumMarker = "$($SelectedDestination.Name)";JumpDistance = "-";TargetDistance = "-"}
        $FinalInstructions += New-Object -Type PSObject -Property $StartingPoint
        $FinalInstructions += New-Object -Type PSObject -Property $FirstStep
        $FinalInstructions += New-Object -Type PSObject -Property $SecondStep
        $FinalInstructions += New-Object -Type PSObject -Property $ThirdStep
        $FinalInstructions += New-Object -Type PSObject -Property $FourthStep
        Write-Host"INSTRUCTIONS" -NoNewline
        Write-Host ($FinalInstructions | Format-Table -Property @{Name="Step"; Expression={$_.Step}; Align="Center"},Type,Direction,QuantumMarker,@{Name="JumpDistance"; Expression={$_.JumpDistance}; Align="Right"},@{Name="TargetDistance"; Expression={$_.TargetDistance}; Align="Right"} | Out-String)
        $LiveResults.Text = ($FinalInstructions | Format-Table -Property @{Name="Step"; Expression={$_.Step}; Align="Center"},Type,Direction,QuantumMarker,@{Name="JumpDistance"; Expression={$_.JumpDistance}; Align="Right"},@{Name="TargetDistance"; Expression={$_.TargetDistance}; Align="Right"} | Out-String)
    }
    #STORE PREVIOUS DISTANCES
    $PreviousXPosition     = $CurrentXPosition
    $PreviousYPosition     = $CurrentYPosition
    $PreviousZPosition     = $CurrentZPosition
    $PreviousDistanceTotal = $CurrentDistanceTotal
    $PreviousDistanceX     = $CurrentDistanceX
    $PreviousDistanceY     = $CurrentDistanceY
    $PreviousDistanceZ     = $CurrentDistanceZ
    $PreviousTime          = $CurrentTime
    $PreviousAngle         = $FinalAngle
    $PreviousAngleLocal      = $FinalAngleLocal
    $PreviousPlanetaryXCoord = $CurrentPlanetaryXCoord
    $PreviousPlanetaryYCoord = $CurrentPlanetaryYCoord
    $PreviousPlanetaryZCoord = $CurrentPlanetaryZCoord
    if($ShipRotationValueX1 -AND $ShipRotationValueX1 -ne $PerviousShipRotationValueX1){$PerviousShipRotationValueX1 = $ShipRotationValueX1}
    if($ShipRotationValueY1 -AND $ShipRotationValueY1 -ne $PerviousShipRotationValueY1){$PerviousShipRotationValueY1 = $ShipRotationValueY1}
    if($ShipRotationValuez1 -AND $ShipRotationValueZ1 -ne $PerviousShipRotationValueZ1){$PerviousShipRotationValueZ1 = $ShipRotationValueZ1}
    $ScriptLoopCount ++

    }
    else{
        #Write-Host "no change"
    }
}

if ($script:ReloadForm){
    #$LiveResults.Text = $FinalInstructions
    $LiveResults.Text = ($FinalInstructions | Format-Table -Property @{Name="Step"; Expression={$_.Step}; Align="Center"},Type,Direction,QuantumMarker,@{Name="JumpDistance"; Expression={$_.JumpDistance}; Align="Right"},@{Name="TargetDistance"; Expression={$_.TargetDistance}; Align="Right"} -AutoSize | Out-String)
    $LiveResults.Text = Get-Process | Out-String
    $LiveResults
    Show-Frontend
    #$Form.Refresh()
    $script:ReloadForm = $false
}
#KEEP LAST RESULTS OPEN, AND EXIT SCRIPT IF USER PRESSES ENTER
Pause


#ToDo
# DeltaDistance 
# is fine positive
# adds 1km if negative

#ToDo #2
# Frontend
# Select System = Stanton, Pyro (Dropdown)
# Select Destination Type = Space, Orbital, Custom Space 
# Create different tabs for each type