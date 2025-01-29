; 读取代理设置
!r::
{ ProxyEnable := RegRead("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings", "ProxyEnable")
    if (ProxyEnable == 1) {
        MsgBox("代理设置：代理已启用。")
    } else {
        MsgBox("代理设置：代理未启用。")
    }
    ProxyServer := RegRead("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings", "ProxyServer")
    if (ProxyServer == "") {
        MsgBox("代理设置：未找到或没有启用代理。")
        ; Send "!p" ; 打开代理设置
    } else {
        MsgBox("代理设置：找到代理服务器：" ProxyServer)
    }
}

; 清除代理设置
!p:: { ; Alt+P

    RegWrite 0, "REG_DWORD", "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings", "ProxyEnable"
    RegWrite "", "REG_SZ", "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings", "ProxyServer"
    MsgBox("代理设置已清除。")
}
; RegWrite("REG_DWORD", "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings", "ProxyEnable", 0)
; RegWrite("REG_SZ", "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings", "ProxyServer", "")
