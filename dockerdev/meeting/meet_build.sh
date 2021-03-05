#! /bin/bash

# 为了安全，还是自己下载代码
git clone  http://192.168.10.68:8000/meeting/meeting.git 
docker build -t meet_nginx  .  -f meet_nginx.dockerfile
docker build -t meet . -f meet.dockerfile
docker run -itd --name lzl_meet  -p 8090:8080 meet && docker run -itd --name lzl_meet_nginx  -p 80:80 meet_nginx
[ $? -eq 0 ] &&\
echo 'SUCCEED BUILD llz_meet and lzl_meet_nginx~~' &&\
docker ps -a | grep meet
