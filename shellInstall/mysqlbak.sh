#!/bin/bash
#Function: auto backup mysql file and upload to ftp server
#定义用户名和密码
MYSQL_USER="root"
MYSQL_PASS="sksHykf8gw6l8bfs3ef"
#设置备份目录
BACKUP_DIR="/home/mysqlbak"
#获取系统时间格式201806091420
TIME="$(date +"%Y%m%d%H%M")"
#删除时间设置为当前时间前2周
# DELETETIME=`date -d "2 week ago" +"%Y%m%d%H"`
# config for ftpServer-win2012
FTP_IP="192.168.4.247"
FTP_USER="Administrator"
FTP_PASS="Admin@bzzn"
FTP_DIR="mysqlbak"

[[ $EUID -ne 0 ]] && echo -e "\033[31mError: This script must be run as root!\033[0m" && exit 1
#进入mysql可执行文件目录，服务器mysql安装在/usr/local/mysql
bak_mysql() {
cd /usr/bin
# ./mysqldump -u$MYSQL_USER -p$MYSQL_PASS --all-databases> "$BACKUP_DIR"/mysql_"$TIME.sql"
./mysqldump -u$MYSQL_USER -p$MYSQL_PASS  smartone_common --skip-lock-tables         > "$BACKUP_DIR"/smartone_common_"$TIME.sql"
./mysqldump -u$MYSQL_USER -p$MYSQL_PASS  smartone_nacos --skip-lock-tables         > "$BACKUP_DIR"/smartone_nacos_"$TIME.sql"
# 因为后面放到win2012上去，这里打成zip包
zip -r $BACKUP_DIR/mysqlbak_$TIME.zip  $BACKUP_DIR/*.sql &>/dev/null
[ $? -eq 0 ] && rm -rf $BACKUP_DIR/*.sql
}

bak_mysql
# del zip file before 10 days
del_bef_10d() {
find /home/mysqlbak -name "mysqlbak_*.zip" -a -mtime +10 -exec rm -rf {} \; &>/dev/null
}

del_bef_10d
# upload backfiles to winserver2012
curl -u $FTP_USER:$FTP_PASS ftp://$FTP_IP/ -X "MKD "$FTP_DIR &>/dev/null
# 如果在win备份服务器上手动创建了文件夹，则无需在此执行创建

up_file2win() {
	cd /home/mysqlbak
	ls mysqlbak_*.zip >jj

	s=`cat jj | wc -l`
	for((i=1;i<=$s;i++))
	do {
		up_file=`sed -n "$i"p jj`
		echo upload file is $up_file
		curl -u $FTP_USER:$FTP_PASS ftp://$FTP_IP/$FTP_DIR/ -T $up_file &>/dev/null
	}
	done
}

up_file2win
