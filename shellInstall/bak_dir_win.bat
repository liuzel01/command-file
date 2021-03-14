:: 此脚本，用于备份win 上的文件夹
:: pause 用于调试，调试成功后，可以删除pause 一行

@echo off
REM 是否静默运行 如需静默运行删除以下四行前面的REM
REM @echo off
REM if "%1" == "h" goto begin
REM mshta vbscript:createobject("wscript.shell").run("%~nx0 h",0)(window.close)&&exit
REM :begin

set folder_source=D:\03_soft\lzhrsip-hr\data

set folder_to=D:\04_back_file\bakup
echo %folder_name%
"C:\Program Files\7-Zip\7z" a -tzip "%folder_to%\repositories_%Date:/=-%.zip" "%folder_source%"
Pause
