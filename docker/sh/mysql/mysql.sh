docker run --name mysql -v /usr/local/zhang/software/docker/mysql/data:/var/lib/mysql -v /usr/local/zhang/software/docker/mysql/config/my.cnf:/etc/mysql/my.cnf -e MYSQL_ROOT_PASSWORD=yourPassword -p 3306:3306 -d mysql:8.0.34

docker run --name mysql -v /usr/local/zhang/software/docker/mysql/data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=? -p 3306:3306 -d mysql:8.0.34

# 注意挂载目录需要有读写权限