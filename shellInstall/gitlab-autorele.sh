#!/usr/bin/env bash  

GITLAB_URL="192.168.10.27:8000"

echo -n "0.请输入Gitlab Access Token:"
read token  
echo -n "1.请输入项目的id:"
read id  
echo -n "2.请输入项目release的名称:"  
read name  
echo -n "3.请输入即将创建release版本的tag:"  
read tag_name  
echo -n "4.请输入release的描述:"  
read description  
echo -n "5.请输入release二进制文件名称:"  
read release_file_name  
echo -n "6.请输入release二进制文件发布路径:"  
read release_path  

#创建发布版本  
curl --header 'Content-Type: application/json' --header "PRIVATE-TOKEN: $token" --data '{ "name": "'$name'", "tag_name": "'$tag_name'", "ref":"'$tag_name'" ,"description": "'$description'" }' --request POST http://$GITLAB_URL/api/v4/projects/$id/releases

#创建二进制文件链接
curl --request POST  --header "PRIVATE-TOKEN: $token"  --data name="$release_file_name"   --data url="$release_path"  "http://$GITLAB_URL/api/v4/projects/$id/releases/$tag_name/assets/links"
