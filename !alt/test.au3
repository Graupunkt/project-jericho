if not A_IsAdmin
{
Run *RunAs "%A_ScriptFullPath%"
ExitApp
}
Run("notepad.exe")

WinWait("Unbenannt - ")
ControlClick("Unbenannt - ", "", 1, "left", 1)
Sleep(500)
Send("Hello")
Sleep(2000)

If Not _WinPrevious() Then ;MsgBox(16, "Error", "_WinPrevious() returned 0, and @error = " & @error)

Func _WinPrevious($z = 1)
    If $z < 1 Then Return SetError(1, 0, 0) ; Bad parameter
    Local $avList = WinList()
    For $n = 1 to $avList[0][0]
        ; Test for non-blank title, and is visible
        If $avList[$n][0] <> "" And BitAND(WinGetState($avList[$n][1]), 2) Then
            If $z Then
                $z -= 1
            Else
                WinActivate($avList[$n][1])
                Return 1
            EndIf
        EndIf
    Next
    Return SetError(2, 0, 0) ; z-depth exceeded
EndFunc

