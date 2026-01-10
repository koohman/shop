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
        .filter-panel {
            background-color: #f8f9fa;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .filter-section {
            margin-bottom: 20px;
        }
        .filter-section:last-child {
            margin-bottom: 0;
        }
        .filter-section label {
            font-weight: 600;
            margin-bottom: 8px;
            display: block;
        }
        .filter-buttons {
            margin-top: 15px;
            display: flex;
            gap: 10px;
        }
        .price-range-options {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }
        .stock-status-options {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }
        .search-input {
            width: 100%;
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
        <!-- 필터 패널 -->
        <div class="mb-3">
            <button class="btn btn-outline-secondary w-100 w-md-auto" type="button" 
                    data-bs-toggle="collapse" data-bs-target="#filterCollapse" 
                    aria-expanded="false" aria-controls="filterCollapse">
                <i class="bi bi-funnel"></i> 검색 필터
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-chevron-down" viewBox="0 0 16 16">
                    <path fill-rule="evenodd" d="M1.646 4.646a.5.5 0 0 1 .708 0L8 10.293l5.646-5.647a.5.5 0 0 1 .708.708l-6 6a.5.5 0 0 1-.708 0l-6-6a.5.5 0 0 1 0-.708z"/>
                </svg>
            </button>
        </div>
        
        <div class="collapse mb-4" id="filterCollapse">
            <div class="filter-panel">
                <form method="get" action="${pageContext.request.contextPath}/products" id="filterForm">
                    <div class="row">
                        <!-- 가격대 필터 -->
                        <div class="col-md-4 filter-section">
                            <label>가격대</label>
                            <div class="price-range-options">
                                <c:set var="currentPriceRange" value="" />
                                <c:choose>
                                    <c:when test="${filterPriceMin == null && filterPriceMax == null}">
                                        <c:set var="currentPriceRange" value="all" />
                                    </c:when>
                                    <c:when test="${filterPriceMin != null && filterPriceMax != null && filterPriceMax == 500000}">
                                        <c:set var="currentPriceRange" value="0-500000" />
                                    </c:when>
                                    <c:when test="${filterPriceMin != null && filterPriceMax != null && filterPriceMin == 500000 && filterPriceMax == 1000000}">
                                        <c:set var="currentPriceRange" value="500000-1000000" />
                                    </c:when>
                                    <c:when test="${filterPriceMin != null && filterPriceMin == 1000000}">
                                        <c:set var="currentPriceRange" value="1000000+" />
                                    </c:when>
                                </c:choose>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="priceRange" id="priceAll" value="all"
                                           ${currentPriceRange == 'all' ? 'checked' : ''}>
                                    <label class="form-check-label" for="priceAll">전체</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="priceRange" id="price0_50" value="0-500000"
                                           ${currentPriceRange == '0-500000' ? 'checked' : ''}>
                                    <label class="form-check-label" for="price0_50">0-50만원</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="priceRange" id="price50_100" value="500000-1000000"
                                           ${currentPriceRange == '500000-1000000' ? 'checked' : ''}>
                                    <label class="form-check-label" for="price50_100">50-100만원</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="priceRange" id="price100plus" value="1000000+"
                                           ${currentPriceRange == '1000000+' ? 'checked' : ''}>
                                    <label class="form-check-label" for="price100plus">100만원 이상</label>
                                </div>
                            </div>
                        </div>
                        
                        <!-- 재고 상태 필터 -->
                        <div class="col-md-4 filter-section">
                            <label>재고 상태</label>
                            <div class="stock-status-options">
                                <c:set var="currentStockStatus" value="${filterStockStatus != null ? filterStockStatus : 'all'}" />
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="stockStatus" id="stockAll" value="all"
                                           ${currentStockStatus == 'all' || currentStockStatus == null ? 'checked' : ''}>
                                    <label class="form-check-label" for="stockAll">전체</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="stockStatus" id="stockAvailable" value="available"
                                           ${currentStockStatus == 'available' ? 'checked' : ''}>
                                    <label class="form-check-label" for="stockAvailable">재고 있음</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="stockStatus" id="stockLow" value="low"
                                           ${currentStockStatus == 'low' ? 'checked' : ''}>
                                    <label class="form-check-label" for="stockLow">품절임박</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="stockStatus" id="stockOut" value="out"
                                           ${currentStockStatus == 'out' ? 'checked' : ''}>
                                    <label class="form-check-label" for="stockOut">품절</label>
                                </div>
                            </div>
                        </div>
                        
                        <!-- 검색어 필터 -->
                        <div class="col-md-4 filter-section">
                            <label for="searchKeyword">검색어</label>
                            <input type="text" class="form-control search-input" id="searchKeyword" 
                                   name="search" placeholder="상품명 또는 설명 검색" 
                                   value="${filterSearchKeyword != null ? filterSearchKeyword : ''}">
                        </div>
                    </div>
                    
                    <!-- 정렬 옵션 (히든 필드로 유지) -->
                    <c:if test="${sortBy != null}">
                        <input type="hidden" name="sort" value="${sortBy}">
                    </c:if>
                    
                    <!-- 가격대 히든 필드 (JavaScript로 채워짐) -->
                    <input type="hidden" name="priceMin" id="priceMin">
                    <input type="hidden" name="priceMax" id="priceMax">
                    
                    <!-- 필터 버튼 -->
                    <div class="filter-buttons">
                        <button type="submit" class="btn btn-primary">필터 적용</button>
                        <a href="${pageContext.request.contextPath}/products" class="btn btn-outline-secondary">초기화</a>
                    </div>
                </form>
            </div>
        </div>

        <div class="row mb-4">
            <div class="col-md-6">
                <h2>상품 목록</h2>
                <p class="text-muted">전체 <strong>${productCount}</strong>개의 상품이 있습니다.</p>
            </div>
            <div class="col-md-6 d-flex justify-content-end align-items-start sort-buttons">
                <!-- 정렬 옵션 -->
                <div class="btn-group" role="group" aria-label="정렬 옵션">
                    <c:set var="currentSort" value="${sortBy != null ? sortBy : 'latest'}" />
                    <c:set var="queryParams" value="" />
                    <c:if test="${filterPriceMin != null}">
                        <c:set var="queryParams" value="${queryParams}&priceMin=${filterPriceMin}" />
                    </c:if>
                    <c:if test="${filterPriceMax != null}">
                        <c:set var="queryParams" value="${queryParams}&priceMax=${filterPriceMax}" />
                    </c:if>
                    <c:if test="${filterStockStatus != null && filterStockStatus != ''}">
                        <c:set var="queryParams" value="${queryParams}&stockStatus=${filterStockStatus}" />
                    </c:if>
                    <c:if test="${filterSearchKeyword != null && filterSearchKeyword != ''}">
                        <c:set var="queryParams" value="${queryParams}&search=${filterSearchKeyword}" />
                    </c:if>
                    <a href="${pageContext.request.contextPath}/products?sort=latest${queryParams}" 
                       class="btn btn-outline-primary ${currentSort == 'latest' ? 'active' : ''}">
                        최신순
                    </a>
                    <a href="${pageContext.request.contextPath}/products?sort=price_asc${queryParams}" 
                       class="btn btn-outline-primary ${currentSort == 'price_asc' ? 'active' : ''}">
                        낮은 가격순
                    </a>
                    <a href="${pageContext.request.contextPath}/products?sort=price_desc${queryParams}" 
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
                    <c:choose>
                        <c:when test="${filterPriceMin != null || filterPriceMax != null || 
                                      (filterStockStatus != null && filterStockStatus != '' && filterStockStatus != 'all') || 
                                      (filterSearchKeyword != null && filterSearchKeyword != '')}">
                            <h4 class="text-muted">필터 조건에 맞는 상품이 없습니다.</h4>
                            <p>다른 필터 조건을 시도해보세요.</p>
                            <a href="${pageContext.request.contextPath}/products" class="btn btn-outline-primary mt-3">필터 초기화</a>
                        </c:when>
                        <c:otherwise>
                            <h4 class="text-muted">등록된 상품이 없습니다.</h4>
                            <p>새로운 상품을 등록해주세요.</p>
                        </c:otherwise>
                    </c:choose>
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
    <script>
        // 가격대 필터 처리
        document.getElementById('filterForm').addEventListener('submit', function(e) {
            const priceRange = document.querySelector('input[name="priceRange"]:checked');
            const priceMinInput = document.getElementById('priceMin');
            const priceMaxInput = document.getElementById('priceMax');
            
            if (priceRange && priceRange.value !== 'all') {
                const range = priceRange.value;
                if (range === '0-500000') {
                    priceMinInput.value = '0';
                    priceMaxInput.value = '500000';
                } else if (range === '500000-1000000') {
                    priceMinInput.value = '500000';
                    priceMaxInput.value = '1000000';
                } else if (range === '1000000+') {
                    priceMinInput.value = '1000000';
                    priceMaxInput.value = '';
                }
            } else {
                priceMinInput.value = '';
                priceMaxInput.value = '';
            }
        });
    </script>
</body>
</html>
