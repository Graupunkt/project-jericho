function Run-AhkCode($script){
    #https://autohotkey.com/board/topic/89609-custom-ahk-dynamically-run-ahk-code-in-powershell/
    $pipeName = "AHK_" + [System.Environment]::TickCount
    $pipeDir = [System.IO.Pipes.PipeDirection]::Out
    $maxNum = [Int]254
    $pipeTMode = [System.IO.Pipes.PipeTransmissionMode]::Message
    $pipeOptions = [System.IO.Pipes.PipeOptions]::None
    
    #$ahkPath = [Environment]::GetFolderPath("ProgramFiles") + "\AutoHotkey\AutoHotkey.exe"
    #$ahkPath = "C:\Users\marcel\Desktop\StarCitizen Tools\Projekt Jericho (3D Navigation)_V6\bin\AutoHotkeyA32.exe"

    if($psISE){$script:ScriptDir = Split-Path -Path $psISE.CurrentFile.FullPath}
    if((Get-Host).Version.Major -gt "5"){$script:ScriptDir = $PSScriptRoot}else{$script:ScriptDir = $PSScriptRoot}
    if($env:TERM_PROGRAM -eq "vscode"){$script:ScriptDir = "C:\Users\marcel\Desktop\StarCitizen Tools\Projekt Jericho (3D Navigation)_V6"}
    Set-Location $script:ScriptDir
    $ahkPath = "$script:ScriptDir\bin\AutoHotkeyA32.exe"

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

$AhkCode_GUI =
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

$AhkCode_AntiLogoff =
@"
if not A_IsAdmin
{
Run *RunAs "%A_ScriptFullPath%"
ExitApp
}

#Persistent
SetTimer, PressTheKey, 300000
SetKeyDelay, 100
Random, RandomTimer, 500, 50000
Sleep, %RandomTimer%
Return

PressTheKey:

prev:=WinActive("A")
if WinExist("Star Citizen")
    WinActivate ; 
else
    WinActivate, Star Citizen
	;Send, !x
	Send, {F12}
	Send, {F12}
    WinActivate, ahk_id %prev%
Return
"@

$AhkCode_AutoRunToggle = 
@"
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; Set cutoff time for double tap detection, second tap must be before this time in milliseconds.
freq:=200

;which key to detect the double tap
~$w::
   wcount++
   SetTimer sub, %freq% ; make this number smaller for quicker successive presses
return

sub:
	; if it's the second time we've tapped the key
	if (wcount==2) {
		Send {Shift down}
		Send, {w down}

		; wait until we press the key Down again.
		KeyWait, w, D

		Send {Shift up}
		Send, {w up} 		
	}
	wcount := 0
return
"@

$AhkCode_ShowLocationTriggeredHotKey =
@"
if not A_IsAdmin
{
Run *RunAs "%A_ScriptFullPath%"
ExitApp
}
#SingleInstance Force

#IfWinActive,ahk_exe StarCitizen.exe
SetKeyDelay, 25
LControl & RAlt::
Sleep, 100
Send, {Enter}
Sleep, 500
Send, /showlocation
Sleep, 100
Send, {Enter}
;ExitApp
"@

Run-AhkCode $AhkCode_GUI


Function BlinkScrollockWhileActeive {
    $continue = $true
    while($continue)
    {

        if ([console]::KeyAvailable)
        {
            echo "Toggle with F12";
            $x = [System.Console]::ReadKey() 

            switch ( $x.key)
            {
                F12 { $continue = $false }
            }
        } 
        else
        {
            $wsh = New-Object -ComObject WScript.Shell
            $wsh.SendKeys('{SCROLLLOCK}')
            sleep 1
            [System.Runtime.Interopservices.Marshal]::ReleaseComObject($wsh)| out-null
            Remove-Variable wsh
        }    
    }
}

Function PauseIfUserInputOccured {
    #StartAs job
    # Detect Keypress for a period of time
    
}

Function DetectKeyPressInGames {
    #CURRENTLY DETECTS KEYPRESS ALT--GR or CTRL + ALT
    #$key = 19
    <#
     8 = BACKSPACE
     9 = TAB
    13 = ENTER
    16 = SHIFT
    17 = STRG
    18 = ALT
    19 = PAUSE    
    27 = ESC
    #>

    # this is the c# definition of a static Windows API method:
$Signature = @'
[DllImport("user32.dll", CharSet=CharSet.Auto, ExactSpelling=true)] 
public static extern short GetAsyncKeyState(int virtualKeyCode); 
'@

    Add-Type -MemberDefinition $Signature -Name Keyboard -Namespace PsOneApi
    #[bool]([PsOneApi.Keyboard]::GetAsyncKeyState($key) -eq -32767)
    [bool]([PsOneApi.Keyboard]::GetAsyncKeyState(17)) -AND [bool]([PsOneApi.Keyboard]::GetAsyncKeyState(18))
}





