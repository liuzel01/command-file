#!/bin/bash

# 清理系统缓存
sync
sync
sleep 20
echo 3 > /proc/sys/vm/drop_caches

# 删除日志文件，空的文件以及文件夹
cd /va/log
find . -mtime +10 -type f -name "*log*" -exec rm -f {} \;
find . -mtime +10 -type f -name "*" -size 0c | xargs -n 1 rm -f
find . -mtime +10 -type d -empty | xargs -n 1 rm -rf

cd /usr/local/opt
find . -mtime +10 -type f -name "*log*" -exec rm -f {} \;
find . -mtime +10 -type f -name "*" -size 0c | xargs -n 1 rm -f
find . -mtime +10 -type d -empty | xargs -n 1 rm -rf

 
