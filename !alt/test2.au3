if WinExists("Star Citizen") Then
	WinActivate("Star Citizen","")
else
	WinActivate("Star Citizen","")
	WinWaitActive("Star Citizen","")
	Send ("{^}")
	Sleep(1000)
Endif

;$hCurrWin = WinGetHandle("[ACTIVE]")
;Sleep(5000)
;WinActivate($hCurrWin)



