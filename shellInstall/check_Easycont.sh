#!/bin/bash

# func: EasyConnect 在centos7 x11（服务器）情况下，连接时间挺短，经常断，影响使用，
#     此脚本用于每天强制重启并登录vpn
#     可以搭配crond 实现每天早上定时执行,手动强制刷新easyconnect保持时间

PASS_VPN="yk123456"
MOUSE_X=552
MOUSE_Y=359

killall EasyConnect
sleep 1
if ! pgrep EasyConnect; then
    /usr/share/sangfor/EasyConnect/EasyConnect --enable-transparent-visuals --disable-gpu &
else
    exit 1
fi

# 利用xdotool 自动点击输入密码实现登录
if ! which xdotool;then 
  sudo rpm -Uvh http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm &&\
  yum install xdotool
fi

sleep 10
xdotool mousemove ${MOUSE_X} ${MOUSE_Y}
xdotool click 1 
sleep 1
xdotool type "${PASS_VPN}"
xdotool key Return
sleep 1

