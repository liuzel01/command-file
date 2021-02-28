#!/bin/bash
# 源码安装jdk
# 参考官方 , for redhat, ubuntu的没拷过来
# TODOList:
# 1. 判断一下，如果存在相关的软件包，则不必执行， install_redhat

# KKFILEVIEW_DIR=/opt/openoffice

DIR_HOME=("/opt/openoffice.org3" "/opt/libreoffice" "/opt/openoffice4" "/usr/lib/openoffice" "/usr/lib/libreoffice")
FLAG=
OFFICE_HOME=/opt/openoffice
KKFILE_VER=kkFileView-2.2.1
KKFILEVIEW_BIN_FOLDER=/opt/openoffice/$KKFILE_VER/bin

install_redhat() {
    mkdir -p $OFFICE_HOME
    cd $OFFICE_HOME
    echo '正在下载wget... ' ;yum install -y wget &>/dev/null
    echo '正在下载'$KKFILE_VER'.tar.gz' ;wget https://kkfileview.keking.cn/$KKFILE_VER.tar.gz &&\
      echo '正在下载Apache_OpenOffice' ;wget https://kkfileview.keking.cn/Apache_OpenOffice_4.1.6_Linux_x86-64_install-rpm_zh-CN.tar.gz -cO openoffice_rpm.tar.gz &>/dev/null &&\
      tar -zxf $KKFILE_VER.tar.gz &&\
      tar zxf openoffice_rpm.tar.gz &&\
      cd ./zh-CN/RPMS
if [ $? -eq 0 ];then
  echo 'install desktop service ...'
  yum install -y libXext.x86_64 &>/dev/null
  yum groupinstall -y  "X Window System" &>/dev/null
  rpm -Uvih *.rpm &>/dev/null
  echo 'install desktop service ...'
  rpm -Uvih desktop-integration/openoffice4.1.6-redhat-menus-4.1.6-9790.noarch.rpm &>/dev/null
  echo 'install finshed...'
else
  echo 'download package error...'
fi
}
# 哦，没太多， 可以不写成函数
install_redhat

# 下面是改配置文件， 和启动脚本相关的
cd $KKFILEVIEW_BIN_FOLDER
echo "Using KKFILEVIEW_BIN_FOLDER $KKFILEVIEW_BIN_FOLDER"
grep 'office\.home' $OFFICE_HOME/$KKFILE_VER/config/application.properties | grep '!^#'

if [ $? -eq 0 ]; then
  echo "Using customized office.home"
else
 for i in ${DIR_HOME[@]}
  do
    if [ -f $i"/program/soffice.bin" ]; then
      FLAG=true
      OFFICE_HOME=${i}
      break
    fi
  done
fi
echo "Starting kkFileView..."
echo "Please execute ./showlog.sh to check log for more information"
# echo "You can get help in our official homesite: https://kkFileView.keking.cn"
# echo "If this project is helpful to you, please star it on https://gitee.com/kekingcn/file-online-preview/stargazers"
echo 'startup启动脚本路径： '$KKFILEVIEW_BIN_FOLDER 
nohup java -Dfile.encoding=UTF-8 -Dsun.java2d.cmm=sun.java2d.cmm.kcms.KcmsServiceProvider -Dspring.config.location=../config/application.properties -jar $KKFILE_VER.jar > ../log/kkFileView.log 2>&1 &