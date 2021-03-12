#!/bin/bash
# curl -X/--request 指定什么命令
	# -T/--upload-file 上传文件

TIME=`date +%Y-%m-%d_%H-%M-%S`
MONTIME=`date +%Y-%m`
SQLFILE='/tmp/192.168.10.107-db-'$TIME'.sql.gz'
FILES='/tmp/192.168.10.107-files-'$TIME'.tar.gz'

tar zcvf $FILES /home/fdfs_storage/data/
mysqldump -usiping -pbackup.com sksdb_crm | gzip -c > $SQLFILE

curl -u "bak_upload:abc123." ftp://192.168.10.25/ -X "MKD "$MONTIME
curl -u "bak_upload:abc123." ftp://192.168.10.25/$MONTIME/ -T "{$FILES,$SQLFILE}"

rm -rf  $SQLFILE $FILES

echo "Backup completed."

