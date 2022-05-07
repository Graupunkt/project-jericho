
function Get-ElapsedUTCServerTime{
    $sNTPServer = @("ptbtime1.ptb.de","ptbtime2.ptb.de","ptbtime3.ptb.de") 
    [DateTime]$DateTime = Get-NTPDateTime (Get-Random $sNTPServer)
    $UTCServerTime = $DateTime.ToUniversalTime() 
    
                                              # SET STARTTIME SIMULATION STARCITIZEN
    $SimulationUTCStartTime = [DateTime]"01.01.2020 00:00:00"                                                    # SET STARTTIME SIMULATION UTC
    $ElapsedUTCTimeSinceSimulationStart = New-Timespan -End $UTCServerTime -Start $SimulationUTCStartTime     # GET ELPASED TIME BETWEEN SIMULATION TIME AND CURRENT TIME
    return $ElapsedUTCTimeSinceSimulationStart
}

function Get-ElapsedUniverseTime{
    $SimulationServerStartTime = [DateTime] "01.01.2950 00:00:00"
    $SimulationTimeFactor = 6
}
function Get-StarCitizenClipboardAndDate{
    #. '.\functions\Generic.ps1'
    
    $ClipboardContentRAW = (Get-Clipboard) -replace '(^\s+|\s+$)','' -replace '\s+',' '
    $ClipboardContentSplit = $ClipboardContentRAW.split("x:").split("y:").split("z:") #GET CURRENT COORDS FROM CLIPBOARD
    #CHECK IF CLIPBOARD CONTAINS COORDINATES
    if ($ClipboardContentRAW -like '*Coordinates: x:*'){
        $ClipboardContainsCoordinates = $true 
        $CurrentXPosition = $ClipboardContentSplit[1]
        $CurrentYPosition = $ClipboardContentSplit[2]
        $CurrentZPosition = $ClipboardContentSplit[3]
        if($CurrentXPosition -ne $PreviousXPosition -or $CurrentYPosition -ne $PreviousYPosition -or $CurrentZPosition -ne $PreviousZPosition){
            $NTPServer = "ptbtime1.ptb.de"
            $NTPServer = @("ptbtime1.ptb.de","ptbtime2.ptb.de","ptbtime3.ptb.de") 
            $DateTime = Get-NTPDateTime (Get-Random $NTPServer)
            #Write-Host -ForegroundColor Yellow $DateTime.ToString('HH:mm:ss:ffff')
        }
        else{
            $DateTime = $null
        }
    }
    else {
        $CurrentXPosition = $null
        $CurrentYPosition = $null
        $CurrentZPosition = $null
        $ClipboardContainsCoordinates = $false
    }
    Write-Output $ClipboardContainsCoordinates, $CurrentXPosition, $CurrentYPosition, $CurrentZPosition, $DateTime
}

Function Save-PoiCoordinates{
    #. '.\functions\Hotkeys and game interactions.ps1'
    $PoiName = Read-Host -Prompt 'Input the name of the POI: '
    #$SystemName = Read-Host -Prompt 'Input the Systemname your currently in (Stanton, Pyro, Nyx): '
    $SystemName = "Stanton"
    if($script:CurrentDetectedObjectContainer){$PoiToSave = "$SystemName;$CurrentDetectedObjectContainer;CustomType;$PoiName;$CurrentPlanetaryXCoord;$CurrentPlanetaryYCoord;$CurrentPlanetaryZCoord;$DateTime"} #IF ON A PLANET
    else {$PoiToSave = "$SystemName;Custom POI Type;$PoiName;$CurrentXPosition;$CurrentYPosition;$CurrentZPosition;$DateTime"} #ELSE IF IN SPACE
    #WRITE CURRENT LINES TO TEXTFILE
    $PoiToSave  >> 'Data\saved_locations.csv' 
    Write-Host "... saved to Data\saved_locations.csv"
}