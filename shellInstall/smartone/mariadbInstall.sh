#!/bin/bash
# Function:  auto install the mariadb-10.1
# TODOList:
# 1. 将手动输入的maria_ver, 与官网比较，测验是否存在
# 2. 测试，服务器上是否有安装mariadb
# 3. 开启端口
# 3. 检测，安装前，需要的环境准备，或者说优化部分
# 4. 判断是否有 mariadb 运行， 并备份后 卸载
    # yum list installed | grep MariaDB
    # yum remove MariaDB -y
    # rm -rf /var/lib/mysql/*
# 5. 设置开机自启

# 判断，mariadb.repo 是否存在
mari=`find . ! -name "." -type d -prune -o -type f -name "*.repo" -print | grep -i mariadb`
mari_ver=10.1
cd /etc/yum.repos.d
if [ ! -f "$mari" ];then
	echo 'there is no mariadb.repo'
	touch MariaDB.repo && echo 'OK,there is~'
else
	\cp $mari MariaDB.repo.bak 2>/dev/null
	# echo $(find . ! -name "." -type d -prune -o -type f  -print | grep -i mariadb)
fi

# 修改repo，直接覆盖，因为上面已备份原文件了
cat > /etc/yum.repos.d/MariaDB.repo << EOF
[mariadb]
name = MariaDB
baseurl = http://mirrors.ustc.edu.cn/mariadb/yum/$mari_ver/centos7-amd64/
gpgkey = http://mirrors.ustc.edu.cn/mariadb/yum/RPM-GPG-KEY-MariaDB
gpgcheck = 1
EOF

# 开始安装，repo中已指定版本，可修改 mari_ver
# 并，加入开机自启动
yum clean all
yum install MariaDB-server MariaDB-client -y
sleep 3
systemctl start mariadb &&\
    systemctl enable mariadb

# 测试是否安装，并启动成功
[ $? -eq 0 ] && echo 'mariadb 安装成功'|| echo 'mariadb 安装失败' &&\
        systemctl status mariadb 2>/dev/null
