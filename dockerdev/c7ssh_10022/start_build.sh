#? /bin/bash
docker build -t c7sshd_10022 . -f Dockerfile && \
docker run -itd --name lzl_c7ssh -p 10022:22 c7sshd_10022

[ $? -eq 0 ] && docker ps --no-trunc | grep lzl_c7ssh
