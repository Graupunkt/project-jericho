
function Get-ElapsedUTCServerTime{
    param ($DateTime)
    #if(!$DateTime){
    #    $sNTPServer = @("ptbtime1.ptb.de","ptbtime2.ptb.de","ptbtime3.ptb.de") 
    #    [DateTime]$DateTime = Get-NTPDateTime (Get-Random $sNTPServer)
    #}
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
    param ($DateTime)
    
    $ClipboardContentRAW = (Get-Clipboard) -replace '(^\s+|\s+$)','' -replace '\s+',' '
    $ClipboardContentSplit = $ClipboardContentRAW.split("x:").split("y:").split("z:") #GET CURRENT COORDS FROM CLIPBOARD
    #CHECK IF CLIPBOARD CONTAINS COORDINATES
    if ($ClipboardContentRAW -like '*Coordinates: x:*'){
        $ClipboardContainsCoordinates = $true 
        $CurrentXPosition = $ClipboardContentSplit[1]
        $CurrentYPosition = $ClipboardContentSplit[2]
        $CurrentZPosition = $ClipboardContentSplit[3]
        if($CurrentXPosition -ne $PreviousXPosition -or $CurrentYPosition -ne $PreviousYPosition -or $CurrentZPosition -ne $PreviousZPosition -AND $DateTime){
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