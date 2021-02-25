#!/bin/bash
# Function:  auto install the mariadb-10.1
# TODOList:
# 1. yumInstall 将失败原因打印出来
# 2. 将myhttpd命令添加到可以systemctl调用
# 3. 目前是安装特定版本，可以打印出来并让用户自定义
# #######################################判断是否有 mariadb 运行

#!/bin/bash
cd /etc/yum.repos.d
if [ -f MariaDB.repo ];then
    cp MariaDB.repo 
    rm -f MariaDB.repo
else
    touch MariaDB.repo
fi
echo '[mariadb]' >> MariaDB.repo
echo 'baseurl = http://mirrors.ustc.edu.cn/mariadb/yum/10.1/centos7-amd64/' >> MariaDB.repo
echo 'gpgkey=http://mirrors.ustc.edu.cn/mariadb/yum/RPM-GPG-KEY-MariaDB' >> MariaDB.repo
echo 'gpgcheck=1' >> MariaDB.repo

yum clean all

yum install MariaDB-server MariaDB-client -y

sleep 3

http://mirrors.ustc.edu.cn/mariadb/yum/10.1/centos7-amd64/