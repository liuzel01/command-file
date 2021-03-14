:: 此脚本，用于启动meeting 项目。
:: 生产环境，可自行删除REM， 达到后台运行效果（不显示终端）
:: pause 用于调试，在出错时会暂停终端。调试成功后，可以删除pause 一行
title meeting

REM 是否静默运行 如需静默运行删除一下四行前面的REM
REM @echo off
REM if "%1" == "h" goto begin
REM mshta vbscript:createobject("wscript.shell").run("%~nx0 h",0)(window.close)&&exit
REM :begin

java "-Dthin.root=." "-Dthin.offline=true" -jar meeting-standard.jar
pause