# Script to use CIG Coordinate System with Status Update

############
### TODO ###
############
# CHECK HOUR ANGLE MURPHYS SHEET AD6 with this script
# there might be a wrong covnersion when exceeding 360° , output script hour angle each update
##################
### Parameters ###
##################
#DISABLE FOR DEBUGGING !!!
$ErrorActionPreference = 'SilentlyContinue'
#$debug = $false
#$debug = $true 

#SELECT CURRENT POI / DESTINATION FROM HASBTABLE LINE 22
$DistanceGreen = 1000      # Set Distance in meters when values should turn green (1km)
$DistanceYellow = 100000    # Set Distance in meters when values should turn yellow (100km)
$QMDistanceGreen = 100000    # QM Distance Green
$QMDistanceYellow = 1000000   # QM Distance Yellow

#GLOBAL PARAMETERS
$CustomCoordsProvided = $false  #set to false per default, in case not selected or script is run again 
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


#Set-StrictMode -Version 2.0    #Display all errors while directly running script
#Set-Location -Path $PSScriptRoot

#################
### FUNCTIONS ###
#################
#Import Functions defined in dedicated files
# IF ScRIPT STOPS TO UPDATE, SOME ONE OF THESE FUNCTION FILEs IS BUGGED
#LAST TIME A FUNCTIONS BRACKET WAS WRITTEN IN THE NEXT LIEN INSTEAD BEHIND THE FUNCTION
. '.\functions\Calculations Planetary.ps1'
. '.\functions\Calculations Space.ps1'
. '.\functions\Dynamic Forms GUI.ps1'
. '.\functions\Generic.ps1'
. '.\functions\Hotkeys and game interactions.ps1'
. '.\functions\StarCitizen Generic.ps1'
. '.\functions\Window settings and controls.ps1'


#ENABLE BULTIN POWERSHELL V5 SUPPORT
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
$ObjectContainerData = Import-Csv -Delimiter ";" $OcCsvPath | Select-Object -Skip 1
$PointsOfInterestOnPlanetsData = Import-Csv -Delimiter ";" $PoiPlanetsCsvPath | Select-Object -Skip 1
$PointsOfInterestInSpaceData = Import-Csv -Delimiter ";" $PoiSpaceCsvPath | Select-Object -Skip 1

# FILTER FOR SPECIFIC VALUES AND SET ANOTHER ARRAY
$DataGroupDestinations = $PointsOfInterestOnPlanetsData.Name


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
#DETERMINE SCRIPT PATH WITHIN VSCODE, iSE OR POWERSHELL
#if($env:TERM_PROGRAM -eq "vscode"){$script:ScriptDir = $psEditor.GetEditorContext().CurrentFile.Path -replace '[^\\]+$'}
#if($psISE){$script:ScriptDir = Split-Path -Path $psISE.CurrentFile.FullPath}
#if((Get-Host).Version.Major -gt "5"){$script:ScriptDir = $PSScriptRoot}
#else{$script:ScriptDir = $PSScriptRoot}

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
#}


if ($ScriptLoopCount -eq 0){
    #Add-Type -AssemblyName System.Windows.Forms
    $ScreenResolution = [System.Windows.Forms.Screen]::AllScreens
    $WindowSizeY = 35
    $WindowSizeX = 85
    $MaxX = $ScreenResolution[0].WorkingArea.Width -720 
    #$MaxY = $ScreenResolution[0].WorkingArea.Height
    Move-Window $MaxX 5 | Out-Null
    Set-WindowSize $WindowSizeY $WindowSizeX
    Set-ConsoleAlwaysOnTop | Out-Null
    #Set-ConsoleBordersRemoval
    #Set-ConsoleOpacity 75
}

#CLEAR OLD VARIABLES
#$SelectedDestination = @{}

#IDEA 
# REGISTER FINAL ENTER SEND TO STARCITIZEN AND GRAB TIMESTAMP
# RUN MULTIPLE SCRIPTS AT THE SAME TIME TO CHECK TIME DIAVATION ?!

