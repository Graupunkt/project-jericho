# Script to use CIG Coordinate System with Status Update

############
### TODO ###
############
# CHECK CELL AD6 (HOUR ANGLE) IN MURPHYS SHEET with scripts
# there might be a wrong conversion (global to local xyz coords) when exceeding 360° , might wanna output script hour angle each update
# The first issue could explain all our sketches. 
# Maybe CIG uses a formula or logic because the data mined values are slightly inaccurate.For example arccorp we have a rotation speed of 4.1099999 or 4,2 hours, but if we apply a logic to like 4.1099999999999 (9 period), its more accurate. So over time the scripts deviates from cig servers rotation



##################
### Parameters ###
##################
#DISABLE FOR DEBUGGING !!!
#$ErrorActionPreference = 'SilentlyContinue'
#$debug = $false
#$debug = $true 

#SELECT CURRENT POI / DESTINATION FROM HASBTABLE LINE 22
$DistanceGreen = 1000      # Set Distance in meters when values should turn green (1km)
$DistanceYellow = 100000    # Set Distance in meters when values should turn yellow (100km)
$QMDistanceGreen = 100000    # QM Distance Green
$QMDistanceYellow = 1000000   # QM Distance Yellow

#GLOBAL PARAMETERS
$Playername = "Graupunkt"
$CustomCoordsProvided = $false  #set to false per default, in case nothing was selected in gui or script is run again 
$StartNavigation = $true
$script:PlanetaryPoi = $false  
$Powershellv5Legacy = $false   
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
$WaitCount = 0
$UserComment = "no comment"



#Set-StrictMode -Version 2.0    #Display all errors while directly running script
#Set-Location -Path $PSScriptRoot

#################
### FUNCTIONS ###
#################
#DETERMINE SCRIPT PATH WITHIN VSCODE, iSE OR POWERSHELL
#if($env:TERM_PROGRAM -eq "vscode"){$script:ScriptDir = $psEditor.GetEditorContext().CurrentFile.Path -replace '[^\\]+$'}

#$ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path
if($psISE){$script:ScriptDir = Split-Path -Path $psISE.CurrentFile.FullPath}
if((Get-Host).Version.Major -gt "5"){$script:ScriptDir = $PSScriptRoot}else{$script:ScriptDir = $PSScriptRoot}
if($env:TERM_PROGRAM -eq "vscode"){$script:ScriptDir = "C:\Users\marcel\Desktop\StarCitizen Tools\Projekt Jericho (3D Navigation)_V6"}
Set-Location $script:ScriptDir

#Import Functions defined in dedicated files
# IF SCRIPT STOPS, SOME OF THESE FUNCTION FILES MGIHT BE BUGGED
# LAST TIME IT WAS BROKEN, A FUNCTIONS BRACKET WAS WRITTEN IN THE NEXT LINE INSTEAD BEHIND THE FUNCTION

#FOR VS CODE, HAS NO IMPACT ON POWERSHELL SCRIPT DIRECTLY
#Set-Location "C:\Users\marcel\Desktop\StarCitizen Tools\Projekt Jericho (3D Navigation)_V6"
#IMPORT FUNCTIONS
#. '.\functions\Calculations Planetary.ps1'
function PPP{
    if($script:PlanetaryPoi){
        #GET UTC SERVER TIME, ROUND MILLISECONDS IN 166ms steps (6 to 1 second conversion)
        $ElapsedUTCTimeSinceSimulationStart = Get-ElapsedUTCServerTime
    
        #GET ORBITAL COORDINATES
        $SelectedDestination = $PointsOfInterestOnPlanetsData.GetEnumerator() | Where-Object { $_.Name -eq $script:CurrentDestination }
        $PoiCoordDataPlanet = $SelectedDestination.ObjectContainer
        $PoiCoordDataX = $SelectedDestination.'Planetary X-Coord'
        $PoiCoordDataY = $SelectedDestination.'Planetary Y-Coord'
        $PoiCoordDataZ = $SelectedDestination.'Planetary Z-Coord'
    
        #GET THE PLANETS COORDS IN STANTON
        #$SelectedPlanet = $ObjectContainerData.GetEnumerator() | Where-Object { $_.Key -eq $CurrentPlanet}
        $SelectedPlanet = $ObjectContainerData.GetEnumerator() | Where-Object { $_.Name -eq $PoiCoordDataPlanet}
        #$SelectedPlanet = $ObjectContainerData.GetEnumerator() | Where-Object { $_.Key -eq $script:CurrentDetectedObjectContainer}
        #$PlanetDataParsed = $SelectedPlanet.Value -Split ";"
        $PlanetCoordDataX = $SelectedPlanet.'X-Coord'/1000
        $PlanetCoordDataY = $SelectedPlanet.'Y-Coord'/1000
        $PlanetCoordDataZ = $SelectedPlanet.'Z-Coord'/1000
        $PlanetRotationSpeed = $SelectedPlanet.RotationSpeedX
        $PlanetRotationStart = $SelectedPlanet.RotationAdjustmentX
        $PlanetOMRadius = $SelectedPlanet.OrbitalMarkerRadius
    
    
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
    }

#. '.\functions\Calculations Space.ps1'
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
    if($winkel_degree){Return $winkel_degree}
}

#. '.\functions\Dynamic Forms GUI.ps1'
Function Show-Frontend {
    $script:MainForm.ShowDialog()| Out-Null
    #$script:MainForm.Add_Shown({$Form.Activate()})
    #[void]$script:MainForm.ShowDialog() | Out-Null
}

