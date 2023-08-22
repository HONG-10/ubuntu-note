#!/bin/bash
# nexus 설치 선행 조건 : openjre

##########################################################################################################################################
# 1. 인터넷 가능한 Linux 서버 ( 예 : WSL2 ) 에서 openjre-8, nexus 다운로드
##########################################################################################################################################

# Nexus Version : 3.38.1-01 ( Release date : 2022-03-29 )
NEXUS_VERSION='3.38.1-01'

# Nexus 전용 openjre-8 다운로드 경로 : OpenJDK8U-jre_x64_linux_hotspot_8u332b09.tar.gz ( 2022-04-28 )
OPEN_JRE_8_DOWNLOAD_URL=https://github.com/adoptium/temurin8-binaries/releases/download/jdk8u332-b09/OpenJDK8U-jre_x64_linux_hotspot_8u332b09.tar.gz

# Nexus 다운로드 경로
NEXUS_DOWNLOAD_URL=https://download.sonatype.com/nexus/3/nexus-"${NEXUS_VERSION}"-unix.tar.gz

# 다운로드시 사용할 임시 작업 디렉토리 생성
WORK_DIR=~/tmp
[ -d "${WORK_DIR}" ] || mkdir -p "${WORK_DIR}"

# Nexus 전용 openjre-8 다운로드
curl -G -k \
  -o "${WORK_DIR}"/openjre-8.tar.gz \
  -L "${OPEN_JRE_8_DOWNLOAD_URL}"

# Nexus 다운로드
curl -G -k \
  -o "${WORK_DIR}"/nexus.tar.gz \
  -L "${NEXUS_DOWNLOAD_URL}"

# 이후 작업 디렉토리에 있는 tar.gz 파일들을 로컬로 다운로드한다.

##########################################################################################################################################
# 2. nexus 설치할 서버에 접속 후 위에서 다운로드 받은 파일들을 서버 내 작업 디렉토리에 직접 업로드한다.
##########################################################################################################################################

# 설치파일 업로드 / offline 설치시 사용할 임시 작업 디렉토리 생성
WORK_DIR=~/tmp
[ -d "${WORK_DIR}" ] || mkdir -p "${WORK_DIR}"

# 임시 작업 디렉토리에 tar.gz 파일들을 업로드한다.

##########################################################################################################################################
# 3. 임시 작업 디렉토리에 업로드된 파일 기반으로 offline 설치
##########################################################################################################################################

################################################################################
# [ Nexus 설치 Script 실행 전 Step ]
#
# 1. [ FireWall ]  Nexus 관련 기본 port 오픈 : NEXUS_HTTP_PORT, NEXUS_HTTPS_PORT 2개 port
# 
# 2. 필요시 Nexus 전용 계정 생성 / password 입력 : sudo 권한 보유한 계정에서 실행해야 함
#                                                  -G sudo => 계정 생성시 자동으로 sudo 그룹에 추가
#                                                  NOPASSWD 권한 부여
# NEXUS_USER='nexus'
# NEXUS_USER_PASSWORD='nexus123#'
# 
# sudo useradd -s /bin/bash -d /home/"${NEXUS_USER}"/ -m -G sudo "${NEXUS_USER}"
# echo -e "${NEXUS_USER_PASSWORD}\n${NEXUS_USER_PASSWORD}\n" | sudo passwd "${NEXUS_USER}"
# 
# echo "${NEXUS_USER} ALL=NOPASSWD: ALL" | sudo tee "/etc/sudoers.d/${NEXUS_USER}-nopasswd"
# 
# 4. nexus 전용 계정으로 login / Home 경로로 이동
# 
# NEXUS_USER='nexus'
# su "${NEXUS_USER}"
#
# cd ~
# 
# 6. sh 파일 생성 / 설정값 변경 / 실행 권한 부여 후 실행
# vi ./nexus-install.sh
# chmod u+x ./nexus-install.sh && ./nexus-install.sh
# 
################################################################################

# 넥서스 전용 openjre-8 설치

# Nexus 전용 openjre-8 설치 디렉토리
NEXUS_OPEN_JRE_8_PATH=/opt/java/openjre-8
WORK_DIR=~/tmp

