function Get-NTPDateTime ([string] $sNTPServer)
{
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

function Set-ADminPermissions{
        #If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
    #    Start-Process powershell.exe "-noProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    #    Exit
    #}
}