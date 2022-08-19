#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
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