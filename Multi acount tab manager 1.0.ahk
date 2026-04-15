#Persistent
#NoEnv
#SingleInstance, Force
#Warn
SetTitleMatchMode, 2
SetBatchLines, -1

TotalRefreshes := 0

; ==================== TERMS OF SERVICE ====================
Gui, TOS: +AlwaysOnTop +ToolWindow
Gui, TOS: Color, 1a1a2e
Gui, TOS: Font, s11 bold cWhite, Segoe UI
Gui, TOS: Add, Text, x20 y20 w360 Center, Roblox Multi-Client Manager - Terms

Gui, TOS: Font, s9 norm cWhite, Segoe UI
Gui, TOS: Add, Text, x20 y55 w360,
(
This script is for personal use only.

By using this tool you agree that:
- You are responsible for your own Roblox account(s)
- You will not use this for cheating or abuse
- Roblox may prohibit multi-client automation
- The author is not responsible for any bans or consequences
)

Gui, TOS: Font, s9 norm cFFD700, Segoe UI
Gui, TOS: Add, Checkbox, x20 y215 vAccepted gCheckAccept, I have read and accept the above terms

Gui, TOS: Font, s9 norm cWhite, Segoe UI
Gui, TOS: Add, Button, x140 y250 w120 h30 vStartBtn gStartMain Disabled, Continue

Gui, TOS: Show, w400 h290, Terms of Service
return

CheckAccept:
    Gui, TOS: Submit, NoHide
    if (Accepted)
        GuiControl, TOS: Enable, StartBtn
    else
        GuiControl, TOS: Disable, StartBtn
return

StartMain:
    Gui, TOS: Submit
    if (!Accepted) {
        MsgBox, You must accept the terms to continue.
        return
    }
    Gui, TOS: Destroy

    ; ==================== MAIN GUI (Fitted & Clean) ====================
    Gui, Main: +AlwaysOnTop +ToolWindow
    Gui, Main: Color, 1a1a2e

    Gui, Main: Font, s11 bold cWhite, Segoe UI
    Gui, Main: Add, Text, x10 y8 w280 Center, Roblox Multi-Client Manager

    Gui, Main: Font, s9 norm c00d4ff, Segoe UI
    Gui, Main: Add, Text, x10 y32 w280, -----------------------

    Gui, Main: Font, s9 bold cFFD700, Segoe UI
    Gui, Main: Add, Text, x12 y48 w38, F7
    Gui, Main: Font, s9 norm cWhite, Segoe UI
    Gui, Main: Add, Text, x52 y48 w230, Tile all Roblox windows

    Gui, Main: Font, s9 bold cFFD700, Segoe UI
    Gui, Main: Add, Text, x12 y68 w38, F4
    Gui, Main: Font, s9 norm cWhite, Segoe UI
    Gui, Main: Add, Text, x52 y68 w230, Force fast maintenance

    Gui, Main: Font, s9 bold cFFD700, Segoe UI
    Gui, Main: Add, Text, x12 y88 w38, F9
    Gui, Main: Font, s9 norm cWhite, Segoe UI
    Gui, Main: Add, Text, x52 y88 w230, Minimize all clients

    Gui, Main: Font, s9 bold cFFD700, Segoe UI
    Gui, Main: Add, Text, x12 y108 w38, F10
    Gui, Main: Font, s9 norm cWhite, Segoe UI
    Gui, Main: Add, Text, x52 y108 w230, Restore all clients

    Gui, Main: Font, s9 bold cFF4444, Segoe UI
    Gui, Main: Add, Text, x12 y128 w38, F8
    Gui, Main: Font, s9 norm cWhite, Segoe UI
    Gui, Main: Add, Text, x52 y128 w230, Exit script

    Gui, Main: Font, s9 norm c00d4ff, Segoe UI
    Gui, Main: Add, Text, x10 y148 w280, -----------------------

    Gui, Main: Font, s9 norm c888888, Segoe UI
    Gui, Main: Add, Text, x12 y163 w260, Auto-maintenance every 5 minutes
    Gui, Main: Add, Text, x12 y180 w260, ESC refresh + memory trim

    Gui, Main: Font, s9 norm cWhite, Segoe UI
    Gui, Main: Add, Text, x12 y198 w85, Status:
    Gui, Main: Add, Text, x100 y198 w190 vStatusText, Idle

    Gui, Main: Add, Text, x12 y215 w85, Next refresh:
    Gui, Main: Add, Text, x100 y215 w190 vNextRefresh, 5:00

    Gui, Main: Add, Text, x12 y232 w85, Total refreshes:
    Gui, Main: Add, Text, x100 y232 w190 vRefreshCount, 0

    Gui, Main: Font, s8 norm c666666, Segoe UI
    Gui, Main: Add, Text, x10 y255 w280 Center, by BOSS D3V

    Gui, Main: Add, Button, x82 y272 w135 h26 gHideMain, Hide Window
    Gui, Main: Show, w300 h305, Roblox Manager   ; Adjusted height to fit everything

    Menu, Tray, Add, Show Manager, ShowMain
    Menu, Tray, Default, Show Manager

    SetTimer, StartMaintenance, 300000
    SetTimer, AutoRefreshTimer, 300000
    SetTimer, RefreshCountdown, 1000
    RefreshCountdownValue := 300
