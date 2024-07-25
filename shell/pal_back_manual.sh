#!/bin/sh  

# 定义颜色变量
Green="\033[0;32m"
Red="\033[0;31m"
Font="\033[0m"

# 函数：检查导出结果
check_result() {
    if [ $? -eq 0 ]; then
        echo -e "${Green}$1 成功${Font}"
    else
        echo -e "${Red}$1 失败${Font}"
        exit 1
    fi
}

echo -e "${Green}此操作会导出容器内 /home/steam/Steam/steamapps/common/PalServer/Pal/Saved 文件夹下所有的文件${Font}"
echo -e "${Green}导出的幻兽帕鲁存档及配置将会存放在 /data/palworld 目录下！${Font}"
echo -e "${Green}开始导出幻兽帕鲁存档及配置...${Font}"

# 根据当前时间创建备份文件夹
timestamp=$(date +%Y%m%d_%H%M%S)
backup_dir="/data/palworld/${timestamp}"
mkdir -p "${backup_dir}"

# 复制文件到备份文件夹
docker cp steamcmd:/home/steam/Steam/steamapps/common/PalServer/Pal/Saved/. "${backup_dir}"
check_result "导出存档及配置"

# 输出导出成功信息
echo -e "${Green}幻兽帕鲁存档及配置已成功导出到 ${backup_dir}！${Font}"
