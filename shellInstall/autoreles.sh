#!/bin/bash

#############################################################################################
# UPDATE:	at 2021-04-27
# NOTE:		make sure ,
# AUTHOR:	liuzelin01@outlook.com
#############################################################################################
# 您可以在用户界面中或使用Releases API来执行此操作. 我们建议使用 API添加release，作为CI/CD 流程中的最后步骤之一
#   有了它,直接通过终端创建，更新，修改和删除发行版

# 导入系统变量
#############################################################################################
# set -e 
if ls -l /etc/init.d/functions ;then
    . /etc/init.d/functions
    exit 1
fi
source /etc/profile
# 基本不变
PRIVATE_TOKEN="d-swU128VWosJySssz7u"
LK_TYPE="other"
# 需要用户确认的，可修改
RELES_NAME_DEF="autoreles_温江区"
RELES_REF_DEF="meeting_standard_v3.1"
LK_FILEPATH_DEF="/binaries/meeting_app_stable"
POST_URL_DEF="http://192.168.10.27/api/v4/projects/5/releases"
# 每次必须要修改的
TAG_NAME=""
RELES_DESCRIP=""
LK_NAME=""
LK_URL=""


CHK_RELES_NAME(){
read -p "当前release_name为 "$RELES_NAME_DEF" ，是否更改（直接输入，否则回车下一步）: " RELES_NAME
[ -z $RELES_NAME ] &&\
    RELES_NAME=${RELES_NAME_DEF}
# && echo "修改后的release_name为: "${RELES_NAME_DEF}
# ||  echo "修改后的release_name为: "${RELES_NAME}
}

CHK_RELES_NAME
read -p "确认release_name为： "${RELES_NAME}" （默认 y）? [y/n]: " RELES_CHOIC
case ${RELES_CHOIC} in
    n|N)
        CHK_RELES_NAME
    ;;
    *)
#         echo ${RELES_NAME}
#         exit 1
# 这里如果用了exit 会报错
esac
echo ${RELES_NAME}

CHK_RELES_REF(){
read -p "当前release_ref为 "$RELES_REF_DEF" ，是否更改（直接输入，否则回车下一步）: " RELES_REF
[ -z $RELES_REF ] &&\
    RELES_REF=${RELES_REF_DEF}
# && echo "修改后的release_name为: "${RELES_REF_DEF}
# ||  echo "修改后的release_name为: "${RELES_REF}
}
CHK_RELES_REF
echo ${RELES_REF}

# 以下的同理
# read -p ": " RELES_REF
# read -p ": " LK_FILEPATH
# read -p ": " POST_URL
# 
# read -p "" TAG_NAME
# read -p "" RELES_DESCRIP
# read -p "" LK_NAME
# read -p "" LK_URL


# 此脚本就一个命令，所以也没必要写成函数
# curl --header 'Content-Type: application/json' --header "PRIVATE-TOKEN: ${PRIVATE_TOKEN}" \
#     --data '{ "name": "${RELES_NAME}", "tag_name": "${TAG_NAME}", "ref":"RELES_REF",\
#     "description": "${RELES_DESCRIP}", \
#     "assets": { "links": [{ "name": "${LK_NAME}", "url": "${LK_URL}", "filepath": "${LK_FILEPATH}", "link_type":"${LK_TYPE}"  }] }}'\
#     --request POST "${POST_URL}"

