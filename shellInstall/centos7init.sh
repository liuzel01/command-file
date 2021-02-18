#!/bin/bash
#CentOS7生产环境优化脚本：
#网络配置，主机名配置，yum源更新，时钟同步，内核参数配置，语言时区，关闭SELINUX、防火墙，SSH 参数配置
#HowToUse: sh centos7init.sh yourHostname
###################################################################
# author: liuzel01
# status: not finished
# TODOList:
# 1. 修改备份文件以时间为后缀
# 2. history_config 参数
# 3. 最后需要重启，倒计时10s后自动重启
# 3. sh -vx centos7init.sh

# 检查是否为root用户，或sudo sh#######################################
if [[ "$(whoami)" != "root" ]]; then
	echo "请以root用户运行此脚本!"    
	exit 1
fi
echo -e "\033[31mSystem Initialization Script, Please Seriously. press ctrl+C to cancel \033[0m"

# 检查系统版本，目前仅支持64bit######################################
if [ $(uname -i) != "x86_64" ];then
#     echo "this script is only for 64bit Operating System !"
    echo -e "\033[31m the script only Support CentOS_7 x86_64 \033[0m"
    exit 1
fi

if [ ! "$1" ];then
    for ((a=3;a>=0;a--))
    do
        echo -en "用法：sh centos7init.sh Yourhostname,$a秒后退出...\r"
        sleep 1;
    done
exit 1
else
	hostnamectl  --static set-hostname  $1
	hostnamectl  set-hostname  $1
fi

cat << EOF
+---------------------------------------+
|   your system is CentOS 7 x86_64      |
|           start optimizing            |
+---------------------------------------+
EOF

# 执行倒计时#########################################################
for ((i=5;i>=0;i--))
do
        echo -en "$i秒后开始执行\r"
        sleep 1;
done

# 安装必要软件包######################################################
yum_install(){
# yum update -y
echo -e "\033[31m正在安装必要软件包~\033[0m"
yum install -y nmap unzip wget vim lsof xz net-tools iptables-services ntpdate ntp-doc psmisc crontabs &>/dev/null
if [ $? -ne 0 ];then 
    echo "FAIL," $(yum -y install xnmap unzip wget vim lsof xz net-tools iptables-services ntpdate ntp-doc psmisc crontabs 2>&1 | grep -v ^[Loading,Loaded]| grep -v .com$)
else
    echo "SUCCESS!"
    sleep 1;
fi 
}

# 设置时间同步 set time##############################################
zone_time(){
echo -e "\033[31m正在设置时间定时同步任务~\033[0m"
timedatectl set-timezone Asia/Shanghai
/usr/sbin/ntpdate cn.pool.ntp.org  &>/dev/null
/usr/sbin/hwclock -w
cat > /var/spool/cron/root << a
10 0 * * * /usr/sbin/ntpdate cn.pool.ntp.org &>/dev/null
* * * * */1 /usr/sbin/hwclock -w &>/dev/null
a
chmod 600 /var/spool/cron/root
/bin/systemctl restart crond.service 2>&1
echo "已完成！" && sleep 2
crontab -l && sleep 2
}

# 修改文件打开数#####################################################
limits_config(){
# cat > /etc/rc.d/rc.local << EOF
# #!/bin/bash
# touch /var/lock/subsys/local
# ulimit -SHn 1024000
# EOF

# 不推荐删除，应该注释掉
#sed -i "/^ulimit -s.*/d" /etc/profile
sed -i "s/^ulimit -SHn*/#&/" /etc/rc.d/rc.local
echo "ulimit -SHn 1024000" >> /etc/rc.d/rc.local

sed -i "s/^ulimit -[s,c,SHn]*/#&/" /etc/profile
cat >> /etc/profile << a
ulimit -c unlimited
ulimit -s unlimited
ulimit -SHn 1024000
a

source /etc/profile
ulimit -a
echo -e "\033[31m打印/etc/profile修改后内容~\033[0m" && sleep 2
cat /etc/profile | grep ulimit
# \cp不用别名定义的cp，避免询问
if [ ! -f "/etc/security/limits.conf.bak" ]; then
    \cp /etc/security/limits.conf /etc/security/limits.conf.bak
fi

cat > /etc/security/limits.conf << EOF
* soft nofile 1024000
* hard nofile 1024000
* soft nproc  1024000
* hard nproc  1024000
hive   - nofile 1024000
hive   - nproc  1024000
EOF

if [ ! -f "/etc/security/limits.d/20-nproc.conf.bak" ]; then
    \cp /etc/security/limits.d/20-nproc.conf /etc/security/limits.d/20-nproc.conf.bak
fi

cat > /etc/security/limits.d/20-nproc.conf << EOF
*          soft    nproc     409600
root       soft    nproc     unlimited
EOF
echo -e "\033[31m打印修改后的20-nproc.conf内容~~\033[0m" &&  sleep 2 && cat /etc/security/limits.d/20-nproc.conf | tail -n 2
}

