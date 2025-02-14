#Include ../Search/JSON.ahk

; SE := JSON.parse('D:\code\Scripts\autohotkey\myScript\Search\search.json', true, true)
; MsgBox(SE["Google"])
text := FileRead("../config/search.json", "UTF-8")
SE := JSON.parse(text)
t := JSON.stringify(SE)
; MsgBox(t)
MsgBox(SE['引擎']['Bilibili']['url'])