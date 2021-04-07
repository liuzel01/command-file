#linux服务器安全加固shell脚本
#!/bin/sh
# desc: setup linux system security
# version 0.1.2 written by 
# author: 

# 执行后的效果：
#   无法直接用 root 登录远程服务器
#   密码输错三次锁定15分钟，防止密码被强制破解
#   用户只能通过登录普通用户，再通过su root， 切换到root
#   需要添加的用户需要在脚本执行前添加。否则执行后，无法添加用户及修改密码（需要额外去除文件的 i 权限）
#   系统的信息会被隐藏，用户无法进行查看及修改

# Function:对账户的密码的一些加固
read -p  "设置密码最多可多少天不修改：" A
read -p  "设置密码修改之间最小的天数：" B
read -p  "设置密码最短的长度：" C
read -p  "设置密码失效前多少天通知用户：" D

sed -i '/^PASS_MAX_DAYS/c\PASS_MAX_DAYS   '$A'' /etc/login.defs
sed -i '/^PASS_MIN_DAYS/c\PASS_MIN_DAYS   '$B'' /etc/login.defs
sed -i '/^PASS_MIN_LEN/c\PASS_MIN_LEN     '$C'' /etc/login.defs
sed -i '/^PASS_WARN_AGE/c\PASS_WARN_AGE    '$D'' /etc/login.defs
 
echo "已对密码进行加固，新用户不得和旧密码相同，且新密码必须同时包含数字、小写字母，大写字母！！"
sed -i '/pam_pwquality.so/c\password    requisite     pam_pwquality.so try_first_pass local_users_only retry=3 authtok_type=  difok=1 minlen=8 ucredit=-1 lcredit=-1 dcredit=-1' /etc/pam.d/system-auth
 
echo "已对密码进行加固，如果输入错误密码超过3次，则锁定账户！！"
n=`cat /etc/pam.d/sshd | grep "auth required pam_tally2.so "|wc -l`
if [ $n -eq 0 ];then
sed -i '/%PAM-1.0/a\auth required pam_tally2.so deny=3 unlock_time=150 even_deny_root root_unlock_time300' /etc/pam.d/sshd
fi
 
echo  "已设置禁止root用户远程登录！！"
sed -i '/PermitRootLogin/c\PermitRootLogin no'  /etc/ssh/sshd_config
 
read -p "设置历史命令保存条数：" E
read -p "设置账户自动注销时间：" F
sed -i '/^HISTSIZE/c\HISTSIZE='$E'' /etc/profile
sed -i '/^HISTSIZE/a\TMOUT='$F'' /etc/profile
 
echo "已设置只允许wheel组的用户可以使用su命令切换到root用户！"
sed -i '/pam_wheel.so use_uid/c\auth            required        pam_wheel.so use_uid ' /etc/pam.d/su
n=`cat /etc/login.defs | grep SU_WHEEL_ONLY | wc -l`
if [ $n -eq 0 ];then
echo SU_WHEEL_ONLY yes >> /etc/login.defs
fi
 
echo "即将对系统中的账户进行检查...."
echo "系统中有登录权限的用户有："
awk -F: '($7=="/bin/bash"){print $1}' /etc/passwd
echo "********************************************"
echo "系统中UID=0的用户有："
awk -F: '($3=="0"){print $1}' /etc/passwd
echo "********************************************"
N=`awk -F: '($2==""){print $1}' /etc/shadow|wc -l`
echo "系统中空密码用户有：$N"

if [ $N -eq 0 ];then
    echo "恭喜你，系统中无空密码用户！！"
    echo "********************************************"
else
    i=1
    while [ $N -gt 0 ]
    do
        None=`awk -F: '($2==""){print $1}' /etc/shadow|awk 'NR=='$i'{print}'`
        echo "------------------------"
        echo $None
        echo "必须为空用户设置密码！！"
        passwd $None
        let N--
    done
    M=`awk -F: '($2==""){print $1}' /etc/shadow|wc -l`
    if [ $M -eq 0 ];then
        echo "恭喜，系统中已经没有空密码用户了！"
    else
        echo "系统中还存在空密码用户：$M"
    fi
