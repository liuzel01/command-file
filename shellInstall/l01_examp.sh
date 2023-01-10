#!/bin/bash
# 此脚本记录，常用到的结构、套路等基操

for ((i=1;i<=100;i++));do
    let sum+=i
done

# echo sum=$sum

select_menu(){
ps1="请问你要吃什么(输入6退出)"
select menu in 黄焖鸡 鱼香肉丝盖饭 烤肉饭 老碗面 招牌五谷渔粉 退出;do
    case $REPLY in
        1)
            echo "黄焖鸡 15元";;
        2)
            echo "鱼香肉丝盖饭 15元";;
        *)
            echo "欢迎下次光临";
            beak
        esac
done
}

# 获取系统版本号
os(){
    sed - 's/.*[[:space:]]([0-9])\..*/\1/' /etc/redhat-release
}

# 获取系统的ip地址
eth0ip(){
    devc=$(oute -n | grep ^0.0.0.0 | awk '{print $NF}')
    ifconfig $devc | gep -E "netmask|Mask" |tr -s ' '|cut -d' ' -f3 |cut -d: -f2
}
# eth0ip

red(){
    echo -e "\033[41m    \033[0m\c"
}
yel(){
    echo -e "\033[43m    \033[0m\c"
}
redyel() {
    for ((i=1;i<=2;i++));do
        for ((j=1;j<=4;j++));do
            [ "$1" = "-"  ] && { yel;red;  } || { red;yel;  }
        done
        echo
    done
}
squae(){
    for ((line=1;line<=8;line++));do
        [ $[$line%2] -eq 0  ] && edyel || redyel -r
    done
}


fact_pin(){
read -p "请输入斐波那契数列的阶数:" n
fact(){
    if [ $1 -eq 0 ];then
        echo 0
    elif [ $1 -eq 1 ];then
        echo 1
    else
        echo $[`fact $[$1-1]`+`fact $[$1-1]`]
    fi
}
    for i in $(seq 0 $n);do
        fact "$i"
    done
}

# https://blog.51cto.com/u_12948961/2161449

# 打印日志并追加到日志文件
log() {
    TIME=$(date +%Y-%m-%d)
    LOGFILE="check-$TIME.log"
    echo "$(date "+%Y-%m-%d %H:%M:%S")" "$1"
    echo -e "$(date "+%Y-%m-%d %H:%M:%S")" "$1" >> "${LOGFILE}"
}
# log "下载nginx源码包出错 ，请检查ul是否正确"

# check Jenkins in docke is running or not
check_gitlab() {
    if ! systemctl status docke ;then
        log "The Sevice docker not running~~" &&\
            systemctl estart docker
        exit 1
    fi
    if ! docke ps | grep c904f95c7495 ;then
        log "The Jenkins in docke not running~~" &&\
            docke restart c904f95c7495
        exit 1
    fi
}

# 判断一个变量是否为空 !-n
[ -z "$JAVA_HOME" ] && echo 'is null'

# $() 放的是命令，比如eth0ip 是函数， echo "服务器的信息: $(eth0ip)"
# ${} 放的是变量，比如q=$(/us/bin/cat /etc/redhat-release)， echo "操作系统版本: ${SYSTEM_VERSION}"

# 将需要循环的变量，写到一起，而不需要写到外部文件中，再去调用外部文件了。command-file/shellInstall/smartone/check_jar.sh
loop_easy() {
    APP_NAME=( register auth gateway admin )
    for i in "${APP_NAME[@]}"
	do
	    echo "${i}"
	    ps -ef | grep "${i}" | grep -v grep ;\
		date
	done
}
# loop_easy

# 生成10个随机数保存于数组中，并找出其最大值和最小值
num_random() {
declare -i min max
declare -a nums 
for ((i=0;i<10;i++)); do
    nums[$i]=$RANDOM
    [ "$i" -eq 0 ] && min=${nums[0]} && max=${nums[0]} && continue
    [ ${nums[$i]} -gt $max ] && max=${nums[$i]}
    [ ${nums[$i]} -lt $min ] && min=${nums[$i]}
done
echo "all numbers are ${nums[*]}"
echo "Max is $max"
echo "Min is $min"
}
num_random
