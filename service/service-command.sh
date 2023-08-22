##########################################################################
# Service 제어
##########################################################################
# Service 시작
$ service [SERVICE_NM] start
$ systemctl start [SERVICE_NM]

# Service 종료
$ service [SERVICE_NM] stop
$ systemctl stop [SERVICE_NM]

# Service 재시작
$ service [SERVICE_NM] restart

# Service 갱신
$ service [SERVICE_NM] reload

# Service 상태 확인
$ service [SERVICE_NM] status

# Booting 시 자동시작 등록 & Daemon Reload
$ sudo systemctl enable [SERVICE_NM]
$ sudo systemctl daemon-reload

$ sudo systemctl enable --now [SERVICE_NM]  # 한번에 처리
> Created symlink from /etc/systemd/system/multi-user.target.wants/test.service to /etc/systemd/system/test.service.


##########################################################################
# Service 관리
##########################################################################
# 시스템 전체 Service 호출
$ service --status-all
$ service --status-all | grep +

[ + ] | running
[ - ] | stopped service
[ ? ] | managed by upstart

# Service 상태 확인
$ systemctl status [SERVICE_NM]
$ systemctl status [SERVICE_NM] | tail -n 300
> ● test.service - Service Register Test
>    Loaded: loaded (/etc/systemd/system/test.service; enabled; vendor preset: disabled)
>    Active: inactive (dead) since 금 2020-05-08 15:39:36 KST; 7s ago
>   Process: 26086 ExecStart=/home/platform/test.sh (code=exited, status=0/SUCCESS)
>  Main PID: 26086 (code=exited, status=0/SUCCESS)

# Service Active 상태 확인
$ systemctl is-active [SERVICE_NM]


##########################################################################
# Service 제거
##########################################################################

# Service 중지
$ sudo systemctl stop [SERVICE_NM].service

# Service 비활성화
$ sudo systemctl disable [SERVICE_NM].service

# Service 설정 파일 삭제
$ sudo rm -f /etc/systemd/system/[SERVICE_NM].service

# Service Daemon Reload (*.service 파일 읽어서 등록)
$ sudo systemctl daemon-reload

$ sudo systemctl reset-failed


##########################################################################
# Nginx Service
##########################################################################
# 셧다운 후 재기동 | 문법적 에러가 있을 시 서버 에러 발생
$ service nginx restart

# 변경사항만 반영 (무중단) | 문법적 에러가 있을 시 에러 메시지 반환(무중단) #! 권장
$ service nginx reload      


##########################################################################
# Redis Service
##########################################################################
# Redis 시작
$ service redis start

# Redis 종료
$ service redis stop

# Redis 상태 확인
$ service redis status

# 자동시작
$ sudo systemctl enable redis


##########################################################################
# Docker Service
##########################################################################

# docker 서비스 등록 및 시작
sudo systemctl enable docker && \
sudo systemctl start docker

# docker 서비스 상태 확인
sudo systemctl status docker

# docker 서비스 재기동
systemctl restart docker


##########################################################################
# Elasticsearch Service
##########################################################################
# Elasticsearch Service 시작
$ systemctl start elasticsearch

# Elasticsearch Service 중지
$ systemctl stop elasticsearch


--- 추후 다른 곳에 정리
##########################################################################
# Elasticsearch
##########################################################################
# Elasticsearch 실행
$ ./bin/elasticsearch


------------- 정보
2. yml 설정 변경 (ES)
3. ES 실행
4. bin/elasticsearch-setup-passwords interactive
(비밀번호 특문 X)