fi
 
echo "即将对系统中重要文件进行锁定，锁定后将无法添加删除用户和组"
read -p "警告：此脚本运行后将无法添加删除用户和组！！确定输入Y，取消输入N；Y/N：" i

case $i in
      [Y,y])
            chattr +i /etc/passwd
            chattr +i /etc/shadow
            chattr +i /etc/group
            chattr +i /etc/gshadow
            echo "锁定成功！"
;;
      [N,n])
            chattr -i /etc/passwd
            chattr -i /etc/shadow
            chattr -i /etc/group
            chattr -i /etc/gshadow
            echo "取消锁定成功！！"
;;
       *)
            echo "请输入Y/y or  N/n"
esac

read -p  "下面开始时对服务器相关账户的加固：" ; sleep 5;
# [ $? -eq 0 ] && 
#account setup
passwd -l xfs
passwd -l news
passwd -l nscd
passwd -l dbus
passwd -l vcsa 
passwd -l games
passwd -l nobody 
passwd -l avahi
passwd -l haldaemon
passwd -l gopher
passwd -l ftp
passwd -l mailnull
passwd -l pcap
passwd -l mail
passwd -l shutdown
passwd -l halt
passwd -l uucp 
passwd -l operator
passwd -l sync
passwd -l adm
passwd -l lp

# chattr /etc/passwd /etc/shadow
chattr +i /etc/passwd
chattr +i /etc/shadow
chattr +i /etc/group
chattr +i /etc/gshadow

# add continue input failure 3 ,passwd unlock time 5 minite
sed -i 's#auth       required     pam_env.so#auth       required     pam_env.so\nauth      required      pam_tally.so onerr=fail deny=3 unlock_time=300\nauth          required    /lib/security/$ISA/pam_tally.so nerr=fail deny=3 unlock_time=300#' /etc/pam.d/system-auth

# system timeout 5 minite auto logout
echo "TMOUT=300" >>/etc/profile

# will system save history command list to 10
sed -i "s/HISTSIZE=1000/HISTSIZE=10/" /etc/profile

# enable /etc/profile go!
source /etc/profile

# add syncookie enable /etc/sysctl.conf
echo "net.ipv4.tcp_syncookies=1" >> /etc/sysctl.conf
sysctl -p # exec sysctl.conf enable

# optimizer sshd_config
sed -i "s/#MaxAuthTries 6/MaxAuthTries 6/" /etc/ssh/sshd_config
sed -i "s/#UseDNS yes/UseDNS no/" /etc/ssh/sshd_config

# limit chmod important commands
chmod 700 /bin/ping
chmod 700 /usr/bin/finger
chmod 700 /usr/bin/who
chmod 700 /usr/bin/w
chmod 700 /usr/bin/locate
chmod 700 /usr/bin/whereis
chmod 700 /sbin/ifconfig
chmod 700 /usr/bin/pico
chmod 700 /bin/vi
chmod 700 /usr/bin/which
chmod 700 /usr/bin/gcc
chmod 700 /usr/bin/make
chmod 700 /bin/rpm

# history security
chattr +a /root/.bash_history
chattr +i /root/.bash_history

# write important command md5
cat > list << "EOF" &&
/bin/ping
/bin/finger
/usr/bin/who
/usr/bin/w
/usr/bin/locate
/usr/bin/whereis
/sbin/ifconfig
/bin/pico
/bin/vi
/usr/bin/vim
/usr/bin/which
/usr/bin/gcc
/usr/bin/make
/bin/rpm
EOF
for i in `cat list`
do
if [ ! -x $i ];then
echo "$i not found,no md5sum!"
else
md5sum $i >> /var/log/`hostname`.log
fi
done
rm -f list
