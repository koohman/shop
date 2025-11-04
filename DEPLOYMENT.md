# 쇼핑몰 애플리케이션 배포 가이드

## 1. 사전 준비

### 필요한 소프트웨어
- **JDK 17 이상** 설치
- **Apache Tomcat 10.x** 설치 (Jakarta EE 9+ 지원)
- **PostgreSQL 14 이상** 설치

### Gradle 설치 (선택)
프로젝트에는 Gradle Wrapper가 포함되어 있어 별도 설치가 필요 없습니다.

---

## 2. 데이터베이스 설정

### PostgreSQL 데이터베이스 생성

1. PostgreSQL에 접속:
```bash
psql -U postgres
```

2. 데이터베이스 생성:
```sql
CREATE DATABASE shopdb;
```

3. 테이블 및 샘플 데이터 생성:
```bash
psql -U postgres -d shopdb -f database/init.sql
```

### 데이터베이스 연결 설정

`src/main/resources/db.properties` 파일을 확인하고 필요시 수정:

```properties
db.url=jdbc:postgresql://localhost:5432/shopdb
db.username=postgres
db.password=postgres
```

**주의**: 운영 환경에서는 보안을 위해 강력한 비밀번호를 사용하세요.

---

## 3. WAR 파일 빌드

### Windows에서 빌드
```cmd
gradlew.bat clean war
```

### Linux/Mac에서 빌드
```bash
./gradlew clean war
```

빌드가 완료되면 `build/libs/shop.war` 파일이 생성됩니다.

---

## 4. Tomcat에 배포

### 방법 1: WAR 파일 복사 (권장)

1. Tomcat의 `webapps` 디렉토리에 WAR 파일 복사:
```cmd
copy build\libs\shop.war C:\tomcat\webapps\
```

2. Tomcat 시작:
```cmd
C:\tomcat\bin\startup.bat
```

3. Tomcat이 자동으로 WAR 파일을 압축 해제하고 배포합니다.

### 방법 2: Tomcat Manager 사용

1. 브라우저에서 Tomcat Manager 접속:
   - URL: `http://localhost:8080/manager/html`

2. "WAR file to deploy" 섹션에서 `shop.war` 파일 선택 후 업로드

---

## 5. 애플리케이션 접속

배포 완료 후 다음 URL로 접속:

```
http://localhost:8080/shop/
```

또는

```
http://localhost:8080/shop/products
```

---

## 6. 테스트

### 기능 테스트 체크리스트

- [ ] 메인 페이지에서 상품 목록으로 자동 리다이렉트
- [ ] 상품 목록이 정상적으로 표시되는지 확인
- [ ] 상품 카드에 이름, 가격, 재고 정보가 표시되는지 확인
- [ ] Bootstrap 스타일이 올바르게 적용되었는지 확인
- [ ] 반응형 디자인이 작동하는지 확인 (브라우저 크기 조절)

### 로그 확인

Tomcat 로그 확인:
```
C:\tomcat\logs\catalina.out (Linux/Mac)
C:\tomcat\logs\catalina.yyyy-mm-dd.log (Windows)
```

애플리케이션 로그에서 다음 메시지 확인:
```
INFO  c.s.util.DatabaseUtil - Database connection pool initialized successfully
INFO  c.s.controller.ProductListServlet - ProductListServlet initialized
INFO  c.s.dao.ProductDAO - Retrieved X active products
```

---

## 7. 문제 해결

### PostgreSQL 연결 오류
- PostgreSQL 서비스가 실행 중인지 확인
- `db.properties`의 연결 정보가 올바른지 확인
- 방화벽에서 PostgreSQL 포트(5432)가 열려있는지 확인

### Tomcat 배포 오류
- JDK 버전이 17 이상인지 확인
- Tomcat 버전이 10.x 이상인지 확인 (Jakarta EE 지원)
- `logs` 디렉토리의 에러 로그 확인

### 상품 목록이 비어있는 경우
- `database/init.sql`이 정상적으로 실행되었는지 확인
- PostgreSQL에서 데이터 확인:
```sql
SELECT * FROM products WHERE active = true;
```

---

## 8. 다음 단계

현재 구현된 기능:
- ✅ 상품 목록 조회

향후 구현 예정:
- 상품 상세 조회
- 상품 등록/수정/비활성화
- 장바구니 기능
- 주문 기능

---

## 9. 개발 환경에서 실행 (IDE)

IntelliJ IDEA나 Eclipse에서:

1. 프로젝트를 Gradle 프로젝트로 import
2. Tomcat 서버 설정 추가
3. WAR exploded 모드로 실행
4. `http://localhost:8080` 접속

---

## 참고사항

- WAR 파일명: `shop.war`
- Context Path: `/shop`
- 기본 포트: `8080` (Tomcat 설정에 따라 변경 가능)
- Java Version: 17
- Servlet API: Jakarta Servlet 6.0
