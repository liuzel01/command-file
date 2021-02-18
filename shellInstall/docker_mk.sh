#!/bin/bash
#!/bin/sh
# author: liuzel01
# platform: centos7
# date: 2020-06-xx
# 此脚本方便一键创建docker容器

docker run --rm -d  --name=centos6_02 --hostname centos6_02  xiaobai/centos6.9_sshd_lamp_bbs:v1 /usr/sbin/sshd -D &> /dev/null
docker run --rm -d  --name=centos6_03  --hostname centos6_03 xiaobai/centos6.9_sshd_lamp_bbs:v1 /usr/sbin/sshd -D &> /dev/null

docker run --rm -d  --name=centos6_06 --privileged=true -p 226:22 --hostname centos6_06 xiaobai/centos6.9_sshd_lamp_bbs:v1 /usr/sbin/sshd -D &> /dev/null
docker inspect centos6_0{2,3,4,5,6} | grep \"IPAddress\": | head -n 1

# 允许container内使用timedatectl 
docker run --rm -d --privileged --name=centos7 --hostname centos7 -v /opt/vol/shell/:/opt/shell/ xiaobai/centos7:v1 /usr/sbin/sshd -D
docker run --rm -d --privileged -p 10020:22 --name=centoslzl --hostname centoslzl -v /opt/vol/shell/:/opt/shell/ lzl_centos7 /usr/sbin/sshd -D

--------------------------------------------------------------------------------------------------------------------------------
应用容器化实践
docker build -t myphp .
docker run -d -p 81:80 myphp

1. docker run -it -p 81:80 --name=phptest --hostname phptest -v /home/liuzel01/docker_files/test:/var/www/html -w /var/www/html php:5.6-apache
    /home/liuzel01/docker_files/test/test.php，运行起来后，浏览器访问ip:81/test.php，能看到hello world 和php version
2. docker pull mysql:5.7，Dockerfile中已将本地 my.cnf 文件添加到mysql:5.7中，build成新镜像
    docker build -t mysql:5.7-utf8 .
    docker run -d -p 4406:3306 --name mysql -v /opt/mysql/mysql-data/:/var/lib/mysql -e MYSQL_DATABASE=tiny_wish -e MYSQL_ROOT_PASSWORD=123456 mysql:5.7-utf8
    ss -tlnp | grep 4406，检查数据库是否启动，用navicat连接上可以看到tiny_wish说明可以

4. 需要注意的是，容器内的进程必须要以前台方式启动运行，不同于以往在服务器的启动方式！！！注意把命令最后的 & 给去掉，不要以后台去启动他
    4.1 而且，Dockerfile里的CMD 只能有一个，有多个的话就执行最后一个。所以，最好就把多条启动命令写在一个脚本中，再在CMD 中去执行脚本就完事了～～～

5. 将一个容器，打包成镜像，
    docker commit -a "zelin.liu" -m "test_for_legacy" legacy mylegazy:v0.1  
-----------------------------------------------------------------------------------------------------------------------------------
- 把大象装进冰箱需要几步？
1. 从仓库pull 下来原始镜像
    1.1 需要，php:5.6-apache,mysql:5.7,
    1.2 或者，java:1.8

2. 根据自定义需求，将环境和 代码添加到原镜像去，通过build成新的满足要求的镜像
    2.1 写Dockerfile，docker build  
    2.2 比如，上面mysql:5.7 的镜像，很可能需要改造成新的image，比如添加字符集utf-8等

3. 根据改造后的镜像，来启动容器。进行添加端口，存储持久化等
    3.1 指定开放端口；指定数据持久化；指定hostname；指定网络模式等

4. 此容器运行后便可看到demo 运行后的效果
- 如何优雅地使用vscode，远程服务器，在docker内部进行开发
5. 可以使用vscode remote-ssh，目的是连接上远程服务器，从而进行获得服务器上的环境，并进行开发工作
    1. 第二点，可以用 remote containers，目的是连接上远程服务器上的容器，你懂得，就很惊艳
        1. 这样，单台服务器上，环境不再成为限制，切换也很方便。

    2. 实践后，发现remote containers貌似只能远程你本地的容器，
        1. 这种，还是建议看文档，文档上是这么说的，
        2. https://code.visualstudio.com/docs/remote/containers

    ```text
    Installation
    To get started, follow these steps:
    Install VS Code or VS Code Insiders and this extension.
    Install and configure Docker for your operating system.
    ```

