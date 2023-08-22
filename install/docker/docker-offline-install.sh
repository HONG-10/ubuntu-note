#!/bin/bash
# docker 설치 선행 조건 : openjdk

##########################################################################################################################################
# 1. 인터넷 가능한 Linux 서버 ( 예 : WSL2 ) 에서 docker-ce, docker-ce-cli, containerd.io, docker-compose 다운로드
##########################################################################################################################################

# docker-ce 다운로드 경로 : docker-ce_20.10.14~3-0~ubuntu-focal_amd64.deb ( 2022-03-24 )
DOCKER_CE_DOWNLOAD_URL=https://download.docker.com/linux/ubuntu/dists/focal/pool/stable/amd64/docker-ce_20.10.14~3-0~ubuntu-focal_amd64.deb

# docker-ce-cli 다운로드 경로 : docker-ce-cli_20.10.14~3-0~ubuntu-focal_amd64.deb ( 2022-03-24 )
DOCKER_CE_CLI_DOWNLOAD_URL=https://download.docker.com/linux/ubuntu/dists/focal/pool/stable/amd64/docker-ce-cli_20.10.14~3-0~ubuntu-focal_amd64.deb

# containerd.io 다운로드 경로 : containerd.io_1.5.11-1_amd64.deb ( 2022-03-24 )
CONTAINEDRD_IO_DOWNLOAD_URL=https://download.docker.com/linux/ubuntu/dists/focal/pool/stable/amd64/containerd.io_1.5.11-1_amd64.deb

# docker-compose 버전 ( Ref : https://github.com/docker/compose/releases )
DOCKER_COMPOSE_VERSION='v2.4.1'

# 다운로드시 사용할 임시 작업 디렉토리
WORK_DIR=~/tmp
[ -d "${WORK_DIR}" ] || mkdir -p "${WORK_DIR}"

# docker-ce-cli.deb 다운로드
curl -G -k \
  -o "${WORK_DIR}"/docker-ce-cli.deb \
  -L "${DOCKER_CE_CLI_DOWNLOAD_URL}"

# containerd.io.deb 다운로드
curl -G -k  \
  -o "${WORK_DIR}"/containerd.io.deb \
  -L "${CONTAINEDRD_IO_DOWNLOAD_URL}"

# docker-ce.deb 다운로드
curl -G -k  \
  -o "${WORK_DIR}"/docker-ce.deb \
  -L "${DOCKER_CE_DOWNLOAD_URL}"

# docker-compose 다운로드
curl \
  -o "${WORK_DIR}"/docker-compose \
  -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)"

# 이후 작업 디렉토리에 있는 *.deb 파일들, docker-compose 파일을 로컬로 다운로드한다.

##########################################################################################################################################
# 2. docker 설치할 서버에 접속 후 위에서 다운로드 받은 파일들을 서버 내 작업 디렉토리에 직접 업로드한다.
##########################################################################################################################################

# 설치파일 업로드 / offline 설치시 사용할 임시 작업 디렉토리 생성
WORK_DIR=~/tmp
[ -d "${WORK_DIR}" ] || mkdir -p "${WORK_DIR}"

# 임시 작업 디렉토리에 *.deb 파일들, docker-compose 파일을 업로드한다.

##########################################################################################################################################
# 3. 임시 작업 디렉토리에 업로드된 파일 기반으로 offline 설치
##########################################################################################################################################

# (1) containerd.io : offline 설치
sudo dpkg -i \
    "${WORK_DIR}"/containerd.io.deb

# (2) docker-ce-cli : offline 설치
sudo dpkg -i \
    "${WORK_DIR}"/docker-ce-cli.deb

# (3) docker-ce : offline 설치
sudo dpkg -i \
    "${WORK_DIR}"/docker-ce.deb

# docker 서비스 등록
sudo systemctl enable docker && \
sudo systemctl start docker

# docker 서비스 상태 확인
sudo systemctl status docker

# 설치된 docker 버전 확인
sudo docker version

# 'docker' 그룹 생성 확인 : 보통 도커 설치시 자동으로 추가됨, 없는 경우 'groupadd docker' 명령어로 수동으로 추가
tail /etc/group | grep docker

# (4) 업로드한 docker-compose 파일을 '/usr/local/bin' 경로로 이동 / 실행권한 부여
sudo mv "${WORK_DIR}"/docker-compose /usr/local/bin/docker-compose
#? 직접 다운로드
#? $ sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose

# docker-compose 버전 확인
docker-compose version

