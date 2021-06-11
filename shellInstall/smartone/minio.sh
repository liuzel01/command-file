#!/bin/bash

# read, 让使用者自己输入
# 设置成开机自启

MINIO_DIR=/home/minio
MINIO_HOST=127.0.0.1
MINIO_PORT=9000

mkdir -p $MINIO_DIR/data
wget http://meeting.sipingsoft.com/smart/mc -P $MINIO_DIR/
wget http://meeting.sipingsoft.com/smart/minio -P $MINIO_DIR/
chmod +x $MINIO_DIR/mc $MINIO_DIR/minio
touch $MINIO_DIR/minio.log

# 添加进环境变量
cat >> /etc/profile.d/minio.sh << eof
# minio server
export MINIO_ACCESS_KEY=minioadmin
export MINIO_SECRET_KEY=luhgft125td4s
eof
# 后台指定参数运行
cd ${MINIO_DIR} && source /etc/profile || exit 1
# 设置成开机自启
touch /etc/init.d/minio
chmod +x /etc/init.d/minio
cat > /etc/init.d/minio <<salute
#!/bin/sh
#
# minio - this script starts and stops the minio daemon
#
# chkconfig:   - 85 15
# description:  minio is
# processname: minio

cd $MINIO_DIR ;nohup ./minio server $MINIO_DIR/data/ &
salute
chkconfig --add minio &&\
    chkconfig minio on
chkconfig --list | grep minio &>/dev/null 	&&\
    [ $? -eq 0 ] 				&&\
    echo 'minio已设置为开机自启'
# 开启端口， 9000
open_port() {
firewall-cmd --list-ports &>/dev/null
[ $? -ne 0 ] && echo '请检查防火墙是否运行，再执行以下： ' &&\
        echo 'firewall-cmd --zone=public --add-port=9000/tcp --permanent' &&\
        echo 'firewall-cmd --reload' || firewall-cmd --zone=public --add-port=9000/tcp --permanent &>/dev/null &&\
        firewall-cmd --reload &>/dev/null &&\
        echo "检查端口是否添加成功： $(firewall-cmd --zone=public --query-port=9000/tcp)"
}
open_port

nohup ./minio server --address "${MINIO_HOST}:${MINIO_PORT}" $MINIO_DIR/data  >> $MINIO_DIR/minio.log 2>&1 &
