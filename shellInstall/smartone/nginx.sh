#!/bin/bash
# Function:  auto install the nginx-1.8.1
# TODOList:
# 1. 判断之前，有无安装 nginx， 版本是否一致，并备份后， 卸载
# 2. 

Ngx_bag="nginx-1.8.1"
Ngx_src="${Ngx_bag}.tar.gz"
Ngx_dir=/usr/local/nginx_18

[[ $EUID -ne 0 ]] && echo -e "\033[31mError: This script must be run as root!\033[0m" && exit 1

mkdir -p $Ngx_dir
# 安装nginx依赖软件
install_depend_package() {
        yum  install gcc-c++ zlib-devel pcre-devel automake -y
}

# 创建nginx源码包存放目录
create_source_storage_directory() {
        if [ ! -d /usr/src/nginx ];then
                mkdir -p /usr/src/nginx
        fi
}

# # 下载nginx 源码包
# download_nginx_package() {
#         if [ ! -f ${Ngx_src} ];then
#                 wget -c http://nginx.org/download/${Ngx_src}
# $         fi
# }

# 编译安装nginx
# 这里, 对软件包是否存在判断不很准确
compile_install_nginx() {
        [ ! -f /tmp/${Ngx_src} ] && echo -e "\033[31m Nginx package is downloading from \033[0m" &&\
                wget http://meeting.sipingsoft.com/smart/$Ngx_src -P /tmp &&\
                tar -xzf /tmp/${Ngx_src} -C /usr/src/nginx/ &&\
                cd /usr/src/nginx/${Ngx_bag} &&\
                ./configure --prefix=${Ngx_dir} --with-http_gzip_static_module &&\
                make && make install || echo '已存在 '${Ngx_src}

}

# centos7版本时，加入系统服务管理
join_system_services_os7() {
        if [ -f ${Ngx_dir}/sbin/nginx ];then
echo "[Unit]
After=network-online.target remote-fs.target nss-lookup.target

[Service]
Type=forking
PIDFile=${Ngx_dir}/logs/nginx.pid
ExecStart=${Ngx_dir}/sbin/nginx -c ${Ngx_dir}/conf/nginx.conf
ExecReload=/bin/kill -s HUP \$MAINPID
ExecStop=/bin/kill -s TERM \$MAINPID

[Install]
WantedBy=multi-user.target
" > /usr/lib/systemd/system/nginx.service
        else
                echo -e "\033[31m Nginx is not install\033[0m"
        fi
}

install_depend_package
create_source_storage_directory
compile_install_nginx
join_system_services_os7			&&\
# 设置开机自启
        systemctl enable nginx &>/dev/null	&&\
        echo '已设置为开机自启'			&&\
        systemctl start nginx			&&\
        ps -ef | grep nginx

# 安装指引， 并调用前面的函数
# echo -e "\033[33m =============================\033[0m"
# echo -e "\033[36m 1)Install Nginx\033[0m"
# echo -e "\033[36m 2)Join system services of OS6\033[0m"
# echo -e "\033[36m 3)Join system services of OS7\033[0m"
# echo -e "\033[36m 0)Exit\033[0m"
# read -p "Please Input Number: " Num
# case $Num in
# 
#                 echo -e "\033[33m Nginx is already installed\033[0m"
#         else
#                 install_depend_package
#                 create_source_storage_directory
#                 download_nginx_package
#                 compile_install_nginx
#         fi
#         ;;
#         2)
#         join_system_services_os6
#         ;;
#         3)
#         join_system_services_os7
#         ;;
#         0)
#         exit
#         ;;
#         *)
#         echo -e "\033[31mInput error,Please re-enter\033[0m"
#         ;;
# esac

# # centos6版本时，加入系统服务管理
# function join_system_services_os6 {
#         if [ -f ${Ngx_dir}/sbin/nginx ];then
# echo "#!/bin/bash
# # chkconfig: 2345 61 62
# # description: nginx.service
# function start_nginx {
#         if [ ! -s ${Ngx_dir}/logs/nginx.pid ];then
#                 ${Ngx_dir}/sbin/nginx
#         else
#                 echo -e \"\033[33mNginx is already running\033[0m\"
#         fi
# }
# function stop_nginx {
#         if [ -s  ${Ngx_dir}/logs/nginx.pid ];then
#                 kill \$(cat ${Ngx_dir}/logs/nginx.pid)
#                 sleep 1
#         else
#                 echo -e \"\033[33mNginx is no running\033[0m\"
#                 return 1
#         fi
# }
# function restart_nginx {
#         stop_nginx
#         if [ \$? -ne 1 ];then
#                 sleep 1
#                 start_nginx
#         fi
# }
# case  \$1 in
#         start)
#         start_nginx
#         ;;
#         stop)
#         stop_nginx
#         ;;
#         restart)
#         restart_nginx
#         ;;
#         *)
#         echo -e \"\033[33mUsage: start | restart | stop \033[0m\"
#         ;;
# esac 
# " > /etc/init.d/nginx
#                 chmod +x /etc/init.d/nginx
#         else
#                 echo -e "\033[31m Nginx is not install\033[0m"                          
#         fi
# }