function New-DynamicFormMainframe{
    
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
    $CustomWidth = 960
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
    $StatusStrip.Left = 0
    $StatusStrip.Visible = $true
    $StatusStrip.Enabled = $true
    $StatusStrip.Dock = [System.Windows.Forms.DockStyle]::Bottom
    $StatusStrip.Anchor = [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Left
    #$StatusStrip.LayoutStyle = [System.Windows.Forms.ToolStripLayoutStyle]::Table
    $StatusStrip.LayoutStyle = [System.Windows.Forms.ToolStripLayoutStyle]::HorizontalStackWithOverflow
    #$StatusStrip.BorderSides = "Left"
    #$StatusStrip.BorderStyle = "Etched"

    $Copyright = [System.Windows.Forms.ToolStripLabel]::new()
    $Copyright.Name = 'Copyright'
    $Copyright.Text = "© [VORA] Graupunkt, [DSC] Murphy, [IFE] Xabdiben, BigCheese"
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
    #$SupportLink.LinkBehavior = System.Windows.Forms.LinkBehavior.AlwaysUnderline
    $SupportLink.Text = "https://www.guilded.gg/projectjericho"
    $SupportLink.Tag = "https://www.guilded.gg/projectjericho"
    $SupportLink.Width = 50
    $SupportLink.Visible = $true
    $SupportLink.add_Click({Invoke-Expression "explorer.exe $($SupportLink.Text)"})

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
    $Legend.Name = "Legend"
    $Legend.text = "Legend" 
    
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
    $MainForm.Controls.Add($Legend)

    #################
    ### LIMIT BOX ###
    #################
    $Limits = New-Object System.Windows.Forms.GroupBox
    $Limits.Location = New-Object System.Drawing.Size(760,5) 
    $Limits.size = New-Object System.Drawing.Size(250,120) 
    $Limits.text = "Limits (meters)" 
    $Limits.Name = "Limits"  

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
    $MainForm.Controls.Add($Limits)

    #####################
    ### 3RD PARTY BOX ###
    #####################
    $3rdPartyBox = New-Object System.Windows.Forms.GroupBox
    $3rdPartyBox.Location = New-Object System.Drawing.Size(1020,5) 
    $3rdPartyBox.size = New-Object System.Drawing.Size(200,120) 
    $3rdPartyBox.text = "3rd Party Tools Autostart" 
    $3rdPartyBox.Name = "3rd Party Tools Autostart" 
    
    # First Tool
    $ToolShowLocation = New-Object System.Windows.Forms.CheckBox
    $ToolShowLocation.Location = new-object System.Drawing.Point(5,20) 
    $ToolShowLocation.size = New-Object System.Drawing.Size(185,20)
    $ToolShowLocation.Text = "Update Location Hotkey" 
    $ToolShowLocation.Name = "Update Location Hotkey" 
    $3rdPartyBox.Controls.Add($ToolShowLocation) 

    # Second Tool
    $ToolAntilogoff = New-Object System.Windows.Forms.CheckBox
    $ToolAntilogoff.Location = new-object System.Drawing.Point(5,40) 
    $ToolAntilogoff.size = New-Object System.Drawing.Size(185,20)
    $ToolAntilogoff.Text = "Anti-Logoff" 
    $ToolAntilogoff.Name = "Anti-Logoff" 
    $3rdPartyBox.Controls.Add($ToolAntilogoff) 

    # Third Tool
    $ToolShowOnTop = New-Object System.Windows.Forms.CheckBox
    $ToolShowOnTop.Location = new-object System.Drawing.Point(5,60) 
    $ToolShowOnTop.size = New-Object System.Drawing.Size(185,20)
    $ToolShowOnTop.Text = "ShowOnTop" 
    $ToolShowOnTop.Name = "ShowOnTop" 
    $3rdPartyBox.Controls.Add($ToolShowOnTop) 

    # Fourth Tool
    $ToolAutorun = New-Object System.Windows.Forms.CheckBox
    $ToolAutorun.Location = new-object System.Drawing.Point(5,80) 
    $ToolAutorun.size = New-Object System.Drawing.Size(185,20)
    $ToolAutorun.Text = "AutoRun Toggle"
    $ToolAutorun.Name = "AutoRun Toggle" 
    $3rdPartyBox.Controls.Add($ToolAutorun) 

    # Fifth Tool
    $ToolHudCrosshair = New-Object System.Windows.Forms.CheckBox
    $ToolHudCrosshair.Location = new-object System.Drawing.Point(5,100) 
    $ToolHudCrosshair.size = New-Object System.Drawing.Size(185,20)
    $ToolHudCrosshair.Text = "HUD Crosshair"
    $ToolHudCrosshair.Name = "HUD Crosshair" 
    $ToolHudCrosshair.Checked = $False
    $3rdPartyBox.Controls.Add($ToolHudCrosshair) 

    $MainForm.Controls.Add($3rdPartyBox) 

    ##########################
    ### CUSTOM COORDINATES ###
    ##########################
    $TextBox = New-Object System.Windows.Forms.GroupBox
    $TextBox.Location = New-Object System.Drawing.Size(500,5) 
    $TextBox.size = New-Object System.Drawing.Size(250,120) 
    $TextBox.text = "    Stanton Coordinates:" 
    $TextBox.Name = "Stanton Coordinates"
    

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

    $MainForm.Controls.Add($TextBox) 

    ################
    #Check if button was pressed and add tool to array
    if ($ToolAntilogoff.Checked   -eq $true){$script:ListOfToolsToStart += "ToolAntilogoff"}
    if ($ToolShowLocation.Checked -eq $true){$script:ListOfToolsToStart += "ToolShowLocation"}
    if ($ToolShowOnTop.Checked    -eq $true){$script:ListOfToolsToStart += "ToolShowOnTop"}
    if ($ToolAutorun.Checked      -eq $true){$script:ListOfToolsToStart += "ToolAutorun"}

    Write-Verbose "starting"
    $script:MainForm.ShowDialog()| Out-Null
}

function Get-CheckboxesFromFormMainframe{
    #DEFINE VARIABLES AND ACTIONS FOR EACH BUTTON
    $debug = $false
    foreach ($Box in $script:MainForm.Controls){
        switch -WildCard ($Box.Name){
            #Destinations, QuantumMarkers, StatusStrip, Legend, Limits, 3rd Party Tools Autostart, Stanton Coordinates
            "*Destinations"                {foreach ($Checkbox in $Box.Controls){if($Checkbox.Checked){$script:CurrentDestination = $Checkbox.Name.replace('Option_',"")}}}
            "*QuantumMarker"               {foreach ($Checkbox in $Box.Controls){if($Checkbox.Checked){if($debug){Write-Host $Checkbox.Name};$script:CurrentQuantumMarker += $Checkbox.Name.replace('Option_',"")}}}
            "*Stanton Coordinates*"        {foreach ($Checkbox in $Box.Controls){if($Checkbox.Checked){$script:CustomCoordsProvided = $True}}}
            "*3rd Party Tools Autostart*"  {foreach ($Checkbox in $Box.Controls){if($Checkbox.Checked){if($Checkbox.Name -like "HUD Crosshair"){$script:HudCrosshair = $True}}}}
            #default                 {if($debug){Write-Host $Box.Name}}
        }
    }
}

#. '.\functions\Generic.ps1'
function Get-NTPDateTime{
    param ($sNTPServer)
    # $sNTPServer = "ptbtime1.ptb.de"
    $StartOfEpoch=New-Object DateTime(1900,1,1,0,0,0,[DateTimeKind]::Utc)  
    [Byte[]]$NtpData = ,0 * 48
    $NtpData[0] = 0x1B    # NTP Request header in first byte
    $Socket = New-Object Net.Sockets.Socket([Net.Sockets.AddressFamily]::InterNetwork, [Net.Sockets.SocketType]::Dgram, [Net.Sockets.ProtocolType]::Udp)
    $Socket.Connect($sNTPServer,123)
     
    $t1 = Get-Date    # Start of transaction... the clock is ticking...
    [Void]$Socket.Send($NtpData)
    [Void]$Socket.Receive($NtpData) 
    $t4 = Get-Date    # End of transaction time
    $Socket.Close()
 
    $IntPart = [BitConverter]::ToUInt32($NtpData[43..40],0)   # t3
    $FracPart = [BitConverter]::ToUInt32($NtpData[47..44],0)
    $t3ms = $IntPart * 1000 + ($FracPart * 1000 / 0x100000000)
 
    $IntPart = [BitConverter]::ToUInt32($NtpData[35..32],0)   # t2
    $FracPart = [BitConverter]::ToUInt32($NtpData[39..36],0)
    $t2ms = $IntPart * 1000 + ($FracPart * 1000 / 0x100000000)
 
    $t1ms = ([TimeZoneInfo]::ConvertTimeToUtc($t1) - $StartOfEpoch).TotalMilliseconds
    $t4ms = ([TimeZoneInfo]::ConvertTimeToUtc($t4) - $StartOfEpoch).TotalMilliseconds
  
    $Offset = (($t2ms - $t1ms) + ($t3ms-$t4ms))/2
     
    [DateTime]$NTPDateTime = $StartOfEpoch.AddMilliseconds($t4ms + $Offset).ToLocalTime()
    return $NTPDateTime#, $Offset
}

function Clear-Variables{
    #CLEAR ALL VARIABLES FROM RPEVIOUS RUN
    if($debug){
        $DefaultVariables = Get-Variable -Scope GLOBAL
        $DefaultVariables += "debug"
        $DefaultVariables += "ErrorActionPreference"
        $ExcludeList = $DefaultVariables.Name -join ','
        Get-Variable -Exclude $ExcludeList | Clear-Variable 
        Remove-Module *
        if($error){$error.Clear()}
    }
}

function Set-AdminPermissions{
    If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
        Start-Process powershell.exe "-noProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
        Exit
    }
}

#. '.\functions\Hotkeys and game interactions.ps1'
function Test-KeyPress{
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
            [Console]::Beep(1800, 200)
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
            #

            # return $false
            $false
        }
    }
}

#. '.\functions\StarCitizen Generic.ps1'
function Get-ElapsedUTCServerTime{
    param ($DateTime)
    $UTCServerTime = $DateTime.ToUniversalTime() 
    #SET STARTTIME SIMULATION STARCITIZEN
    $SimulationUTCStartTime = [DateTime]"01.01.2020 00:00:00"                                                    # SET STARTTIME SIMULATION UTC
    $result = New-Timespan -End $UTCServerTime -Start $SimulationUTCStartTime     # GET ELPASED TIME BETWEEN SIMULATION TIME AND CURRENT TIME
    Write-Output $result
}

function Get-ElapsedUniverseTime{
    $SimulationServerStartTime = [DateTime] "01.01.2950 00:00:00"
    $SimulationTimeFactor = 6
}

function Get-StarCitizenClipboardAndDate{ 
    param ($PCClockdrift) #Required to fetch the ntp server only once
    #. '.\functions\Generic.ps1'
    #GET CURRENT TIME AND APPLY CLCOK DRIFT
    $ClipboardContentRAW = (Get-Clipboard) -replace '(^\s+|\s+$)','' -replace '\s+',' '
    $DateTimeCurrent = Get-Date
    if($PCClockdrift){
        $DateTime = $DateTimeCurrent + $PCClockdrift
    }else{
        $DateTime = $DateTimeCurrent
    }

    #CHECK IF CLIPBOARD CONTAINS COORDINATES
    if($ClipboardContentRAW -like '*Coordinates: x:*'){
        #if($CurrentXPosition -ne $PreviousXPosition -or $CurrentYPosition -ne $PreviousYPosition -or $CurrentZPosition -ne $PreviousZPosition){
            $ClipboardContainsCoordinates = $true 
            $ClipboardContentSplit = $ClipboardContentRAW.split("x:").split("y:").split("z:") #GET CURRENT COORDS FROM CLIPBOARD
            $CurrentXPosition = $ClipboardContentSplit[3]
            $CurrentYPosition = $ClipboardContentSplit[5]
            $CurrentZPosition = $ClipboardContentSplit[7]
            if(!$CurrentZPosition){
                $CurrentXPosition = $ClipboardContentSplit[1]
                $CurrentYPosition = $ClipboardContentSplit[2]
                $CurrentZPosition = $ClipboardContentSplit[3]
            }
    }else{
        #$CurrentXPosition = $null
        #$CurrentYPosition = $null
        #$CurrentZPosition = $null
        $ClipboardContainsCoordinates = $false
    }
    Write-Output $ClipboardContainsCoordinates, $CurrentXPosition, $CurrentYPosition, $CurrentZPosition, $DateTime
}

#. '.\functions\Window settings and controls.ps1'
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
    
function Set-ConsoleOpacity {
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
    #return $CrosshairXPixels, $CrosshairYPixels
    Start-process "Crosshair Overlay.exe" -ArgumentList "$CrosshairXPixels $CrosshairYPixels"
}

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

#ENABLE BUILTIN POWERSHELL V5 SUPPORT
if((Get-Host).Version.Major -eq "5"){
    $Powershellv5Legacy = $true
    #$StartNavigation = $true
    Write-Host -ForegroundColor Red "Please install and run with powershell v7"
}

###################
### IMPORT DATA ###
###################
# FILE LOCATIONS
$OcCsvPath = "data\Script_Project Jericho_Values for Object Containers.csv"
$PoiPlanetsCsvPath = "data\Script_Project Jericho_Points of Interest on Planets and ObjectContainers.csv"
$PoiSpaceCsvPath = "data\Script_Project Jericho_Points of Interest in 3D Space.csv"

# IMPORT FILES TO ARRAY
$ObjectContainerData =              Import-Csv -Delimiter ";" $OcCsvPath            | Where-Object {$_.System -notlike "*#*"} #| Select-Object -Skip 1
$PointsOfInterestOnPlanetsData =    Import-Csv -Delimiter ";" $PoiPlanetsCsvPath    | Where-Object {$_.System -notlike "*#*"} | Select-Object -Skip 1
$PointsOfInterestInSpaceData =      Import-Csv -Delimiter ";" $PoiSpaceCsvPath      | Where-Object {$_.System -notlike "*#*"} #| Select-Object -Skip 1

# FILTER FOR SPECIFIC VALUES AND SET ANOTHER ARRAY
$DataGroupDestinations = $PointsOfInterestOnPlanetsData.Name
$DataGroupDestinations += $PointsOfInterestInSpaceData.Name

# RUN SCRIPT WITH ADMIN PERMISSIONS
#if(!$debug){Set-AdminPermissions}

