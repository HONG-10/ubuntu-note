#!/bin/bash

# Redis official site : https://redis.io/download/
# Install Method : C Compile

##########################################################################################################################################
# ​선행조건 | Redis 의존 패키지 설치 | 계정 생성
##########################################################################################################################################

# APT 필수 패키지 Update
echo -e "\n[ INFO ]  apt-get update\n" && \
sudo apt-get update -y

# APT 필수 패키지 Install
echo -e "\n[ INFO ]  Redis 의존 패키지 Install\n" && \
DEBIAN_FRONTEND=noninteractive \
sudo apt-get install -y --no-install-recommends \
    debhelper libperl-dev tcl8.5-dev

# APT 필수 패키지 Upgrade
echo -e "\n[ INFO ]  apt-get upgrade\n" && \
sudo apt-get upgrade -y

### APT 불필요한 패키지 Clean
sudo apt-get clean -y && \
sudo rm -rf /var/lib/apt/lists/*

------------------------------------------------------------------------------------------------------------------

# postgres 계정 생성
REDIS_USER='redis'
REDIS_USER_PASSWORD='redis123#'

sudo useradd -s /bin/bash -d /home/"${REDIS_USER}"/ -m -G sudo "${REDIS_USER}"
echo -e "${REDIS_USER_PASSWORD}\n${REDIS_USER_PASSWORD}\n" | sudo passwd "${REDIS_USER}"
echo "${REDIS_USER} ALL=NOPASSWD: ALL" | sudo tee "/etc/sudoers.d/${REDIS_USER}-nopasswd"



usr은 root
etc는 redis

##########################################################################################################################################
# 1. 인터넷 가능한 Linux 서버 ( 예 : WSL2 ) 에서 Redis 다운로드
##########################################################################################################################################

# Redis 다운로드 경로 | File : redis-7.0.5.tar.gz | 2022-09-21
REDIS_DOWNLNAD_URL=https://github.com/redis/redis/archive/7.0.5.tar.gz

# 다운로드시 사용할 임시 작업 디렉토리
WORK_DIR=~/tmp
[ -d "${WORK_DIR}" ] || mkdir -p "${WORK_DIR}"

# Redis.tar.gz 다운로드
curl -G -k \
  -o "${WORK_DIR}"/redis.tar.gz \
  -L "${REDIS_DOWNLNAD_URL}"

##########################################################################################################################################
# 2. Redis 설치할 서버에 접속 후 위에서 다운로드 받은 파일들을 서버 내 작업 디렉토리에 직접 업로드한다.
##########################################################################################################################################

# 설치파일 업로드 / offline 설치시 사용할 임시 작업 디렉토리 생성
WORK_DIR=~/tmp
[ -d "${WORK_DIR}" ] || mkdir -p "${WORK_DIR}"

# 임시 작업 디렉토리에 *.tar.gz 파일들을 업로드한다.

##########################################################################################################################################
# 3. 임시 작업 디렉토리에 업로드된 파일 기반으로 offline 설치
##########################################################################################################################################

# Redis 압축 해제
REDIS_7_PATH=/opt/redis/7
[ -d "${REDIS_7_PATH}" ] || sudo mkdir -p "${REDIS_7_PATH}"

sudo tar -zxf "${WORK_DIR}"/redis.tar.gz \
  -C "${REDIS_7_PATH}" \
  --strip-components=1

sudo chown -R root:root "${REDIS_7_PATH}"

------------------------------------------------------------------------------------------------------------------

REDIS_7_PATH=/opt/redis/7
cd "${REDIS_7_PATH}"

# 설치 | Redis
echo -e "\n[ INFO ]  Install\n" && \
sudo make install \
  -C "${REDIS_7_PATH}"

# dot(hidden) 파일도 이동 처리되도록 설정
shopt -s dotglob

##########################################################################################################################################
# 4. Redis Server, Redis CLI 실행
##########################################################################################################################################



5. Redis 실행
./pg_ctl -D ${REDIS_7_PATH}/data start
./pg_ctl -D ${REDIS_7_PATH}/data stop
./pg_ctl -D ${REDIS_7_PATH}/data restart

$ vi ~/.bash_profile
 export LD_LIBRARY_PATH=:$HOME/pgsql/lib
 export PATH=$PATH:$HOME/pgsql/bin
 export PGDATA=$HOME/pgsql/data

$ source ~/.bash_profile

# Redis 설치 관련 script 작성 후 저장
# vi ./postgres-install.sh
# * chmod u+x ./postgres-install.sh && ./postgres-install.sh


# Redis 접속
psql


##########################################################################################################################################@
#@ apt 설치 방법
##########################################################################################################################################@
# 저장소 추가
$ echo "deb http://apt.Redis.org/pub/repos/apt/ bionic-pgdg main" > /etc/apt/sources.list.d/pgdg.list
$ wget https://www.Redis.org/media/keys/ACCC4CF8.asc
$ apt-key add ACCC4CF8.asc && rm -f ACCC4CF8.asc
$ apt-get update

# 설치
$ apt-get install Redis-11

# 확인
$ sudo -u postgres psql

-----------------
sudo sh -c 'echo "deb http://apt.Redis.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.Redis.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get update
sudo apt-get -y install Redis
