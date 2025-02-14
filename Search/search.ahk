; 设置工作路径为当前文件夹

; SetWorkingDir "D:\code\Scripts\autohotkey\myScript\Search"
#Include JSON.ahk
#Include ../sqlite/SQLite.ahk
CheckNet() {
    ; 设置代理
    proxy_enable := RegRead("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings", "ProxyEnable")
    if proxy_enable == 0 {
        MsgBox("请先打开代理")
    }
    return proxy_enable
}
!s::
{
    ; 构建一个gui实现搜索功能
    MyGui := Gui(, "Swift Search")
    MyGui.Opt("+MaximizeBox +MinimizeBox +Resize +AlwaysOnTop")
    MyGui.SetFont("s12 bold")

    ; 抽象出一个创建函数
    CreateListBox(MyGui, name, arr, options) {
        if name == "引擎" {
            MyGui.Add("Text", "h18 Checked", name)
        } else {
            MyGui.Add("Text", "h18 ym", name)
        }

        tmp := MyGui.AddListBox(options, arr)
        tmp.OnEvent("Change", ChangeEngine)
        return tmp
    }
    ; 选中一个后，其他listbox取消选中
    ChangeEngine(this, *) {
        for index, box in BoxList {
            if box != this {
                box.Value := ""
            } else {
                ; 选中的box的值赋给src，value是序号
                label := this.name
                src := box.Text
            }
        }

    }
    path := "../config/search.json"
    global_cfg := GetConfig(path)
    arr := []
    BoxList := []
    labelList := []
    for k, v in global_cfg {
        tmp := []
        for k1, v1 in v {
            tmp.Push(k1)
        }
        labelList.Push(k)
        arr.Push(tmp)
        cfg := 'v' k ' r5 w100'
        BoxList.Push(CreateListBox(MyGui, k, tmp, cfg))
    }


    MyGui.Add("Text", "h18 xm", "keywords")
    ; 读取数据库记录
    result := DBread(5)
    MyGui.Add("ComboBox", "vColorChoice w400", result)
    MyGui.Add("Button", "x+10 default", "OK").OnEvent("Click", RunWebPage)

    MyGui.Show
    ControlFocus("ComboBox1", "Swift Search")

    DBread(lines) {
        ; 读取数据库
        db := SQLite('test.db', SQLITE_OPEN_READONLY)
        sql := "SELECT * FROM search_record ORDER BY id DESC Limit '" lines "';"
        resp := db.Exec(sql)
        db.Close()

        res := []
        loop lines {
            res.Push(resp[A_Index, 'text'])
        }
        return res
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

    label := "引擎"
    src := "Google"
    context := ""

    GetConfig(path) {
        if !FileExist(path) {
            MsgBox("未找到配置文件：" path)
            ExitGui(0)
        }
        js := FileRead(path, "UTF-8")
        return json.parse(js, true, true)

    }

    ; 处理用户输入
    InputProcess() {

        context := MyGui.Submit().ColorChoice
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
            if ((group_num <= arr.Length) && (index_num <= arr[group_num].Length)) {
                label := labelList[group_num]
                src := arr[group_num][index_num]
            } else {
                MsgBox("输入错误：" prefix "`n跳转至默认引擎")
            }
            context := SubStr(context, 5)
        }

    }

    RunWebPage(thisGui, *) {
        InputProcess()
        ; 根据 src 查找对应的搜索引擎信息
        engine := global_cfg[label][src]
        if (engine["needProxy"] && !CheckNet()) { ; 检查代理是否可用
            ExitGui(0)
        } else if (src == "Youdao Tran") {
            Run(engine["url"]) ; 打开有道翻译
            A_Clipboard := context
        } else {
            Run(engine["url"] context)
        }
        ExitGui(1)

    }
}