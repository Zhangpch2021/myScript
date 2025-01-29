#Requires Autohotkey v2.0
; REMOVED: #NoEnv
#SingleInstance force

return

^1::
{ ; V1toV2: Added bracket
    Explorer_Navigate_New_Tab("C:\Windows")
    Return
} ; Added bracket before function

Explorer_Navigate_New_Tab(FullPath, hwnd := "") {

    if (hwnd) { ; make sure this Explorer window is active
        WinActivate("ahk_id " hwnd)
        WinWaitActive("ahk_id " hwnd)
    }
    else
        hwnd := WinExist("A") ; if omitted, use active window
    ProcessName := WinGetProcessName(`
        "ahk_id `" hwnd")
    if (ProcessName != "explorer.exe")  ; not Windows explorer
        return

    ; Windows Explorer is the active window
    Send("^ t") ; add a new tab
    ; Note 1: This hotkey works in English and French, don't know for other localizations
    ; Note 2: AFAIK, this hotkey does nothing in earlier versions of Windows Explorer but
    ; it would be safer to check the version before sending it
    Sleep(100) ; for safety

    ; the new tab is the active tab
    Explorer_Navigate_Tab("C:\Windows", hwnd)
}

Explorer_Navigate_Tab(FullPath, hwnd := "") {
    ; see https://www.autohotkey.com/boards/viewtopic.php?p=489575#p489575
    hwnd := (hwnd = "") ? WinExist("A") : hwnd ; if omitted, use active window
    ProcessName := WinGetProcessName(`
        "ahk_id `" hwnd")
    if (ProcessName != "explorer.exe")  ; not Windows explorer
        return
    For pExp in ComObject("Shell.Application").Windows
    {
        if (pExp.hwnd = hwnd) { ; matching window found
            activeTab := 0
            try activeTab := ControlGetHwnd(`
                "ShellTabWindowClass1`"", "ahk_id" hwnd)
            if activeTab {
                static IID_IShellBrowser := "{000214E2-0000-0000-C000-000000000046}"
                shellBrowser := ComObjQuery(pExp, IID_IShellBrowser, IID_IShellBrowser)
                DllCall(NumGet(NumGet(shellBrowser + 0, "UPtr") + 3 * A_PtrSize, "UPtr"), "Ptr", shellBrowser, "UInt*", &thisTab)
                if (thisTab != activeTab) ; matching active tab
                    continue
                ObjRelease(shellBrowser)
            }
            pExp.Navigate("file:///" FullPath)
            return
        }
    }
}