[ -d "${NEXUS_OPEN_JRE_8_PATH}" ] || sudo mkdir -p "${NEXUS_OPEN_JRE_8_PATH}"

# 넥서스 전용 openjre-8 다운로드 / ${NEXUS_OPEN_JRE_8_PATH} 에 압축 해제
tar -zxf "${WORK_DIR}"/openjre-8.tar.gz \
  -C "${NEXUS_OPEN_JRE_8_PATH}" \
  --strip-components 1

# 해당 jre 의 permission 을 755 로 변경하여 다른 계정도 조회 가능하도록 설정할 것
sudo chmod -R 755 "${NEXUS_OPEN_JRE_8_PATH}"

################################################################################

NEXUS_VERSION='3.38.1-01'
NEXUS_OPEN_JRE_8_PATH=/opt/java/openjre-8
WORK_DIR=~/tmp

# Nexus 실행 계정 / Group : Group 의 경우 여기서는 계정명과 같다고 가정함, 필요시 변경할 것 
NEXUS_USER=$(id -u -n)
NEXUS_USER_GROUP=$(id -u -n)

# Nexus HTTP 가동 포트
NEXUS_HTTP_PORT='12081'

# Nexus HTTPS 가동 포트
NEXUS_HTTPS_PORT='12080'

# < 중요 > 인증서 생성시 발급자 CN 값이 해당 dns 명으로 지정됨
# 해당 nexus 에 대한 유일한 DNS 명 : 공통 dns 명과 별도로 지정
NEXUS_UNIQUE_DNS_NAME='nexus-public'

# Nexus 공통 dns 명 : 인증서 생성시 SAN 에 unique DNS 명과 함께 등록됨
NEXUS_COMMON_DNS_NAME='nexus'

# Nexus 사설 인증서 관련 정보
NEXUS_KEYSTORE_FILE_NAME="${NEXUS_UNIQUE_DNS_NAME}"
NEXUS_KEYSTORE_PASSWORD='changeit'
NEXUS_SELF_SIGNED_KEY_VALIDITY='10000'

# Nexus 설치 경로
NEXUS_INSTALL_PATH=/nexus/nexus-app

# Nexus Data 경로
NEXUS_DATA_PATH=/nexus/nexus-data

# Nexus PID 경로
NEXUS_PID_PATH="${NEXUS_INSTALL_PATH}"/pid

# Nexus https keystore 저장 경로
NEXUS_HTTPS_CONFIG_PATH=/nexus/nexus-ssl

################################################################################

# Nexus 관련 경로 생성 / 소유자 변경

[ -d "${NEXUS_INSTALL_PATH}" ] || sudo mkdir -p "${NEXUS_INSTALL_PATH}"
sudo chown -R "${NEXUS_USER}:${NEXUS_USER_GROUP}" "${NEXUS_INSTALL_PATH}"

[ -d "${NEXUS_DATA_PATH}" ] || sudo mkdir -p "${NEXUS_DATA_PATH}"
sudo chown -R "${NEXUS_USER}:${NEXUS_USER_GROUP}" "${NEXUS_DATA_PATH}"

[ -d "${NEXUS_PID_PATH}" ] || sudo mkdir -p "${NEXUS_PID_PATH}"
sudo chown -R "${NEXUS_USER}:${NEXUS_USER_GROUP}" "${NEXUS_PID_PATH}"

[ -d "${NEXUS_HTTPS_CONFIG_PATH}" ] || sudo mkdir -p "${NEXUS_HTTPS_CONFIG_PATH}"
sudo chown -R "${NEXUS_USER}:${NEXUS_USER_GROUP}" "${NEXUS_HTTPS_CONFIG_PATH}"

################################################################################

# nexus 다운로드 / 압축 해제
# 압축 해제시 ${WORK_DIR} 경로에 nexus-(버전명) ( 예 : nexus-3.35.0-02 ), sonatype-work 두 개의 디렉토리가 생성됨
tar -zxf "${WORK_DIR}"/nexus.tar.gz \
  -C "${WORK_DIR}"

# dot(hidden) 파일도 이동 처리되도록 설정
shopt -s dotglob

