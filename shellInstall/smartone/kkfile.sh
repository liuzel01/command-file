#!/bin/bash
# 源码安装jdk
# 参考官方 , for redhat, ubuntu的没拷过来
# TODOList:

KKFILEVIEW_DIR=/opt/kkFileView

DIR_HOME=("/opt/openoffice.org3" "/opt/libreoffice" "/opt/openoffice4" "/usr/lib/openoffice" "/usr/lib/libreoffice")
FLAG=
OFFICE_HOME=
KKFILEVIEW_BIN_FOLDER=$(cd "$(dirname "$0")";pwd)

install_redhat() {
    mkdir -p /opt/kkFileView
    cd $KKFILEVIEW_DIR
    wget https://kkfileview.keking.cn/kkFileView-2.2.1.tar.gz
    yum install -y wget
    wget https://kkfileview.keking.cn/Apache_OpenOffice_4.1.6_Linux_x86-64_install-rpm_zh-CN.tar.gz -cO openoffice_rpm.tar.gz && tar zxf /tmp/openoffice_rpm.tar.gz && cd /tmp/zh-CN/RPMS
   if [ $? -eq 0 ];then
     yum install -y libXext.x86_64
     yum groupinstall -y  "X Window System"
     rpm -Uvih *.rpm
     echo 'install desktop service ...'
     rpm -Uvih desktop-integration/openoffice4.1.6-redhat-menus-4.1.6-9790.noarch.rpm
     echo 'install finshed...'
   else
     echo 'download package error...'
   fi
}

# 哦，没太多函数，下面这行可不要
install_redhat

export KKFILEVIEW_BIN_FOLDER=$KKFILEVIEW_BIN_FOLDER
cd $KKFILEVIEW_BIN_FOLDER
echo "Using KKFILEVIEW_BIN_FOLDER $KKFILEVIEW_BIN_FOLDER"
grep 'office\.home' $KKFILEVIEW_DIR/config/application.properties | grep '!^#'
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
  if [ ! -n "${FLAG}" ]; then
    echo "Installing OpenOffice"
    sh ./install.sh
  else
    echo "Detected office component has been installed in $OFFICE_HOME"
  fi
fi
echo "Starting kkFileView..."
echo "Please execute ./showlog.sh to check log for more information"
echo "You can get help in our official homesite: https://kkFileView.keking.cn"
echo "If this project is helpful to you, please star it on https://gitee.com/kekingcn/file-online-preview/stargazers"
nohup java -Dfile.encoding=UTF-8 -Dsun.java2d.cmm=sun.java2d.cmm.kcms.KcmsServiceProvider -Dspring.config.location=../config/application.properties -jar kkFileView-2.2.1.jar > ../log/kkFileView.log 2>&1 &