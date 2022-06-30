# Script to use CIG Coordinate System with Status Update

# EXPLANATION

# KEYBINDINGS
# CTRL + S = Save current position into /data/saved_locations.csv, issue a /sendlocation command before saving the current spot
# CTRL + R = Re Calibrate the current rotation of the planet, for this you need to get as close as possible to OM-3, ship with short nose to cockpit
# CTRL + T = Comment the previous spot, in case you do pathing something, every showlocation update is saved in two history files, the comment will be added to the previous update

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
#$Playername = "Graupunkt"
$CustomCoordsProvided = $false  #set to false per default, in case nothing was selected in gui or script is run again 
$StartNavigation = $true
$script:PlanetaryPoi = $false  
$script:3dSpacePoi  = $false
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
$ErrorActionPreference = 'SilentlyContinue'
$PlayernameGF = "Player"



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
if($env:TERM_PROGRAM -eq "vscode"){$script:ScriptDir = "C:\Users\marcel\Desktop\StarCitizen Tools\Projekt Jericho (3D Navigation)"}
Set-Location $script:ScriptDir

#Import Functions defined in dedicated files
# IF SCRIPT STOPS, SOME OF THESE FUNCTION FILES MGIHT BE BUGGED
# LAST TIME IT WAS BROKEN, A FUNCTIONS BRACKET WAS WRITTEN IN THE NEXT LINE INSTEAD BEHIND THE FUNCTION

#FOR VS CODE, HAS NO IMPACT ON POWERSHELL SCRIPT DIRECTLY
#Set-Location "C:\Users\marcel\Desktop\StarCitizen Tools\Projekt Jericho (3D Navigation)_V6"
#IMPORT FUNCTIONS
. '.\functions\Calculations Planetary.ps1'
. '.\functions\Calculations Space.ps1'
. '.\functions\Dynamic Forms GUI.ps1'
. '.\functions\Generic.ps1'
. '.\functions\Hotkeys and game interactions.ps1'
. '.\functions\StarCitizen Generic.ps1'
. '.\functions\Window settings and controls.ps1'

#ENABLE BUILTIN POWERSHELL V5 SUPPORT
if((Get-Host).Version.Major -eq "5"){
    $Powershellv5Legacy = $true
    #$StartNavigation = $true
    Write-Host -ForegroundColor Red "Please install and run with powershell v7"
}

#Set-ConsoleIcon -IconFile "data\Icon-Project-Jericho.ico"

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
    $WindowSizeY = 50
    $WindowSizeX = 99
    $MaxX = $ScreenResolution[0].WorkingArea.Width -850 
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

$CsvFilename = "Logs\history_local_$($DateTimeNTP.ToString('yyyy.MM.dd')).csv"
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
    $ClipboardContainsCoordinates, [decimal]$CurrentXPosition, [decimal]$CurrentYPosition, [decimal]$CurrentZPosition, $DateTime = Get-StarCitizenClipboardAndDate $PCClockdrift

    #[decimal]$CurrentXPosition = -18967436025.336437d
    #[decimal]$CurrentYPosition = -2667811818.272488d
    #[decimal]$CurrentZPosition = 5666797.140279d
    #$DateTime = Get-Date -Year "2022" -Month "06" -Day "14" -Hour "01" -Minute "57" -Second "42" -Millisecond "583"
    #$DateTime.ToString("yyyy-MM-dd HH:mm:ss.fff")    
    #$CurrentXPosition

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

        [decimal]$Circumference360Degrees = [Math]::PI * 2 * $CurrentDetectedOCRadius
        #Very high or low values are presented by ps as scientific results, therefore we force the nubmer (decimal) and limit it to 7 digits after comma
        #Multiplied by 1000 to convert km into m and invert it to correct the deviation
        [decimal]$RotationSpeedAdjustment = [Math]::Round(($CurrentPlanetaryXCoord * 1000 * 360 / $Circumference360Degrees) -as [decimal],7) * -1
        #GET Adjustment for Rotationspeed 
        [decimal]$FinalRotationAdjustment = ([decimal]$CurrentDetectedOCADX + [decimal]$RotationSpeedAdjustment)
        (Get-Content $OcCsvPath).replace($CurrentDetectedOCADX, $FinalRotationAdjustment) | Set-Content $OcCsvPath
        Write-Host "Rotation calibrated from $($CurrentDetectedOCADX)° to $($FinalRotationAdjustment)° by $RotationSpeedAdjustment, pls restart script"
        Start-Sleep -Seconds 5
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
            [decimal]$DestCoordDataX = $TextBoxX.Text
            [decimal]$DestCoordDataY = $TextBoxY.Text
            [decimal]$DestCoordDataZ = $TextBoxZ.Text
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
        #$ElapsedUTCTimeSinceSimulationStart = [TimeSpan]::FromMilliseconds(77327862583.328)
        #$ElapsedUTCTimeSinceSimulationStart.TotalDays
        #GET ORBITAL COORDINATES
        $SelectedDestination = $PointsOfInterestOnPlanetsData.GetEnumerator() | Where-Object { $_.Name -eq $script:CurrentDestination }
        $PoiCoordDataPlanet = $SelectedDestination.ObjectContainer
        [decimal]$PoiCoordDataX = $SelectedDestination.'Planetary X-Coord'
        [decimal]$PoiCoordDataY = $SelectedDestination.'Planetary Y-Coord'
        [decimal]$PoiCoordDataZ = $SelectedDestination.'Planetary Z-Coord'

        #GET THE PLANETS COORDS IN STANTON
        #$SelectedPlanet = $ObjectContainerData.GetEnumerator() | Where-Object { $_.Key -eq $CurrentPlanet}
        $SelectedPlanet = $ObjectContainerData.GetEnumerator() | Where-Object { $_.Name -eq $PoiCoordDataPlanet}
        #$SelectedPlanet = $ObjectContainerData.GetEnumerator() | Where-Object { $_.Key -eq $script:CurrentDetectedObjectContainer}
        #$PlanetDataParsed = $SelectedPlanet.Value -Split ";"
        [decimal]$PlanetCoordDataX = $SelectedPlanet.'X-Coord'/1000
        [decimal]$PlanetCoordDataY = $SelectedPlanet.'Y-Coord'/1000
        [decimal]$PlanetCoordDataZ = $SelectedPlanet.'Z-Coord'/1000
        
        $script:DestOCQuadW = $SelectedPlanet.RotQuatW
        $script:DestOCQuadX = $SelectedPlanet.RotQuatZ
        $script:DestOCQuadY = $SelectedPlanet.RotQuatY
        $script:DestOCQuadZ = $SelectedPlanet.RotQuatZ

        [decimal]$PlanetRotationSpeed = $SelectedPlanet.RotationSpeedX
        [decimal]$PlanetRotationStart = $SelectedPlanet.RotationAdjustmentX
        [int]$PlanetOMRadius = $SelectedPlanet.OrbitalMarkerRadius
