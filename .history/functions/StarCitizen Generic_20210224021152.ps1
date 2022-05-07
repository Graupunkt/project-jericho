
function Get-ElapsedUTCServerTime{
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
        return $NTPDateTime
    }
    $sNTPServer = @("ptbtime1.ptb.de","ptbtime2.ptb.de","ptbtime3.ptb.de") 
    [DateTime]$DateTime = Get-NTPDateTime (Get-Random $sNTPServer)
    $UTCServerTime = $DateTime.ToUniversalTime() 
    #. '.\functions\Generic.ps1'
    # SET STARTTIME SIMULATION STARCITIZEN
    $SimulationUTCStartTime = [DateTime]"01.01.2020 00:00:00"                                                    # SET STARTTIME SIMULATION UTC
    $ElapsedUTCTimeSinceSimulationStart = New-Timespan -End $UTCServerTime -Start $SimulationUTCStartTime     # GET ELPASED TIME BETWEEN SIMULATION TIME AND CURRENT TIME
    Write-Output $ElapsedUTCTimeSinceSimulationStart
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