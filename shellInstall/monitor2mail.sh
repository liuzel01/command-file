#!/bin/bash
set -e
# 一条命令，会收到一条关于所有事的邮件
# df -Ph | sed s/%//g | awk '{ if($5 > 60) print $0;}' | mail -s "Disk Space Alert On $(hostname)" zelin.liu@sipingsofr

MAIL="zelin.liu@sipingsoft.com"

# 计算cpu使用率
cpu_used_persent=$(top -b -n5 | fgrep "Cpu(s)" | tail -1 | awk -F'id,' '{split($1, vs, ","); v=vs[length(vs)]; sub(/\s+/, "", v);sub(/\s+/, "", v); printf "%d", 100-v;}')
echo -e "\033[31m计算cpu使用率~: \n$cpu_used_persent"%"\033[0m"

# 计算运存使用率
mem_used_persent=$(free -m | awk -F '[ :]+' 'NR==2{printf "%d", ($3)/$2*100}')
echo -e "\033[31m计算运存使用率~: \n$mem_used_persent"%"\033[0m"

# 计算磁盘空间使用率
disk_used_persent=$(df -THP | awk -F '[ ]+' 'NR!=1{print $1","$6}')
# echo -e "\033[31m计算磁盘使用率~: \n$disk_used_persent"%"\033[0m"
echo $disk_used_persent

create_ips() {
cat >> /etc/profile << salute
function ips(){
    local nics=\$(route -n | grep ^0.0.0.0 | awk '{print \$8}')
    for nic in \$nics
    do
        local ip=\$(ifconfig \$nic | grep -E 'inet\s+' | sed -E -e 's/inet\s+\S+://g' | awk '{print \$2}')
#         echo \$ip [\$nic]
        echo \$ip
    done
}
salute
}

# 获取服务器ip地址， 写入系统配置文件，就可以全局调用了
# ifconfig | grep -A1 "en" | grep 'inet' |awk -F ' ' '{print $2}'|awk '{print $1}'
# cat /proc/net/dev | awk '{i++; if(i>2){print $1}}' | sed 's/^[\t]*//g' | sed 's/[:]*$//g'
# 写入内容ips， 可以单独写一个函数

# 这里执行不过去
grep -ir "function ips()" /etc/profile
[ $? -ne 0 ] && create_ips || exit 1
source /etc/profile

# sh ll.sh | mail -s "Disk Space Alert On $(hostname): $(ip)" $MAIL