Dockerfile内容：
    ```dockerfile
    FROM centos:centos7.5.1804
    MAINTAINER zelin.liu@sipingsoft.com
    # 准备工作
    ENV LANG en_US.UTF-8
    ENV LC_ALL en_US.UTF-8
    RUN curl -so /etc/yum.repos.d/Centos-7.repo http://mirrors.aliyun.com/repo/Centos-7.repo
    RUN yum install -y gcc pcre-devel zlib-devel make net-tools
    ADD ./dist.tar.gz /tiny
    ADD ./wish.jar /tiny
    ADD ./jdk-8u271-linux-x64.tar.gz /usr/local/
    ADD ./nginx-1.13.7.tar.gz /opt
    ADD ./startup.sh /tiny
    ENV JAVA_HOME   /usr/local/jdk1.8.0_271
    ENV JRE_HOME    $JAVA_HOME/jre
    ENV CLASS_PATH  $CLASSPATH:$JAVA_HOME/lib:JRE_HOME/lib
    ENV PATH        $PATH:$JAVA_HOME/bin
    WORKDIR /tiny
    RUN cd /opt/nginx-1.13.7 && ./configure --prefix=/usr/local/nginx && make && make install && ln -s /usr/local/nginx/sbin/nginx /usr/bin/nginx
    ADD ./nginx_tiny.conf /usr/local/nginx/conf
    RUN chmod +x /tiny/*.sh
    EXPOSE 88
    EXPOSE 8089
    CMD ["./startup.sh"]
    ```

docker build -t tiny_lzl .
docker run -it -p 88:88 -p 8089:8089 -p 8090:8090 --name tiny_lzl tiny_lzl
登录8090不行，登录99，行
    是因为和nginx的参数，proxy_pass  有关系
访问http://192.168.226.134:88/

------------------------------------------------------------------------------------------------------------------------------------

docker commit -a "zelin.liu" -m "test_for_go"  lzl_c7_ssh lzl_go:c7_ssh     # lzl_c7_ssh 为容器名
docker run -d -p 32:22 -p 8000:8000 -v /dockerdev:/dockerdev -w /dockerdev --name lzl_go  --hostname lzl_go lzl_go:c7_ssh22
docker commit lzl_c7_ssh -a "liuzel01" -m "test_for_go" lzl_go:c7_ssh
docker commit -a "liuzel01" -m "test_for_go" lzl_c7_ssh lzl_ssh:c7      创建一个可供ssh连接的base image，当然可以用dockerfile来进行build
    1. 这样子，这个具有sshd功能的image,可作为多个环境的base image，无需每次都去配sshd了
docker run -d -p 32:22 --name lzl_ssh_c7 --hostname lzl_ssh_c7 lzl_ssh:c7 /usr/sbin/sshd -D     启起来后，再次进行环境的配置，
docker commit -a "liuzel01" -m "test_for_go" lzl_ssh_c7 lzl_go:c7ssh        配置完后，即可创建go环境的image了，
    2. 注意一定要精简。只要基础的环境即可，extra软件包无需装，在运行容器后，自己去装。需要参考网上googler是如何做的。
举个栗子，别人拿到你给的含有golang环境的image了，那么运行image即可，
    docker run -d -p 32:22 --name lzl_go_c7ssh --hostname lzl_go_c7ssh -v /home/dockerdev:/dockerdev -w /dockerdev lzl_go:c7ssh
    3. 不要忘记了每一层构建的最后，一定要清理掉无关文件，否则很容易变得臃肿

- 理解镜像构建上下文（context）
    1. 构建命令中的 . 通常被误认为是，指定Dockerfile的所在目录。这是因为在默认情况下，如若不额外指定dockerfile的话，会将上下文目录下的名为dockerfile的文件作为Dockerfile
        1. 这是默认行为。实际上，dockerfile的文件名并不要求必须为dockerfile，而且并不要求必须位于上下文目录中。例如，-f ../Dockerfile.php 指定某个文件作为Dockerfile
    2. images迁移，save和load命令，不推荐使用，应该直接用docker registry，无论是dockerhub还是内网私仓
        1. `docker save <镜像名> | bzip2 | pv | ssh <用户名>@<主机名> 'cat | docker load'`  用ssh和pv和管道，将images迁移并能看进度条
    3. 

