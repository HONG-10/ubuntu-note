##########################################################################
# Ubuntu Fire Wall | UFW
##########################################################################

# UFW 확인
$ ufw status verbose

# UFW 활성화
$ ufw enable

# UFW 비활성화
$ ufw disable

##########################################################################
# UFW 허용 & 차단
##########################################################################
# UFW 허용
$ ufw allow [PORT]/[PROTOCAL]

$ ufw allow 22
$ ufw allow 22/tcp
$ ufw allow 22/udp

$ ufw allow from [IP_ADDRESS]
$ ufw allow from 192.168.0.100
$ ufw allow from 192.168.0.0/24

$ ufw allow from [IP_ADDRESS] to [PROTOCOL] [PORT] [PORT_NUM]
$ ufw allow from 192.168.0.100 to any port 22

$ ufw allow from [IP_ADDRESS] to [PROTOCOL] [PORT] [PORT NUM] proto [PROTOCOL_NM]
$ ufw allow from 192.168.0.100 to any port 22 proto tcp


# UFW 차단
$ ufw deny [PORT]/[PROTOCAL]

$ ufw deny 22
$ ufw deny 22/tcp
$ ufw deny 22/udp


##########################################################################
# Remove UFW Rule 
##########################################################################
$ ufw delete [설정한 Rule]
$ ufw delete deny 22/tcp

##########################################################################
# UFW Rule Numbering
##########################################################################
$ ufw status numbered

$ ufw delete 1
$ ufw insert 1 allow from 192.168.0.100

##########################################################################
# UFW Service Name Rule
##########################################################################
$ less /etc/services
$ ufw allow [SERVICE_NM]
$ ufw deny [SERVICE_NM]

##########################################################################
# UFW 로그 기록
##########################################################################
$ ufw logging on
$ ufw logging off

##########################################################################
# ping (icmp) 허용/거부
##########################################################################
# UFW Default : ping 요청 허용
sudo vi /etc/ufw/before.rules

    "
    # ok icmp codes
    -A ufw-before-input -p icmp --icmp-type destination-unreachable -j ACCEPT
    -A ufw-before-input -p icmp --icmp-type source-quench -j ACCEPT
    -A ufw-before-input -p icmp --icmp-type time-exceeded -j ACCEPT
    -A ufw-before-input -p icmp --icmp-type parameter-problem -j ACCEPT
    -A ufw-before-input -p icmp --icmp-type echo-request -j ACCEPT
    "
    to
    "
    # ok icmp codes
    -A ufw-before-input -p icmp --icmp-type destination-unreachable -j DROP
    -A ufw-before-input -p icmp --icmp-type source-quench -j DROP
    -A ufw-before-input -p icmp --icmp-type time-exceeded -j DROP
    -A ufw-before-input -p icmp --icmp-type parameter-problem -j DROP
    -A ufw-before-input -p icmp --icmp-type echo-request -j DROP
    "

##########################################################################
# example
##########################################################################
$ sudo ufw enable
$ sudo ufw allow from 192.168.0.3 to any port 22 proto tcp
$ sudo ufw allow 123/udp
$ sudo ufw allow 80/tcp
$ sudo ufw allow 3306/tcp
$ sudo ufw status