return

HideMain:
    Gui, Main: Hide
    TrayTip, Roblox Manager, Script still running. Right-click tray -> Show Manager, 2
return

GuiClose:
    Gui, Main: Hide
return

ShowMain:
    Gui, Main: Show
return

UpdateStatus(msg) {
    GuiControl, Main:, StatusText, %msg%
}

UpdateRefreshCounter() {
    global TotalRefreshes
    GuiControl, Main:, RefreshCount, %TotalRefreshes%
}

; ==================== Timers ====================
AutoRefreshTimer:
    MaintenanceMode := "fast"
    Gosub, MaintenanceCycle
return

RefreshCountdown:
    if (RefreshCountdownValue > 0) {
        RefreshCountdownValue--
        mins := Floor(RefreshCountdownValue / 60)
        secs := Mod(RefreshCountdownValue, 60)
        if (secs < 10)
            secs := "0" . secs
        GuiControl, Main:, NextRefresh, %mins%:%secs%
    } else {
        RefreshCountdownValue := 300
    }
return

; ==================== Maintenance (with counter) ====================
StartMaintenance:
    CountdownValue := 30
    SetTimer, UpdateTooltip, 1000
return

UpdateTooltip:
    if (CountdownValue > 0) {
        ToolTip, Maintenance starting in: %CountdownValue%s
        UpdateStatus("Maintenance in " . CountdownValue . "s")
        CountdownValue--
    } else {
        ToolTip
        SetTimer, UpdateTooltip, Off
        MaintenanceMode := "normal"
        Gosub, MaintenanceCycle
    }
return

MaintenanceCycle:
    ToolTip
    SetTimer, UpdateTooltip, Off
    UpdateStatus("Running maintenance...")

    WinGet, robloxList, List, ahk_exe RobloxPlayerBeta.exe
    if (robloxList = 0) {
        UpdateStatus("Idle")
        return
    }

    if (MaintenanceMode = "fast") {
        preDelay := 80
        escDelay := 120
        escCount := 2
    } else {
        preDelay := 350
        escDelay := 350
        escCount := 2
    }

    clients := []
    Loop, %robloxList%
    {
        this_id := robloxList%A_Index%
        WinGet, windowState, MinMax, ahk_id %this_id%
        WinGet, this_pid, PID, ahk_id %this_id%
        clients.Push([this_id, this_pid, windowState])
    }

    clientCount := clients.Length()

    Loop, %clientCount%
    {
        this_id := clients[A_Index][1]
        windowState := clients[A_Index][3]

        if (windowState = -1)
            DllCall("ShowWindow", "ptr", this_id, "int", 9)

        WinActivate, ahk_id %this_id%
        WinWaitActive, ahk_id %this_id%, , 1
        Sleep, %preDelay%

        Loop, %escCount%
        {
            ControlSend,, {Esc}, ahk_id %this_id%
            Sleep, %escDelay%
            SendInput, {Esc}
            Sleep, 30
        }

        if (windowState = -1)
            DllCall("ShowWindow", "ptr", this_id, "int", 2)

        Random, stagger, 40, 120
        Sleep, %stagger%
    }

    Loop, %clientCount%
    {
        this_pid := clients[A_Index][2]
        hProcess := DllCall("OpenProcess", UInt, 0x0500, Int, 0, UInt, this_pid)
        if (hProcess) {
            DllCall("psapi.dll\EmptyWorkingSet", UInt, hProcess)
            DllCall("CloseHandle", UInt, hProcess)
        }
    }

    ; Update counter
    global TotalRefreshes
    TotalRefreshes += clientCount
    UpdateRefreshCounter()

    ToolTip, Maintenance [%MaintenanceMode%] completed for %robloxList% clients.
    UpdateStatus("Maintenance done (" . robloxList . " clients)")
    Sleep, 1500
    ToolTip
