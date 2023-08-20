#? 네트워크	
#? host
#? nslookup
#? rlogin
#? netcat
#? traceroute
#? inetd

#? ssh
#? ip
#? ifconfig
#? netstat
#? ping
#? dig



nftables <- iptables(강화된 버전)

##########################################################################
# 원격 접속 | ssh
##########################################################################


##########################################################################
# Network Manager | nmcli, nmtui, nm-connection-editor
##########################################################################
#? nmcli con sh --> 명령어 기반 관리도구(자동화)
#? nmtui --> 텍스트 기반 관리도구





##########################################################################
# 네트워크 확인 | ip, ifconfig, route
##########################################################################
#! ifconfig(namespace 지원안됨) --> ip
#! route(namespace 지원안됨) --> ip r

# 구성된 NIC의 아이피 정보 및 NIC상태 확인
$ ip address show

# 여기에서 구성되는 아이피 정보는 일시적으로 시스템에서 저장. 재시작 시 해당 내용은 제거. 반드시 네트워크 설정은 NetworkManager에서 구성해야 됨.
$ ip address add <DEV>

$ ip a add
$ ip a s eth1
$ nmcli connection show eth1
$ nmcli device

# 연결이 되어 있는 NIC카드 정보
$ ip link

# 현재 구성이 되어있는 라우팅 테이블 정보
$ ip route

$ ip monitor

##########################################################################
# 네트워크 상태 확인 | ss, netstat
##########################################################################
#! netstat(namespace 지원안됨, 느림) --> ss
# net-tools 설치
$ apt install -y net-tools

# 사용 포트 확인 (TCP)
$ netstat -nltp
$ netstat -nltp | grep [PORT_NUM]

# 사용 포트 확인 (UDP)
$ netstat -unl

$ netstat -st # s(ip, icmp, udp별의 상태 확인), t(tcp로 연결된 리스트)

$ ss -antp
$ ss -tl




##########################################################################
# 네트워크 연결 확인 | ping (Packet InterNet Groper)
##########################################################################
# iputils-ping 설치
# $ apt install -y iputils-ping

$ ping [IP_ADDRESS]
$ ping [URI]

$ ping -c 2 [URI]


##########################################################################
# 도메인 연결 확인 | dig (Domain Information Groper)
##########################################################################
# dnsutils 설치
# $ apt -y install dnsutils

$ dig [DNS_NM]


