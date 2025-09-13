#Include ./sqlite/SQLite.ahk

CheckNet() {
    register := "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
    proxy_enable := RegRead(register, "ProxyEnable")
    return proxy_enable
}

DBread(db_path,table,lines) {
    ; 读取数据库
    db := SQLite(db_path, SQLITE_OPEN_READONLY)
    sql := "SELECT * FROM " table " ORDER BY id DESC Limit '" lines "';"
    resp := db.Exec(sql)
    db.Close()

    res := []
    loop lines {
        res.Push(resp[A_Index, 'text'])
    }
    return res
}

DBdump(db_path, table, context, src, code) {
    ; 保留历史记录到数据库
    db := SQLite(db_path, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE)
    ; 记录time\text\src\success
    time := FormatTime(A_Now, "yyyy-MM-dd HH:mm:ss")
    sql := "INSERT INTO " table " (time, text, src, success) VALUES ('" time "', '" context "', '" src "', " code ");"
    db.Exec(sql)
    db.Close()
}