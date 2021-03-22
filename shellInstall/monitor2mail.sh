#!/bin/bash
set -e
# 一条命令，会收到一条关于所有事的邮件
# df -Ph | sed s/%//g | awk '{ if($5 > 60) print $0;}' | mail -s "Disk Space Alert On $(hostname)" zelin.liu@sipingsofr

# 计算cpu使用率
cpu_used_persent=$(top -b -n5 | fgrep "Cpu(s)" | tail -1 | awk -F'id,' '{split($1, vs, ","); v=vs[length(vs)]; sub(/\s+/, "", v);sub(/\s+/, "", v); printf "%d", 100-v;}')
# 计算运存使用率
mem_used_persent=$(free -m | awk -F '[ :]+' 'NR==2{printf "%d", ($3)/$2*100}')
# 计算磁盘空间使用率
disk_used_persent=$(df -THP | awk -F '[ ]+' 'NR!=1{print $1","$6}')

create_ips() {
# /usr/bin/fgrep -i "the func for getting ip of this Server." /etc/profile
# 不知道为什么,条件写到外面来(上面一行),就运行不下去,会被bash 识别为运行无结果 的命令

if /usr/bin/fgrep -i "the func for getting ip of this Server." /etc/profile; then
	exit 1
else
	cat >> /etc/profile << salute

# 小写, 用于和系统变量区分
mail="zelin.liu@sipingsoft.com"
# the func for getting ip of this Server.
ips(){
    local nics=\$(route -n | grep ^0.0.0.0 | awk '{print \$8}')
    for nic in \$nics
    do
        local ip=\$(ifconfig \$nic | grep -E 'inet\s+' | sed -E -e 's/inet\s+\S+://g' | awk '{print \$2}')
#         echo \$ip [\$nic]
        echo \$ip
    done
}
salute
fi
}

# 获取服务器ip地址， 写入系统配置文件，就可以全局调用了
# ifconfig | grep -A1 "en" | grep 'inet' |awk -F ' ' '{print $2}'|awk '{print $1}'
# cat /proc/net/dev | awk '{i++; if(i>2){print $1}}' | sed 's/^[\t]*//g' | sed 's/[:]*$//g'
# sh ll.sh | mail -s "Disk Space Alert On $(hostname): $(ips)" $MAIL
echo -e "\033[31m计算cpu使用率~: \n$cpu_used_persent"%"\033[0m"
echo -e "\033[31m计算运存使用率~: \n$mem_used_persent"%"\033[0m"
echo -e "\033[31m计算磁盘使用率~: \n$disk_used_persent"%"\033[0m"
create_ips; source /etc/profile