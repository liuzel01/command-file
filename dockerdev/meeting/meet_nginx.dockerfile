# Docker image for multi stage build
# VERSION 0.0.1
### 第一阶段，用maven镜像进行编译
FROM maven:3.6.3 AS build_env

####################定义环境变量 start####################
#定义工程名称，也是源文件的文件夹名称
ENV PROJECT_NAME meeting
#定义工作目录
ENV WORK_PATH /usr/src/$PROJECT_NAME
ADD ./$PROJECT_NAME  $WORK_PATH

RUN rm -rf /root/.m2/repository
ADD ./repository /root/.m2/repository
ADD ./settings.xml /usr/share/maven/conf/settings.xml
#编译构建
RUN cd $WORK_PATH &&\
    mvn clean package -P prod     
# 第二阶段，用nginx
FROM nginx:stable-alpine
#定义工程名称，也是源文件的文件夹名称
ENV PROJECT_NAME meeting
ENV PROJECT_VERSION 0.0.1-SNAPSHOT
ENV WORK_PATH /usr/src/$PROJECT_NAME

WORKDIR /nginx
COPY --from=build_env $WORK_PATH/target/thin/root/static.zip .
COPY ./nginx.conf /etc/nginx/nginx.conf 
RUN mkdir static &&\
    unzip -d ./static ./static.zip &&\
    chmod 777 -R ./static

CMD ["/usr/sbin/nginx","-g","daemon off;"]