# 优化内核参数 tune kernel parametres#################################
sysctl_config(){
if [ ! -f "/etc/sysctl.conf.bak" ]; then
    \cp /etc/sysctl.conf /etc/sysctl.conf.bak
fi
cat > /etc/sysctl.conf << aa
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv4.tcp_syn_retries = 1
net.ipv4.tcp_synack_retries = 1
net.ipv4.tcp_keepalive_time = 600
net.ipv4.tcp_keepalive_probes = 3
net.ipv4.tcp_keepalive_intvl =15
net.ipv4.tcp_retries1 = 3
net.ipv4.tcp_retries2 = 5
net.ipv4.tcp_fin_timeout = 10
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_window_scaling = 1
net.ipv4.tcp_max_tw_buckets = 60000
net.ipv4.tcp_max_orphans = 32768
net.ipv4.tcp_max_syn_backlog = 16384
net.ipv4.tcp_mem = 94500000 915000000 927000000
net.ipv4.tcp_wmem = 4096 16384 13107200
net.ipv4.tcp_rmem = 4096 87380 17476000
net.ipv4.ip_local_port_range = 1024 65000
net.ipv4.route.gc_timeout = 100
net.core.somaxconn = 32768
net.core.netdev_max_backlog = 32768
net.nf_conntrack_max = 6553500
net.netfilter.nf_conntrack_max = 6553500
net.netfilter.nf_conntrack_tcp_timeout_established = 180
vm.overcommit_memory = 1
vm.swappiness = 1
fs.file-max = 1024000
aa

#重启生效
/usr/sbin/sysctl -p
sleep 2
}

# 设置UTF-8   LANG="zh_CN.UTF-8"######################################
LANG_config(){
echo "LANG=\"en_US.UTF-8\"">/etc/locale.conf
source  /etc/locale.conf
}

#关闭SELINUX disable selinux##########################################
selinux_config(){
#sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
sed -ri '/^SELINUX=/cSELINUX=disabled' /etc/selinux/config
setenforce 0
sleep 2
}

#日志处理#############################################################
log_config(){
setenforce 0
systemctl start systemd-journald &>/dev/null
echo -e "\033[31m检查服务状态~\033[0m" && sleep 2
systemctl status systemd-journald | grep 'Active:'
}

# 关闭防火墙##########################################################
firewalld_config(){
/usr/bin/systemctl stop  firewalld.service
/usr/bin/systemctl disable  firewalld.service
}

# SSH配置优化 set sshd_config#########################################
sshd_config(){
if [ ! -f "/etc/ssh/sshd_config.bak" ]; then
    cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
fi
cat >/etc/ssh/sshd_config<<EOF
Port 22322
AddressFamily inet
ListenAddress 0.0.0.0
Protocol 2
HostKey /etc/ssh/ssh_host_rsa_key
HostKey /etc/ssh/ssh_host_ecdsa_key
HostKey /etc/ssh/ssh_host_ed25519_key
SyslogFacility AUTHPRIV
PermitRootLogin yes
MaxAuthTries 6
RSAAuthentication yes
PubkeyAuthentication yes
AuthorizedKeysFile	.ssh/authorized_keys
PasswordAuthentication yes
ChallengeResponseAuthentication no
UsePAM yes
UseDNS no
X11Forwarding yes
UsePrivilegeSeparation sandbox
AcceptEnv LANG LC_CTYPE LC_NUMERIC LC_TIME LC_COLLATE LC_MONETARY LC_MESSAGES
AcceptEnv LC_PAPER LC_NAME LC_ADDRESS LC_TELEPHONE LC_MEASUREMENT
AcceptEnv LC_IDENTIFICATION LC_ALL LANGUAGE
AcceptEnv XMODIFIERS
Subsystem       sftp    /usr/libexec/openssh/sftp-server
EOF
/usr/bin/systemctl restart sshd &>/dev/null
/usr/bin/systemctl enable sshd
}

