package com.shop.dao;

import com.shop.model.Product;
import com.shop.util.DatabaseUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {
    private static final Logger logger = LoggerFactory.getLogger(ProductDAO.class);

    /**
     * 모든 활성 상품 목록 조회
     * @param sortBy 정렬 옵션 ("latest", "price_asc", "price_desc")
     */
    public List<Product> findAllActiveProducts(String sortBy) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT id, name, description, price, stock, image_url, active, created_at, updated_at " +
                     "FROM products WHERE active = true ";
        
        // 정렬 옵션에 따라 ORDER BY 절 동적 생성
        if (sortBy == null) {
            sortBy = "latest"; // 기본값
        }
        
        switch (sortBy) {
            case "price_asc":
                sql += "ORDER BY price ASC";
                break;
            case "price_desc":
                sql += "ORDER BY price DESC";
                break;
            case "latest":
            default:
                sql += "ORDER BY created_at DESC";
                break;
        }

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                Product product = mapResultSetToProduct(rs);
                products.add(product);
            }

            logger.info("Retrieved {} active products", products.size());

        } catch (SQLException e) {
            logger.error("Error retrieving products", e);
            throw new RuntimeException("Failed to retrieve products", e);
        } finally {
            DatabaseUtil.close(rs, pstmt, conn);
        }

        return products;
    }

    /**
     * 필터 조건에 따라 활성 상품 목록 조회
     * @param sortBy 정렬 옵션 ("latest", "price_asc", "price_desc")
     * @param priceMin 최소 가격 (null 허용)
     * @param priceMax 최대 가격 (null 허용)
     * @param stockStatus 재고 상태 ("all", "available", "low", "out", null 허용)
     * @param searchKeyword 검색어 (null 허용)
     * @return 필터링된 상품 목록
     */
    public List<Product> findByFilters(String sortBy, BigDecimal priceMin, BigDecimal priceMax, 
                                       String stockStatus, String searchKeyword) {
        List<Product> products = new ArrayList<>();
        
        // SQL 기본 부분
        StringBuilder sql = new StringBuilder(
            "SELECT id, name, description, price, stock, image_url, active, created_at, updated_at " +
            "FROM products WHERE active = true "
        );
        
        // 파라미터 리스트 (PreparedStatement용)
        List<Object> parameters = new ArrayList<>();
        
        // 가격대 필터 추가
        if (priceMin != null) {
            sql.append("AND price >= ? ");
            parameters.add(priceMin);
        }
        if (priceMax != null) {
            sql.append("AND price <= ? ");
            parameters.add(priceMax);
        }
        
        // 재고 상태 필터 추가
        if (stockStatus != null && !stockStatus.isEmpty() && !"all".equals(stockStatus)) {
            switch (stockStatus) {
                case "available":
                    sql.append("AND stock > 10 ");
                    break;
                case "low":
                    sql.append("AND stock > 0 AND stock <= 10 ");
                    break;
                case "out":
                    sql.append("AND stock = 0 ");
                    break;
            }
        }
        
        // 검색어 필터 추가
        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            sql.append("AND (name LIKE ? OR description LIKE ?) ");
            String searchPattern = "%" + searchKeyword.trim() + "%";
            parameters.add(searchPattern);
            parameters.add(searchPattern);
        }
        
        // 정렬 옵션에 따라 ORDER BY 절 동적 생성
        if (sortBy == null) {
            sortBy = "latest"; // 기본값
        }
        
        switch (sortBy) {
            case "price_asc":
                sql.append("ORDER BY price ASC");
                break;
            case "price_desc":
                sql.append("ORDER BY price DESC");
                break;
            case "latest":
            default:
                sql.append("ORDER BY created_at DESC");
                break;
        }
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql.toString());
            
            // 파라미터 바인딩
            for (int i = 0; i < parameters.size(); i++) {
                Object param = parameters.get(i);
                if (param instanceof BigDecimal) {
                    pstmt.setBigDecimal(i + 1, (BigDecimal) param);
                } else if (param instanceof String) {
                    pstmt.setString(i + 1, (String) param);
                }
            }
            
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Product product = mapResultSetToProduct(rs);
                products.add(product);
            }
            
            logger.info("Retrieved {} products with filters: sortBy={}, priceMin={}, priceMax={}, stockStatus={}, search={}", 
                        products.size(), sortBy, priceMin, priceMax, stockStatus, searchKeyword);
            
        } catch (SQLException e) {
            logger.error("Error retrieving products with filters", e);
            throw new RuntimeException("Failed to retrieve products", e);
        } finally {
            DatabaseUtil.close(rs, pstmt, conn);
        }
        
        return products;
    }

    /**
     * 상품 ID로 단일 상품 조회
     */
    public Product findById(Long id) {
        String sql = "SELECT id, name, description, price, stock, image_url, active, created_at, updated_at " +
                     "FROM products WHERE id = ?";

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setLong(1, id);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                logger.info("Retrieved product with id: {}", id);
                return mapResultSetToProduct(rs);
            }

        } catch (SQLException e) {
            logger.error("Error retrieving product with id: {}", id, e);
            throw new RuntimeException("Failed to retrieve product", e);
        } finally {
            DatabaseUtil.close(rs, pstmt, conn);
        }

        return null;
    }

    /**
     * ResultSet을 Product 객체로 매핑
     */
    private Product mapResultSetToProduct(ResultSet rs) throws SQLException {
        Product product = new Product();
        product.setId(rs.getLong("id"));
        product.setName(rs.getString("name"));
        product.setDescription(rs.getString("description"));
        product.setPrice(rs.getBigDecimal("price"));
        product.setStock(rs.getInt("stock"));
        product.setImageUrl(rs.getString("image_url"));
        product.setActive(rs.getBoolean("active"));

        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            product.setCreatedAt(createdAt.toLocalDateTime());
        }

        Timestamp updatedAt = rs.getTimestamp("updated_at");
        if (updatedAt != null) {
            product.setUpdatedAt(updatedAt.toLocalDateTime());
        }

        return product;
    }
}
