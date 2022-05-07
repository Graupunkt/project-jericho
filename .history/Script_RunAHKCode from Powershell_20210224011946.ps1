function Run-AhkCode($script)
{
    $pipeName = "AHK_" + [System.Environment]::TickCount
    $pipeDir = [System.IO.Pipes.PipeDirection]::Out
    $maxNum = [Int]254
    $pipeTMode = [System.IO.Pipes.PipeTransmissionMode]::Message
    $pipeOptions = [System.IO.Pipes.PipeOptions]::None
    
    #$ahkPath = [Environment]::GetFolderPath("ProgramFiles") + "\AutoHotkey\AutoHotkey.exe"
    $ahkPath = "C:\Users\marcel\Desktop\StarCitizen Tools\Projekt Jericho (3D Navigation)_V6\bin\AutoHotkeyA32.exe"
    $pipe_ga = new-object System.IO.Pipes.NamedPipeServerStream($pipeName, $pipeDir, $maxNum, $pipeTMode, $pipeOptions)
        
    $pipe = new-object System.IO.Pipes.NamedPipeServerStream($pipeName, $pipeDir, $maxNum, $pipeTMode, $pipeOptions)
    
    if ($pipe_ga -and $pipe) {
        Start-Process $ahkPath "\\.\pipe\$pipeName"
        $pipe_ga.WaitForConnection()
        $pipe_ga.Dispose()
        $pipe.WaitForConnection()
        $script = [char]65279 + $script
        $sw = new-object System.IO.StreamWriter($pipe)
        $sw.Write($script)
            
        $sw.Dispose()
        $pipe.Dispose()
    } else { Write-Host "Operation cancelled: Failed to create named pipe" }
}

$ahkcode =
@"
Gui, Color, 0xFFFFFF
Gui, Margin, 10, 10
Gui, Add, Edit, w300 r5
Gui, Add, Button, x+-88 y+10 w88 h26 gTest, OK
Gui, Show
return
GuiClose:
ExitApp
Test:
GuiControlGet, text,, Edit1
Msgbox, % text
return
"@
Run-AhkCode $ahkcode