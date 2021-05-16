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
if (ls -l /etc/init.d/functions &>/dev/null);then
    . /etc/init.d/functions
#     exit 1
fi
source /etc/profile
#############################################################################################
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


chk_reles_name(){
read -p "当前release_name为 "$RELES_NAME_DEF" ，是否更改（直接输入，否则回车下一步）: " RELES_NAME
[ -z $RELES_NAME ] &&\
    RELES_NAME=${RELES_NAME_DEF}
# && echo "修改后的release_name为: "${RELES_NAME_DEF}
# ||  echo "修改后的release_name为: "${RELES_NAME}
}

chk_reles_name
read -p "确认release_name为： "${RELES_NAME}" （默认 y）? [y/n]: " RELES_CHOIC
case ${RELES_CHOIC} in
    n|N)
        chk_reles_name
    ;;
    *)
#         exit 1
# 这里如果用了exit 会报错
esac
echo ${RELES_NAME}

# 检查RELES_REF，并且一次修改的机会，以下的就同理了
#############################################################################################
chk_reles_ref(){
read -p "当前release_ref为 "$RELES_REF_DEF" ，是否更改（直接输入，否则回车下一步）: " RELES_REF
[ -z $RELES_REF ] &&\
    RELES_REF=${RELES_REF_DEF}
# && echo "修改后的release_name为: "${RELES_REF_DEF}
# ||  echo "修改后的release_name为: "${RELES_REF}
}
chk_reles_ref
echo ${RELES_REF}

#############################################################################################
chk_lk_filepath(){
read -p "当前link_filepath为 "$LK_FILEPATH_DEF" ，是否更改（直接输入，否则回车下一步）: " LK_FILEPATH
[ -z $LK_FILEPATH ] &&\
    LK_FILEPATH=${LK_FILEPATH_DEF}
}
chk_lk_filepath
echo ${LK_FILEPATH}

#############################################################################################
chk_post_url(){
read -p "当前release_ref为 "$POST_URL_DEF" ，是否更改（直接输入，否则回车下一步）: " POST_URL
[ -z $POST_URL ] &&\
    POST_URL=${POST_URL_DEF}
}
chk_post_url
echo ${POST_URL}

read -p "请输入本次发布的tag_name（必填）： " TAG_NAME
read -p "请输入本次发布的reles_description（必填，支持markdown）： " RELES_DESCRIP
read -p "请输入本次发布的link_name（必填）： " LK_NAME
read -p "请输入本次发布的link_url（必填）： " LK_URL


# 此脚本就一个命令，所以也没必要写成函数
echo \
curl --header 'Content-Type: application/json\' --header \"PRIVATE-TOKEN: ${PRIVATE_TOKEN}\" \
    --data \'{ \"name\": \"${RELES_NAME}\", \"tag_name\": \"${TAG_NAME}\", \"ref\":\"${RELES_REF}\",\
    \"description\": \"${RELES_DESCRIP}\", \
    \"assets\": { \"links\": [{ \"name\": \"${LK_NAME}\", \"url\": \"${LK_URL}\", \"filepath\": \"${LK_FILEPATH}\", \"link_type\": \"${LK_TYPE}\"  }] }}\' \
    --request POST \"${POST_URL}\"

