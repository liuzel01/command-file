# docker make

```bash
#!/bin/bash
#!/bin/sh
# author: liuzel01
# platform: centos7
# date: 2020-06-xx
# 此脚本方便一键创建docker容器
```

`docker run --rm -d  --name=centos6_02 --hostname centos6_02  xiaobai/centos6.9_sshd_lamp_bbs:v1 /usr/sbin/sshd -D &> /dev/null`

`docker run --rm -d  --name=centos6_03  --hostname centos6_03 xiaobai/centos6.9_sshd_lamp_bbs:v1 /usr/sbin/sshd -D &> /dev/null`

`docker run --rm -d  --name=centos6_06 --privileged=true -p 226:22 --hostname centos6_06 xiaobai/centos6.9_sshd_lamp_bbs:v1 /usr/sbin/sshd -D &> /dev/null`

`docker inspect centos6_0{2,3,4,5,6} | grep \"IPAddress\": | head -n 1`

- 允许container内使用timedatectl

`docker run --rm -d --privileged --name=centos7 --hostname centos7 -v /opt/vol/shell/:/opt/shell/ xiaobai/centos7:v1 /usr/sbin/sshd -D`

`docker run --rm -d --privileged -p 10020:22 --name=centoslzl --hostname centoslzl -v /opt/vol/shell/:/opt/shell/ lzl_centos7 /usr/sbin/sshd -D`
    -v source:destination

- docker,创建gitlab-ce
sudo docker run --detach \
  --hostname gitlab-l01 \
  --publish 443:443 --publish 80:80 --publish 22:22 \
  --name gitlab-l01 \
  --restart always \
  --volume /opt/gitlab/config:/etc/gitlab \
  --volume /opt/gitlab/logs:/var/log/gitlab \
  --volume /opt/gitlab/data:/var/opt/gitlab \
  gitlab/gitlab-ce:latest

- docker,创建gitlab-runner
docker run -it --name gitlab-runner-l01 --restart always \
    -v /srv/gitlab-runner/config:/etc/gitlab-runner \
    -v /var/run/docker.sock:/var/run/docker.sock \
    gitlab/gitlab-runner:latest

---

- 应用容器化实践

`docker build -t myphp .`

`docker run -d -p 81:80 myphp`

1. `docker run -it -p 81:80 --name=phptest --hostname phptest -v /home/liuzel01/docker_files/test:/var/www/html -w /var/www/html php:5.6-apache`

    -t      让docker分配一个伪终端（pseudo-tty）， 并绑定到容器的标准输入上。 -i， 让容器的标准输入保持打开。 man docker-run
    /home/liuzel01/docker_files/test/test.php，运行起来后，浏览器访问ip:81/test.php，能看到hello world 和php version

2. `docker pull mysql:5.7`，Dockerfile中已将本地 my.cnf 文件添加到mysql:5.7中，build成新镜像

    `docker build -t mysql:5.7-utf8 .`

    `docker run -d -p 4406:3306 --name mysql -v /opt/mysql/mysql-data/:/var/lib/mysql -e MYSQL_DATABASE=tiny_wish -e MYSQL_ROOT_PASSWORD=123456 mysql:5.7-utf8`
        -v xxx/mysql:/var/lib/mysql:ro           加了ro后，容器内对所挂载数据卷内的数据就无法修改了

    `ss -tlnp | grep 4406`，检查数据库是否启动，用navicat连接上可以看到tiny_wish说明可以

3. 需要注意的是，容器内的进程必须要以前台方式启动运行，不同于以往在服务器的启动方式！！！注意把命令最后的 & 给去掉，不要以后台去启动他

    1. 而且，Dockerfile里的CMD 只能有一个，有多个的话就执行最后一个。所以，最好就把多条启动命令写在一个脚本中，再在CMD 中去执行脚本就完事了～～～

4. 将一个容器，打包成镜像，

    `docker commit -a "zelin.liu" -m "test_for_legacy" legacy mylegazy:v0.1`

---

- 把大象装进冰箱需要几步？

1. 从仓库pull 下来原始镜像

    1. 需要，php:5.6-apache,mysql:5.7,
    2. 或者，java:1.8

2. 根据自定义需求，将环境和 代码添加到原镜像去，通过build成新的满足要求的镜像

    1. 写Dockerfile，docker build  
    2. 比如，上面mysql:5.7 的镜像，很可能需要改造成新的image，比如添加字符集utf-8等

3. 根据改造后的镜像，来启动容器。进行添加端口，存储持久化等
    1. 指定开放端口；指定数据持久化；指定hostname；指定网络模式等

4. 此容器运行后便可看到demo 运行后的效果

- 如何优雅地使用vscode，远程服务器，在docker内部进行开发

