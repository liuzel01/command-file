#!/bin/bash
# Function:  auto install the redis-5.0.5
# TODOList:
# 1. 判断之前，有无安装 redis, 版本是否一致，并备份后， 卸载
# 2. 

REDS_BAG=redis-5.0.5.tar.gz
REDS_SRC=/usr/src/redis
REDS_DIR=/usr/local/redis
REDS_PASS=vxqas168lta3p

#安装依赖库
yum install -y cpp binutils glibc-kernheaders glibc-common glibc-devel gcc make wget &>/dev/null
wget http://meeting.sipingsoft.com/smart/$REDS_BAG -P /tmp/  2>&1
# 将错误输出绑定到标准输出上，标准输出默认，所以输出到屏幕；然后，标准输出重定向到/dev/null
# 不同于 >/dev/null 2>&1 标准输出和错误输出都丢弃
# & 意为两个输出绑定在一起，作用是错误输出和标准输出同用一个文件描述符。两个输出输出到同一个地方

[ ! -d  $REDS_DIR/bin ] && mkdir -p $REDS_DIR || echo $REDS_DIR'目录已存在'
[ ! -d $REDS_SRC/src ] && mkdir -p $REDS_SRC &&\
    tar -zxvf /tmp/$REDS_BAG -C $REDS_SRC --strip-components 1 &&\
    cd $REDS_SRC &&\
    make &&\
    make install PREFIX=$REDS_DIR || echo $REDS_SRC'目录已存在'

#(编辑redis服务配置文件,修改其中配置)
cd ${REDS_DIR} && mkdir log || exit 1

mv $REDS_SRC/redis.conf $REDS_SRC/redis.conf.bak

cp $REDS_SRC/redis.conf.bak redis.conf.bak

sed -i 's/daemonize no/daemonize yes/' redis.conf.bak
sed -i 's/bind 127.0.0.1/bind 0.0.0.0/' redis.conf.bak
sed -i 's/# requirepass foobared/requirepass '"$REDS_PASS"'/' redis.conf.bak

grep -v '^#' redis.conf.bak | grep -v '^$' > redis.conf
# sed -i '88s/protected-mode yes/protected-mode no/' $REDS_DIR/redis.conf

which redis-server &>/dev/null
[ $? -eq 1 ] && ln -sf $REDS_DIR/bin/* /usr/bin/
ss -tlnp | grep 6379 &>/dev/null
[ $? -eq 0 ] && echo '端口6379 已被占用' || nohup redis-server redis.conf &

netstat -tlnp|grep redis

# 设置开机自启
touch /etc/init.d/redis
chmod +x /etc/init.d/redis
cat > /etc/init.d/redis <<salute
#!/bin/sh
#
# redis - this script starts and stops the redis daemon
#
# chkconfig:   - 85 15
# description:  redis is 
# processname: redis

nohup redis-server /usr/local/redis/redis.conf &
salute
chkconfig --add redis &&\
    chkconfig redis on
if chkconfig --list | grep redis &>/dev/null; then
    [ $? -eq 0 ] &&\
    echo 'redis已设置为开机自启'
fi

echo "Redis 部署完成！"
echo " "
echo "如果你的系统是Centos 7在安装完毕后留意防火墙，可执行以下命令来放行redis 外部通信。"
echo "firewall-cmd --zone=public --add-port=6379/tcp --permanent"
echo "firewall-cmd --reload"
echo "firewall-cmd --zone=public --query-port=6379/tcp"
# 开启端口， 6379
if ! firewall-cmd --list-ports &>/dev/null; then
    echo '请检查防火墙是否运行，再执行以下： ' &&\
    echo 'firewall-cmd --zone=public --add-port=6379/tcp --permanent' &&\
    echo 'firewall-cmd --reload'
else  firewall-cmd --zone=public --add-port=6379/tcp --permanent &>/dev/null &&\
        firewall-cmd --reload &>/dev/null &&\
        echo "检查端口是否添加成功：  $(firewall-cmd --zone=public --query-port=6379/tcp)"
fi
