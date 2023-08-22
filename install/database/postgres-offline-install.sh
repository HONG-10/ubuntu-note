#!/bin/bash

# PostgreSQL official site : https://www.postgresql.org/ftp/source/
# Install Method : C Compile

##########################################################################################################################################
# ​0. 선행조건 | PostgreSQL 의존 패키지 설치 | 계정 생성
##########################################################################################################################################

# APT 필수 패키지 Update
echo -e "\n[ INFO ]  apt-get update\n" && \
sudo apt-get update -y

# APT 필수 패키지 Install
echo -e "\n[ INFO ]  PostgreSQL 의존 패키지 Install\n" && \
DEBIAN_FRONTEND=noninteractive \
sudo apt-get install -y --no-install-recommends \
    debhelper libperl-dev tcl8.5-dev  libssl-dev \
    zlib1g-dev libz-dev libpam0g-dev libpam-dev libxml2-dev libkrb5-dev \
    libldap2-dev libxslt1-dev libossp-uuid-dev python-dev  \
    gettext bzip2 perl cdbs
    # python-central hardening-wrapper libreadline5-dev



readline readline-devel
zlib, zlib-devel
openssl, openssl-devel
python, python-devel
perl systemd-devel
gcc gcc-c++ 
systemd systemd-devel
python python-devel
gettext gettext-devel autoconf wget flex flex-devel

# sudo apt-get build-dep postgresql

# debhelper (>= 5.0.37.2)
# cdbs (>= 0.4.43)
# perl (>= 5.8)
# libreadline5-dev (>= 4.2)
# python-central (>= 0.5)
# readline error >> libreadline5-dev

# APT 필수 패키지 Upgrade
echo -e "\n[ INFO ]  apt-get upgrade\n" && \
sudo apt-get upgrade -y

