FROM ubuntu:14.04

ENV VER_NGINX_DEVEL_KIT=0.3.0
ENV VER_LUA_NGINX_MODULE=0.9.16

ENV NGINX_DEVEL_KIT ngx_devel_kit-${VER_NGINX_DEVEL_KIT}
ENV LUA_NGINX_MODULE lua-nginx-module-${VER_LUA_NGINX_MODULE}

ENV VER_NGINX=1.7.7
ENV VER_LUAJIT=2.0.4

ENV LUAJIT_LIB /usr/local/lib
ENV LUAJIT_INC /usr/local/include/luajit-2.0

RUN apt-get update && \
    apt-get upgrade -y -qq

RUN apt-get update && apt-get -y -qq install build-essential libpcre3 libpcre3-dev zlib1g-dev libssl-dev wget unzip gcc make 
RUN wget http://nginx.org/download/nginx-${VER_NGINX}.tar.gz && \
    wget https://github.com/arut/nginx-rtmp-module/archive/master.zip && \
    wget http://luajit.org/download/LuaJIT-${VER_LUAJIT}.tar.gz && \
    wget https://github.com/simpl/ngx_devel_kit/archive/v${VER_NGINX_DEVEL_KIT}.tar.gz -O ${NGINX_DEVEL_KIT}.tar.gz &&\
    wget https://github.com/openresty/lua-nginx-module/archive/v${VER_LUA_NGINX_MODULE}.tar.gz -O ${LUA_NGINX_MODULE}.tar.gz

# Untar
RUN tar -xzvf nginx-${VER_NGINX}.tar.gz &&\
	tar -xzvf LuaJIT-${VER_LUAJIT}.tar.gz  &&\
	tar -xzvf ${NGINX_DEVEL_KIT}.tar.gz  &&\
	tar -xzvf ${LUA_NGINX_MODULE}.tar.gz  &&\
    unzip master.zip


RUN rm *.tar.gz && rm *.zip

# LuaJIT
WORKDIR /LuaJIT-${VER_LUAJIT}
RUN make && \
	make install

WORKDIR /nginx-${VER_NGINX}

RUN ./configure  \
		--with-ld-opt="-Wl,-rpath,${LUAJIT_LIB}" \
		--with-http_ssl_module \
		--add-module=../${NGINX_DEVEL_KIT} \
		--add-module=../${LUA_NGINX_MODULE}  \
		--add-module=../nginx-rtmp-module-master

RUN make -j2  &&\
	make install &&\
	ln -s ${NGINX_ROOT}/sbin/nginx /usr/local/sbin/nginx

RUN rm -rf /nginx-${VER_NGINX} && \
	rm -rf /LuaJIT-${VER_LUAJIT} && \
	rm -rf /${NGINX_DEVEL_KIT} && \
	rm -rf /${LUA_NGINX_MODULE}

EXPOSE 1935
EXPOSE 80

WORKDIR /

COPY nginx.conf /usr/local/nginx/conf/
COPY init.sh /init.sh

RUN chmod +x /init.sh

CMD ["/bin/bash","init.sh"]
