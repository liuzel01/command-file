REM D:
REM cd D:\tool\nacos\bin
REM start /b startup.cmd
REM ping -n 10 127.0.0.1>nul

D:
cd D:\smartone\minio
start cmd /c ".\minio.exe server D:\smartone\minio\data >nohup.log"

cd D:\smartone
ping -n 10 127.0.0.1>nul

start cmd /c "title register && java -Xms512m -Xmx1024m -jar sone-register.jar >nohup-register.log"

start cmd /c "title gateway && java -jar sone-gateway.jar>nohup-gateway.log"

start cmd /c "title auth && java -jar sone-auth.jar >nohup-auth.log"

start cmd /c "title admin && java -jar sone-upms-admin.jar >nohup-admin.log"
