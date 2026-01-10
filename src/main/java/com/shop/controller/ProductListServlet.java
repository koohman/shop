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
        
        // 활성 상품 목록 조회 (정렬 옵션 전달)
        List<Product> products = productDAO.findAllActiveProducts(sortBy);

        // 요청 속성에 상품 목록 및 정렬 옵션 설정
        request.setAttribute("products", products);
        request.setAttribute("productCount", products.size());
        request.setAttribute("sortBy", sortBy);

        logger.info("Forwarding to product list view with {} products, sorted by: {}", products.size(), sortBy);

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
