<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>상품 목록 - 쇼핑몰</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .product-card {
            transition: transform 0.2s;
            height: 100%;
        }
        .product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        .product-image {
            height: 200px;
            object-fit: cover;
            background-color: #f8f9fa;
        }
        .price {
            font-size: 1.25rem;
            font-weight: bold;
            color: #0d6efd;
        }
        .stock-info {
            font-size: 0.9rem;
        }
        .stock-available {
            color: #198754;
        }
        .stock-low {
            color: #ffc107;
        }
        .sort-buttons {
            margin-bottom: 1rem;
        }
        .sort-buttons .btn-group {
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .sort-buttons .btn-outline-primary.active {
            background-color: #0d6efd;
            border-color: #0d6efd;
            color: white;
        }
        .sort-buttons .btn-outline-primary:hover {
            background-color: #0d6efd;
            border-color: #0d6efd;
            color: white;
        }
        @media (max-width: 768px) {
            .sort-buttons .btn-group {
                width: 100%;
            }
            .sort-buttons .btn {
                flex: 1;
            }
        }
    </style>
</head>
<body>
    <!-- Navigation Bar -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/products">쇼핑몰</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/products">상품 목록</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="container mt-4">
        <div class="row mb-4">
            <div class="col-md-6">
                <h2>상품 목록</h2>
                <p class="text-muted">전체 <strong>${productCount}</strong>개의 상품이 있습니다.</p>
            </div>
            <div class="col-md-6 d-flex justify-content-end align-items-start sort-buttons">
                <!-- 정렬 옵션 -->
                <div class="btn-group" role="group" aria-label="정렬 옵션">
                    <c:set var="currentSort" value="${sortBy != null ? sortBy : 'latest'}" />
                    <a href="${pageContext.request.contextPath}/products?sort=latest" 
                       class="btn btn-outline-primary ${currentSort == 'latest' ? 'active' : ''}">
                        최신순
                    </a>
                    <a href="${pageContext.request.contextPath}/products?sort=price_asc" 
                       class="btn btn-outline-primary ${currentSort == 'price_asc' ? 'active' : ''}">
                        낮은 가격순
                    </a>
                    <a href="${pageContext.request.contextPath}/products?sort=price_desc" 
                       class="btn btn-outline-primary ${currentSort == 'price_desc' ? 'active' : ''}">
                        높은 가격순
                    </a>
                </div>
            </div>
        </div>

        <!-- Product Grid -->
        <div class="row g-4">
            <c:forEach var="product" items="${products}">
                <div class="col-md-4 col-lg-3">
                    <div class="card product-card">
                        <c:choose>
                            <c:when test="${product.imageUrl != null && product.imageUrl != ''}">
                                <img src="${product.imageUrl}" class="card-img-top product-image" alt="${product.name}">
                            </c:when>
                            <c:otherwise>
                                <div class="card-img-top product-image d-flex align-items-center justify-content-center bg-light">
                                    <span class="text-muted">이미지 없음</span>
                                </div>
                            </c:otherwise>
                        </c:choose>
                        <div class="card-body d-flex flex-column">
                            <h5 class="card-title">${product.name}</h5>
                            <p class="card-text text-muted flex-grow-1">
                                <c:choose>
                                    <c:when test="${product.description.length() > 50}">
                                        ${product.description.substring(0, 50)}...
                                    </c:when>
                                    <c:otherwise>
                                        ${product.description}
                                    </c:otherwise>
                                </c:choose>
                            </p>
                            <div class="mt-2">
                                <div class="price mb-2">
                                    <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="₩"/>
                                </div>
                                <div class="stock-info mb-3">
                                    <c:choose>
                                        <c:when test="${product.stock > 10}">
                                            <span class="stock-available">재고: ${product.stock}개</span>
                                        </c:when>
                                        <c:when test="${product.stock > 0}">
                                            <span class="stock-low">재고: ${product.stock}개 (품절임박)</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-danger">품절</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <a href="${pageContext.request.contextPath}/products/${product.id}"
                                   class="btn btn-primary w-100">상세보기</a>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>

        <!-- Empty State -->
        <c:if test="${empty products}">
            <div class="row mt-5">
                <div class="col text-center">
                    <h4 class="text-muted">등록된 상품이 없습니다.</h4>
                    <p>새로운 상품을 등록해주세요.</p>
                </div>
            </div>
        </c:if>
    </div>

    <!-- Footer -->
    <footer class="mt-5 py-4 bg-light">
        <div class="container text-center text-muted">
            <p>&copy; 2024 쇼핑몰. All rights reserved.</p>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