1. 可以使用vscode remote-ssh，目的是连接上远程服务器，从而进行获得服务器上的环境，并进行开发工作

    1. 第二点，可以用 remote containers，目的是连接上远程服务器上的容器，你懂得，就很惊艳
        1. 这样，单台服务器上，环境不再成为限制，切换也很方便。

    2. 实践后，发现remote containers貌似只能远程你本地的容器，
        1. 这种，还是建议看文档，文档上是这么[说的](https://code.visualstudio.com/docs/remote/containers)

    ```text
    Installation
    To get started, follow these steps:
    Install VS Code or VS Code Insiders and this extension.
    Install and configure Docker for your operating system.
    ```

- Dockerfile内容

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
    
    # 注意这里，只是起到声明作用，并不会自动完成端口映射。映射端口还是要，在启动时 -p 参数
    EXPOSE 88
    EXPOSE 8089
    CMD ["./startup.sh"]
    ```

`docker build -t tiny_lzl .`
`docker run -it -p 88:88 -p 8089:8089 -p 8090:8090 --name tiny_lzl tiny_lzl`

登录8090不行，登录99，行
    是因为和nginx的参数，proxy_pass  有关系

访问[192.168.226.134:88](http://192.168.226.134:88/)

---

`docker commit -a "zelin.liu" -m "test_for_go"  lzl_c7_ssh lzl_go:c7_ssh`     # lzl_c7_ssh 为容器名

`docker run -d -p 32:22 -p 8000:8000 -v /dockerdev:/dockerdev -w /dockerdev --name lzl_go  --hostname lzl_go lzl_go:c7_ssh22`

`docker commit lzl_c7_ssh -a "liuzel01" -m "test_for_go" lzl_go:c7_ssh`

`docker commit -a "liuzel01" -m "test_for_go" lzl_c7_ssh lzl_ssh:c7`      创建一个可供ssh连接的base image，当然可以用dockerfile来进行build

这样子，这个具有sshd功能的image,可作为多个环境的base image，无需每次都去配sshd了

`docker run -d -p 32:22 --name lzl_ssh_c7 --hostname lzl_ssh_c7 lzl_ssh:c7 /usr/sbin/sshd -D`     启起来后，再次进行环境的配置，

`docker commit -a "liuzel01" -m "test_for_go" lzl_ssh_c7 lzl_go:c7ssh`        配置完后，即可创建go环境的image了，

注意一定要精简。只要基础的环境即可，extra软件包无需装，在运行容器后，自己去装。需要参考网上googler是如何做的。

举个栗子，别人拿到你给的含有golang环境的image了，那么运行image即可，

1. `docker run -d -p 32:22 --name lzl_go_c7ssh --hostname lzl_go_c7ssh -v /home/dockerdev:/dockerdev -w /dockerdev lzl_go:c7ssh`

2. 不要忘记了每一层构建的最后，一定要清理掉无关文件，否则很容易变得臃肿

- 理解镜像构建上下文（context）
    1. 构建命令中的 . 通常被误认为是，指定Dockerfile的所在目录。这是因为在默认情况下，如若不额外指定dockerfile的话，会将上下文目录下的名为dockerfile的文件作为Dockerfile

1. 这是默认行为。实际上，dockerfile的文件名并不要求必须为dockerfile，而且并不要求必须位于上下文目录中。例如，-f ../Dockerfile.php 指定某个文件作为Dockerfile

    1. images打包迁移，save和load命令，不推荐使用，应该直接用docker registry，无论是dockerhub还是内网私仓
    2. `docker save <IMAGE ID> | bzip2 | pv | ssh <用户名>@<主机名> 'cat | docker load'`  用ssh和pv和管道，将images迁移并能看进度条

        `docker save 7382 > mysql.tar`

        `docker load -i /home/bakup/mysql.tar`

    3. container打包，

        1. export 将一个容器导出为文件， import将文件导入成为一个新镜像。 但相比docker save, 容器文件会丢失所有元数据和历史记录，仅保存容器当时的状态，相当于虚拟机快照

            docker export -o ubu_lzl01.tar d006

            docker import ubu_lzl01.tar -- ubu/lzl001:v1.0

- 容器的网络模式:       ifconfig -a ;route -n
    1. bridge模式,默认的,创建容器后,各容器为172.17.0.x  容器名docker_bri1
    2. host模式,要指定, --net host  容器不会虚拟出自己的网卡,不会配置自己的IP,而是使用宿主机的
    3. container模式, --net container:docker_bri1  与已存在的容器共享一个Network Namespace;使用宿主机的网卡/IP/端口范围,与host类似.两个容器间进程可通过lo网卡设备通信
    4. none模式,--net none  none模式,容器拥有自己的Network Namespace,但是无网络配置,需要自己添加网卡/配置IP等
    5. docker跨主机通信,在后面k8s会遇到

- docker-compose:

---

## 创建运行jenkins

- `docker run -p 8080:8080 -p 50000:5000 --name jenkins -u root -v /etc/localtime:/etc/localtime -v /home/jenkins_home:/var/jenkins_home --privileged=true -e Java_OPTS=-Duser.timezone=Asia/Shanghai -d jenkins/jenkins:lts`

1. 使用jenkins/jenkins:lts，~~因为此版本jenkins较新~~  
2. 注意将之前使用的jenkins的数据存储（比如/var/lib/jenkins），迁移到现服务器上；然后添加映射到容器内

- 关于docer 多阶构建 multi-stage build

1. `docker build -t lzl_meet_nginx  .  -f meeting_nginx.dockerfile`                     创建项目所用nginx image
    1. `docker build -t lzl_meet . -f meet.dockerfile`                                  创建项目所用后台  image
    2. `docker run -itd --name lzl_meet  -p 8090:8080 lzl_meet`
        `docker run -itd --name lzl_meet_nginx  -p 80:80 lzl_meet_nginx`

2. dockerfile 部署会议系统，
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

        ```text
        .
        ├── meet_build.sh
        ├── meet.dockerfile
        ├── meet_nginx.dockerfile
        ├── nginx.conf
        ├── repository.tar.gz
        ├── settings.xml
        └── startup.sh
        ```

3. `docker run -d --restart=unless-stopped  -p 80:80 -p 443:443  --privileged  --name lzl_rancher rancher/rancher:latest`
4. 从运维角度,研发同事将打包好的images 上传到harbor;
    1. 使得运维人员在现场可直接拉取对应项目的images,
        拉取到本地,直接运行就ok

5. 从研发角度,

- rancher 使用搭建开发环境

- Anything,还是先给出一个demo,

    1. 比如,基于docker的devops落地探索实践

---

## 磁盘占用

1. `docker system df`             查看docker占用分布

2. `docker system df -v`      进一步查看空间占用细节，以确定是哪个image、container或volume占用过高空间

3. `docker system prune`          对占用空间自动清理
    1. -a   一并清除所有未被使用的image和悬空image，    -f          用以强制删除，不提示信息
    2. `docker image prune`       删除悬空image
    3. `docker container prune`   删除无用的container(this will remove all stopped containers)
        1. **默认会清理掉所有处于stopped状态的container**
        2. `docker container prune --filter "until=24h"`          但24h内创建的除外
        3. docker [volume,network] prune                        删除无用的卷、网络

    > 悬空镜像：未配置任何tag（也就是无法被引用）的镜像。通常是由于镜像编译过程中未指定 -t 参数配置tag导致的。

4. 手动清除
    1. `docker rmi $(docker images -f "dangling=true" -q)`        删除所有悬空镜像，不删除未使用镜像
        -f filter
    2. `docker volume rm $(docker volume ls -qf dangling=true)`   删除未被容器引用的卷
    3. `docker rm -v $(docker ps -aq -f status=dead)`             删除所有状态为dead的容器

---

## 技巧技巧

1. docker容器内date与宿主机不同，因为是时区导致的。

    1. 在创建时，只需将容器内的localtime改成你想要的时区就可。

        -v /etc/localtime:/etc/localtime

        或者，-v /usr/share/zoneinfo/Asia/Shanghai:/etc/localtime

    2. 无需进入容器内部就执行命令，docker exec -it lzl02 date 查看日期时间

2. 调整容器的磁盘空间大小，（用户执意要调整rootfs大小）

    1. 需要对磁盘开启quota特性，

        `mkfd.xfs -f /dev/sdc`

        `mount -o uquota,prjquota /dev/sdc /datadata/`

        `xfs_quota -x -c 'report' /datadata/`

        `blkid /dev/sdc`                  写入到 /etc/fstab 文件内，
            UUID=3416a76b-ad7c-491d-8e25-b65434a6f8f7 /datadata                   xfs     rw,pquota        0 0

        `cat /proc/mounts | grep sdc`     可以看到已经被挂载的目录和参数

        这样，这个分区就支持了目录配额，之后就可以对docker去限制其空间大小

    2. 修改 /etc/docker/daemon.json ,设置每个容器可以使用的磁盘空间为2G

    ```bash
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
    ```

    1. 这样，之前的images 和 container 都空了，因为docker存储在宿主机上的位置变了
    2. 创建容器后，docker exec -it vol01 df -H  查看overlay空间大小
        1. 进入容器，dd if=/dev/zero of=/a bs=100M count=20 创建一个2G大小的文件，再创建一个2G大小的，查看文件大小，会不足2G

    3. 参考，[storage-driver overlay2限制容器可占用的磁盘空间](https://blog.csdn.net/qq_34556414/article/details/108058302)

3. 快速管理容器和镜像

    1. `docker ps --format='{{.Names}}'`                              输出容器的name
    2. `docker ps -f name=harbor --format='{{.Names}}'`               输出所有容器名包含harbor的容器名
        `docker inspect 2c04 -f {{.Architecture}}`                    输出某个镜像的架构信息
    3. `docker ps -qf status=exited`
    4. `docker images -qf dangling=true`                              查看悬挂镜像
    5. `docker images --format='{{.ID}}:{{.Repository}}'`             只列出镜像id以及仓库名称
        `docker images --format='{{.Repository}}:{{.Tag}}'`

    6. `docker ps -f name=harbor --format='{{.ID}}:{{.Image}}:{{.Status}}:{{.Names}}'`        只列出容器的相关信息
    7. 给容器添加label，
        `docker run -itd --name vol02 --label zone=lzl centos:7`      也可以，--label group=meet
        `docker ps -f label=zone=lzl --format='{{.Names}}'`           docker ps -f label=group=meet

4. 快速进入容器内，没必要把ID全部写上~      `docker exec -it f69 sh`

    有个弊端，就是在查看你创建好的容器信息， 看不到是具体的哪个镜像，不过查还是能查出来

    1. `docker inspect -f '{{.GraphDriver.Data.DeviceName}}' nginx`   查看容器的devicemapper 设备
    2. `docker inspect -f '{{.State.Pid}}' nginx01`                   查看容器的PID

        `docker inspect -f '{{.Name}}' nginx01       '{{.Id}}'`

5. linux别名

    ```bash
    alias dockerrm='docker rm -f -v'
    alias dockerexec='docker exec -it'
    alias dockerrmi='docker rmi'
    dockerexec 16355 bash -c '/bin/ps -ef | grep gitlab'
    ```

6. --restart=always                                                 使容器随着 docker daemon 的启动一同启动
7. `docker ps -s`                                                     查看容器大小
8. 暂停一个或多个容器中的所有进程。挂起所有进程，而不是关闭(stop)当前容器

    `docker ps`

    `docker pause dfd1`                                               对当前容器进行暂停进程

    `docker ps`                                                       查看到，当前容器的STATUS 中添加了 Paused

    `docker unpause dfd1`

## faq

- 启动docker报错

1. 描述：启动docker报错，E: Sub-process /usr/bin/dpkg returned an error code (1)

   systemd[1]: Failed to listen on Docker Socket for the API.

   -- Subject: Unit docker.socket has failed

2. 解决：在 /lib/systemd/system/docker.socket 里将SocketGroup=docker，改成root，

   之后，root用户启动就成功了。

   接着将用户加入到root用户组，或者是加入docker组，

   sudo usermod -aG root lzl

   检查，id lzl

   另外，还可以设置主组，sudo usermod -g root lzl

## contain

- 容器技术

    > 容器技术,关键是两个,"看起来隔离"的技术namespace和"用起来隔离"的技术CGroup
        docker，宿主机好比一间大房子，docker把他成了N个隔断，这些小隔断之间，有独立的卫生间、小床、电视...docker实现这些功能，依赖于 chroot、namespace、cgroup 三种老技术
        docker，的创新之处在于加入了一个中央仓库，并封装了很多易用的命令。

    1. 下面主要是CGroup,（其实应该先看ns方面的）

1. CGroup,全称Control Group,控制什么?控制资源的使用.

    是linux内核提供的一个特性，用于限制和隔离一组进程对系统资源的使用。对不同资源的具体管理由各个子系统分工完成。

2. 定义了下面的一系列子系统,每个子系统用于控制某一类资源
    1. cpu 子系统,限制进程的cpu使用率
    2. cpuacct 子系统,统计cgroups中的进程的cpu使用报告
    3. cpuset 子系统,为cgroup中的进程分配单独的cpu节点或者内存节点
    4. memory 子系统,限制进程的memory使用量
    5. blkio,限制进程的块设备io
    6. devices,控制进程能够访问的设备
    7. net_cls,标记cgroups中进程的网络数据包,然后使用tc模块,对数据包进行控制
    8. freezer,可以挂起或者恢复cgroups中的进程

---

1. cpuset子系统，主要接口如下

    cpuset.cpus：允许进程使用的CPU列表

    cpuset.mems：允许进程使用的内存节点列表

2. cpu子系统，用于限制进程的CPU利用率

    CPU比重分配。cpu.shares接口

    CPU带宽限制。cpu.cfs_period_us，和cpu.cfs_quota_us接口

    实时进程的CPU带宽限制。cpu_rt_perios_us，和cpu_rt_quota_us接口

3. cpuacct子系统，统计各个CGroup 的CPU使用情况

    cpuacct.stat，报告这个CGroup在用户态和内核态消耗的CPU时间，单位是赫兹

    cpuacct.usage，报告该CGroup消耗的总CPU时间

    cpuacct.usage_percpu，报告该CGroup在每个CPU上的消耗时间

4. memory子系统，限制CGroup所能使用的内存上限

    memory.limit_in_bytes，设定内存上限，单位字节

    memory.memsw，limit_in_bytes，设定内存加上交换内存区的总量

    memory.oom_control，如果设置为0，那么内存超过上限时，不会杀死进程，而是阻塞等待进程释放内存；同时系统会向用户态发送事件通知

    memory.stat，报告内存使用信息

5. blkio，限制CGroup对阻塞IO的使用

    blkio.weight，设置权值，范围在[100,1000]，属于比重分配，不是绝对带宽，因此只有当不同CGroup争用同一个阻塞设备时才起作用

    blkio.weight_device，对具体设备设置权值，他会覆盖上面的选项值

    blkio.throttle.read_bps_device，对具体的设备，设置每秒读磁盘的带宽上限

    blkio.throttle.write_bps_device，对具体的设备，设置每秒写磁盘的带宽上限

    blkio.throttle.read_iops_device，对具体的设备，设置每秒读磁盘的IOPS带宽上限

    blkio.throttle.write_iops_device，对具体的设备，设置每秒写磁盘的IOPS带宽上限

6. devices子系统，控制CGroup的进程对哪些设备有访问权限

    devices.list，只读文件，显示目前允许被访问的设备列表，文件格式为：类型[a|b|c] 设备号[major:minor] 权限[r/w/m 的组合]

    devices.allow，只写文件，以上述格式描述允许相应设备的访问列表

    devices.deny，只写文件，以上述格式描述禁止相应设备的访问列表

    1. `mount -t cgroup` 查看文件系统cgroup的挂载目录

        `docker run -d --cpu-shares 513 --cpus 2 --cpuset-cpus 1,3 --memory 1024M --memory-swap 1234M --memory-swappiness 7 -p 8081:80 nginx:latest`

        1. 内存限制，限制每一个内存线程分配多大运存.memory可以使用200， swap可以使用100
            docker run -itd -m 200M --memory-swap=300M --name lzl02mem f23

        2. CPU限制，安装优先级进行限制，数值大，优先级高
            docker run -it --name lzl02cpu -c 1024 --cpus 1 centos:7

        3. 硬盘（Block IO）限制。限制原因：会反复读写硬盘，容易坏
            docker run -it --device-write-bps /dev/sda:30MB --name lzl02bps centos:7 /bin/bash

        线程是最小的资源调度单位，进程是最小的资源分配单位。中断需要将现在用户态的CPU状态保存下来，然后切换到内核态执行，得到结果后又要切换回用户态。所以进程用户态内核态切换开销大。

    2. 具体路径是， /sys/fs/cgroup/， 该目录下存储的就是容器有关cgroup的，配置

        /sys/fs/cgroup/cpuset/docker/9949.../cpuset.cpus，该文件配置的就是cpu绑核的参数

        /sys/fs/cgroup/memory/docker/9949.../memory.limit_in_bytes， 文件配置的就是memory
        ...
        这是cgroup 对于docke资源的控制，在用户态是如何表现的。大佬画了一张图linux_os_cgroup_user

       ![linux_os CGroup 流程](https://gitee.com/liuzel01/picbed/raw/master/data/linux_os_cgroup_user_docker.png)

    3. 接着是，在内核中cgruop 如何实现资源控制

7. namespace，将内核的全局资源做封装，使得每个ns都有一份独立的资源，因此不同的进程在各自的ns内对同一种资源的使用互不干扰。

    相关的三个系统调用：

    1. clone，创建全新的ns，由clone创建的新进程就位于这个新的ns里

    2. unshare，为已有进程创建新的ns

    3. setns，把某个进程放在已有的某个ns里

---

### 命名空间

回到docker上，docker通过Libcontainer来做这。用户只需要使用docker api就可以优雅地创建一个容器，docker exec的底层实现就是上面提过的setns

2. rootfs，代表一个docker容器启动时（非运行后），其内部进程可见的文件系统视角，或者叫docker容器的根目录

    docker文件系统简单理解为：只读的rootfs + 可读写的文件系统

    在容器中修改用户视角下文件时，docker借助COW（copy-on-write）机制节省不必要的内存分配。

2. 举个例子，
    unshare --pid --fork --mount-proc /bin/bash，                       linux中进程PID为1的，叫做system进程。执行命令后，bash成了1号进程，ps -ef 能看到进程信息很少了

    exit 退出

    再开一个终端，pstree，                                               查看进程信息，显示，└─sshd───bash───unshare───bash───sleep，表示的就是这个隔离环境的进行信息。

    1. unshare --mount --fork /bin/bash

        unshare --uts --fork /bin/bash

        unshare --ipc --fork /bin/bash

        unshare --user -r /bin/bash

        unshare --net --fork /bin/bash

3. 有关docker的深入研究，[参考](http://docker-saigon.github.io/post/Docker-Internals/)，

---

1. 在内核态，最重要的四种硬件资源是CPU、内存、存储和网络
2. 对应到数据中心，我们也需要一个调度器，将运维人员从指定物理机或虚拟机的痛苦中解放出来，实现对于物理资源的统一管理，这就是k8s
    要通过文件系统保持持久化的数据并且实现共享，在数据中心里面也需要一个这样的基础设施。

    1. 统一的存储常常有三种形式，
        对象存储
        分布式文件系统
        分布式块存储。云硬盘，也即存储虚拟化的方式

    2. k8s有自己的网络模型。
        1. 至此，k8s作为数据中心的操作系统，内核问题解决了

    3. 接着是用户态的工具问题。
        1. 交互式命令行
        2. nohup长期运行的进程
        3. 系统服务
        4. 周期性进程，CrontabJob

    4. 有了k8s我们就能像管理一台linux服务器那样，去管理数据中心了。

3. 动态扩容docker磁盘容量，
    docker默认安装后磁盘容量是10G，若磁盘容量不够， 会导致集群节点unhealthy
    1. dmsetup table                            查看正在运行的容器卷，记录下要扩展的容器，其中20971520 代表10G磁盘

        ```bash
        # docker-253:2-3222704835-96ecec2cac5594a03ade95580fb11d682f4eadf85adc7081ff2e587f095859de: 0 20971520 thin 253:3 63
        dmsetup table /dev/mapper/docker-253\:2-3222704835-96ecec2cac5594a03ade95580fb11d682f4eadf85adc7081ff2e587f095859de     查看文件扇区信息
        ```

    2. echo $((50*1024*1024*1024/512))          计算要扩充的磁盘大小（20G）， 41943040, 将新的扇区大小写入，

        ```bash
        # dmsetup table docker-253:2-3222704835-96ecec2cac5594a03ade95580fb11d682f4eadf85adc7081ff2e587f095859de 0 20971520 thin 253:3 63
        echo 0 41943040 thin 253:3 63 | dmsetup load /dev/mapper/docker-253\:2-3222704835-96ecec2cac5594a03ade95580fb11d682f4eadf85adc7081ff2e587f095859de
        ```

    3. 现在再次检查表，仍然是相同的，所以新的table 需要激活
        dmsetup resume /dev/mapper/docker-253\:2-3222704835-96ecec2cac5594a03ade95580fb11d682f4eadf85adc7081ff2e587f095859de
        再次检查，就拥有新的扇区数。不过，仍然需要调整文件系统的大小。 注意文件系统是xfs 还是其他的。其他的话，命令就不同了

        ```bash
        # resize2fs /dev/mapper/docker-253:2-3222704835-96ecec2cac5594a03ade95580fb11d682f4eadf85adc7081ff2e587f095859de
        xfs_growfs /dev/mapper/docker-253\:2-3222704835-96ecec2cac5594a03ade95580fb11d682f4eadf85adc7081ff2e587f095859de
        ```

    4. docker inspect gitlab | grep -iC 10 devicename，                 查看容器对应的设备名称（挂载）

        df -hT，                                                        								  查看对应的设备，所挂载的宿主机目录

    5. ../shellInstall/modify_docker_disk.sh, 有个脚本，不过是 resize2fs ，**需要进行完善**

## 入门与实践

- docker history --no-trunc e445                                   查看镜像历史。images由多层组成，该命令列出各层的创建信息

    ```bash
    docker search --filter=is-official=true nginx                   查看官方提供的镜像
        man docker search  可以看到其他的筛选项，                     --filter=starts=4， --filter=is-automated=true
        --filter=stars=3 --limit=5                                  限制输出结果个数为，5个
        添加 --no-trunc                                             不截断输出结果
        --format string                                             格式化输出内容
    docker search --format "table {{.Name}}\t{{.IsAutomated}}\t{{.IsOfficial}}" nginx
    ```

    注册服务器（ registry ）与仓库（ repository ）不同， registry 是存放仓库的具体服务器，一个registry 可有多个仓库，每个仓库下面又可有多个 image 。 所以，仓库可看作一个具体的项目或目录（参照 harbor）。

    **docker search 后面的 nginx， 其实代表 nginx 这个仓库。同理，可以搜索私仓里的某个项目仓库， docker search xxxxxx/env_dev**

- `docker logs --tail=100 -f aada`                                 查看容器输出信息，表示输出最近的若干日志

    `man docker-logs`

- `docker stats d006`                                              查看当前运行中容器的系统资源使用统计
    `docker diff d006`                                              查看容器内的数据修改
    `docker port d006`                                              查看容器的端口映射（无用但是）
    `docker update --cpu-quota 1000000 d006`                        更新容器的一些运行时配置，主要是一些资源限制份额

- 自动构建，automated builds， 自动化服务，可以自动跟随项目代码的变更而重新构建镜像。步骤如下（harbor+jenkins 也可实现）

    1. 创建并登录docker hub，以及目标网站如github
    2. 在目标网站中允许docker hub 访问服务
    3. 在docker hub 中配置一个“自动创建”类型的项目
    4. 选取一个目标网站中的项目（需要含dockerfile） 和分支
    5. 指定dockerfile 的位置，并提交创建

- 数据卷特性，

    1. 数据卷可以在容器之间共享和重用，容器间传递数据变得高效方便
    2. 对数据卷内数据的修改会立马生效，无论是容器内操作还是本地操作
    3. 对数据卷的更新不会影响镜像，解耦应用和数据
    4. 卷会一直存在，直到没有容器使用，可以安全地卸载它

---

1. 创建数据卷容器

    docker run -it -v /dbdata --name dbdata 2c04

    docker inspect 313e | grep -iC 10 mount                         能看到在外面（宿主机）并没有 /dbdata 文件夹，还是存储到docker 那的， /var/lib/docker/volumes/55e1xxx/_data

    docker run -it --volumes-from  dbdata --name lzl01 2c04
    --volumes-from  dbdata  --volumes-from data02                   可以从多个容器挂载多个数据卷，还可以从其他已经挂载了容器卷的容器来挂载

    tips： volumes-from 数据卷来源容器，并不需要保持在运行状态

    1. 利用数据卷容器来迁移数据
    `docker run --volumes-from dbdata -v /home/database/:/backup --name lzl_wkr 2c04 tar cvf /backup/lzlbakup.tar /dbdata`                                                         将数据卷 dbdata 备份到外面的 /home/database/lzlbackup.tar 完了后，容器 lzl_wkr 会处于 Exited 状态
    `docker run -it -v /dbdata --name lzl0101 2c04`                 恢复数据到一个容器内（无用）...
    `docker run -it  --volumes-from lzl0101 -v /home/database:/backup 2c04 tar xvf /backup/lzlbakup.tar`

    另外，有时不希望数据保存在宿主机或容器中，可以使用tmpfs类型的数据卷，其中数据只存在于内存中，容器退出后自动删除

2. 容器间互联，
    1. docker run -d --name db001 xxxx/postgres
    2. docker run -d -P --name web001 --link db:db xxxx/webapp python app.py

        --link 格式为，--link name:alias, 其中，name是要链接的容器名称，alias是别名

    3. 相当于在两个互联的容器间创建了一个虚拟通道，而不用映射它们的端口到宿主主机上，避免了暴露数据库服务端口到外部网络上

---

- 最佳实践

1. 原则
    1. 精简镜像用途
    2. 选用合适的基础镜像
    3. 提供注释和维护者信息
    4. 正确使用版本号
    5. 减少镜像层数
    6. 恰当使用多步骤创建
    7. 使用 .dockerignore 文件
    8. 及时删除临时文件和缓存文件
    9. 提高生成速度
    10. 调整合理的指令顺序
    11. 减少外部源的干扰， 需要指定持久的地址，并带版本信息等，让他人可以复用而不出错

2. docker run -it --name busybox_lzl01 busybox                  busybox， linux系统的瑞士军刀，方便快速熟悉linux命令
    docker run -it --name alpine_lzl01 alpine

3. 就docker 容器是否启用SSH服务,
    看容器用途,如若作为应用容器,容器行为围绕应用生命周期,较为简单,不需要人工的额外干预;而系统容器,则需要支持管理员的登录再进行操作,这时SSH服务就很有必要
    并且,还能作为额外的开发环境来使用~

---

- 远程容器内环境，

    1. docker cp ~/.ssh/authorized_keys l001_www:/root/.ssh/authorized_keys

- 包括web服务在内的中间件领域十分适合引入容器技术:
    1. 中间件服务器, 是除数据库服务器外的主要计算节点,一般需要大批量部署, 而docker对于批量部署有先天优势
    2. 中间件服务器, 结构清晰, 在剥离了配置文件/日志/代码目录之后, 容器几乎可以处于0增长状态,这使得容器的迁移和批量部署更加方便
    3. 中间件服务器, 很容易实现集群,在使用硬件的F5/ 软件的nginx等 负载均衡后, 中间件服务器集群就变得非常容易
    **除此,需要注意数据的持久化. 对于程序代码/资源目录/日志/数据库文件这些, 要实时更新和保存的数据一定要启用数据持久化机制**

---

- 容器化开发模式

    1. 在容器化开发模式中,application 是以容器的形式存在的,所有和该应用有关的依赖都会在容器中, 因此移植变得非常方便. 避免了因为环境不一致而出错的风险.
    2. 操作流程:
        1. 在容器化应用中,项目架构师及开发人员的作用贯穿整个开发/测试/生产三个环节.
        2. 场景示例::

        ![传统模式 vs 容器模式下的工作流程比较](https://gitee.com/liuzel01/picbed/raw/master/data/image-20210304115631723_docker.png)
        

3. 容器与生产环境
   1. 在这里,是指企业运行其商业应用的IT环境, 是性对于开发环境/预发布环境和测试环境而言的
   2. 在云上使用doker
   3. 建议:
      1. 如果docker出现了不可控风险,是否考虑了备选的解决方案
      2. 是否需要对docker容器做资源限制,以及如何限制,如CPU/内存/网络/磁盘等
      3. 是否做了对于数据的备份xxxxxxxx？

## 核心实现技术

1. 基本架构

   1. CS架构，包括客户端、服务端，通过镜像仓库来存储镜像。客户端和服务端可以运行在一个机器上，也可通过socker 或者RESTful API 来通信

      服务端主要包括四个组件

   ![docker基础架构](https://gitee.com/liuzel01/picbed/raw/master/data/image-20210304140321534_docker.png)

   2. dockerd， 为客户端提供RESTful API，相应来自客户端的请求。模块化结构，通过专门的engine模块来分发管理各个客户端的任务。可单独升级

      1. docker-proxy， 是docker的紫禁城。 当需要容器端口映射时，docker-proxy 完成网络映射配置

         用 ss, 就只能看到docker-proxy的进程，看不到具体的进程

      2. containerd， 是docker的子进程。提供gRPC接口，响应来自 dockerd的请求，对下管理runC镜像和容器环境。 可单独升级
      3. containerd-shim， 是containerd的子进程， 为runC 容器提供支持，同时作为容器内进程的根进程

   3. `docker network ls ` 查看当前系统网桥

      `brctl show ` 看到连接到网桥上的虚拟网口的信息， 并将dcker0的 ip地址设置为默认的网关。 容器的网络流量通过宿主机的iptables 进行转发

---

1. UnionFS 联合文件系统。 改变了一个docker 镜像，则会创建一个新的层（layer）， 因此不必替换整个原镜像或者重新建立，只需要添加新层即可。 用户分发镜像时，也只需分发被改动的新层部分（增量部分）。 所以docker 的镜像管理十分轻量和快速

2. 对于IO敏感型应用，一般推荐将容器修改的数据通过volume 方式挂载，而不是直接修改镜像内数据

---

1. docker 的本地网络实现，是利用了linux 上的网络命名空间和虚拟网络设备（特别是 veth pair）

2. 基本概念。

   1. docker 中的网络接口默认都是虚拟接口。 最大优势是转发效率极高。如下

   ![容器网络的基本原理](https://gitee.com/liuzel01/picbed/raw/master/data/image-20210304163949464_docker.png)

   2. 创建过程：创建一对虚拟接口，分别放到本地主机和新容器的命名空间中；

      本地主机一端的虚拟接口连接到默认的docker0网桥或者指定网桥上，并具有一个以 veth 开头的唯一名字；

      容器一端的虚拟接口将放到新创建的容器中去，并修改名字为eth0。 这个接口只在容器的命名空间可见；

      从网桥可用地址段中获取一个空闲地址分配给容器的 ethO（例如172.17.0.2/16），并配置默认路由网关为dockerO 网卡的内部接口dockerO 的IP地址（例如172.17.42.1/16）

      至此， 容器就可使用它所能看到的eth0 虚拟网卡来连接其他容器和访问外部网络

      1. 也可`docker network ` 手动管理网络
      2. **手动配置网络,示例** 



3. 本章(17.6), 知识点有: docker基本架构,runc, 以及实现所以来的操作系统中的命名空间/控制组/联合文件系统/虚拟网络支持等特性
   1. 这和linux 上成熟的已有容器技术支持是分不开的



## 记录

- `docker run -it -v /var/run/docker.sock:/var/run/docker.sock --name docker-l01 docker:19.03`

1. docker images ,sort -n -t ' ' -k 5r,将输出结果按照镜像大小进行排序

   docker images | sort -n -k 10r -t ' '

2. 192.168.10.62，还未拉取镜像，因为上面运行有其他mino 等容器。待确认后，再操作

3. 要创建一个集群，则需要提供一台主机，用作执行命令，用来创建rancher-agent，rancher/rancher-agent:v2.5.3，就下面这个

  `sudo docker run -d --privileged --restart=unless-stopped --net=host -v /etc/kubernetes:/etc/kubernetes -v /var/run:/var/run registry.cn-hangzhou.aliyuncs.com/rancher/rancher-agent:v2.5.3 --server https://192.168.10.62 --token 2bpf9cfsfmdmh2n4pc555lntcrr2jx4ppmwkt5tc9b97zsv5pnmn42 --ca-checksum df3f8a359b9a6daf65468988b37cc689901ebe8637d2039349fcbbdd1c9a968e --etcd --controlplane --worker`

1. 若不执行，你的集群就会提示，Waiting for etcd and controlplane nodes to be registered


















