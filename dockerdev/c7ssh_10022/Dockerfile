#
FROM centos:7.9 AS stage_1
LABEL maintainer zelin.liu@sipingsoft.com

RUN mkdir -p /var/run/sshd \
    echo 'UseDNS no' >> /etc/ssh/sshd_config\
    sed -i -e '/pam_loginuid.so/d' /etc/pam.d/sshd\
    echo 'root:123456' | chpasswd\
    /usr/bin/ssh-keygen -A

# ENV
# ADD
