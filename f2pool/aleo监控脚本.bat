@echo off  
title ���aleo�ű��Ƿ�����  
setlocal  
  
:loop  
    :: ���aleo-miner.exe�Ƿ���������  
    tasklist /fi "imagename eq aleo-miner.exe" | find /i "aleo-miner.exe" >nul  
    if errorlevel 1 (  
        :: aleo-miner.exe û�����У�����������  
        echo aleo-miner.exe û�����У����ڳ�������...  
        start aleo-miner.exe  -u stratum+tcp://aleo-asia.f2pool.com:4400 -w caotan.222
        timeout /t 5 >nul
    ) else (  
        :: aleo-miner.exe �������У���ִ���κβ���  
        echo aleo-miner.exe �������У���������������  
    )  
      
    :: �ȴ�һ��ʱ�䣨���磬10�룩���ٴμ��  
    timeout /t 1 >nul  
  
    :: ����ѭ����ֱ���ֶ�ֹͣ  
    goto loop  
  
endlocal