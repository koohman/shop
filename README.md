# 쇼핑몰 웹 애플리케이션

Java MVC 패턴을 사용한 쇼핑몰 웹 애플리케이션입니다.

## 기술 스택

- **언어**: Java 17
- **빌드 도구**: Gradle
- **웹 프레임워크**: Jakarta Servlet 6.0
- **데이터베이스**: PostgreSQL
- **프론트엔드**: JSP + Bootstrap 5
- **서버**: Apache Tomcat 10.x

## 현재 구현된 기능

### ✅ 1단계: 상품 목록 조회
- 활성화된 모든 상품 목록 표시
- Bootstrap을 활용한 반응형 UI
- 상품 카드에 이름, 설명, 가격, 재고 정보 표시
- 재고 상태에 따른 색상 표시 (충분/부족/품절)

## 프로젝트 구조

```
shop/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/shop/
│   │   │       ├── model/          # 모델 클래스 (Product 등)
│   │   │       ├── dao/            # 데이터 접근 계층
│   │   │       ├── controller/     # 서블릿 컨트롤러
│   │   │       └── util/           # 유틸리티 클래스
│   │   ├── resources/
│   │   │   └── db.properties       # DB 연결 설정
│   │   └── webapp/
│   │       ├── WEB-INF/
│   │       │   └── web.xml
│   │       ├── views/              # JSP 뷰 파일
│   │       └── index.jsp
├── database/
│   └── init.sql                    # DB 초기화 스크립트
├── build.gradle                    # Gradle 빌드 설정
└── DEPLOYMENT.md                   # 배포 가이드

```

## 빠른 시작

### 1. 데이터베이스 설정
```bash
# PostgreSQL 데이터베이스 생성
createdb shopdb

# 테이블 및 샘플 데이터 생성
psql -d shopdb -f database/init.sql
```

### 2. WAR 파일 빌드
```bash
# Windows
gradlew.bat clean war

# Linux/Mac
./gradlew clean war
```

### 3. Tomcat에 배포
```bash
# WAR 파일을 Tomcat webapps 디렉토리에 복사
copy build\libs\shop.war C:\tomcat\webapps\
```

### 4. 애플리케이션 실행
```
http://localhost:8080/shop/
```

상세한 배포 가이드는 [DEPLOYMENT.md](DEPLOYMENT.md)를 참고하세요.

## 향후 구현 예정 기능

- [ ] 상품 상세 조회
- [ ] 상품 등록/수정/비활성화
- [ ] 장바구니 기능
- [ ] 주문 기능
- [ ] 회원 관리

## MVC 패턴 구조

### Model (모델)
- `Product.java`: 상품 엔티티

### View (뷰)
- `product-list.jsp`: 상품 목록 화면

### Controller (컨트롤러)
- `ProductListServlet.java`: 상품 목록 요청 처리

### DAO (Data Access Object)
- `ProductDAO.java`: 상품 데이터 CRUD 작업

## 개발 환경 설정

### 필수 소프트웨어
- JDK 17 이상
- PostgreSQL 14 이상
- Apache Tomcat 10.x
- IDE (IntelliJ IDEA, Eclipse 등)

### 데이터베이스 설정
`src/main/resources/db.properties` 파일에서 DB 연결 정보 수정:
```properties
db.url=jdbc:postgresql://localhost:5432/shopdb
db.username=postgres
db.password=postgres
```

## 라이선스  

MIT License
