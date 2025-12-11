#!/bin/bash

# 배포 후 작업
DEPLOY_DIR="/data/web"
TEMP_DIR="/tmp/codedeploy"

echo "Installing new application..."

# ROOT.war 파일을 배포 디렉토리로 복사
if [ -f "$TEMP_DIR/ROOT.war" ]; then
    echo "Copying ROOT.war to $DEPLOY_DIR..."
    cp $TEMP_DIR/ROOT.war $DEPLOY_DIR/

    # 파일 권한 설정
    chmod 644 $DEPLOY_DIR/ROOT.war

    echo "Application installed successfully"
else
    echo "ERROR: ROOT.war not found in $TEMP_DIR"
    exit 1
fi

# 임시 파일 정리
echo "Cleaning up temporary files..."
rm -rf $TEMP_DIR

exit 0
