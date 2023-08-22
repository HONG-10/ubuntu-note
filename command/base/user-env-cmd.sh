#! 사용자 환경
#! env
#! finger
#! id
#! logname
#! mesg
#! passwd
#! su
#! sudo
#! talk
#! uptime
#! w
#! wall
#! who
#! whoami
#! write

##########################################################################
# 권한 실행 | sudo & su
##########################################################################
# sudo | (substitute user do) or (Super user do)
## 다른 계정(Default: root)의 권한을 빌리는 것
## 현재 계정 PASSWORD 입력
$ sudo
$ sudo [명령어]      # root 권한으로 명령어 엑세스
$ sudo -i           # root 권한 Login & ‘/root’로 이동
$ sudo -s           # root 권한 Login & 현재 path 유지
$ sudo -u           # --user user명


$ sudo su           # 일시적으로 그 명령은 root가 내리는 명령 (root shell 을 직접 실행)
sudo는 잠시 권한만 빌리는 것이기 때문에 근본적으로 명령을 내리는 주체는 현재 로그인한 사용자다.
따라서 생성, 수정, 삭제 등의 이력이 남는 작업을 했을 때 해당 사용자의 ID가 남게 된다.
기본적으로 sudo 명령어를 사용할 수 있는 사용자나 그룹은 /etc/sudoers에 등록이 되어 있어야 가능하다.

##########################################################################
# 권한 실행 | su
##########################################################################
# su | (substitute user) or (switch user)
## 현재 계정 Login 유지하면서 다른 계정(Default: root)으로 변경하는 것
## 전환 계정 PASSWORD 입력

# Options
# -l | --login | -                 : 지정한 사용자의 환경변수를 적용하여 로그인
# -s | --shell [SHELL]             : 지정된 쉘로 로그인
# -c | --command [COMMAND]         : 쉘을 실행하지 않고 지정한 명령어를 실행 (1회성)
# -m | -p | --preserve-environment : 환경 변수를 재설정하지 않고 동일한 셸을 유지 (su와 비슷)

; 차이점
sudo: 현재 계정에서 다른 계정의 권한만 빌림

su: 다른 계정으로 전환

su -: 다른계정으로 전환 + 그 계정의 환경변수 적용

#* su  : root 사용자로 변경, root암호 입력해야함
#* su [사용자명] : 다른 사용자로 변경
#* su - [사용자명] : 다른 사용자로 변경하면서 환경 변수까지 적용

; 상세내용
sudo는 root가 아닌 사용자가 root에 준하는 능력으로 sudo 다음에 나오는 명령을 실행하게 하는 명령어입니다. 
su는 root 패스워드가 필요하지만 sudoer에서 사용을 허락한 사용자는 모두 패스워드와 관계없이 쓸 수 있습니다. sudo는 슈퍼유저,
관리자 권한을 가지지만 근본적으로는 해당 사용자가 내리는 명령입니다.  sudo su는 일시적으로 그 명령은 root가 내리는 명령입니다.
예를 들어 sudo로 작업하면서 디스크에 쓰기를 해야하면 소유자가 지금 사용자로 나옵니다만,
sudo su로 작업하면 소유자가 root가 됩니다. sudo -s는 sudo 만으로 su 명령어와 같은 효과가 나는 명령입니다.
su는 root 암호를 알아야만 쓸 수 있지만,
sudo -s는 sudoer에서 허가된 사용자라면 본인 암호를 넣고 쓸 수 있는 su와 동일한 명령입니다. 
간단히 말하면 sudo -s 를 하고 자기 암호를 넣으면 root로 로그인한 쉘로 전환됩니다. sudo로 가능한 명령어를 지정하는 곳은 sudoer파일에서 설정할 수 있습니다.

