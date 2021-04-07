#!/bin/bash
dir=$(find /home/sone -maxdepth 1 -name "*.sh")
for i in $dir
do
        cd /home/sone
        nohup sh $i start &>/dev/null
done
[ $? -eq 0 ] && echo 'SUCCEED!!'
