#/:: Shutdown 1 ;关机
#\:: Shutdown 6 ;重启
#0:: run "rundll32.exe powrProf.dll,SetSuspendState" ;休眠
#9:: DllCall("PowrProf\SetSuspendState", "int", 0, "int", 0, "int", 0) ; 睡眠
; 执行v1的程序
^!C:: Run "C:\Users\21282\Desktop\Files\Programs\GitHub\BeautifulToolTip\clipboard.exe"
; 媒体控制
^!Left:: Send "{Media_Prev}"
^!Right:: Send "{Media_Next}"
^!Space:: Send "{Media_Play_Pause}"
; 打开视频解析器
^!V:: Run "C:\Users\21282\Downloads\Programs\AsrTools-v1.1.0\AsrTools.exe"
^!K:: Run "C:\Users\21282\Downloads\Compressed\KBLAutoSwitch\KBLAutoSwitch.exe"
^!M:: Run "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\搜狗输入法\设置.lnk"
!k:: run "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Revo Uninstaller Pro\Revo Uninstaller Pro.lnk"
!A:: run '"code" "D:\code\Scripts\autohotkey\myScript"'
; 关闭当前窗口
!q:: send "!{F4}"
; 打开Ubuntu子系统
!u:: run "ubuntu2004.exe"
; 重命名
^+r:: send "{F2}"
; 永久删除
#w:: send "+{Delete}" ; 按下shift键
; 打开管理员权限终端
#`:: Run "*RunAs cmd.exe" ; 打开cmd
; !P:: { ; 修改代理
;     ProxyEnable := RegRead("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings", "ProxyEnable")
;     if ProxyEnable == 0 {
;         RegWrite 1, "REG_DWORD", "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings", "ProxyEnable"
;         RegWrite "127.0.0.1:1000", "REG_SZ", "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings", "ProxyServer"
;     } else {
;         RegWrite 0, "REG_DWORD", "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings", "ProxyEnable"
;         RegWrite "", "REG_SZ", "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings", "ProxyServer"
;     }
; }
; #S::
; {
;     proxy_enable := RegRead("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings", "ProxyEnable")
;     if proxy_enable == 0 {
;         Send "!p" ; 打开clash代理设置
;     }
;     Run ("https://www.google.com/search?q=" A_Clipboard "")
; }

