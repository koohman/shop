package com.shop.controller;

import com.shop.dao.ProductDAO;
import com.shop.model.Product;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet("/products/*")
public class ProductListServlet extends HttpServlet {
    private static final Logger logger = LoggerFactory.getLogger(ProductListServlet.class);
    private ProductDAO productDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        productDAO = new ProductDAO();
        logger.info("ProductListServlet initialized");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();

        try {
            // pathInfo가 null 또는 "/"인 경우 목록 조회
            if (pathInfo == null || pathInfo.equals("/")) {
                showProductList(request, response);
            } else {
                // pathInfo가 "/{id}" 형태인 경우 상세 조회
                showProductDetail(request, response, pathInfo);
            }
        } catch (Exception e) {
            logger.error("Error processing product request", e);
            request.setAttribute("errorMessage", "요청을 처리하는데 실패했습니다.");
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private void showProductList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 정렬 파라미터 추출
        String sortBy = request.getParameter("sort");
        
        // 파라미터 검증 (null이거나 잘못된 값이면 "latest"로 설정)
        if (sortBy == null || !isValidSortBy(sortBy)) {
            sortBy = "latest";
        }
        
        // 필터 파라미터 추출
        String priceMinStr = request.getParameter("priceMin");
        String priceMaxStr = request.getParameter("priceMax");
        String stockStatus = request.getParameter("stockStatus");
        String searchKeyword = request.getParameter("search");
        
        // 파라미터 검증 및 변환
        BigDecimal priceMin = parsePrice(priceMinStr);
        BigDecimal priceMax = parsePrice(priceMaxStr);
        stockStatus = validateStockStatus(stockStatus);
        searchKeyword = sanitizeSearchKeyword(searchKeyword);
        
        // 필터 조건에 따라 상품 목록 조회
        List<Product> products = productDAO.findByFilters(
            sortBy, priceMin, priceMax, stockStatus, searchKeyword
        );

        // 요청 속성에 상품 목록 및 정렬 옵션, 필터 값 설정
        request.setAttribute("products", products);
        request.setAttribute("productCount", products.size());
        request.setAttribute("sortBy", sortBy);
        request.setAttribute("filterPriceMin", priceMin);
        request.setAttribute("filterPriceMax", priceMax);
        request.setAttribute("filterStockStatus", stockStatus);
        request.setAttribute("filterSearchKeyword", searchKeyword);

        logger.info("Forwarding to product list view with {} products, sorted by: {}, filters: priceMin={}, priceMax={}, stockStatus={}, search={}", 
                    products.size(), sortBy, priceMin, priceMax, stockStatus, searchKeyword);

        // JSP 뷰로 포워딩
        request.getRequestDispatcher("/views/product-list.jsp").forward(request, response);
    }

    /**
     * 정렬 파라미터 유효성 검증
     * @param sortBy 정렬 옵션
     * @return 유효한 값이면 true, 그렇지 않으면 false
     */
    private boolean isValidSortBy(String sortBy) {
        return "latest".equals(sortBy) || "price_asc".equals(sortBy) || "price_desc".equals(sortBy);
    }

    /**
     * 가격 문자열을 BigDecimal로 변환
     * @param priceStr 가격 문자열
     * @return BigDecimal 값, 변환 실패 시 null
     */
    private BigDecimal parsePrice(String priceStr) {
        if (priceStr == null || priceStr.trim().isEmpty()) {
            return null;
        }
        try {
            BigDecimal price = new BigDecimal(priceStr.trim());
            // 음수는 null로 처리
            if (price.compareTo(BigDecimal.ZERO) < 0) {
                return null;
            }
            return price;
        } catch (NumberFormatException e) {
            logger.warn("Invalid price format: {}", priceStr);
            return null;
        }
    }

    /**
     * 재고 상태 파라미터 검증
     * @param status 재고 상태
     * @return 유효한 재고 상태, 검증 실패 시 "all"
     */
    private String validateStockStatus(String status) {
        if (status == null || status.trim().isEmpty()) {
            return null;
        }
        String trimmed = status.trim();
        if ("all".equals(trimmed) || "available".equals(trimmed) || 
            "low".equals(trimmed) || "out".equals(trimmed)) {
            return trimmed;
        }
        logger.warn("Invalid stock status: {}, defaulting to null", status);
        return null;
    }

    /**
     * 검색어 정제 (SQL injection 방지)
     * @param keyword 검색어
     * @return 정제된 검색어, null이거나 공백인 경우 null 반환
     */
    private String sanitizeSearchKeyword(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return null;
        }
        // 공백 제거 및 길이 제한 (100자)
        String sanitized = keyword.trim();
        if (sanitized.length() > 100) {
            sanitized = sanitized.substring(0, 100);
        }
        // 특수 문자 제거는 하지 않음 (검색 정확도 유지를 위해)
        // SQL injection은 PreparedStatement의 LIKE로 처리하여 방지
        return sanitized;
    }

    private void showProductDetail(HttpServletRequest request, HttpServletResponse response, String pathInfo)
            throws ServletException, IOException {
        try {
            // pathInfo에서 ID 추출 (예: "/123" -> "123")
            String idStr = pathInfo.substring(1);
            Long productId = Long.parseLong(idStr);

            // 상품 조회
            Product product = productDAO.findById(productId);

            if (product == null) {
                logger.warn("Product not found with id: {}", productId);
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "상품을 찾을 수 없습니다.");
                return;
            }

            // 요청 속성에 상품 설정
            request.setAttribute("product", product);

            logger.info("Forwarding to product detail view for product id: {}", productId);

            // JSP 뷰로 포워딩
            request.getRequestDispatcher("/views/product-detail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            logger.error("Invalid product ID format: {}", pathInfo, e);
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "잘못된 상품 ID입니다.");
        }
    }
}
