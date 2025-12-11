#!/bin/bash

# 배포 전 준비 작업
DEPLOY_DIR="/data/web"

echo "Preparing for deployment..."

# 기존 ROOT 애플리케이션 백업 및 삭제
if [ -d "$DEPLOY_DIR/ROOT" ]; then
    echo "Backing up existing ROOT application..."
    BACKUP_DIR="/tmp/backup_$(date +%Y%m%d_%H%M%S)"
    mkdir -p $BACKUP_DIR
    mv $DEPLOY_DIR/ROOT $BACKUP_DIR/
    echo "Backup created at $BACKUP_DIR"
fi

if [ -f "$DEPLOY_DIR/ROOT.war" ]; then
    echo "Removing existing ROOT.war..."
    rm -f $DEPLOY_DIR/ROOT.war
fi

# CodeDeploy 임시 디렉토리 생성
mkdir -p /tmp/codedeploy

echo "Before install completed"
exit 0
