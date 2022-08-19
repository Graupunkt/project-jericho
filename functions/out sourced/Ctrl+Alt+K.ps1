$key  = [Byte][Char]'K' ## Letter
$key2 = '0x11' ## Ctrl
$key3 = '0x12' ## Alt 
$Signature = @'
    [DllImport("user32.dll", CharSet=CharSet.Auto, ExactSpelling=true)] 
    public static extern short GetAsyncKeyState(int virtualKeyCode); 
'@
Add-Type -MemberDefinition $Signature -Name Keyboard -Namespace PsOneApi
do
{   
    write-host  ([bool]([PsOneApi.Keyboard]::GetAsyncKeyState($key3) -eq -32767))
    write-host  ([bool]([PsOneApi.Keyboard]::GetAsyncKeyState($key2) -eq -32767))
    write-host  ([bool]([PsOneApi.Keyboard]::GetKeyboardState($key2) -eq -32767))
    Start-Sleep -Milliseconds 1000
    

} while($true)