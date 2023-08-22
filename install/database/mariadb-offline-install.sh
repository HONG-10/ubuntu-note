#!/bin/bash

# MariaDB official site : https://mariadb.org/mariadb/all-releases/
# Install Method : C Compile

##########################################################################################################################################
# ​선행조건 | MariaDB 의존 패키지 설치 
##########################################################################################################################################

# APT 필수 패키지 Update
echo -e "\n[ INFO ]  apt-get update\n" && \
sudo apt-get update -y

# APT 필수 패키지 Install
echo -e "\n[ INFO ]  MariaDB 의존 패키지 Install\n" && \
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













# # mysql 계정 생성
# $ groupadd mysql
# $ useradd -g mysql -M -s /bin/false mysql   # 시스템 로그인이 불가하며 홈디렉터리를 제외하여 mysql 계정을 생성

# # MySQL 계정 생성
# MYSQL_USER='mysql'
# MYSQL_USER_PASSWORD='mysql123#'    ** 본인 비밀번호에 맞춰 변경

# sudo useradd -s /bin/bash -d /home/"${MYSQL_USER}"/ -m -G sudo "${MYSQL_USER}"
# echo -e "${MYSQL_USER_PASSWORD}\n${MYSQL_USER_PASSWORD}\n" | sudo passwd "${MYSQL_USER}"
# echo "${MYSQL_USER} ALL=NOPASSWD: ALL" | sudo tee "/etc/sudoers.d/${MYSQL_USER}-nopasswd"

# su "${MYSQL_USER}"
# cd ~


# yum install -y cmake bison gcc gcc-c++ ncurses-devel

##########################################################################################################################################
# 1. 인터넷 가능한 Linux 서버 ( 예 : WSL2 ) 에서 MySQL 다운로드
##########################################################################################################################################

# CMake 다운로드 경로 | File : cmake-3.26.1.tar.gz | 2023-03-29
CMAKE_DOWNLOAD_URL=https://github.com/Kitware/CMake/releases/download/v3.26.1/cmake-3.26.1.tar.gz

# MySQL 다운로드 경로 | File : mysql-5.6.28.tar.gz | 2023-03-29
MARIADB_DOWNLOAD_URL=https://downloads.mariadb.com/MariaDB/mariadb-10.5.6

# 다운로드시 사용할 임시 작업 디렉토리
WORK_DIR=~/tmp
[ -d "${WORK_DIR}" ] || mkdir -p "${WORK_DIR}"

# mysql.tar.gz 다운로드
curl -G -k \
  -o "${WORK_DIR}"/mysql.tar.gz \
  -L "${MARIADB_DOWNLOAD_URL}"


##########################################################################################################################################
# 2. MYSQL 설치할 서버에 접속 후 위에서 다운로드 받은 파일들을 서버 내 작업 디렉토리에 직접 업로드한다.
##########################################################################################################################################

# 설치파일 업로드 / offline 설치시 사용할 임시 작업 디렉토리 생성
WORK_DIR=~/tmp
[ -d "${WORK_DIR}" ] || mkdir -p "${WORK_DIR}"

# 임시 작업 디렉토리에 *.tar.gz, *.deb 파일들을 업로드한다.


##########################################################################################################################################
# 3. 임시 작업 디렉토리에 업로드된 파일 기반으로 offline 설치
##########################################################################################################################################

# MYSQL 설치 관련 script 작성 후 저장
# vi ./mysql-install.sh
# '''
# chmod u+x ./mysql-install.sh && ./mysql-install.sh
# '''

# MYSQL 설치 디렉토리
MYSQL_INSTALL_PATH=/usr/local/src
WORK_DIR=~/tmp
MYSQL_VERSION='10.5.6'

[ -d "${MYSQL_INSTALL_PATH}" ] || sudo mkdir -p "${MYSQL_INSTALL_PATH}"

# wget http://dev.mysql.com/get/Downloads/MySQL-5.6/mysql-5.6.28.tar.gz

# tar xzvf mysql-5.6.28.tar.gz

# cd mysql-5.6.28

# 압축 해제
tar -xvzf "${WORK_DIR}"/mysql.tgz \
  -C "${WORK_DIR}" \

tar xvf 파일명.tgz

# dot(hidden) 파일도 이동 처리되도록 설정
shopt -s dotglob

# MYSQL-(버전명) 디렉토리 내 모든 파일을 MYSQL_INSTALL_PATH 으로 이동
sudo mv "${WORK_DIR}"/mysql-"${MYSQL_VERSION}"/* \
   "${MYSQL_INSTALL_PATH}"


cd ${MYSQL_INSTALL_PATH}


# Configure 파일 설정
sudo ./configure
sudo ./configure --prefix=${MYSQL_INSTALL_PATH} --without-readline --without-zlib

# --prefix  : 엔진 설치 경로 (Default: /usr/local/pgsql)
# --without : 설치 시 제외할 Package (gcc, readline-devel, zlib-devel 등 지정 or install)

sudo make && sudo make install
cd ${MYSQL_INSTALL_PATH}/bin && ./initdb -D /${MYSQL_INSTALL_PATH}/data

5. MYSQL 실행
./pg_ctl -D ${MYSQL_INSTALL_PATH}/data start
./pg_ctl -D ${MYSQL_INSTALL_PATH}/data stop
./pg_ctl -D ${MYSQL_INSTALL_PATH}/data restart

$ vi ~/.bash_profile
 export LD_LIBRARY_PATH=:$HOME/pgsql/lib
 export PATH=$PATH:$HOME/pgsql/bin
 export PGDATA=$HOME/pgsql/data

$ source ~/.bash_profile



##########################################################################################################################################
# apt 설치 방법
##########################################################################################################################################

$ sudo apt update -y
$ sudo apt install mariadb-server mariadb-client -y
$ sudo apt upgrade -y
$ sudo mysql_secure_installation
$ sudo mysql -uroot -p

# ------------------------------------------------------------------------------------------------------------------

# 저장소 추가
$ sudo echo "deb http://apt.MYSQL.org/pub/repos/apt/ bionic-pgdg main" > /etc/apt/sources.list.d/pgdg.list
$ sudo wget https://www.MYSQL.org/media/keys/ACCC4CF8.asc
$ sudo apt-key add ACCC4CF8.asc && rm -f ACCC4CF8.asc
$ sudo apt-get update -y

# ------------------------------------------------------------------------------------------------------------------

$ sudo sh -c 'echo "deb http://apt.MYSQL.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
# $ sudo apt-get install -y software-properties-common
# $ sudo add-apt-repository "deb http://apt.MYSQL.org/pub/repos/apt $(lsb_release -cs)-pgdg main"
$ tail /etc/apt/sources.list

$ wget --quiet -O - https://www.MYSQL.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
# $ sudo curl -fsSL https://www.MYSQL.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
$ sudo apt-key fingerprint
$ sudo apt-get clean -y && \
  sudo rm -rf /var/lib/apt/lists/*
$ sudo apt-get update -y

# ------------------------------------------------------------------------------------------------------------------

# 설치
$ sudo apt-get install MYSQL-11

# 확인
$ sudo -u [USER_NM] -p
