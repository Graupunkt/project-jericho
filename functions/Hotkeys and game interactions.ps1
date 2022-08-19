#9..20 | ForEach-Object { '{0} = {1}' -f $_, [System.Windows.Forms.Keys]$_ }

$RunspaceHotKeyCode = {
    if(Test-Path -Path "$ScriptDir\debug-runspace-hotkey.log" -PathType Leaf){Remove-Item -Path "$ScriptDir\debug-runspace-hotkey.log" -ErrorAction SilentlyContinue}
    Start-Transcript -Path "$ScriptDir\debug-runspace-hotkey.log" -Append  | Out-Null
    
$Signature = @'
[DllImport("user32.dll", CharSet=CharSet.Auto, ExactSpelling=true)] 
public static extern short GetAsyncKeyState(int virtualKeyCode); 
'@
    

#$API = Add-Type -MemberDefinition $signatures -Name 'Win32' -Namespace API -PassThru
[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
Add-Type -MemberDefinition $Signature -Name Keyboard -Namespace PsOneApi 

    $global:arrayofkeys = [System.Collections.ArrayList]@()
    $loop = 0
    while ($true) {
        #check keypresses every 50ms
        Start-Sleep -Milliseconds 50

        #collect all keypress within a specific timeframe, in this case 1sec (20 * 50ms)
        if($loop%50 -eq 0){$global:arrayofkeys = [System.Collections.ArrayList]@()}

        # scan all ASCII codes above 8
        for ($ascii = 9; $ascii -le 254; $ascii++) {
        # get current key state
        #$state = $API::GetAsyncKeyState($ascii)
        $state = [PsOneApi.Keyboard]::GetAsyncKeyState($ascii)

        #$state = -32767
        # is key pressed?
        if ($state -eq -32767) {
                #convert keycode to name
                $virtualKeyName = [System.Windows.Forms.Keys]$ascii
                #add name to array
                write-host "$virtualKeyName keypress detected"
                If ($global:arrayofkeys -notcontains $virtualKeyName){$global:arrayofkeys.add($virtualKeyName) | Out-Null}
        }
    }
    #Save Poi
    if($global:arrayofkeys -like "ControlKey*" -AND $global:arrayofkeys -like "*S"){
        #msg * "CTRL + S"
        $RunSpaceSyncData.SaveHotkey = $true
        $global:arrayofkeys = [System.Collections.ArrayList]@()
        Write-Host "CTRL+S detected, $($RunSpaceSyncData.SaveHotkey)"
    }
    #Recalibrate Planet
    if($global:arrayofkeys -like "ControlKey*" -AND $global:arrayofkeys -like "*R"){
        #msg * "CTRL + R"
        $RunSpaceSyncData.RecalibrateHotkey = $true
        $global:arrayofkeys = [System.Collections.ArrayList]@()
        Write-Host "CTRL+R detected, $($RunSpaceSyncData.RecalibrateHotkey)"
    }
    #Add Comment to Logfile
    if($global:arrayofkeys -like "ControlKey*" -AND $global:arrayofkeys -like "*K"){
        #msg * "CTRL + K"
        $RunSpaceSyncData.CommentLogfileHotkey = $true
        $global:arrayofkeys = [System.Collections.ArrayList]@()
        Write-Host "CTRL+K detected, $($RunSpaceSyncData.CommentLogfileHotkey)"
    }    
    $loop++
    }
}







<#
function Run-RunspaceHotkeys {
    $RunspaceHotkey = [runspacefactory]::CreateRunspace()
    $RunspaceHotkey.ApartmentState = "STA"
    $RunspaceHotkey.ThreadOptions = "ReuseThread"
    $RunspaceHotkey.Open()
    $RunspaceLogfile.SessionStateProxy.SetVariable("SavePoiHotkey", $SavePoiHotkey)
    $PSinstanceHotkey = [powershell]::Create().AddScript($RunspaceHotKeyCode)
    $PSinstanceHotkey.Runspace = $RunspaceHotkey
    $JobHotkey = $PSinstanceHotkey.BeginInvoke()
    }


Run-RunspaceHotkeys
$PowerShell.EndInvoke($JobHotkey) | Out-Null
$PSinstanceHotkey.RunSpace.Dispose()
$PSinstanceHotkey.Dispose()
$RunspaceHotkey.Dispose()

Debug-Runspace -iD 2
$runspaces = Get-Runspace
$runspaces | ForEach { 
    $_.Dispose()
}
#>