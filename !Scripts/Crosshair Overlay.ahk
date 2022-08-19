#SingleInstance Force
w:=150 ; Image dimensions, needs to correct for image to be centered.
h:=150
SetTimer, ForceExitApp,  10000 ; 10 secs

prev:=WinActive("A")
gui, new,+toolwindow -caption +hwndguiId +e0x20 +alwaysontop
gui, margin,0,0
gui,add,pic,x0 y0,cross150.png
;gui, show, % "na x" round((A_ScreenWidth-w)/2-w) " y" round((A_ScreenHeight-h)/2-h)
;gui, show, % "na x" round((A_ScreenWidth-w)/2) " y" round((A_ScreenHeight-h)/2)
;gui, show, x200 y200
; %1% and %2% are the two command passed by exe / ahk
x = %1%
y = %2%
xpos := x-w/2
ypos := y-h/2
gui, show, x%xpos% y%ypos%
WinActivate, ahk_id %prev%

WinSet,TransColor ,3c3c3c 255, ahk_id %guiId%
fadeoutfn:=Func("fade").bind(0)
fadeinfn:=Func("fade").bind(1)
;RButton::SetTimer, % fadeoutfn, 10
;RButton up::
;	SetTimer, % fadeoutfn, off
;	SetTimer, % fadeinfn, 10
return

fade(dir){
	global guiId
	static step:=1, nsteps:=25
	WinSet,TransColor, % "ffffff " round(255*(1-step/nsteps)), ahk_id %guiId%
	dir?step-=1:step+=1
	if (step=nsteps+1) {
		SetTimer,,off
		step:=nsteps
	} else if (step=0){
		SetTimer,,off
		step:=1
	}
}

ForceExitApp:
SetTimer,  ForceExitApp, Off
ExitApp