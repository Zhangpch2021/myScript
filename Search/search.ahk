; 设置工作路径为当前文件夹

#Include JSON.ahk
#Include ../sqlite/SQLite.ahk
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

        return MyGui.AddListBox(options, arr).OnEvent("Change", ChangeEngine)
    }
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
    arr := [
        ["Goole", "Baidu", "Bilibili", "GitHub", "Youtube"],
        ["S.O.", "CSDN", "RedNote", "ZhiHu", "NowCoder"],
        ["CNKI", "Baidu Sch", "Google Sch"],
        ["Deepl", "Goole Tran", "Youdao Tran"]
    ]

    engines := CreateListBox(MyGui, arr[1], "Engines", "vEngines r5 w100 choose1")
    forums := CreateListBox(MyGui, arr[2], "Forums", "vForums r5 w100")
    academics := CreateListBox(MyGui, arr[3], "Academic", "vAcademic r5 w100")
    translates := CreateListBox(MyGui, arr[4], "Translate", "vTranslate r5 w100")


    MyGui.Add("Text", "h18 xm", "keywords")
    MyGui.Add("Edit", "vEdit w400 -WantReturn")
    MyGui.Add("Button", "x+10 default", "OK").OnEvent("Click", RunWebPage)

    MyGui.Show
    ControlFocus("Edit1", "Swift Search")

    DBread() {
        ; 读取数据库
        db := SQLite('test.db', SQLITE_OPEN_READONLY)
        sql := "SELECT * FROM search_record Limit 3;"
        result := db.Exec(sql)
        db.Close()
        return result
    }

    DBdump(code) {
        ; 保留历史记录到数据库
        db := SQLite('test.db', SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE)
        ; 记录time\text\src\success
        time := FormatTime(A_Now, "yyyy-MM-dd HH:mm:ss")
        sql := "INSERT INTO search_record (time, text, src, success) VALUES ('" time "', '" context "', '" src "', " code ");"
        db.Exec(sql)
        db.Close()
    }
    ; 自定义exit
    ExitGui(code) {
        DBdump(code)
        Exit()
    }

    src := "Goole"
    context := ""
    ; 设置搜索引擎
    GetConfig() {
        ; 读文件
        file := "search.json"
        if !FileExist(file) {
            ; 获取当前文件夹路径
            path := A_ScriptDir
            MsgBox("未找到配置文件：" path "\" file)
            ExitGui(0)
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
            ExitGui(1)
        }

        ; 取前四个字符
        prefix := SubStr(context, 1, 4)
        if (RegExMatch(prefix, "^\d \d $") == 1) {
            ; 根据组号和索引号选择src
            group_num := Integer(SubStr(prefix, 1, 1))
            index_num := Integer(SubStr(prefix, 3, 1))
            if ((group_num <= arr.Length && group_num > 0) && (index_num > 0 && index_num <= arr[group_num].Length)) {
                src := arr[group_num][index_num]
            } else {
                MsgBox("输入错误：" prefix "\n跳转至默认引擎")
            }
            context := SubStr(context, 5)
        }

    }

    RunWebPage(thisGui, *) {
        InputProcess()
        SE := GetConfig()
        ; 根据 src 查找对应的搜索引擎信息
        if !SE.Has(src) {
            MsgBox("未找到对应的搜索引擎：" src)
            ExitGui(0)
        } else {
            engine := SE[src]
            if (engine["needNet"] && !CheckNet()) { ; 检查代理是否可用
                ExitGui(0)
            } else if (src == "有道翻译") {
                Run(engine["url"]) ; 打开有道翻译
                A_Clipboard := context
            } else {
                Run(engine["url"] context)
            }
            ExitGui(1)
        }
    }
}