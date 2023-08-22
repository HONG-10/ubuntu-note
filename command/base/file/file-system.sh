##########################################################################
# 파일 시스템 탐색
##########################################################################
$ cd /      # 최상위 경로
$ cd ~      # home 경로
$ cd ./     # 현재 경로
$ cd ../    # 상위 경로
$ cd -      # 이전 경로
$ cd -P     # 피지컬 경로

$ ls        # List Segments 탐색
$ ls -al    # -a(all) -l(long) -S(size) -r(reverse) -R(recursive) -h(human *파일 크기 K, M, G 단위로 변경) -
$ ls -lR

$ pwd       # Print Working Directory 현재 작업 중인 폴더 출력
$ pwd -P    # 피지컬 경로 옵션


##########################################################################
# 디렉토리 생성 및 삭제
##########################################################################
$ mkdir [디렉토리명]    # 새 디렉토리 생성
$ mkdir -p [디렉토리명]/[디렉토리명]/[디렉토리명]   # 모든 경로 생성 (부모 디렉토리도 없으면 생성) 
$ mkdir -m 755 [디렉토리명]
$ mkdir -m u=rwx,g=rx,o= -Z --context -p [디렉토리명]     # Z 경우에는 SELinux 컨텍스트


$ rmdir [디렉토리명]    # 비어있는 디렉토리 삭제

##########################################################################
# 디렉토리 권한 및 삭제
##########################################################################
# 권한 확인
$ lsattr [디렉토리명]
$ lsattr [FILE_NM]

# 권한 부여
$ chattr <Options> [MODE][PROPERTY] [디렉토리명]
$ chattr <Options> [MODE][PROPERTY] [FILE_NM]

# Mode
#* + : 속성 추가
#* - : 속성 제거
#* = : 속성 유지

# Property
#* a : 파일을 추가모드로만 열수 있다. 단, vi 편집기로는 내용을 추가 할 수 없게 된다.
#* c : 압축되어 있는 상태로 저장함.
#* d : dump 명령을 통하여 백업받을 경우 백업받지 않습니다.
#* i :  파일을 read-only로만 열 수 있게 설정합니다. 링크로 허용하지 않고 루트만이 이 속성을 제거 할 수 있습니다.
#* s : 파일 삭제가 될 경우에 디스크 동기화가 일어나는 효고가가 발생합니다.
#* S : 파일이 변경 될 경우에 디스크 동기화가 일어나는 효과가 발생합니다.
#* u : 파일이 삭제가 되엇을 경우에는 그 내용이 저장이 되며 삭제되기 전의 데이터로 복구가 가능해 집니다.

$ sudo chattr +i /etc/resolv.conf

##########################################################################
# 마운트 | mount
##########################################################################
# $ sudo apt-get install cifs-utils
# $ sudo apt-get install nfs-common

$ mount -t nfs [REMOTE_FILE_SYSTEM]:[REMTOE_DIR] [LOCAL_DIR]
$ mount -t nfs 10.10.10.10:/data/shared /data/shared
$ mount -t nfs 10.10.10.10:/data2 /data2


##########################################################################
# 재부팅 시 mount 자동연결 | fstab
##########################################################################


##########################################################################
# 블록장치 트리 구조 출력 | lsblk
##########################################################################
$ lsblk
$ lsblk -t
$ lsblk -l



##########################################################################
# pushd / popd
##########################################################################
pushd 

dirs