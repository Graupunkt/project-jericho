


$Runspace = [runspacefactory]::CreateRunspace()
$Runspace.Open()

$Code = {

$Signature = @'
[DllImport("user32.dll", CharSet=CharSet.Auto, ExactSpelling=true)] 
public static extern short GetAsyncKeyState(int virtualKeyCode); 
'@
    

    $KeyK  = [Byte][Char]'K' ## Letter
    $KeyS  = [Byte][Char]'S' ## Letter
    $KeyR  = [Byte][Char]'R' ## Letter
    $KeyCtrl = '0x11' ## Ctrl
    $KeyAlt = '0x12' ## Alt 
    
    Add-Type -MemberDefinition $Signature -Name Keyboard -Namespace PsOneApi

    do
    {   
        If([bool]([PsOneApi.Keyboard]::GetAsyncKeyState($KeyK) -eq -32767 -and [PsOneApi.Keyboard]::GetAsyncKeyState($KeyCtrl) -eq -32767 -and [PsOneApi.Keyboard]::GetAsyncKeyState($KeyAlt) -eq -32767)){Start-Process "msg.exe" -argumentlist '* HotKey K Detected'}
        If([bool]([PsOneApi.Keyboard]::GetAsyncKeyState($KeyR) -eq -32767 -and [PsOneApi.Keyboard]::GetAsyncKeyState($KeyCtrl) -eq -32767 -and [PsOneApi.Keyboard]::GetAsyncKeyState($KeyAlt) -eq -32767)){Start-Process "msg.exe" -argumentlist '* HotKey RECALIBRATE Detected'}
        If([bool]([PsOneApi.Keyboard]::GetAsyncKeyState($KeyS) -eq -32767 -and [PsOneApi.Keyboard]::GetAsyncKeyState($KeyCtrl) -eq -32767 -and [PsOneApi.Keyboard]::GetAsyncKeyState($KeyAlt) -eq -32767)){Start-Process "msg.exe" -argumentlist '* HotKey SAVE Detected'}
        Start-Sleep -Milliseconds 100
        $I++

    } while($true)
}

#Eanble Hotkey
$PSinstance = [powershell]::Create().AddScript($Code)
$PSinstance.Runspace = $Runspace
$PSinstance.BeginInvoke()
write-host "global hotkeys enabled"
#
Start-Sleep -Seconds 10

#Disable Hotkey
$PSinstance.Stop()
$PSinstance.Runspace.Close()
$PSinstance.Dispose()
write-host "global hotkeys disabled"
