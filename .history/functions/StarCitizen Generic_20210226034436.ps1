
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
    $DateTime = $DateTimeCurrent + $PCClockdrift

    #CHECK IF CLIPBOARD CONTAINS COORDINATES
    $ClipboardContentSplit = $ClipboardContentRAW.split("x:").split("y:").split("z:") #GET CURRENT COORDS FROM CLIPBOARD
    if($ClipboardContentRAW -like '*Coordinates: x:*'){
        #if($CurrentXPosition -ne $PreviousXPosition -or $CurrentYPosition -ne $PreviousYPosition -or $CurrentZPosition -ne $PreviousZPosition){
            $ClipboardContainsCoordinates = $true 
            $CurrentXPosition = $ClipboardContentSplit[1]
            $CurrentYPosition = $ClipboardContentSplit[2]
            $CurrentZPosition = $ClipboardContentSplit[3]
        }
    }else{
        #$CurrentXPosition = $null
        #$CurrentYPosition = $null
        #$CurrentZPosition = $null
        #$ClipboardContainsCoordinates = $false
    }
    Write-Output $ClipboardContainsCoordinates, $CurrentXPosition, $CurrentYPosition, $CurrentZPosition, $DateTime
}