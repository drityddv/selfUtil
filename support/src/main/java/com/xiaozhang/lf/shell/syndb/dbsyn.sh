server1=$1
server2=$2

# 检查是否传递了足够的参数
if [ $# -ne 2 ]; then
    echo "Usage: $0 <server1> <server2>"
    exit 1
fi

# 
sh syn.sh $server1 $server2
#  config_$server1_to_server2.json
file_path="/Users/xiaozhang/Documents/shell/mysql_syn/config_${server1}_to_${server2}.json"
echo $file_path
mysql-schema-sync -conf $file_path -sync
echo syndb finish
