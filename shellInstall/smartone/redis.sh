#!/bin/bash
# Function:  auto install the redis-5.0.5
# TODOList:
# 1. 判断之前，有无安装 redis, 版本是否一致，并备份后， 卸载
# 2. 

REDS_BAG=redis-5.0.5.tar.gz
REDS_SRC=/usr/src/redis
REDS_DIR=/usr/local/redis
#安装依赖库
yum install -y cpp binutils glibc-kernheaders glibc-common glibc-devel gcc make wget &>/dev/null
[ ! -f packages/$REDS_BAG ] && wget http://download.redis.io/releases/$REDS_BAG -P packages/  &>/dev/null

[ ! -d  $REDS_DIR/bin ] && mkdir -p $REDS_DIR || echo $REDS_DIR'目录已存在'
[ ! -d $REDS_SRC/src ] && mkdir -p $REDS_SRC &&\
    tar -zxvf packages/$REDS_BAG -C $REDS_SRC --strip-components 1 &&\
    cd $REDS_SRC &&\
    make &&\
    make install PREFIX=$REDS_DIR || echo $REDS_SRC'目录已存在'

#(编辑redis服务配置文件,修改其中配置)
cd $REDS_DIR
mkdir log
mv $REDS_SRC/redis.conf $REDS_SRC/redis.conf.bak
cp $REDS_SRC/redis.conf.bak redis.conf.bak
sed -i 's/daemonize no/daemonize yes/' redis.conf.bak
sed -i 's/#bind 127.0.0.1/bind 0.0.0.0/' redis.conf.bak

grep -v '^#' redis.conf.bak | grep -v '^$' > redis.conf
# sed -i '88s/protected-mode yes/protected-mode no/' $REDS_DIR/redis.conf

#(将初始化文件配置到系统自启动的文件夹内，redisd为服务名，可自行修改)
# mkdir -p /etc/redis
# ln -s $REDS_DIR/redis.conf /etc/redis/6379.conf
# ln -s $REDS_SRC/utils/redis_init_script /etc/init.d/redisd
#(开启redis服务，服务名为：redisd)

which redis-server &>/dev/null
[ $? -eq 1 ] && ln -sf $REDS_DIR/bin/* /usr/bin/
ss -tlnp | grep 6379 &>/dev/null
[ $? -eq 0 ] && echo '端口6379 已被占用' || nohup redis-server redis.conf &

netstat -ntpl|grep redis

# 设置开机自启
touch /etc/init.d/redis
chmod +x /etc/init.d/redis
cat > /etc/init.d/redis <<salute
#!/bin/sh
#
# redis - this script starts and stops the redis daemon
#
# chkconfig:   - 85 15
# description:  NGINX is an HTTP(S) server, HTTP(S) reverse 
#               proxy and IMAP/POP3 proxy server
# processname: redis

nohup redis-server /usr/local/redis/redis.conf &
salute
chkconfig --add redis &&\
    chkconfig redis on
chkconfig --list | grep redis &>/dev/null &&\
    [ $? -eq 0 ] &&\
    echo 'redis已设置为开机自启'

echo "Redis 部署完成！"
echo " "
echo "如果你的系统是Centos 7在安装完毕后留意防火墙，可执行以下命令来放行redis 外部通信。"
echo "firewall-cmd --zone=public --add-port=6379/tcp --permanent"
echo "firewall-cmd --reload"
echo "firewall-cmd --zone= public --query-port=6379/tcp"