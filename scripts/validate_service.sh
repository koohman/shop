#!/bin/bash

# 서비스 검증 스크립트
echo "Validating service..."

# 최대 30번 시도 (약 60초)
MAX_ATTEMPTS=30
ATTEMPT=0

while [ $ATTEMPT -lt $MAX_ATTEMPTS ]; do
    # HTTP 응답 확인
    HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8180/ || echo "000")

    if [ "$HTTP_STATUS" = "200" ] || [ "$HTTP_STATUS" = "302" ]; then
        echo "Service is running successfully! (HTTP $HTTP_STATUS)"
        exit 0
    elif [ "$HTTP_STATUS" = "404" ]; then
        # 404는 Tomcat은 실행 중이나 애플리케이션이 아직 배포 중일 수 있음
        echo "Tomcat is running but application not ready yet... (Attempt $((ATTEMPT+1))/$MAX_ATTEMPTS)"
    else
        echo "Waiting for service to be ready... HTTP $HTTP_STATUS (Attempt $((ATTEMPT+1))/$MAX_ATTEMPTS)"
    fi

    ATTEMPT=$((ATTEMPT+1))
    sleep 2
done

echo "ERROR: Service validation failed after $MAX_ATTEMPTS attempts"
exit 1
