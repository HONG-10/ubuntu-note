##########################################################################
# Log 확인
##########################################################################

$ logger -p [FACILITY].[PRIORITY] secure-log


$ tail -f /var/log/messages
$ logger default-log

$ tail -f /var/log/secure
$ logger -p authpriv.info secure-log

$ tail -f /var/log/maillog
$ logger -p mail.info mail-log

$ tail -f /var/log/cron
$ logger -p cron.info cron-log

$ tail -f /var/log/spooler
$ logger -p news.crit spooler-log

#! 긴급 상황 발생 시 Emergency Log | 전체 로그 파일에 출력 및 Output 출력
$ loger -p uucp.emerg emerg-log
