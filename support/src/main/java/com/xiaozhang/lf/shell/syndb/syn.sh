#!/bin/bash

# 接收两个参数: 源数据库ID和目标数据库ID
SOURCE_ID=$1
DEST_ID=$2

# 检查是否传递了足够的参数
if [ $# -ne 2 ]; then
    echo "Usage: $0 <source_id> <dest_id>"
    exit 1
fi

# 定义配置文件存储目录
CONFIG_DIR="/Users/xiaozhang/Documents/shell/mysql_syn"

# 定义函数来决定IP地址
determine_ip() {
    local id=$1
    # 默认IP
    local ip="10.1.2.116"

    # 特定条件下的IP修改
    case $id in
        888)
            ip="10.2.4.42"
            ;;
        999)
            ip="10.2.4.43"
            ;;
        # 可以继续添加更多条件
    esac

    echo $ip
}

# 定义函数来保存配置文件并输出结果
save_config() {
    local config=$1
    local source_id=$2
    local dest_id=$3
    local file_path="${CONFIG_DIR}/config_${source_id}_to_${dest_id}.json"
    echo "$config" > "$file_path"  # Save directly without jq
    echo "Config file created: $file_path"
}

# 使用函数来设定IP地址
SRC_IP=$(determine_ip $SOURCE_ID)
DEST_IP=$(determine_ip $DEST_ID)

# 创建JSON配置
CONFIG=$(cat <<-END
{
    "source": "root:admin123@(${SRC_IP}:3306)/lf${SOURCE_ID}",
    "dest": "root:admin123@(${DEST_IP}:3306)/lf${DEST_ID}",
    "alter_ignore": {},
    "tables": [],
    "tables_ignore": [],
    "email": {
       "send_mail": false
    }
}
END
)

# 保存配置文件并输出结果
save_config "$CONFIG" "$SOURCE_ID" "$DEST_ID"
