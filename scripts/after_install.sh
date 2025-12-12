#!/bin/bash

# 배포 후 작업
DEPLOY_DIR="/data/web"
TEMP_DIR="/tmp/codedeploy"
TOMCAT_HOME=$(find /software/tomcat/servers -maxdepth 1 -type d -name "web*1" | head -n 1)
TOMCAT_WEBAPPS="$TOMCAT_HOME/webapps"

echo "Installing new application..."
echo "Tomcat webapps directory: $TOMCAT_WEBAPPS"

# ROOT.war 파일을 배포 디렉토리로 복사
if [ -f "$TEMP_DIR/ROOT.war" ]; then
    echo "Copying ROOT.war to $DEPLOY_DIR..."
    cp $TEMP_DIR/ROOT.war $DEPLOY_DIR/

    # 파일 권한 설정
    chmod 644 $DEPLOY_DIR/ROOT.war

    # Tomcat webapps 디렉토리로 복사
    echo "Copying ROOT.war to Tomcat webapps..."
    cp $TEMP_DIR/ROOT.war $TOMCAT_WEBAPPS/

    # Tomcat webapps의 파일 권한 설정
    chmod 644 $TOMCAT_WEBAPPS/ROOT.war

    # 기존 압축 해제된 ROOT 디렉토리 삭제 (재배포를 위해)
    if [ -d "$TOMCAT_WEBAPPS/ROOT" ]; then
        echo "Removing old ROOT directory for clean deployment..."
        rm -rf $TOMCAT_WEBAPPS/ROOT
    fi

    echo "Application installed successfully"
else
    echo "ERROR: ROOT.war not found in $TEMP_DIR"
    exit 1
fi

# 임시 파일 정리
echo "Cleaning up temporary files..."
rm -rf $TEMP_DIR

exit 0
