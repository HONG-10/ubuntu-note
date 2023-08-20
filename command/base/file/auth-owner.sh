##########################################################################
# 권한과 소유
##########################################################################
# 엑세스 권한 수정

#* -[rwx]{rw-}(r--) : 파일
#* d[r--]{rwx}(rw-) : 디렉토리
#* l[rw-]{r--}(rwx) : 링크

#* b : 블록장치
#* c : 캐릭터 장치
#* l : 소프트 링크 (바로가기)

#* [] : Owner User | 파일 생성자
#* {} : Owner Group | 파일 생성자가 속한 그룹(사용자)
#* () : Other User | 그 밖의 사용자

#* r : Read
#* w : Write
#* x : Execute
#* X : 


#! Execute -> Read -> Write

# Options
#* -R, --recursive : 특정 디렉터리 내의 파일과 디렉터리에 대해 재귀적으로 허가권 변경
#* -C, --changes : 변경된 파일이나 디렉터리에 대한 자세한 정보를 출력
#* -f , --silent, --quite : 대부분의 에러메시지 출력을 제한
#* --reference : 모드 대신 파일에 지정한 모드를 사용 

##########################################################################
# 권한 (Permission) | chmod
##########################################################################

###########################? numeric method 
$ chmod [OPTION] [NUMERIC] [FILE_NM]
$ chmod [OPTION] [NUMERIC] [DIR_NM]

# Options
# 상동

# NUMERIC
#* r : 4
#* w : 2
#* x : 1

#* rwx : 7 (4+2+1)
#* rw- : 6 (4+2)
#* r-x : 5 (4+1)
#* r-- : 4
#* -wx : 3 (2+1)
#* -w- : 2
#* --x : 1
#* --- : 0

$ chmod 755 docker.sh
$ sudo chmod -R 755 "${NEXUS_OPEN_JRE_8_PATH}"          #  jre 의 permission 을 755 로 변경하여 다른 계정도 조회 가능하도록 설정할 것

# 특수 권한
#* 4--- : Set UID | 사용자의 권한이 있어야만 실행을 할 수 있는 파일의 경우, 그 권한을 일시적으로 일반사용자들에게 파일 실행권한을 부여하기 위해 사용한다.
#*                  파일에 Set-UID 비트가 설정되면 다른 사용자가 파일을 실행했을때 해당 사용자의 권한이 아닌 파일의 소유자 권한으로 실행.
#* 2--- : Set GID | 그룹의 권한이 있어야만 실행을 할 수 있는 파일의 경우, 그 권한을 일시적으로 일반 사용자들에게도 부여하여 파일을 실행 할 수 있게 한다.
#*                  파일에 설정하면 사용자그룹이 아닌 해당 파일그룹으로 실행디렉터리에 지정하면 하나의 디렉터리를 두고 여러 사용자가 공동작업하기 편함.
#* 1--- : Sticky Bit | 디렉토리(d---------)에만 설정 가능 , 공유디렉토리로 사용하고자 할 때 쓰인다.
#* sticky-bit가 설정된 디렉토리에 파일을 생성하면 해당 파일은 생성한 사람의 소유가 되며, 오직 소유자와 root에게만 해당 파일에 대한 삭제 및 변경의 권한이 있다.
#* 0--- :

$ sudo chmod 0440 /etc/sudoers.d/jenkins-nopasswd       # 보안상 0440 으로 설정

###########################! symbolic method
$ chmod [OPTION] [OWNERSHIP] [SYMBOL] [PERMISSION] [FILE_NM]
$ chmod [OPTION] [OWNERSHIP] [SYMBOL] [PERMISSION] [DIR_NM]

# Options
# 상동

# OWNERSHIP
# u : User
# g : Group
# o : Other
# a : all

# SYMBOL
# + : 권한 추가 (add)
# - : 권한 제거 (remove)
# = : 권한으로 초기화 (force)

# PERMISSION
# r : Read
# w : Write
# x : Execute/Access


$ chmod +x gradlew

##########################################################################
# 소유권 (Ownership) | chown
##########################################################################
# 파일(디렉토리) 소유권 변경
$ sudo chown [OPTIONS] [OWNER_NM]:[GROUP_NM] [FILE_NM]

$ sudo chown root catalina.out
$ sudo chown -R "${NEXUS_USER}:${NEXUS_USER_GROUP}" "${NEXUS_HTTPS_CONFIG_PATH}"
$ sudo chown -R root:root "${OPEN_JDK_11_PATH}"
$ sudo chown -Rcf root:root "${OPEN_JDK_11_PATH}"

# -f 오류가 발생할때 화면에 오류 메시지만 출력
# -c changes 
# -R 재귀변경 디렉토리 안에 파일 모두 퍼미션 변경
# --no-proeserve-root root 방지
##########################################################################
# 소유그룹 | chown & chgrp
##########################################################################
# 파일(디렉토리) 소속그룹 변경
$ sudo chown [OPTIONS] .[GROUP_NM] [FILE_NM]
$ sudo chgrp [OPTIONS] [GROUP_NM] [FILE_NM]

$ sudo chgrp -R colors color_files
