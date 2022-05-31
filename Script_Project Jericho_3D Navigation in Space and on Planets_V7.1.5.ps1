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
            $ObjectContainerRotSpeedX = $ObjectContainer.RotationSpeedX
            $ObjectContainerRotSpeedY = $ObjectContainer.RotationSpeedY
            $ObjectContainerRotSpeedZ = $ObjectContainer.RotationSpeedZ
            $ObjectContainerRotAdjustX = $ObjectContainer.RotationAdjustmentX
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
                $script:CurrentDetectedOCX  = $ObjectContainer."X-Coord"    #$ObjectContainerX
                $script:CurrentDetectedOCY  = $ObjectContainer."Y-Coord"    #$ObjectContainerY
                $script:CurrentDetectedOCZ  = $ObjectContainer."Z-Coord"    #$ObjectContainerZ
                $script:CurrentDetectedOCRS = $ObjectContainerRotSpeedX #check
                $script:CurrentDetectedOCADW = $ObjectContainerRotAdjustW 
                $script:CurrentDetectedOCADX = $ObjectContainerRotAdjustX
                $script:CurrentDetectedOCADY = $ObjectContainerRotAdjustY
                $script:CurrentDetectedOCADZ = $ObjectContainerRotAdjustZ
                $script:CurrentDetectedOCRadius = $ObjectContainerOMRadius
                $script:CurrentDetectedBodyRadius = $ObjectContainerBodyRadius
                $script:CurrentOCQuadW = $ObjectContainer.RotQuatW
                $script:CurrentOCQuadX = $ObjectContainer.RotQuatZ
                $script:CurrentOCQuadY = $ObjectContainer.RotQuatY
                $script:CurrentOCQuadZ = $ObjectContainer.RotQuatZ
                #$ObjectContainer.Name
                
            }
            #DEBUG IF A COORD MIGH TBE CORRECT; BUT MATCHES NOT BECAUSE OF A TYPO
            #if($WithinX -or $WithinY){
                #$ObjectContainer.Name
                #$ObjectContainerX
                #$ObjectContainerY
                #$ObjectContainerZ
                #Write-Host "Stanton Coords $CurrentXPosition $CurrentYPosition $CurrentZPosition"
            #}
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
        if($script:CurrentDetectedObjectContainer){$OrbitalMarkers = "Player      : ".PadRight(14)+"${VTDarkGray}OM1:${VTDefault}$FinalOM1${VTDarkGray}".PadRight(29)+"OM2:${VTDefault}$FinalOM2${VTDarkGray}".PadRight(24)+"OM3:${VTDefault}$FinalOM3${VTDarkGray}".PadRight(24)+"OM4:${VTDefault}$FinalOM4${VTDarkGray}".PadRight(24)+"OM5:${VTDefault}$FinalOM5${VTDarkGray}".PadRight(24)+"OM6:${VTDefault} $FinalOM6"}
        else{$OrbitalMarkers = "Player      : ${VTRed}in Space${VTDefault}"}
        #Write-Host -ForegroundColor White "OM Distance :  ${VTDarkGray}OM1:${VTDefault} $FinalOM1"

        #OM DISTANCES FOR DESTINATION
        #MicroTech / Daymar Fix
        $DestinationOCRadius = ($ObjectContainerData.GetEnumerator() | Where-Object {$_.Name -contains $SelectedDestination.ObjectContainer}).OrbitalMarkerRadius
        #$DestinationOCRadius = ($ObjectContainerData.GetEnumerator() | Where-Object {$_.Name -contains $SelectedDestination.ObjectContainer}).BodyRadius
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
        #$RadialDistance = [math]::Sqrt([double]$CurrentXPosition * [double]$CurrentXPosition + [double]$CurrentYPosition * [double]$CurrentYPosition + [double]$CurrentZPosition * [double]$CurrentZPosition)
        $RadialDistance = [math]::Sqrt([double]$CurrentPlanetaryXCoord * [double]$CurrentPlanetaryXCoord + [double]$CurrentPlanetaryYCoord * [double]$CurrentPlanetaryYCoord + [double]$CurrentPlanetaryZCoord * [double]$CurrentPlanetaryZCoord)
        $WgsHeight = [math]::Round($RadialDistance*1000 - [double]$CurrentDetectedBodyRadius, 0)
        $WgsLatitude = [math]::Round([math]::ASin($CurrentPlanetaryZCoord / $RadialDistance) * 180 / [Math]::PI,6)
        $WgsLongitude = [math]::Round([math]::Atan2($CurrentPlanetaryXCoord, $CurrentPlanetaryYCoord) * 180 / [Math]::PI,6) * -1

        $WGSSpacing = 17
        $WGS     = "Player      : ".PadRight($WGSSpacing),"${VTDarkgray}Lat: ${VTDefault}$WgsLatitude°".PadRight($WGSSpacing+9),"${VTDarkgray}Long:${VTDefault}$WgsLongitude°".PadRight($WGSSpacing+14),"${VTDarkgray}Height: ${VTDefault}$WgsHeight"
    
        
        #doabigcheese Bearing Berechnung
        $RadialDistance_Destination = [math]::Sqrt([double]$CurrentDestinationXCoord * [double]$CurrentDestinationXCoord + [double]$CurrentDestinationYCoord * [double]$CurrentDestinationYCoord + [double]$CurrentDestinationZCoord * [double]$CurrentDestinationZCoord)  
        $WgsLatitude_Destination = [math]::Round([math]::ASin([double]$CurrentDestinationZCoord / [double]$RadialDistance_Destination) * 180 / [Math]::PI, 6)
        $WgsLongitude_Destination = [math]::Round([math]::Atan2([double]$CurrentDestinationXCoord, [double]$CurrentDestinationYCoord) * 180 / [Math]::PI * -1, 6)
    

        $DestinationBodyRadius = ($ObjectContainerData.GetEnumerator() | Where-Object {$_.Name -contains $SelectedDestination.ObjectContainer}).BodyRadius
        $WgsHeight_Destination = [math]::Round($RadialDistance_Destination * 1000 - [double]$DestinationBodyRadius, 0)

        $WgsLatitude_Destination_ = $WgsLatitude_Destination * [Math]::PI / 180
        $WgsLongitude_Destination_ = $WgsLongitude_Destination * [Math]::PI / 180

        $WGSDest = "Destination : ".PadRight($WGSSpacing),"${VTDarkgray}Lat: ${VTDefault}$WgsLatitude_Destination°".PadRight($WGSSpacing+9),"${VTDarkgray}Long:${VTDefault}$WgsLongitude_Destination°".PadRight($WGSSpacing+14),"${VTDarkgray}Height: ${VTDefault}$WgsHeight_Destination"   

        $WgsLatitude_ = $WgsLatitude * [Math]::PI / 180
        $WgsLongitude_= $WgsLongitude * [Math]::PI / 180

    
        $bearingX = [math]::Cos([double]$WgsLatitude_Destination_) * [math]::Sin([double]$WgsLongitude_Destination_ - [double]$WgsLongitude_)
        $bearingY = [math]::Cos([double]$WgsLatitude_) * [math]::Sin([double]$WgsLatitude_Destination_) - [math]::Sin([double]$WgsLatitude_) * [math]::Cos([double]$WgsLatitude_Destination_) * [math]::Cos([double]$WgsLongitude_Destination_ - [double]$WgsLongitude_)
        $bearing = [math]::Round([math]::Atan2([double]$bearingX, [double]$bearingY) * 180 / [Math]::PI,0)
        $bearing_final = ($bearing + 360) % 360

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
        $StarRelX = $StarRelXCoord / 1000 #BSX, Cell AR3 19066589.410000000
        $StarRelY = $StarRelYCoord / 1000 #BSY, Cell AS3 3904586.165000000
        $StarRelZ = $StarRelZCoord / 1000 #BSZ, Cell AT3 2923345.368000000


        #SOLAR DECLINATION OF THE STAR
        # Cell AG3 = 8.54228846
        #=DEGREES(ACOS((((SQRT(bsx^2+bsy^2+bsz^2))^2)+((SQRT(bsx^2+bsy^2))^2)-(bsz^2))/(2*(SQRT(bsx^2+bsy^2+bsz^2))*(SQRT(bsx^2+bsy^2)))))*IF(bsz<0,-1,1)
        if($StarRelZ -lt 0){$SRMultipier = -1} else {$SRMultipier = 1}
        $Declination = ([math]::Acos((([math]::Pow(([math]::Sqrt([math]::Pow($StarRelX,2) + [math]::Pow($StarRelY,2) + [math]::Pow($StarRelZ,2))),2)) + ([math]::Pow(([math]::Sqrt([math]::Pow($StarRelX,2) + [math]::Pow($StarRelY,2))),2)) - ([math]::Pow($StarRelZ,2))) / (2 * ([math]::Sqrt([math]::Pow($StarRelX,2) + [math]::Pow($StarRelY,2) + [math]::Pow($StarRelZ,2))) * ([math]::Sqrt([math]::Pow($StarRelX,2) + [math]::Pow($StarRelY,2)))))) / [math]::pi * 180 * $SRMultipier


        #DETERMINE THE APPARENT RADIUS OF THE STAR
        # Cell AP3 = 2.02667352
        # =DEGREES(MOD((ATAN2(bsx,bsy)-(PI()/2)),2*PI()))
        $ApparentRadius = ([math]::ASin($StarRadius / ([math]::Sqrt([math]::Pow($StarRelX,2) + [math]::Pow($StarRelY,2) + [math]::Pow($StarRelZ,2))))) / [math]::pi * 180


        #$LengthOfDayDecimal     #AD3 = 0.1033333333
        #$JulianDate             #D1 = 858.009722453702		
        #$TotalCycles            #AD3 = 8303.319895
        #Star Locations if the planet wouldn rotate


        # Cell AG2
        #DEGREES(MOD((ATAN2(bsx,bsy)-(PI()/2))   ,2*PI()))
        $Meridian = (mod(([math]::atan2($StarRelY,$StarRelX) - ([math]::pi/2)), (2 * [math]::pi))) / [math]::pi * 180

        #SOLAR LONGITUDE
        # Cell AG4 = -13969050
        # =IF(CurrentRotation-MOD(0-Meridian,360)>180,CurrentRotation-MOD(0-Meridian,360)-360,IF(CurrentRotation-MOD(0-Meridian,360)<-180,CurrentRotation-MOD(0-Meridian,360)+360,CurrentRotation-MOD(0-Meridian,360)))

        IF($Meridian - (mod((0 - $Meridian),360)) -gt 180){
            $SolarLongitude = $Meridian - (mod((0 - $Meridian), 360)) -360
        } else {
            IF(($Meridian - (mod((0 - $Meridian), 360))) -lt 180) {$SolarLongitude = $Meridian - (mod((0 - $Meridian), 360)) + 360} else 
                                                                         {$SolarLongitude = $Meridian - (mod((0 - $Meridian), 360))}
        }



        
        ### LOCAL ###
        if($WgsHeight -gt 0){$Locationheight = $WgsHeight}else{$Locationheight = 0}
        $ElevationCorrection = [math]::Acos([int]$script:CurrentDetectedBodyRadius/([int]$script:CurrentDetectedBodyRadius + [int]$Locationheight)) / [math]::pi * 180

        $CurrentRotationPosition = mod((360 - (mod($TotalCycles,1)) * 360 - $script:CurrentDetectedOCADX),360)

        if([math]::Abs($WgsLatitude)-eq 90){$WgsLongtidue360 = 0}else{
            $WgsLongitude360 = (mod (([math]::Atan2($CurrentPlanetaryYCoord, $CurrentPlanetaryXCoord) - ([math]::PI / 2)), (2 * [math]::PI))) / [math]::pi * 180  
        }

        #HOUR ANGLE
        #IF(MOD(CycleHourAngle-MOD(AG44-sMeridian,360),360)>180,MOD(CycleHourAngle-MOD(AG44-sMeridian,360),360)-360,MOD(CycleHourAngle-MOD(AG44-sMeridian,360),360)
         IF(mod(($CurrentRotationPosition - (mod(($WgsLongitude360 - $Meridian), 360))),360) -gt 180){
            $HourAngleLocal = mod(($CurrentRotationPosition - (mod(($WgsLongitude360 - $Meridian), 360))),360) - 360
         }
         else{
             $HourAngleLocal = mod(($CurrentRotationPosition - (mod(($WgsLongitude360 - $Meridian), 360))),360)
         }


         #RiseSetHourAngle
         #DEGREES(ACOS(-TAN(RADIANS($WgsLatitude_Destination)) * TAN(RADIANS($Declination)))) + $ApparentRadius + $ElevationCorrectionDest
         $RiseSetHourAngle = [math]::Acos(([math]::tan($WgsLatitude * [math]::pi / 180) * -1) * [math]::tan($Declination * [math]::pi / 180)) / [math]::pi * 180 + $ApparentRadius + $ElevationCorrection

         #AngularRotationRate
         $AngularRotationRate = 6 / $script:CurrentDetectedOCRS


         #TIMES
         IF($HourAngleLocal -gt 0){
             $LocalNoon = $HourAngleLocal/$AngularRotationRate/1440
             $ColorLocalNoon = $VTWhite
            }
        else{
            $LocalNoon = (360 + $HourAngleLocal) / $AngularRotationRate /1440 
            $ColorLocalNoon = $VTRed
        }
         $LocalTime = (Get-Date)
         $LocalNoonTime = $Localtime.AddDays($LocalNoon).ToString("HH:mm")

         #SUNRISE
         $TerrainRaise = 0
         if($HourAngleDestination -gt ($RiseSetHourAngle - $TerrainRaise)){
            #
            $LocalRise = $LocalNoon - (($RiseSetHourAngle - $TerrainRaise) / $AngularRotationRate *3 / 4300)
            $ColorLocalRise = $VTWhite
         }elseif($HourAngleDestination -gt 0){
            #
            $LocalRise = $LocalNoon - (($RiseSetHourAngle - $TerrainRaise) / $AngularRotationRate *3 / 4300) + $LengthOfDayDecimal
            $ColorLocalRise = $VTDarkGray
         }else{
            # If sunrise has already happened this cycle
            $LocalRise = $LocalNoon - (($RiseSetHourAngle - $TerrainRaise) / $AngularRotationRate *3 / 4300)
            $ColorLocalRise = $VTDarkGray
         }
         $LocalRiseTime = $Localtime.AddDays($LocalRise).ToString("HH:mm")

         #SUNSET
         if($HourAngleDestination -gt (($RiseSetHourAngle - $TerrainRaise) * -1)){
            $LocalSet = $LocalNoon + (($RiseSetHourAngle + $TerrainRaise) / $AngularRotationRate *3 / 4300)
            $ColorLocalSet  = $VTRed
         }elseif($HourAngleDestination -gt 0){
            $LocalSet = $LocalNoon + (($RiseSetHourAngle + $TerrainRaise) / $AngularRotationRate *3 / 4300) - $LengthOfDayDecimal
            $ColorLocalSet  = $VTDarkGray
         }else{
            $LocalSet = $LocalNoon + (($RiseSetHourAngle + $TerrainRaise) / $AngularRotationRate *3 / 4300)
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
            {$_ -ge $Localtime.AddDays($LocalSet)}    {$NexRise = $LocalNoon - (($RiseSetHourAngle - $TerrainRaise) / $AngularRotationRate *3 / 4300) + $LengthOfDayDecimal;$RemainingLocalNighttime  = [math]::Round(($Localtime.AddDays($NexRise) - $Localtime.AddDays($LocalSet)).TotalMinutes);break}
        }
        if ($RemainingLocalDaylight -le 0) {$RemainingLocalDaylight = $RemainingLocalDaylight * -1}
        if ($RemainingLocalNighttime -le 0){$RemainingLocalNighttime = $RemainingLocalNighttime * -1}

        #Local Day Conditions # after sunrise
        $LocalDayCondition = "unknown"
        if(180 -ge $HourAngleLocal -AND $HourAngleLocal -gt ($RiseSetHourAngle + 12))                                           {$LocalDayCondition = "After Midnight";     $DayLocalColor = $VTDarkGray;   $NightLocalColor = $VTGreen}
        if($RiseSetHourAngle + 12 -ge $HourAngleLocal -AND $HourAngleLocal -gt $RiseSetHourAngle)                               {$LocalDayCondition = "Morning Twilight";   $DayLocalColor = $VTGreen;      $NightLocalColor = $VTDarkGray}
        if($RiseSetHourAngle + 12 -ge $HourAngleLocal -AND $HourAngleLocal -gt 0)                                               {$LocalDayCondition = "Morning";            $DayLocalColor = $VTGreen;      $NightLocalColor = $VTDarkGray}       
        if(0 -ge $HourAngleLocal -AND $HourAngleLocal -gt ($RiseSetHourAngle * -1))                                             {$LocalDayCondition = "Afternoon";          $DayLocalColor = $VTGreen;      $NightLocalColor = $VTDarkGray}
        if(($RiseSetHourAngle * -1) -ge $HourAngleLocal -AND $HourAngleLocal -gt (($RiseSetHourAngle * -1) - 12))               {$LocalDayCondition = "Evening Twilight";   $DayLocalColor = $VTDarkGray;   $NightLocalColor = $VTGreen}
        if(($RiseSetHourAngle * -1 -12) -ge $HourAngleLocal -AND $HourAngleLocal -ge -180)                                      {$LocalDayCondition = "Before Midnight";    $DayLocalColor = $VTDarkGray;   $NightLocalColor = $VTGreen}

        #### DESTINATION ####
        #Cell AI44 = 1,07571295561478
        if($WgsHeight_Destination -gt 0){$LocationheightD = $WgsHeight_Destination}else{$LocationheightD = 0}
        $ElevationCorrectionDest = [math]::Acos($DestinationBodyRadius/([int]$script:DestinationBodyRadius + [int]$LocationheightD)) / [math]::pi * 180

        #
        $DestinationRotAdjX = ($ObjectContainerData.GetEnumerator() | Where-Object {$_.Name -contains $SelectedDestination.ObjectContainer}).RotationAdjustmentX
        $CurrentRotationPositionD = mod((360 - (mod($TotalCycles,1)) * 360 - $DestinationRotAdjX),360)

        if([math]::Abs($WgsLatitude_Destination)-eq 90){$WgsLongtidue360D = 0}else{
            $WgsLongitude360D = (mod (([math]::Atan2($CurrentDestinationYCoord, $CurrentDestinationXCoord) - ([math]::PI / 2)), (2 * [math]::PI))) / [math]::pi * 180  
        }

        #HOUR ANGLE

        #IF(MOD(CycleHourAngle-MOD(AG44-sMeridian,360),360)>180,MOD(CycleHourAngle-MOD(AG44-sMeridian,360),360)-360,MOD(CycleHourAngle-MOD(AG44-sMeridian,360),360)
        IF((mod(($CurrentRotationPosition - (mod(($WgsLongitude360D - $Meridian), 360))),360)) -gt 180){
            $HourAngleDestination = (mod(($CurrentRotationPosition - (mod(($WgsLongitude360D - $Meridian), 360))),360)) - 360
         }
         else{
             $HourAngleDestination = mod(($CurrentRotationPosition - (mod(($WgsLongitude360D - $Meridian), 360))),360)
         }

         #RiseSetHourAngle
         #DEGREES(ACOS(-TAN(RADIANS($WgsLatitude_Destination)) * TAN(RADIANS($Declination)))) + $ApparentRadius + $ElevationCorrectionDest
         $RiseSetHourAngle = [math]::Acos(([math]::tan($WgsLatitude_Destination * [math]::pi / 180) * -1) * [math]::tan($Declination * [math]::pi / 180)) / [math]::pi * 180 + $ApparentRadius + $ElevationCorrectionDest

        #AngularRotationRate
        $AngularRotationRate = 6 / $PlanetRotationSpeed


         #TIMES
         IF($HourAngleDestination -gt 0){
            $noon = $HourAngleDestination/$AngularRotationRate/1440
            $ColorDestNoon = $VTWhite
            } 
        else{
            $noon = (360 + $HourAngleDestination) / $AngularRotationRate /1440 
            $ColorDestNoon = $VTRed
            }
         $LocalTime = (Get-Date)
         $DestNoonTime = $Localtime.AddDays($noon).ToString("HH:mm")


         #SUNRISE
         $TerrainRaise = 0
         $LengthOfDayDestination = [double]$PlanetRotationSpeed * 3600 / 86400 

         if($HourAngleDestination -gt ($RiseSetHourAngle - $TerrainRaise)){
            $rise = $noon - (($RiseSetHourAngle - $TerrainRaise) / $AngularRotationRate *3 / 4300)
            $ColorDestRise = $VTDarkGray
         }elseif($HourAngleDestination -gt 0){
            $rise = $noon - (($RiseSetHourAngle - $TerrainRaise) / $AngularRotationRate *3 / 4300) + $LengthOfDayDestination
            $ColorDestRise = $VTDarkGray
         }else{
            $rise = $noon - (($RiseSetHourAngle - $TerrainRaise) / $AngularRotationRate *3 / 4300)
            $ColorDestRise = $VTGreen
         }
         $DestRiseTime = $Localtime.AddDays($rise).ToString("HH:mm")

         #SUNSET
         if($HourAngleDestination -gt (($RiseSetHourAngle - $TerrainRaise) * -1)){
            $set = $noon + (($RiseSetHourAngle + $TerrainRaise) / $AngularRotationRate *3 / 4300)
            $ColorDestSet  = $VTRed
         }elseif($HourAngleDestination -gt 0){
            $set = $noon + (($RiseSetHourAngle + $TerrainRaise) / $AngularRotationRate *3 / 4300) - $LengthOfDayDestination
            $ColorDestSet  = $VTDarkGray
         }else{
            $set = $noon + (($RiseSetHourAngle + $TerrainRaise) / $AngularRotationRate *3 / 4300)
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
            {$_ -ge $Localtime.AddDays($rise)}    {$NexRise = $noon - (($RiseSetHourAngle - $TerrainRaise) / $AngularRotationRate *3 / 4300) + $LengthOfDayDestination;$RemainingNighttime  = [math]::Round(($Localtime.AddDays($NexRise) - $Localtime.AddDays($set)).TotalMinutes);break}
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

                Write-Host -ForegroundColor DarkGray "TURRET DIRECTIONS", "ANGLE".PadLeft(10)
                Write-Host -ForegroundColor White "Horizontal".PadRight(15) "${VTGreen}$FinalHorizontalAngle°${VTDefault}" #.PadLeft(18)
                Write-Host -ForegroundColor White "Vertical".PadRight(16) "${VTGreen}$FinalVerticalAngle°${VTDefault}" #.PadLeft(20)
                #Write-Host "Ship Position","${VTGreen}OM3/4".padLeft(11)
                #Write-Host "Planet: ${VTGreen}$($SelectedPlanet.Name)${VTDefault}, Orbital Marker: ${VTGreen}$ShipOMClosest${VTDefault}, Alignment: ${VTGreen}Planet Centre"
                Write-Host -ForegroundColor White "Alignment","Nose: ${VTGreen}Planet Centre${VTDefault}, Wings: ${VTGreen}OM5-6${VTDefault}, Top: ${VTGreen}OM-1".padLeft(72)
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

                Write-Host -ForegroundColor DarkGray "TURRET DIRECTIONS", "ANGLE".PadLeft(10)
                Write-Host -ForegroundColor White "Horizontal".PadRight(15) "${VTGreen}$FinalHorizontalAngle°${VTDefault}" #.PadLeft(18)
                Write-Host -ForegroundColor White "Vertical".PadRight(16) "${VTGreen}$FinalVerticalAngle°${VTDefault}" #.PadLeft(20)
                #Write-Host "Ship Position","${VTGreen}OM5/6".padLeft(11)
                #Write-Host "Planet: ${VTGreen}$($SelectedPlanet.Name)${VTDefault}, Orbital Marker: ${VTGreen}$ShipOMClosest${VTDefault}, Alignment: ${VTGreen}Planet Centre"
                Write-Host -ForegroundColor White "Alignment","Nose: ${VTGreen}Planet Centre${VTDefault}, Wings: ${VTGreen}OM3-4${VTDefault}, Top: ${VTGreen}OM-1".padLeft(72)
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

                Write-Host -ForegroundColor DarkGray "TURRET DIRECTIONS", "ANGLE".PadLeft(10)
                Write-Host -ForegroundColor White "Horizontal".PadRight(15) "${VTGreen}$FinalHorizontalAngle°${VTDefault}" #.PadLeft(18)
                Write-Host -ForegroundColor White "Vertical".PadRight(16) "${VTGreen}$FinalVerticalAngle°${VTDefault}" #.PadLeft(20)
                #Write-Host "Ship Position","${VTGreen}OM1/2".padLeft(11)
                #Write-Host "Planet: ${VTGreen}$($SelectedPlanet.Name)${VTDefault}, Orbital Marker: ${VTGreen}$ShipOMClosest${VTDefault}, Alignment: ${VTGreen}Planet Centre"
                Write-Host -ForegroundColor White "Alignment","Nose: ${VTGreen}Planet Centre${VTDefault}, Wings: ${VTGreen}OM5-6${VTDefault}, Top: ${VTGreen}OM-3".padLeft(73)
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

        ###############################################
        ### ORBITal DROP INSTRUCTIONS AND DiSTANCES ###
        ###############################################
        #Delta       #Player         #Destination
        $LatDelta =  $WgsLatitude  - $WgsLatitude_Destination 
        $LongDelta = $WgsLongitude - $WgsLongitude_Destination

        $CircumDestination = [Math]::Round(2 * [math]::PI * ([int]$DestinationBodyRadius + [int]$WgsHeight_Destination), 3)

        #Conversion of Angles into Meters
        $LatDist  = $CircumDestination / 180 * $LatDelta 
        $LongDist = $CircumDestination / 360 * $LongDelta

        $LatDistKM  = '{0:N0}' -f [math]::Truncate($LatDist/1000).ToString('N0')+"km" 
        $LatDistM   = ($LatDist/1000).ToString('N3').split(',')[1]+"m"

        $LongDistKM = '{0:N0}' -f [math]::Truncate($LongDist/1000).ToString('N0')+"km" 
        $LongDistM  = ($LongDist/1000).ToString('N3').split(',')[1]+"m"

        $WgsHeightDot = '{0:N0}' -f $WgsHeight
        $WgsHeight_DestinationDot = '{0:N0}' -f $WgsHeight_Destination

        $FallingSpeed = 89.14
        $DifferenceHeightMin = [System.Math]::Truncate(($WgsHeight - $WgsHeight_Destination) / $FallingSpeed / 60)
        $DifferenceHeightSec = [System.Math]::Truncate(((($WgsHeight - $WgsHeight_Destination) / $FallingSpeed) % 60) / 100 * 60)
        #Cyclone Falling Speed = 45729m in 513sec = 89,14 m/s on Crusader
        #Mule    Falling Speed = 15232m in 479sec = 31,80 m/s on Yela

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

        $EpochTime = Get-Date $DateTime -UFormat %s
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