##########################################################################
# dpkg
##########################################################################
# Package 리스트 확인
$ dpkg -l
$ dpkg -l | grep [PACKAGE_NM]

$ dpkg --get-selections

# 해당 패키지로부터 설치된 모든 파일목록 확인
$ dpkg -L [PACKAGE_NM]

# 해당 .deb 파일이 설치한 파일의 목록 확인
$ dpkg -C [.deb FIME_NM]

# 해당 .deb 파일에 대한 정보 확인
$ dpkg -I [.deb FIME_NM]

# 해당 패키지에 대한 정보 확인
$ dpkg -s [PACKAGE_NM]

# 해당 파일명 또는 경로가 포함된 패키지들을 검색
$ dpkg -S [FILE_NM]

# 해당 파일 설치 또는 최신 버전으로 업그레이드
$ dpkg -i [.deb FIME_NM]

# 해당 패키지 삭제 
$ sudo dpkg -r [PACKAGE_NM]     # 패키지만 삭제
$ sudo dpkg -P [PACKAGE_NM]     # 패키지 + 설정파일 삭제
