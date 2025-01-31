; #Include JSON.ahk
; createGUI(arr) {
;     ; 构建一个gui实现搜索功能
;     MyGui := Gui(, "Swift Search")
;     MyGui.Opt("+MaximizeBox +MinimizeBox +Resize +AlwaysOnTop")
;     MyGui.SetFont("s12 bold")

;     ; 抽象出一个创建函数
;     CreateListBox(MyGui, arr, name, options) {
;         if name == "Engines" {
;             MyGui.Add("Text", "h18 Checked", name)
;         } else {
;             MyGui.Add("Text", "h18 ym", name)
;         }

;         return MyGui.AddListBox(options, arr)
;     }
;     arr1 := ["Goole", "Baidu", "Bilibili", "GitHub", "Youtube"]
;     engines := CreateListBox(MyGui, arr1, "Engines", "vEngines r5 w100 choose1")
;     ; 绑定事件
;     engines.OnEvent("Change", ChangeEngine)

;     arr2 := ["S.O.", "CSDN", '小红书', "知乎", "牛客"]
;     forums := CreateListBox(MyGui, arr2, "Forums", "vForums r5 w100")
;     forums.OnEvent("Change", ChangeEngine)

;     arr3 := ["知网", "百度学术", "谷歌学术"]
;     academics := CreateListBox(MyGui, arr3, "Academic", "vAcademic r5 w100")
;     academics.OnEvent("Change", ChangeEngine)

;     arr4 := ["Deepl", "谷歌翻译", "有道翻译"]
;     translates := CreateListBox(MyGui, arr4, "Translate", "vTranslate r5 w110")
;     translates.OnEvent("Change", ChangeEngine)


;     MyGui.Add("Text", "h18 xm", "keywords")
;     MyGui.Add("Edit", "vEdit w400 -WantReturn")
;     MyGui.Add("Button", "x+10 default", "OK").OnEvent("Click", ProcessUserInput)

;     MyGui.Show
;     ControlFocus("Edit1", "Swift Search")
;     src := "Goole"

;     ; 选中一个后，其他listbox取消选中
;     ChangeEngine(this, *) {
;         box_list := [engines, forums, academics, translates]
;         for index, box in box_list {
;             if box != this {
;                 box.Value := ""
;             } else {
;                 src := box.Value
;             }
;         }

;     }
; }
; 设置工作路径为当前文件夹

#Include JSON.ahk
SetWorkingDir "D:\code\Scripts\autohotkey\myScript\Search"
CheckNet() {
    ; 设置代理
    proxy_enable := RegRead("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings", "ProxyEnable")
    if proxy_enable == 0 {
        MsgBox("请先打开代理")
        return false
    } else {
        return true
    }
}
!s::
{
    ; 构建一个gui实现搜索功能
    MyGui := Gui(, "Swift Search")
    MyGui.Opt("+MaximizeBox +MinimizeBox +Resize +AlwaysOnTop")
    MyGui.SetFont("s12 bold")

    ; 抽象出一个创建函数
    CreateListBox(MyGui, arr, name, options) {
        if name == "Engines" {
            MyGui.Add("Text", "h18 Checked", name)
        } else {
            MyGui.Add("Text", "h18 ym", name)
        }

        return MyGui.AddListBox(options, arr)
    }

    arr1 := ["Goole", "Baidu", "Bilibili", "GitHub", "Youtube"]
    engines := CreateListBox(MyGui, arr1, "Engines", "vEngines r5 w100 choose1")
    engines.OnEvent("Change", ChangeEngine)

    arr2 := ["S.O.", "CSDN", "RedNote", "ZhiHu", "NowCoder"]
    forums := CreateListBox(MyGui, arr2, "Forums", "vForums r5 w100")
    forums.OnEvent("Change", ChangeEngine)

    arr3 := ["CNKI", "Baidu Sch", "Google Sch"]
    academics := CreateListBox(MyGui, arr3, "Academic", "vAcademic r5 w100")
    academics.OnEvent("Change", ChangeEngine)

    arr4 := ["Deepl", "Goole Tran", "Youdao Tran"]
    translates := CreateListBox(MyGui, arr4, "Translate", "vTranslate r5 w100")
    translates.OnEvent("Change", ChangeEngine)


    MyGui.Add("Text", "h18 xm", "keywords")
    MyGui.Add("Edit", "vEdit w400 -WantReturn")
    MyGui.Add("Button", "x+10 default", "OK").OnEvent("Click", RunWebPage)

    MyGui.Show
    ControlFocus("Edit1", "Swift Search")
    src := "Goole"

    ; 选中一个后，其他listbox取消选中
    ChangeEngine(this, *) {
        box_list := [engines, forums, academics, translates]
        for index, box in box_list {
            if box != this {
                box.Value := ""
            } else {
                ; 选中的box的值赋给src，value是序号
                src := box.Text
            }
        }

    }

    ; 设置搜索引擎
    GetMapConfig() {
        ; 读文件
        file := "search.json"
        if !FileExist(file) {
            ; 获取当前文件夹路径
            path := A_ScriptDir
            MsgBox("未找到配置文件：" path "\" file)
            ExitApp()
        }
        js := FileRead(file)
        SE := json.parse(js, true, true)
        return SE
    }

    ; 处理用户输入
    InputProcess() {
        context := MyGui.Submit().Edit
        ; 识别网址
        if (RegExMatch(context, "https?://\S+") == 1) {
            Run(context) ; 直接打开网址
            ExitApp()
        }

        ; 取前四个字符
        prefix := SubStr(context, 1, 4)
        if (RegExMatch(prefix, "^\d \d $") == 1) {
            ; 根据组号和索引号选择src
            group_num := SubStr(context, 1, 1)
            index_num := SubStr(context, 3, 1)
            if (group_num == '1') {
                src := arr1[index_num]
            } else if (group_num == '2') {
                src := arr2[index_num]
            } else if (group_num == '3') {
                src := arr3[index_num]
            } else if (group_num == '4') {
                src := arr4[index_num]
            } else {
                MsgBox("输入错误：" group_num)
                return
            }
            context := SubStr(context, 5)
        }
        return context

    }

    RunWebPage(thisGui, *) {
        context := InputProcess()
        SE := GetMapConfig()
        ; 根据 src 查找对应的搜索引擎信息
        if !SE.Has(src) {
            MsgBox("未找到对应的搜索引擎：" src)
            ExitApp()
        } else {
            engine := SE[src]
            if (engine["needNet"] && !CheckNet()) { ; 检查代理是否可用
                return
            }
            if (src == "有道翻译") {
                Run(engine["url"]) ; 打开有道翻译
                A_Clipboard := context
            } else {
                Run(engine["url"] context)
            }
        }
    }
}