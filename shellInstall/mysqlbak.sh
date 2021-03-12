#2018.06.09
#定义用户名和密码
MYSQL_USER="root"
MYSQL_PASS="sksHykf8gw6l8bfs3ef"
#设置备份目录，在此为/mysqlbak，可自行设置
BACKUP_DIR="/home/mysqlbak"
#获取系统时间格式201806091420
TIME="$(date +"%Y%m%d%H%M")"
#删除时间设置为当前时间前2周
DELETETIME=`date -d "2 week ago" +"%Y%m%d%H"`
# config for ftp
FTP_IP="192.168.4.247"
FTP_USER="Administrator"
FTP_PASS="Admin@bzzn"
FTP_DIR="mysqlbak"

# 这个可能不太对
# rm -f $BACKUP_DIR/mysqlbak_$DELETETIME.zip
#进入mysql可执行文件目录，本人mysql安装在/usr/local/mysql
bak_mysql() {
cd /usr/bin
# ./mysqldump -u$MYSQL_USER -p$MYSQL_PASS --all-databases> "$BACKUP_DIR"/mysql_"$TIME.sql"
./mysqldump -u$MYSQL_USER -p$MYSQL_PASS  smartone_common --skip-lock-tables         > "$BACKUP_DIR"/smartone_common_"$TIME.sql"
./mysqldump -u$MYSQL_USER -p$MYSQL_PASS  smartone_nacos --skip-lock-tables         > "$BACKUP_DIR"/smartone_nacos_"$TIME.sql"

# 因为后面放到win2012上去，打成zip包
zip -r $BACKUP_DIR/mysqlbak_$TIME.zip  $BACKUP_DIR/*.sql &>/dev/null
[ $? -eq 0 ] && rm -rf $BACKUP_DIR/*.sql
}

bak_mysql
# del zip before 10 days，执行脚本同时删除前10天的文件
del_bef_10d() {
find /home/mysqlbak -name "mysqlbak_*.zip" -a -mtime +10 -exec rm -rf {} \; &>/dev/null
}

del_bef_10d
# upload backfiles to winserver2012
curl -u $FTP_USER:$FTP_PASS ftp://$FTP_IP/ -X "MKD "$FTP_DIR &>/dev/null
# 如果在win备份服务器上手动创建了文件夹，则无需在此执行创建

# curl -u $FTP_USER:$FTP_PASS ftp://$FTP_IP/$FTP_DIR/ -T /home/mysqlbak/mysqlbak_*.zip
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

# 执行遍历，上传文件到win备份服务器
up_file2win