!S::
{
    ; 构建一个gui实现搜索功能
    MyGui := Gui(, "快捷搜索")
    MyGui.Opt("+MaximizeBox +MinimizeBox +Resize +AlwaysOnTop")
    MyGui.SetFont("s12 bold")

    ; 抽象出一个创建函数
    CreateListBox(MyGui, arr, name, options) {
        if name == "Engines" {
            MyGui.Add("Text", "h18 Checked", name)
        } else {
            MyGui.Add("Text", "h18 ym", name)
        }

        return MyGui.AddListBox(options, arr, name)
    }
    arr1 := ["Goole", "Baidu", "Bilibili", "GitHub", "Youtube"]
    engines := CreateListBox(MyGui, arr1, "Engines", "vEngines r5 w100 choose1")
    ; 绑定事件
    engines.OnEvent("Change", ChangeEngine)

    arr2 := ["S.O.", "CSDN", '小红书', "知乎", "牛客"]
    forums := CreateListBox(MyGui, arr2, "Forums", "vForums r5 w100")
    forums.OnEvent("Change", ChangeEngine)

    arr3 := ["知网", "百度学术", "谷歌学术"]
    academics := CreateListBox(MyGui, arr3, "Academic", "vAcademic r5 w100")
    academics.OnEvent("Change", ChangeEngine)

    arr4 := ["Deepl", "谷歌翻译", "有道翻译"]
    translates := CreateListBox(MyGui, arr4, "Translate", "vTranslate r5 w110")
    translates.OnEvent("Change", ChangeEngine)
    ; c1 := MyGui.Add("Text", "Vc1 h18 Checked ", "搜索引擎")
    ; arr1 := ["Goole", "Baidu", "Bilibili", "GitHub", "Youtube"]
    ; engines := MyGui.AddListBox("vEngines r5 w100 choose1", arr1)
    ; engines.OnEvent("Change", ChangeEngine1)

    ; c2 := MyGui.Add("Text", "Vc2 h18 ym", "论坛")
    ; arr2 := ["S.O.", "CSDN", '小红书', "知乎", "牛客"]
    ; forums := MyGui.AddListBox("vForums r5 w100", arr2)
    ; forums.OnEvent("Change", ChangeEngine2)

    ; c3 := MyGui.Add("Text", "Vc3 h18 ym", "学术")
    ; arr3 := ["知网", "百度学术", "谷歌学术"]
    ; academics := MyGui.AddListBox("vAcademic r5 w100", arr3)
    ; academics.OnEvent("Change", ChangeEngine3)

    ; c4 := MyGui.Add("Text", "Vc4 h18 ym", "翻译")
    ; arr4 := ["Deepl", "谷歌翻译", "有道翻译"]
    ; translates := MyGui.AddListBox("vTranslate r5 w110", arr4)
    ; translates.OnEvent("Change", ChangeEngine4)
    MyGui.Add("Text", "h18 xm", "搜索内容")
    MyGui.Add("Edit", "vEdit w400 -WantReturn")
    MyGui.Add("Button", "x+10 default", "OK").OnEvent("Click", ProcessUserInput)

    MyGui.Show
    ControlFocus("Edit1", "快捷搜索")

    ; 选中一个listbox后，其他的listbox应该取消选中
    ; 这里重构成一个函数
    ChangeEngine(this, *) {
        if this.Name == "Engines" {
            forums.Value := ""
            academics.Value := ""
            translates.Value := ""
        } else if this.Name == "Forums" {
            engines.Value := ""
            academics.Value := ""
            translates.Value := ""
        } else if this.Name == "Academic" {
            engines.Value := ""
            forums.Value := ""
            translates.Value := ""
        } else {
            engines.Value := ""
            forums.Value := ""
            academics.Value := ""
        }

    }
    ; ChangeEngine1(thisGui, *)
    ; {
    ;     ; 将其他listbox的选中状态取消
    ;     forums.Value := ""
    ;     academics.Value := ""
    ;     translates.Value := ""

    ; }
    ; ChangeEngine2(thisGui, *)
    ; {
    ;     engines.Value := ""
    ;     academics.Value := ""
    ;     translates.Value := ""
    ; }
    ; ChangeEngine3(thisGui, *)
    ; {
    ;     engines.Value := ""
    ;     forums.Value := ""
    ;     translates.Value := ""
    ; }
    ; ChangeEngine4(thisGui, *)
    ; {
    ;     engines.Value := ""
    ;     forums.Value := ""
    ;     academics.Value := ""
    ; }
    ProcessUserInput(thisGui, *)
    {
        engine := MyGui.Submit().Engines
        forum := MyGui.Submit().Forums
        academic := MyGui.Submit().Academic
        translate := MyGui.Submit().Translate
        if engine {
            src := engine
        }
        else if forum {
            src := forum
        }
        else if academic {
            src := academic
        }
        else {
            src := translate
        }
        context := MyGui.Submit().Edit
        ; 识别网址
        if (RegExMatch(context, "https?://\S+") == 1) {
            Run(context) ;直接打开网址
            return
        }
        ; 如果第一个字符是数字
        group_num := SubStr(context, 1, 1)
        space_num := SubStr(context, 2, 1) ; 空格（第二个字符）
        index_num := SubStr(context, 3, 1)
        space_num2 := SubStr(context, 4, 1) ; 空格（第四个字符）
        if (IsDigit(group_num) && IsDigit(index_num) && space_num == " ") {
            ; 根据组号和索引号选择src
            if (group_num == '1') {
                src := arr1[index_num]
            } else if (group_num == '2') {
                src := arr2[index_num]
            } else if (group_num == '3') {
                src := arr3[index_num]
            } else if (group_num == '4') {
                src := arr4[index_num]
            }
            context := SubStr(context, 5)
        }
        if src == 'Goole' {
            ; 设置代理
            proxy_enable := RegRead("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings", "ProxyEnable")
            if proxy_enable == 0 {
                Send "!p" ; 打开clash代理设置
            }
            Run ("https://www.google.com/search?q=" context "")
        }
        else if src == 'Baidu' {
            Run ("https://www.baidu.com/s?wd=" context "")
        }
        else if src == 'CSDN' {
            Run ("https://so.csdn.net/so/search/s.do?q=" context "")
        }
        else if src == 'Bilibili' {
            Run ("https://search.bilibili.com/all?keyword=" context "")
        } else if src == 'GitHub' {
            Run ("https://github.com/search?q=" context "")
        } else if src == 'Youtube' {
            Run ("https://www.youtube.com/results?search_query=" context "")
        } else if src == '知网' {
            Run ("https://kns.cnki.net/kns/brief/result.aspx?dbprefix=SCDB&crossDbcodes=&QueryWords=" context "")
        } else if src == '百度学术' {
            Run ("https://xueshu.baidu.com/s?wd=" context "")
        } else if src == '谷歌学术' {
            Run ("https://scholar.google.com/scholar?q=" context "")
        } else if src == '知乎' {
            Run ("https://www.zhihu.com/search?type=content&q=" context "")
        } else if src == 'S.O.' {
            Run ("https://stackoverflow.com/search?q=" context "")
        } else if src == '小红书' {
            Run ("https://www.xiaohongshu.com/search_result?keyword=" context "")
        } else if src == "Deepl" {
            Run ("https://www.deepl.com/translator#en/zh/" context "")
        } else if src == "谷歌翻译" {
            Run ("https://translate.google.com/?sl=zh-CN&tl=en&text=" context "&op=translate")
        } else if src == "有道翻译" {
            Run ("https://fanyi.youdao.com/index.html#/") ; 打开有道翻译
            A_Clipboard := context
        } else if src == "牛客" {
            Run ("https://www.nowcoder.com/search/all?type=all&query=" context "")
        }

    }
}
!n:: Run "notepad.exe"
^!e:: run "rundll32.exe sysdm.cpl,EditEnvironmentVariables" ; 打开系统环境变量
; !r:: Run "::{645ff040-5081-101b-9f08-00aa002f954e}" ; 打开回收站
; !s:: Run "shell:startup"    ; 打开开机自启动文件夹


