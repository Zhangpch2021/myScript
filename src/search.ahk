; search.ahk - 子脚本，使用相对导入其他文件
; #NoEnv
#Include JSON.ahk
#Include utils.ahk

BuildSearchGui(config_path,db_path) {
    ; 构建一个gui实现搜索功能
    MyGui := Gui(, "Swift Search")
    MyGui.Opt("+MaximizeBox +MinimizeBox +Resize +AlwaysOnTop")
    MyGui.SetFont("s12 bold")

    ; 抽象出一个创建函数
    CreateListBox(MyGui, name, arr, options) {
        if name == "引擎" {
            MyGui.Add("Text", "h18 Checked Choose1", name)
            options := options " Choose1"
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
    
    GetConfig(path) {
        if !FileExist(path) {
            MsgBox("未找到配置文件：" path)
            ExitGui(0)
        }
        js := FileRead(path, "UTF-8")
        return json.parse(js, true, true)
    }

    ; 处理用户输入
    getEngineName() {

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
    ; MsgBox(config_path)
    global_cfg := GetConfig(config_path)
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
        cfg := 'v' k ' r5 w110'
        BoxList.Push(CreateListBox(MyGui, k, tmp, cfg))
    }


    MyGui.Add("Text", "h18 xm", "keywords")
    ; 读取数据库记录
    table := "search_record"
    result := DBread(db_path, table, 5)
    MyGui.Add("ComboBox", "vColorChoice w400", result)
    MyGui.Add("Button", "x+10 default", "OK").OnEvent("Click", RunWebPage)

    MyGui.Show
    ControlFocus("ComboBox1", "Swift Search")




    src := "Google"
    label := "引擎"
    context := ""

    ; 自定义exit
    ExitGui(code) {
        DBdump(db_path, table, context, src, code)
        Exit()
    }
    RunWebPage(thisGui, *) {
        getEngineName()
        ; 根据 src 查找对应的搜索引擎信息
        engine := global_cfg[label][src]

        if (src == "Youdao Tran") {
            Run(engine["url"])
            A_Clipboard := context
            MsgBox("请手动粘贴")
        } else if (engine["Proxy"] == true) {
            if (CheckNet() == 0) {
                MsgBox("请先打开代理", "提示", 0x1000)
            } else {
                Run(engine["url"] context)
            }
        } else {
            Run(engine["url"] context)
        }
        ExitGui(1)

    }    

}