# Create GUI
New-DynamicFormMainframe
#Show-Frontend 
Get-CheckboxesFromFormMainframe

#DETERMINE IF DESTINATION IS ON A PLANET, WITHIN AN OBJECT CONTAINER OR IN SPACE
switch($script:CurrentDestination){
    {$_ -in $PointsOfInterestOnPlanetsData.Name} {$script:PlanetaryPoi = $true}
    {$_ -in $PointsOfInterestInSpaceData.Name} {$script:3dSpacePoi = $true}
}

switch($Script:CurrentPlayerPosition){
    {$true} {$true}
    # if debug mode show all values
    #Space, if not in an object conainter
    #if ObjectContainer, if within an objectcontainer and above OM Radius
        #if Planet, if 1000m above planet radius or below OM Radius + 10.000m
        #if Ground, if 1000m above or below planet radius
        #else ObjecContainer
}


###################
### MAIN SCRIPT ###
###################


#START 3RD PARTY TOOLS
#foreach ($Tool in $script:ListOfToolsToStart){
#    switch ($Tool){
#        "ToolAntiLogoff" {$3rdPartyFileName = "Autoit Scripts\AntiLogoffScript_V2.ahk"}
#        "ToolShowLocation" {$3rdPartyFileName = "Showlocation_Hotkey ALT-R or LEFTCTRL+ALT_RunAsAdmin.exe"}
#        "ToolShowOnTop" {$3rdPartyFileName = "WindowTop.exe"}
#        "ToolAutorun" {$3rdPartyFileName = "Autoit Scripts\autorun.ahk"}
#    }
#    if(get-process | Where-Object {$_.path -like "*$3rdPartyFileName"} -ea SilentlyContinue){
        #Process is already running
#    }
#    else{Start-process -FilePath "$ScriptDir\$3rdPartyFileName"}
#}c


if ($ScriptLoopCount -eq 0){
    #Add-Type -AssemblyName System.Windows.Forms
    $ScreenResolution = [System.Windows.Forms.Screen]::AllScreens
    $WindowSizeY = 38
    $WindowSizeX = 95
    $MaxX = $ScreenResolution[0].WorkingArea.Width -800 
    #$MaxY = $ScreenResolution[0].WorkingArea.Height
    Move-Window $MaxX 15 | Out-Null
    if($ScreenResolution){Set-WindowSize $WindowSizeY $WindowSizeX}
    Set-ConsoleAlwaysOnTop | Out-Null
    #Set-ConsoleBordersRemoval
    Set-ConsoleOpacity 90
}



$NTPServer = "ptbtime1.ptb.de"
$NTPServer = @("ptbtime1.ptb.de","ptbtime2.ptb.de","ptbtime3.ptb.de")  #Array of multiple servers, in case of multuple users or starts of the script, a random ntp server is contacted
$DateTimeNTP = Get-NTPDateTime (Get-Random $NTPServer)
$DateTimePC = Get-Date
$PCClockdrift = $DateTimeNTP - $DateTimePC

If(!(test-path "Logs"))
{
      New-Item -ItemType Directory -Force -Path "Logs"
}

$CsvFilename = "Logs\history_local_$($DateTime.ToString('yyyy.MM.dd')).csv"
$LogFilename = "Logs\Logfile.csv"
#Write-Host -ForegroundColor Yellow $DateTime.ToString('HH:mm:ss:ffff')

#CLEAR OLD VARIABLES
#$SelectedDestination = @{}

#IDEA 
# REGISTER FINAL ENTER SEND TO STARCITIZEN AND GRAB TIMESTAMP
# RUN MULTIPLE SCRIPTS AT THE SAME TIME TO CHECK TIME DIAVATION ?!

