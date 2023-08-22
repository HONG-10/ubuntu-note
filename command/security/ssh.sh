##########################################################################
# 선행 조건
##########################################################################
# 현재 상태 확인
sudo service ssh status

# ssh server 설치
sudo apt install openssh-server

# ssh service 재실행
sudo service ssh restart

# 확인
dpkg --get-selections | grep ssh


##########################################################################
# Step. 1 Local Server (Client) - ssh 인증키 발급
##########################################################################
# Local Server : 접속 허가를 받을 서버
# Client : 접속 허가를 받을 주체, 비밀키를 보유해야함

# ~/.ssh/id_rsa.pub (PUBLIC KEY | 공개키)
# ~/.ssh/id_rsa (PRIVATE KEY | 비밀키)

#! 실행 계정(Client)에 ssh 인증키 발급
$ sudo su - [USER_NM]
$ ssh-keygen -t rsa             # $ ssh-keygen -t dsa -C ["COMMENT"]
> 1. key 이름 입력 {Enter}
> 2. 비밀번호 입력 <[PASSWORD]>
> 3. 비밀번호 확인 <[PASSWORD]>

$ cat ~/.ssh/id_rsa.pub
> [PUBLIC_KEY]              #@ Public Key 복사 | 맨 마지막 계정@IP or 계정@HostName 확인


##########################################################################
# Step. 2 Destination Server - id_rsa.pub 등록
##########################################################################
# Destination Server : 접속 허가를 해줄 서버

$ vi ~/.ssh/authorized_keys
```
[PUBLIC_KEY] 입력
```
Ref
https://m.blog.naver.com/ramtol/221782016378


##########################################################################?
#? Step. 3 Local Server (Client) | ssh 접속
##########################################################################?
$ ssh -i [PRIVATE KEY_NM] [USER_NM]@[IP_ADDRESS] -p [PORT_NUM]
> 비밀번호 입력


##########################################################################?
#? Step. 4 Client(Local Server) | ssh 설정
##########################################################################?
$ vi ~/.ssh/config

'''
Host [HOST_NM]
    HostName [IP_ADDRESS]
    User [USER_NM]
    Port [PORT_NUM]
    IdentityFile ~/.ssh/[PRIVATE KEY_NM]

'''

$ chmod -R 440 config


##########################################################################?
#? etc. ssh 실행
##########################################################################?
$ ssh [DESTINATION_USER_NM]@[DESTINATION_IP]

# shell 입력 
$ ssh [DESTINATION_USER_NM]@[DESTINATION_IP] "
  
/data/diplwapl/tomcat/www.diplwapl.com/bin/tomcat.sh stop

sleep 5

/data/diplwapl/tomcat/www.diplwapl.com/bin/tomcat.sh start

"


##########################################################################@
#@ Step. 3 Local Server - ssh 접속 & sftp 전송
##########################################################################@
#! 이떄 사용하려는 계정으로 시도해야 함.
$ sudo su - [USER_NM]

# sftp
$ sftp [DESTINATION_USER_NM]@[DESTINATION_IP]
> Are you sure to continue connecting --> <yes>           #? yes 입력 시 Local Server .ssh/known_hosts에 Destination Server IP 등록 
> [Permanently added x.x.x.x to the list of known hosts.]

#* 최초 접속을 하지 않으면 Verification Error 발생.
#* 기존 인증키로 접속할 Destination IP가 변경된다면 known_hosts 파일에 등록된 IP를 삭제한 뒤 다시 위와같이 접속 해 준다.


##########################################################################@
#@ Step. 4 sftp 실행
##########################################################################@
#! -oPort 는 생략 가능. SFTP 포트가 22가 아닌경우 명시할것
# 파일 지정
$ sftp -oPort=22 [DESTINATION_USER_NM]@[DESTINATION_IP] << EOF
cd [DESTINATION_ABSOLUTE_PATH]
lcd [LOCAL_ABSOLUTE_PATH]
put [FILE_NM]
quit
EOF

# 디렉토리 지정
$ sftp [DESTINATION_USER_NM]@[DESTINATION_IP] << EOF
cd [DESTINATION_ABSOLUTE_PATH]
lcd [LOCAL_ABSOLUTE_PATH]
put -r [DIRECTORY_NM]
quit
EOF