# 关闭ipv6############################################################
ipv6_config(){
echo "NETWORKING_IPV6=no">/etc/sysconfig/network
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
echo 1 > /proc/sys/net/ipv6/conf/default/disable_ipv6
echo "127.0.0.1   localhost   localhost.localdomain">/etc/hosts
#sed -i 's/IPV6INIT=yes/IPV6INIT=no/g' /etc/sysconfig/network-scripts/ifcfg-enp0s8

for line in $(ls -lh /etc/sysconfig/network-scripts/ifcfg-* | awk -F '[ ]+' '{print $9}')
do
if [ -f  $line ]
        then
        sed -i 's/IPV6INIT=yes/IPV6INIT=no/g' $line
                echo $i
fi
done
}

# 设置历史命令记录格式 history########################################
history_config(){
export HISTFILESIZE=10000000
export HISTSIZE=1000000
export PROMPT_COMMAND="history -a"
export HISTTIMEFORMAT="%Y-%m-%d_%H:%M:%S "
##export HISTTIMEFORMAT="{\"TIME\":\"%F %T\",\"HOSTNAME\":\"\$HOSTNAME\",\"LI\":\"\$(who -u am i 2>/dev/null| awk '{print \$NF}'|sed -e 's/[()]//g')\",\"LU\":\"\$(who am i|awk '{print \$1}')\",\"NU\":\"\${USER}\",\"CMD\":\""
cat >>/etc/bashrc<<EOF
alias vi='vim'
HISTDIR='/var/log/command.log'
if [ ! -f \$HISTDIR ];then
touch \$HISTDIR
chmod 666 \$HISTDIR
fi
export HISTTIMEFORMAT="{\"TIME\":\"%F %T\",\"IP\":\"\$(ip a | grep -E '192.168|172' | head -1 | awk '{print \$2}' | cut -d/ -f1)\",\"LI\":\"\$(who -u am i 2>/dev/null| awk '{print \$NF}'|sed -e 's/[()]//g')\",\"LU\":\"\$(who am i|awk '{print \$1}')\",\"NU\":\"\${USER}\",\"CMD\":\""
export PROMPT_COMMAND='history 1|tail -1|sed "s/^[ ]\+[0-9]\+  //"|sed "s/$/\"}/">> /var/log/command.log'
EOF
source /etc/bashrc
}

# 服务优化设置########################################################
service_config(){
/usr/bin/systemctl enable NetworkManager-wait-online.service
/usr/bin/systemctl start NetworkManager-wait-online.service &>/dev/null
/usr/bin/systemctl stop postfix.service &>/dev/null
/usr/bin/systemctl disable postfix.service
chmod +x /etc/rc.local
chmod +x /etc/rc.d/rc.local
#ls -l /etc/rc.d/rc.local
}

# vim 配置还是推荐spf13-vim
vim_config(){
cat > /root/.vimrc << EOF
set history=1000
EOF
#autocmd InsertLeave * se cul
#autocmd InsertLeave * se nocul
#set nu
#set bs=2
#syntax on
#set laststatus=2
#set tabstop=4
#set go=
#set ruler
#set showcmd
#set cmdheight=1
#hi CursorLine   cterm=NONE ctermbg=blue ctermfg=white guibg=blue guifg=white
#set hls
#set cursorline
#set ignorecase
#set hlsearch
#set incsearch
#set helplang=cn
}

done_ok(){
cat << EOF
+-------------------------------------------------+
|               optimizer is done                 |
|   it's recommond to restart this server !       |
|             Please Reboot system                |
+-------------------------------------------------+
EOF
}

#main(){
yum_install
zone_time
limits_config
sysctl_config
LANG_config
selinux_config
log_config
firewalld_config
sshd_config
ipv6_config
history_config
service_config
vim_config
done_ok
#}
#main
