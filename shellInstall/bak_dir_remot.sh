#!/bin/bash
# the directory for story your backup file.you shall change this dir
# 此脚本用于备份指定目录下的所有文件夹
# todolist
# 1. 可以将scp和 mv 放到循环内，每次循环执行一遍此套动作（也可以写成func，tar+ scp+ mv）
set -e

BAK_DIR="/mnt/data/portal"
a="$(ls -l "$BAK_DIR" |awk '/^d/ {print $NF}')"

for i in $a
do
        tar -czpf $i.tar.gz $BAK_DIR/$i
done

[ $? -eq 0 ] &&\
        scp ./*.tar.gz root@116.62.156.142:/mnt/mysql/databak/
# 异地备份
[ $? -eq 0 ] &&\
        mv ./*.tar.gz /tmp/
