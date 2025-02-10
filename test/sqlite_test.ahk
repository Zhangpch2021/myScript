#Include ../sqlite/SQLite.ahk
db := SQLite('../Search/test.db', SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE)
db.Exec("CREATE TABLE IF NOT EXISTS history (id INTEGER PRIMARY KEY AUTOINCREMENT, content TEXT, time TEXT);")
; db.Exec("INSERT INTO history (id, content, time) VALUES (2, 'test', ' " A_Now " ');")
context := "test"
src := "Google"
code := 1
time := FormatTime(A_Now, "yyyy-MM-dd HH:mm:ss")
; MsgBox(time)
sql := "INSERT INTO search_record (time, text, src, success) VALUES ('" time "', '" context "', '" src "', " code ");"
db.Exec(sql)
; MsgBox(sql)

db.Close()