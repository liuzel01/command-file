#! /bin/sh

# java "-Dthin.root=." "-Dthin.offline=true" -jar meeting-standard.jar > nohup-meeting.log  2>&1
java "-Dthin.root=." "-Dthin.offline=true" -jar meeting-standard.jar 2>&1
tail -f nohup-meeting.log
