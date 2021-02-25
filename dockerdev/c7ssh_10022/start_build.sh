#? /bin/bash
# ssh-keygen -t rsa &&\
# 按照dockerfile内容走，手动创建可以远程连接，但是用dockerfile 创建，就不行？？！！

cat ~/.ssh/id_rsa.pub  > ~/.ssh/authorized_keys
[ $? -eq 0 ] && \cp ~/.ssh/authorized_keys ./authorized_keys && \
docker build -t c7sshd_10022 . -f Dockerfile && \
docker run -itd -p 10022:22 --name lzl_c7ssh c7sshd_10022

[ $? -eq 0 ] && docker ps --no-trunc | grep lzl_c7ssh
# docker cp authorized_keys  lzl_c7ssh:/root/.ssh/authorized_keys

[ $? -eq 0 ] && echo 'SUCCEED~'