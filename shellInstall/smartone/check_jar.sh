#!/bin/bash
# 检测服务是否有在运行，没有的话就执行脚本重启
# v1.1,精简版检测服务脚本，
# 因为是定时运行脚本，所以将需要检测的服务都写在下面
# restart_$i.sh 可参考同目录下 restart_admin.sh

APP_NAME=(register auth gateway admin erp crm)

TIME=$(date +%Y-%m-%d)
LOGFILE="check-$TIME.log"

log() {
    echo -e "$(date "+%Y-%m-%d %H:%M:%S")" "$1" >> ${LOGFILE} 2>&1
}

checkup(){
for i in "${APP_NAME[@]}"
do
    echo ${i}
    ps -ef | grep ${i} | grep -v grep &>/dev/null
    [ $? -ne 0 ] &&\
	case "$i" in
	    "register")
	    cd /home/sone|| sh restart_nacos.sh restart
	    ;;
	    *)
	    cd /home/sone|| sh restart_${i}.sh restart
	    ;;
	esac
done
}
checkup

# #检查程序是否在运行，可作参考
# is_exist(){
#   pid=`ps -ef|grep $APP_NAME|grep -v grep|awk '{print $2}'`
#   #如果不存在返回1，存在返回0     
#   if [ -z "${pid}" ]; then
#    return 1
#   else
#     return 0
#   fi
# }

# check sone-register is running ?
# ps -ef |grep sone-register | grep -v grep
# [ $? -ne 0 ] && log "Service sone-register not running~~" &&\
# 	cd /home/sone &&\
# 	sh restart_nacos.sh restart
# # check sone-auth is running ?
# ps -ef |grep sone-auth | grep -v grep
# [ $? -ne 0 ] && log "Service sone-auth not running~~" &&\
# 	cd /opt/sone &&\
# 	sh restart_auth.sh restart
