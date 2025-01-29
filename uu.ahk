CheckClipboard() ; 启动检查剪贴板内容的函数
{
    clipboard := ClipboardAll  ; 保存当前剪贴板内容
    if (clipboard ~= "i)(https?://\S+)")  ; 正则表达式匹配以http或https开始的网址
    {
        MsgBox(clipboard) ; 显示匹配到的网址
    }
}
SetTimer(CheckClipboard, 1000) ; 每1000毫秒检查一次剪贴板内容
