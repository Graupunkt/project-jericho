if not A_IsAdmin
{
Run *RunAs "%A_ScriptFullPath%"
ExitApp
}

#Persistent
SetTimer, PressTheKey, 300000
SetKeyDelay, 100
Return

PressTheKey:
if WinExist("Star Citizen")
    WinActivate ; 
else
    WinActivate, Star Citizen
	;Send, !x
	Send, {F6]
Return