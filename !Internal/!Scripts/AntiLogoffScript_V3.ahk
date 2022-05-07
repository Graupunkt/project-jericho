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