/*

; 定义一个函数，读取用户输入，用于杀死进程.
; processClose(processName) {
;     if (PID := ProcessExist(processName)) {
;         ProcessClose(PID)
;         MsgBox "关闭进程", "进程已关闭", 16
;     } else
;         MsgBox "关闭进程", "进程不存在", 16

; }

!k::
{
while (processName := InputBox("Please enter a processame", "kill", "w160 h100").value) {
    processName := Trim(processName)    ; 去除首尾空格.

    if (SubStr(processName, -4) != ".exe")
        processName .= ".exe"  ; 加上后缀.exe
    if (PID := ProcessExist(processName)) {
        ProcessClose(PID)
        MsgBox "进程已关闭", "关闭进程", 16
    } else
        MsgBox "进程不存在", "关闭进程", 16
}
}
*/
; #Y::
; {
;     processName := "Winxray.exe" ; 进程名
;     if pid := ProcessExist(ProcessName) ; 如果进程存在, 关闭总进程
;     {
;         Processclose pid
;     }
;     else ; 如果进程不存在
;     {
;         Run "D:\IDM\压缩\WinXray\WinXray.exe"
;     }
; }

^+w::
{
    processName := "WeChat.exe" ; 进程名
    if pid := ProcessExist(ProcessName) ; 如果进程存在
    {
        send "^!w" ;立即显示窗口
    }
    else ; 如果进程不存在
    {
        run "D:\Tencent\WeChat\WeChat.exe"
        sleep 3000
        Send "{Enter}" ;登录
    }
}

^+q::
{
    processName := "QQ.exe" ; 进程名
    if pid := ProcessExist(ProcessName) ; 如果进程存在
    {
        send "^!z" ;立即显示未读信息
    }
    else ; 如果进程不存在
    {
        run "D:\Tencent\QQNT\QQ.exe"

    }
}
/*

!x::
{
processName := "Poe.exe"    ; 进程名，变量名不区分大小写
if pid := ProcessExist(ProcessName) ; 如果进程存在
{
    send "^!\" ;立即显示窗口
}
else ; 如果进程不存在
{
    run "C:\Users\21282\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Quora, Inc\Poe.lnk"
}
}
*/
/*

; 批量关闭程序的函数，传入进程名或者pid数字
processArrClose(processArr){
For processName in processArr
if (PID := ProcessExist(processName)){
ProcessClose(PID)
}
}

; 下班时，按win+l 批量关闭程序
#l::{
; 下班应该关闭的程序
offDuttiesCloseProcessArr:= ["spotify.exe","winxray.exe"]
processArrClose(offDuttiesCloseProcessArr)
}

*/
