#!/bin/bash

# 然鹅，在外部， docker ps 能看到端口映射了两个，22和80，但是SSH远程不进去。说明dockerdile 创建镜像时，会继承父镜像的开放端口，但并不会继承启动命令
    # 所以需要启动sshd
/usr/sbin/httpd &
/usr/sbin/sshd &
[ $? -eq 0 ] &&\
    while true; do date;sleep 100;done