### APT 불필요한 패키지 Clean
sudo apt-get clean -y && \
sudo rm -rf /var/lib/apt/lists/*

# ------------------------------------------------------------------------------------------------------------------

# postgres 계정 생성
POSTGRESQL_USER='postgres'
POSTGRESQL_USER_PASSWORD='postgres123#'

sudo useradd -s /bin/bash -d /home/"${POSTGRESQL_USER}"/ -m -G sudo "${POSTGRESQL_USER}"
echo -e "${POSTGRESQL_USER_PASSWORD}\n${POSTGRESQL_USER_PASSWORD}\n" | sudo passwd "${POSTGRESQL_USER}"
echo "${POSTGRESQL_USER} ALL=NOPASSWD: ALL" | sudo tee "/etc/sudoers.d/${POSTGRESQL_USER}-nopasswd"

##########################################################################################################################################
# 1. 인터넷 가능한 Linux 서버 ( 예 : WSL2 ) 에서 PostgreSQL 다운로드
##########################################################################################################################################

# PostgreSQL 다운로드 경로 | File : postgresql-14.6.tar.gz | 2022-11-07
POSTGRESQL_DOWNLNAD_URL=https://ftp.postgresql.org/pub/source/v14.6/postgresql-14.6.tar.gz

# 다운로드시 사용할 임시 작업 디렉토리
WORK_DIR=~/tmp
[ -d "${WORK_DIR}" ] || mkdir -p "${WORK_DIR}"

# postgresql.tar.gz 다운로드
curl -G -k \
  -o "${WORK_DIR}"/postgresql.tar.gz \
  -L "${POSTGRESQL_DOWNLNAD_URL}"

##########################################################################################################################################
# 2. PostgreSQL 설치할 서버에 접속 후 위에서 다운로드 받은 파일들을 서버 내 작업 디렉토리에 직접 업로드한다.
##########################################################################################################################################

# 설치파일 업로드 / offline 설치시 사용할 임시 작업 디렉토리 생성
WORK_DIR=~/tmp
[ -d "${WORK_DIR}" ] || mkdir -p "${WORK_DIR}"

# 임시 작업 디렉토리에 *.tar.gz 파일들을 업로드한다.

##########################################################################################################################################
# 3. 임시 작업 디렉토리에 업로드된 파일 기반으로 offline 설치
##########################################################################################################################################

# PostgreSQL 압축 해제
POSTGRESQL_14_PATH=/opt/postgresql/14
[ -d "${POSTGRESQL_14_PATH}" ] || sudo mkdir -p "${POSTGRESQL_14_PATH}"

sudo tar -zxf "${WORK_DIR}"/postgresql.tar.gz \
  -C "${POSTGRESQL_14_PATH}" \
  --strip-components=1

sudo chown -R root:root "${POSTGRESQL_14_PATH}"

------------------------------------------------------------------------------------------------------------------

POSTGRESQL_14_PATH=/opt/postgresql/14
cd "${POSTGRESQL_14_PATH}"

# 설치파일(Makefile) 생성 | PostgreSQL
echo -e "\n[ INFO ]  Create Makefile\n" && \
sudo ./configure --prefix="${POSTGRESQL_14_PATH}" \
  --without-readline

# 컴파일 | PostgreSQL
echo -e "\n[ INFO ]  Compile\n" && \
sudo make -j 24 \
  -C "${POSTGRESQL_14_PATH}"

# 설치 | PostgreSQL
echo -e "\n[ INFO ]  Install\n" && \
sudo make -j 24 install \
  -C "${POSTGRESQL_14_PATH}"



su "${POSTGRESQL_USER}"



cd ${POSTGRESQL_14_PATH}/bin && sudo ./initdb -D ${POSTGRESQL_14_PATH}/data


# dot(hidden) 파일도 이동 처리되도록 설정
shopt -s dotglob

# postgresql-(버전명) 디렉토리 내 모든 파일을 POSTGRESQL_14_PATH 으로 이동
sudo mv "${WORK_DIR}"/postgresql-"${POSTGRESQL_VERSION}"/* \
   "${POSTGRESQL_14_PATH}"


 /usr/lib/postgresql/11/lib | 라이브러리 파일
 /usr/lib/postgresql/11/bin | 바이너리 파일

 /usr/share/postgresql/11/ | smaple 파일

 /etc/postgresql | 설정 파일
 
 설치 후 PostgreSQL 관련 파일의 위치는 다음과 같다.

설정 파일: /etc/postgresql/[version]/[cluster]/
실행 파일: /usr/lib/postgresql/[version]
데이타 파일: /var/lib/postgresql/[version]/[cluster]
로그 파일: /var/log/postgresql 디렉토리 안의 postgresql-[version]-[cluster].log




5. PostgreSQL 실행
./pg_ctl -D ${POSTGRESQL_14_PATH}/data start
./pg_ctl -D ${POSTGRESQL_14_PATH}/data stop
./pg_ctl -D ${POSTGRESQL_14_PATH}/data restart

$ vi ~/.bash_profile
 export LD_LIBRARY_PATH=:$HOME/pgsql/lib
 export PATH=$PATH:$HOME/pgsql/bin
 export PGDATA=$HOME/pgsql/data

$ source ~/.bash_profile

# PostgreSQL 설치 관련 script 작성 후 저장
# vi ./postgres-install.sh
'''
chmod u+x ./postgres-install.sh && ./postgres-install.sh
'''


# PostgreSQL 접속
psql


##########################################################################################################################################
# apt 설치 방법
##########################################################################################################################################
# 저장소 추가
$ echo "deb http://apt.postgresql.org/pub/repos/apt/ bionic-pgdg main" > /etc/apt/sources.list.d/pgdg.list
$ wget https://www.postgresql.org/media/keys/ACCC4CF8.asc
$ apt-key add ACCC4CF8.asc && rm -f ACCC4CF8.asc
$ apt-get update

# 설치
$ apt-get install postgresql-11

# 확인
$ sudo -u postgres psql

-----------------
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get update
sudo apt-get -y install postgresql



[code:tdmrvuqo]--mandir=\$${prefix}/share/postgresql/$(MAJOR_VER)/man \
--with-docdir=\$${prefix}/share/doc/postgresql-doc-$(MAJOR_VER) \
--sysconfdir=/etc/postgresql-common \
--datadir=\$${prefix}/share/postgresql/$(MAJOR_VER) \
--bindir=\$${prefix}/lib/postgresql/$(MAJOR_VER)/bin \
--includedir=\$${prefix}/include/postgresql/ \
--enable-nls \
--enable-integer-datetimes \
--enable-thread-safety \
--enable-debug \
--disable-rpath \
--with-tcl \
--with-perl \
--with-python \
--with-pam \
--with-krb5 \
--with-gssapi \
--with-openssl \
--with-libxml \
--with-libxslt \
--with-ldap \
--with-ossp-uuid \
--with-gnu-ld \
--with-tclconfig=/usr/lib/tcl$(TCL_VER) \
--with-tkconfig=/usr/lib/tk$(TCL_VER) \
--with-includes=/usr/include/tcl$(TCL_VER) \
--with-system-tzdata=/usr/share/zoneinfo \
--with-pgport=5432 \
$(ARCH_OPTS) \
CFLAGS='$(CFLAGS)' \
LDFLAGS='$(LDFLAGS)'[/code:tdmrvuqo]