#CHECK CLIPBOARD FOR NEW VALUES 
while($StartNavigation) {
    #Start-Sleep -Milliseconds 1            # IF THIS LINE IS NOT PRESENT, CPU USAGE WILL CONSUME A FULL THREAD, AND SCRIPTS MIGHT GET UNRESPONSIVE 
    #Get ClipboardContents and Get Current Date/Time
    $ClipboardContainsCoordinates, $CurrentXPosition, $CurrentYPosition, $CurrentZPosition, $DateTime = Get-StarCitizenClipboardAndDate $PCClockdrift
    #Write-Host $CurrentXPosition, $CurrentYPosition, $CurrentZPosition

    ### KEY TO SAVE CURRENT COORDINATES TO TEXTFILE ###
    # CODE BY BIGCHEESE
    $pressed = Test-KeyPress -Key "S" -ModifierKey 'Control'
    if ($pressed) {
        $PoiName = Read-Host -Prompt 'Input the name of the POI: '
        #$SystemName = Read-Host -Prompt 'Input the Systemname your currently in (Stanton, Pyro, Nyx): '
        #$SystemName = "Stanton"
        $SystemName = $script:CurrentDetectedSystem
        if($script:CurrentDetectedObjectContainer){$PoiToSave = "$SystemName;$CurrentDetectedObjectContainer;CustomType;$PoiName;$CurrentPlanetaryXCoord;$CurrentPlanetaryYCoord;$CurrentPlanetaryZCoord;$DateTime"} #IF ON A PLANET
        else {$PoiToSave = "$SystemName;Custom POI Type;$PoiName;$CurrentXPosition;$CurrentYPosition;$CurrentZPosition;$DateTime"} #ELSE IF IN SPACE
        $PoiToSave  >> 'Data\saved_locations.csv' #WRITE CURRENT LINES TO TEXTFILE
        Write-Host "... saved $PoiName to Data\saved_locations.csv"
    }

    #ADJUST PLANETARY ROTATION DEVIATION
    $ResetPressed = Test-KeyPress -Key "R" -ModifierKey 'Control'
    if ($ResetPressed) {
        #$CurrentPlanetaryXCoord = ""
        #$CurrentDetectedOCRadius = ""
        #$CurrentDetectedOCADX = ""

        $Circumference360Degrees = [Math]::PI * 2 * $CurrentDetectedOCRadius
        #Very high or low values are presented by ps as scientific results, therefore we force the nubmer (decimal) and limit it to 7 digits after comma
        #Multiplied by 1000 to convert km into m and invert it to correct the deviation
        $RotationSpeedAdjustment = [Math]::Round(($CurrentPlanetaryXCoord * 1000 * 360 / $Circumference360Degrees) -as [decimal],7) * -1
        #GET Adjustment for Rotationspeed 
        $FinalRotationAdjustment = ([double]$CurrentDetectedOCADX + [double]$RotationSpeedAdjustment)
        #Write-Host "OMRadius $CurrentDetectedOCRadius"
        #Write-Host "Circumference $Circumference360Degrees "
        #Write-Host "Speed $RotationSpeedAdjustment"
        #Write-Host "Adjustment $FinalRotationAdjustment"
        #Write-Host "X-Coord $CurrentPlanetaryXCoord"
        (Get-Content $OcCsvPath).replace($CurrentDetectedOCADX, $FinalRotationAdjustment) | Set-Content $OcCsvPath
        Write-Host "Rotation calibrated from $($CurrentDetectedOCADX)° to $($FinalRotationAdjustment)° by $RotationSpeedAdjustment, pls restart script"
        Pause
        Start-Process "powershell.exe" -ArgumentList '-NoExit', '-File', $script:MyInvocation.MyCommand.Path
        Pause
        Exit
    }

    $pressed = Test-KeyPress -Key "T" -ModifierKey 'Control'
    if ($pressed) {
        $UserCommentPrev = Read-Host -Prompt 'Comment the previous updated position: '
        (Get-Content $LogFilename -raw) -replace ("(?s)(.*)no comment","`$1$UserCommentPrev") | Out-File $LogFilename

    }

    #USE CUSTOM 3D SPACE COORDINATES IF PROVIDED
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
            #$LiveResults.Text = $ErrorMessageCustomCoords
            #Show-Frontend
        }

    }


    #################################################
    ### POI ON ROTATING OBJECT CONTAINER, PLANETS ###
    #################################################
    if($script:PlanetaryPoi){
        #GET UTC SERVER TIME, ROUND MILLISECONDS IN 166ms steps (6 to 1 second conversion)
        #Function currently prevents script from continuing
        #$ErrorActionPreference = "SilentlyContinue"
        $ElapsedUTCTimeSinceSimulationStart = Get-ElapsedUTCServerTime $DateTime
        #$ElapsedUTCTimeSinceSimulationStart.TotalDays
        #GET ORBITAL COORDINATES
        $SelectedDestination = $PointsOfInterestOnPlanetsData.GetEnumerator() | Where-Object { $_.Name -eq $script:CurrentDestination }
        $PoiCoordDataPlanet = $SelectedDestination.ObjectContainer
        $PoiCoordDataX = $SelectedDestination.'Planetary X-Coord'
        $PoiCoordDataY = $SelectedDestination.'Planetary Y-Coord'
        $PoiCoordDataZ = $SelectedDestination.'Planetary Z-Coord'

        #GET THE PLANETS COORDS IN STANTON
        #$SelectedPlanet = $ObjectContainerData.GetEnumerator() | Where-Object { $_.Key -eq $CurrentPlanet}
        $SelectedPlanet = $ObjectContainerData.GetEnumerator() | Where-Object { $_.Name -eq $PoiCoordDataPlanet}
        #$SelectedPlanet = $ObjectContainerData.GetEnumerator() | Where-Object { $_.Key -eq $script:CurrentDetectedObjectContainer}
        #$PlanetDataParsed = $SelectedPlanet.Value -Split ";"
        $PlanetCoordDataX = $SelectedPlanet.'X-Coord'/1000
        $PlanetCoordDataY = $SelectedPlanet.'Y-Coord'/1000
        $PlanetCoordDataZ = $SelectedPlanet.'Z-Coord'/1000
        $PlanetRotationSpeed = $SelectedPlanet.RotationSpeedX
        $PlanetRotationStart = $SelectedPlanet.RotationAdjustmentX
        $PlanetOMRadius = $SelectedPlanet.OrbitalMarkerRadius

  
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
        #$SelectedDestination = $PointsOfInterestInSpaceData.GetEnumerator() | Where-Object { $_.Key -eq $script:CurrentDestination } #UNCOMMENT AGAIN !!!!!!!!!!!!!!!!!!!!!!!!
        $SelectedDestination = $PointsOfInterestInSpaceData.GetEnumerator() | Where-Object { $_.Name -eq $script:CurrentDestination } 
        #$DestCoordData = $SelectedDestination.Value -Split ";"
        $DestCoordDataX = $SelectedDestination.'Stanton X-Coord'
        $DestCoordDataY = $SelectedDestination.'Stanton Y-Coord'
        $DestCoordDataZ = $SelectedDestination.'Stanton Z-Coord'
        #$script:DestPlanet = $SelectedDestination.'ObjectContainer'
    }
    

    if(($CurrentXPosition -ne $PreviousXPosition -or $CurrentYPosition -ne $PreviousYPosition -or $CurrentZPosition -ne $PreviousZPosition) -and $ClipboardContainsCoordinates){
        $CoordinatesSubmitted = $true
        if ($script:CustomCoordsProvided){
        $DestinationName = $SelectedDestination.Keys
    }
    else {
        $DestinationName = $SelectedDestination.Name
    }

    #GET CURRENT TIME AND SAVE PREVIOUS VALUES
    #$DateTime = Get-Date # REPLACE WITH $DATETIME
    if($PreviousTime){
        $LastUpdateRaw1 = $DateTime - $PreviousTime
    }
    else{
        $LastUpdateRaw1 = $DateTime
    }
    switch ($LastUpdateRaw1){
        {$_.Hours} {$LastUpdate = '{0:00}h {1:00}min {2:00}sec' -f $LastUpdateRaw1.Hours,$LastUpdateRaw1.Minutes,$LastUpdateRaw1.Seconds; break}
        {$_.Minutes} {$LastUpdate = '{1:00}min {2:00}sec' -f $LastUpdateRaw1.Hours,$LastUpdateRaw1.Minutes,$LastUpdateRaw1.Seconds; break}
        {$_.Seconds} {$LastUpdate = '{2:00}sec' -f $LastUpdateRaw1.Hours,$LastUpdateRaw1.Minutes,$LastUpdateRaw1.Seconds; break}
    }
    if(!$env:TERM_PROGRAM -eq 'vscode') {
        Clear-Host
      }
    Write-Host -ForegroundColor DarkGray -NoNewLine "Updated:".PadLeft(12)
    Write-Host -ForegroundColor White    -NoNewLine "$($DateTime.ToString('HH:mm:ss'))".PadLeft(9)
    Write-Host -ForegroundColor DarkGray -NoNewLine  "last update:".PadLeft(15) #+2
    Write-Host -ForegroundColor White    -NoNewLine  "$LastUpdate".PadLeft(6) #-2
    Write-Host -ForegroundColor DarkGray -NoNewLine "Destination: ".PadLeft(15)
    Write-Host -ForegroundColor White               "$DestinationName"

    #Write-Host -ForegroundColor Yellow $DateTime.ToString('HH:mm:ss:ffff')

    #################################################################
    ### DETERMINE THE CURRENTOBJECT CONTAINER FROM STANTON COORDS ###
    #################################################################
    $script:CurrentDetectedObjectContainer = ""
    #DETECT CURRENT OC
    foreach ($ObjectContainer in $ObjectContainerData.GetEnumerator()){
        $ObjectContainerX         = $ObjectContainer.'X-Coord'
        $ObjectContainerY         = $ObjectContainer.'Y-Coord'
        $ObjectContainerZ         = $ObjectContainer.'Z-Coord'
        $ObjectContainerRotSpeed  = $ObjectContainer.RotationSpeedX
        $ObjectContainerRotAdjustW = $ObjectContainer.RotationAdjustmentW
        $ObjectContainerRotAdjust  = $ObjectContainer.RotationAdjustmentX
        $ObjectContainerRotAdjustY = $ObjectContainer.RotationAdjustmentY
        $ObjectContainerRotAdjustZ = $ObjectContainer.RotationAdjustmentZ
        $ObjectContainerOMRadius  = $ObjectContainer.OrbitalMarkerRadius
        $ObjectContainerBodyRadius  = $ObjectContainer.BodyRadius
        $OMRadiusExtra = 1.5

        $WithinX = $WithinY = $WithinZ = $false
        if([double]$ObjectContainerX -lt 0){if($CurrentXPosition -lt ([double]$ObjectContainerX - [double]$ObjectContainerOMRadius * $OMRadiusExtra) -AND $CurrentXPosition -gt ([double]$ObjectContainerX + [double]$ObjectContainerOMRadius * $OMRadiusExtra)){$WithinX = $true}}
        else {if([double]$CurrentXPosition -gt ([double]$ObjectContainerX - [double]$ObjectContainerOMRadius * $OMRadiusExtra) -AND [double]$CurrentXPosition -lt ([double]$ObjectContainerX + [double]$ObjectContainerOMRadius * $OMRadiusExtra)){$WithinX = $true}}

        if([double]$ObjectContainerY -lt 0){if($CurrentYPosition -lt ([double]$ObjectContainerY - [double]$ObjectContainerOMRadius * $OMRadiusExtra) -AND $CurrentYPosition -gt ([double]$ObjectContainerY + [double]$ObjectContainerOMRadius * $OMRadiusExtra)){$WithinY = $true}}
        else {if([double]$CurrentYPosition -gt ([double]$ObjectContainerY - [double]$ObjectContainerOMRadius * $OMRadiusExtra) -AND [double]$CurrentYPosition -lt ([double]$ObjectContainerY + [double]$ObjectContainerOMRadius * $OMRadiusExtra)){$WithinY = $true}}

        if([double]$ObjectContainerZ -lt 0){if($CurrentZPosition -lt ([double]$ObjectContainerZ - [double]$ObjectContainerOMRadius * $OMRadiusExtra) -AND $CurrentZPosition -gt ([double]$ObjectContainerZ + [double]$ObjectContainerOMRadius * $OMRadiusExtra)){$WithinZ = $true}}
        else {if([double]$CurrentZPosition -gt ([double]$ObjectContainerZ - [double]$ObjectContainerOMRadius * $OMRadiusExtra) -AND [double]$CurrentZPosition -lt ([double]$ObjectContainerZ + [double]$ObjectContainerOMRadius * $OMRadiusExtra)){$WithinZ = $true}}

        if($WithinX -and $WithinY -and $WithinZ){
            $script:CurrentDetectedSystem = $ObjectContainer.System
            $script:CurrentDetectedObjectContainer = $ObjectContainer.Name
            $script:CurrentDetectedOCX  = $ObjectContainerX
            $script:CurrentDetectedOCY  = $ObjectContainerY
            $script:CurrentDetectedOCZ  = $ObjectContainerZ
            $script:CurrentDetectedOCRS = $ObjectContainerRotSpeed
            $script:CurrentDetectedOCADX = $ObjectContainerRotAdjust
            $script:CurrentDetectedOCADW = $ObjectContainerRotAdjustW
            $script:CurrentDetectedOCADY = $ObjectContainerRotAdjustY
            $script:CurrentDetectedOCADZ = $ObjectContainerRotAdjustZ
            $script:CurrentDetectedOCRadius = $ObjectContainerOMRadius
            $script:CurrentDetectedBodyRadius = $ObjectContainerBodyRadius
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
    $OCJulianDate = $ElapsedUTCTimeSinceSimulationStart.TotalDays               #CORRECT
    $OCTotalCycles = $OCJulianDate / $OCLengthOfDayDecimal                      #CORRECT
    $OCCurrentCycleDez = $OCTotalCycles%1
    $OCCurrentCycleDeg = $OCCurrentCycleDez * 360
    $OCCurrentCycleAngle = [double]$script:CurrentDetectedOCADX + [double]$OCCurrentCycleDeg
    $OCReversedAngle = 360 - $OCCurrentCycleAngle
    $OCAngleRadian = $OCReversedAngle/180*[System.Math]::PI

    $PlanetRotationValueX1 = ([double]$PlanetDifferenceinX * ([math]::Cos($OCAngleRadian)) - [double]$PlanetDifferenceinY * ([math]::Sin($OCAngleRadian))) * -1
    $PlanetRotationValueY1 = ([double]$PlanetDifferenceinX * ([math]::Sin($OCAngleRadian)) + [double]$PlanetDifferenceinY * ([math]::Cos($OCAngleRadian))) * -1
    $ShipRotationValueZ1 = $CurrentZPosition / 1000
    $PlanetRotationValueZ1 = $ShipRotationValueZ1

    #DISPLAY CURRENT COORDS OF STANTON, PLANETARY AND POI
    #CONVERT CURRENT RESULTS FROM M OT KM (/1000) AND ROUND COORDINATES TO 3 DIGITS AFTER COMMA
    $CurrentPlanetaryXCoord = [math]::Round($PlanetRotationValueX1/1000, 3)
    $CurrentPlanetaryYCoord = [math]::Round($PlanetRotationValueY1/1000, 3)
    $CurrentPlanetaryZCoord = [math]::Round($PlanetRotationValueZ1, 3)

    #CONVERT DESTINATION COORDINATES INTO 3 DIGITS AFTER COMMA, TOO
    $CurrentDestinationXCoord = [math]::Round($PoiCoordDataX, 3)
    $CurrentDestinationYCoord = [math]::Round($PoiCoordDataY, 3)
    $CurrentDestinationZCoord = [math]::Round($PoiCoordDataZ, 3)

    #Total Distance Away
    #$PreviousDistanceTotalist = $curdist
    if($script:CurrentDetectedObjectContainer -eq $PoiCoordDataPlanet){
        $CurrentDistanceTotal = [math]::Sqrt([math]::pow($CurrentPlanetaryXCoord - $CurrentDestinationXCoord,2) + [math]::pow($CurrentPlanetaryYCoord - $CurrentDestinationYCoord,2) + [math]::pow($CurrentPlanetaryZCoord - $CurrentDestinationZCoord,2))*1000
        $CurrentDistanceX = [math]::Sqrt([math]::pow($CurrentPlanetaryXCoord - $CurrentDestinationXCoord,2))*1000
        $CurrentDistanceY = [math]::Sqrt([math]::pow($CurrentPlanetaryYCoord - $CurrentDestinationYCoord,2))*1000
        $CurrentDistanceZ = [math]::Sqrt([math]::pow($CurrentPlanetaryZCoord - $CurrentDestinationZCoord,2))*1000
    }
    else{
        $CurrentDistanceTotal = [math]::Sqrt([math]::pow($CurrentXPosition - $DestCoordDataX,2) + [math]::pow($CurrentYPosition - $DestCoordDataY,2) + [math]::pow($CurrentZPosition - $DestCoordDataZ,2))
        $CurrentDistanceX = [math]::Sqrt([math]::pow($CurrentXPosition - $DestCoordDataX,2))
        $CurrentDistanceY = [math]::Sqrt([math]::pow($CurrentYPosition - $DestCoordDataY,2))
        $CurrentDistanceZ = [math]::Sqrt([math]::pow($CurrentZPosition - $DestCoordDataZ,2))
    }

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
    <#
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
        $VTFontWhite = "97"
        #$VTFontDefault = "0"      #light Gray Text Color
        $VTFontDefault = "97"      #White Text Color
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
        $VTWhite = "$EscapeCharacter[${VTFontWhite}m"
        $VTDefault = "$EscapeCharacter[${VTFontDefault}m"
    }
    else{
        #>
        $EscapeCharacter = ""
        $VTGray = ""
        $VTRed = ""
        $VTYellow = ""
        $VTGreen = ""
        $VTGray = ""
        $VTDarkGray = ""
        $VTDefault = ""
    #}

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
    
    <# QMResults currently uses gigs of ram for calculations, therefore disabled
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
    #>


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

    $Selection = $PointsOfInterestInSpaceData | Where-Object {$_.Name -contains $SelectedDestination.Name}
    #$FinalCoordArray += $QuantummarkerDataGroup  # ADD ALL QUANTUM MARKER TO FINAL ARRAY
    $FirstCoordArray += $FinalCoordArray    # ADD ALL QUANTUM MARKER TO FIRST ARRAY TO DETERMINE STARTPOINT
    #$FirstCoordArray += $RestStopData       # ADD ALL RESTSTOPS TO FIRST ARRAY, THEY MIGHT COME IN HANDY AS STARTING POINT
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
    #$ShipRotationValueZ1 = $CurrentZPosition / 1000

    ##
    #$OCRotationValueX = [double]$script:CurrentDetectedOCX * ([math]::Cos($CurrentCycleAngle/180*[System.Math]::PI)) - [double]$script:CurrentDetectedOCY * ([math]::Sin($CurrentCycleAngle/180*[System.Math]::PI))
    #$OCRotationValueY = [double]$script:CurrentDetectedOCX * ([math]::Sin($CurrentCycleAngle/180*[System.Math]::PI)) + [double]$script:CurrentDetectedOCY * ([math]::Cos($CurrentCycleAngle/180*[System.Math]::PI))

    #CONVERT 3D SPACE INTO 
    if($script:3dSpacePoi)  {$PoiCoordDataPlanet = $DestinationName; $CurrentDestinationXCoord = $DestCoordDataX; $CurrentDestinationYCoord = $DestCoordDataY;$CurrentDestinationZCoord = $DestCoordDataZ} 

    #SHOW OM DISTANCES
    #$CurrentPlanetaryXCoord
    #$CurrentPlanetaryYCoord
    #$CurrentPlanetaryZCoord


    #Calculate Orbital Marker Distances for Current Position
    #First Value is in meters
    #Final Value is rounded in kilometers
    $OCRadius = $CurrentDetectedOCRadius/1000
    $OM1 = [math]::Pow(([math]::Pow("$CurrentPlanetaryXCoord","2") + [math]::Pow("$CurrentPlanetaryYCoord","2") + [math]::Pow($CurrentPlanetaryZCoord-$OCRadius,"2")),1/2)
    $OM2 = [math]::Pow(([math]::Pow("$CurrentPlanetaryXCoord","2") + [math]::Pow("$CurrentPlanetaryYCoord","2") + [math]::Pow($CurrentPlanetaryZCoord-(-$OCRadius),"2")),1/2)
    $OM3 = [math]::Pow(([math]::Pow("$CurrentPlanetaryXCoord","2") + [math]::Pow($CurrentPlanetaryYCoord-$OCRadius,"2") + [math]::Pow($CurrentPlanetaryZCoord,"2")),1/2)
    $OM4 = [math]::Pow(([math]::Pow("$CurrentPlanetaryXCoord","2") + [math]::Pow($CurrentPlanetaryYCoord-(-$OCRadius),"2") + [math]::Pow($CurrentPlanetaryZCoord,"2")),1/2)
    $OM5 = [math]::Pow(([math]::Pow($CurrentPlanetaryXCoord-$OCRadius,"2") + [math]::Pow("$CurrentPlanetaryYCoord","2") + [math]::Pow($CurrentPlanetaryZCoord,"2")),1/2)
    $OM6 = [math]::Pow(([math]::Pow($CurrentPlanetaryXCoord-(-$OCRadius),"2") + [math]::Pow("$CurrentPlanetaryYCoord","2") + [math]::Pow($CurrentPlanetaryZCoord,"2")),1/2)
    $FinalOM1 = [math]::Round(($OM1),2)
    $FinalOM2 = [math]::Round(($OM2),2)
    $FinalOM3 = [math]::Round(($OM3),2)
    $FinalOM4 = [math]::Round(($OM4),2)
    $FinalOM5 = [math]::Round(($OM5),2)
    $FinalOM6 = [math]::Round(($OM6),2)                          
    if($script:CurrentDetectedObjectContainer){$OrbitalMarkers = "OM Distance : ${VTDarkGray}OM1:${VTDefault}$FinalOM1${VTDarkGray}, OM2:${VTDefault}$FinalOM2${VTDarkGray}, OM3:${VTDefault}$FinalOM3${VTDarkGray}, OM4:${VTDefault}$FinalOM4${VTDarkGray}, OM5:${VTDefault}$FinalOM5${VTDarkGray}, OM6:${VTDefault} $FinalOM6"}
    else{$OrbitalMarkers = "OM Distance : ${VTRed}in Space${VTDefault}"}
    #Write-Host -ForegroundColor White "OM Distance :  ${VTDarkGray}OM1:${VTDefault} $FinalOM1"

    #OM DISTANCES FOR DESTINATION
    $DestinationOCRadius = ($ObjectContainerData.GetEnumerator() | Where-Object {$_.Name -contains $SelectedDestination.ObjectContainer}).BodyRadius
    $OCRadiusD = $DestinationOCRadius/1000

    $OM1D = [math]::Pow(([math]::Pow("$CurrentDestinationXCoord","2") + [math]::Pow("$CurrentDestinationYCoord","2") + [math]::Pow($CurrentDestinationZCoord-$OCRadiusD,"2")),1/2)
    $OM2D = [math]::Pow(([math]::Pow("$CurrentDestinationXCoord","2") + [math]::Pow("$CurrentDestinationYCoord","2") + [math]::Pow($CurrentDestinationZCoord-(-$OCRadiusD),"2")),1/2)
    $OM3D = [math]::Pow(([math]::Pow("$CurrentDestinationXCoord","2") + [math]::Pow($CurrentDestinationYCoord-$OCRadiusD,"2") + [math]::Pow($CurrentDestinationZCoord,"2")),1/2)
    $OM4D = [math]::Pow(([math]::Pow("$CurrentDestinationXCoord","2") + [math]::Pow($CurrentDestinationYCoord-(-$OCRadiusD),"2") + [math]::Pow($CurrentDestinationZCoord,"2")),1/2)
    $OM5D = [math]::Pow(([math]::Pow($CurrentDestinationXCoord-$OCRadiusD,"2") + [math]::Pow("$CurrentDestinationYCoord","2") + [math]::Pow($CurrentDestinationZCoord,"2")),1/2)
    $OM6D = [math]::Pow(([math]::Pow($CurrentDestinationXCoord-(-$OCRadiusD),"2") + [math]::Pow("$CurrentDestinationYCoord","2") + [math]::Pow($CurrentDestinationZCoord,"2")),1/2)
    $FinalOM1D = [math]::Round(($OM1D),2)
    $FinalOM2D = [math]::Round(($OM2D),2)
    $FinalOM3D = [math]::Round(($OM3D),2)
    $FinalOM4D = [math]::Round(($OM4D),2)
    $FinalOM5D = [math]::Round(($OM5D),2)
    $FinalOM6D = [math]::Round(($OM6D),2)
    if($script:PlanetaryPoi){$OrbitalMarkersD = "Destination : ${VTDarkGray}OM1:${VTDefault}$FinalOM1D${VTDarkGray}, OM2:${VTDefault}$FinalOM2D${VTDarkGray}, OM3:${VTDefault}$FinalOM3D${VTDarkGray}, OM4:${VTDefault}$FinalOM4D${VTDarkGray}, OM5:${VTDefault}$FinalOM5D${VTDarkGray}, OM6:${VTDefault} $FinalOM6D"}
    else{$OrbitalMarkersD = "Destination : ${VTRed}in Space${VTDefault}"}

    #REWORK PADDING
    $SpacingLeftColumns = 15
    $SpacingRightColumns = 17
    $Legend      = "COORDINATES :".PadRight($SpacingLeftColumns),'X (+OM5/-OM6)'.PadLeft($SpacingRightColumns),'Y (+OM3/-OM4)'.PadLeft($SpacingRightColumns),'Z (+OM1/-OM2)'.PadLeft($SpacingRightColumns)
    $Stanton     = "$script:CurrentDetectedSystem     :".PadRight($SpacingLeftColumns),,$([math]::Round($CurrentXPosition, 3)).ToString().PadLeft($SpacingRightColumns),$([math]::Round($CurrentYPosition, 3)).ToString().PadLeft($SpacingRightColumns),$([math]::Round($CurrentZPosition, 3)).ToString().PadLeft($SpacingRightColumns)
    if($script:CurrentDetectedObjectContainer){$Local = "Planet/Moon :".PadRight($SpacingLeftColumns-7),$CurrentDetectedObjectContainer.PadRight($SpacingLeftColumns-5),$CurrentPlanetaryXCoord.ToString().PadLeft($SpacingRightColumns-9),($CurrentPlanetaryYCoord).ToString().PadLeft($SpacingRightColumns),($CurrentPlanetaryZCoord).ToString().PadLeft($SpacingRightColumns)}else{$local = "Planet/Moon : ${VTRed}in Space${VTDefault}"}
    if($script:PlanetaryPoi)              {$Destination = "Destination :".PadRight($SpacingLeftColumns-7),$PoiCoordDataPlanet.PadRight($SpacingLeftColumns-8),$CurrentDestinationXCoord.ToString().PadLeft($SpacingRightColumns-6),$CurrentDestinationYCoord.ToString().PadLeft($SpacingRightColumns),$CurrentDestinationZCoord.ToString().PadLeft($SpacingRightColumns)}
    elseif($script:3dSpacePoi)            {$Destination = "Destination :".PadRight($SpacingLeftColumns-7),"Space".PadRight($SpacingLeftColumns-8),$CurrentDestinationXCoord.ToString().PadLeft($SpacingRightColumns-6),$CurrentDestinationYCoord.ToString().PadLeft($SpacingRightColumns),$CurrentDestinationZCoord.ToString().PadLeft($SpacingRightColumns)}
    elseif($script:CustomCoordsProvided)  {$Destination = "Destination :".PadRight($SpacingLeftColumns-7),"Custom".PadRight($SpacingLeftColumns-8),$CurrentDestinationXCoord.ToString().PadLeft($SpacingRightColumns-6),$CurrentDestinationYCoord.ToString().PadLeft($SpacingRightColumns),$CurrentDestinationZCoord.ToString().PadLeft($SpacingRightColumns)}
    
    
    #WGS Lat Long Height Conversion
    #$CurrentXPosition = 100;$CurrentYPosition = 200;$CurrentZPosition = 300;$CurrentDetectedBodyRadius = 380
    #$CurrentXPosition = -140700;$CurrentYPosition = 287920;$CurrentZPosition = -116690;$CurrentDetectedBodyRadius = 340830
    # = Lat: -20.008°  Long: 26.044°  Height: 214
    #$RadialDistance = [math]::Sqrt([double]$CurrentXPosition * [double]$CurrentXPosition + [double]$CurrentYPosition * [double]$CurrentYPosition + [double]$CurrentZPosition * [double]$CurrentZPosition)
    $RadialDistance = [math]::Sqrt([double]$CurrentPlanetaryXCoord * [double]$CurrentPlanetaryXCoord + [double]$CurrentPlanetaryYCoord * [double]$CurrentPlanetaryYCoord + [double]$CurrentPlanetaryZCoord * [double]$CurrentPlanetaryZCoord)
    $WgsHeight = [math]::Round($RadialDistance*1000 - [double]$CurrentDetectedBodyRadius, 0)
    $WgsLatitude = [math]::Round([math]::ASin($CurrentPlanetaryZCoord / $RadialDistance) * 180 / [Math]::PI,6)
    $WgsLongitude = [math]::Round([math]::Atan2($CurrentPlanetaryXCoord, $CurrentPlanetaryYCoord) * 180 / [Math]::PI,6) * -1

    $WGSSpacing = 17
    $WGS = "Planet/Moon : ".PadRight($WGSSpacing),"${VTDarkgray}Lat: ${VTDefault}$WgsLatitude°".PadRight($WGSSpacing-2),"${VTDarkgray}Long: ${VTDefault}$WgsLongitude°".PadRight($WGSSpacing+5),"${VTDarkgray}Height: ${VTDefault}$WgsHeight"

    #doabigcheese Bearing Berechnung                                                       
    #doabigcheese Bearing Berechnung  
    $WgsLatitude_Destination = [math]::ASin([double]$CurrentDestinationZCoord*1000 / [double]$DestinationOCRadius) * 180 / [Math]::PI
    $WgsLongitude_Destination = [math]::Atan2([double]$CurrentDestinationXCoord, [double]$CurrentDestinationYCoord) * 180 / [Math]::PI * -1 
    $WgsLatitude_Destination_=$WgsLatitude_Destination * [Math]::PI / 180
    $WgsLongitude_Destination_=$WgsLongitude_Destination * [Math]::PI / 180
    $WgsLatitude_=$WgsLatitude * [Math]::PI / 180
    $WgsLongitude_= $WgsLongitude * [Math]::PI / 180

   
    $bearingX = [math]::Cos([double]$WgsLatitude_Destination_) * [math]::Sin([double]$WgsLongitude_Destination_ - [double]$WgsLongitude_)
    $bearingY = [math]::Cos([double]$WgsLatitude_) * [math]::Sin([double]$WgsLatitude_Destination_) - [math]::Sin([double]$WgsLatitude_) * [math]::Cos([double]$WgsLatitude_Destination_) * [math]::Cos([double]$WgsLongitude_Destination_ - [double]$WgsLongitude_)
    $bearing = [math]::Round([math]::Atan2([double]$bearingX, [double]$bearingY) * 180 / [Math]::PI,0)
    $bearing_final = ($bearing + 360) % 360

    $bearing_output = "Compass : ".PadRight($WGSSpacing+7),"${VTDarkgray} ${VTDefault}$bearing_final°  (Bearing)"

    #OUTPUT RESULTS
    Write-Host -ForegroundColor DarkGray $Legend
    Write-Host -ForegroundColor White $Stanton
    Write-Host -ForegroundColor White $WGS
    Write-Host -ForegroundColor White $Local
    Write-Host -ForegroundColor White $Destination
    Write-Host -ForegroundColor White $OrbitalMarkers
    Write-Host -ForegroundColor White $OrbitalMarkersD
    Write-Host ""

    ### PREDICTION OF SUNRISE AND SUNSET ###
    <#
    #NEEDED VARIABLES
    #The location of the star in the current detected solarsystem
    $CurrentStarCoordinates = $ObjectContainerData.GetEnumerator() | Where-Object { $_.System -eq $script:CurrentDetectedSystem} | Where-Object { $_.Type -eq "Star"}
    $StarXCoord = $CurrentStarCoordinates.'X-Coord' #SX = Star X
    $StarYCoord = $CurrentStarCoordinates.'Y-Coord' #SY
    $StarZCoord = $CurrentStarCoordinates.'Z-Coord' #SZ
    $StarRadius = $CurrentStarCoordinates.BodyRadius

    #HCHF (HCHF - heliocentric / helio fixed) Coordinates of the current object container
    $script:CurrentDetectedOCX #BX = Body X
    $script:CurrentDetectedOCY #BY
    $script:CurrentDetectedOCZ #BZ

    #Quaternion Rotation of the current object container 
    $script:CurrentDetectedOCADW #QW = Quaternion W
    $script:CurrentDetectedOCADX #QX = Quaternion X
    $script:CurrentDetectedOCADY #QY
    $script:CurrentDetectedOCADZ #QZ


    #CALCULATIONS
    #CONVERT SYSTEM COORDINATES FROM STANTON STAR TOWARDS PLANET RELATIVE COORDINATES (ECEF - earth centered / earth fixed), THINK OF PLANET CENTRE HAS SYSTEM COORDINATES OF 0,0,0
    if($script:CurrentDetectedObjectContainer){
        #bsx
        $StarRelXCoord = (((1 - [math]::pow(2 * $script:CurrentDetectedOCADY,2)) - [math]::pow(2 * $script:CurrentDetectedOCADZ,2)) * ($StarXCoord - $script:CurrentDetectedOCX)) + (((2 * $script:CurrentDetectedOCADX * $script:CurrentDetectedOCADY)-(2 * $script:CurrentDetectedOCADZ * $script:CurrentDetectedOCADW))*($StarYCoord-$script:CurrentDetectedOCY)) + (((2 * $script:CurrentDetectedOCADX * $script:CurrentDetectedOCADZ)+(2 * $script:CurrentDetectedOCADY * $script:CurrentDetectedOCADW)) * ($StarZCoord-$script:CurrentDetectedOCZ))

        #bsy
        $StarRelYCoord = (((2 * $script:CurrentDetectedOCADX * $script:CurrentDetectedOCADY)+(2 * $script:CurrentDetectedOCADZ * $script:CurrentDetectedOCADW)) * ($StarXCoord - $script:CurrentDetectedOCX)) + ((1 - [math]::pow(2 * $script:CurrentDetectedOCADX,2) - [math]::pow(2 * $script:CurrentDetectedOCADZ,2)) * ($StarYCoord - $script:CurrentDetectedOCY)) + (((2 * $script:CurrentDetectedOCADY * $script:CurrentDetectedOCADZ) - (2 * $script:CurrentDetectedOCADX * $script:CurrentDetectedOCADW)) * ($StarZCoord - $script:CurrentDetectedOCZ))

        #bsz
        #$StarRelZCoord =
        #(((2 * qx * qz) - (2 * qy * qw)) * (sx - bx)) + (((2 * qy * qz) + (2 * qx * qw)) * (sy - by)) + ((1 - (2 * qx ^ 2) - (2 * qy ^ 2)) * (sz - bz))
    }

#>




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
    $SpacingToLeft2 = 15
    Write-Host -ForegroundColor DarkGray "NAVIGATION","CURRENT".PadLeft($SpacingToLeft2),"DELTA/PREVIOUSlY".PadLeft($SpacingToLeft2)
    Write-Host -ForegroundColor White "Distance","${CDTcolor}$("$DistanceTKM $DistanceTM")".PadLeft($SpacingToLeft2+7),"${VTDefault}$("$DistanceDKM $DistanceDM")".PadLeft($SpacingToLeft2+4)
    Write-Host -ForegroundColor White "Deviation Space","${FAcolor}$("$script:FinalAngle°")".PadLeft($SpacingToLeft2),"${VTDefault}$PreviousAngle°".PadLeft($SpacingToLeft2+4)
    Write-Host -ForegroundColor White "Deviation Planet","${FALcolor}$("$FinalAngleLocal°")".PadLeft($SpacingToLeft2-1),"${VTDefault}$PreviousAngleLocal°".PadLeft($SpacingToLeft2+4)
    Write-Host ""

    if($CurrentDeltaTotal -gt 0 -OR $CurrentDeltaTotal -lt 0){
        if($PreviousTime -gt 0){$CurrentETA = $CurrentDistanceTotal/($CurrentDeltaTotal/($DateTime - $PreviousTime).TotalSeconds)}
    }
    if($CurrentETA -gt 0){
        $ts =  [timespan]::fromseconds($CurrentETA)
        Write-Host -ForegroundColor DarkGray "ETA"
        Write-Host -ForegroundColor White "$($ts.Days) Days, $($ts.Hours) Hours, $($ts.Minutes) Minutes, $($ts.Seconds) Seconds"
        Write-Host ""
    }
    else {
        Write-Host -ForegroundColor DarkGray "ETA"
        Write-Host -ForegroundColor Red "Wrong way Pilot, turn around."
        Write-Host ""
    }
   
    #Write-Host ""


    #DETERMINE CLOST CURRENT OM FOR ANGLE CALCULATIONS
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
    if($PlanetaryPoi){

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

            Write-Host -ForegroundColor DarkGray "DIRECTION", "ANGLE".PadLeft(10)
            Write-Host -ForegroundColor White "Horizontal","${VTGreen}$FinalHorizontalAngle°${VTDefault}".PadLeft(10)
            Write-Host -ForegroundColor White "Vertical","${VTGreen}$FinalVerticalAngle°${VTDefault}".PadLeft(12)
            #Write-Host "Ship Position","${VTGreen}OM3/4".padLeft(11)
            #Write-Host "Planet: ${VTGreen}$($SelectedPlanet.Name)${VTDefault}, Orbital Marker: ${VTGreen}$ShipOMClosest${VTDefault}, Alignment: ${VTGreen}Planet Centre"
            Write-Host -ForegroundColor White "Alignment","Nose: ${VTGreen}Planet Centre${VTDefault}, Wings: ${VTGreen}OM5-6${VTDefault}, Top: ${VTGreen}OM-1".padLeft(11)
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

            Write-Host -ForegroundColor DarkGray "DIRECTION", "ANGLE".PadLeft(10)
            Write-Host -ForegroundColor White "Horizontal","${VTGreen}$FinalHorizontalAngle°${VTDefault}".PadLeft(10)
            Write-Host -ForegroundColor White "Vertical","${VTGreen}$FinalVerticalAngle°${VTDefault}".PadLeft(12)
            #Write-Host "Ship Position","${VTGreen}OM5/6".padLeft(11)
            #Write-Host "Planet: ${VTGreen}$($SelectedPlanet.Name)${VTDefault}, Orbital Marker: ${VTGreen}$ShipOMClosest${VTDefault}, Alignment: ${VTGreen}Planet Centre"
            Write-Host -ForegroundColor White "Alignment","Nose: ${VTGreen}Planet Centre${VTDefault}, Wings: ${VTGreen}OM3-4${VTDefault}, Top: ${VTGreen}OM-1".padLeft(11)
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

            Write-Host -ForegroundColor DarkGray "DIRECTION", "ANGLE".PadLeft(10)
            Write-Host -ForegroundColor White "Horizontal","${VTGreen}$FinalHorizontalAngle°${VTDefault}".PadLeft(10)
            Write-Host -ForegroundColor White "Vertical","${VTGreen}$FinalVerticalAngle°${VTDefault}".PadLeft(12)
            #Write-Host "Ship Position","${VTGreen}OM1/2".padLeft(11)
            #Write-Host "Planet: ${VTGreen}$($SelectedPlanet.Name)${VTDefault}, Orbital Marker: ${VTGreen}$ShipOMClosest${VTDefault}, Alignment: ${VTGreen}Planet Centre"
            Write-Host -ForegroundColor White "Alignment","Nose: ${VTGreen}Planet Centre${VTDefault}, Wings: ${VTGreen}OM5-6${VTDefault}, Top: ${VTGreen}OM-3".padLeft(11)
        }

        ### CREATE CROSSHAIR OVERLAY ###
        if($script:HudCrosshair){Set-CrosshairOnScreen $FinalHorizontalAngle $FinalVerticalAngle}
    }

    ### GET ANGLE ON A PLANET FOR GROUDN VEHICLES ###
    if($PlanetaryPoi){

        # CODE BY BIGCHEESE
        #Write-Host "CalcEbenenwinkel: " +  $PreviousPlanetaryXCoord + '; ' + $PreviousPlanetaryYCoord + '; ' + $PreviousPlanetaryZCoord + '; ' + $CurrentPlanetaryXCoord + '; ' + $CurrentPlanetaryYCoord + '; ' + $CurrentPlanetaryZCoord + '; ' + $PoiCoordDataX + '; ' + $PoiCoordDataY + '; ' + $PoiCoordDataZ
        Write-Host " "
        Write-Host -ForegroundColor DarkGray "GROUND VEHICLES","VALUE".PadLeft(14),"TENDENCY".PadLeft(10)
        
        $AngleGroundVehiclesRAW = CalcEbenenwinkel $PreviousPlanetaryXCoord $PreviousPlanetaryYCoord $PreviousPlanetaryZCoord $CurrentPlanetaryXCoord $CurrentPlanetaryYCoord $CurrentPlanetaryZCoord $PoiCoordDataX $PoiCoordDataY $PoiCoordDataZ
        $AngleGroundVehicles = [math]::Round($AngleGroundVehiclesRAW)
        $Previous_DistanceGroundVehicles = $DistanceGroundVehicles
        $DistanceGroundVehiclesRAW = CalcDistance3d $CurrentPlanetaryXCoord $CurrentPlanetaryYCoord $CurrentPlanetaryZCoord $PoiCoordDataX $PoiCoordDataY $PoiCoordDataZ
        $DistanceGroundVehicles = [math]::Pow("$DistanceGroundVehiclesRAW","2")
        if ($AngleGroundVehicles -le $Previous_AngleGroundVehicles) {
        Write-Host -ForegroundColor White "Angle".PadLeft(5),"$AngleGroundVehicles°".PadLeft(24),"${VTGreen}good${VTDefault}".PadLeft(10)
        }
        else {
        Write-Host -ForegroundColor White "Angle".PadLeft(5),"$AngleGroundVehicles°".PadLeft(24)," ${VTRed}bad${VTDefault}".PadLeft(10)
        }
        switch($DistanceGroundVehicles){
            {$_ -lt $Previous_DistanceGroundVehicles} {$TendencyColor = $VTGreen; $TendecyStatus = "closer"; break }
            {$_ -gt $Previous_DistanceGroundVehicles} {$TendencyColor = $VTred; $TendecyStatus = "further"; break }
            Default {$TendencyColor = $VTDarkGray; $TendecyStatus = "no change"}
        }
        switch($DistanceGroundVehicles){
            {$_ -lt $DistanceGreen} {$DistanceGVColor = $VTGreen; break }
            {$_ -lt $DistanceYellow} {$DistanceGVColor = $VTYellow; break }
            Default {$DistanceGVColor = $VTRed}
        }

        #Write-Host -ForegroundColor White "Distance".PadLeft(8),"${DistanceGVColor}$($DistanceGroundVehicles.ToString("#.###")) km".PadLeft(26),"${TendencyColor}$TendecyStatus${VTDefault}".PadLeft(19)
        Write-Host -ForegroundColor White "Distance".PadLeft(8),"${DistanceGVColor}$DistanceTKM $DistanceTM".PadLeft(21),"${TendencyColor}$TendecyStatus${VTDefault}".PadLeft(10)
        Write-Host -ForegroundColor White $bearing_output
    
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
        $Previous_AngleGroundVehicles = $AngleGroundVehicles
        Write-Host "" 
    }


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

    if ($script:PlanetaryPoi) {
        $FinalInstructions = @()
        $StartingPoint  =  [ordered]@{Step = "1.";Type = "Start";Direction = "from"; QuantumMarker = $PoiCoordDataPlanet;Distance = "-";TargetDistance = [math]::Truncate($ClosestQMStart.Distance/1000).ToString('N0')+"km"}
        $FirstStep =       [ordered]@{Step = "2.";Type = "Jump";Direction = "to";QuantumMarker = $OMGSStart;Distance = "-";TargetDistance = [math]::Truncate($OMGSDistanceToDestination/1000).ToString('N0')+"km"}
        $SecondStep =      [ordered]@{Step = "3.";Type = "Fly";Direction = "to";QuantumMarker = "$($SelectedDestination.Name)";Distance = [math]::Truncate($CurrentDistanceTotal/1000).ToString('N0')+"km";TargetDistance = "0 m"}
        #$SecondStep =      [ordered]@{Step = "3.";Type = "Fly";Direction = "to";QuantumMarker = "$($SelectedDestination.Name)";Distance = [math]::Truncate($CurrentDistanceTotal/1000).ToString('N0')+"km";TargetDistance = [math]::Truncate($CurrentDistanceTotal/1000).ToString('N0')+"km"}
        $FinalInstructions += New-Object -Type PSObject -Property $StartingPoint
        $FinalInstructions += New-Object -Type PSObject -Property $FirstStep
        $FinalInstructions += New-Object -Type PSObject -Property $SecondStep
        Write-Host "QUANTUM NAVIGATION" -NoNewline -ForegroundColor DarkGray
        Write-Host -ForegroundColor White ($FinalInstructions | Format-Table -Property @{Name="Step"; Expression={$_.Step}; Align="Center"},Type,Direction,QuantumMarker,<#@{Name="Distance"; Expression={"   $($_.Distance)"}; Align="Right"},#>@{Name="Final Distance"; Expression={$_.TargetDistance}; Align="Right"} | Out-String)
        #$LiveResults.Text = ($FinalInstructions | Format-Table -Property @{Name="Step"; Expression={$_.Step}; Align="Center"},Type,Direction,QuantumMarker,@{Name="Distance"; Expression={$_.Distance}; Align="Right"},@{Name="TargetDistance"; Expression={$_.TargetDistance}; Align="Right"} | Out-String)
    }
    else{
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
        Write-Host "QuaNTUM NaVIGATION" -NoNewline -ForegroundColor Darkgray
        Write-Host -ForegroundColor White ($FinalInstructions | Format-Table -Property @{Name="Step"; Expression={$_.Step}; Align="Center"},Type,Direction,QuantumMarker,@{Name="JumpDistance"; Expression={$_.JumpDistance}; Align="Right"},@{Name="Final Distance"; Expression={$_.TargetDistance}; Align="Right"} | Out-String)
        #$LiveResults.Text = ($FinalInstructions | Format-Table -Property @{Name="Step"; Expression={$_.Step}; Align="Center"},Type,Direction,QuantumMarker,@{Name="JumpDistance"; Expression={$_.JumpDistance}; Align="Right"},@{Name="TargetDistance"; Expression={$_.TargetDistance}; Align="Right"} | Out-String)
    }

    #FINAL DEBUGGING
    #Write-Host "Rotation Rate $ObjectContainerRotSpeed"
    #Write-Host "Length of Day $LengthOfDayDecimal"
    #Write-Host "Current Cycle $TotalCycles"
    #Write-Host "Julian Date $OCJulianDate"
    #Write-Host "Rotation Correction $ObjectContainerRotAdjust"
    #Write-Host "Hour Angle"

    ### WRITE EACH UPDATE INTO A LOGFILE, CALLED SLF (StarCitizen Logging Fileformat) FILE, 
    #Key, Systemname, Global X, Global Y, Global Z, Planetname, Local X, Local Y, Local Z, Latitude, Longitude, Height, Lat2d-X, Long2D-Y, Datetime, Playername, Comment

    $EpochTime = Get-Date $DateTime -UFormat %s
    $Logindex = 0

    if ($ScriptLoopCount -lt 1) {
        #ADD HEADING TO LOGFILE
        $LogHeading = "Key, Systemname, Global X (m), Global Y (m), Global Z (m), Planetname, Local X (km), Local Y (km), Local Z (km), Latitude, Longitude, Height (m), Lat2d-X (m), Long2D-Y (m), Date (Epoch), Datetime (UTC), Playername, Comment"
        $LogHeading >> $LogFilename

        #DETERMINE PLAYERNAME
        $LogfileLauncher = "$env:APPDATA\rsilauncher\log.log"
        $CurrentGameDetails = Get-Content -Path $LogfileLauncher | Select-String -Pattern "Launching Star Citizen" | Select-Object -Last 1
        $GameDir = ($CurrentGameDetails.Line.split('(').split(')').replace("\\","\"))[1]
        $GameLogLocation = "$GameDir\game.log"
        $GameLogDetailsRaw = Get-Content $GameLogLocation -Delimiter "<" #| Select-Object -Last 150
        $GameLogDetails = $GameLogDetailsRaw.trim("<").trim()
        (Get-Content $GameLogLocation) -replace '^.', ';' | Out-File "$GameDir\pre.log"

        $GameLogDetailsRaw = Get-Content "$GameDir\pre.log" -Delimiter ";" 
        #$GameLogDetailsRaw = $ModifiedLog.split(';').Trim('`r')
        $GameLogDetails = $GameLogDetailsRaw.trim(";") | Where-Object {$_ -gt 0}
    
        $LogContent = @()
        foreach($line in $GameLogDetails){
    
            $nline = $line.Split("`n").Split(">").Trim()
            $properties = @{
                'Date' = $nline[0]
                'Message' = $nline[1]
                'Details1' = $nline[2]
                'Details2' = $nline[3]
                'Details3' = $nline[4]
                'Details4' = $nline[5]
                'Details5' = $nline[6]
            }
            
            $LogContent += New-Object PSObject -Property $properties
        }
        $PlayernameGF = ($LogContent | Where-Object { $_.Message -match "User Login Success"}).Message.split("[").split("]")[5]
    }


    if($script:CurrentDetectedObjectContainer){
        #$Playername,$($DateTime.ToString('yyyy.MM.dd_HH:mm:ss:ffff'))
        #$HistoryContent = "$CurrentPlanetaryXCoord,$CurrentPlanetaryYCoord,$CurrentPlanetaryZCoord"

        ### Convert Lat into meters for scale ###
        #FIRST CALC THE CIRCUMFERENCE AND CONVERT IT INTO 1° AND MULTIPLE IT WITH THE READING
        $Circum = ([Math]::PI * [Math]::Pow(([double]$CurrentDetectedBodyRadius + $WgsHeight),2))
        $LatInMeters  = $Circum / 180 * $WgsLatitude 
        $LongInMeters = $Circum / 360 * $WgsLongitude
        
        #LOG CONTENT
        $LogContent = "$Logindex,$script:CurrentDetectedSystem,$CurrentXPosition,$CurrentYPosition,$CurrentZPosition,$CurrentDetectedObjectContainer,$CurrentPlanetaryXCoord,$CurrentPlanetaryYCoord,$CurrentPlanetaryZCoord,$WgsLatitude,$WgsLongitude,$WgsHeight,$LatInMeters,$LongInMeters,$EpochTime,$($DateTime.ToString('yyyy.MM.dd_HH:mm:ss:ffff')),$PlayernameGF,$UserComment"
        $LogContent  >>  $LogFilename

        #OUTPUT ALL UPDATES IN HISTORY FILE FOR MAPPING
        $HistoryContent = "$LatInMeters,$LongInMeters,$WgsHeight,$Playername"
        $HistoryContent  >>  $CsvFilename
    } #IF ON A PLANET
    else {
        $LogContent = "$Logindex,$script:CurrentDetectedSystem,$CurrentXPosition,$CurrentYPosition,$CurrentZPosition,none,none,none,none,none,none,none,none,none,$EpochTime,$($DateTime.ToString('yyyy.MM.dd_HH:mm:ss:ffff')),$PlayernameGF,$UserComment"
        $LogContent  >>  $LogFilename

        $HistoryContent = "$CurrentXPosition,$CurrentYPosition,$CurrentZPosition,$Playername"
        $HistoryContent  >> 'Data\history_global.csv'
    } #ELSE IF IN SPACE
    

    #STORE PREVIOUS DISTANCES
    $PreviousXPosition     = $CurrentXPosition
    $PreviousYPosition     = $CurrentYPosition
    $PreviousZPosition     = $CurrentZPosition
    $PreviousDistanceTotal = $CurrentDistanceTotal
    $PreviousDistanceX     = $CurrentDistanceX
    $PreviousDistanceY     = $CurrentDistanceY
    $PreviousDistanceZ     = $CurrentDistanceZ
    $PreviousTime          = $DateTime
    $PreviousAngle         = $FinalAngle
    $PreviousAngleLocal      = $FinalAngleLocal
    $PreviousPlanetaryXCoord = $CurrentPlanetaryXCoord
    $PreviousPlanetaryYCoord = $CurrentPlanetaryYCoord
    $PreviousPlanetaryZCoord = $CurrentPlanetaryZCoord
    if($ShipRotationValueX1 -AND $ShipRotationValueX1 -ne $PerviousShipRotationValueX1){$PerviousShipRotationValueX1 = $ShipRotationValueX1}
    if($ShipRotationValueY1 -AND $ShipRotationValueY1 -ne $PerviousShipRotationValueY1){$PerviousShipRotationValueY1 = $ShipRotationValueY1}
    if($ShipRotationValuez1 -AND $ShipRotationValueZ1 -ne $PerviousShipRotationValueZ1){$PerviousShipRotationValueZ1 = $ShipRotationValueZ1}
    $ScriptLoopCount ++
    $Logindex ++
    #Start-Sleep -Milliseconds 1
    
    }
    #DEBUG
    #else{
    #    Write-Host -NoNewline "."
    #}
    else{
        if(!$ClipboardContainsCoordinates -and $ScriptLoopCount -lt 2){
            
            Clear-Host
            $max = [System.ConsoleColor].GetFields().Count - 1 
            $color = [System.ConsoleColor](Get-Random -Min 1 -Max $max)
            $text1 = "Please issue "
            $text2 = "/showlocation "
            $text3 = "command in chat to display results"
            $Milliseconds = 5
            [char[]]$text1 | ForEach-Object{
                Write-Host -NoNewline -ForegroundColor White $_
                # Only break for a non-whitespace character.
                if($_ -notmatch "\s"){Start-Sleep -Milliseconds $Milliseconds}
            }

            [char[]]$text2 | ForEach-Object{
                Write-Host -NoNewline -ForegroundColor $color $_
                # Only break for a non-whitespace character.
                if($_ -notmatch "\s"){Start-Sleep -Milliseconds $Milliseconds}
            }
            
            [char[]]$text3 | ForEach-Object{
                Write-Host -NoNewline -ForegroundColor White $_
                # Only break for a non-whitespace character.
                if($_ -notmatch "\s"){Start-Sleep -Milliseconds $Milliseconds}
            }
            Write-Host " "
            #if($WaitCount -eq 5){}
            #$WaitCount++
            Start-Sleep -Milliseconds 1500
        }
    }
}


#KEEP LAST RESULTS OPEN, AND EXIT SCRIPT IF USER PRESSES ENTER
Pause

#Debug
#Get-Variable * > debug.txt

#ToDo
# DeltaDistance 
# is fine positive
# adds 1km if negative

#ToDo #2
# Frontend
# Select System = Stanton, Pyro (Dropdown)
# Select Destination Type = Space, Orbital, Custom Space 
# Create different tabs for each type