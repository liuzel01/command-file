FROM httpd:2.4 
LABEL MAINTAINER zelin.liu@xxxx.com
COPY ./public_html_hellodocker /usr/local/apache2/htdocs/ 