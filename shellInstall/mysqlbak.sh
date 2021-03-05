#2018.06.09
#定义用户名和密码
username="root"
password="123456"
#设置备份目录，在此为/mysqlbak，可自行设置
backup_dir="/mysqlbak"
#获取系统时间格式201806091420
backuptime="$(date +"%Y%m%d%H")"
#删除时间设置为当前时间前2周
deletetime=`date -d "2 week ago" +"%Y%m%d%H"`
rm -f $backup_dir/mysqlbak_$deletetime.zip
#进入mysql可执行文件目录，本人mysql安装在/usr/local/mysql
cd /usr/local/mysql/bin
#执行导出全库语句
# ./mysqldump -u$username -p$password --all-databases> "$backup_dir"/mysql_"$backuptime.sql"
# 一般的，如果数据库过多， 就需要单独备份，这样还原也好做
./mysqldump -u$username -p$password  smartone_nacos --skip-lock-tables         > "$backup_dir"/smartone_nacos_"$backuptime.sql"

zip -r $backup_dir/mysqlbak_$backuptime.zip  $backup_dir/*.sql
[ $? -eq 0 ] && rm -rf $backup_dir/*.sql
