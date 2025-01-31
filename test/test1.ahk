
; 热字符串
:O:xxxy::信息科技与工程学院
:O:lzuid::320210901711
:O:dh1::19194186728
:O:dh2::15756022716
:O:birthday=::2003-01-06
:O:qmail::2128247795@qq.com
:O:wmail::ZPC19194186728@163.com
:0:lmail::zhangpch2021@lzu.edu.cn
:O:gmail::dr.zhangpch@gmail.com
:O:sfz::341422200301067010    
:O:addr1=::安徽省铜陵市铜官区东郊街道高速地产42栋605
:O:addr2=::甘肃省兰州市榆中县夏官营镇兰州大学榆中校区

^!Left::Send "{Media_Prev}"
^!Right::Send "{Media_Next}"
^!Space::Send "{Media_Play_Pause}"

!S::run "C:\Users\21282\AppData\Roaming\Spotify\Spotify.exe"
!k::run "C:\Users\21282\Downloads\decompress\geek\geek.exe"
!a::run "C:\Users\21282\Downloads\decompress\AdventureCN - v5.6++\Adventure\adventure64.exe"

!r::Run "::{645ff040-5081-101b-9f08-00aa002f954e}"  ; 打开回收站.
!e::run "sysdm.cpl"

#c::Run "*RunAs cmd"

#Y::
{   
    processName := "Winxray.exe" ; 进程名
    if pid := ProcessExist(ProcessName)   ; 如果进程存在, 关闭总进程
    {
        Processclose pid
    }
    else ; 如果进程不存在
    {
        Run "D:\IDM\压缩\WinXray\WinXray.exe"
    }
    Return
}

^+w:: 
{   
    processName := "WeChat.exe" ; 进程名
    if pid := ProcessExist(ProcessName)   ; 如果进程存在
    {
        send "^!w" ;立即显示窗口
    }
    else ; 如果进程不存在
    {
        run "D:\腾讯\WeChat\WeChat.exe"        
        Sleep 1000
        Send "{Enter}" ;登录
    }
    Return
}

^+q:: 
{   
    processName := "QQ.exe" ; 进程名
    if pid := ProcessExist(ProcessName)   ; 如果进程存在
    {
        send "^!z" ;立即显示窗口
    }
    else ; 如果进程不存在
    {
        run "D:\腾讯\QQNT\QQ.exe"
        
    }
    Return
}

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
#/::Shutdown 1  ;关机
#\::Shutdown 6  ;重启

