#!/bin/bash
# Function:  auto install the mariadb-10.4及以上（环境需要）
# TODOList:
# 1. 将手动输入的maria_ver, 与官网比较，测验是否存在
# 2. 测试，服务器上是否有安装mariadb
# 3. 检测，安装前，需要的环境准备，或者说优化部分
# 4. 判断是否有 mariadb 运行， 并备份后 卸载
    # yum list installed | grep MariaDB*
    # yum remove MariaDB -y
    # rm -rf /var/lib/mysql/*
# 5. windows_64bit ,下载地址, https://downloads.mariadb.org/interstitial/mariadb-10.4.18/winx64-packages/mariadb-10.4.18-winx64.msi/from/https%3A//mirrors.ustc.edu.cn/mariadb/
# 判断，mariadb.repo 是否存在
# 在winserver上建议使用mariadbxxxx.zip, https://iso.mirrors.ustc.edu.cn/mariadb/mariadb-10.4.18/winx64-packages/mariadb-10.4.18-winx64.zip
# 安装方法--待补充
MARI=`find . ! -name "." -type d -prune -o -type f -name "*.repo" -print | grep -i mariadb`
MARI_VER=10.4

cd /etc/yum.repos.d
if [ ! -f "$MARI" ];then
	echo 'there is no mariadb.repo'
	touch MariaDB.repo && echo 'OK,there is~'
else
	mv $MARI MariaDB.repo.bak 2>/dev/null
fi
# 修改repo，直接覆盖，因为上面已备份原文件了
cat > /etc/yum.repos.d/MariaDB.repo << EOF
[mariadb]
name = MariaDB
baseurl = http://mirrors.ustc.edu.cn/mariadb/yum/$MARI_VER/centos7-amd64/
gpgkey = http://mirrors.ustc.edu.cn/mariadb/yum/RPM-GPG-KEY-MariaDB
gpgcheck = 1
EOF
# 开始安装，repo中已指定版本，可修改 MARI_VER
yum clean all
yum install MariaDB-server MariaDB-client -y
sleep 3
systemctl enable mariadb &&\
    echo '已设置开机自启' &&\
    echo '检测是否安装成功' &&\
    systemctl start mariadb

# 测试是否安装，并启动成功
[ $? -eq 0 ] && echo 'mariadb 安装成功' || echo 'mariadb 安装失败'
# 开启端口， 3306
open_port() {
firewall-cmd --list-ports &>/dev/null
[ $? -ne 0 ] && echo '请检查防火墙是否运行，再执行以下： ' &&\
        echo 'firewall-cmd --zone=public --add-port=3306/tcp --permanent' &&\
        echo 'firewall-cmd --reload' || firewall-cmd --zone=public --add-port=3306/tcp --permanent &>/dev/null &&\
        firewall-cmd --reload &>/dev/null &&\
        echo '检查端口是否添加成功： ' `firewall-cmd --zone=public --query-port=3306/tcp`
}

open_port