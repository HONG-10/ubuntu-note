#!/bin/bash

##########################################################################
# Server 
##########################################################################

# Ubuntu 재시작
$ sudo reboot

# Ubuntu 전원 off
$ sudo poweroff

# Server 버전 조회
$ grep . /etc/*-release

##########################################################################
# APT Mirror 변경
##########################################################################
#! Security는 변경 X

$ sudo vi /etc/apt/sources.list

'''
archive.ubuntu.com/ubuntu > mirror.kakao.com/ubuntu(한국) 모두 변경
'''

:%s/[기존_URL]/[변경할_URL]

:%s/kr.archive.ubuntu.com/mirror.kakao.com
:%s/archive.ubuntu.com/mirror.kakao.com


##########################################################################
# APT 필수 패키지 설치
##########################################################################

# APT 필수 패키지 Update
echo -e "\n[ INFO ]  apt-get update\n" && \
sudo apt-get update -y

# APT 필수 패키지 Install
# 상호작용 방지 옵션
# -y (yes|No > yes)  # 버전 추천 아닌 지정
echo -e "\n[ INFO ]  APT 필수 패키지 Install\n" && \
DEBIAN_FRONTEND=noninteractive \
sudo apt-get install -y --no-install-recommends \
    openssh-server curl wget vim make sudo tree \
    zip unzip xz-utils \
    fontconfig locales tzdata \
    gnupg2 apt-transport-https ca-certificates \
    git htop software-properties-common lsb-release \
    bash-completion \
    net-tools
    # containernetworking-plugins \
    # expect github \ 
    # nfs-common cifs-utils

# APT 필수 패키지 Upgrade
echo -e "\n[ INFO ]  apt-get upgrade\n" && \
sudo apt-get upgrade -y

### APT 불필요한 패키지 Clean
sudo apt-get clean -y && \
sudo rm -rf /var/lib/apt/lists/*

##########################################################################
# Time Zone 설정
##########################################################################

echo -e "\n[ INFO ]  \"Asia/Seoul\" timezone 설정\n" && \
sudo ln -fs /usr/share/zoneinfo/Asia/Seoul /etc/localtime && 
sudo dpkg-reconfigure --frontend=noninteractive tzdata

echo -e "\n[ INFO ]  timezone 설정 확인\n" && \
timedatectl

##########################################################################
# Language 설정
##########################################################################

echo -e "\n[ INFO ]  \"ko_KR.UTF-8\" language 설정\n" && \
sudo locale-gen ko_KR.UTF-8 && \
sudo sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
sudo sed -i -e 's/# ko_KR.UTF-8 UTF-8/ko_KR.UTF-8 UTF-8/' /etc/locale.gen && \
echo 'LANG="ko_KR.UTF-8"' | sudo tee /etc/default/locale && \
sudo dpkg-reconfigure --frontend=noninteractive locales && \
sudo update-locale LANG=ko_KR.UTF-8

echo -e "\n[ INFO ]  language 설정 확인\n" && \
locale

##########################################################################
# 관리자(root) 계정 활성화
##########################################################################
# root 계정 비밀번호 설정
$ sudo passwd root
> [sudo] password for rex:
> Enter new UNIX password: ["ROOT 계정 비밀먼호"]
> Retype new UNIX password: ["ROOT 계정 비밀먼호 확인"]
> passwd: password updated successfully

# root 계정 진입
$ sudo su
