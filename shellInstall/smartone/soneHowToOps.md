## 部署环境

- jdk-8u221

1. 脚本安装
2. scp root@192.168.10.27:/home/lzl/command-file/shellInstall/smartone/jdkInstall.sh .

2. 执行`yum install -y glibc.i686`
3. yum install libgcc.i686 --setopt=protected_multilib=false

- nginx

1. 脚本安装

scp root@192.168.10.27:/home/lzl/command-file/shellInstall/smartone/nginx.sh .

2. 配置开机自启

- redis

1. 脚本安装

scp root@192.168.10.27:/home/lzl/command-file/shellInstall/smartone/redis.sh .

2. 修改 redis.conf  密码

3. 配置开机自启

- kkfile

1. 脚本安装
2. scp root@192.168.10.27:/home/lzl/command-file/shellInstall/smartone/kkfile.sh .

- minio

1. scp root@192.168.10.27:/home/lzl/command-file/shellInstall/smartone/minio.sh .
2. 检查，/etc/profile 变量对否

- mysql

1. 脚本安装
2. scp root@192.168.10.27:/home/lzl/command-file/shellInstall/smartone/mariadbInstall.sh  .
3. 修改root密码，授予远程连接权限，

```sql
update user set password=password('crrc123.com') where user= root='root' and host='localhost' ;
grant all privileges on *.* to root@"%" identified by "crrc123.com";
```

3. 创建数据库

```sql
create database smartone_common CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;
create database smartone_license CHARACTER SET utf8 COLLATE utf8_general_ci;
create database smartone_nacos CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;
create database smartone_monitor CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
create database smartone_monitor CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
```

1. 配置开机自启

```txt
systemctl enable nginx
scp root@192.168.10.27:/home/lzl/command-file/shellInstall/smartone/etc_init.d/nginx .
scp root@192.168.10.27:/home/lzl/command-file/shellInstall/smartone/etc_init.d/redis .
scp root@192.168.10.27:/home/lzl/command-file/shellInstall/smartone/etc_init.d/minio  .
```



### 开机自启动

- 在上一步很可能做了，但是没全。本步骤，做自启并检查

### 配置各环境密码/配置文件

检查各环境的密码，变量，

将配置信息，记录到部署文档

### 修改hosts

举个栗子

```txt
10.0.3.217 sone-redis
10.0.3.217 sone-mysql
10.0.3.218 sone-register
10.0.3.218 sone-gateway
10.0.3.217 sone-minio
10.0.3.217 sone-kkFileView
```

2. **环境搞完了，接下来就是重要的数据导入**

## 导入数据

sql文件从要求的数据库导出

navicat 导入sql文件

### 修改数据

smartone_common.sys_busi_app， 将url 的地址更改为部署的nginx访问地址

## 访问并验证

### 访问nacos

浏览器访问url 能否登录上，修改配置

确保服务启动正常

### 启动jar

cd /etc/init.d/

scp root@192.168.10.27:/home/lzl/command-file/shellInstall/smartone/etc_init.d/startall .

启动startall 脚本

### 访问sone

# FAQ



中车-测试环境，license好了

  操作：连接进redis，执行：

  license文件的目录结构如下：   /home/sone/license/license.key   此文件应是开发给

​    且，与jar项目包同级（和sone-auth jar包同一服务器）

  auth crrc123.com

  hset license "ipDPBdBfMPItM3ryw2uYLs91G0aVq5eo5HFpk16kFDznJc3i8N" "{\"initialTime\":1601534400000,\"expireTime\":null,\"ip\":\"127.0.0.1\",\"userNumber\":1000,\"productVersion\":\"portal/3.0,license/3.0,fi_cc_v2/3.0,crm_mobile/3.0,fi_ap/3.0,fi_ajs/3.0,fi_gl/3.0,fi_ar/3.0,crm/3.0,ps/3.0,fi_co/3.0,hr/3.0,fi_as/3.0,plm/3.0,erp/3.0,sys_mgt/3.0,adv_config/3.0\",\"isLocked\":0}"

  测试一下，hget license "ipDPBdBfMPItM3ryw2uYLs91G0aVq5eo5HFpk16kFDznJc3i8N"

  之后，重启， sh restart_auth.sh restart 



1. 在导入数据库步骤中， 会出现导入smartone_common.sql 报错，据说是用navicat15 导出来的原因。下次， 可用命令行导入试试

  `audit_date` date GENERATED ALWAYS AS (cast(`audit_time` as date)) STORED COMMENT '审核日期' NULL, 将最后的NULL 删除掉，再次导入就可了~



1. 在导入时，也会出现报错， 需要设置一下 参数log_bin_trust_function_creators

  show variables like 'log_bin_trust_function%';

  set global log_bin_trust_function_creators=1;

  flush privileges;

  在 my.cnf 文件中，[mysqld] 部分添加一行， log_bin_trust_function_creators=1

  最后， systemctl restart mariadb, 检查下，

  show variables like 'log_bin_trust_function%';



2. 在登录页面，会出现验证码刷不出来 这种情况。 因为缺省的是装libgcc这个包。但java一般还是会用32 位的包，所以安装个32位即可。加上false ，因为多个库不能共存，可以安装时加上后面一句~

  yum install libgcc.i686 --setopt=protected_multilib=false

3. 首先确保 nacos启动成功， 包名： sone-register.jar

5. 要更改数据库内容，否则点击模块会跳转到test 测试环境去

  update smartone_common.sys_busi_app set baack_host_url='http://192.168.4.248' where back_host_url='https://test.sipingsoft.com'

minio:9000， 开机自启，

  AccessKey: minioadmin

  SecretKey: luhgft125td4s

  export MINIO_ACCESS_KEY=minioadmin

  export MINIO_SECRET_KEY=luhgft125td4s

redis，开机自启

  设置密码，

  redis-cli -h 192.168.0.133 -p 6379

  config get requirepass

  config set requirepass "vxqas168lta3p"         设置密码

  退出后，重新  redis-cli -h 192.168.0.133 -p 6379 -a vxqas168lta3p

​    验证， auth vxqas168lta3p

​    config get requirepass

重启后失效，所以要写到配置去， redis.conf, 添加一行requirepass vxqas168lta3p