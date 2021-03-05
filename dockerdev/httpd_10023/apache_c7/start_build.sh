#! /bin/bash

docker build -t apa_c7ssh:lzl_10023 . -f Dockerfile &&\
docker run -d -p 10023:80 -p 1023:22 --name l001 apa_c7ssh:lzl_10023

# docker cp ~/.ssh/authorized_keys l001_www:/root/.ssh/authorized_keys
# docker run -itd -p 10024:80 -p 1024:22 -e APACHE_SERVERNAME=testlzl -v /home/lzl/command-file/dockerdev/httpd_10023/apache_c7/www:/var/www/html:ro --name l001_www apa_c7ssh:lzl_10023