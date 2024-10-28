#!/bin/bash

# 定义你的输入参数
URL="https://ghproxy.net/https://github.com/6block/zkwork_aleo_gpu_worker/releases/download/cuda-v0.2.4/aleo_prover-v0.2.4_cuda_full.tar.gz"
WHO=$(whoami)
TARGET_DIR="/home/$WHO/zk_work"
LOCAL_ARCHIVE="aleo_prover-v0.2.4_cuda_full.tar.gz"
REQUIRED_TOOLS=("curl" "wget")
TEMP_DIR=$(mktemp -d)
START_FILE="start_zk_work"
WATCH_FILE="watch_aleo"
SERVICE_FILE="aleo.service"


# 检查所需工具是否安装，如果没有安装，则进行安装
for tool in "${REQUIRED_TOOLS[@]}"; do
    if ! command -v "$tool" &> /dev/null; then
        echo "$tool is not installed. Installing..."
        sudo apt update && sudo apt install -y "$tool"
        if [ $? -ne 0 ]; then
            echo "Failed to install $tool."
            exit 1
        fi
    fi
done

# 检查文件是否存在
if [ -f "$LOCAL_ARCHIVE" ]; then
    # 文件存在，询问用户是否覆盖下载
    read -p "File $LOCAL_ARCHIVE already exists. Do you want to download and overwrite it? [y/N]: " OVERRIDE
    OVERRIDE=${OVERRIDE:-n}  # 默认值为 n (no)

    if [[ "$OVERRIDE" == "y" || "$OVERRIDE" == "Y" ]]; then
        echo "Overwriting $LOCAL_ARCHIVE..."
        if curl -L -o "$LOCAL_ARCHIVE" "$URL"; then
            echo "Download completed."
        else
            # 如果curl失败，尝试使用wget下载文件
            echo "Failed to download using curl, trying wget..."
            if wget -O "$LOCAL_ARCHIVE" "$URL"; then
                echo "Download completed."
            else
                echo "Failed to download the archive using wget."
            fi
        fi
    else
        echo "Skipping download."
    fi
else
    # 文件不存在，直接下载
    echo "Downloading $LOCAL_ARCHIVE..."
    if curl -L -o "$LOCAL_ARCHIVE" "$URL"; then
        echo "Download completed."
    else
        # 如果curl失败，尝试使用wget下载文件
        echo "Failed to download using curl, trying wget..."
        if wget -O "$LOCAL_ARCHIVE" "$URL"; then
            echo "Download completed."
        else
            echo "Failed to download the archive using wget."
        fi
    fi
fi

# 继续执行后续命令
echo "Continuing with subsequent commands..."

# 解压文件到临时目录
echo "Extracting archive to temporary directory..."
tar -xzf "$LOCAL_ARCHIVE" -C "$TEMP_DIR" --force-local

# 检查解压操作是否成功
if [ $? -ne 0 ]; then
    echo "Error occurred while extracting files."
    exit 1
fi


# 创建目标目录（如果不存在）
mkdir -p "$TARGET_DIR"

#复制文件到对应目录
cp -r $TEMP_DIR/aleo_prover/aleo_prover $TARGET_DIR

#赋予权限
chmod +x $TARGET_DIR/aleo_prover
mv $TARGET_DIR/aleo_prover $TARGET_DIR/zk_work_aleo

#创建start_zk_work文件
touch $TARGET_DIR/$START_FILE
# 提示用户输入 custom_name
read -p "Enter custom_name : " CUSTOM_NAME
echo 'nohup ./zk_work_aleo --pool aleo.asia1.zk.work:10003 --pool aleo.hk.zk.work:10003 --pool aleo.jp.zk.work:10003 --address ADDRESS --custom_name CUSTOM_NAME >> zk_work.log 2>&1 &' > $TARGET_DIR/$START_FILE 


TEMPLATE_FILE="$TARGET_DIR/$START_FILE"
# 读取模板文件内容
TEMPLATE_CONTENT=$(<"$TEMPLATE_FILE")

# 替换模板中的 CUSTOM_NAME 变量
MODIFIED_CONTENT=$(echo "$TEMPLATE_CONTENT" | sed "s/CUSTOM_NAME/$CUSTOM_NAME/g")

# 创建新的脚本文件并写入修改后的内容
echo -e "$MODIFIED_CONTENT" > $TARGET_DIR/$START_FILE

TEMPLATE_FILE="$TARGET_DIR/$START_FILE"
# 读取模板文件内容
TEMPLATE_CONTENT=$(<"$TEMPLATE_FILE")

# 替换模板中的 ADDRESS 变量
MODIFIED_CONTENT=$(echo "$TEMPLATE_CONTENT" | sed "s/ADDRESS/$ADDRESS/g")

# 创建新的脚本文件并写入修改后的内容
echo -e "$MODIFIED_CONTENT" > $TARGET_DIR/$START_FILE


