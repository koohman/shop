#!/bin/bash

# Tomcat 중지 스크립트
TOMCAT_HOME=$(find /software/tomcat/servers -maxdepth 1 -type d -name "web*1" | head -n 1)

echo "Stopping Tomcat..."

# Tomcat PID 확인
if [ -f "$TOMCAT_HOME/catalina.pid" ]; then
    PID=$(cat $TOMCAT_HOME/catalina.pid)
    if [ -n "$PID" ] && kill -0 $PID 2>/dev/null; then
        echo "Tomcat is running with PID: $PID"
        $TOMCAT_HOME/shl/stop.sh

        # Tomcat이 완전히 종료될 때까지 대기 (최대 60초)
        count=0
        while [ $count -lt 60 ] && kill -0 $PID 2>/dev/null; do
            echo "Waiting for Tomcat to stop... ($count/60)"
            sleep 1
            count=$((count + 1))
        done

        # 여전히 실행 중이면 강제 종료
        if kill -0 $PID 2>/dev/null; then
            echo "Force killing Tomcat..."
            kill -9 $PID
        fi

        echo "Tomcat stopped successfully"
    else
        echo "Tomcat PID file exists but process is not running"
    fi
else
    echo "Tomcat is not running (PID file not found)"
fi

exit 0
