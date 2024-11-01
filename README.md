安装脚本：
<br>curl -SL -o install_aleo.sh https://github.com/caotan1/aleo/raw/main/zkwork/install_ore.sh && chmod +x install_aleo.sh && ./install_aleo.sh
<br>curl -SL -o install_aleo_add.sh https://github.com/caotan1/aleo/raw/main/zkwork/install_ore.sh && chmod +x install_aleo.sh && ./install_aleo_add.sh
<br>curl -SL -o install_aleo.sh https://ghproxy.net/https://github.com/caotan1/aleo/raw/main/zkwork/install_aleo.sh && chmod +x install_aleo.sh && ./install_aleo.sh
<br>curl -SL -o install_aleo_add.sh https://ghproxy.net/https://github.com/caotan1/aleo/raw/main/zkwork/install_aleo.sh && chmod +x install_aleo_add.sh && ./install_aleo_add.sh
<br>说明：
<br>安装脚本：install_aleo.sh默认公钥，install_aleo_add.sh手动输入公钥
<br>关闭开机自动运行服务脚本：disable_aleo
<br>删除服务，文件脚本：uninstall_aleo.sh 
<br>aleo.service服务文件

[oula矿池教程]

<br>1.下载文件：wget https://github.com/oula-network/aleo/releases/download/v1.10/oula-pool-prover
<br>2.创建start_oula,填入以下内容：
nohup ./oula-pool-prover --pool wss://aleo.oula.network:6666 --account caotan4070s --worker-name u-155 &> oula.log &
<br>3.说明：caotan4070s为子账户名称，u-155为自定义用户名
<br>4.赋予执行权限：chmod +x oula-pool-prover start_oula
<br>5.开启锄头：./start_oula
<br>6.停止锄头：pkill -9 oula-pool-prover
<br>7.日志查看：tail -f oula.log

[zk_work矿池教程]

<br>1.下载文件：wget https://github.com/6block/zkwork_aleo_gpu_worker/releases/download/v0.2.0/aleo_prover-v0.2.0.tar.gz
<br>2.解压文件：tar -xvf aleo_prover-v0.2.0.tar.gz
<br>3.创建start_zk_work,填入以下内容：
<br>nohup ./aleo_prover --address aleo12r69w7qat0e6n7kqg7jt9e6zlsaywczhdjn6u3zfegejg0hzv5ys2mdhyu --pool aleo.hk.zk.work:10003 --custom_name ct-103 &> zk_work.log &
<br>4.说明：ct-103为自定义用户名
<br>5.赋予执行权限：chmod +x aleo_prover start_zk_work
<br>6.开启锄头：./start_zk_work
<br>7.停止锄头：pkill -9 aleo_prover
<br>8.日志查看：tail -f zk_work.log

[鱼池矿池教程]

<br>1.下载文件：wget https://public-download-ase1.s3.ap-southeast-1.amazonaws.com/aleo-miner/aleominer+3.0.4.zip
<br>2.解压文件：unzip aleominer+3.0.4.zip
<br>3.创建start_f2pool,填入以下内容：
<br>nohup ./aleominer -u stratum+tcp://aleo-asia.f2pool.com:4400 -d 0,1,2,3,4,5 -w caotan.u-103 &> f2pool.log&
<br>4.说明：caotan为子账户名称，u-103为自定义用户名，d后面0,1,2,3,4,5为显卡编号
<br>5.赋予执行权限：chmod +x aleo_prover start_f2pool
<br>6.开启锄头：./start_f2pool
<br>7.停止锄头：pkill -9 aleominer
<br>8.日志查看：tail -f f2pool.log
