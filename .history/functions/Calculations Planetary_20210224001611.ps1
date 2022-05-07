function PPP{}
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