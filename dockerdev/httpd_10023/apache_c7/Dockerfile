FROM c7sshd_10022:lzl
LABEL MAINTAINER zelin.liu@xxxx.com
# ENV 
ADD run.sh /root/run.sh
COPY sample/ /app
RUN chmod +x /root/run.sh &&\
    yum install -y httpd &&\
    yum clean headers &&\
    yum clean packages &&\
    yum clean metadata &&\
    \cp  /usr/share/zoneinfo/Asia/Shanghai /etc/localtime &&\
    mkdir -p /var/lock/apache2 &&\
    mkdir -p /app &&\
    rm -rf /var/www/html/ &&\
    ln -s /app/ /var/www/html


ENV APACHE RUN USER www-data 
ENV APACHE RUN GROUP www-data 
ENV APACHE_LOG_DIR /var/log/apache2 
ENV APACHE_PID_FILE /var/run/apache2.pid 
ENV APACHE_RUN_DIR /var/run/apache2 
ENV APACHE_LOCK_DIR /var/lock/apache2 
ENV APACHE SERVER砬MIN adrnin@localhost 
ENV APACHE SERVERNAME localhost
ENV APACHE SERVERALIAS docker.localhost 
ENV APACHE DOCUMENTROOT /var/www

EXPOSE 80

CMD ["/root/run.sh"]