if not A_IsAdmin
{
Run *RunAs "%A_ScriptFullPath%"
ExitApp
}

#Persistent
SetTimer, PressTheKey, 10000
SetKeyDelay, 100
Return

PressTheKey:
;$PreviousWindowFocus = WinActive("[active]","")
$PreviousWindowFocus == WinGetHandle("")

if WinExist("Star Citizen")
    WinActivate ; 
else
    WinActivate, Star Citizen
	;Send, !x
	Send, test
WinActivate, ($PreviousWindowFocus)

Return