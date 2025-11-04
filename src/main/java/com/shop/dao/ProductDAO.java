package com.shop.dao;

import com.shop.model.Product;
import com.shop.util.DatabaseUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {
    private static final Logger logger = LoggerFactory.getLogger(ProductDAO.class);

    /**
     * 모든 활성 상품 목록 조회
     */
    public List<Product> findAllActiveProducts() {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT id, name, description, price, stock, image_url, active, created_at, updated_at " +
                     "FROM products WHERE active = true ORDER BY created_at DESC";

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
