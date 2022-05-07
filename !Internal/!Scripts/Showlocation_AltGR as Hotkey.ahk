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