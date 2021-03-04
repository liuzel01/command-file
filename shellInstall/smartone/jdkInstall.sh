#!/bin/bash
# 源码安装jdk
# TODOList:
# 1. 将 /etx/profile 文件中以前的配置jdk 删掉。 虽然 /etc/profile 是以追加在最后的内容 为准
# 2. 判断默认安装的jdk，并卸载
    # yum list installed | grep jdk  && yum remove java-1.8.0-openjdk*

#变量
java_dir="/usr/local/java"
bak_rq=`date +%Y%m%d%H%M%S`
jdk_dir=jdk1.8.0_221
JAVA_HOME=/usr/local/java/$jdk_dir

yum install -y glibc.i686

if [ ! -n "$JAVA_HOME" ];then
    yum remove -y java-1.8.0-openjdk* 
    mkdir -p $java_dir &&\
            wget http://meeting.sipingsoft.com/smart/jdk-8u221-linux-i586.tar.gz -P /tmp &&\
            tar -zxvf /tmp/jdk-8u221-linux-i586.tar.gz -C $java_dir
else
# 还要将 /etc/profile 文件内 JAVA_HOME类似内容删掉
# $JAVA_HOME 这个判断条件， 不标准
    mv $java_dir /usr/local/java_bak_$bak_rq 2>/dev/null
    mkdir -p $java_dir &&\
        wget http://meeting.sipingsoft.com/smart/jdk-8u221-linux-i586.tar.gz -P /tmp &&\
        tar -zxvf /tmp/jdk-8u221-linux-i586.tar.gz -C $java_dir
fi

# 添加变量到文件，使用追加， 并输出结果
cat >> /etc/profile << bb
export JAVA_HOME=$JAVA_HOME
export CLASSPATH=.:$JAVA_HOME/lib:$JAVA_HOME/jre/lib
export PATH=$PATH:$JAVA_HOME/bin:$JAVA_HOME/jre/bin
bb

source /etc/profile &&\
echo "jdk is installed !" &&\
echo 'JAVA_HOME: '$JAVA_HOME &&\
java -version