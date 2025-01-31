#Include Search\search.ahk
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
#c:: Run "*RunAs cmd.exe" ; 打开cmd


!n:: Run "notepad.exe"
^!e:: run "rundll32.exe sysdm.cpl,EditEnvironmentVariables" ; 打开系统环境变量
; !r:: Run "::{645ff040-5081-101b-9f08-00aa002f954e}" ; 打开回收站
; !s:: Run "shell:startup"    ; 打开开机自启动文件夹


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
    } else ; 如果进程不存在
    {
        run "D:\Tencent\QQNT\QQ.exe"

    }
}