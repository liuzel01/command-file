#dockerfile for c7_sshd, port: 10022
FROM centos:7 AS stage_1
LABEL maintainer zelin.liu@sipingsoft.com

ADD run.sh /run.sh
ADD authorized_keys /root/.ssh/authorized_keys
RUN yum makecache fast && \
    yum install -y openssh-server && \
    chmod +x /run.sh && \
    mkdir -p /root/.ssh && \
    mkdir -p /var/run/sshd && \
    echo 'UseDNS no' >> /etc/ssh/sshd_config && \
    sed -i -e '/pam_loginuid.so/d' /etc/pam.d/sshd && \
    echo 'root:123456' | chpasswd && \
    ssh-keygen -A


EXPOSE 22
CMD ./run.sh