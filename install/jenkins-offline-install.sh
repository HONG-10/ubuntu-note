#!/bin/bash
# jenkins 설치 선행 조건 : nettools

##########################################################################################################################################
# 1. 인터넷 가능한 Linux 서버 ( 예 : WSL2 ) 에서 net-tools, jenkins 다운로드
##########################################################################################################################################

# net-tools 다운로드 경로
NET_TOOLS_DOWNLOAD_URL=http://archive.ubuntu.com/ubuntu/pool/main/n/net-tools/net-tools_1.60+git20180626.aebd88e-1ubuntu1_amd64.deb

# jenkins 다운로드 경로 : jenkins_2.332.2_all.deb ( 2022-04-06 )
JENKINS_DOWNLNAD_URL=https://mirror.esuni.jp/jenkins/debian-stable/jenkins_2.332.2_all.deb

# 다운로드시 사용할 임시 작업 디렉토리
WORK_DIR=~/tmp
[ -d "${WORK_DIR}" ] || mkdir -p "${WORK_DIR}"

# net-tools.deb 다운로드
curl -G -k \
  -o "${WORK_DIR}"/net-tools.deb \
  -L "${NET_TOOLS_DOWNLOAD_URL}"

# jenkins.deb 다운로드
curl -G -k \
  -o "${WORK_DIR}"/jenkins.deb \
  -L "${JENKINS_DOWNLNAD_URL}"

##########################################################################################################################################
# 2. jenkins 설치할 서버에 접속 후 위에서 다운로드 받은 파일들을 서버 내 작업 디렉토리에 직접 업로드한다.
##########################################################################################################################################

# 설치파일 업로드 / offline 설치시 사용할 임시 작업 디렉토리 생성
WORK_DIR=~/tmp
[ -d "${WORK_DIR}" ] || mkdir -p "${WORK_DIR}"

# 임시 작업 디렉토리에 *.tar.gz, *.deb 파일들을 업로드한다.

##########################################################################################################################################
# 3. 임시 작업 디렉토리에 업로드된 파일 기반으로 offline 설치
##########################################################################################################################################

# (1) net-tools : offline 설치
sudo dpkg -i \
  "${WORK_DIR}"/net-tools.deb

# (2) jenkins : offline 설치
sudo dpkg -i \
  "${WORK_DIR}"/jenkins.deb

# jenkins User 에 sudo 실행시 nopassword 권한 부여
echo 'jenkins ALL=NOPASSWD: ALL' | sudo tee /etc/sudoers.d/jenkins-nopasswd

# 보안상 0440 으로 설정
sudo chmod 0440 /etc/sudoers.d/jenkins-nopasswd

# jenkins 초기 비밀번호 확인
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

# jenkins.service port 변경
sudo systemctl edit jenkins
  '''
  [Service]
  Environment="JENKINS_PORT=9092"
  '''

# jenkins 재시작
sudo systemctl daemon-reload
sudo systemctl restart jenkins

####################################################################################

sudo mkdir -p /jenkins-dependencies/.gradle
sudo mkdir -p /jenkins-dependencies/.m2

sudo chown -R jenkins:jenkins /jenkins-dependencies

# 1. jenkins 접속 후 admin 계정의 비밀번호 변경 / User Defined Time Zone 값 'Asia/Seoul' 로 변경

# 2. 'Jenkins 관리' => 'Global Tool Configuration'
# - 'JDK' : openjdk-8, openjdk-11 등록

# 3. 'Jenkins 관리' => '환경 설정'
# - 'Global properties' 세팅
#   => GRADLE_USER_HOME : /jenkins-dependencies/.gradle
# - Usage Statistics : 'Help make Jenkins better by sending anonymous usage statistics and crash reports to the Jenkins project.' 체크 해제

# 4. 필수 plugin 설치: pipeline, bitbucket, Conditional BuildStep
