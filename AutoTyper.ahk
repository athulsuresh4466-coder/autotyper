#NoEnv
#SingleInstance Force
#InstallKeybdHook
#MaxThreads 255
#MaxThreadsPerHotkey 2
SendMode Event
SetBatchLines, -1

paused := false
stop := false
currentSpeed := 90
speedAdjust := 0

; =========================
; START = Ctrl + I
; =========================
^i::
stop := false
paused := false
speedAdjust := 0

FileRead, text, MyCode.txt
if ErrorLevel
{
    MsgBox, Could not open MyCode.txt
    return
}

Sleep, 2000

Loop, Parse, text, `n, `r
{
    if (stop)
        break

    line := A_LoopField

    ; ---------------------------------
    ; Remove any indentation on the
    ; current Notepad line.
    ; ---------------------------------
    Send, {Home}
    Send, +{End}
    Send, {Backspace}

    ; ---------------------------------
    ; Select typing speed
    ; ---------------------------------
    Random, chance, 1, 100

    if (chance <= 20)
    {
        Random, currentSpeed, 80, 120
    }
    else if (chance <= 40)
    {
        Random, currentSpeed, 90, 220
    }
    else
    {
        Random, currentSpeed, 110, 170
    }

    ; Apply manual speed adjustment
    currentSpeed += speedAdjust

    if (currentSpeed < 10)
        currentSpeed := 10

    ; ---------------------------------
    ; Type current line
    ; ---------------------------------
    Loop, Parse, line
    {
        if (stop)
            break

        while (paused)
        {
            if (stop)
                break

            Sleep, 50
        }

        if (stop)
            break

        Random, delay, %currentSpeed%, % currentSpeed + 40
        Sleep, delay

        ; Small thinking pause
        Random, think, 1, 100
        if (think <= 3)
        {
            Random, thinkPause, 300, 700
            Sleep, thinkPause
        }

        SendRaw, %A_LoopField%

        ; Punctuation
        if A_LoopField in `,,.,;,:
        {
            Random, p, 100, 350
            Sleep, p
        }

        ; Brackets
        if (A_LoopField = "{") || (A_LoopField = "}")
        {
            Random, p, 250, 600
            Sleep, p
        }

        ; Spaces
        if (A_LoopField = " ")
        {
            Random, p, 10, 40
            Sleep, p
        }
    }

    if (stop)
        break

    ; Next line
    Send, {Enter}

    Random, linePause, 300, 700
    Sleep, linePause
}

ToolTip Done!
SetTimer, RemoveToolTip, -1500
return


; =========================
; PAUSE / RESUME = Ctrl + O
; =========================
^o::
paused := !paused

if (paused)
    ToolTip, Paused
else
    ToolTip, Resumed

SetTimer, RemoveToolTip, -1000
return


; =========================
; STOP = Ctrl + P
; =========================
^p::
stop := true
ExitApp
return


; =========================
; FASTER = Ctrl + Up
; SLOWER = Ctrl + Down
; =========================

^Up::
speedAdjust -= 10

if (speedAdjust < -600)
    speedAdjust := -600

ToolTip, Speed Adjustment: %speedAdjust% ms
SetTimer, RemoveToolTip, -1000
return


^Down::
speedAdjust += 10

if (speedAdjust > 300)
    speedAdjust := 300

ToolTip, Speed Adjustment: %speedAdjust% ms
SetTimer, RemoveToolTip, -1000
return


RemoveToolTip:
ToolTip
return