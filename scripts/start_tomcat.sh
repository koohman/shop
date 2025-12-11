#!/bin/bash

# Tomcat 시작 스크립트
TOMCAT_HOME=$(find /software/tomcat/servers -maxdepth 1 -type d -name "web*1" | head -n 1)

echo "Starting Tomcat..."

# Tomcat이 이미 실행 중인지 확인
if [ -f "$TOMCAT_HOME/catalina.pid" ]; then
    PID=$(cat $TOMCAT_HOME/catalina.pid)
    if [ -n "$PID" ] && kill -0 $PID 2>/dev/null; then
        echo "Tomcat is already running with PID: $PID"
        exit 0
    fi
fi

# Tomcat 시작
$TOMCAT_HOME/shl/start.sh

# Tomcat이 시작될 때까지 대기
echo "Waiting for Tomcat to start..."
sleep 10

# Tomcat 프로세스 확인
if [ -f "$TOMCAT_HOME/catalina.pid" ]; then
    PID=$(cat $TOMCAT_HOME/catalina.pid)
    if [ -n "$PID" ] && kill -0 $PID 2>/dev/null; then
        echo "Tomcat started successfully with PID: $PID"
        exit 0
    fi
fi

echo "ERROR: Failed to start Tomcat"
exit 1
