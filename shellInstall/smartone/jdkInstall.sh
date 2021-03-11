#!/bin/bash
set -e
# 作用是， 告诉bash，如果任何语句的执行结果不是true则应该退出。 好处是防止错误像滚雪球变大导致一个致命的错误。 也可 set -o errexit

# 源码安装jdk
# TODOList:
# 1. 将 /etx/profile 文件中以前的配置jdk 删掉。 虽然 /etc/profile 是以追加在最后的内容 为准
# 2. 判断默认安装的jdk，并卸载
    # yum list installed | grep jdk  && yum remove java-1.8.0-openjdk*

#变量
JAVA_DIR="/usr/local/java"
BAK_RQ=`date +%Y%m%d%H%M%S`
JDK_DIR="jdk1.8.0_221"
JAVA_HOME=/usr/local/java/$JDK_DIR

yum install -y glibc.i686

if [ ! -z "$JAVA_HOME" ];then
    yum remove -y java-*-openjdk*
    mkdir -p $JAVA_DIR &&\
            wget http://meeting.sipingsoft.com/smart/jdk-8u221-linux-i586.tar.gz -P /tmp &&\
            tar -zxvf /tmp/jdk-8u221-linux-i586.tar.gz -C $JAVA_DIR
else
# 还要将 /etc/profile 文件内 JAVA_HOME类似内容删掉
# $JAVA_HOME 这个判断条件， 不标准
    mv $JAVA_DIR /usr/local/java_bak_$BAK_RQ 2>/dev/null
    mkdir -p $JAVA_DIR &&\
        wget http://meeting.sipingsoft.com/smart/jdk-8u221-linux-i586.tar.gz -P /tmp &&\
        tar -zxvf /tmp/jdk-8u221-linux-i586.tar.gz -C $JAVA_DIR
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