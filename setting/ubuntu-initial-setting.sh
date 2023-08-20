#!/bin/bash

##########################################################################
# Server 
##########################################################################

# ubuntu 재시작
$ sudo reboot

##########################################################################
# Server 버전 조회
##########################################################################
grep . /etc/*-release

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
    sudo curl wget vim make \
    zip unzip xz-utils \
    fontconfig locales tzdata \
    gnupg2 apt-transport-https ca-certificates \
    tree git htop software-properties-common openssh-server
    # containernetworking-plugins \
    # expect github \ 
    # nfs-common cifs-utils
    # net-tools        net-tools는 offline 설치

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

##########################################################################
# 사용자 계정 생성
##########################################################################

$ sudo adduser [USER_NM]

$ sudo passwd [USER_NM]
> 비밀번호 입력
> 비밀번호 확인

# sudoers 수정 | 설정 유효성과 문법 체크를 위해 visudo를 사용헤서 수정
$ sudo visudo

[계정명] [호스트명]=([실행 계정명]) NOPASSWD: [COMMAND]
[USER_NM]   ALL=(ALL:ALL) ALL
# 계정명	명령어 실행 권한을 줄 계정명이나 그룹명. 모두에게 줄 경우 ALL
# 호스트	실행할 대상 서버명이나 IP. 모든 서버가 대상이라면 ALL
# 실행 계정명	명령어를 실행할 때 어떤 계정의 권한을 갖는지 설정하며 생략시 root 로 실행
# NOPASSWD	설정할 경우 명령어를 실행할 때 계정 암호를 물어보지 않음.
# COMMAND	실행을 허용하는 명령어의 경로. ALL 일 경우 모든 명령어를 허용

# 사용자 권한 기술
root ALL=(ALL:ALL) ALL

# admin 그룹의 구성원은 root 권한 획득 가능
%admin ALL=(ALL) ALL

# sudo 그룹의 구성원은 모든 명령어 실행 가능
%sudo ALL=(ALL:ALL) ALL

# 그룹 추가
$ sudo usermod -a -G [GROUP_NM] [USER_NM]

# sudo NOPASSWD 지정해서 생성
USER_NAME=[USER_NM]
USER_PASSWORD=[PASSWORD]

sudo useradd -s /bin/bash -d /home/"${USER_NAME}"/ -m -G sudo "${USER_NAME}"
echo -e "${USER_PASSWORD}\n${USER_PASSWORD}\n" | sudo passwd "${USER_NAME}"
echo "${USER_NAME} ALL=NOPASSWD: ALL" | sudo tee "/etc/sudoers.d/${USER_NAME}-nopasswd"