# nexus-(버전명) 디렉토리 내 모든 파일을 NEXUS_INSTALL_PATH 으로 이동
sudo mv "${WORK_DIR}"/nexus-"${NEXUS_VERSION}"/* \
   "${NEXUS_INSTALL_PATH}"

# sonatype-work 디렉토리 내 모든 파일을 NEXUS_DATA_PATH 으로 이동
sudo mv "${WORK_DIR}"/sonatype-work/* \
   "${NEXUS_DATA_PATH}"

# unset dotglob
shopt -u dotglob

################################################################################

# ${NEXUS_INSTALL_PATH}/bin/nexus 내 INSTALL4J_JAVA_HOME_OVERRIDE 설정
LINE_NO=$(grep -n "INSTALL4J_JAVA_HOME_OVERRIDE" \
   ${NEXUS_INSTALL_PATH}/bin/nexus | cut -d: -f1 | head -1)

LINE_CONTENT="INSTALL4J_JAVA_HOME_OVERRIDE=${NEXUS_OPEN_JRE_8_PATH}"

sed -i "${LINE_NO}s@.*@${LINE_CONTENT}@" \
  "${NEXUS_INSTALL_PATH}"/bin/nexus

# ${NEXUS_INSTALL_PATH}/bin/nexus.rc 설정
sudo cat > "${NEXUS_INSTALL_PATH}"/bin/nexus.rc <<EOF
run_as_user=${NEXUS_USER}
EOF

# ${NEXUS_INSTALL_PATH}/bin/nexus.vmoptions 설정
sudo cat > "${NEXUS_INSTALL_PATH}"/bin/nexus.vmoptions <<EOF
-Xms2703m
-Xmx2703m
-XX:MaxDirectMemorySize=2703m
-XX:+UnlockDiagnosticVMOptions
-XX:+LogVMOutput
# default: -XX:LogFile=../sonatype-work/nexus3/log/jvm.log
-XX:LogFile=${NEXUS_DATA_PATH}/log/jvm.log
-XX:-OmitStackTraceInFastThrow
-Djava.net.preferIPv4Stack=true
-Dkaraf.home=.
-Dkaraf.base=.
-Dkaraf.etc=etc/karaf
-Djava.util.logging.config.file=etc/karaf/java.util.logging.properties
# default: -Dkaraf.data=../sonatype-work/nexus3
-Dkaraf.data=${NEXUS_DATA_PATH}
# default: -Dkaraf.log=../sonatype-work/nexus3/log
-Dkaraf.log=${NEXUS_DATA_PATH}/log
# default: -Djava.io.tmpdir=../sonatype-work/nexus3/tmp
-Djava.io.tmpdir=${NEXUS_DATA_PATH}/tmp
-Dkaraf.startLocalConsole=false
-Djdk.tls.ephemeralDHKeySize=2048
-Dinstall4j.pidDir=${NEXUS_PID_PATH}
-Djava.endorsed.dirs=lib/endorsed
EOF

#############################################

# \${NEXUS_HTTPS_CONFIG_PATH}/\${NEXUS_KEYSTORE_FILE_NAME}.jks 생성
if [[ ! -f "${NEXUS_HTTPS_CONFIG_PATH}"/"${NEXUS_KEYSTORE_FILE_NAME}".jks ]]; then

  echo -e "\n[ INFO ]  '${NEXUS_HTTPS_CONFIG_PATH}' 경로에 '${NEXUS_KEYSTORE_FILE_NAME}.jks' 신규 생성" && \

  VALIDITY="${NEXUS_SELF_SIGNED_KEY_VALIDITY}" && \
  sudo "${NEXUS_OPEN_JRE_8_PATH}"/bin/keytool \
    -genkeypair \
    -keystore "${NEXUS_HTTPS_CONFIG_PATH}"/"${NEXUS_KEYSTORE_FILE_NAME}".jks \
    -storetype jks \
    -storepass "${NEXUS_KEYSTORE_PASSWORD}" \
    -keypass "${NEXUS_KEYSTORE_PASSWORD}" \
    -alias "${NEXUS_UNIQUE_DNS_NAME}" \
    -keyalg RSA \
    -keysize 2048 \
    -validity "${VALIDITY}" \
    -dname "CN=${NEXUS_UNIQUE_DNS_NAME}, L=Unspecified, ST=Unspecified, C=KR" \
    -ext "SAN=DNS:${NEXUS_COMMON_DNS_NAME},DNS:${NEXUS_UNIQUE_DNS_NAME}" \
    -ext "BC=ca:true"

fi

if [[ ! -f "${NEXUS_HTTPS_CONFIG_PATH}"/"${NEXUS_KEYSTORE_FILE_NAME}".pfx ]]; then

  echo -e "\n[ INFO ]  '${NEXUS_HTTPS_CONFIG_PATH}' 경로에 '${NEXUS_KEYSTORE_FILE_NAME}.pfx' 신규 생성" && \

  # Convert .jks file to .pfx
  sudo "${NEXUS_OPEN_JRE_8_PATH}"/bin/keytool \
      -importkeystore \
      -srcstoretype JKS \
      -srckeystore "${NEXUS_HTTPS_CONFIG_PATH}"/"${NEXUS_KEYSTORE_FILE_NAME}".jks \
      -srcstorepass "${NEXUS_KEYSTORE_PASSWORD}" \
      -srcalias "${NEXUS_UNIQUE_DNS_NAME}" \
      -deststoretype PKCS12 \
      -destkeystore "${NEXUS_HTTPS_CONFIG_PATH}"/"${NEXUS_KEYSTORE_FILE_NAME}".pfx \
      -deststorepass "${NEXUS_KEYSTORE_PASSWORD}" \
      -destalias "${NEXUS_UNIQUE_DNS_NAME}"
fi

# .pfx 기반으로 .crt 인증서 생성
sudo openssl pkcs12 \
   -in "${NEXUS_HTTPS_CONFIG_PATH}"/"${NEXUS_KEYSTORE_FILE_NAME}".pfx \
   -passin pass:"${NEXUS_KEYSTORE_PASSWORD}" \
   -nokeys \
   -out "${NEXUS_HTTPS_CONFIG_PATH}"/"${NEXUS_KEYSTORE_FILE_NAME}".crt

##################################################################

# \${NEXUS_HTTPS_CONFIG_PATH}/\${NEXUS_UNIQUE_DNS_NAME}-https.xml 생성
sudo tee "${NEXUS_HTTPS_CONFIG_PATH}"/"${NEXUS_UNIQUE_DNS_NAME}"-https.xml <<EOF
<?xml version="1.0"?>
<!DOCTYPE Configure PUBLIC "-//Jetty//Configure//EN" "http://www.eclipse.org/jetty/configure_9_0.dtd">
<Configure id="Server" class="org.eclipse.jetty.server.Server">

  <Ref refid="httpConfig">
    <Set name="secureScheme">https</Set>
    <Set name="securePort"><Property name="application-port-ssl" /></Set>
  </Ref>

  <New id="httpsConfig" class="org.eclipse.jetty.server.HttpConfiguration">
    <Arg><Ref refid="httpConfig"/></Arg>
    <Call name="addCustomizer">
      <Arg>
        <New id="secureRequestCustomizer" class="org.eclipse.jetty.server.SecureRequestCustomizer">
          <!-- 7776000 seconds = 90 days -->
          <Set name="stsMaxAge"><Property name="jetty.https.stsMaxAge" default="7776000"/></Set>
          <Set name="stsIncludeSubDomains"><Property name="jetty.https.stsIncludeSubDomains" default="false"/></Set>
          <Set name="sniHostCheck"><Property name="jetty.https.sniHostCheck" default="false"/></Set>
        </New>
      </Arg>
    </Call>
  </New>

  <!-- escape 처리 : SslContextFactory\$Server -->
  <New id="sslContextFactory" class="org.eclipse.jetty.util.ssl.SslContextFactory\$Server">
    <!-- .jks 경로, password 설정 Start  -->
    <Set name="KeyStorePath">${NEXUS_HTTPS_CONFIG_PATH}/${NEXUS_KEYSTORE_FILE_NAME}.jks</Set>
    <Set name="KeyStorePassword">${NEXUS_KEYSTORE_PASSWORD}</Set>
    <Set name="KeyManagerPassword">${NEXUS_KEYSTORE_PASSWORD}</Set>
    <Set name="TrustStorePath">${NEXUS_HTTPS_CONFIG_PATH}/${NEXUS_KEYSTORE_FILE_NAME}.jks</Set>
    <Set name="TrustStorePassword">${NEXUS_KEYSTORE_PASSWORD}</Set>
    <!-- .jks 경로, password 설정 End  -->
    <Set name="EndpointIdentificationAlgorithm"></Set>
    <Set name="NeedClientAuth"><Property name="jetty.ssl.needClientAuth" default="false"/></Set>
    <Set name="WantClientAuth"><Property name="jetty.ssl.wantClientAuth" default="false"/></Set>
    <Set name="IncludeProtocols">
      <Array type="java.lang.String">
        <Item>TLSv1.2</Item>
      </Array>
    </Set>
  </New>

  <Call  name="addConnector">
    <Arg>
      <New id="httpsConnector" class="org.eclipse.jetty.server.ServerConnector">
        <Arg name="server"><Ref refid="Server" /></Arg>
        <Arg name="acceptors" type="int"><Property name="jetty.https.acceptors" default="-1"/></Arg>
        <Arg name="selectors" type="int"><Property name="jetty.https.selectors" default="-1"/></Arg>
        <Arg name="factories">
          <Array type="org.eclipse.jetty.server.ConnectionFactory">
            <Item>
              <New class="org.sonatype.nexus.bootstrap.jetty.InstrumentedConnectionFactory">
                <Arg>
                  <New class="org.eclipse.jetty.server.SslConnectionFactory">
                    <Arg name="next">http/1.1</Arg>
                    <Arg name="sslContextFactory"><Ref refid="sslContextFactory"/></Arg>
                  </New>
                </Arg>
              </New>
            </Item>
            <Item>
              <New class="org.eclipse.jetty.server.HttpConnectionFactory">
                <Arg name="config"><Ref refid="httpsConfig" /></Arg>
              </New>
            </Item>
          </Array>
        </Arg>

        <Set name="host"><Property name="application-host" /></Set>
        <Set name="port"><Property name="application-port-ssl" /></Set>
        <Set name="idleTimeout"><Property name="jetty.https.timeout" default="30000"/></Set>
        <Set name="acceptorPriorityDelta"><Property name="jetty.https.acceptorPriorityDelta" default="0"/></Set>
        <Set name="acceptQueueSize"><Property name="jetty.https.acceptQueueSize" default="0"/></Set>
      </New>
    </Arg>
  </Call>

</Configure>
EOF

##################################################################

# \${NEXUS_DATA_PATH}/etc/nexus.properties 설정
[ -d "${NEXUS_DATA_PATH}"/etc ] || sudo mkdir -p "${NEXUS_DATA_PATH}"/etc

sudo tee "${NEXUS_DATA_PATH}"/etc/nexus.properties <<EOF
# Jetty section

# nexus http 전용 port
application-port=${NEXUS_HTTP_PORT}

# nexus https 전용 port
application-port-ssl=${NEXUS_HTTPS_PORT}
application-host=0.0.0.0

# ${NEXUS_HTTPS_CONFIG_PATH}/${NEXUS_UNIQUE_DNS_NAME}-https.xml 추가
nexus-args=\${jetty.etc}/jetty.xml,\${jetty.etc}/jetty-http.xml,\${jetty.etc}/jetty-requestlog.xml,${NEXUS_HTTPS_CONFIG_PATH}/${NEXUS_UNIQUE_DNS_NAME}-https.xml
nexus-context-path=/

# Nexus section
nexus-edition=nexus-oss-edition
nexus-features=\
 nexus-oss-feature

# https://issues.sonatype.org/browse/NEXUS-23205
nexus.scripts.allowCreation=true

# https://baykara.medium.com/how-to-automate-nexus-setup-process-5755183bc322
nexus.security.randompassword=false
EOF

#############################################

# Nexus 설치 완료 후 관련 경로들에 대해 명시적으로 Nexus 실행 계정으로 소유자 변경
sudo chown -R "${NEXUS_USER}":"${NEXUS_USER_GROUP}" "${NEXUS_INSTALL_PATH}"

sudo chown -R "${NEXUS_USER}":"${NEXUS_USER_GROUP}" "${NEXUS_DATA_PATH}"

sudo chown -R "${NEXUS_USER}":"${NEXUS_USER_GROUP}" "${NEXUS_PID_PATH}"

sudo chown -R "${NEXUS_USER}":"${NEXUS_USER_GROUP}" "${NEXUS_HTTPS_CONFIG_PATH}"

#############################################

# systemd 에 nexus.service 등록 & 실행
sudo tee /etc/systemd/system/nexus.service << EOF
# https://help.sonatype.com/repomanager3/installation/run-as-a-service#RunasaService-systemd
[Unit]
Description=nexus service
After=network.target

[Service]
Type=forking
User=${NEXUS_USER}
Group=${NEXUS_USER_GROUP}
TimeoutStartSec=0
TimeoutStopSec=0
PermissionsStartOnly=true
ExecStart=${NEXUS_INSTALL_PATH}/bin/nexus start
ExecReload=${NEXUS_INSTALL_PATH}/bin/nexus restart
ExecStop=${NEXUS_INSTALL_PATH}/bin/nexus stop
Restart=on-abort

[Install]
WantedBy=multi-user.target graphical.target
EOF

sudo systemctl enable --now nexus
# 최초 설치시 1 ~ 2분 시간 소요됨
sudo systemctl status nexus | tail -n 300

#############################################

# 최초 Nexus 접속시 admin default password 확인
# => cat "${NEXUS_DATA_PATH}"/admin.password

# 1. 최초 admin 계정으로 로그인 : 비밀번호는 admin default password 값

# 2. 
#  (1 of 4) 'This wizard will help you complete required setup tasks.'
#
#  (2 of 4) 'Please choose a password for the admin user'
#
#  (3 of 4) Configure Anonymous Access
# Enable anonymous access means that by default, users can search, browse and download components from repositories without credentials.
# Please consider the security implications for your organization.
# Disable anonymous access should be chosen with care, as it will require credentials for all users and/or build tools.
# More information
# - Enable anonymous access
# - Disable anonymous access
#
#  (4 of 4) Complete
# The setup tasks have been completed, enjoy using Nexus Repository Manager!
# 

###########################################################################



###########################################################################

# systemctl 에서 nexus 제거 방법

# sudo systemctl stop nexus.service
# sudo systemctl disable nexus.service
# sudo rm /etc/systemd/system/nexus.service
# sudo systemctl daemon-reload
# sudo systemctl reset-failed

###########################################################################


sudo tee ~/security.groovy << EOF
import groovy.json.JsonOutput

// Change default admin password
def user = security.securitySystem.getUser('admin')
user.setEmailAddress('user@example.com')
security.securitySystem.updateUser(user)
security.securitySystem.changePassword('admin','admin123#')
log.info('default password for admin changed')

// disable anonymous access 
security.setAnonymousAccess(false)
log.info('Anonymous access disabled')

// Create new admin user
def adminRole = ['nx-admin']
def adminUser = security.addUser('newadmin', 'First Name', 'Last Name', 'user@example.com', true, 'admin123#', adminRole)
log.info('User newadmin created')

log.info('Script security completed successfully')

//Return a JSON response containing our new Users for confirmation
return JsonOutput.toJson([adminUser])
EOF





====================================
# nexus apt install
0. 기본
sudo apt install openjdk-8-jre-headless -y

1. nexus 다운로드
sudo wget https://download.sonatype.com/nexus/3/lastest-unix.tar.gz

2. nexus 압축 해제
tar -zxvf nexus-3.24.0-02-unix.tar.gz

3. nexus 폴더 지정
sudo mv /opt/nexus-3.24.0-02 /opt/nexus

4. nexus 유저 등록
sudo adduser nexus
sudo visudo

5. nexus 권한 부여
sudo chown -R nexus:nexus /opt/nexus
sudo chown -R nexus:nexus /opt/sonatype-work

6. nexus 실행 유저 등록
sudo nano /opt/nexus/bin/nexus.rc

7. nexus 실행 등록
cp {경로}/nexus /etc/init.d/nexus
sudo chmod 755 /etc/init.d/nexus
sudo chown root /etc/init.d/nexus

8. 포트확인
netstat -nap
netstat -nap | grep LISTEN

9. nexus 실행 설정 변경
vi nexus-default.properties

-- ----------
실행 / 종료
./nexus start
./nexus stop

초기 비밀번호 확인
cat /opt/sonatype-work/nexus3/admin.password 