chmod +x "$TARGET_DIR/$START_FILE"

# 检查脚本文件是否创建成功
if [ -f "$TARGET_DIR/$START_FILE" ]; then
    echo "Script file $START_FILE created successfully."
else
    echo "Failed to create script file $START_FILE"
    exit 1
fi


#创建watch_aleo文件
touch $TARGET_DIR/$WATCH_FILE

echo '#!/bin/bash
while true; do  
    # 检查aleo是否正在运行  
    if ! pgrep -x "zk_work_aleo" > /dev/null; then  
        echo "aleo is not running, starting it..."
        # 调用之前创建的脚本来启动脚本  
        cd /home/WHO/zk_work
        ./start_zk_work
    else
        echo "$(date): zk_work_aleo running..."
    fi  
    # 等待一段时间再次检查（例如，每5秒）  
    sleep 5  
done' > $TARGET_DIR/$WATCH_FILE

chmod +x $TARGET_DIR/$WATCH_FILE

TEMPLATE_FILE="$TARGET_DIR/$WATCH_FILE"
# 读取模板文件内容
TEMPLATE_CONTENT=$(<"$TEMPLATE_FILE")

# 替换模板中的 CPU_NUM 变量
MODIFIED_CONTENT=$(echo "$TEMPLATE_CONTENT" | sed "s/WHO/$WHO/g")

# 创建新的脚本文件并写入修改后的内容
echo -e "$MODIFIED_CONTENT" > $TARGET_DIR/$WATCH_FILE

# 检查脚本文件是否创建成功
if [ -f "$TARGET_DIR/$WATCH_FILE" ]; then
    echo "Script file $WATCH_FILE created successfully."
else
    echo "Failed to create script file $WATCH_FILE."
    exit 1
fi

#创建aleo.service文件
touch $TARGET_DIR/$SERVICE_FILE
echo '[Unit]  
Description=Monitor and Restart aleo if not running  
  
[Service]  
Type=simple  
ExecStart=/home/WHO/zk_work/watch_aleo
Restart=on-failure  
RestartSec=10s 
  
[Install]  
WantedBy=multi-user.target
' > $TARGET_DIR/$SERVICE_FILE

chmod +x $TARGET_DIR/$SERVICE_FILE

TEMPLATE_FILE="$TARGET_DIR/$SERVICE_FILE"
# 读取模板文件内容
TEMPLATE_CONTENT=$(<"$TEMPLATE_FILE")

# 替换模板中的 WHO 变量
MODIFIED_CONTENT=$(echo "$TEMPLATE_CONTENT" | sed "s/WHO/$WHO/g")

# 创建新的脚本文件并写入修改后的内容
echo -e "$MODIFIED_CONTENT" > $TARGET_DIR/$SERVICE_FILE

# 检查脚本文件是否创建成功
if [ -f "$TARGET_DIR/$SERVICE_FILE" ]; then
    echo "Script file $SERVICE_FILE created successfully."
else
    echo "Failed to create script file $SERVICE_FILE."
    exit 1
fi

sudo mv $TARGET_DIR/$SERVICE_FILE /etc/systemd/system/

#取消开机启动
touch $TARGET_DIR/disable_aleo
echo 'sudo systemctl disable aleo.service' > $TARGET_DIR/disable_aleo
chmod +x $TARGET_DIR/disable_aleo
# 检查脚本文件是否创建成功
if [ -f "$TARGET_DIR/disable_aleo" ]; then
    echo "Script file disable_aleo created successfully."
else
    echo "Failed to create script file disable_aleo."
    exit 1
fi


#删除aleo.service服务文件
touch $TARGET_DIR/uninstall_aleo.sh
echo '
sudo pkill -9 zk_work_aleo
sudo systemctl disable aleo.service
sudo rm -r /etc/systemd/system/aleo.service
sudo systemctl daemon-reload
sudo rm -r /home/$(whoami)/zk_work
' > $TARGET_DIR/uninstall_aleo.sh
chmod +x $TARGET_DIR/uninstall_aleo.sh

# 检查脚本文件是否创建成功
if [ -f "$TARGET_DIR/uninstall_aleo.sh" ]; then
    echo "Script file uninstall_aleo.sh created successfully."
else
    echo "Failed to create script file uninstall_aleo.sh."
    exit 1
fi


#关闭原有进程
sudo systemctl daemon-reload
sudo systemctl enable aleo.service
sudo systemctl start aleo.service
sudo systemctl restart aleo.service
sleep 5

# 确保日志文件由当前用户创建，并设置权限为当前用户的读写权限
sudo chown $(whoami) $TARGET_DIR/zk_work.log
sudo chmod 600 $TARGET_DIR/zk_work.log  # 设置权限为当前用户的读写权

# 清理临时文件和目录
#rm -rf "$LOCAL_ARCHIVE"
rm -rf "$TEMP_DIR"

exit 0
