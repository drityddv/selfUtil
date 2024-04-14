#!/bin/bash

# 脚本文件名: manage_proxy.sh

# 函数：启用代理
enable_proxy() {
    read -p "Enter proxy IP: " proxy_ip
    read -p "Enter proxy port: " proxy_port

    # 将代理设置添加到 ~/.bashrc 中
    echo "export http_proxy=\"http://$proxy_ip:$proxy_port\"" >> ~/.bashrc
    echo "export https_proxy=\"https://$proxy_ip:$proxy_port\"" >> ~/.bashrc
    echo "export ftp_proxy=\"ftp://$proxy_ip:$proxy_port\"" >> ~/.bashrc
    echo "export all_proxy=\"socks5://$proxy_ip:$proxy_port\"" >> ~/.bashrc

    # 重新加载 ~/.bashrc 文件
    source ~/.bashrc

    echo "Proxy enabled"
    echo "HTTP_PROXY=$http_proxy"
    echo "HTTPS_PROXY=$https_proxy"
    echo "FTP_PROXY=$ftp_proxy"
    echo "SOCKS_PROXY=$all_proxy"
}

# 函数：禁用代理
disable_proxy() {
    # 从 ~/.bashrc 中删除代理设置
    sed -i '/http_proxy/d' ~/.bashrc
    sed -i '/https_proxy/d' ~/.bashrc
    sed -i '/ftp_proxy/d' ~/.bashrc
    sed -i '/all_proxy/d' ~/.bashrc

    # 重新加载 ~/.bashrc 文件
    source ~/.bashrc

    echo "Proxy disabled"
}

# 主菜单
echo "Proxy Manager"
echo "1. Enable proxy"
echo "2. Disable proxy"
echo "3. Exit"
read -p "Choose an option: " option

case $option in
    1)
        enable_proxy
        ;;
    2)
        disable_proxy
        ;;
    3)
        exit 0
        ;;
    *)
        echo "Invalid option"
        exit 1
        ;;
esac
