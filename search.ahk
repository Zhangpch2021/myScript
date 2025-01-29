!i::
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


    MyGui.Add("Text", "h18 xm", "keywords")
    MyGui.Add("Edit", "vEdit w400 -WantReturn")
    MyGui.Add("Button", "x+10 default", "OK").OnEvent("Click", ProcessUserInput)

    MyGui.Show
    ControlFocus("Edit1", "Swift Search")
    src := "Goole"

    ; 选中一个listbox后，其他listbox取消选中
    ChangeEngine(this, *) {
        box_list := [engines, forums, academics, translates]
        for index, box in box_list {
            if box != this {
                box.Value := ""
            } else {
                src := box.Value
            }
        }

    }

    ; 设置搜索引擎
    GetMapConfig() {
        SE := Map()
        ; 搜索引擎
        SE.Set("Goole", Map("url", "https://www.google.com/search?q=", "needNet", true))
        SE.Set("Baidu", Map("url", "https://www.baidu.com/s?wd=", "needNet", false))
        SE.Set("CSDN", Map("url", "https://so.csdn.net/so/search/s.do?q=", "needNet", false))
        SE.Set("Bilibili", Map("url", "https://search.bilibili.com/all?keyword=", "needNet", false))
        SE.Set("GitHub", Map("url", "https:github.com/search?q=", "needNet", true))
        SE.Set("Youtube", Map("url", "https://www.youtube.com/results?search_query=", "needNet", true))

        ; 学术引擎
        SE.Set("知网", Map("url", "https://kns.cnki.net/kns/brief/result.aspx?dbprefix=SCDB&crossDbcodes=&QueryWords=", "needNet", false))
        SE.Set("百度学术", Map("url", "https://xueshu.baidu.com/s?wd=", "needNet", false))
        SE.Set("谷歌学术", Map("url", "https://scholar.google.com/scholar?q=", "needNet", true))

        ; 论坛搜索引擎
        SE.Set("知乎", Map("url", "https://www.zhihu.com/search?type=content&q=", "needNet", false))
        SE.Set("S.O.", Map("url", "https://stackoverflow.com/search?q=", "needNet", true))
        SE.Set("小红书", Map("url", "https://www.xiaohongshu.com/search_result?keyword=", "needNet", false))
        SE.Set("牛客", Map("url", "https://www.nowcoder.com/search/all?type=all&query=", "needNet", false))

        ; 翻译引擎
        SE.Set("Deepl", Map("url", "https://www.deepl.com/translator#en/zh/", "needNet", false))
        SE.Set("谷歌翻译", Map("url", "https://translate.google.com/?sl=zh-CN&tl=en&text=", "needNet", true))
        SE.Set("有道翻译", Map("url", "https://fanyi.youdao.com/index.html#/", "needNet", false))

        return SE
    }


    ProcessUserInput(thisGui, *) {
        context := MyGui.Submit().Edit
        ; 识别网址
        if (RegExMatch(context, "https?://\S+") == 1) {
            Run(context) ; 直接打开网址
            return
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
                MsgBox("输入错误")
                return
            }
            context := SubStr(context, 5)
        }


        ; 根据 src 查找对应的搜索引擎信息
        SE := GetMapConfig()
        if !SE.Has(src) {
            MsgBox("未找到对应的搜索引擎")
            return
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