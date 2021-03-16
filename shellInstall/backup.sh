#!/bin/bash
# 此脚本用于curl+ ftp将linux服务器上数据文件，打包传输到ftp服务器上去
# 关于此，已在./mysqlbak.sh 脚本中有用到~
# curl -X/--request 指定运行什么命令
	# -T/--upload-file 上传文件

TIME=$(date +%Y-%m-%d_%H-%M-%S)
MONTIME=$(date +%Y-%m)
SQLFILE='/tmp/192.168.10.107-db-'$TIME'.sql.gz'
FILES="/tmp/192.168.10.107-files-"${TIME}".tar.gz"

tar zcvf $FILES /home/fdfs_storage/data/
mysqldump -usiping -pbackup.com sksdb_crm | gzip -c > $SQLFILE

curl -u "bak_upload:abc123." ftp://192.168.10.25/ -X "MKD "$MONTIME
curl -u "bak_upload:abc123." ftp://192.168.10.25/$MONTIME/ -T "{$FILES,$SQLFILE}"

rm -rf  $SQLFILE $FILES

echo "Backup completed."
