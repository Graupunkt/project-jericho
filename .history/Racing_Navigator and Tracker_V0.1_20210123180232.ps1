##################
### Parameters ###
##################
$debug = $false
$debug = $true 

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

##################
### DATAGROUPS ###
##################

$DataGroupDaymarRally = @(
    "Daymar - Rally 2950"    
    "Daymar - Rally 2951"    
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

#################
### FRONTEND ###
#################

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
    $TextBox.text = "    Custom Coordinates:" 
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

#############################
### START 3RD PARTY TOOLS ###
#############################
#DETERMINE SCRIPT PATH WITHIN VSCODE, iSE OR POWERSHELL
if($env:TERM_PROGRAM -eq "vscode"){$script:ScriptDir = $psEditor.GetEditorContext().CurrentFile.Path -replace '[^\\]+$'}
if($psISE){$script:ScriptDir = Split-Path -Path $psISE.CurrentFile.FullPath}
if((Get-Host).Version.Major -gt "5"){$script:ScriptDir = $PSScriptRoot}
else{$script:ScriptDir = $PSScriptRoot}

#START §RD PARTy IF
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
    $ClipboardContent = ("Coordinates: X:0 y:0 z:0").split(":").Split(" ")
    #Add-Type -AssemblyName System.Windows.Forms
    $ScreenResolution = [System.Windows.Forms.Screen]::AllScreens
    $WindowSizeX = 25
    $WindowSizeY = 85
    $MaxX = $ScreenResolution[0].WorkingArea.Width -720 
    #$MaxY = $ScreenResolution[0].WorkingArea.Height
    Move-Window $MaxX 5
    Set-WindowSize $WindowSizeX $WindowSizeY
    Keep-ConsoleOnTop
}

##############################
### MAIN FUNCTION / SCRIPT ###
##############################






#CLEAR OLD VARIABLES
$SelectedDestination = @{}

if($debug){Write-Host "Start Navigation $StartNavigation"}