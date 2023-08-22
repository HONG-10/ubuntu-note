##########################################################################
# 생성 | touch
##########################################################################
$ touch [FILE_NM]


##########################################################################
# 삭제 | rm
##########################################################################
$ rm [REMOVE_FIME_NM]
$ rm -rf [REMOVE_DIR_NM] 

# Options
# -r : 디렉토리 하위 파일
# -f : 바로 삭제


##########################################################################
# 복사 | cp
##########################################################################
$ cp [원본FIME_NM] [복사할FIME_NM]
$ cp -r [원본DIR_NM] [복사할DIR_NM]
$ cp ['원본FIME_NM'] ['복사할FIME_NM']


##########################################################################
# 이동 및 파일명 수정 | mv
##########################################################################
$ mv [원본FIME_NM] [이동 및 수정할 FIME_NM]
$ mv ['원본FIME_NM'] ['이동 및 수정할 FIME_NM']


##########################################################################
# 압축 | tar
##########################################################################
# 백업 시 압축해서 안전한 저장소에 옮긴다.
# tar | tape archive --> Packaging
# .gz | 압축
# .bz2 | 압축 | gz보다 압축률 10% 높음

# .tar 압축 & 해제 & 조회
$ tar -cvf [PACKAGING_FIME_NM.tar] [ARCHIVE_DIR_NM]
$ tar -xvf [PACKAGING_FIME_NM.tar]
$ tar -tvf [PACKAGING_FIME_NM.tar]

# .tar.gz (.tgz) 압축 & 해제 & 조회
$ tar -zcvf [PACKAGING_FIME_NM.tar.gz] [ARCHIVE_DIR_NM]
$ tar -zxvf [PACKAGING_FIME_NM.tar.gz]
$ tar -ztvf [PACKAGING_FIME_NM.tar.gz]

# .tar.bz2 (.tbz) 압축 & 해제 & 조회
$ tar -jcvf [PACKAGING_FIME_NM.tar.bz2] [ARCHIVE_DIR_NM]
$ tar -jxvf [PACKAGING_FIME_NM.tar.bz2]
$ tar -jtvf [PACKAGING_FIME_NM.tar.bz2]

# Options
# -c : 압축
# -x : 압축 해제
# -v : 과정 보여주기
# -f : 파일명 설정
# -z : gzip 파일 압축 & 해제
# -j : bzip2 파일 압축 & 해제

# -C : 압축해제 디렉토리 지정
# -k : 압축 시, 기존 파일 유지
# -U : 압축 전, 기존 파일 삭제.
# --strip-components=1 : 해제 시 디렉토리의 1번째 경로 제거

$ tar xvfz xx.tar.gz
$ zcat xx.tar.gz | tar xvf -
$ tar xvfj xx.tar.bz2
$ bzcat xx.tar.bz2|tar xvf -

##########################################################################
# 압축 | 7zr
##########################################################################
# 백업 시 압축해서 안전한 저장소에 옮긴다.

# 7z 압축 및 압축 풀기
$ 7zr a [압축_FILE_NM].7z [압축할_폴더명1] [압축할_폴더명2] ...
$ 7zr x [압축_FILE_NM].7z


##########################################################################
# 심볼릭링크 | in
##########################################################################
$ ln -s [연결할_FIME_NM] [생성할_FIME_NM]

$ ln -s ../sites-available/nginx-test nginx-test
> nginx-test -> ../sites-available/nginx-test


##########################################################################
# 파일 생성 & 확인 & 병합 | cat(concatenate)
##########################################################################
# 새 파일을 작성하고 터미널에서 파일 내용을 보고 출력을 다른 명령행 도구나 파일로 리디렉션하는데 사용
$ cat [Option] [FIME_NM] 

# 파일 내용 출력
$ cat [FIME_NM]
$ cat [FIME_NM] | more      # 출력 내용 화면 크기에 맞추기
$ cat [FIME_NM] | less      # 파일 내용을 vim 편집기로 확인

# 파일 생성
$ cat [ORIG_FIME_NM] > [NEW_FILE_NM]
$ cat [ORIG_FIME_NM_1] [ORIG_FIME_NM_2] [ORIG_FIME_NM_3] > [NEW_FILE_NM]