get
  
        #FORMULA TO CALCULATE THE CURRENT STANTON X, Y, Z COORDNIATES FROM ROTATING PLANET
        #GET CURRENT ROTATION FROM ANGLE
        [decimal]$LengthOfDayDecimal = [decimal]$PlanetRotationSpeed * 3600 / 86400  #CORRECT
        [decimal]$JulianDate = $ElapsedUTCTimeSinceSimulationStart.TotalDays        #CORRECT
        [decimal]$TotalCycles = $JulianDate / $LengthOfDayDecimal                   #CORRECT
        [decimal]$CurrentCycleDez = $TotalCycles%1
        [decimal]$CurrentCycleDeg = $CurrentCycleDez * 360
        #if (($CurrentCycleDeg + $PlanetRotationStart) -gt 360){$CurrentCycleAngle = 360 - [decimal]$PlanetRotationStart + [decimal]$CurrentCycleDeg}
        if (($CurrentCycleDeg + $PlanetRotationStart) -lt 360){[decimal]$CurrentCycleAngle = $PlanetRotationStart + $CurrentCycleDeg}

        #CALCULATE THE RESULTING X Y COORDS 
        # /180 * PI = Conversion from 
        [decimal]$PoiRotationValueX = [decimal]$PoiCoordDataX * ([math]::Cos($CurrentCycleAngle/180*[System.Math]::PI)) - [decimal]$PoiCoordDataY * ([math]::Sin($CurrentCycleAngle/180*[System.Math]::PI))
        [decimal]$PoiRotationValueY = [decimal]$PoiCoordDataX * ([math]::Sin($CurrentCycleAngle/180*[System.Math]::PI)) + [decimal]$PoiCoordDataY * ([math]::Cos($CurrentCycleAngle/180*[System.Math]::PI))

        #SUBTRACT POI COORDS FROM PLANET COORDS
        [decimal]$DestCoordDataX = ($PlanetCoordDataX + $PoiRotationValueX) * 1000
        [decimal]$DestCoordDataY = ($PlanetCoordDataY + $PoiRotationValueY) * 1000
        [decimal]$DestCoordDataZ = ($PlanetCoordDataZ + $PoiCoordDataZ) * 1000

        $FinalPoiCoords = @{}
        $FinalPoiCoords = @{
            "$script:CurrentDestination" = "$DestCoordDataX;$DestCoordDataY;$DestCoordDataZ"
        }
        
        $FinalPlanetCoords = @{}
        [decimal]$FinalPlanetDataX = $PlanetCoordDataX * 1000
        [decimal]$FinalPlanetDataY = $PlanetCoordDataY * 1000
        [decimal]$FinalPlanetDataZ = $PlanetCoordDataZ * 1000
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
        [decimal]$DestCoordDataX = $SelectedDestination.'Stanton X-Coord'
        [decimal]$DestCoordDataY = $SelectedDestination.'Stanton Y-Coord'
        [decimal]$DestCoordDataZ = $SelectedDestination.'Stanton Z-Coord'
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
        #foreach ($ObjectContainer in $ObjectContainerData.GetEnumerator()){
        foreach ($ObjectContainer in $ObjectContainerData[13]){
            $MaxXGrid = $MaxYGrid = $MaxZGrid = $MinXGrid = $MinYGrid = $MinZGrid = ""
            [decimal]$ObjectContainerX         = $ObjectContainer.'X-Coord'
            [decimal]$ObjectContainerY         = $ObjectContainer.'Y-Coord'
            [decimal]$ObjectContainerZ         = $ObjectContainer.'Z-Coord'
            $ObjectContainerRotSpeedX = $ObjectContainer.RotationSpeedX
            $ObjectContainerRotSpeedY = $ObjectContainer.RotationSpeedY
            $ObjectContainerRotSpeedZ = $ObjectContainer.RotationSpeedZ
            $ObjectContainerRotAdjustX = $ObjectContainer.RotationAdjustmentX
            $ObjectContainerRotAdjustY = $ObjectContainer.RotationAdjustmentY
            $ObjectContainerRotAdjustZ = $ObjectContainer.RotationAdjustmentZ
            [decimal]$ObjectContainerOMRadius  = $ObjectContainer.OrbitalMarkerRadius
            [decimal]$ObjectContainerBodyRadius  = $ObjectContainer.BodyRadius
            [decimal]$OMRadiusExtra = 1.5

            $WithinX = $WithinY = $WithinZ = $false
            $MaxXGrid = $ObjectContainerX + ($ObjectContainerOMRadius * $OMRadiusExtra)
            $MaxYGrid = $ObjectContainerY + ($ObjectContainerOMRadius * $OMRadiusExtra)
            $MaxZGrid = $ObjectContainerZ + ($ObjectContainerOMRadius * $OMRadiusExtra)
            $MinXGrid = $ObjectContainerX - ($ObjectContainerOMRadius * $OMRadiusExtra)
            $MinYGrid = $ObjectContainerY - ($ObjectContainerOMRadius * $OMRadiusExtra)
            $MinZGrid = $ObjectContainerZ - ($ObjectContainerOMRadius * $OMRadiusExtra)
            if($CurrentXPosition -le $MaxXGrid -AND $CurrentXPosition -gt $MinXGrid){$WithinX = $true}
            if($CurrentYPosition -le $MaxYGrid -AND $CurrentYPosition -gt $MinYGrid){$WithinY = $true}
            if($CurrentZPosition -le $MaxZGrid -AND $CurrentZPosition -gt $MinZGrid){$WithinZ = $true}

            #Write-Host $ObjectContainer.Name 
            #Write-Host "X $WithinX"
            #Write-Host "Y $WithinY"
            #Write-Host "Z $WithinZ"

            #"$ObjectContainerX $ObjectContainerY $ObjectContainerZ"
            #Write-Host "X= $MaxXGrid"
            #Write-Host "X= $CurrentXPosition"
            #Write-Host "X= $MinXGrid"
            #Write-Host "Y= $MaxYGrid"
            #Write-Host "Y= $CurrentYPosition"
            #Write-Host "Y= $MinYGrid"
            #Write-Host "Z= $MaxZGrid"
            #Write-Host "Z= $CurrentZPosition"
            #Write-Host "Z= $MinZGrid"
            #Write-Host " "


            if($WithinX -and $WithinY -and $WithinZ){
                $script:CurrentDetectedSystem = $ObjectContainer.System
                $script:CurrentDetectedObjectContainer = $ObjectContainer.Name
                [decimal]$script:CurrentDetectedOCX  = $ObjectContainer."X-Coord"    #$ObjectContainerX
                [decimal]$script:CurrentDetectedOCY  = $ObjectContainer."Y-Coord"    #$ObjectContainerY
                [decimal]$script:CurrentDetectedOCZ  = $ObjectContainer."Z-Coord"    #$ObjectContainerZ
                [decimal]$script:CurrentDetectedOCRS = $ObjectContainerRotSpeedX #check
                [decimal]$script:CurrentDetectedOCADW = $ObjectContainerRotAdjustW 
                [decimal]$script:CurrentDetectedOCADX = $ObjectContainerRotAdjustX
                [decimal]$script:CurrentDetectedOCADY = $ObjectContainerRotAdjustY
                [decimal]$script:CurrentDetectedOCADZ = $ObjectContainerRotAdjustZ
                $script:CurrentDetectedOCRadius = $ObjectContainerOMRadius
                $script:CurrentDetectedBodyRadius = $ObjectContainerBodyRadius
                $script:CurrentOCQuadW = $ObjectContainer.RotQuatW
                $script:CurrentOCQuadX = $ObjectContainer.RotQuatZ
                $script:CurrentOCQuadY = $ObjectContainer.RotQuatY
                $script:CurrentOCQuadZ = $ObjectContainer.RotQuatZ
                #$ObjectContainer.Name
                
            }
            #DEBUG IF A COORD MIGH TBE CORRECT; BUT MATCHES NOT BECAUSE OF A TYPO
            if($WithinX -or $WithinY){
               #$ObjectContainer.Name
               # $ObjectContainerX
               # $ObjectContainerY
               # $ObjectContainerZ
               # Write-Host "Stanton Coords $CurrentXPosition $CurrentYPosition $CurrentZPosition"
            }
            #DEBUG2
            #Write-Host "$($ObjectContainer.Name) (X=$WithinX Y=$WithinY Z=$WithinZ)"
            #Write-Host "Stanton Coords  $CurrentXPosition $CurrentYPosition $CurrentZPosition"
            #Write-Host "ObjectContainer $ObjectContainerX $ObjectContainerY $ObjectContainerZ"
            #Write-Host "Orbit Radius" ($ObjectContainerOMRadius * $OMRadiusExtra)
            #Write-Host "$script:CurrentDetectedObjectContainer "
        }

        
        #GET DIFFERENCES BETWEEN PLANET CENTRE AND CURRENT POSITION
        [decimal]$PlanetDifferenceinX = ([double]$CurrentDetectedOCX - [double]$CurrentXPosition)    #A2
        [decimal]$PlanetDifferenceinY = ([double]$CurrentDetectedOCY - [double]$CurrentYPosition)    #B2
        #$PlanetDifferenceinZ = ($CurrentDetectedOCZ - $CurrentZPosition)    #C2

        [decimal]$OCLengthOfDayDecimal = [decimal]$script:CurrentDetectedOCRS * 3600 / 86400  #CORRECT
        [double]$OCJulianDate = $ElapsedUTCTimeSinceSimulationStart.TotalDays               #CORRECT
        [decimal]$OCTotalCycles = $OCJulianDate / $OCLengthOfDayDecimal                      #CORRECT
        [decimal]$OCCurrentCycleDez = $OCTotalCycles%1
        [decimal]$OCCurrentCycleDeg = $OCCurrentCycleDez * 360
        [decimal]$OCCurrentCycleAngle = $script:CurrentDetectedOCADX + $OCCurrentCycleDeg
        [decimal]$OCReversedAngle = 360 - $OCCurrentCycleAngle
        [decimal]$OCAngleRadian = $OCReversedAngle/180*[System.Math]::PI

        [decimal]$PlanetRotationValueX1 = ($PlanetDifferenceinX * ([math]::Cos($OCAngleRadian)) - $PlanetDifferenceinY * ([math]::Sin($OCAngleRadian))) * -1
        [decimal]$PlanetRotationValueY1 = ($PlanetDifferenceinX * ([math]::Sin($OCAngleRadian)) + $PlanetDifferenceinY * ([math]::Cos($OCAngleRadian))) * -1
        [decimal]$ShipRotationValueZ1 = $CurrentZPosition / 1000
        [decimal]$PlanetRotationValueZ1 = $ShipRotationValueZ1

        #DISPLAY CURRENT COORDS OF STANTON, PLANETARY AND POI
        #CONVERT CURRENT RESULTS FROM M OT KM (/1000) AND ROUND COORDINATES TO 3 DIGITS AFTER COMMA
        [decimal]$CurrentPlanetaryXCoord = [math]::Round($PlanetRotationValueX1/1000, 4)
        [decimal]$CurrentPlanetaryYCoord = [math]::Round($PlanetRotationValueY1/1000, 4)
        [decimal]$CurrentPlanetaryZCoord = [math]::Round($PlanetRotationValueZ1, 4)

        #CONVERT DESTINATION COORDINATES INTO 3 DIGITS AFTER COMMA, TOO
        [decimal]$CurrentDestinationXCoord = [math]::Round($PoiCoordDataX, 4)
        [decimal]$CurrentDestinationYCoord = [math]::Round($PoiCoordDataY, 4)
        [decimal]$CurrentDestinationZCoord = [math]::Round($PoiCoordDataZ, 4)

        #Total Distance Away
        #$PreviousDistanceTotalist = $curdist
        if($script:CurrentDetectedObjectContainer -eq $PoiCoordDataPlanet){
            [decimal]$CurrentDistanceTotal = [math]::Sqrt([math]::pow($CurrentPlanetaryXCoord - $CurrentDestinationXCoord,2) + [math]::pow($CurrentPlanetaryYCoord - $CurrentDestinationYCoord,2) + [math]::pow($CurrentPlanetaryZCoord - $CurrentDestinationZCoord,2))*1000
            [decimal]$CurrentDistanceX = [math]::Sqrt([math]::pow($CurrentPlanetaryXCoord - $CurrentDestinationXCoord,2))*1000
            [decimal]$CurrentDistanceY = [math]::Sqrt([math]::pow($CurrentPlanetaryYCoord - $CurrentDestinationYCoord,2))*1000
            [decimal]$CurrentDistanceZ = [math]::Sqrt([math]::pow($CurrentPlanetaryZCoord - $CurrentDestinationZCoord,2))*1000
        }
        else{
            [decimal]$CurrentDistanceTotal = [math]::Sqrt([math]::pow($CurrentXPosition - $DestCoordDataX,2) + [math]::pow($CurrentYPosition - $DestCoordDataY,2) + [math]::pow($CurrentZPosition - $DestCoordDataZ,2))
            [decimal]$CurrentDistanceX = [math]::Sqrt([math]::pow($CurrentXPosition - $DestCoordDataX,2))
            [decimal]$CurrentDistanceY = [math]::Sqrt([math]::pow($CurrentYPosition - $DestCoordDataY,2))
            [decimal]$CurrentDistanceZ = [math]::Sqrt([math]::pow($CurrentZPosition - $DestCoordDataZ,2))
        }

        [decimal]$CurrentDistanceTotal = [Math]::abs($CurrentDistanceTotal)
        [decimal]$CurrentDistanceX     = [Math]::abs($CurrentDistanceX)
        [decimal]$CurrentDistanceY     = [Math]::abs($CurrentDistanceY)
        [decimal]$CurrentDistanceZ     = [Math]::abs($CurrentDistanceZ)

        #GET DIFFERENCE IN DISTANCE
        #$CurrentDeltaTotal = $PreviousDistanceTotal - $CurrentDistanceTotal
        [decimal]$CurrentDeltaX     = $PreviousDistanceX - $CurrentDistanceX
        [decimal]$CurrentDeltaY     = $PreviousDistanceY - $CurrentDistanceY
        [decimal]$CurrentDeltaZ     = $PreviousDistanceZ - $CurrentDistanceZ
        #$CurrentDeltaTotal = [math]::Sqrt([math]::pow($PreviousDistanceX - $CurrentDistanceX,2) + [math]::pow($PreviousDistanceY - $CurrentDistanceY,2) + [math]::pow($PreviousDistanceZ - $CurrentDistanceZ,2))
        #$CurrentDeltaTotal = [math]::Sqrt([math]::pow($CurrentDeltaX ,2) + [math]::pow($CurrentDeltaY,2) + [math]::pow($CurrentDeltaZ,2))
        
        [decimal]$X2 = [math]::pow($CurrentDeltaX,2)
        [decimal]$Y2 = [math]::pow($CurrentDeltaY,2)
        [decimal]$Z2 = [math]::pow($CurrentDeltaZ,2)
        if ($CurrentDeltaX -lt 0){$X2 = $X2 * -1}
        if ($CurrentDeltaY -lt 0){$Y2 = $Y2 * -1}
        if ($CurrentDeltaZ -lt 0){$Z2 = $Z2 * -1}

        [decimal]$CurrentDeltaTotal = [math]::Sqrt([math]::Abs($X2 + $Y2 + $Z2))
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
            [decimal]$xu = (($DestCoordDataX - $PreviousXPosition) * ($CurrentXPosition - $PreviousXPosition))+(($DestCoordDataY - $PreviousYPosition) * ($CurrentYPosition - $PreviousYPosition))+(($DestCoordDataZ - $PreviousZPosition) * ($CurrentZPosition - $PreviousZPosition))

            [decimal]$xab_dist = CalcDistance3d $CurrentXPosition $CurrentYPosition $CurrentZPosition $PreviousXPosition $PreviousYPosition $PreviousZPosition 

            if ($xab_dist -lt 1) {
                $xab_dist=1
            }

            [decimal]$xu2 = $xu/($xab_dist * $xab_dist)

            [decimal]$closestX = $PreviousXPosition + $xu2 * ($CurrentXPosition - $PreviousXPosition)
            [decimal]$closestY = $PreviousYPosition + $xu2 * ($CurrentYPosition - $PreviousYPosition)
            [decimal]$closestZ = $PreviousZPosition + $xu2 * ($CurrentZPosition - $PreviousZPosition)

            #$c1 = CalcDistance3d $DestCoordDataX $DestCoordDataY $DestCoordDataZ $PreviousXPosition $PreviousYPosition $PreviousZPosition
            [decimal]$c2 = CalcDistance3d $DestCoordDataX $DestCoordDataY $DestCoordDataZ $CurrentXPosition $CurrentYPosition $CurrentZPosition


            [decimal]$pathError = CalcDistance3d $DestCoordDataX $DestCoordDataY $DestCoordDataZ $closestX $closestY $closestZ
            #Write-Host "Path Error = $pathError"
            [decimal]$perrd = [math]::atan2($pathError, $c2) * 180.0 / [math]::pi
            [decimal]$script:FinalAngle = [math]::Round($perrd,2)
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
            [decimal]$InstQuantumMarkerDataX  = $InstQuantumMarkerCoords[0]
            [decimal]$InstQuantumMarkerDataY  = $InstQuantumMarkerCoords[1]
            [decimal]$InstQuantumMarkerDataZ  = $InstQuantumMarkerCoords[2]

            $InstQMCurrent = "" | Select-Object QuantumMarker,X,Y,Z
            $InstQMCurrent.QuantumMarker = $QMEntry.Name
            [decimal]$InstQMCurrent.X = $InstQuantumMarkerDataX
            [decimal]$InstQMCurrent.Y = $InstQuantumMarkerDataY
            [decimal]$InstQMCurrent.Z = $InstQuantumMarkerDataZ
            $AllQMResults += $InstQMCurrent
        }

        #CALCULATE DISTANCES BETWEEN ALLE ENTRIES FROM PREVIOUS ARRAY
        $AllQMDistances = @()
        foreach ($QMEntry in $AllQMResults.GetEnumerator()){
            foreach ($Entry in $AllQMResults.GetEnumerator()){
                [decimal]$DistanceBetweenQM = [math]::Sqrt([math]::pow($QMEntry.X - $Entry.X,2) + [math]::pow($QMEntry.Y - $Entry.Y,2) + [math]::pow($QMEntry.Z - $Entry.Z,2))
                [decimal]$DistanceBetweenQMX = [math]::Sqrt([math]::pow($QMEntry.X - $Entry.X,2))
                [decimal]$DistanceBetweenQMY = [math]::Sqrt([math]::pow($QMEntry.Y - $Entry.Y,2))
                [decimal]$DistanceBetweenQMZ = [math]::Sqrt([math]::pow($QMEntry.Z - $Entry.Z,2))
                $CurrentQMDistance = "" | Select-Object QuantumMarkerFrom,QuantumMarkerTo,Distance,DistanceX,DistanceY,DistanceZ
                $CurrentQMDistance.QuantumMarkerFrom = $QMEntry.QuantumMarker
                $CurrentQMDistance.QuantumMarkerTo = $Entry.QuantumMarker
                $CurrentQMDistance.Distance = $DistanceBetweenQM
                [decimal]$CurrentQMDistance.DistanceX = $DistanceBetweenQMX
                [decimal]$CurrentQMDistance.DistanceY = $DistanceBetweenQMY
                [decimal]$CurrentQMDistance.DistanceZ = $DistanceBetweenQMZ
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
            [decimal]$PosX = [decimal]$PoiCoordDataX * 1000
            [decimal]$PosY = [decimal]$PoiCoordDataY * 1000
            [decimal]$PosZ = [decimal]$PoiCoordDataZ * 1000
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
        [decimal]$X2 = $CurrentXPosition / 1000
        [decimal]$Y2 = $CurrentYPosition / 1000
        
        #HARDCODED PLANET VIA DESTINATION
        [decimal]$A2 = ($PlanetCoordDataX - $X2)
        [decimal]$B2 = ($PlanetCoordDataY - $Y2)

        [decimal]$ReversedAngle = 360 - $CurrentCycleAngle
        [decimal]$AngleRadian = $ReversedAngle/180*[System.Math]::PI

        [decimal]$ShipRotationValueX1 = ($A2 * ([math]::Cos($AngleRadian)) - $B2 * ([math]::Sin($AngleRadian))) * -1
        [decimal]$ShipRotationValueY1 = ($A2 * ([math]::Sin($AngleRadian)) + $B2 * ([math]::Cos($AngleRadian))) * -1
        #$ShipRotationValueZ1 = $CurrentZPosition / 1000

        ##
        #$OCRotationValueX = [decimal]$script:CurrentDetectedOCX * ([math]::Cos($CurrentCycleAngle/180*[System.Math]::PI)) - [decimal]$script:CurrentDetectedOCY * ([math]::Sin($CurrentCycleAngle/180*[System.Math]::PI))
        #$OCRotationValueY = [decimal]$script:CurrentDetectedOCX * ([math]::Sin($CurrentCycleAngle/180*[System.Math]::PI)) + [decimal]$script:CurrentDetectedOCY * ([math]::Cos($CurrentCycleAngle/180*[System.Math]::PI))

        #CONVERT 3D SPACE INTO 
        if($script:3dSpacePoi)  {$PoiCoordDataPlanet = $DestinationName; [decimal]$CurrentDestinationXCoord = $DestCoordDataX; [decimal]$CurrentDestinationYCoord = $DestCoordDataY;[decimal]$CurrentDestinationZCoord = $DestCoordDataZ} 

        #Calculate Orbital Marker Distances for Current Position
        #First Value is in meters
        #Final Value is rounded in kilometers
        [decimal]$OCRadius = $CurrentDetectedOCRadius/1000
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
        if($script:CurrentDetectedObjectContainer){$OrbitalMarkers = "Player      : ".PadRight(14)+"${VTDarkGray}OM1:${VTDefault}$FinalOM1${VTDarkGray}".PadRight(29)+"OM2:${VTDefault}$FinalOM2${VTDarkGray}".PadRight(24)+"OM3:${VTDefault}$FinalOM3${VTDarkGray}".PadRight(24)+"OM4:${VTDefault}$FinalOM4${VTDarkGray}".PadRight(24)+"OM5:${VTDefault}$FinalOM5${VTDarkGray}".PadRight(24)+"OM6:${VTDefault} $FinalOM6"}
        else{$OrbitalMarkers = "Player      : ${VTRed}in Space${VTDefault}"}
        #Write-Host -ForegroundColor White "OM Distance :  ${VTDarkGray}OM1:${VTDefault} $FinalOM1"

        #OM DISTANCES FOR DESTINATION
        #MicroTech / Daymar Fix
        $DestinationOCRadius = ($ObjectContainerData.GetEnumerator() | Where-Object {$_.Name -contains $SelectedDestination.ObjectContainer}).OrbitalMarkerRadius
        #$DestinationOCRadius = ($ObjectContainerData.GetEnumerator() | Where-Object {$_.Name -contains $SelectedDestination.ObjectContainer}).BodyRadius
        [decimal]$OCRadiusD = $DestinationOCRadius/1000

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
        if($script:PlanetaryPoi){$OrbitalMarkersD = "Destination : ".PadRight(13)+"${VTDarkGray}OM1:${VTDefault}$FinalOM1D${VTDarkGray}".PadRight(29)+"OM2:${VTDefault}$FinalOM2D${VTDarkGray}".PadRight(24)+"OM3:${VTDefault}$FinalOM3D${VTDarkGray}".PadRight(24)+"OM4:${VTDefault}$FinalOM4D${VTDarkGray}".PadRight(24)+"OM5:${VTDefault}$FinalOM5D${VTDarkGray}".PadRight(24)+"OM6:${VTDefault} $FinalOM6D"}
        else{$OrbitalMarkersD = "Destination : ${VTRed}in Space${VTDefault}"}

        #REWORK PADDING
        $SpacingLeftColumns = 15
        $SpacingRightColumns = 17
        $Legend      = "COORDINATES :".PadRight($SpacingLeftColumns),'X (+OM5/-OM6)'.PadLeft($SpacingRightColumns),'Y (+OM3/-OM4)'.PadLeft($SpacingRightColumns),'Z (+OM1/-OM2)'.PadLeft($SpacingRightColumns)
        $Stanton     = "$script:CurrentDetectedSystem     :".PadRight($SpacingLeftColumns),,$([math]::Round($CurrentXPosition, 3)).ToString().PadLeft($SpacingRightColumns),$([math]::Round($CurrentYPosition, 3)).ToString().PadLeft($SpacingRightColumns),$([math]::Round($CurrentZPosition, 3)).ToString().PadLeft($SpacingRightColumns)
        if($script:CurrentDetectedObjectContainer){$Local = "Player      :".PadRight($SpacingLeftColumns-2),$CurrentDetectedObjectContainer.PadRight($SpacingLeftColumns-5),$CurrentPlanetaryXCoord.ToString("0.000").PadRight($SpacingRightColumns+1),($CurrentPlanetaryYCoord).ToString("0.000").PadRight($SpacingRightColumns+1),($CurrentPlanetaryZCoord).ToString("0.000").PadRight($SpacingRightColumns)}else{$local = "Planet/Moon : ${VTRed}in Space${VTDefault}"}

        if($script:PlanetaryPoi)              {$Destination = "Destination :".PadRight($SpacingLeftColumns-7),$PoiCoordDataPlanet.PadRight($SpacingLeftColumns-4),$CurrentDestinationXCoord.ToString("0.000").PadRight($SpacingRightColumns),$CurrentDestinationYCoord.ToString("0.000").PadRight($SpacingRightColumns),$CurrentDestinationZCoord.ToString("0.000").PadRight($SpacingRightColumns)}
        elseif($script:3dSpacePoi)            {$Destination = "Destination :".PadRight($SpacingLeftColumns-7),"Space".PadRight($SpacingLeftColumns-8),$CurrentDestinationXCoord.ToString("0.000").PadRight($SpacingRightColumns-6),$CurrentDestinationYCoord.ToString("0.000").PadRight($SpacingRightColumns),$CurrentDestinationZCoord.ToString("0.000").PadRight($SpacingRightColumns)}
        elseif($script:CustomCoordsProvided)  {$Destination = "Destination :".PadRight($SpacingLeftColumns-7),"Custom".PadRight($SpacingLeftColumns-8),$CurrentDestinationXCoord.ToString("0.000").PadRight($SpacingRightColumns-6),$CurrentDestinationYCoord.ToString("0.000").PadRight($SpacingRightColumns),$CurrentDestinationZCoord.ToString("0.000").PadRight($SpacingRightColumns)}
        
        
        #WGS Lat Long Height Conversion
        #$CurrentXPosition = 100;$CurrentYPosition = 200;$CurrentZPosition = 300;$CurrentDetectedBodyRadius = 380
        #$CurrentXPosition = -140700;$CurrentYPosition = 287920;$CurrentZPosition = -116690;$CurrentDetectedBodyRadius = 340830
        # = Lat: -20.008°  Long: 26.044°  Height: 214
        #$RadialDistance = [math]::Sqrt([decimal]$CurrentXPosition * [decimal]$CurrentXPosition + [decimal]$CurrentYPosition * [decimal]$CurrentYPosition + [decimal]$CurrentZPosition * [decimal]$CurrentZPosition)
        [decimal]$RadialDistance = [math]::Sqrt($CurrentPlanetaryXCoord * $CurrentPlanetaryXCoord + $CurrentPlanetaryYCoord * $CurrentPlanetaryYCoord + $CurrentPlanetaryZCoord * $CurrentPlanetaryZCoord)
        $WgsHeight = [math]::Round($RadialDistance*1000 - $CurrentDetectedBodyRadius, 0)
        [decimal]$WgsLatitude = [math]::Round([math]::ASin($CurrentPlanetaryZCoord / $RadialDistance) * 180 / [Math]::PI,8)
        [decimal]$WgsLongitude = [math]::Round([math]::Atan2($CurrentPlanetaryXCoord, $CurrentPlanetaryYCoord) * 180 / [Math]::PI,8) * -1

        $WGSSpacing = 17
        $WGS     = "Player      : ".PadRight($WGSSpacing),"${VTDarkgray}Lat: ${VTDefault}$WgsLatitude°".PadRight($WGSSpacing+9),"${VTDarkgray}Long:${VTDefault}$WgsLongitude°".PadRight($WGSSpacing+14),"${VTDarkgray}Height: ${VTDefault}$WgsHeight"
    
        
        #doabigcheese Bearing Berechnung
        [decimal]$RadialDistance_Destination = [math]::Sqrt($CurrentDestinationXCoord * $CurrentDestinationXCoord + $CurrentDestinationYCoord * $CurrentDestinationYCoord + $CurrentDestinationZCoord * $CurrentDestinationZCoord)  
        [decimal]$WgsLatitude_Destination = [math]::Round([math]::ASin($CurrentDestinationZCoord / $RadialDistance_Destination) * 180 / [Math]::PI, 7)
        [decimal]$WgsLongitude_Destination = [math]::Round([math]::Atan2($CurrentDestinationXCoord, $CurrentDestinationYCoord) * 180 / [Math]::PI * -1, 7)
    

        $DestinationBodyRadius = ($ObjectContainerData.GetEnumerator() | Where-Object {$_.Name -contains $SelectedDestination.ObjectContainer}).BodyRadius
        $WgsHeight_Destination = [math]::Round($RadialDistance_Destination * 1000 - $DestinationBodyRadius, 0)

        [decimal]$WgsLatitude_Destination_ = $WgsLatitude_Destination * [Math]::PI / 180
        [decimal]$WgsLongitude_Destination_ = $WgsLongitude_Destination * [Math]::PI / 180

        $WGSDest = "Destination : ".PadRight($WGSSpacing),"${VTDarkgray}Lat: ${VTDefault}$WgsLatitude_Destination°".PadRight($WGSSpacing+9),"${VTDarkgray}Long:${VTDefault}$WgsLongitude_Destination°".PadRight($WGSSpacing+14),"${VTDarkgray}Height: ${VTDefault}$WgsHeight_Destination"   

        [decimal]$WgsLatitude_ = $WgsLatitude * [Math]::PI / 180
        [decimal]$WgsLongitude_ = $WgsLongitude * [Math]::PI / 180

    
        [decimal]$bearingX = [math]::Cos($WgsLatitude_Destination_) * [math]::Sin($WgsLongitude_Destination_ - $WgsLongitude_)
        [decimal]$bearingY = [math]::Cos($WgsLatitude_) * [math]::Sin($WgsLatitude_Destination_) - [math]::Sin($WgsLatitude_) * [math]::Cos($WgsLatitude_Destination_) * [math]::Cos($WgsLongitude_Destination_ - $WgsLongitude_)
        [decimal]$bearing = [math]::Round([math]::Atan2($bearingX, $bearingY) * 180 / [Math]::PI,0)
        [decimal]$bearing_final = ($bearing + 360) % 360

        $bearing_output = "Compass : ".PadRight($WGSSpacing+7),"${VTDarkgray} ${VTDefault}$bearing_final° (Bearing)"

        #OUTPUT RESULTS
        Write-Host -ForegroundColor DarkGray $Legend
        Write-Host -ForegroundColor White $Stanton
        Write-Host -ForegroundColor White $WGS
        Write-Host -ForegroundColor White $WGSDest
        #Write-Host ""
        Write-Host -ForegroundColor White $Local
        Write-Host -ForegroundColor White $Destination
        #Write-Host ""
        Write-Host -ForegroundColor White $OrbitalMarkers
        Write-Host -ForegroundColor White $OrbitalMarkersD
        #Write-Host ""

        ### PREDICTION OF SUNRISE AND SUNSET ###
        
        #NEEDED VARIABLES, EXAMPLE VALUES ARE FOR DAYMAR, WolfPoint Aid and Javelin
        #The location of the star in the current detected solarsystem, can be directly obtained from the game files
        $CurrentStarCoordinates = $ObjectContainerData.GetEnumerator() | Where-Object { $_.System -eq $script:CurrentDetectedSystem} | Where-Object { $_.Type -eq "Star"}
        $StarXCoord = $CurrentStarCoordinates.'X-Coord'         #SX = Star X, Cell AK3
        $StarYCoord = $CurrentStarCoordinates.'Y-Coord'         #SY = Star Y, Cell AL3
        $StarZCoord = $CurrentStarCoordinates.'Z-Coord'         #SZ = Star Z, Cell AM3
        $StarRadius = $CurrentStarCoordinates.BodyRadius                     #Cell AN3

        #HCHF (HCHF - heliocentric / helio fixed) Coordinates of the current object container
        #$script:CurrentDetectedOCX                             #BX = Body X Coordinate
        #$script:CurrentDetectedOCY                             #BY = Body Y Coordinate
        #$script:CurrentDetectedOCZ                             #BZ = Body Z Coordinate
 
        #Quaternion Rotation of the current object container, can be directly obtained from the game files
        #$script:CurrentOCQuadW                           #QW = Quaternion Rotation W
        #$script:CurrentOCQuadX                           #QX = Quaternion Rotation X
        #$script:CurrentOCQuadY                           #QY = Quaternion Rotation Y
        #$script:CurrentOCQuadZ                           #QZ = Quaternion Rotation Z

        #Load JS code
        #node mod.js $x $y

        # Google Sheet Functions
        # Abs = Absolute values, so convert negative into positive values
        # Degrees Function = / pi * 180
        # ATAN2 X and Y are switched in Google Sheets
        # Mod Function = Special function to deal with negativ values and use a simple
        function mod ([array]$x) {
            return (($x[0] % $x[1]) + $x[1]) % $x[1]
        }

        #CALCULATIONS
        #CONVERT SYSTEM COORDINATES FROM STANTON STAR TOWARDS PLANET RELATIVE COORDINATES (ECEF - earth centered / earth fixed), THINK OF PLANET CENTRE HAS SYSTEM COORDINATES OF 0,0,0
        if($script:CurrentDetectedObjectContainer){
            #Distance in X between Body and Star (BSX)                           
            $StarRelXCoord = (((1 - [math]::pow(2 * $script:CurrentOCQuadY,2)) - [math]::pow(2 * $script:CurrentOCQuadZ,2)) * ($StarXCoord - $script:CurrentDetectedOCX)) + (((2 * $script:CurrentOCQuadX * $script:CurrentOCQuadY)-(2 * $script:CurrentOCQuadZ * $script:CurrentOCQuadW))*($StarYCoord-$script:CurrentDetectedOCY)) + (((2 * $script:CurrentOCQuadX * $script:CurrentOCQuadZ)+(2 * $script:CurrentOCQuadY * $script:CurrentOCQuadW)) * ($StarZCoord-$script:CurrentDetectedOCZ))

            #Distance in Y between Body and Star (BSY)            #((2*qx*qy)+(2*qz*qw))*(sx-bx))+((1-(2*qx^2)-(2*qz^2))*(sy-by))+(((2*qy*qz)-(2*qx*qw))*(sz-bz))
            $StarRelYCoord = (((2 * $script:CurrentOCQuadX * $script:CurrentOCQuadY) + (2 * $script:CurrentOCQuadZ * $script:CurrentOCQuadW)) * ($StarXCoord - $script:CurrentDetectedOCX)) + ((1 - [math]::pow(2 * $script:CurrentOCQuadX,2) - [math]::pow(2 * $script:CurrentOCQuadZ,2)) * ($StarYCoord - $script:CurrentDetectedOCY)) + (((2 * $script:CurrentOCQuadY * $script:CurrentOCQuadZ) - (2 * $script:CurrentOCQuadX * $script:CurrentOCQuadW)) * (($StarZCoord - $script:CurrentDetectedOCZ)))

            #Distance in Z between Body and Star (BSZ)
            $StarRelZCoord = (((2 * $script:CurrentOCQuadX * $script:CurrentOCQuadZ) - (2 * $script:CurrentOCQuadY * $script:CurrentOCQuadW)) * ($StarXCoord - $script:CurrentDetectedOCX)) + (((2 * $script:CurrentOCQuadY * $script:CurrentDetectedOCADZ) + (2 * $script:CurrentOCQuadX * $script:CurrentOCQuadW)) * ($StarYCoord - $script:CurrentDetectedOCY)) + ((1 - [math]::pow(2 * $script:CurrentOCQuadX,2) - [math]::pow(2 * $script:CurrentOCQuadY,2)) * ($StarZCoord - $script:CurrentDetectedOCZ))
        }

        #Convert Meters into KM
        [decimal]$StarRelX = $StarRelXCoord / 1000 #BSX, Cell AR3 19066589.410000000
        [decimal]$StarRelY = $StarRelYCoord / 1000 #BSY, Cell AS3 3904586.165000000
        [decimal]$StarRelZ = $StarRelZCoord / 1000 #BSZ, Cell AT3 2923345.368000000


        #SOLAR DECLINATION OF THE STAR
        # Cell AG3 = 8.54228846
        #=DEGREES(ACOS((((SQRT(bsx^2+bsy^2+bsz^2))^2)+((SQRT(bsx^2+bsy^2))^2)-(bsz^2))/(2*(SQRT(bsx^2+bsy^2+bsz^2))*(SQRT(bsx^2+bsy^2)))))*IF(bsz<0,-1,1)
        if($StarRelZ -lt 0){$SRMultipier = -1} else {$SRMultipier = 1}
        [decimal]$Declination = ([math]::Acos((([math]::Pow(([math]::Sqrt([math]::Pow($StarRelX,2) + [math]::Pow($StarRelY,2) + [math]::Pow($StarRelZ,2))),2)) + ([math]::Pow(([math]::Sqrt([math]::Pow($StarRelX,2) + [math]::Pow($StarRelY,2))),2)) - ([math]::Pow($StarRelZ,2))) / (2 * ([math]::Sqrt([math]::Pow($StarRelX,2) + [math]::Pow($StarRelY,2) + [math]::Pow($StarRelZ,2))) * ([math]::Sqrt([math]::Pow($StarRelX,2) + [math]::Pow($StarRelY,2)))))) / [math]::pi * 180 * $SRMultipier


        #DETERMINE THE APPARENT RADIUS OF THE STAR
        # Cell AP3 = 2.02667352
        # =DEGREES(MOD((ATAN2(bsx,bsy)-(PI()/2)),2*PI()))
        [decimal]$ApparentRadius = ([math]::ASin($StarRadius / ([math]::Sqrt([math]::Pow($StarRelX,2) + [math]::Pow($StarRelY,2) + [math]::Pow($StarRelZ,2))))) / [math]::pi * 180


        #$LengthOfDayDecimal     #AD3 = 0.1033333333
        #$JulianDate             #D1 = 858.009722453702		
        #$TotalCycles            #AD3 = 8303.319895
        #Star Locations if the planet wouldn rotate


        # Cell AG2
        #DEGREES(MOD((ATAN2(bsx,bsy)-(PI()/2))   ,2*PI()))
        [decimal]$Meridian = (mod(([math]::atan2($StarRelY,$StarRelX) - ([math]::pi/2)), (2 * [math]::pi))) / [math]::pi * 180

        #SOLAR LONGITUDE
        # Cell AG4 = -13969050
        # =IF(CurrentRotation-MOD(0-Meridian,360)>180,CurrentRotation-MOD(0-Meridian,360)-360,IF(CurrentRotation-MOD(0-Meridian,360)<-180,CurrentRotation-MOD(0-Meridian,360)+360,CurrentRotation-MOD(0-Meridian,360)))

        IF($Meridian - (mod((0 - $Meridian),360)) -gt 180){
            [decimal]$SolarLongitude = $Meridian - (mod((0 - $Meridian), 360)) -360
        } else {
            IF(($Meridian - (mod((0 - $Meridian), 360))) -lt 180) {[decimal]$SolarLongitude = $Meridian - (mod((0 - $Meridian), 360)) + 360} else 
                                                                         {[decimal]$SolarLongitude = $Meridian - (mod((0 - $Meridian), 360))}
        }



        
        ### LOCAL ###
        if($WgsHeight -gt 0){$Locationheight = $WgsHeight}else{$Locationheight = 0}
        $ElevationCorrection = [math]::Acos($script:CurrentDetectedBodyRadius/($script:CurrentDetectedBodyRadius + $Locationheight)) / [math]::pi * 180

        #[decimal]$CurrentRotationPosition = mod((360 - (mod($TotalCycles,1)) * 360 - $script:CurrentDetectedOCADX),360)
        [decimal]$CurrentRotationPosition = mod((360 - (mod($OCTotalCycles,1)) * 360 - $script:CurrentDetectedOCADX),360)

        if([math]::Abs($WgsLatitude)-eq 90){$WgsLongtidue360 = 0}else{
            [decimal]$WgsLongitude360 = (mod (([math]::Atan2($CurrentPlanetaryYCoord, $CurrentPlanetaryXCoord) - ([math]::PI / 2)), (2 * [math]::PI))) / [math]::pi * 180  
        }

        #HOUR ANGLE




        #IF(MOD(CycleHourAngle-MOD(AG44-sMeridian,360),360)>180,MOD(CycleHourAngle-MOD(AG44-sMeridian,360),360)-360,MOD(CycleHourAngle-MOD(AG44-sMeridian,360),360)
         IF((mod(($CurrentRotationPosition - (mod(($WgsLongitude360 - $Meridian), 360))),360)) -gt 180){
            [decimal]$HourAngleLocal = (mod(($CurrentRotationPosition - (mod(($WgsLongitude360 - $Meridian), 360))),360)) - 360
         }
         else{
            [decimal]$HourAngleLocal = mod(($CurrentRotationPosition - (mod(($WgsLongitude360 - $Meridian), 360))),360)
         }


         #RiseSetHourAngle
         #DEGREES(ACOS(-TAN(RADIANS($WgsLatitude_Destination)) * TAN(RADIANS($Declination)))) + $ApparentRadius + $ElevationCorrectionDest
         [decimal]$RiseSetHourAngleLocal = [math]::Acos(([math]::tan($WgsLatitude * [math]::pi / 180) * -1) * [math]::tan($Declination * [math]::pi / 180)) / [math]::pi * 180 + $ApparentRadius + $ElevationCorrection

         #AngularRotationRate
         [decimal]$AngularRotationRate = 6 / $script:CurrentDetectedOCRS


         #TIMES
         IF($HourAngleLocal -gt 0){
            [decimal]$LocalNoon = $HourAngleLocal/$AngularRotationRate/1440
             $ColorLocalNoon = $VTWhite
            }
        else{
            [decimal]$LocalNoon = (360 + $HourAngleLocal) / $AngularRotationRate /1440 
            $ColorLocalNoon = $VTRed
        }
         $LocalTime = (Get-Date)
         $LocalNoonTime = $Localtime.AddDays($LocalNoon).ToString("HH:mm")

         #SUNRISE
         $TerrainRaise = 0
         if($HourAngleDestination -gt ($RiseSetHourAngleLocal - $TerrainRaise)){
            #
            [decimal]$LocalRise = $LocalNoon - (($RiseSetHourAngleLocal - $TerrainRaise) / $AngularRotationRate *3 / 4300)
            $ColorLocalRise = $VTWhite
         }elseif($HourAngleDestination -gt 0){
            #
            [decimal]$LocalRise = $LocalNoon - (($RiseSetHourAngleLocal - $TerrainRaise) / $AngularRotationRate *3 / 4300) + $LengthOfDayDecimal
            $ColorLocalRise = $VTDarkGray
         }else{
            # If sunrise has already happened this cycle
            [decimal]$LocalRise = $LocalNoon - (($RiseSetHourAngleLocal - $TerrainRaise) / $AngularRotationRate *3 / 4300)
            $ColorLocalRise = $VTDarkGray
         }
         $LocalRiseTime = $Localtime.AddDays($LocalRise).ToString("HH:mm")

         #SUNSET
         if($HourAngleDestination -gt (($RiseSetHourAngleLocal - $TerrainRaise) * -1)){
            [decimal]$LocalSet = $LocalNoon + (($RiseSetHourAngleLocal + $TerrainRaise) / $AngularRotationRate *3 / 4300)
            $ColorLocalSet  = $VTRed
         }elseif($HourAngleDestination -gt 0){
            [decimal]$LocalSet = $LocalNoon + (($RiseSetHourAngleLocal + $TerrainRaise) / $AngularRotationRate *3 / 4300) - $LengthOfDayDecimal
            $ColorLocalSet  = $VTDarkGray
         }else{
            [decimal]$LocalSet = $LocalNoon + (($RiseSetHourAngleLocal + $TerrainRaise) / $AngularRotationRate *3 / 4300)
            $ColorLocalSet  = $VTDarkGray
         }

         $LocalSetTime = $Localtime.AddDays($LocalSet).ToString("HH:mm")

        #Remaining Daytime / Nighttime
        #DAYLIGHT 
        switch($Localtime){
            {$_ -gt $Localtime.AddDays($LocalRise) -OR $_ -lt $Localtime.AddDays($LocalRise)}   {$RemainingLocalDaylight  = [math]::Round(($Localtime - $Localtime.AddDays($LocalSet)).TotalMinutes);break}                        #Day has begun
            {$_ -le $Localtime.AddDays($LocalRise)}   {$RemainingLocalDaylight  = [math]::Round(($Localtime.AddDays($LocalSet) - $Localtime.AddDays($LocalRise)).TotalMinutes);break}    # Its before sunrise
        }
        #NIGHTIME
        switch($Localtime){
            {$_ -lt $Localtime.AddDays($LocalSet)}    {$RemainingLocalNighttime  = [math]::Round(($Localtime.AddDays($LocalRise) - $Localtime).TotalMinutes);break}
            {$_ -ge $Localtime.AddDays($LocalSet)}    {$NexRise = $LocalNoon - (($RiseSetHourAngleLocal - $TerrainRaise) / $AngularRotationRate *3 / 4300) + $LengthOfDayDecimal;$RemainingLocalNighttime  = [math]::Round(($Localtime.AddDays($NexRise) - $Localtime.AddDays($LocalSet)).TotalMinutes);break}
        }
        if ($RemainingLocalDaylight -le 0) {$RemainingLocalDaylight = $RemainingLocalDaylight * -1}
        if ($RemainingLocalNighttime -le 0){$RemainingLocalNighttime = $RemainingLocalNighttime * -1}

        #Local Day Conditions # after sunrise
        #$LocalDayCondition = "unknown"
        if(180 -ge $HourAngleLocal -AND $HourAngleLocal -gt ($RiseSetHourAngleLocal + 12))                                      {$LocalDayCondition = "After Midnight";  $DayLocalColor = $VTDarkGray;    $NightLocalColor = $VTGreen}
        if($RiseSetHourAngleLocal + 12 -ge $HourAngleLocal -AND $HourAngleLocal -gt $RiseSetHourAngleLocal)                     {$LocalDayCondition = "Morning Twilight";$DayLocalColor = $VTGreen;       $NightLocalColor = $VTDarkGray}
        if($RiseSetHourAngleLocal + 12 -ge $HourAngleLocal -AND $HourAngleLocal -gt 0)                                          {$LocalDayCondition = "Morning";         $DayLocalColor = $VTGreen;       $NightLocalColor = $VTDarkGray}
        if(0 -ge $HourAngleLocal -AND $HourAngleLocal -gt ($RiseSetHourAngleLocal * -1))                                        {$LocalDayCondition = "Afternoon";       $DayLocalColor = $VTGreen;       $NightLocalColor = $VTDarkGray}
        if(($RiseSetHourAngleLocal * -1) -ge $HourAngleLocal -AND $HourAngleLocal -gt (($RiseSetHourAngleLocal * -1) - 12))     {$LocalDayCondition = "Evening Twilight";$DayLocalColor = $VTDarkGray;    $NightLocalColor = $VTGreen}
        if(($RiseSetHourAngleLocal * -1 -12) -ge $HourAngleLocal -AND $HourAngleLocal -ge -180)                                 {$LocalDayCondition = "Before Midnight"; $DayLocalColor = $VTDarkGray;    $NightLocalColor = $VTGreen}

        #####################
        #### DESTINATION ####
        #####################
        #Cell AI44 = 1,07571295561478
        if($WgsHeight_Destination -gt 0){$LocationheightD = $WgsHeight_Destination}else{$LocationheightD = 0}
        [decimal]$ElevationCorrectionDest = [math]::Acos([int]$DestinationBodyRadius/([int]$script:DestinationBodyRadius + [int]$LocationheightD)) / [math]::pi * 180

        #
        [decimal]$DestinationRotAdjX = ($ObjectContainerData.GetEnumerator() | Where-Object {$_.Name -contains $SelectedDestination.ObjectContainer}).RotationAdjustmentX
        $CurrentRotationPositionD = mod((360 - (mod($TotalCycles,1)) * 360 - $DestinationRotAdjX),360)

        if([math]::Abs($WgsLatitude_Destination)-eq 90){$WgsLongtidue360D = 0}else{
            [decimal]$WgsLongitude360D = (mod (([math]::Atan2($CurrentDestinationYCoord, $CurrentDestinationXCoord) - ([math]::PI / 2)), (2 * [math]::PI))) / [math]::pi * 180  
        }

        #HOUR ANGLE

        #IF(MOD(CycleHourAngle-MOD(AG44-sMeridian,360),360)>180,MOD(CycleHourAngle-MOD(AG44-sMeridian,360),360)-360,MOD(CycleHourAngle-MOD(AG44-sMeridian,360),360)
        IF((mod(($CurrentRotationPosition - (mod(($WgsLongitude360D - $Meridian), 360))),360)) -gt 180){
            [decimal]$HourAngleDestination = (mod(($CurrentRotationPosition - (mod(($WgsLongitude360D - $Meridian), 360))),360)) - 360
         }
         else{
            [decimal]$HourAngleDestination = mod(($CurrentRotationPosition - (mod(($WgsLongitude360D - $Meridian), 360))),360)
         }

         #RiseSetHourAngle

         #######################################
         if($PoiCoordDataPlanet){
            #Distance in X between Body and Star (BSX)                           
            $StarRelXCoordDest = (((1 - [math]::pow(2 * $script:DestOCQuadY,2)) - [math]::pow(2 * $script:DestOCQuadZ,2)) * ($StarXCoord - $FinalPlanetDataX)) + (((2 * $script:DestOCQuadX * $script:DestOCQuadY)-(2 * $script:DestOCQuadZ * $script:DestOCQuadW))*($StarYCoord-$FinalPlanetDataY)) + (((2 * $script:DestOCQuadX * $script:DestOCQuadZ)+(2 * $script:DestOCQuadY * $script:DestOCQuadW)) * ($StarZCoord-$FinalPlanetDataZ))

            #Distance in Y between Body and Star (BSY)            #((2*qx*qy)+(2*qz*qw))*(sx-bx))+((1-(2*qx^2)-(2*qz^2))*(sy-by))+(((2*qy*qz)-(2*qx*qw))*(sz-bz))
            $StarRelYCoordDest = (((2 * $script:DestOCQuadX * $script:DestOCQuadY) + (2 * $script:DestOCQuadZ * $script:DestOCQuadW)) * ($StarXCoord - $FinalPlanetDataX)) + ((1 - [math]::pow(2 * $script:DestOCQuadX,2) - [math]::pow(2 * $script:DestOCQuadZ,2)) * ($StarYCoord - $FinalPlanetDataY)) + (((2 * $script:DestOCQuadY * $script:DestOCQuadZ) - (2 * $script:DestOCQuadX * $script:DestOCQuadW)) * (($StarZCoord - $FinalPlanetDataZ)))

            #Distance in Z between Body and Star (BSZ)
            $StarRelZCoordDest = (((2 * $script:DestOCQuadX * $script:DestOCQuadZ) - (2 * $script:DestOCQuadY * $script:DestOCQuadW)) * ($StarXCoord - $FinalPlanetDataX)) + (((2 * $script:DestOCQuadY * $script:CurrentDetectedOCADZ) + (2 * $script:DestOCQuadX * $script:DestOCQuadW)) * ($StarYCoord - $FinalPlanetDataY)) + ((1 - [math]::pow(2 * $script:DestOCQuadX,2) - [math]::pow(2 * $script:DestOCQuadY,2)) * ($StarZCoord - $FinalPlanetDataZ))
        }

        #Convert Meters into KM
        [decimal]$StarRelXDest = $StarRelXCoordDest / 1000 #BSX, Cell AR3 19066589.410000000
        [decimal]$StarRelYDest = $StarRelYCoordDest / 1000 #BSY, Cell AS3 3904586.165000000
        [decimal]$StarRelZDest = $StarRelZCoordDest / 1000 #BSZ, Cell AT3 2923345.368000000


        #SOLAR DECLINATION OF THE STAR
        # Cell AG3 = 8.54228846
        #=DEGREES(ACOS((((SQRT(bsx^2+bsy^2+bsz^2))^2)+((SQRT(bsx^2+bsy^2))^2)-(bsz^2))/(2*(SQRT(bsx^2+bsy^2+bsz^2))*(SQRT(bsx^2+bsy^2)))))*IF(bsz<0,-1,1)
        if($StarRelZDest -lt 0){$SRMultipierD = -1} else {$SRMultipierD = 1}
        
        [decimal]$DeclinationDest = ([math]::Acos((([math]::Pow(([math]::Sqrt([math]::Pow($StarRelXDest,2) + [math]::Pow($StarRelYDest,2) + [math]::Pow($StarRelZDest,2))),2)) + ([math]::Pow(([math]::Sqrt([math]::Pow($StarRelXDest,2) + [math]::Pow($StarRelYDest,2))),2)) - ([math]::Pow($StarRelZDest,2))) / (2 * ([math]::Sqrt([math]::Pow($StarRelXDest,2) + [math]::Pow($StarRelYDest,2) + [math]::Pow($StarRelZDest,2))) * ([math]::Sqrt([math]::Pow($StarRelXDest,2) + [math]::Pow($StarRelYDest,2)))))) / [math]::pi * 180 * $SRMultipierD

        [decimal]$ApparentRadiusDest = ([math]::ASin($StarRadius / ([math]::Sqrt([math]::Pow($StarRelXDest,2) + [math]::Pow($StarRelYDest,2) + [math]::Pow($StarRelZDest,2))))) / [math]::pi * 180

##############################################################



        [decimal]$RiseSetHourAngle = [math]::Acos(([math]::tan($WgsLatitude_Destination * [math]::pi / 180) * -1) * [math]::tan($DeclinationDest * [math]::pi / 180)) / [math]::pi * 180 + $ApparentRadiusDest + $ElevationCorrectionDest

        #AngularRotationRate
        [decimal]$AngularRotationRateDest = 6 / $PlanetRotationSpeed
        [decimal]$MeridianDest = (mod(([math]::atan2($StarRelYDest,$StarRelXDest) - ([math]::pi/2)), (2 * [math]::pi))) / [math]::pi * 180
        IF($Meridian - (mod((0 - $MeridianDest),360)) -gt 180){
            [decimal]$SolarLongitudeDest = $MeridianDest - (mod((0 - $MeridianDest), 360)) -360
        } else {
            IF(($MeridianDest - (mod((0 - $Meridian), 360))) -lt 180) {[decimal]$SolarLongitudeDest = $MeridianDest - (mod((0 - $Meridian), 360)) + 360} else 
                                                                         {[decimal]$SolarLongitudeDest = $MeridianDest - (mod((0 - $Meridian), 360))}
        }




         #TIMES
         IF($HourAngleDestination -gt 0){
            [decimal]$noon = $HourAngleDestination/$AngularRotationRateDest/1440
            $ColorDestNoon = $VTWhite
            } 
        else{
            [decimal]$noon = (360 + $HourAngleDestination) / $AngularRotationRateDest /1440 
            $ColorDestNoon = $VTRed
            }
         $LocalTime = (Get-Date)
         $DestNoonTime = $Localtime.AddDays($noon).ToString("HH:mm")


         #SUNRISE
         $TerrainRaise = 0
         [decimal]$LengthOfDayDestination = [decimal]$PlanetRotationSpeed * 3600 / 86400 

         if($HourAngleDestination -gt ($RiseSetHourAngle - $TerrainRaise)){
            [decimal]$rise = $noon - (($RiseSetHourAngle - $TerrainRaise) / $AngularRotationRateDest *3 / 4300)
            $ColorDestRise = $VTDarkGray
         }elseif($HourAngleDestination -gt 0){
            [decimal]$rise = $noon - (($RiseSetHourAngle - $TerrainRaise) / $AngularRotationRateDest *3 / 4300) + $LengthOfDayDestination
            $ColorDestRise = $VTDarkGray
         }else{
            [decimal]$rise = $noon - (($RiseSetHourAngle - $TerrainRaise) / $AngularRotationRateDest *3 / 4300)
            $ColorDestRise = $VTGreen
         }
         $DestRiseTime = $Localtime.AddDays($rise).ToString("HH:mm")

         #SUNSET
         if($HourAngleDestination -gt (($RiseSetHourAngle - $TerrainRaise) * -1)){
            [decimal]$set = $noon + (($RiseSetHourAngle + $TerrainRaise) / $AngularRotationRateDest *3 / 4300)
            $ColorDestSet  = $VTRed
         }elseif($HourAngleDestination -gt 0){
            [decimal]$set = $noon + (($RiseSetHourAngle + $TerrainRaise) / $AngularRotationRateDest *3 / 4300) - $LengthOfDayDestination
            $ColorDestSet  = $VTDarkGray
         }else{
            [decimal]$set = $noon + (($RiseSetHourAngle + $TerrainRaise) / $AngularRotationRateDest *3 / 4300)
            $ColorDestSet  = $VTDarkGray
         }
         $DestSetTime = $Localtime.AddDays($set).ToString("HH:mm")

        #Remaining Daytime / Nighttime
        #DAYLIGHT 
        switch($Localtime){
            {$_ -gt $Localtime.AddDays($rise) -OR $_ -lt $Localtime.AddDays($rise)}   {$RemainingDaylight  = [math]::Round(($Localtime - $Localtime.AddDays($set)).TotalMinutes);break}
            {$_ -le $Localtime.AddDays($rise)}   {$RemainingDaylight  = [math]::Round(($Localtime.AddDays($set) - $Localtime.AddDays($rise)).TotalMinutes);break} #working
        }
        #NIGHTIME
        switch($Localtime){
            {$_ -lt $Localtime.AddDays($rise)}    {$RemainingNighttime  = [math]::Round(($Localtime.AddDays($rise) - $Localtime).TotalMinutes);break}
            {$_ -ge $Localtime.AddDays($rise)}    {$NexRise = $noon - (($RiseSetHourAngle - $TerrainRaise) / $AngularRotationRateDest *3 / 4300) + $LengthOfDayDestination;$RemainingNighttime  = [math]::Round(($Localtime.AddDays($NexRise) - $Localtime.AddDays($set)).TotalMinutes);break}
        }
        if ($RemainingDaylight -le 0) {$RemainingDaylight = $RemainingDaylight * -1}
        if ($RemainingNighttime -le 0){$RemainingNighttime = $RemainingNighttime * -1}

        #Destination Day Conditions #before sunrise
        if(180 -ge $HourAngleDestination -AND $HourAngleDestination -gt ($RiseSetHourAngle + 12))                               {$DestDayCondition = "After Midnight";  $DayColor = $VTDarkGray;    $NightColor = $VTGreen}
        if($RiseSetHourAngle + 12 -ge $HourAngleDestination -AND $HourAngleDestination -gt $RiseSetHourAngle)                   {$DestDayCondition = "Morning Twilight";$DayColor = $VTGreen;       $NightColor = $VTDarkGray}
        if($RiseSetHourAngle + 12 -ge $HourAngleDestination -AND $HourAngleDestination -gt 0)                                   {$DestDayCondition = "Morning";         $DayColor = $VTGreen;       $NightColor = $VTDarkGray}
        if(0 -ge $HourAngleDestination -AND $HourAngleDestination -gt ($RiseSetHourAngle * -1))                                 {$DestDayCondition = "Afternoon";       $DayColor = $VTGreen;       $NightColor = $VTDarkGray}
        if(($RiseSetHourAngle * -1) -ge $HourAngleDestination -AND $HourAngleDestination -gt (($RiseSetHourAngle * -1) - 12))   {$DestDayCondition = "Evening Twilight";$DayColor = $VTDarkGray;    $NightColor = $VTGreen}
        if(($RiseSetHourAngle * -1 -12) -ge $HourAngleDestination -AND $HourAngleDestination -ge -180)                          {$DestDayCondition = "Before Midnight"; $DayColor = $VTDarkGray;    $NightColor = $VTGreen}
        #$DestDayCondition

         Write-Host ""
         Write-Host -ForegroundColor DarkGray "Daylight Forecast    Condition          Rise    Set     Daylight left   Nighttime left"
         if($script:CurrentDetectedObjectContainer){Write-Host -ForegroundColor White $PlayernameGF.PadRight(20)    $LocalDayCondition.PadRight(18)    "${ColorLocalRise}$LocalRiseTime".PadRight(12)     "${ColorLocalSet}$LocalSetTime".PadRight(12)   "${DayLocalColor}$RemainingLocalDaylight min".PadRight(20)   ${NightLocalColor}$RemainingLocalNighttime "min"}
         else{Write-Host -ForegroundColor White $PlayernameGF.PadRight(20)    "${VTRed}in Space".PadRight(18)}

         if($script:PlanetaryPoi){Write-Host -ForegroundColor White $DestinationName.PadRight(20) $DestDayCondition.PadRight(18)     "${ColorDestRise}$DestRiseTime".PadRight(12)       "${ColorDestSet}$DestSetTime".PadRight(12)     "${DayColor}$RemainingDaylight min".PadRight(20)             ${NightColor}$RemainingNighttime "min"}
         else{Write-Host -ForegroundColor White $DestinationName.PadRight(20)    "${VTRed}in Space".PadRight(18)}
         Write-Host ""

        #Coordinates: x:-18930267227.731792 y:-2610218512.783141 z:95733.918393
        #Coordinates: x:-18961179048.555115 y:-2648341045.898221 z:-6979924.962668



        #CALCUALTE LOCAL COURSE DIAVATION
        #by Xabdiben
        [decimal]$XULocal = (($CurrentDestinationXCoord - $PreviousPlanetaryXCoord) * ($CurrentPlanetaryXCoord - $PreviousPlanetaryXCoord))+(($CurrentDestinationYCoord - $PreviousPlanetaryYCoord) * ($CurrentPlanetaryYCoord - $PreviousPlanetaryYCoord))+(($CurrentDestinationZCoord - $PreviousPlanetaryZCoord) * ($CurrentPlanetaryZCoord - $PreviousPlanetaryZCoord))
        [decimal]$xab_distLocal = CalcDistance3d $CurrentPlanetaryXCoord $CurrentPlanetaryYCoord $CurrentPlanetaryZCoord $PreviousPlanetaryXCoord $PreviousPlanetaryYCoord $PreviousPlanetaryZCoord 
        if ($xab_distLocal -lt 1) {$xab_distLocal=1}
        [decimal]$XULocal2 = $XULocal/($xab_distLocal * $xab_distLocal)
        [decimal]$closestXLocal = $PreviousPlanetaryXCoord + $XULocal2 * ($CurrentPlanetaryXCoord - $PreviousPlanetaryXCoord)
        [decimal]$closestYLocal = $PreviousPlanetaryYCoord + $XULocal2 * ($CurrentPlanetaryYCoord - $PreviousPlanetaryYCoord)
        [decimal]$closestZLocal = $PreviousPlanetaryZCoord + $XULocal2 * ($CurrentPlanetaryZCoord - $PreviousPlanetaryZCoord)
        #$c1 = CalcDistance3d $DestCoordDataX $DestCoordDataY $DestCoordDataZ $PreviousXPosition $PreviousYPosition $PreviousZPosition
        [decimal]$c2Local = CalcDistance3d $CurrentDestinationXCoord $CurrentDestinationYCoord $CurrentDestinationZCoord $CurrentPlanetaryXCoord $CurrentPlanetaryYCoord $CurrentPlanetaryZCoord
        [decimal]$pathErrorLocal = CalcDistance3d $CurrentDestinationXCoord $CurrentDestinationYCoord $CurrentDestinationZCoord $closestXLocal $closestYLocal $closestZLocal
        #Write-Host "Path Error = $pathError"
        [decimal]$perrdLocal = [math]::atan2($pathErrorLocal, $c2Local) * 180.0 / [math]::pi
        # above ok, below 0
        [decimal]$FinalAngleLocal = [math]::Round($perrdLocal,2)
        
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
        $SpacingToLeft2 = 20
        Write-Host -ForegroundColor DarkGray "NAVIGATION","CURRENT".PadLeft($SpacingToLeft2),"DELTA/PREVIOUSLY".PadLeft($SpacingToLeft2-1)
        Write-Host -ForegroundColor White "Distance","${CDTcolor}$("$DistanceTKM $DistanceTM")".PadLeft($SpacingToLeft2+7),"${VTDefault}$("$DistanceDKM $DistanceDM")".PadLeft($SpacingToLeft2+4)
        Write-Host -ForegroundColor White "Deviation Space","${FAcolor}$("$($script:FinalAngle.ToString("0.00"))°")".PadLeft($SpacingToLeft2),"${VTDefault}$($PreviousAngle.ToString("0.00"))°".PadLeft($SpacingToLeft2+4)
        Write-Host -ForegroundColor White "Deviation Planet","${FALcolor}$("$($FinalAngleLocal.ToString("0.00"))°")".PadLeft($SpacingToLeft2-1),"${VTDefault}$($PreviousAngleLocal.ToString("0.00"))°".PadLeft($SpacingToLeft2+4)
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
        [decimal]$PosShipX = $ShipRotationValueX1 * 1000
        [decimal]$PosShipY = $ShipRotationValueY1 * 1000
        [decimal]$PosShipZ = $ShipRotationValueZ1 * 1000
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

        [decimal]$DistanceShipToPlanetAlignment = [math]::Sqrt([math]::pow(($CurrentXPosition - $FinalPlanetDataX),2) + [math]::pow(($CurrentYPosition - $FinalPlanetDataY),2) + [math]::pow(($CurrentZPosition - $FinalPlanetDataZ),2))
        [decimal]$DistancePoiToPlanet = [math]::Sqrt([math]::pow($DestCoordDataX - ($PlanetCoordDataX * 1000),2) + [math]::pow($DestCoordDataY - ($PlanetCoordDataY * 1000),2) + [math]::pow($DestCoordDataZ - ($PlanetCoordDataZ * 1000),2))
        #$ClosestQM = $QMDistancesCurrent | Where-Object {$_.QuantumMarkerTo -NotContains $ClosestQMStart.QuantumMarkerTo} | Sort-Object -Property Distance | Select-Object -First 1 
        if($PlanetaryPoi){

            if($ShipOMClosest -eq "OM3" -OR $ShipOMClosest -eq "OM4"){     
                [decimal]$TriangleYB = $PoiCoordDataY - $ShipRotationValueY1
                [decimal]$TriangleYA = $PoiCoordDataZ - $ShipRotationValueZ1
                [decimal]$TriangleYC = [math]::Sqrt([math]::pow($TriangleYA,2) + [math]::pow($TriangleYB,2)) 
                [decimal]$TriangleYAlpha = [math]::ASin($TriangleYA / $TriangleYC) * 180 / [System.Math]::PI         
                #$TriangleYAlpha 

                [decimal]$TriangleXA = $ShipRotationValueX1 + $PoiCoordDataX                                  
                [decimal]$TriangleXB = $PoiCoordDataY - $ShipRotationValueY1                                                          
                [decimal]$TriangleXC = [math]::Sqrt([math]::pow($TriangleXA,2) + [math]::pow($TriangleXB,2))  
                if($ShipOMClosest -eq "OM3"){[decimal]$TriangleXAlpha = [math]::Sin($TriangleXA / $TriangleXC) * 180 / [System.Math]::PI * -1} 
                if($ShipOMClosest -eq "OM4"){[decimal]$TriangleXAlpha = [math]::Sin($TriangleXA / $TriangleXC) * 180 / [System.Math]::PI} 
                if($TriangleXAlpha -lt 0){$TriangleXAlpha = 360 + $TriangleXAlpha}

                [decimal]$FinalHorizontalAngle = [Math]::Round($TriangleXAlpha)
                [decimal]$FinalVerticalAngle = [Math]::Round($TriangleYAlpha)

                Write-Host -ForegroundColor DarkGray "TURRET DIRECTIONS", "ANGLE".PadLeft(10)
                Write-Host -ForegroundColor White "Horizontal".PadRight(15) "${VTGreen}$FinalHorizontalAngle°${VTDefault}" #.PadLeft(18)
                Write-Host -ForegroundColor White "Vertical".PadRight(16) "${VTGreen}$FinalVerticalAngle°${VTDefault}" #.PadLeft(20)
                #Write-Host "Ship Position","${VTGreen}OM3/4".padLeft(11)
                #Write-Host "Planet: ${VTGreen}$($SelectedPlanet.Name)${VTDefault}, Orbital Marker: ${VTGreen}$ShipOMClosest${VTDefault}, Alignment: ${VTGreen}Planet Centre"
                Write-Host -ForegroundColor White "Alignment","Nose: ${VTGreen}Planet Centre${VTDefault}, Wings: ${VTGreen}OM5-6${VTDefault}, Top: ${VTGreen}OM-1".padLeft(72)
            }

            if($ShipOMClosest -eq "OM5" -OR $ShipOMClosest -eq "OM6"){       
                if($ShipOMClosest -eq "OM6"){[decimal]$TriangleYA = $PoiCoordDataZ + $ShipRotationValueZ1}
                [decimal]$TriangleYA = $PoiCoordDataZ - $ShipRotationValueZ1
                if($ShipOMClosest -eq "OM6"){[decimal]$TriangleYA = $PoiCoordDataZ - $ShipRotationValueZ1}
                [decimal]$TriangleYB = $PoiCoordDataX - $ShipRotationValueX1
                [decimal]$TriangleYC = [math]::Sqrt([math]::pow($TriangleYA,2) + [math]::pow($TriangleYB,2)) 
                [decimal]$TriangleYAlpha = [math]::ASin($TriangleYA / $TriangleYC) * 180 / [System.Math]::PI         
                #$TriangleYAlpha 

                [decimal]$TriangleXA = $PoiCoordDataY - $ShipRotationValueY1                                     
                [decimal]$TriangleXB = $PoiCoordDataX - $ShipRotationValueX1                                                             
                [decimal]$TriangleXC = [math]::Sqrt([math]::pow($TriangleXA,2) + [math]::pow($TriangleXB,2))        
                [decimal]$TriangleXAlpha = [math]::ASin($TriangleXA / $TriangleXC) * 180 / [System.Math]::PI
                if($ShipOMClosest -eq "OM5"){[decimal]$TriangleXAlpha = [math]::ASin($TriangleXA / $TriangleXC) * 180 / [System.Math]::PI} 
                if($ShipOMClosest -eq "OM6"){[decimal]$TriangleXAlpha = [math]::ASin($TriangleXA / $TriangleXC) * 180 / [System.Math]::PI * -1}   
                if($TriangleXAlpha -lt 0){$TriangleXAlpha = 360 + $TriangleXAlpha}
                #$TriangleXAlpha

                $FinalHorizontalAngle = [Math]::Round($TriangleXAlpha)
                $FinalVerticalAngle = [Math]::Round($TriangleYAlpha)

                Write-Host -ForegroundColor DarkGray "TURRET DIRECTIONS", "ANGLE".PadLeft(10)
                Write-Host -ForegroundColor White "Horizontal".PadRight(15) "${VTGreen}$FinalHorizontalAngle°${VTDefault}" #.PadLeft(18)
                Write-Host -ForegroundColor White "Vertical".PadRight(16) "${VTGreen}$FinalVerticalAngle°${VTDefault}" #.PadLeft(20)
                #Write-Host "Ship Position","${VTGreen}OM5/6".padLeft(11)
                #Write-Host "Planet: ${VTGreen}$($SelectedPlanet.Name)${VTDefault}, Orbital Marker: ${VTGreen}$ShipOMClosest${VTDefault}, Alignment: ${VTGreen}Planet Centre"
                Write-Host -ForegroundColor White "Alignment","Nose: ${VTGreen}Planet Centre${VTDefault}, Wings: ${VTGreen}OM3-4${VTDefault}, Top: ${VTGreen}OM-1".padLeft(72)
            }

            if($ShipOMClosest -eq "OM2" -OR $ShipOMClosest -eq "OM1"){                                      
                [decimal]$TriangleYA = $PoiCoordDataY - $ShipRotationValueY1
                [decimal]$TriangleYB = $PoiCoordDataZ - $ShipRotationValueZ1
                [decimal]$TriangleYC = [math]::Sqrt([math]::pow($TriangleYA,2) + [math]::pow($TriangleYB,2)) 
                [decimal]$TriangleYAlpha = [math]::ASin($TriangleYA / $TriangleYC) * 180 / [System.Math]::PI         

                [decimal]$TriangleXA = $PoiCoordDataX - $ShipRotationValueX1                                      
                [decimal]$TriangleXB = $PoiCoordDataZ - $ShipRotationValueZ1                                                           
                [decimal]$TriangleXC = [math]::Sqrt([math]::pow($TriangleXA,2) + [math]::pow($TriangleXB,2))        
                if($ShipOMClosest -eq "OM1"){[decimal]$TriangleXAlpha = [math]::ASin($TriangleXA / $TriangleXC) * 180 / [System.Math]::PI}
                if($ShipOMClosest -eq "OM2"){[decimal]$TriangleXAlpha = [math]::ASin($TriangleXA / $TriangleXC) * 180 / [System.Math]::PI * -1}
                if($TriangleXAlpha -lt 0){[decimal]$TriangleXAlpha = 360 + $TriangleXAlpha}

                $FinalHorizontalAngle = [Math]::Round($TriangleXAlpha)
                $FinalVerticalAngle = [Math]::Round($TriangleYAlpha)

                Write-Host -ForegroundColor DarkGray "TURRET DIRECTIONS", "ANGLE".PadLeft(10)
                Write-Host -ForegroundColor White "Horizontal".PadRight(15) "${VTGreen}$FinalHorizontalAngle°${VTDefault}" #.PadLeft(18)
                Write-Host -ForegroundColor White "Vertical".PadRight(16) "${VTGreen}$FinalVerticalAngle°${VTDefault}" #.PadLeft(20)
                #Write-Host "Ship Position","${VTGreen}OM1/2".padLeft(11)
                #Write-Host "Planet: ${VTGreen}$($SelectedPlanet.Name)${VTDefault}, Orbital Marker: ${VTGreen}$ShipOMClosest${VTDefault}, Alignment: ${VTGreen}Planet Centre"
                Write-Host -ForegroundColor White "Alignment","Nose: ${VTGreen}Planet Centre${VTDefault}, Wings: ${VTGreen}OM5-6${VTDefault}, Top: ${VTGreen}OM-3".padLeft(73)
            }

            [decimal]$XULocal = (($CurrentDestinationXCoord - $PreviousPlanetaryXCoord) * ($CurrentPlanetaryXCoord - $PreviousPlanetaryXCoord))+(($CurrentDestinationYCoord - $PreviousPlanetaryYCoord) * ($CurrentPlanetaryYCoord - $PreviousPlanetaryYCoord))+(($CurrentDestinationZCoord - $PreviousPlanetaryZCoord) * ($CurrentPlanetaryZCoord - $PreviousPlanetaryZCoord))
            [decimal]$xab_distLocal = CalcDistance3d $CurrentPlanetaryXCoord $CurrentPlanetaryYCoord $CurrentPlanetaryZCoord $PreviousPlanetaryXCoord $PreviousPlanetaryYCoord $PreviousPlanetaryZCoord 
            if ($xab_distLocal -lt 1) {$xab_distLocal=1}
            [decimal]$XULocal2 = $XULocal/($xab_distLocal * $xab_distLocal)
            [decimal]$closestXLocal = [decimal]$PreviousPlanetaryXCoord + [decimal]$XULocal2 * ($CurrentPlanetaryXCoord - $PreviousPlanetaryXCoord)
            [decimal]$closestYLocal = [decimal]$PreviousPlanetaryYCoord + [decimal]$XULocal2 * ($CurrentPlanetaryYCoord - $PreviousPlanetaryYCoord)
            [decimal]$closestZLocal = [decimal]$PreviousPlanetaryZCoord + [decimal]$XULocal2 * ($CurrentPlanetaryZCoord - $PreviousPlanetaryZCoord)
            #$c1 = CalcDistance3d $DestCoordDataX $DestCoordDataY $DestCoordDataZ $PreviousXPosition $PreviousYPosition $PreviousZPosition
            [decimal]$c2Local = CalcDistance3d $CurrentDestinationXCoord $CurrentDestinationYCoord $CurrentDestinationZCoord $CurrentPlanetaryXCoord $CurrentPlanetaryYCoord $CurrentPlanetaryZCoord
            [decimal]$pathErrorLocal = CalcDistance3d $CurrentDestinationXCoord $CurrentDestinationYCoord $CurrentDestinationZCoord $closestXLocal $closestYLocal $closestZLocal
            #Write-Host "Path Error = $pathError"
            [decimal]$perrdLocal = [math]::atan2($pathErrorLocal, $c2Local) * 180.0 / [math]::pi
            # above ok, below 0
            [decimal]$FinalAngleLocal = [math]::Round($perrdLocal,2)

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
            Write-Host -ForegroundColor White "Angle".PadLeft(5),"$AngleGroundVehicles°".PadLeft(24),"${VTGreen}good${VTDefault}".PadLeft(19)
            }
            else {
            Write-Host -ForegroundColor White "Angle".PadLeft(5),"$AngleGroundVehicles°".PadLeft(24)," ${VTRed}bad${VTDefault}".PadLeft(19)
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
            Write-Host -ForegroundColor White "Distance".PadLeft(8),"${DistanceGVColor}$DistanceTKM $DistanceTM".PadLeft(26),"${TendencyColor}$TendecyStatus${VTDefault}".PadLeft(19)
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


        #Deviation Planet            14,66°
        # GV Angle                   8° 
        #Result                      1.57 and 3.08
        #$PreviousPlanetaryXCoord   = "378.546" 
        #$PreviousPlanetaryYCoord   = "853.506"
        #$PreviousPlanetaryZCoord   = "640.661"
        #$CurrentPlanetaryXCoord    = "380.138"
        #$CurrentPlanetaryYCoord    = "851.182"
        #$CurrentPlanetaryZCoord    = "643.012"
        #$CurrentDestinationXCoord  = "561.471"
        #$CurrentDestinationYCoord  = "545.471"
        #$CurrentDestinationZCoord  = "808.832"

        # Calculations with z = up
        ### USE DECIMAL ISNTEAD OF DOUBLE !!!
        #Angle on X/Y Pane only, Deviation
        [decimal]$TriangleAA = [math]::Sqrt([Math]::Abs(([math]::pow($CurrentPlanetaryXCoord - $PreviousPlanetaryXCoord,2))   + ([math]::pow($CurrentPlanetaryYCoord - $PreviousPlanetaryYCoord,2)))) 
        [decimal]$TriangleAB = [math]::Sqrt([Math]::Abs(([math]::pow($CurrentPlanetaryXCoord - $CurrentDestinationXCoord,2))  + ([math]::pow($CurrentPlanetaryYCoord - $CurrentDestinationYCoord,2)))) 
        [decimal]$TriangleAC = [math]::Sqrt([Math]::Abs(([math]::pow($PreviousPlanetaryXCoord - $CurrentDestinationXCoord,2)) + ([math]::pow($PreviousPlanetaryYCoord - $CurrentDestinationYCoord,2)))) 
        [decimal]$TriangleAAlpha = [math]::Round([math]::Acos(([math]::pow($TriangleAA,2) + [math]::pow($TriangleAB,2) - [math]::pow($TriangleAC,2))/(2 * $TriangleAA * $TriangleAB)),2) 

        #Angle on Z Pane only, Deviation
        [decimal]$TriangleBA = [math]::Sqrt([Math]::Abs(([math]::pow($CurrentPlanetaryZCoord,2) - [math]::pow([decimal]$PreviousPlanetaryZCoord,2))))
        [decimal]$TriangleBB = [math]::Sqrt([Math]::Abs(([math]::pow($CurrentPlanetaryZCoord,2) - [math]::pow($CurrentDestinationZCoord,2))))
        [decimal]$TriangleBC = [math]::Sqrt([Math]::Abs(([math]::pow($TriangleBA,2) + [math]::pow($TriangleBB,2))))
        [decimal]$TriangleBAlpha = [math]::Round([math]::Acos(([math]::pow($TriangleBA,2) + [math]::pow($TriangleBB,2) - [math]::pow($TriangleBC,2)) / (2 * $TriangleBA * $TriangleBB)),2) 

        #Write-Host "Up/Down = $TriangleBAlpha, Left/Right = $TriangleAAlpha"
        
        #Write-Host "x $PreviousPlanetaryXCoord $CurrentPlanetaryXCoord $CurrentDestinationXCoord"
        #Write-Host "y $PreviousPlanetaryYCoord $CurrentPlanetaryYCoord $CurrentDestinationYCoord"
        #Write-Host "z $PreviousPlanetaryZCoord $CurrentPlanetaryZCoord $CurrentDestinationZCoord"

        #99.804 - 99.258                     = 0,546000000000006
        #10.804 - 10.258                     = 0,546000000000001
        #[decimal]99.804 - [decimal]99.258     = 0,546000000000006
        #[decimal]99.804 - [decimal]99.258   = 0,546

        ###############################################
        ### ORBITal DROP INSTRUCTIONS AND DiSTANCES ###
        ###############################################
        #Delta       #Player         #Destination
        [decimal]$LatDelta =  $WgsLatitude  - $WgsLatitude_Destination 
        [decimal]$LongDelta = $WgsLongitude - $WgsLongitude_Destination

        # Bodyradius = 1.000.000m, Circumferrence = 6287313.36 #correct
        [decimal]$CircumDestination = [Math]::Round(2 * [math]::PI * ([int]$DestinationBodyRadius + [int]$WgsHeight_Destination), 0)

        #Conversion of Angles into Meters
        #$CurrentDistanceTotal

        # Xdist = 144m
        # YDist = 155m
        # ZDist = 90m
        # Delta = 229.91m # correct
        # Lat + Long = 182m 
        # 47m inaccuracy or 20%

        [decimal]$LatDist  = $CircumDestination / 360 * $LatDelta 
        [decimal]$LongDist = $CircumDestination / 360 * $LongDelta

        $LatDistKM  = '{0:N0}' -f [math]::Truncate($LatDist/1000).ToString('N0')+"km" 
        $LatDistM   = ($LatDist/1000).ToString('N3').split(',')[1]+"m"

        $LongDistKM = '{0:N0}' -f [math]::Truncate($LongDist/1000).ToString('N0')+"km" 
        $LongDistM  = ($LongDist/1000).ToString('N3').split(',')[1]+"m"

        $WgsHeightDot = '{0:N0}' -f $WgsHeight
        $WgsHeight_DestinationDot = '{0:N0}' -f $WgsHeight_Destination

        
        switch($script:CurrentDetectedObjectContainer){
          #"Aberdeen"    {$FallingSpeed = 0}
          #"Arial"       {$FallingSpeed = 0}  
          #"Calliope"    {$FallingSpeed = 0}
          #"Cellin"      {$FallingSpeed = 0}
          #"Clio"        {$FallingSpeed = 0}
          "Crusader"    {$FallingSpeed = 89.14} #Cyclone, 45729m in 513secs
          "Daymar"      {$FallingSpeed = 31.80} #Mule,    15232m in 479sec
          #"Euterpe"     {$FallingSpeed = 0}
          #"Ita"         {$FallingSpeed = 0}
          #"Magda"       {$FallingSpeed = 0}
          #"Microtech"   {$FallingSpeed = 0} # Player, 141 m/s, 2681m in 19secs
          #"Lyria"       {$FallingSpeed = 0}          
          #"Wala"        {$FallingSpeed = 0}
          Default       {$FallingSpeed = 89.14}
        }
        #debug 
        $DeltaSeconds = '{2:00}' -f $LastUpdateRaw1.Hours,$LastUpdateRaw1.Minutes,$LastUpdateRaw1.Seconds
        $DeltaSpeed = [math]::Round($CurrentDeltaTotal / $DeltaSeconds, 2)
        $DeltaDistance = [math]::Round($CurrentDeltaTotal, 2)

        $DifferenceHeightMin = [System.Math]::Truncate(($WgsHeight - $WgsHeight_Destination) / $FallingSpeed / 60)
        $DifferenceHeightSec = [System.Math]::Truncate(((($WgsHeight - $WgsHeight_Destination) / $FallingSpeed) % 60) / 100 * 60)
        Write-Host "Drop Debug - Speed: $DeltaSpeed m/s, Distance: $DeltaDistance m, Duration: $DeltaSeconds sec"

        Write-Host -ForegroundColor DarkGray "ORBITAL DROP   Lat (+North/-South)    Long (+East/-West)"
        Write-Host -ForegroundColor White "Distance $($LatDistKM.PadLeft(10)) $LatDistM $($LongDistKM.PadLeft(16)) $LongDistM"
        Write-Host -ForegroundColor White "Height         Player: $WgsHeightDot         Destination: $WgsHeight_DestinationDot"
        Write-Host -ForegroundColor White "Traveltime     $($DifferenceHeightMin)min $($DifferenceHeightSec)sec"

        #Spacing depends on positive or negative values +/- 1 digit
        #Spacing is relevant to 1,2,3 or more leading digits
        Write-Host ""

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

        [decimal]$EpochTime = Get-Date $DateTime -UFormat %s
        $Logindex = 0
        
        if ($ScriptLoopCount -lt 1) {
            #ADD HEADING TO LOGFILE
            if(-not(Test-Path -Path $LogFilename -PathType Leaf)){
                $LogHeading = "Key, Systemname, Global X (m), Global Y (m), Global Z (m), Planetname, Local X (km), Local Y (km), Local Z (km), Latitude, Longitude, Height (m), Lat2d-X (m), Long2D-Y (m), Date (Epoch), Datetime (UTC), Playername, Comment"
                $LogHeading >> $LogFilename
            }

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
            #GameLogDetails.Count
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
            [decimal]$Circum = ([Math]::PI * [Math]::Pow(([decimal]$CurrentDetectedBodyRadius + $WgsHeight),2))
            [decimal]$LatInMeters  = $Circum / 180 * $WgsLatitude 
            [decimal]$LongInMeters = $Circum / 360 * $WgsLongitude
            
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
        [decimal]$PreviousXPosition     = $CurrentXPosition
        [decimal]$PreviousYPosition     = $CurrentYPosition
        [decimal]$PreviousZPosition     = $CurrentZPosition
        [decimal]$PreviousDistanceTotal = $CurrentDistanceTotal
        [decimal]$PreviousDistanceX     = $CurrentDistanceX
        [decimal]$PreviousDistanceY     = $CurrentDistanceY
        [decimal]$PreviousDistanceZ     = $CurrentDistanceZ
                 $PreviousTime          = $DateTime
        [decimal]$PreviousAngle         = $FinalAngle
        [decimal]$PreviousAngleLocal    = $FinalAngleLocal
        #Write-Host $PreviousPlanetaryXCoord $CurrentPlanetaryXCoord $PreviousPlanetaryYCoord $CurrentPlanetaryYCoord $PreviousPlanetaryZCoord $CurrentPlanetaryZCoord

        if($PreviousPlanetaryXCoord -ne $CurrentPlanetaryXCoord -or $PreviousPlanetaryYCoord -ne $CurrentPlanetaryYCoord -or $PreviousPlanetaryZCoord -ne $CurrentPlanetaryZCoord -and $ClipboardContainsCoordinates){
            #write-host "delta occured"
            [decimal]$PreviousPlanetaryXCoord = $CurrentPlanetaryXCoord
            [decimal]$PreviousPlanetaryYCoord = $CurrentPlanetaryYCoord
            [decimal]$PreviousPlanetaryZCoord = $CurrentPlanetaryZCoord
        }
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

<#
$DefaultVariables = Get-Variable -Scope GLOBAL
$DefaultVariables += "debug"
$DefaultVariables += "UseTestdata"
$DefaultVariables += "ErrorActionPreference"
$ExcludeList = $DefaultVariables.Name -join ','
$CustoMVariables = Get-Variable -Exclude $ExcludeList

foreach($variable in $CustoMVariables){
    #$variable.Name
    #$variable.Value
    $variable.GetType().FullName
    if($variable -is [String]){write-host $variable.Name}
}
#>