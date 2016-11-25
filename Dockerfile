FROM ubuntu:14.04

RUN apt-get update && \
    apt-get upgrade -y

RUN apt-get update && apt-get -y install build-essential libpcre3 libpcre3-dev libssl-dev libperl-dev wget unzip && \
    wget http://nginx.org/download/nginx-1.7.7.tar.gz && \
    wget https://github.com/arut/nginx-rtmp-module/archive/master.zip && \
    tar -zxvf nginx-1.7.7.tar.gz && \
    unzip master.zip && \
    cd nginx-1.7.7 && \
      ./configure --with-http_ssl_module  --with-http_perl_module  --add-module=../nginx-rtmp-module-master && \
      make && \
      make install

# RUN apt-get -y install gettext

ADD nginx.conf /usr/local/nginx/conf/

EXPOSE 1935

CMD ["/usr/local/nginx/sbin/nginx"]