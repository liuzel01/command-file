#!/bin/bash

# read, 让使用者自己输入
# 设置成开机自启

MINIO_DIR=/home/minio
MINIO_HOST=127.0.0.1
MINIO_PORT=9000

mkdir -p $MINIO_DIR/data
cp ./packages/* $MINIO_DIR/
touch $MINIO_DIR/minio.log

# 添加进环境变量
cat >> /etc/profile <<eof
# minio server
export MINIO_ACCESS_KEY=minioadmin
export MINIO_SECRET_KEY=luhgft125td4s
eof

# 后台指定参数运行
cd $MINIO_DIR
source /etc/profile

nohup ./minio server --address "${MINIO_HOST}:${MINIO_PORT}" $MINIO_DIR/data  >> $MINIO_DIR/minio.log 2>&1 &