- 容器的网络模式:       ifconfig -a ;route -n 
    1. bridge模式,默认的,创建容器后,各容器为172.17.0.x  容器名docker_bri1
    2. host模式,要指定, --net host  容器不会虚拟出自己的网卡,不会配置自己的IP,而是使用宿主机的
    3. container模式, --net container:docker_bri1  与已存在的容器共享一个Network Namespace;使用宿主机的
        网卡/IP/端口范围,与host类似.两个容器间进程可通过lo网卡设备通信
    4. none模式,--net none  none模式,容器拥有自己的Network Namespace,但是无网络配置,需要自己添加网卡/配置IP等
    5. docker跨主机通信,在后面k8s会遇到

- docker-compose:
    1. 

------------------------------------------------------------------------------------------------------------------------------------

# 创建运行jenkins
- docker run -p 8080:8080 -p 50000:5000 --name jenkins -u root -v /etc/localtime:/etc/localtime -v /home/jenkins_home:/var/jenkins_home --privileged=true -e Java_OPTS=-Duser.timezone=Asia/Shanghai -d jenkins/jenkins:lts

1. 使用jenkins/jenkins:lts，~~因为此版本jenkins较新~~  
2. 注意将之前使用的jenkins的数据存储（比如/var/lib/jenkins），迁移到现服务器上；然后添加映射到容器内

- 关于docer 多阶构建

1. docker build -t lzl_meet_nginx  .  -f meeting_nginx.dockerfile   创建项目所用nginx image
    1. docker build -t lzl_meet . -f meet.dockerfile                                  创建项目所用后台  image
    2. docker run -itd --name lzl_meet  -p 8090:8080 lzl_meet
    docker run -itd --name lzl_meet_nginx  -p 80:80 lzl_meet_nginx

2. 
3. dockerfile 部署会议系统，
    1. docker多阶段构建,（优化，降低images的体积）
    2. 多阶段构建meeting会议系统，需要两个容器（镜像），如下
        1. meeting_nginx.dockerfile构建 nginx，运行容器meet_nginx
        2. /dockerdev/meeting/Dockerfile 构建系统后台，运行容器meet
        3. mysql,运行数据库
            1. 这一步，同样可以根据打包文件夹内的sql脚本，来进行实现。。理应同meeting_nginx.dockerfile
            2. 不过，后续肯定采用本地部署数据库
        4. 可能还有部分要完善。。。比如说看不到容器meet 的日志（CMD 的启动脚本），
        5. 还有,dockerfile里面 CMD 只能 .startup.sh ,若是sh startup.sh就会报错

    3. cd ../dockerdev/meeting/， 目录结构如下
        .
        ├── meet_build.sh
        ├── meet.dockerfile
        ├── meet_nginx.dockerfile
        ├── nginx.conf
        ├── repository.tar.gz
        ├── settings.xml
        └── startup.sh

    
    1. docker run -d --restart=unless-stopped  -p 80:80 -p 443:443  --privileged  --name lzl_rancher rancher/rancher:latest
    2. 从运维角度,研发同事将打包好的images 上传到harbor;
        1. 使得运维人员在现场可直接拉取对应项目的images,
            拉取到本地,直接运行就ok
    3. 从研发角度,

    - rancher 使用搭建开发环境

    - fanshi,还是先给出一个demo,

        1. 比如,基于docker的devops落地探索实践

------------------------------------------------------------------------------------------------------------------------------------

# docker 磁盘占用与清理

1. docker system df             查看docker占用分布
    1. docker system df -v      进一步查看空间占用细节，以确定是哪个image、container或volume占用过高空间

2. docker system prune          对占用空间自动清理
    1. -a   一并清除所有未被使用的image和悬空image，    -f          用以强制删除，不提示信息
    2. docker image prune       删除悬空image
    3. docker container prune   删除无用的container
        1. 默认会清理掉所有处于stopped状态的container
        2. docker container prune --filter "until=24h"          但24h内创建的除外
        3. docker {volume,network} prune                        删除无用的卷、网络

    悬空镜像：未配置任何tag（也就是无法被引用）的镜像。通常是由于镜像编译过程中未指定 -t 参数配置tag导致的。

