<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${product.name} - 쇼핑몰</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .product-image {
            max-width: 100%;
            height: auto;
            max-height: 500px;
            object-fit: contain;
            background-color: #f8f9fa;
        }
        .price {
            font-size: 2rem;
            font-weight: bold;
            color: #0d6efd;
        }
        .stock-info {
            font-size: 1.1rem;
        }
        .stock-available {
            color: #198754;
        }
        .stock-low {
            color: #ffc107;
        }
        .stock-out {
            color: #dc3545;
        }
        .product-detail-section {
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            margin-top: 20px;
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
                        <a class="nav-link" href="${pageContext.request.contextPath}/products">상품 목록</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="container mt-4">
        <!-- Breadcrumb -->
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/products">상품 목록</a></li>
                <li class="breadcrumb-item active" aria-current="page">${product.name}</li>
            </ol>
        </nav>

        <div class="row">
            <!-- Product Image -->
            <div class="col-md-6">
                <div class="card">
                    <img src="${product.imageUrl != null ? product.imageUrl : 'https://via.placeholder.com/500x500?text=No+Image'}"
                         class="card-img-top product-image" alt="${product.name}">
                </div>
            </div>

            <!-- Product Information -->
            <div class="col-md-6">
                <h1 class="mb-3">${product.name}</h1>

                <div class="price mb-4">
                    <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="₩"/>
                </div>

                <div class="stock-info mb-4">
                    <strong>재고 상태:</strong>
                    <c:choose>
                        <c:when test="${product.stock > 10}">
                            <span class="stock-available">재고: ${product.stock}개 (충분)</span>
                        </c:when>
                        <c:when test="${product.stock > 0}">
                            <span class="stock-low">재고: ${product.stock}개 (품절임박)</span>
                        </c:when>
                        <c:otherwise>
                            <span class="stock-out">품절</span>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="mb-4">
                    <c:choose>
                        <c:when test="${product.stock > 0}">
                            <button class="btn btn-primary btn-lg w-100" disabled>
                                장바구니 담기 (준비중)
                            </button>
                        </c:when>
                        <c:otherwise>
                            <button class="btn btn-secondary btn-lg w-100" disabled>
                                품절
                            </button>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="mb-3">
                    <a href="${pageContext.request.contextPath}/products" class="btn btn-outline-secondary w-100">
                        목록으로 돌아가기
                    </a>
                </div>
            </div>
        </div>

        <!-- Product Description -->
        <div class="row mt-5">
            <div class="col-12">
                <div class="product-detail-section">
                    <h3>상품 설명</h3>
                    <hr>
                    <p class="lead">${product.description}</p>
                </div>
            </div>
        </div>

        <!-- Product Meta Information -->
        <c:if test="${product.createdAt != null}">
            <div class="row mt-3">
                <div class="col-12">
                    <small class="text-muted">
                        등록일: ${product.createdAt.toString().substring(0, 16).replace('T', ' ')}
                    </small>
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
