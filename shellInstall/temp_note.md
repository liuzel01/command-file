# temp note

角色 IP
k8s-master  192.168.31.61（原）   10.0.2.4    master
k8s-node1   192.168.31.62（原）   10.0.2.x    mode1
k8s-node2   192.168.31.63（原）   10.0.2.x    node2

kubeadm init \
--apiserver-advertise-address=10.0.2.4 \
--image-repository registry.aliyuncs.com/google_containers \
--kubernetes-version v1.19.3 \
--service-cidr=10.96.0.0/12 \
--pod-network-cidr=10.244.0.0/16

kubectl get nodes
[kube-flannel.yml](https://github.com/coreos/flannel/blob/v0.12.0/Documentation/kube-flannel.yml)

topk(5,(rate(namedprocess_namegroup_cpu_seconds_total{groupname="docker",instance=~"192.168.10.137"}[$interval])+
rate(namedprocess_namegroup_thread_cpu_seconds_total{groupname="docker",instance=~"192.168.10.137"}[$interval])
)
)

topk(5,(rate(namedprocess_namegroup_cpu_seconds_total{groupname="docker",instance=~"192.168.10.137:9256"}[5m])+
rate(namedprocess_namegroup_thread_cpu_seconds_total{groupname="docker",instance=~"192.168.10.137:9256"}[5m])
)
)

topk(5,(irate(namedprocess_namegroup_cpu_seconds_total{groupname=~"$processes",instance=~"$host"}[$__interval])+rate(namedprocess_namegroup_thread_cpu_seconds_total{groupname=~"$processes",instance=~"$host"}[$__interval])
))

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
mysql:
select user,host,password from mysql.user;
CREATE USER 'sks_sone'@'localhost' IDENTIFIED BY 'sksHykf8gw6l8bfs3ef';
grant all privileges on *.* to 'sks_sone'@'%' identified by 'sksHykf8gw6l8bfs3ef' with grant option;
grant all privileges on smartone_common.* to 'sks_sone'@'%' identified by 'sksHykf8gw6l8bfs3ef' with grant option;

flush privileges;

CREATE USER 'sks_sone'@'192.168.10.108' IDENTIFIED BY 'sksHykf8gw6l8bfs3ef';

set password for sks_sone@'localhost'=password('sksHykf8gw6l8bfs3ef');
set password for sks_sone@'192.168.10.108'=password('sksHykf8gw6l8bfs3ef');
CREATE USER 'sks_sone'@'192.168.10.108' IDENTIFIED BY 'sksHykf8gw6l8bfs3ef';

/bin/sh /application/apache-tomcat-8.5.20/bin/startup.sh && tail -f /application/apache-tomcat-8.5.20/logs/catalina.out
docker run -d --restart always --privileged -v /home/lscgdj-xin_sp:/application/apache-tomcat-8.5.20/webapps -p 51223:8080 --name lscgdj-xin_sp chenlulu/tomcat:v2 /bin/sh /application/apache-tomcat-8.5.20/bin/startup.sh && tail -f /application/apache-tomcat-8.5.20/logs/catalina.out

firewall-cmd --zone=public --add-port=3306/tcp --add-port=4444/tcp --add-port=4567/tcp --add-port=4568/tcp --permanent
firewall-cmd --zone=public --add-port=80/tcp --add-port=8080/tcp --add-port=3306/tcp --add-port=9999/tcp --add-port=8848/tcp --add-port=3000/tcp --add-port=4000/tcp --add-port=4100/tcp --add-port=4200/tcp --add-port=4300/tcp --add-port=4400/tcp --add-port=9000/tcp --add-port=6379/tcp --add-port=5003/tcp --permanent
/usr/local/mysql/bin/mysqldump -uroot -psks.slave  sksdb_crm --skip-lock-tables         > sksdb_crm_bakup.sql
grant all privileges on *.* to root@"%" identified by "sks123.com";

./soffice -headless -accept="socket,host=127.0.0.1,port=8100:urp;" -nofirststartwizard & 

firewall-cmd --zone=public --add-port=8012/tcp --add-port=8100/tcp --add-port=9000/tcp --permanent
firewall-cmd --permanent --zone=public address="192.168.10.107" port protocol="tcp" port="111"
grant all privileges on *.* to sone1@"%" identified by "sks123.com";
create database smartone_common CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;
change master to master_host='192.168.10.108',master_user='root',master_password='sks123.com',master_log_file='mysql-bin.000004',master_log_pos=986;
grant replication slave,replication client on *.* to root@'192.168.10.107' identified by 'sks123.com';

firewall-cmd --zone=public --add-port=9999/tcp --add-port=8848/tcp --add-port=3000/tcp --add-port=8012/tcp --add-port=4000/tcp --add-port=9000/tcp --add-port=4000-5000/tcp --permanent

/usr/local/mysql/bin/mysqldump -u$user -p$passwd  information_schema --skip-lock-tables         > "$backup_dir/"information_schema_"$time.sql"

create database smartone_nacos CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;
create database smartone_license CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;
grant all privileges on smartone_nacos.* to 'sks_sone'@'%' identified by 'sksHykf8gw6l8bfs3ef' with grant option;
grant all privileges on smartone_license.* to 'sks_sone'@'%' identified by 'sksHykf8gw6l8bfs3ef' with grant option;

# 查看用户的权限，及撤销权限

show grants for sks_sone;
revoke all on *.* from dba@localhost;
# 查看数据库版本

进入数据库，show version();

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# 给文件中ip server，发送id_rsa.pub
for i in `cat ip_sp.txt`;do ssh-copy-id -i ~/.ssh/id_rsa.pub root@$i;done
#  显示过滤掉# 开头和空格后的配置信息
grep -Ev "^$|^[#;]" redis.conf
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

wget https://mirrors.tuna.tsinghua.edu.cn/mariadb//mariadb-10.4.6/bintar-linux-systemd-x86_64/mariadb-10.4.6-linux-systemd-x86_64.tar.gz
mariadb密码，sks123.com

微信公众号-与开发者模式绑定，因此要用到接口去配置，比如说菜单...
微信接口调试页面，前往，https://mp.weixin.qq.com/debug?token=980797293&lang=zh_CN
appid+secret，拼接的地址为，
    https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=wxdf1ad0c1c7590f4e&secret=bc8310072386062e0ddf5fea6ff60b42
    可以获得access_token，
此为，access_token，
    {"access_token":"39_onEaw_AXP5lVQcmCInEQGN1STGXQ8RHQRxT-f2Fzwpp7pNM_owFwVAbXBNj9Jwm_Ty-ocF-9M3pCKVhlGsG6e6zNDy7g8mWfr6ZTqBw3Dm_VgxUdBX9_vFVGJ4zpJAGUvMVdcOAuU-YZ7UpZNUOdAHAVCW","expires_in":7200}
    https://api.weixin.qq.com/cgi-bin/menu/addconditional?access_token=39_FSSg_9mrCYoLlHIoPtsmYKsjhAJZSQHRA7reA1fFpzyypwwvyT3MImfzi69k8xMbMFxpTjJG1hS3ar0VwZPNMMvsQ6eO-H1r0XZONcgtEWhZbC8biFAG4BAaMpy_LljMnkxX7AiiP2a2ZQdwPKBgAJAAVM
在微信接口调试页面，可以利用access_token，获取到菜单的详细信息，注意token需要手动获取，因为每次的都不一样
利用access_token，还是刚才的微信接口调试页面，上传图片，获取到media_id
接着，在上上步的菜单详细信息中，添加上如下格式，即是新菜单的详细信息。然后，还是回到微信接口调试页面上去，去调用生成菜单的接口
        {
           "type": "media_id", 
           "name": "图片", 
           "media_id": "MEDIA_ID1"
        }

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
- yum 更新时报错，需要删除软件包。操作还是谨慎点，不要轻易点yes

    1. package-cleanup --cleandupes
    2. 可以只升级某一个软件包，，  yum update -y docker-ce

- 更换jenkins的源,编辑 /home/jenkins_home/updates/default.json

    1. sed -i 's#http:\/\/updates.jekins-ci.org\/download#https:\/\/mirrors.ustc.edu.cn\/jenkins#g' default.json && sed -i '#/http:\/\/www.google.com#https:\/\/www.baidu.com#g' default.json
        https://mirrors.ustc.edu.cn/jenkins/updates/update-center.json
    2. 中文社区,镜像地址:https://jenkins-zh.cn/tutorial/management/plugin/update-center/

- 获取结果的最后一列, 例如  docker ps -a | awk '{print $NF}'

- 哦，remote-ssh连接上后，打开文件夹，之后再开终端才会是你写代码的那个路径a

汇报汇报汇报汇报汇报汇报汇报汇报汇报汇报汇报汇报汇报汇报汇报汇报汇报汇报汇报汇报汇报汇报汇报汇报汇汇报报汇报汇报汇报汇报汇报汇报汇报汇报汇报汇报汇报汇报汇报汇报汇报汇报汇报汇报汇报汇报汇报汇报汇报报汇报汇报汇报汇报汇报汇报汇报汇报汇报汇报汇报
weekly：

- 已完成：

1.
2. 会议系统:

---

- 其他：

1.

- 未完成：

---
- 下周计划：
运维工作;
项目上的安排


- 进行中：
1. centos，整理笔记
    1. 用xmind整理下更好，梳理下

1. docker 技术入门到实践第3版,补充一下 docker_mk.txt 文档

2. smartone， 环境部署脚本， 方便其他客户（比如，windows） 快速搭建部署环境
    版本信息，

        ~~`mariadb， Server version: 10.1.48-MariaDB MariaDB Server`~~
        ~~`java， openjdk version "1.8.0_272"`~~
        ~~`minio, version RELEASE.2020-11-19T23-48-16Z`~~
        `nginx, nginx version: nginx/1.8.1`
        ~~`kkfile, wget https://kkfileview.keking.cn/kkFileView-2.2.1.tar.gz`~~
        `redis, Redis server v=5.0.5 sha=00000000:0 malloc=jemalloc-5.1.0 bits=64 build=f3676dc6baceb8a`

3. ~~曾国藩- 诫子书~~

4. 完善下jianli? 应该是在硬盘里头
    5. 写下安装smartone 环境脚本/
6. 还有一道菜(昨儿吃的🍅鸡蛋)
7. 有多少人破除了我执,这个好






2. 内核有点难。搭建实验环境，好像也不太顺利，这个坑慢慢填

3. linux_security， 服务器安全方面、安全加固， 的一些操作， **能深入实践更好**
4. linux shell 脚本
5. linux的 底层容器技术， 完善下

5. 每周一--周四，整理分享笔记，不管轮没轮到都整一篇。

1. linux-secure-方法论,这块要深究的话,其实还有很多
    不过,从使用配置层面,也要先达到最低标准
    另,从攻击角度来搞,或许能理解得更深, 你说呢









minio:9000， 开机自启，
    AccessKey: minioadmin
    SecretKey: luhgft125td4s
    export MINIO_ACCESS_KEY=minioadmin
    export MINIO_SECRET_KEY=luhgft125td4s

redis，开机自启
    设置密码，
    redis-cli -h 192.168.0.133 -p 6379
    config get requirepass
    config set requirepass "vxqas168lta3p"                  设置密码
    退出后，重新    redis-cli -h 192.168.0.133 -p 6379 -a vxqas168lta3p
        验证，  auth vxqas168lta3p
        config get requirepass






clouclouclouclouclouclouclouclouclouclouclouclouclouclouclouclouclouclouclouclouclouclouclouclouclouclouclouclouclouclouclouclouclouclouclouclouclouclouclouclouclouclouclcloucloucloucloucloucloucloucloucloucloucloucloucl
- 需求：
    1. 将云上环境与私网环境，统一管理起来
    2. 可将私网环境，打造成私有云，进行管理
        1. 做云的话，就是要实现虚拟化。
    3. 
    4. 
- 概述：
    1. PAAS（平台即服务），是一种云计算产品。服务提供商，向客户提供平台，使他们能够开发/运行和管理业务应用程序，而无需构建和维护基础设施等软件开发过程
    2. 概念区分？？？
        openstack,虚拟化。作为一个开源的云计算平台，利用虚拟化技术和底层存储服务，提供了可扩展/灵活/适应性强的云计算服务。
            1. 一台物理机上跑多台虚拟机，虚拟机共享物理机的CPU/内存/IO硬件资源；但逻辑上虚拟机之间是相互隔离的。
            2. 宿主机一般使用hypervisor实现硬件资源虚拟化。一般来讲，半虚拟化-KVM,是使用率最高的技术
            3. 优点：隔离性强。所有虚拟机都有自己的协议栈，虚拟机之间底层相互隔离
                1. 缺点：资源占用多。虚拟化技术本身占用资源，宿主机性能有10%左右消耗
        k8s,docker。是容器管理编排引擎，其底层实现是容器技术。
            1. write once, run anywhere，打包的app可以在几乎任何地方以相同的方式运行
            2. 相比于KVM虚拟化技术，特点是启动快，资源占用小。虚拟化启动虚拟机是min级别，docker是s级别
            3. 精简的文件系统可以小到100M以内。可以将容器看作是在内核上运行的独立代码单元，非常轻，因此占用的资源也少
            4. 优点：启动快，资源占用小，移植性好
                1. 缺点：隔离性不好，共用宿主机的内核，底层能够访问。依赖宿主机内核所以容器的系统选择有限制。
            5. 这部分可参考这里，https://www.cnblogs.com/goldsunshine/p/9872142.html
                1. openstack与k8s融合架构下的实践，https://www.kubernetes.org.cn/2121.html
                2. 基于docker与k8s技术构建容器云平台，https://www.huweihuang.com/kubernetes-notes/concepts/architecture/paas-based-on-docker-and-kubernetes.html
                3. openshift,redhat开源的，应该用不到
    3. 使用场景？？？
        1. openstack+KVM：
            安全和隔离；
            提供基础设施；如若在业务场景中，很依赖虚拟机，例如编译内核或驱动开发等
            存储需求；存储和计算，存储需求很大的场景下，能提供高效安全的存储方案，所以电信行业看好openstack的原因
            动态数据场景；即不需要反复创建和销毁这些服务的运行环境
        2. k8s+（docker）：
            业务变化快，业务量未知；
            需要反复地创建和销毁这些服务的运行环境；其优势在于启动快速，消耗资源小
            需要业务模块化和可伸缩性；容器可以很容易地将app的功能分解为单个组件，符合微服务架构的设计模式
            应用云化；
            微服务架构和API管理；服务拆分来抽象不同系统的权限控制和任务，以方便业务开发人员通过服务组合快速的创建企业应用。
    4. 阿里云  kubernetes，集群管理实践，（解决之道）


- 总结：
    1. 从下而上搭建，如若要平滑过度（不影响现有环境），可以底层OS->>docker->>编排工具


- 问题记录：

1. 描述：启动docker报错，E: Sub-process /usr/bin/dpkg returned an error code (1)
    systemd[1]: Failed to listen on Docker Socket for the API.
    -- Subject: Unit docker.socket has failed
2. 解决：在 /lib/systemd/system/docker.socket 里将SocketGroup=docker，改成root，
    之后，root用户启动就成功了。
    接着将用户加入到root用户组，或者是加入docker组，
    sudo usermod -aG root lzl 
    检查，id lzl 
    另外，还可以设置主组，sudo usermod -g root lzl

- 问题记录：

1. 







unixunixunixunixunixunixunixunixunixunixunixunixunixunixunixunixunixunixunixunixunixunixunixunixunixunixunixunixunixunixunixunixunixunixunixunixunixunixunixunixunixunixunixunixunixunixunixunixunixunixunixunixunixunixunix

1. docker images ,sort -n -t ' ' -k 5r,将输出结果按照镜像大小进行排序
    docker images | sort -n -k 10r -t ' '
2. 192.168.10.62，还未拉取镜像，因为上面运行有其他mino 等容器。待确认后，再操作


6. 要创建一个集群，则需要提供一台主机，用作执行命令，用来创建rancher-agent，rancher/rancher-agent:v2.5.3，就下面这个
    sudo docker run -d --privileged --restart=unless-stopped --net=host -v /etc/kubernetes:/etc/kubernetes -v /var/run:/var/run registry.cn-hangzhou.aliyuncs.com/rancher/rancher-agent:v2.5.3 --server https://192.168.10.62 --token 2bpf9cfsfmdmh2n4pc555lntcrr2jx4ppmwkt5tc9b97zsv5pnmn42 --ca-checksum df3f8a359b9a6daf65468988b37cc689901ebe8637d2039349fcbbdd1c9a968e --etcd --controlplane --worker
    1. 若不执行，你的集群就会提示，Waiting for etcd and controlplane nodes to be registered

7. 
    uname -r` ,`cat /etc/redhat-release
    rpm -import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
    rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm
    yum list installed | grep kernel*                   查看已安装的内核软件
    tar -zxvf linux-5.5.9.tar.gz  -C /usr/local 
    yum install elfutils-libelf-devel bc ncurses-devel flex bison -y


    lspci -v                查看使用的网卡驱动（内核默认使用的网卡驱动r8169，但实际网卡是r8168）
        `yum whatprovides */lspci`                      yum查看lspci 的所属软件包

    ethtool -i enp3s0        查看网卡的固件版本以及所依赖的驱动，firmware-version: rtl8168g-2_0.0.1 02/06/13
    lspci -nn | grep -i eth  查看具体的网卡驱动型号，
      03:00.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller [10ec:8168] (rev 0c)

    awk -F\' '$1=="menuentry " {print $2}' /etc/grub2.cfg 查看grub中默认的内核版本

1. linux命令行，^替换掉上调命令的部分内容
    zsh里头，需要按tab将内容给你补充显示出来，要不回车后，他还是需要你确认的
    1. ^old^new             换掉输错或输少的部分
        ansible vod -m command -a 'uptim'       如果是uptimee，就不好说了？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？
        ^im^ime
        !:s/is/e            这也能达到效果

    2. !:gs/old/new         将old内容全部换成new，              用久了就发现，其实这些和vim中的操作是类似的
        ansible nginx -m command -a 'which nginx'
        !:gs/nginx/squid
        ^nginx^squid^:G     # zsh

    3. !! 执行上一条命令，
        比如，sudo !!
        !10，执行第10条命令

    4. cd !$，              !$得到上条命令的最后一位参数
        cd !^，             得到上条命令的第一个参数
        vim !:2             !:n，得到上条命令第n个参数
        vim !:1-2           !:x-y，得到上条命令从x到y的参数
        vim !:n*            !:n*,从n开始到最后的参数
        cp -r !*            !*,得到上条命令所有参数

    5. !$:h,                  选取路径开头
        比如，ls /usr/share/fonts/urw-base35
            cd !$:h,    会到，cd /usr/share/fonts

        1. !$:t,            选取路径结尾
            tar -zxvf !$:t,     会到，tar zxvf nginx-1.4.7.tar.gz
            cd !$:r，           选取文件名，比如：unzip lzl01.zip,  cd !$:r 

        2. echo !$:e，          选取扩展名

    6. ctrl+w，             删除操作，光标前的一个单词（终端操作）
    7. cp lzl01.zip{,.bak}，创建备份文件，使用{} 构造字符串
        touch {1..10..2}.txt 

    8. 使用`` 或者 $() 做命令替换； 嵌套时，$()可读性更清晰

2. 查看服务器CPU，运存情况
    1. cat /proc/cpuinfo  | grep processor | wc -l      4个CPU处理器
        cat /proc/cpuinfo | grep cores                  每个CPU含4个核心，所以是，16核处理器
        或者通过lscpu，CPU(s): 4,   Core(s) per socket: 4， Socket(s): 1，      所以，其逻辑CPU的数量就是Socket*core*thread  也就是threads
    2. 

3. 通过端口查找进程PID，通过PID查找端口，就这几个命令
    ps -ef | grep 9090
    ss -tulnp | grep 9090
    lsof -n -i :9090 | grep -i listen 
    1. 为什么top 查出来的pid，用ss命令查找不到呢，查不到对应的进程，
        哦，用netstat 也是查不到的
        但是用ps，就能查找到，
    2. ps aux | grep 9090,                              能查出两个进程，一个 24010 /usr/bin/docker-proxy ...；一个 24045 /bin/prometheus ...（本机并未安装prometheus）
    在top 里面显示的PID是 24045；而你用ss， 或者netstat呢，查PID理应是用24010查，用24045 就查不出来（ss 应该是用来，通过端口查进程PID的）
    或者也可以理解为，PID 24045的进程 /bin/prometheus，不占用本机的端口？
    经发现，该容器映射的端口为，0.0.0.0:9090->9090/tcp，    这也说明以后尽量不要将容器内和映射端口搞成一致的。
    3. systemctl status 24010，                         显示Active: active(running) 
    systemctl status 24045，                            提示，Failed to get unit for PID 24045: PID 24045 does not belong to any loaded unit.
    4. 

4. centos7安装sql-server，
    参考，https://blog.51cto.com/13770206/2429881

5. centos7内核相关，记录
    1. cat /boot/grub2/grub.cfg |grep menuentry         查看系统可用内核
    2. uname -sr                                         查看当前内核
    3. grub2-set-default 'CentOS Linux (3.10.0-1160.xxxx) 7 (Core)'          修改开机时默认使用的内核
    4. grub2-editenv list                               查看内核修改结果
    5. rpm -qa |grep kernel                             查看系统安装了哪些内核包
    6. yum remove kernelxxxx                            yum remove 或者rom -e 删除无用内核

    可以在线升级内核，[centos7在线升级最新版本内核](https://cloud.tencent.com/developer/article/1666173)
        rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
        yum install https://www.elrepo.org/elrepo-release-7.el7.elrepo.noarch.rpm
        yum --enablerepo=elrepo-kernel install kernel-lt                    安装lt内核，lt为长期支持的内核。 kernel-ml 为最新版本的内核
        grub2-mkconfig -o /boot/grub2/grub.cfg
        cat /boot/grub2/grub.cfg | rgep menuentry
        grub2-set-default  'CentOS Linux (5.4.93-1.el7.elrepo.x86_64) 7 (Core)'
        less /etc/default/grub                                              检查一下
        uname -sr
        grub2-editenv  list
        rpm -qa | grep kernel                                               查看系统中全部的内核RPM包
        yum remove xxxx                                                     卸载旧内核（不需要）的RPM包

6. lsblk -f                                             查看磁盘UUID
        -f, --fs                                        输出文件系统信息
        blkid， 
        ll /dev/disk/by-uuid/ 
        注意，自己要挂载的是centos_data-vdb ext4， 而不是vdb，因为你已经分区了，UUID就应该是分区后的那块盘

7. linux系统架构从外到内，可以分为，应用层（封装起来的shell）、 shell、 kernel、 hardware
8. Git， 七大基本原则
    1. 每次commit只做一件事。 linux中心原则是，所有更改都必须分解为小步骤进行。针对某一项单一任务的更改
    2. commit不能破坏构建。 不仅应该将所有更改分解为尽可能小的变量（上一条），而且不能破坏内核（就内核维护而言）。 即每个步骤都必须完全起作用，并且不引起退化。
    3. 所有代码都是二等分的。 二等分是一种操作，它使开发者可以找到所有发生错误的确切时间点。 只有在遵守上面的规则的情况下，才能很好起作用。开发者可以在十几次编译/测试中，从成千上万的可能 commit 中分离出导致问题出现的 commit 。Git 甚至可以通过 git bisect 功能帮助自动化该过程
    4. 永远不要rebase 公共分支。 linux项目工作流程不允许这样，因为rebase这些公共分支后，已重新基准化的commit 将不再与 基于原存储库中的相同 commit 匹配
        在树的层次结构中，不是叶子的公共主干部分 不能重新设置基准，否则将会破坏层次结构中的下游分支。

    5. git正确合并。 
    6. 保留定义明确的commit 日志。 每个commit都必须是独立的， 这也应该包括与commit相应的日志。内核贡献者（就内核维护而言） 必须在更改的commit 日志中做出说明，让所有人了解与正在进行的更改相关的所有内容
        git blame来查看。编写良好的代码更改日志可以帮助确定是否可以删除改代码或如何对其进行修改

    7. 持续测试和集成。 linux-next是一个公共仓库，任何人都可以测试它。

9. 修改之前已commit 的某次注释信息，
    git rebase -i HEAD~3                                显示倒数三次注释。要修改哪次注释，就将前面的pick改成edit，
    git commit --amend                                  按照terminal 给出的提示，修改你要修改的注释，然后保存退出。接着回到本地最新的版本，
    git rebase --continue                               会提示， Successfully rebased and updated refs/heads/master.
    git add -A（如果你在这期间， 对文件有更改）            所以说，你在修改注释的时候，就不要改动文件了

10. 拉取指定分支的代码，
    
    git clone -b meeting_standard_v3.0 http://192.168.10.68:8000/meeting/meeting.git

11. win10环境，使用 vscode remote ssh 远程连接服务器，免密连接

    cmd, ssh-keygen -t rsa,                             生成秘钥
    将win10 上的 用户/user01/.ssh/id_rsa.pub 上传到服务器的 /root/.ssh/  目录下，
        cat id_rsa.pub  >> authorized_keys

    本来，试讲win10上面的资料mount 挂载到虚拟机 centos7mini 上去的。 现在发现，用远程服务器可以同样实现，大功告成。 不过这样的话，虽然本地资源压力减轻，但是安全性就没了。

12. [ ! -n "$JAVA_HOME" ] && echo 'is null'             判断一个变量是否为空

13. 条理清晰，有理有据













faqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaq

- 在编译安装软件时，make sense, 报错内容如下
    /usr/bin/ld: 找不到 -lc
    collect2: 错误：ld 返回 1
    make: *** [strings-static] 错误 1
- 解决： 
    1. yum install glibc-static

- 前后端分项目，后端使用 spring-boot 的项目一般都打成了jar包，需要排查问题或是修改配置的时候需要解压和打包，

    1. unzip meeting-standard.jar  -d meeting-stand                 解压包，
    2. jar -cvfM0 meeting_lzl.jar meeting-stand/                    打包

        1. 如果是我这种打了jar包，可以直接找到 对应的文件， vim修改内容并保存退出




























TODO：
1. 可以自己列一个,  作息时刻表，这名不错




















！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！
去报工系统那个地址，添加自己的报销单。不过需要首先由PM将项目建立好~~





export JAVA_HOME=/usr/java/jdk1.8.0_271\n export CLASSPATH=.:$JAVA_HOME/jre/lib/rt.jar:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar \nexport PATH=$PATH:$JAVA_HOME/bin
[nginx] 
name=nginx repo 
baseurl=http://nginx.org/packages/centos/7/$basearch/ 
gpgcheck=0 
enabled=1

