#IfWinActive, ahk_exe StarCitizen.exe
SetKeyDelay, 25
Sleep, 100
Send, {Enter}
Sleep, 500
Send, /showlocation
Sleep, 100
Send, {Enter}
;ExitApp