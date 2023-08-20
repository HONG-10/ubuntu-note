#!/bin/bash

##########################################################################################################################################
# 1. 인터넷 가능한 Linux 서버 ( 예 : WSL2 ) 에서 openjdk-8 다운로드
##########################################################################################################################################

# openjdk-8 다운로드 경로 : OpenJDK8U-jdk_x64_linux_hotspot_8u332b09.tar.gz ( 2022-04-28 )
OPENJDK_8_DOWNLOAD_URL=https://github.com/adoptium/temurin8-binaries/releases/download/jdk8u332-b09/OpenJDK8U-jdk_x64_linux_hotspot_8u332b09.tar.gz

# openjdk-11 다운로드 경로 : OpenJDK11U-jdk_x64_linux_hotspot_11.0.15_10.tar.gz ( 2022-04-23 )
OPENJDK_11_DOWNLOAD_URL=https://github.com/adoptium/temurin11-binaries/releases/download/jdk-11.0.15%2B10/OpenJDK11U-jdk_x64_linux_hotspot_11.0.15_10.tar.gz

# 다운로드시 사용할 임시 작업 디렉토리
WORK_DIR=~/tmp
[ -d "${WORK_DIR}" ] || mkdir -p "${WORK_DIR}"

# openjdk-8 다운로드
curl -G -k \
  -o "${WORK_DIR}"/openjdk-8.tar.gz \
  -L "${OPENJDK_8_DOWNLOAD_URL}"

# openjdk-11 다운로드
curl -G -k \
  -o "${WORK_DIR}"/openjdk-11.tar.gz \
  -L "${OPENJDK_11_DOWNLOAD_URL}"

##########################################################################################################################################
# 2. OpenJDK 설치할 서버에 접속 후 위에서 다운로드 받은 파일들을 서버 내 작업 디렉토리에 직접 업로드한다.
##########################################################################################################################################

# 설치파일 업로드 / offline 설치시 사용할 임시 작업 디렉토리 생성
WORK_DIR=~/tmp
[ -d "${WORK_DIR}" ] || mkdir -p "${WORK_DIR}"

# 임시 작업 디렉토리에 *.tar.gz 파일을 업로드한다.

##########################################################################################################################################
# 3. 임시 작업 디렉토리에 업로드된 파일 기반으로 offline 설치
##########################################################################################################################################

# '/opt/java' 경로에 버전별로 다양한 jdk/jre 를 설치/사용할 수 있도록 구성한다.

# openjdk-8 압축 해제
OPEN_JDK_8_PATH=/opt/java/openjdk-8
[ -d "${OPEN_JDK_8_PATH}" ] || sudo mkdir -p "${OPEN_JDK_8_PATH}"

sudo tar -zxf "${WORK_DIR}"/openjdk-8.tar.gz \
  -C "${OPEN_JDK_8_PATH}" \
  --strip-components=1

sudo chown -R root:root "${OPEN_JDK_8_PATH}"

# openjdk-11 압축 해제
OPEN_JDK_11_PATH=/opt/java/openjdk-11
[ -d "${OPEN_JDK_11_PATH}" ] || sudo mkdir -p "${OPEN_JDK_11_PATH}"

sudo tar -zxf "${WORK_DIR}"/openjdk-11.tar.gz \
  -C "${OPEN_JDK_11_PATH}" \
  --strip-components=1

sudo chown -R root:root "${OPEN_JDK_11_PATH}"

# ------------------------------------------------------------------------------------------------------------------

# update-alternatives 명령어로 offline 설치 | openjdk-11
sudo update-alternatives --install "/usr/local/bin/javac" "javac" "${OPEN_JDK_11_PATH}/bin/javac" 11
sudo update-alternatives --install "/usr/local/bin/java" "java" "${OPEN_JDK_11_PATH}/bin/java" 11

# java, javac 실행파일들의 symbolic link 를 '/usr/local/bin' 경로에 생성 / 실행권한 부여
sudo chmod a+x /usr/local/bin/java
sudo chmod a+x /usr/local/bin/javac

# JDK 한개 설치 시
# $ sudo update-alternatives --config java
# > There is only one alternative in link group java (providing /usr/local/bin/java): /opt/java/openjdk-11/bin/java
# > 설정할 것이 없습니다.

# update-alternatives 명령어로 offline 설치 | openjdk-8
sudo update-alternatives --install "/usr/local/bin/javac" "javac" "${OPEN_JDK_8_PATH}/bin/javac" 8
sudo update-alternatives --install "/usr/local/bin/java" "java" "${OPEN_JDK_8_PATH}/bin/java" 8

# ------------------------------------------------------------------------------------------------------------------

# 여러 버전의 JDK 설치 확인
sudo update-alternatives --display java
sudo update-alternatives --display javac

# Base JDK 설정
sudo update-alternatives --config java
sudo update-alternatives --config javac
> Press <enter> to keep the current choice[*], or type selection number: [Selection_NUM]

# JDK Version 확인
java -version