3. 手动清除
    1. docker rmi $(docker images -f "dangling=true" -q)        删除所有悬空镜像，不删除未使用镜像
        -f filter
    2. docker volume rm $(docker volume ls -qf dangling=true)   删除未被容器引用的卷
    3. docker rm -v $(docker ps -aq -f status=dead)             删除所有状态为dead的容器
    
# 技巧技巧

1. docker容器内date与宿主机不同，因为是时区导致的。

    1. 在创建时，只需将容器内的localtime改成你想要的时区就可。
    -v /etc/localtime:/etc/localtime
    或者，-v /usr/share/zoneinfo/Asia/Shanghai:/etc/localtime
    2. 无需进入容器内部就执行命令，docker exec -it lzl02 date 查看日期时间

2. 调整容器的磁盘空间大小，（用户执意要调整rootfs大小）

    1. 需要对磁盘开启quota特性，
        mkfd.xfs -f /dev/sdc 
        mount -o uquota,prjquota /dev/sdc /datadata/
        xfs_quota -x -c 'report' /datadata/
        blkid /dev/sdc                  写入到 /etc/fstab 文件内，
            UUID=3416a76b-ad7c-491d-8e25-b65434a6f8f7 /datadata                   xfs     rw,pquota        0 0
        cat /proc/mounts | grep sdc     可以看到已经被挂载的目录和参数
        这样，这个分区就支持了目录配额，之后就可以对docker去限制其空间大小

    2. 修改 /etc/docker/daemon.json ,设置每个容器可以使用的磁盘空间为2G
        {
            "registry-mirrors":["https://3oxbtpll.mirror.aliyuncs.com"],
            "insecure-registries":[
            "192.168.10.85","192.168.10.85:5000","192.168.226.134:5000","192.168.226.134"
            ],
            "live-restore":true,
            "data-root": "/datadata/docker",
            "storage-driver": "overlay2",
            "storage-opts": [
            "overlay2.override_kernel_check=true",
            "overlay2.size=2G"
            ]
        }

    3. 这样，之前的images 和 container 都空了，因为docker存储在宿主机上的位置变了
    4. 创建容器后，docker exec -it vol01 df -H  查看overlay空间大小
        1. 进入容器，dd if=/dev/zero of=/a bs=100M count=20 创建一个2G大小的文件，再创建一个2G大小的，查看文件大小，会不足2G
    
    5. 参考，https://blog.csdn.net/qq_34556414/article/details/108058302

3. 快速管理容器和镜像

    1. docker ps --format='{{.Names}}'                              输出容器的name
    2. docker ps -f name=harbor --format='{{.Names}}'               输出所有容器名包含harbor的容器名
    3. docker ps -qf status=exited
    4. docker images -qf dangling=true                              查看悬挂镜像
    5. docker images --format='{{.ID}}:{{.Repository}}'             只列出镜像id以及仓库名称
        docker images --format='{{.Repository}}:{{.Tag}}'        

    6. docker ps -f name=harbor --format='{{.ID}}:{{.Image}}:{{.Status}}:{{.Names}}'        只列出容器的相关信息
    7. 给容器添加label，
        docker run -itd --name vol02 --label zone=lzl centos:7      也可以，--label group=meet
        docker ps -f label=zone=lzl --format='{{.Names}}'           docker ps -f label=group=meet

4. 快速进入容器内，没必要把ID全部写上~      docker exec -it f69 sh
    1. docker inspect -f '{{.GraphDriver.Data.DeviceName}}' nginx   查看容器的devicemapper 设备
    2. docker inspect -f '{{.State.Pid}}' nginx01                   查看容器的PID
        docker inspect -f '{{.Name}}' nginx01       '{{.Id}}'

    3. linux别名
        1. alias dockerrm='docker rm -f -v'
        alias dockerexec='docker exec -it'
        alias dockerrmi='docker rmi'
        dockerexec 16355 /bin/sh -c '/bin/ps -ef | grep gitlab'

5. --restart=always                                                 使容器随着 docker daemon 的启动一同启动
6. docker ps -s                                                     查看容器大小
7. 暂停一个或多个容器中的所有进程。挂起所有进程，而不是关闭当前容器
    docker ps
    docker pause dfd1                                               对当前容器进行暂停进程
    docker ps                                                       查看到，当前容器的 STATUS 中添加了 Paused
    docker unpause dfd1

8.
