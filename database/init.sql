-- 쇼핑몰 데이터베이스 초기화 스크립트

-- 데이터베이스 생성 (필요시)
-- CREATE DATABASE shopdb;

-- 상품 테이블 생성
CREATE TABLE IF NOT EXISTS products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    price NUMERIC(10, 2) NOT NULL CHECK (price >= 0),
    stock INTEGER NOT NULL DEFAULT 0 CHECK (stock >= 0),
    image_url VARCHAR(500),
    active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 인덱스 생성
CREATE INDEX idx_products_active ON products(active);
CREATE INDEX idx_products_created_at ON products(created_at DESC);

-- 샘플 데이터 삽입
INSERT INTO products (name, description, price, stock, image_url, active) VALUES
('노트북 - Dell XPS 13', '13인치 고성능 노트북, Intel Core i7, 16GB RAM, 512GB SSD', 1500000, 25, 'https://via.placeholder.com/300x200?text=Dell+XPS+13', true),
('무선 마우스 - Logitech MX Master 3', '인체공학적 디자인의 고급 무선 마우스', 129000, 50, 'https://via.placeholder.com/300x200?text=Logitech+MX+Master+3', true),
('기계식 키보드 - Keychron K8', 'RGB 백라이트, 무선/유선 겸용 키보드', 159000, 30, 'https://via.placeholder.com/300x200?text=Keychron+K8', true),
('모니터 - LG 27인치 4K', 'IPS 패널, 4K UHD 해상도, HDR 지원', 450000, 15, 'https://via.placeholder.com/300x200?text=LG+27inch+4K', true),
('USB-C 허브', '7포트 USB-C 멀티포트 어댑터', 59000, 100, 'https://via.placeholder.com/300x200?text=USB-C+Hub', true),
('웹캠 - Logitech C920', 'Full HD 1080p 웹캠, 자동 초점 기능', 89000, 40, 'https://via.placeholder.com/300x200?text=Logitech+C920', true),
('헤드셋 - Sony WH-1000XM5', '노이즈 캐슬링 무선 헤드셋', 399000, 20, 'https://via.placeholder.com/300x200?text=Sony+WH-1000XM5', true),
('외장 SSD - Samsung T7', '1TB 포터블 SSD, USB 3.2 Gen 2', 149000, 60, 'https://via.placeholder.com/300x200?text=Samsung+T7', true),
('스마트폰 - iPhone 15 Pro', '6.1인치, A17 Pro 칩, 256GB', 1550000, 8, 'https://via.placeholder.com/300x200?text=iPhone+15+Pro', true),
('태블릿 - iPad Air', '10.9인치 Liquid Retina 디스플레이, M1 칩', 899000, 12, 'https://via.placeholder.com/300x200?text=iPad+Air', true);

-- 업데이트 트리거 생성 (updated_at 자동 갱신)
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_products_updated_at BEFORE UPDATE
    ON products FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- 데이터 확인
SELECT COUNT(*) as total_products FROM products;
SELECT * FROM products WHERE active = true ORDER BY created_at DESC;
