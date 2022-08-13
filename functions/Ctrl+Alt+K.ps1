$RunspacePool = [runspacefactory]::CreateRunspacePool(1,8)
$RunspacePool.Open()

$Code = {
    #Start-Process "msg.exe" -argumentlist '* test'

    $key  = [Byte][Char]'K' ## Letter
    $key2 = '0x11' ## Ctrl
    $key3 = '0x12' ## Alt 
    
$Signature = @'
    [DllImport("user32.dll", CharSet=CharSet.Auto, ExactSpelling=true)] 
    public static extern short GetAsyncKeyState(int virtualKeyCode); 
'@
    Add-Type -MemberDefinition $Signature -Name Keyboard -Namespace PsOneApi

    do
    {   If( [bool]([PsOneApi.Keyboard]::GetAsyncKeyState($key) -eq -32767 -and 
                   [PsOneApi.Keyboard]::GetAsyncKeyState($key2) -eq -32767 -and 
                   [PsOneApi.Keyboard]::GetAsyncKeyState($key3) -eq -32767))
            { 
                Write-Host "combi registered from ingame!" -ForegroundColor Green 
                Start-Process "msg.exe" -argumentlist '* test'
            }
    
          Start-Sleep -Milliseconds 100
          $I++

    } while($I -lt 200)
}
$PSinstance = [powershell]::Create().AddScript($Code).AddArgument($creds).AddArgument("computer1.domain.tld")
$PSinstance.RunspacePool = $RunspacePool
$PSinstance.BeginInvoke()

