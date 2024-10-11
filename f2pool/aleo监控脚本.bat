@echo off  
title 监控aleo脚本是否运行  
setlocal  
  
:loop  
    :: 检查aleo-miner.exe是否正在运行  
    tasklist /fi "imagename eq aleo-miner.exe" | find /i "aleo-miner.exe" >nul  
    if errorlevel 1 (  
        :: aleo-miner.exe 没有运行，尝试启动它  
        echo aleo-miner.exe 没有运行，正在尝试启动...  
        start aleo-miner.exe  -u stratum+tcp://aleo-asia.f2pool.com:4400 -w caotan.222
        timeout /t 5 >nul
    ) else (  
        :: aleo-miner.exe 正在运行，不执行任何操作  
        echo aleo-miner.exe 正在运行，无需重新启动。  
    )  
      
    :: 等待一段时间（例如，10秒）后再次检查  
    timeout /t 1 >nul  
  
    :: 无限循环，直到手动停止  
    goto loop  
  
endlocal