#CHECK CLIPBOARD FOR NEW VALUES 
while($StartNavigation) {
    #Get ClipboardContents and Get Current Date/Time
    $ClipboardContainsCoordinates, $CurrentXPosition, $CurrentYPosition, $CurrentZPosition, $DateTime = Get-StarCitizenClipboardAndDate
    
    ### KEY TO SAVE CURRENT COORDINATES TO TEXTFILE ###
    # CODE BY BIGCHEESE
    $pressed = Test-KeyPress -Key "S" -ModifierKey 'Control'
    if ($pressed) {
        $PoiName = Read-Host -Prompt 'Input the name of the POI: '
        #$SystemName = Read-Host -Prompt 'Input the Systemname your currently in (Stanton, Pyro, Nyx): '
        $SystemName = "Stanton"
        if($script:CurrentDetectedObjectContainer){$PoiToSave = "$SystemName;$CurrentDetectedObjectContainer;CustomType;$PoiName;$CurrentPlanetaryXCoord;$CurrentPlanetaryYCoord;$CurrentPlanetaryZCoord;$DateTime"} #IF ON A PLANET
        else {$PoiToSave = "$SystemName;Custom POI Type;$PoiName;$CurrentXPosition;$CurrentYPosition;$CurrentZPosition;$DateTime"} #ELSE IF IN SPACE
        $PoiToSave  >> 'Data\saved_locations.csv' #WRITE CURRENT LINES TO TEXTFILE
        Write-Host "... saved $PoiName to Data\saved_locations.csv"
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
            $LiveResults.Text = $ErrorMessageCustomCoords
            Show-Frontend
        }

    }
    # IF THIS LINE IS NOT PRESENT, CPU USAGE WILL CONSUME A FULL THREAD
    # AND SCRIPTS MIGHT GET UNRESPONSIVE 
    Start-Sleep -Milliseconds 1
    #################################################
    ### POI ON ROTATING OBJECT CONTAINER, PLANETS ###
    #################################################
    if($script:PlanetaryPoi){
        #GET UTC SERVER TIME, ROUND MILLISECONDS IN 166ms steps (6 to 1 second conversion)
        #Function currently prevents script from continuing
        $ErrorActionPreference S
        $ElapsedUTCTimeSinceSimulationStart# = Get-ElapsedUTCServerTime

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
        $DestCoordData = $SelectedDestination.Value -Split ";"
        $DestCoordDataX = $DestCoordData[0]
        $DestCoordDataY = $DestCoordData[1]
        $DestCoordDataZ = $DestCoordData[2]
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
    Write-Host -ForegroundColor Yellow "Updated: $($DateTime.ToString('HH:mm:ss')), last update: $LastUpdate, Destination: $DestinationName"
    #Write-Host -ForegroundColor Yellow $DateTime.ToString('HH:mm:ss:ffff')

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
        $ObjectContainerX         = $ObjectContainer.'X-Coord'
        $ObjectContainerY         = $ObjectContainer.'Y-Coord'
        $ObjectContainerZ         = $ObjectContainer.'Z-Coord'
        $ObjectContainerRotSpeed  = $ObjectContainer.RotationSpeedX
        $ObjectContainerRotAdjust = $ObjectContainer.RotationAdjustmentX
        $ObjectContainerOMRadius  = $ObjectContainer.OrbitalMarkerRadius
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
    $OCJulianDate = $ElapsedUTCTimeSinceSimulationStart.TotalDays               #CORRECT
    $OCTotalCycles = $OCJulianDate / $OCLengthOfDayDecimal                      #CORRECT
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
        if($PreviousTime -gt 0){$CurrentETA = $CurrentDistanceTotal/($CurrentDeltaTotal/($DateTime - $PreviousTime).TotalSeconds)}
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

    ### CREATE CROSSHAIR OVERLAY ###
    Set-CrosshairOnScreen $FinalHorizontalAngle $FinalVerticalAngle

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
        #$LiveResults.Text = ($FinalInstructions | Format-Table -Property @{Name="Step"; Expression={$_.Step}; Align="Center"},Type,Direction,QuantumMarker,@{Name="Distance"; Expression={$_.Distance}; Align="Right"},@{Name="TargetDistance"; Expression={$_.TargetDistance}; Align="Right"} | Out-String)
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
        #$LiveResults.Text = ($FinalInstructions | Format-Table -Property @{Name="Step"; Expression={$_.Step}; Align="Center"},Type,Direction,QuantumMarker,@{Name="JumpDistance"; Expression={$_.JumpDistance}; Align="Right"},@{Name="TargetDistance"; Expression={$_.TargetDistance}; Align="Right"} | Out-String)
    }
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
    Start-Sleep -Milliseconds 1
    
    }
    else{
        if(!$CoordinatesSubmitted){
            Start-Sleep -Milliseconds 700
            cls
            $max = [System.ConsoleColor].GetFields().Count - 1 
            $color = [System.ConsoleColor](Get-Random -Min 1 -Max $max)
            $text1 = "Please issue "
            $text2 = "/showlocation "
            $text3 = "command in chat to display results"
            $Milliseconds= 25
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

$ASCIIPIC =@'                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
TEST                                                                                                                                                                                       
'@
            if($WaitCount -eq 5){WRITE-HOST $ASCIIPIC; Start-Sleep -Milliseconds 5000}
            $WaitCount++
        }
    }
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