; sudo su와 sudo -s 차이점 
sudo su 와 sudo -s 둘 다 root shell 을 사용할 수 있는 명령어이지만,
전자가 계정을 독립적으로 root 로 전환해 버리는 데 반해 (즉 root shell 을 직접 실행) 후자는 현 계정의 모든 환경 변수들을 root 계정 쪽으로 넘긴다는 차이가 있습니다. 그래서 sudo su를 하면 홈 디렉토리가 /root 가 되지만 (이와 동시에 현재 디렉토리 역시 /root 로 바뀝니다),
sudo -s를 하게 되면 홈 디렉토리가 기존 그대로 유지되며,
.bashrc 역시 전자가 $user의 ~/.bashrc 를 읽는데 반해 후자는 /root/.bashrc 를 읽습니다. 이 외에도 몇 가지 차이가 생깁니다.


##########################################################################
# 계정 확인
##########################################################################
$ cat /etc/passwd
$ cut -f1 -d: /etc/passwd
$ grep /bin/bash /etc/passwd    # useradd를 통해 등록된 계정
$ grep /bin/bash /etc/passwd | cut -f1 -d:


##########################################################################
# 계정 생성
##########################################################################
# 1. 로그인 Shell 권한 없는 계정 생성
$ useradd -s /sbin/nologin [USER_NM]

# 2. 패스워드 설정
$ passwd [USER_NM]

useradd -s /sbin/nologin sftp
passwd sftp
ilifocon11

# 3. sshd_config 수정
/etc/ssh/sshd_config 파일에서 아래 라인 수정
수정 전 : Subsystem sftp /usr/libexec/openssh/sftp-server
수정 후 : Subsystem sftp internal-sftp

# 4. SSH 데몬 재기동
service sshd restart


##########################################################################
# 계정 생성
##########################################################################

# sudo 계정 생성
ADMIN_USER='admin'
ADMIN_USER_PASSWORD='admin123#'

sudo useradd -s /bin/bash -d /home/"${ADMIN_USER}"/ -m -G sudo "${ADMIN_USER}"
echo -e "${ADMIN_USER_PASSWORD}\n${ADMIN_USER_PASSWORD}\n" | sudo passwd "${ADMIN_USER}"

# NOPASSWD 권한 부여
echo "${ADMIN_USER} ALL=NOPASSWD: ALL" | sudo tee "/etc/sudoers.d/${ADMIN_USER}-nopasswd"

# (옵션) ssh 설정 변경
sudo tee /etc/ssh/sshd_config.d/custom_sshd.conf << EOF
Port 11122
PasswordAuthentication yes
EOF

sudo service ssh restart

# 비밀번호 변경
passwd [USER_NM]

# 계정 생성
USER_NM=test123
USER_PASSWORD=test123!@#
GROUP_NM='sudo'

sudo useradd -d /home/"${USER_NM}"/ -m -G "${GROUP_NM}" "${USER_NM}"
echo "${USER_NM}":"${USER_PASSWORD}" | /usr/sbin/chpasswd
passwd --expire "${USER_NM}"
# usermod -a -G "${GROUP_NM}" "${USER_NM}"

# 계정 삭제
USER_NM=test123

userdel -r "${USER_NM}"

# 삭제 확인
grep /bin/bash /etc/passwd | grep "${USER_NM}"

##########################################################################
# 그룹 생성 & 그룹 권한 부여
##########################################################################
# 그룹 생성
groupadd [GROUP_NM]

USER_NM=test123
GROUP_NM='sudo'

# 권한 부여
usermod -G "${GROUP_NM}" "${USER_NM}"

# 권한 추가
usermod -a -G "${GROUP_NM}" "${USER_NM}"

# 권한 회수
deluser "${USER_NM}" "${GROUP_NM}"

##########################################################################
# 계정 & 그룹 확인
##########################################################################
grep /bin/bash /etc/passwd

GROUP_NM='sudo'
more /etc/group
grep "${GROUP_NM}" /etc/group


##########################################################################
# 환경변수 | env
##########################################################################
