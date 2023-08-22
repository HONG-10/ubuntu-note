##########################################################################
# Download | curl
##########################################################################
$ curl 


##########################################################################
# Download | wget
##########################################################################
$ wget -0 [저장할_파일명] [다운로드_URL]


##########################################################################
# 설치파일 생성 | configure
##########################################################################
$ ./configure --help


##########################################################################
# 컴파일 | make
##########################################################################
$ make 
Usage: make [options] [target] ...

install: altinstall bininstall maninstall

Options:
#   -b | -m                         호환성 무시
#   -B | --always-make              강제 always-make
#   -d                              디버깅 정보 출력
#   --debug[=FLAGS]                 디버깅 정보 지정 출력
#   --trace                         추적 정보 출력
#   -h | --help                     도움말 출력
#   -i | --ignore-errors            오류 무시
#   -k | --keep-going           
#   -S | --no-keep-going | --stop Turns off -k.
  -j [N] | --jobs[=N]          처리할 jobs 지정
  -l [N] | --load-average[=N] | --max-load[=N] 부하 처리 지정
  -L | --check-symlink-times   Use the latest mtime between symlinks and target.
  -n | --just-print | --dry-run | --recon
                              Do not actually run any recipe; just print them.

#   -e | --environment-overrides      Environment variables override makefiles.
#   --eval=STRING                     Evaluate STRING as a makefile statement.

  -p | --print-data-base        Print make is internal database.
  -q | --question               Run no recipe; exit status says if up to date.
  -r | --no-builtin-rules       Disable the built-in implicit rules.
  -R | --no-builtin-variables   Disable the built-in variable settings.
  -s | --silent | --quiet       Do not echo recipes.
  -t | --touch                 Touch targets instead of remaking them.
  -v | --version               Print the version number of make and exit.

  -w | --print-directory       Print the current directory.
#   --no-print-directory        Turn off -w | even if it was turned on implicitly.
#   --warn-undefined-variables  정의되지 않은 변수가 참조될 때 경고

# Makefile 지정
# -f [FILE_NM]
# --file=[FILE_NM]
# --makefile=[FILE_NM]

# Consider FILE to be infinitely new.
# -W [FILE_NM]
# --what-if=[FILE_NM]
# --new-file=[FILE_NM]
# --assume-new=[FILE_NM]

# Old 파일 지정 | Avoiding Recompilation
# -o [FILE_NM]
# --old-file=[FILE_NM]
# --assume-old=[FILE_NM]

# 디렉토리 지정
# -C [DIRECTORY_NM]               
# --directory=[DIRECTORY_NM]

# Makefile 디렉토리 지정
# -I [DIRECTORY_NM] 
# --include-dir=[DIRECTORY_NM]

# 병렬 작업의 출력을 유형별로 동기화
# -O[TYPE]
# --output-sync[=TYPE]

##########################################################################
# 설치 | make install
##########################################################################
$ sudo ./configure --prefix=${POSTGRESQL_INSTALL_PATH} --without-readline --without-zlib
# --prefix  : 엔진 설치 경로 (Default: /usr/local/pgsql)
# --without : 설치 시 제외할 Package (gcc, readline-devel, zlib-devel 등 지정 or install)


##########################################################################
# 테스트 | make test
##########################################################################
$ make test


##########################################################################
# 갱신 | update-alternatives
##########################################################################
$ update-alternatives -<Option> -[Command]

<link> : 실행파일 이름으로 /etc/alternatives/<name> 을 가리킨다.
<name> : 해당 링크 그룹의 대표 이름으로, 여러 가지 버전의 패키지들을 대표하는 이름으로 보면 될 것 같다.
<path> : alternatives 로 실제 연결할 실행파일 이름으로, 시스템에 설치한 패키지의 실행파일 이름이다.
<priority> : automatic 모드에서 어떤 것을 자동으로 선택해서 사용할지 결정할 때 사용되는 우선순위로, 높은 수가 더 높은 우선순위이다.

Commands:
  --install <link> <name> <path> <priority>
    [--slave <link> <name> <path>] ...
                           add a group of alternatives to the system.

# Command 목록 확인
$ sudo update-alternatives                          user to select which one to use.

# 등록
$ sudo update-alternatives --install <link> <name> <path> <priority>
$ sudo update-alternatives --install "/usr/bin/java" "java" "/usr/local/java/jdk1.7.0_75/bin/java" 1
$ sudo update-alternatives --install "/usr/bin/javac" "javac" "/usr/local/java/jdk1.7.0_75/bin/javac" 1
$ sudo update-alternatives --install "/usr/bin/javaws" "javaws" "/usr/local/java/jdk1.7.0_75/bin/javaws" 1

# 삭제
$ sudo update-alternatives --remove <name> <path>   remove <path> from the <name> group alternative.
$ sudo update-alternatives --remove-all <name>      remove <name> group from the alternatives system.

# 설정
$ sudo update-alternatives --set <name> <path>      set <path> as alternative for <name>.
$ sudo update-alternatives --set "java" "/usr/local/java/jdk1.7.0_75/bin/java"
$ sudo update-alternatives --set "javac" "/usr/local/java/jdk1.7.0_75/bin/javac"
$ sudo update-alternatives --set "javaws" "/usr/local/java/jdk1.7.0_75/bin/javaws"

# 확인
$ sudo update-alternatives --display <name>         display information about the <name> group.
$ sudo update-alternatives --list <name>            display all targets of the <name> group.
$ sudo update-alternatives --query <name>           machine parseable version of --display <name>.

# 목록 확인 | alternative 명, 상태, 경로
$ sudo update-alternatives --get-selections         list master alternative names and their status.

# 지정
$ sudo update-alternatives --config <name>          show alternatives for the <name> group and ask the
$ sudo update-alternatives --auto <name>            switch the master link <name> to automatic mode.
$ sudo update-alternatives --all                    call --config on all alternatives.

#??
$ sudo update-alternatives --set-selections         read alternative status from standard input.


# Options
--altdir [DIRECTORY_NM]     change the alternatives directory.
--admindir [DIRECTORY_NM]   change the administrative directory.
--log [FILE_NM]             change the log file.
--force                     allow replacing files with alternative links.
--skip-auto                 skip prompt for alternatives correctly configured in automatic mode (relevant for --config only)
--verbose                   verbose operation | more output.
--quiet                     quiet operation | minimal output.
--help                      show this help message.
--version                   show the version.

https://www.whatwant.com/entry/update-alternatives-%EC%97%AC%EB%9F%AC-%EB%B2%84%EC%A0%84%EC%9D%98-%ED%8C%A8%ED%82%A4%EC%A7%80-%EA%B4%80%EB%A6%AC%ED%95%98%EA%B8%B0

sudo update-alternatives --install [NEW_PATH] [PROGRAM_NM] [OLD_PATH] [NUM]

sudo update-alternatives --install /usr/local/bin/openssl openssl /usr/bin/openssl 111
