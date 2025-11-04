package com.shop.controller;

import com.shop.dao.ProductDAO;
import com.shop.model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.util.List;

@WebServlet("/products")
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

        try {
            // 활성 상품 목록 조회
            List<Product> products = productDAO.findAllActiveProducts();

            // 요청 속성에 상품 목록 설정
            request.setAttribute("products", products);
            request.setAttribute("productCount", products.size());

            logger.info("Forwarding to product list view with {} products", products.size());

            // JSP 뷰로 포워딩
            request.getRequestDispatcher("/views/product-list.jsp").forward(request, response);

        } catch (Exception e) {
            logger.error("Error processing product list request", e);
            request.setAttribute("errorMessage", "상품 목록을 불러오는데 실패했습니다.");
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
