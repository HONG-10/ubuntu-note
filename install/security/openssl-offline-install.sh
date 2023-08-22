#!/bin/bash

# Openssl official site : https://www.openssl.org/source/

##########################################################################################################################################
# ​선행조건 | Openssl 의존 패키지 설치 
##########################################################################################################################################

# APT 필수 패키지 Update
echo -e "\n[ INFO ]  apt-get update\n" && \
sudo apt-get update -y

# APT 필수 패키지 Install
echo -e "\n[ INFO ]  Openssl 의존 패키지 Install\n" && \
DEBIAN_FRONTEND=noninteractive \
sudo apt-get install -y --no-install-recommends \
    make gcc libc6-dev

    fuzz gcc-c++ perl pcre-devel zlib-devel
    
# APT 필수 패키지 Upgrade
echo -e "\n[ INFO ]  apt-get upgrade\n" && \
sudo apt-get upgrade -y

### APT 불필요한 패키지 Clean
sudo apt-get clean -y && \
sudo rm -rf /var/lib/apt/lists/*

##########################################################################################################################################
# 1. 인터넷 가능한 Linux 서버 ( 예 : WSL2 ) 에서 Openssl 다운로드
##########################################################################################################################################

# Openssl 다운로드 경로 | File : openssl-1.1.1s.tar.gz | 2022-11-01
OPENSSL_DOWNLOAD_URL=https://www.openssl.org/source/openssl-1.1.1s.tar.gz
# OPENSSL_DOWNLOAD_URL=https://launchpad.net/ubuntu/+archive/primary/+sourcefiles/openssl/1.1.1-1ubuntu2.1~18.04.14/openssl_1.1.1.orig.tar.gz

# 다운로드시 사용할 임시 작업 디렉토리
WORK_DIR=~/tmp
[ -d "${WORK_DIR}" ] || mkdir -p "${WORK_DIR}"

# Openssl 다운로드
curl -G -k \
  -o "${WORK_DIR}"/openssl.tar.gz \
  -L "${OPENSSL_DOWNLOAD_URL}"

##########################################################################################################################################
# 2. Openssl 설치할 서버에 접속 후 위에서 다운로드 받은 파일들을 서버 내 작업 디렉토리에 직접 업로드
##########################################################################################################################################

# 설치파일 업로드 / offline 설치시 사용할 임시 작업 디렉토리 생성
WORK_DIR=~/tmp
[ -d "${WORK_DIR}" ] || mkdir -p "${WORK_DIR}"

# 임시 작업 디렉토리에 *.tar.gz 파일 업로드

##########################################################################################################################################
# 3. 임시 작업 디렉토리에 업로드된 파일 기반으로 offline 설치
##########################################################################################################################################

# Openssl 압축 해제
OPENSSL_PATH=/opt/openssl/openssl-1.1.1s
[ -d "${OPENSSL_PATH}" ] || sudo mkdir -p "${OPENSSL_PATH}"

sudo tar -zxf "${WORK_DIR}"/openssl.tar.gz \
  -C "${OPENSSL_PATH}" \
  --strip-components=1

sudo chown -R root:root "${OPENSSL_PATH}"

------------------------------------------------------------------------------------------------------------------

OPENSSL_PATH=/opt/openssl/openssl-1.1.1s
cd "${OPENSSL_PATH}"

# 설치파일(Makefile) 생성
echo -e "\n[ INFO ]  Create Makefile\n" && \
sudo "${OPENSSL_PATH}"/config --prefix="${OPENSSL_PATH}" \
  --openssldir="${OPENSSL_PATH}" shared

# 컴파일
echo -e "\n[ INFO ]  Compile\n" && \
sudo make \
  -C "${OPENSSL_PATH}"

# 설치
echo -e "\n[ INFO ]  Install\n" && \
sudo make install \
  -C "${OPENSSL_PATH}"

echo -e "\n[ INFO ]  alternatives\n" && \
sudo update-alternatives --install "/usr/local/bin/openssl" "openssl" "${OPENSSL_PATH}/openssl" 112

# Openssl 실행파일의 symbolic link 를 '/usr/local/bin' 경로에 생성 / 실행권한 부여
sudo chmod a+x /usr/local/bin/openssl

##########################################################################################################################################
# 4. 공유 라이브러리 등록
##########################################################################################################################################
# 공유 라이브러리 등록
$ sudo vim /etc/ld.so.conf.d/openssl-1.1.1l.conf
'''
# OPENSSL_DOWNLOAD_URL 경로 추가
/usr/local/bin/openssl/lib
'''

# 공유 라이브러리 캐시 재설정
$ sudo ldconfig -v

##########################################################################################################################################
# 5. Openssl 관련 라이브러리 확인 및 추가
##########################################################################################################################################
# Openssl 관련 라이브러리 확인
$ ll /usr/lib64 | grep libssl

# Openssl 관련 라이브러리 추가
$ OPENSSL_DOWNLOAD_URL=/usr/local/bin/openssl
$ sudo ln -s "${OPENSSL_DOWNLOAD_URL}"/lib/libssl.so.1.1 /usr/lib64/libssl.so.1.1
$ sudo ln -s "${OPENSSL_DOWNLOAD_URL}"/lib/libcrypto.so.1.1 /usr/lib64/libcrypto.so.1.1

rpm -qa openssl
rpm -qa openssl-devel