# 파일 병합
$ cat [ORIG_FIME_NM] >> [ADD_FILE_NM]

# 내용 입력 저장
$ cat > [FIME_NM]
['new text']

# 내용 추가 저장
$ cat >> [FIME_NM]
['add text']

# File Redirection | 파일 리디렉션
# >   표준 출력     # 명령 > 파일 : 명령의 결과를 파일로 저장 (write)
# >>  표준 출력     # 명령 >> 파일 : 명령의 결과를 기존 파일에 추가 (add)
# <   표준 입력     # 명령 < 파일 : 파일의 내용을 명령에 입력

# Options
# n: 줄번호를 화면 왼쪽에 나타낸다. 비어있는 행도 포함한다.
# b: 줄번호를 화면 왼쪽에 나타낸다. 비어있는 행은 제외한다.
# e: 제어 문자를 ^ 형태로 출력하면서 각 행의 끝에 $를 추가한다.
# s: 연속되는 2개이상의 빈 행을 한 행으로 출력한다.
# v: tab과 행 바꿈 문자를 제외한 제어 문자를 ^ 형태로 출력한다.
# E: 행마다 끝에 $ 문자를 출력한다.
# T: 탭(tab) 문자를 출력한다.
# A: -vET 옵션을 사용한 것과 같은 효과를 본다.

# 활용법
# 파일 내용만 삭제 (log파일 로그 내용만 삭제)
$ cat /dev/null > ./[로그파일명]

# 특정 파일에서 여러 문자열 찾기
$ cat [FIME_NM] | grep [KEY_WORD_1] | grep [KEY_WORD_2]


##########################################################################
# tee
##########################################################################
# File 내용 복사 후 New File에 기록
$ cat [FILE_NM] | tee [NEW_FILE_NM]

# File에 "hello" 기록 & "hello" 출력
$ echo "hello" | tee [FILE_NM]

# Options
# -a | --append : append, 덮어쓰기 안 함
# -i | --ignore-interrupts : ignore interrupt signals (프로그램 방해 시그널 무시)
# -p : 파이프가 아닌 다른 파이프에 쓰는 오류 diagnose errors writing to non pipes
# --output-error[=MODE] : Write Error 시 동작 설정
# MODE
# 'warn'         모든 출력에 쓰기 오류 진단
# 'warn-nopipe'  파이프가 아닌 모든 출력에 쓰기 오류 진단 diagnose errors writing to any output not a pipe # -p (Default)
# 'exit'         출력에 쓰기 오류 발생 시 종료
# 'exit-nopipe'  파이프가 아닌 모든 출력에 쓰기 오류 발생 시 종료

# File에 "hello" append
$ echo "hello" | tee -a [FILE_NM] /dev/null

# append case. 2
$ echo "hello world" >> [FILE_NM]

# redirection으로 파일을 생성할 경우, sudo로 명령해도 일반 사용자로 전환됨
# root 권한으로 write or append 할 경우 tee 명령어 사용
$ sudo echo "validate_password.policy=LOW" >> /etc/mysql/mysql.conf.d/mysqld.cnf (X) --> "permission denied"
$ echo "validate_password.policy=LOW" | sudo tee -a /etc/mysql/mysql.conf.d/mysqld.cnf (O)


##########################################################################
# tail | 실시간으로 파일의 지정행~마지막행 출력(Default: 10)
##########################################################################
$ tail -f [FIME_NM]
$ tail -f [FIME_NM] | grep [KEY_WORD]
# 종료: Ctrl + C

# touch		유효한 빈 파일을 작성하기 위해 사용
# head		터미널에서 직접 파일or파이프된 데이터의 시작 출력
# tail		파일의 지정행~마지막행 출력(Default: 10)
# comm		2개 파일을 공통 행과 구별되는 행으로 비교 가능
# less		파일 내용 보고 양방향 탐색 가능
# cmp		두 파일 비교--> 결과를 표준 출력 스트림에 인쇄
# dd		파일 유형 다른 유형으로 변경
# alias		단어 변경
