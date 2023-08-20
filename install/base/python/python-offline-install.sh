#!/bin/bash

# Python official site : https://www.python.org/downloads/source/
# Install Method : C Compile

##########################################################################################################################################
# ​선행조건 | Python 의존 패키지 설치 
##########################################################################################################################################

# APT 필수 패키지 Update
echo -e "\n[ INFO ]  apt-get update\n" && \
sudo apt-get update -y

# APT 필수 패키지 Install
echo -e "\n[ INFO ]  Python 의존 패키지 Install\n" && \
DEBIAN_FRONTEND=noninteractive \
sudo apt-get install -y --no-install-recommends \
    build-essential zlib1g-dev libncurses5-dev \
    libgdbm-dev libnss3-dev libssl-dev \
    libreadline-dev libffi-dev libsqlite3-dev libbz2-dev

# APT 필수 패키지 Upgrade
echo -e "\n[ INFO ]  apt-get upgrade\n" && \
sudo apt-get upgrade -y

### APT 불필요한 패키지 Clean
sudo apt-get clean -y && \
sudo rm -rf /var/lib/apt/lists/*

##########################################################################################################################################
# 1. 인터넷 가능한 Linux 서버 ( 예 : WSL2 ) 에서 Python 다운로드
##########################################################################################################################################

# Python 다운로드 경로 | File : Python-3.8.15.tgz | 2022-10-11
PYTHON_38_DOWNLOAD_URL=https://www.python.org/ftp/python/3.8.15/Python-3.8.15.tgz

# Python 다운로드 경로 | File : Python-3.8.15.tgz | 2022-10-11
PYTHON_39_DOWNLOAD_URL=https://www.python.org/ftp/python/3.9.15/Python-3.9.15.tgz

# 다운로드시 사용할 임시 작업 디렉토리
WORK_DIR=~/tmp
[ -d "${WORK_DIR}" ] || mkdir -p "${WORK_DIR}"

# Python38 다운로드
curl -G -k \
  -o "${WORK_DIR}"/python38.tgz \
  -L "${PYTHON_38_DOWNLOAD_URL}"

# Python39 다운로드
curl -G -k \
  -o "${WORK_DIR}"/python39.tgz \
  -L "${PYTHON_39_DOWNLOAD_URL}"


##########################################################################################################################################
# 2. Python 설치할 서버에 접속 후 위에서 다운로드 받은 파일들을 서버 내 작업 디렉토리에 직접 업로드
##########################################################################################################################################

# 설치파일 업로드 / offline 설치시 사용할 임시 작업 디렉토리 생성
WORK_DIR=~/tmp
[ -d "${WORK_DIR}" ] || mkdir -p "${WORK_DIR}"

# 임시 작업 디렉토리에 *.tgz 파일 업로드

##########################################################################################################################################
# 3. 임시 작업 디렉토리에 업로드된 파일 기반으로 offline 설치
##########################################################################################################################################

# '/opt/python' 경로에 버전별로 다양한 python을 설치/사용할 수 있도록 구성한다.

# Python38 압축 해제
PYTHON_38_INSTALL_PATH=/opt/python/python38
[ -d "${PYTHON_38_INSTALL_PATH}" ] || sudo mkdir -p "${PYTHON_38_INSTALL_PATH}"

sudo tar -zxf "${WORK_DIR}"/python38.tgz \
  -C "${PYTHON_38_INSTALL_PATH}" \
  --strip-components=1

sudo chown -R root:root "${PYTHON_38_INSTALL_PATH}"

# Python39 압축 해제
PYTHON_39_INSTALL_PATH=/opt/python/python39
[ -d "${PYTHON_39_INSTALL_PATH}" ] || sudo mkdir -p "${PYTHON_39_INSTALL_PATH}"

sudo tar -zxf "${WORK_DIR}"/python39.tgz \
  -C "${PYTHON_39_INSTALL_PATH}" \
  --strip-components=1

sudo chown -R root:root "${PYTHON_39_INSTALL_PATH}"

# ------------------------------------------------------------------------------------------------------------------

PYTHON_39_INSTALL_PATH=/opt/python/python39
cd "${PYTHON_39_INSTALL_PATH}"

# 설치파일(Makefile) 생성 | Python3.9
echo -e "\n[ INFO ]  Create Makefile\n" && \
sudo "${PYTHON_39_INSTALL_PATH}"/configure --enable-optimizations \
  --prefix="${PYTHON_39_INSTALL_PATH}"

# 컴파일 | Python3.9
echo -e "\n[ INFO ]  Compile\n" && \
sudo make -j 16 \
  -C "${PYTHON_39_INSTALL_PATH}"

# 설치 | Python3.9
echo -e "\n[ INFO ]  Install\n" && \
sudo make altinstall \
  -C "${PYTHON_39_INSTALL_PATH}"

# alternatives 등록 | Python3.9
echo -e "\n[ INFO ]  alternatives\n" && \
sudo update-alternatives --install "/usr/local/bin/python" "python" "${PYTHON_39_INSTALL_PATH}/python" 39
sudo update-alternatives --install "/usr/local/bin/python3" "python3" "${PYTHON_39_INSTALL_PATH}/python" 39
sudo update-alternatives --install "/usr/local/bin/pip" "pip" "${PYTHON_39_INSTALL_PATH}/bin/pip3.9" 109
sudo update-alternatives --install "/usr/local/bin/pip3" "pip3" "${PYTHON_39_INSTALL_PATH}/bin/pip3.9" 109

# Python 실행파일의 symbolic link 를 '/usr/local/bin' 경로에 생성 / 실행권한 부여
sudo chmod a+x /usr/local/bin/python
sudo chmod a+x /usr/local/bin/python3
sudo chmod a+x /usr/local/bin/pip
sudo chmod a+x /usr/local/bin/pip3

PYTHON_38_INSTALL_PATH=/opt/python/python38
cd "${PYTHON_38_INSTALL_PATH}"

# 설치파일(Makefile) 생성 | Python3.8
echo -e "\n[ INFO ]  Create Makefile\n" && \
sudo "${PYTHON_38_INSTALL_PATH}"/configure --enable-optimizations \
  --prefix="${PYTHON_38_INSTALL_PATH}"

# 컴파일 | Python3.8
echo -e "\n[ INFO ]  Compile\n" && \
sudo make -j 16 \
  -C "${PYTHON_38_INSTALL_PATH}"

# 설치 | Python3.8
echo -e "\n[ INFO ]  Install\n" && \
sudo make altinstall \
  -C "${PYTHON_38_INSTALL_PATH}"

# alternatives 등록 | Python3.8
echo -e "\n[ INFO ]  Install\n" && \
sudo update-alternatives --install "/usr/local/bin/python" "python" "${PYTHON_38_INSTALL_PATH}/python" 38
sudo update-alternatives --install "/usr/local/bin/python3" "python3" "${PYTHON_38_INSTALL_PATH}/python" 38
sudo update-alternatives --install "/usr/local/bin/pip" "pip" "${PYTHON_38_INSTALL_PATH}/bin/pip3.8" 38
sudo update-alternatives --install "/usr/local/bin/pip3" "pip3" "${PYTHON_38_INSTALL_PATH}/bin/pip3.8" 38

# ------------------------------------------------------------------------------------------------------------------

# 여러 버전의 Python 설치 확인
sudo update-alternatives --display python

# Base Python 설정
sudo update-alternatives --config python
> Press <enter> to keep the current choice[*], or type selection number: [SELECTION_NUM]

# Python 확인
python -V
