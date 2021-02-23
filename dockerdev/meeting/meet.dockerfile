# Docker image for multi stage build
# VERSION 0.0.1
### 第一阶段，用maven镜像进行编译
FROM maven:3.6.3 AS build_env
LABEL maintainer zelin.liu@sipingsoft.com

#定义工程名称，也是源文件的文件夹名称
ENV PROJECT_NAME meeting
ENV WORK_PATH /usr/src/$PROJECT_NAME
# 实际上，这里可以用git从仓库拉取代码，然后写入脚本，没必要手动将项目代码拉取，到本地
# 上面配料（环境）准备好了， 开始吧
ADD ./$PROJECT_NAME  $WORK_PATH
# repository 此文件是从研发的本地拷贝过来的。。因为体积过大，我这里就不上传了
RUN rm -rf /root/.m2/repository
ADD ./repository /root/.m2/repository
ADD ./settings.xml /usr/share/maven/conf/settings.xml
# 实际上，如若是在外网，则访问不到settings.xml，因为配置的是内网地址
RUN cd $WORK_PATH &&\
    mvn clean package -P prod &&\
    sed  -i "s/D:\/meeting\/logs/.\/logs/" ./target/thin/root/config/application.yml &&\
    sed  -i "s/127.0.0.1:3306\/meeting_standard/192.168.10.68:3306\/meeting_standard/" ./target/thin/root/config/application-prod.yml &&\
    sed  -i "s/password: sipingsoft/password: SipingSoft2016/" ./target/thin/root/config/application-prod.yml

### stage 2，用第一阶打包好的jar包，和jre环境合成一个小体积的镜像
FROM java:8-jre-alpine
#定义工程名称，也是源文件的文件夹名称
ENV PROJECT_NAME meeting
ENV PROJECT_VERSION 0.0.1-SNAPSHOT
ENV WORK_PATH /usr/src/$PROJECT_NAME

#安全起见不用root账号，新建用户admin
RUN adduser -Dh /home/admin admin

WORKDIR /app
COPY --from=build_env $WORK_PATH/target/thin/root .
RUN mkdir static &&\
    unzip -d ./static ./static.zip
COPY ./startup.sh ./startup.sh
CMD ./startup.sh