#!/bin/bash
#!/bin/sh
# backup linux system files
# 自动备份linux文件系统，有待优化

# 需要备份的文件目录，可以在命令中手输体现，也可以写进脚本中写死
SOURCE_DIR=(
    $*
)
# 默认备份路径，可自定义
DEST_DIR=/data/backup/
YEAR=`date +%Y`
MONTH=`date +%m`
DAY=`date +%d`
WEEK=`date +%u`
FILES=system_backup.tgz
# 判断是否执行成功
CODE=$?

msg(){
     printf '%b\n' "$1" >&2
}
success(){
    msg "\33[32m[?]\33[0m These ${1} System Files Backup Successfully !"
}
if
    [ -z "$*" ];then
    msg "\33[31mPlease Enter Your Backup Files or Directories\33[0m \n--------------------------------------------\nExample $0 /boot /etc ......"
    exit
fi
#判断备份路径是否存在,没有;创建
if [ ! -d $DEST_DIR/$YEAR/$MONTH/$DAY ];then
    mkdir -p $DEST_DIR/$YEAR/$MONTH/$DAY
    echo "This $DEST_DIR is Created Successfully !"
fi
# 全量备份,当周日时，删除快照并执行。成功后打印
Full_Backup()
{
if [ "$WEEK" -eq "7" ];then
    rm -rf $DEST_DIR/snapshot
    cd $DEST_DIR/$YEAR/$MONTH/$DAY && tar -g $DEST_DIR/snapshot -czvf $FILES `echo ${SOURCE_DIR[@]}` &>/dev/null
    [ "$CODE" == "0" ]&& success  Full_Backup
fi
}
# 增量备份
Add_Backup()
{
cd $DEST_DIR/$YEAR/$MONTH/$DAY ;
if [ -f $DEST_DIR/$YEAR/$MONTH/$DAY/$FILES ];then
    read -p "These $FILES Already Exists, overwrite confirmation yes or no ? : " SURE
    if [ $SURE == "no" -o $SURE == "n" ];then
	sleep 1 ;exit 0
    fi
# 添加备份文件系统，$$当前的PID。当不是周日时执行
    if [ $WEEK -ne "7" ];then
#       cd $DEST_DIR/$YEAR/$MONTH/$DAY && 
	tar -g $DEST_DIR/snapshot -czvf $$_$FILES `echo ${SOURCE_DIR[@]}` &>/dev/null
        [ "$CODE" == "0" ]&& success Add_Backup
   fi
else
   if [ $WEEK -ne "7" ];then
# 	cd $DEST_DIR/$YEAR/$MONTH/$DAY && 
	tar -g $DEST_DIR/snapshot -czvf $FILES `echo ${SOURCE_DIR[@]}` &>/dev/null
	[ "$CODE" == "0" ]&& success Add_Backup
   fi
fi
}
Full_Backup;Add_Backup