return

; ==================== Hotkeys (F7 remains the same) ====================
F7::
    UpdateStatus("Tiling windows...")
    WinGet, robloxList, List, ahk_exe RobloxPlayerBeta.exe
    if (robloxList = 0) {
        ToolTip, No Roblox clients found.
        Sleep, 1500
        ToolTip
        UpdateStatus("Idle")
        return
    }

    OffsetLeft := -5
    OffsetRight := 10
    OffsetBottom:= 30
    OffsetTop := 0
    RobloxMinW := 800
    RobloxMinH := 600

    CoordMode, Mouse, Screen
    MouseGetPos, mx, my
    SysGet, monCount, MonitorCount

    Loop, %monCount%
    {
        SysGet, mon, MonitorWorkArea, %A_Index%
        if (mx >= monLeft && mx <= monRight && my >= monTop && my <= monBottom) {
            AreaL := monLeft + OffsetLeft
            AreaR := monRight - OffsetRight
            AreaT := monTop + OffsetTop
            AreaB := monBottom - OffsetBottom
            tW := AreaR - AreaL
            tH := AreaB - AreaT
            break
        }
    }

    cols := Ceil(Sqrt(robloxList))
    rows := Ceil(robloxList / cols)
    hGap := (cols > 1) ? (tW - cols*RobloxMinW) / (cols-1) : 0
    vGap := (rows > 1) ? (tH - rows*RobloxMinH) / (rows-1) : 0

    pids := []
    Loop, %robloxList%
    {
        this_id := robloxList%A_Index%
        WinGet, this_pid, PID, ahk_id %this_id%
        pids.Push(this_pid)

        cCol := Mod(A_Index-1, cols)
        cRow := Floor((A_Index-1)/cols)

        posX := AreaL + (cCol * RobloxMinW) + (cCol * hGap)
        posY := AreaT + (cRow * RobloxMinH) + (cRow * vGap)

        WinRestore, ahk_id %this_id%
        DllCall("ShowWindow", "ptr", this_id, "int", 9)
        DllCall("SetWindowPos", "ptr", this_id, "ptr", 0, "int", posX, "int", posY, "int", RobloxMinW, "int", RobloxMinH, "uint", 0x0040)
    }

    for index, pid in pids {
        hProcess := DllCall("OpenProcess", UInt, 0x0500, Int, 0, UInt, pid)
        if (hProcess) {
            DllCall("psapi.dll\EmptyWorkingSet", UInt, hProcess)
            DllCall("CloseHandle", UInt, hProcess)
        }
    }

    UpdateStatus("Tiled " . robloxList . " clients")
    Sleep, 1200
    ToolTip
return

F4::
    UpdateStatus("Fast maintenance triggered...")
    SetTimer, StartMaintenance, Off
    SetTimer, UpdateTooltip, Off
    SetTimer, AutoRefreshTimer, Off
    RefreshCountdownValue := 300
    MaintenanceMode := "fast"
    Gosub, MaintenanceCycle
    SetTimer, StartMaintenance, 300000
    SetTimer, AutoRefreshTimer, 300000
return

F9::
    WinGet, robloxList, List, ahk_exe RobloxPlayerBeta.exe
    if (robloxList = 0) {
        ToolTip, No Roblox clients found.
        Sleep, 1000
        ToolTip
        return
    }
    Loop, %robloxList%
        DllCall("ShowWindow", "ptr", robloxList%A_Index%, "int", 2)

    ToolTip, Minimized %robloxList% Roblox clients.
    UpdateStatus("Minimized all clients")
    Sleep, 1200
    ToolTip
return

F10::
    WinGet, robloxList, List, ahk_exe RobloxPlayerBeta.exe
    if (robloxList = 0) {
        ToolTip, No Roblox clients found.
        Sleep, 1000
        ToolTip
        return
    }
    Loop, %robloxList%
        DllCall("ShowWindow", "ptr", robloxList%A_Index%, "int", 9)

    ToolTip, Restored %robloxList% Roblox clients.
    UpdateStatus("Restored " . robloxList . " clients")
    Sleep, 1200
    ToolTip
return

F8::ExitApp