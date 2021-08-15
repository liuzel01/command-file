#!/bin/bash
# Function:  some scripts about docker images &containers
# TODOList:


# 备份所有docker镜像
mkdir -p images && cd images
for image in `docker images | grep -v REPOSITORY | awk '{print $1":"$2}'`; do
    echo "saving the image of ${image}"
    docker save ${image} >  ${image////-}.tar
    echo -e "finished saving the image of \033[32m ${image} \033[0m"
done
# 批量加载镜像
for image in `ls *.tar`; do
    echo "loading the image of ${image}"
    docker load < ${image}
    echo -e "finished loading the image of \033[32m ${image} \033[0m"
done
# 批量杀死僵尸进程
ps -A -o stat,ppid,pid,cmd | grep -e '^[Zz]' | awk '{print $2}' | xargs kill -9
