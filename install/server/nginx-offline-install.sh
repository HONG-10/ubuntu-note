#!/bin/bash

# Nginx official site : https://nginx.org/en/download.html
# Install Method : C Compile

##########################################################################################################################################
# 0. ​선행조건 | Nginx 의존 패키지 설치 & Nginx 기동 전용 계정 생성
##########################################################################################################################################

# APT 필수 패키지 Update
echo -e "\n[ INFO ]  apt-get update\n" && \
sudo apt-get update -y

# APT 필수 패키지 Install
echo -e "\n[ INFO ]  Nginx 의존 패키지 Install\n" && \
DEBIAN_FRONTEND=noninteractive \
sudo apt-get install -y --no-install-recommends \
    build-essential libpcre3 libpcre3-dev \
    zlib1g zlib1g-dev libssl-dev libgd-dev \
    libxml2 libxml2-dev uuid-dev libgeoip-dev libxslt-dev

# APT 필수 패키지 Upgrade
echo -e "\n[ INFO ]  apt-get upgrade\n" && \
sudo apt-get upgrade -y

### APT 불필요한 패키지 Clean
sudo apt-get clean -y && \
sudo rm -rf /var/lib/apt/lists/*

# ------------------------------------------------------------------------------------------------------------------

NGINX_USER='nginx'
NGINX_USER_PASSWORD='nginx1234@'

#! /usr/sbin/nologin 에 저장하여 Shell 접근을 막고, nginx 기동 시에만 사용.
sudo useradd -s /usr/sbin/nologin "${NGINX_USER}"
echo -e "${NGINX_USER_PASSWORD}\n${NGINX_USER_PASSWORD}\n" | sudo passwd "${NGINX_USER}"

##########################################################################################################################################
# 1. 인터넷 가능한 Linux 서버 ( 예 : WSL2 ) 에서 Nginx 다운로드
##########################################################################################################################################

# Nginx 다운로드 경로 | File : nginx-1.22.1.tar.gz | 2023-02-18
NGINX_DOWNLOAD_URL=https://nginx.org/download/nginx-1.22.1.tar.gz

# 다운로드시 사용할 임시 작업 디렉토리 생성
WORK_DIR=~/tmp
[ -d "${WORK_DIR}" ] || mkdir -p "${WORK_DIR}"

# Nginx 다운로드
curl -G -k \
  -o "${WORK_DIR}"/nginx-1.22.1.tar.gz \
  -L "${NGINX_DOWNLOAD_URL}"

##########################################################################################################################################
# 2. Nginx 설치할 서버에 접속 후 위에서 다운로드 받은 파일들을 서버 내 작업 디렉토리에 직접 업로드한다.
##########################################################################################################################################

# 설치파일 업로드 / offline 설치시 사용할 임시 작업 디렉토리 생성
WORK_DIR=~/tmp
[ -d "${WORK_DIR}" ] || mkdir -p "${WORK_DIR}"

# 임시 작업 디렉토리에 tar.gz 파일들을 업로드한다.

##########################################################################################################################################
# 3. 임시 작업 디렉토리에 업로드된 파일 기반으로 offline 설치
##########################################################################################################################################

# Nginx 압축 해제
NGINX_INSTALL_PATH=/etc/nginx/install
[ -d "${NGINX_INSTALL_PATH}" ] || sudo mkdir -p "${NGINX_INSTALL_PATH}"

sudo tar -zxf "${WORK_DIR}"/nginx-1.22.1.tar.gz \
  -C "${NGINX_INSTALL_PATH}" \
  --strip-components=1

sudo chown -R root:root "${NGINX_INSTALL_PATH}"

# ------------------------------------------------------------------------------------------------------------------

NGINX_INSTALL_PATH=/etc/nginx/install
NGINX_PATH=/etc/nginx
cd "${NGINX_INSTALL_PATH}"

# 설치파일(Makefile) 생성
echo -e "\n[ INFO ]  Create Makefile\n" && \
sudo "${NGINX_INSTALL_PATH}"/configure --user=nginx --group=nginx \
  --sbin-path=/usr/sbin/nginx --lock-path=/var/lock/nginx.lock \
  --conf-path=/etc/nginx/nginx.conf --modules-path=/etc/nginx/modules \
  --http-log-path=/var/log/nginx/access.log --error-log-path=/var/log/nginx/error.log \
  --pid-path=path --with-pcre --with-debug \
  --with-http_geoip_module=dynamic --with-http_image_filter_module=dynamic \
  --with-http_xslt_module=dynamic  --with-mail=dynamic --with-stream=dynamic \
  --prefix="${NGINX_PATH}"

# 설치파일(Makefile) 컴파일
echo -e "\n[ INFO ]  Compile\n" && \
sudo make -j 16 \
  -C "${NGINX_INSTALL_PATH}"

# 컴파일된 설치파일(Makefile)로 Nginx 설치
echo -e "\n[ INFO ]  Install\n" && \
sudo make install \
  -C "${NGINX_INSTALL_PATH}"

# ------------------------------------------------------------------------------------------------------------------

#  --with-http_ssl_module
#  --with-http_addition_module
#  --with-http_v2_module
#  --with-http_mp4_module

# Path
#* Executable File | /usr/sbin/nginx
#? Module | usr/lib/nginx/modules(현재)  -->  /etc/nginx/modules
#? Module Conf | /usr/share/nginx/modules-available --> /etc/nginx/modules-available

# Module List (Dynamic)
#* ngx_http_geoip_module.so
#* ngx_http_image_filter_module.so
#* ngx_http_xslt_filter_module.so
#* ngx_mail_module.so
#* ngx_stream_module.so

# Module Conf
# mod-http-geoip.conf
# mod-http-image-filter.conf
# mod-http-xslt-filter.conf
# mod-mail.conf
# mod-stream.conf

./configure 
--with-zlib=../zlib-1.2.8 
--with-pcre=../pcre-8.32 
--with-openssl=../openssl-1.0.1e 
--add-module=../echo-nginx-module-0.45 

# ------------------------------------------------------------------------------------------------------------------

--help | prints a help message.
--prefix=path | defines a directory that will keep server files. This same directory will also be used for all relative paths set by configure (except for paths to libraries sources) and in the nginx.conf configuration file. It is set to the /usr/local/nginx directory by default.
--sbin-path=path | sets the name of an nginx executable file. This name is used only during installation. By default the file is named prefix/sbin/nginx.
--modules-path=path | defines a directory where nginx dynamic modules will be installed. By default the prefix/modules directory is used.
--conf-path=path | sets the name of an nginx.confprefix/conf/nginx.conf.
--http-log-path=path | sets the name of the primary request log file of the HTTP server. After installation, the file name can always be changed in the nginx.conf configuration file using the access_log directive. By default the file is named prefix/logs/access.log.
--error-log-path=path | sets the name of the primary error, warnings, and diagnostic file. After installation, the file name can always be changed in the nginx.confprefix/logs/error.log.
--pid-path=path | sets the name of an nginx.pid file that will store the process ID of the main process. After installation, the file name can always be changed in the nginx.confprefix/logs/nginx.pid.
--lock-path=path | sets a prefix for the names of lock files. After installation, the value can always be changed in the nginx.confprefix/logs/nginx.lock.
--user=name | sets the name of an unprivileged user whose credentials will be used by worker processes. After installation, the name can always be changed in the nginx.conf configuration file using the user directive. The default user name is nobody.
--group=name | sets the name of a group whose credentials will be used by worker processes. After installation, the name can always be changed in the nginx.conf configuration file using the user directive. By default, a group name is set to the name of an unprivileged user.
--build=name | sets an optional nginx build name.
--builddir=path | sets a build directory.
--add-module=path | enables an external module.
--add-dynamic-module=path | enables an external dynamic module.

--http-client-body-temp-path=path | defines a directory for storing temporary files that hold client request bodies. After installation, the directory can always be changed in the nginx.conf configuration file using the client_body_temp_path directive. By default the directory is named prefix/client_body_temp.
--http-proxy-temp-path=path | defines a directory for storing temporary files with data received from proxied servers. After installation, the directory can always be changed in the nginx.conf configuration file using the proxy_temp_path directive. By default the directory is named prefix/proxy_temp.
--http-fastcgi-temp-path=path | defines a directory for storing temporary files with data received from FastCGI servers. After installation, the directory can always be changed in the nginx.conf configuration file using the fastcgi_temp_path directive. By default the directory is named prefix/fastcgi_temp.
--http-uwsgi-temp-path=path | defines a directory for storing temporary files with data received from uwsgi servers. After installation, the directory can always be changed in the nginx.conf configuration file using the uwsgi_temp_path directive. By default the directory is named prefix/uwsgi_temp.
--http-scgi-temp-path=path | defines a directory for storing temporary files with data received from SCGI servers. After installation, the directory can always be changed in the nginx.conf configuration file using the scgi_temp_path directive. By default the directory is named prefix/scgi_temp.

# With
--with-select_module | --without-select_module | enables or disables building a module that allows the server to work with the select() method. This module is built automatically if the platform does not appear to support more appropriate methods such as kqueue, epoll, or /dev/poll.
--with-poll_module | --without-poll_module | enables or disables building a module that allows the server to work with the poll() method. This module is built automatically if the platform does not appear to support more appropriate methods such as kqueue, epoll, or /dev/poll.
--with-threads | enables the use of thread pools.
--with-file-aio | enables the use of asynchronous file I/O (AIO) on FreeBSD and Linux.
--with-http_ssl_module | enables building a module that adds the HTTPS protocol support to an HTTP server. This module is not built by default. The OpenSSL library is required to build and run this module.
--with-http_v2_module | enables building a module that provides support for HTTP/2. This module is not built by default.
--with-http_realip_module | enables building the ngx_http_realip_module module that changes the client address to the address sent in the specified header field. This module is not built by default.
--with-http_addition_module | enables building the ngx_http_addition_module module that adds text before and after a response. This module is not built by default.
--with-http_xslt_module | --with-http_xslt_module=dynamic | enables building the ngx_http_xslt_module module that transforms XML responses using one or more XSLT stylesheets. This module is not built by default. The libxml2 and libxslt libraries are required to build and run this module.
--with-http_image_filter_module | --with-http_image_filter_module=dynamic | enables building the ngx_http_image_filter_module module that transforms images in JPEG, GIF, PNG, and WebP formats. This module is not built by default.
--with-http_geoip_module | --with-http_geoip_module=dynamic | enables building the ngx_http_geoip_module module that creates variables depending on the client IP address and the precompiled MaxMind databases. This module is not built by default.
--with-http_sub_module | enables building the ngx_http_sub_module module that modifies a response by replacing one specified string by another. This module is not built by default.
--with-http_dav_module | enables building the ngx_http_dav_module module that provides file management automation via the WebDAV protocol. This module is not built by default.
--with-http_flv_module | enables building the ngx_http_flv_module module that provides pseudo-streaming server-side support for Flash Video (FLV) files. This module is not built by default.
--with-http_mp4_module | enables building the ngx_http_mp4_module module that provides pseudo-streaming server-side support for MP4 files. This module is not built by default.
--with-http_gunzip_module | enables building the ngx_http_gunzip_module module that decompresses responses with “Content-Encoding: gzip” for clients that do not support “gzip” encoding method. This module is not built by default.
--with-http_gzip_static_module | enables building the ngx_http_gzip_static_module module that enables sending precompressed files with the “.gz” filename extension instead of regular files. This module is not built by default.
--with-http_auth_request_module | enables building the ngx_http_auth_request_module module that implements client authorization based on the result of a subrequest. This module is not built by default.
--with-http_random_index_module | enables building the ngx_http_random_index_module module that processes requests ending with the slash character (‘/’) and picks a random file in a directory to serve as an index file. This module is not built by default.
--with-http_secure_link_module | enables building the ngx_http_secure_link_module module. This module is not built by default.
--with-http_degradation_module | enables building the ngx_http_degradation_module module. This module is not built by default.
--with-http_slice_module | enables building the ngx_http_slice_module module that splits a request into subrequests, each returning a certain range of response. The module provides more effective caching of big responses. This module is not built by default.
--with-http_stub_status_module | enables building the ngx_http_stub_status_module module that provides access to basic status information. This module is not built by default.
--with-http_perl_module | --with-http_perl_module=dynamic | enables building the embedded Perl module. This module is not built by default.
--with-perl_modules_path=path | defines a directory that will keep Perl modules.
--with-perl=path | sets the name of the Perl binary.
--with-mail | --with-mail=dynamic | enables POP3/IMAP4/SMTP mail proxy server.
--with-mail_ssl_module | enables building a module that adds the SSL/TLS protocol support to the mail proxy server. This module is not built by default. The OpenSSL library is required to build and run this module.
--with-stream | --with-stream=dynamic | enables building the stream module for generic TCP/UDP proxying and load balancing. This module is not built by default.
--with-stream_ssl_module | enables building a module that adds the SSL/TLS protocol support to the stream module. This module is not built by default. The OpenSSL library is required to build and run this module.
--with-stream_realip_module | enables building the ngx_stream_realip_module module that changes the client address to the address sent in the PROXY protocol header. This module is not built by default.
--with-stream_geoip_module | --with-stream_geoip_module=dynamic | enables building the ngx_stream_geoip_module module that creates variables depending on the client IP address and the precompiled MaxMind databases. This module is not built by default.
--with-stream_ssl_preread_module | enables building the ngx_stream_ssl_preread_module module that allows extracting information from the ClientHello message without terminating SSL/TLS. This module is not built by default.
--with-google_perftools_module | enables building the ngx_google_perftools_module module that enables profiling of nginx worker processes using Google Performance Tools. The module is intended for nginx developers and is not built by default.
--with-cpp_test_module | enables building the ngx_cpp_test_module module.
--with-compat | enables dynamic modules compatibility.
--with-cc=path | sets the name of the C compiler.
--with-cpp=path | sets the name of the C preprocessor.
--with-cc-opt=parameters | sets additional parameters that will be added to the CFLAGS variable. When using the system PCRE library under FreeBSD, --with-cc-opt="-I /usr/local/include" should be specified. If the number of files supported by select() needs to be increased it can also be specified here such as this: --with-cc-opt="-D FD_SETSIZE=2048". | --with-ld-opt=parameters | sets additional parameters that will be used during linking. When using the system PCRE library under FreeBSD, --with-ld-opt="-L /usr/local/lib" should be specified. | --with-cpu-opt=cpu | enables building per specified CPU: pentium, pentiumpro, pentium3, pentium4, athlon, opteron, sparc32, sparc64, ppc64.
--with-pcre | forces the usage of the PCRE library.
--with-pcre=path | sets the path to the sources of the PCRE library. The library distribution needs to be downloaded from the PCRE site and extracted. The rest is done by nginx’s ./configure and make. The library is required for regular expressions support in the location directive and for the ngx_http_rewrite_module module.
--with-pcre-opt=parameters | sets additional build options for PCRE.
--with-pcre-jit | builds the PCRE library with “just-in-time compilation” support (1.1.12, the pcre_jit directive).
--with-zlib=path | sets the path to the sources of the zlib library. The library distribution (version 1.1.3 — 1.2.11) needs to be downloaded from the zlib site and extracted. The rest is done by nginx’s ./configure and make. The library is required for the ngx_http_gzip_module module.
--with-zlib-opt=parameters | sets additional build options for zlib.
--with-zlib-asm=cpu | enables the use of the zlib assembler sources optimized for one of the specified CPUs: pentium, pentiumpro.
--with-libatomic | forces the libatomic_ops library usage.
--with-libatomic=path | sets the path to the libatomic_ops library sources.
--with-openssl=path | sets the path to the OpenSSL library sources.
--with-openssl-opt=parameters | sets additional build options for OpenSSL.
--with-debug | enables the debugging log.

# Without
--without-http_charset_module | disables building the ngx_http_charset_module module that adds the specified charset to the “Content-Type” response header field and can additionally convert data from one charset to another.
--without-http_gzip_module | disables building a module that compresses responses of an HTTP server. The zlib library is required to build and run this module.
--without-http_ssi_module | disables building the ngx_http_ssi_module module that processes SSI (Server Side Includes) commands in responses passing through it.
--without-http_userid_module | disables building the ngx_http_userid_module module that sets cookies suitable for client identification.
--without-http_access_module | disables building the ngx_http_access_module module that allows limiting access to certain client addresses.
--without-http_auth_basic_module | disables building the ngx_http_auth_basic_module module that allows limiting access to resources by validating the user name and password using the “HTTP Basic Authentication” protocol.
--without-http_mirror_module | disables building the ngx_http_mirror_module module that implements mirroring of an original request by creating background mirror subrequests.
--without-http_autoindex_module | disables building the ngx_http_autoindex_module module that processes requests ending with the slash character (‘/’) and produces a directory listing in case the ngx_http_index_module module cannot find an index file.
--without-http_geo_module | disables building the ngx_http_geo_module module that creates variables with values depending on the client IP address.
--without-http_map_module | disables building the ngx_http_map_module module that creates variables with values depending on values of other variables.
--without-http_split_clients_module | disables building the ngx_http_split_clients_module module that creates variables for A/B testing.
--without-http_referer_module | disables building the ngx_http_referer_module module that can block access to a site for requests with invalid values in the “Referer” header field.
--without-http_rewrite_module | disables building a module that allows an HTTP server to redirect requests and change URI of requests. The PCRE library is required to build and run this module.
--without-http_proxy_module | disables building an HTTP server proxying module.
--without-http_fastcgi_module | disables building the ngx_http_fastcgi_module module that passes requests to a FastCGI server.
--without-http_uwsgi_module | disables building the ngx_http_uwsgi_module module that passes requests to a uwsgi server.
--without-http_scgi_module | disables building the ngx_http_scgi_module module that passes requests to an SCGI server.
--without-http_grpc_module | disables building the ngx_http_grpc_module module that passes requests to a gRPC server.
--without-http_memcached_module | disables building the ngx_http_memcached_module module that obtains responses from a memcached server.
--without-http_limit_conn_module | disables building the ngx_http_limit_conn_module module that limits the number of connections per key, for example, the number of connections from a single IP address.
--without-http_limit_req_module | disables building the ngx_http_limit_req_module module that limits the request processing rate per key, for example, the processing rate of requests coming from a single IP address.
--without-http_empty_gif_module | disables building a module that emits single-pixel transparent GIF.
--without-http_browser_module | disables building the ngx_http_browser_module module that creates variables whose values depend on the value of the “User-Agent” request header field.
--without-http_upstream_hash_module | disables building a module that implements the hash load balancing method.
--without-http_upstream_ip_hash_module | disables building a module that implements the ip_hash load balancing method.
--without-http_upstream_least_conn_module | disables building a module that implements the least_conn load balancing method.
--without-http_upstream_random_module | disables building a module that implements the random load balancing method.
--without-http_upstream_keepalive_module | disables building a module that provides caching of connections to upstream servers.
--without-http_upstream_zone_module | disables building a module that makes it possible to store run-time state of an upstream group in a shared memory zone.
--without-http | disables the HTTP server.
--without-http-cache | disables HTTP cache.
--without-mail_pop3_module | disables the POP3 protocol in mail proxy server.
--without-mail_imap_module | disables the IMAP protocol in mail proxy server.
--without-mail_smtp_module | disables the SMTP protocol in mail proxy server.
--without-stream_limit_conn_module | disables building the ngx_stream_limit_conn_module module that limits the number of connections per key, for example, the number of connections from a single IP address.
--without-stream_access_module | disables building the ngx_stream_access_module module that allows limiting access to certain client addresses.
--without-stream_geo_module | disables building the ngx_stream_geo_module module that creates variables with values depending on the client IP address.
--without-stream_map_module | disables building the ngx_stream_map_module module that creates variables with values depending on values of other variables.
--without-stream_split_clients_module | disables building the ngx_stream_split_clients_module module that creates variables for A/B testing.
--without-stream_return_module | disables building the ngx_stream_return_module module that sends some specified value to the client and then closes the connection.
--without-stream_set_module | disables building the ngx_stream_set_module module that sets a value for a variable.
--without-stream_upstream_hash_module | disables building a module that implements the hash load balancing method.
--without-stream_upstream_least_conn_module | disables building a module that implements the least_conn load balancing method.
--without-stream_upstream_random_module | disables building a module that implements the random load balancing method.
--without-stream_upstream_zone_module | disables building a module that makes it possible to store run-time state of an upstream group in a shared memory zone.
--without-pcre | disables the usage of the PCRE library.
--without-pcre2 | disables use of the PCRE2 library instead of the original PCRE library (1.21.5).

# Nginx 기동
nginx

# Nginx 확인
nginx -V

##########################################################################################################################################
# 4. 백그라운드 등록 & Service 등록
##########################################################################################################################################

# Nginx 정지
nginx -s stop

# systemd 에 nginx.service 등록 & 실행
sudo tee /etc/systemd/system/nginx.service << EOF
[Unit]
Description=The NGINX HTTP and reverse proxy server
After=syslog.target network-online.target remote-fs.target nss-lookup.target
Wants=network-online.target
        
[Service]
Type=forking
PIDFile=/var/run/nginx.pid
ExecStartPre=/usr/sbin/nginx -t
ExecStart=/usr/sbin/nginx
ExecReload=/usr/sbin/nginx -s reload
ExecStop=/bin/kill -s QUIT $MAINPID
PrivateTmp=true
        
[Install]
WantedBy=multi-user.target
EOF

sudo systemctl enable --now nginx

# service nginx 상태 확인
sudo systemctl status nginx | tail -n 300

# nginx process 확인
ps aux | grep nginx

https://unix.stackexchange.com/questions/175345/difference-between-run-and-var-run
https://jadehan.tistory.com/11

##########################################################################################################################################@
#@ apt 설치 방법
##########################################################################################################################################@
# APT 설정
$ vi /etc/apt/sources.list.d/nginx.list
'''
$release = "bionic"
deb https://nginx.org/packages/ubuntu/ $release nginx
deb-src https://nginx.org/packages/ubuntu/ $release nginx
'''

# APT 설치
$ apt-get update
$ apt-get install nginx

# 확인
$ nginx -V

# 삭제
$ apt-get remove --purge nginx nginx-full nginx-common
