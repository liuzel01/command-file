#!/bin/bash
# Function:  auto install the apache
# TODOList:
# 1. yumInstall 将失败原因打印出来
# 2. 将myhttpd命令添加到可以systemctl调用
# 3. 目前是安装特定版本，可以打印出来并让用户自定义
# #######################################判断是否有apache运行
/bin/netstat -tln | grep 80
[ $? -eq 0 ] && echo 'Already have a httpd running...' && exit 1
#if [ $httpStatus == 'active' ];then
#    echo 'Already have a httpd runing...'
#else
#    echo 'There is no httpd running!!'
#fi
if [ -d /usr/local/apache ];then
	echo "You have install httpd"
    exit 0
fi
echo "======`date +%F-%T`=========" >> /tmp/apache_install.log
# #######################################开始安装
if [ ! -d /root/tools ];then
	/bin/mkdir -p /root/tools
elif [ ! -f /root/tools/httpd-2.4.43.tar.gz ];then
	echo -e "\033[31m正在从网络下载httpd-2.4.43~\033[0m"
	wget https://mirrors.aliyun.com/apache/httpd/httpd-2.4.43.tar.gz -P /root/tools/ 1>/dev/null 2>>/tmp/apache_install.log
	if [ $? -eq 0 ];then
		echo -e "\033[31m下载成功！！~\033[0m" && sleep 2 && ll /root/tools/httpd*.tar.gz
	else
		echo "FAIL," $(wget https://mirrors.aliyun.com/apache/httpd/httpd-2.4.43.tar.gz -P /root/tools/ 2>&1 | grep ERROR)
	fi
fi
# ######################################安装需要的软件包和依赖
yumInstall(){
    echo -e "\033[31m正在安装必要软件包~\033[0m"
    yum -y install expat expat-devel*  pcre pcre-devel zlib zlib-devel* openssl &>/dev/null
    if [ $? -ne 0 ];then
        echo 'FAIL!'
    else
        echo 'SUCCESS!!软件包安装完成'
    fi
}
aprInstall(){
	yum remove -y apr &>/dev/null
	echo -e "\033[31m正在安装APR~\033[0m"
	[ ! -f /usr/local/apr*.tar.gz ] && wget https://mirrors.aliyun.com/apache/apr/apr-1.6.5.tar.gz -P /usr/local/ &>/dev/null || \
	{
	cd /usr/local && tar -zxvf apr-1.6.5.tar.gz && cd apr-1.6.5 &>/dev/null
	sed -i "s/\$RM \"\$cfgfile\"/#&/" configure &>/dev/null
	mkdir -p /usr/local/apr
	./configure --prefix=/usr/local/apr &>/dev/null
	}
	make && make install &>/dev/null
	if [ $? -ne 0 ]; then
		echo 'FAIL~'
	else
		echo 'SUCCESS!!APR安装完成'
	fi
}
aprutilInstall(){
	yum remove -y apr-util &>/dev/null
	echo -e "\033[31m正在安装apr~\033[0m"
	[ ! -f /usr/local/apr-util*.tar.gz ] && wget https://mirrors.aliyun.com/apache/apr/apr-util-1.6.1.tar.gz -P /usr/local/ &>/dev/null || \
	{
	if [ ! -f /usr/local/apr-util ]; then
		cd /usr/local && tar -zxvf apr-util-1.6.1.tar.gz &>/dev/null && cd apr-util-1.6.1 &>/dev/null
		mkdir -p /usr/local/apr-util
		./configure --prefix=/usr/local/apr-util --with-apr=/usr/local/apr &>/dev/null
		(make && make install) &>/dev/null
	else
		exit 1
	fi
	}
	if [ $? -ne 0 ]; then
		echo 'FAIL~'
	else
		echo 'SUCCESS!!APR-UTIL安装完成'
	fi
}
cd /root/tools && tar -zxvf httpd-2.4.43.tar.gz &>/dev/null
mkdir -p /usr/local/apache-2.4.43 && cd httpd-2.4.43
# ######################################编译参数可以自己进行修改。安装目录为/usr/local/apache-2.4.43
./configure \
--prefix=/usr/local/apache-2.4.43 \
--enable-deflate \
--enable-expires \
--enable-headers \
--enable-modules=most \
--enable-so \
--with-mpm=worker \
--with-apr=/usr/local/apr \
--with-apr-util=/usr/local/apr-util \
--enable-rewrite
if [ $? -ne 0 ];then
    echo "Configure error" >> /tmp/apache_install.log
    exit 1
fi
make && make install &>/dev/null
if [ $? -ne 0 ];then
    echo "Make && make install error" >> /tmp/apache_install.log
    exit 1
else
    echo "Install apache successful" >> /tmp/apache_install.log
fi
/bin/ln -s  /usr/local/apache-2.4.43 /usr/local/apache

# ######################################检查用户组是否存在，添加用户和目录,授权
/bin/grep apache: /etc/shadow
[ $? -ne 0 ] && \
{
/usr/sbin/groupadd  apache
/usr/sbin/useradd  -g  apache -s /sbin/nologin apache
}
[ ! -d /www ] && /bin/mkdir /www && chown -R apache.apache /www

cp  /usr/local/apache/conf/httpd.conf /usr/local/apache/conf/httpd-default.conf
sed -i 's#User daemon#User apache#g' /usr/local/apache/conf/httpd.conf
sed -i 's#Group daemon#Group apache#g' /usr/local/apache/conf/httpd.conf
sed -i 's#/usr/local/apache-2.4.43/htdocs#/www/#g' /usr/local/apache/conf/httpd.conf
sed -i 's#\#ServerName www.example.com:80#ServerName 127.0.0.1:80#g' /usr/local/apache/conf/httpd.conf
#修改一些最简单的http.conf配置。
# ######################################测试apache服务
[ ! -f /usr/lib/libiconv.so.2 ] && /bin/ln -sf /usr/local/lib/libiconv.so.2 /usr/lib/libiconv.so.2
#这个是因为我在一次安装中有出现错误，特意加上这句。
/usr/local/apache/bin/apachectl -t 1> /dev/null  2>>/tmp/apache_install.log

[ $? -ne 0 ] && echo "http.conf have  error "  >> /tmp/apache_install.log && exit 1
/usr/local/apache/bin/apachectl start
[ $? -ne 0 ] && echo "Can't start httpd ../bin/apachectl" >>/tmp/apache_install.log && exit 1
/bin/echo  "/usr/local/apache/bin/apachectl start" >> /etc/rc.local
cp /usr/local/apache/bin/apachectl /usr/sbin/httpd
/bin/netstat -tln | grep 80
[ $? -eq 0 ] && \
/bin/echo  `netstat -tln |grep 80 ` >> /www/index.html && /bin/echo "Http runing..." >>/tmp/apache_install.log

cat > /usr/local/apache/bin/myhttpd <<a
#!/bin/bash
# chkconfig 12345 80 90 
httpStart(){
	/usr/local/apache/bin/apachectl start
}
httpStop(){
	/usr/local/apache/bin/apachectl stop
}
case \$1 in
start)
	httpStart
	;;
stop)
	httpStop
	;;
restart)
	httpStop
	httpStart
	;;
*)
	echo 'Usage: start | stop | restart'
	;;
esac
a

chmod a+x /usr/local/apache/bin/myhttpd
# cp -arf /usr/local/apache/bin/myhttpd /etc/init.d/

# #######################################MAIN()
yumInstall
aprInstall
aprutilInstall
