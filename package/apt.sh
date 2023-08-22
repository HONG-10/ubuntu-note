##########################################################################
# APT | Advanced Package Tool
##########################################################################
# APT 데비안 계열 OS (ubuntu, ..) Package 매니저
# apt == apt-get (구버전)
# apt (Core) = apt-get (Full)

# Package 리스트 확인
$ apt list
$ apt list --installaed         # 설치된 Package 리스트 확인
$ apt list --upgradable         # Upgrade 필요한 Package 리스트 확인

# Package 리스트 최신화 (저장소 업데이트)
$ apt update

#? Hit : 변경사항 없음.
#? Ign : 무시
#? Get : 변경사항 있음.

# Package 최신화 리스트 업그레이드 (실제 프로그램 업데이트)
$ apt upgrade

# Package 설치
$ apt install [PACKAGE_NM]
$ apt -f install    # 의존성 확인

# Package 삭제
$ apt remove [PACKAGE_NM]
$ apt purge [PACKAGE_NM]    # Package 삭제 시 설정파일 동시에 삭제
$ apt autoremove            # 불필요한 Package 자동 삭제
$ apt clean                 # /var/cache/apt/archives 디렉토리에 다운로드한 파일을 삭제

# 설치된 Package 찾기
$ apt search [PACKAGE_NM]
$ apt-cache search [PACKAGE_NM]

# Package 정보 출력
$ apt show [PACKAGE_NM]

# 도움말 출력
$ apt --help


##########################################################################
# APT | 중앙 저장소 변경
##########################################################################
$ vi /etc/apt/sources.list

'''
archive.ubuntu.com/ubuntu > mirror.kakao.com/ubuntu(한국) 모두 변경
'''

vim
:%s/[기존 URL]/[변경할 URL]
:%s/kr.archive.ubuntu.com/mirror.kakao.com
:%s/archive.ubuntu.com/mirror.kakao.com

- Security는 변경 X


##########################################################################
# APT | 중앙 저장소 변경
##########################################################################

# 0. Package 리스트 확인
$ sudo apt list

# 1. Package 리스트 최신화
$ sudo apt update

# 1-1. 업그레이드 필요한 목록 확인
$ sudo apt list --upgradable

# 2. Package 실제 업그레이드
$ sudo apt upgrade


##########################################################################
# APT | 의존성 확인
##########################################################################
# 패키지 의존성 확인
$ sudo apt-get install -y apt-rdepends
$ apt-redepends [PACKAGE_NM]

# 실행파일 의존성 확인
$ ldd [EXE_PATH]
$ ldd /usr/bin/nano

# $ apt-get clean
# $ apt-get install -f
# $ dpkg --configure -a
# $ apt-get update


apt-get install p7zip
apt-cache search 7z

##########################################################################
# Repository 추가 | add-apt-repository
##########################################################################
# 설치
$ sudo apt-get install software-properties-common

# Repository 추가
$ sudo add-apt-repository ppa:[REPOSITORY_NM]
$ sudo add-apt-repository ppa:deadsnakes/nightly
$ sudo apt-get update -y

##########################################################################
# Repository 검색 | apt-cache
##########################################################################

# Keyword가 Package Name or Info에 포함된 Package 검색
$ sudo apt-cache search [KEYWORD]

# Keyword로 시작되는 Package 검색
$ sudo apt-cache pkgnames [KEYWORD]

# Package 의존성 확인
$ sudo apt-cache depends [PACKAGE_NM]

# Package를 의존하는 Package 확인
$ sudo apt-cache rdepends [PACKAGE_NM]

# Package 정보 확인
$ sudo apt-cache showpkg [PACKAGE_NM_1] [PACKAGE_NM_2] ...
$ sudo apt-cache show [PACKAGE_NM]

# Package Version 정보 확인
$ sudo apt-cache policy [PACKAGE_NM]

##########################################################################
# apt-key 등록 | apt-key
##########################################################################

# apt-key List 확인
$ sudo apt-key list

# apt-key 등록
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# apt-key 등록 확인
sudo apt-key fingerprint

sudo apt-key adv --fetch-keys <key가 필요한 repository url>/<아까 찾은 public key>.pub


##########################################################################
# Repository 추가 | add-apt-repository
##########################################################################
# 설치
$ sudo apt-get install software-properties-common

$ sudo add-apt-repository ppa:deadsnakes/nightly

$ sudo apt-get update -y
