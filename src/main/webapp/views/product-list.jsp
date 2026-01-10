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
        /* 메인 컬러 변수 */
        :root {
            --primary-color: #0066cc;
            --primary-dark: #004499;
            --secondary-color: #6c757d;
            --success-color: #28a745;
            --warning-color: #ffc107;
            --danger-color: #dc3545;
            --light-bg: #f8f9fa;
            --card-shadow: 0 2px 8px rgba(0,0,0,0.1);
            --card-shadow-hover: 0 4px 16px rgba(0,0,0,0.15);
            --nav-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        /* 네비게이션 바 개선 - T world 스타일 */
        .navbar {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-dark) 100%);
            box-shadow: var(--nav-shadow);
            padding: 1rem 0;
        }

        .navbar-brand {
            font-size: 1.5rem;
            font-weight: 700;
            letter-spacing: -0.5px;
        }

        .navbar-nav .nav-link {
            font-weight: 500;
            padding: 0.5rem 1rem;
            transition: all 0.2s ease;
        }

        .navbar-nav .nav-link:hover,
        .navbar-nav .nav-link.active {
            background-color: rgba(255, 255, 255, 0.1);
            border-radius: 4px;
        }

        /* 상품 카드 개선 */
        .product-card {
            border: none;
            border-radius: 12px;
            box-shadow: var(--card-shadow);
            transition: all 0.3s ease;
            height: 100%;
            overflow: hidden;
        }

        .product-card:hover {
            transform: translateY(-8px);
            box-shadow: var(--card-shadow-hover);
        }

        .product-image {
            height: 200px;
            object-fit: cover;
            background-color: var(--light-bg);
            border-radius: 12px 12px 0 0;
        }

        .product-card .card-body {
            padding: 1.25rem;
        }

        .card-title {
            font-size: 1.1rem;
            font-weight: 600;
            margin-bottom: 0.75rem;
            color: #333;
            min-height: 3rem;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        .card-text {
            font-size: 0.9rem;
            color: #666;
            line-height: 1.5;
        }

        /* 가격 표시 개선 */
        .price {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: 0.5rem;
        }

        /* 재고 상태 스타일 */
        .stock-info {
            font-size: 0.9rem;
        }

        .stock-badge {
            padding: 0.4rem 0.75rem;
            font-size: 0.85rem;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
            border-radius: 6px;
        }

        .stock-available {
            color: var(--success-color);
            font-weight: 500;
        }

        .stock-low {
            color: var(--warning-color);
            font-weight: 500;
        }

        /* 카드 버튼 스타일 */
        .product-card .btn-primary {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
            transition: all 0.2s ease;
        }

        .product-card .btn-primary:hover {
            background-color: var(--primary-dark);
            border-color: var(--primary-dark);
            transform: translateY(-1px);
            box-shadow: 0 2px 8px rgba(0, 102, 204, 0.3);
        }

        /* 정렬 버튼 개선 */
        .sort-buttons {
            margin-bottom: 1rem;
        }

        .sort-buttons .btn-group {
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            border-radius: 6px;
            overflow: hidden;
        }

        .sort-buttons .btn-outline-primary {
            border-color: var(--primary-color);
            color: var(--primary-color);
            transition: all 0.2s ease;
        }

        .sort-buttons .btn-outline-primary.active {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
            color: white;
        }

        .sort-buttons .btn-outline-primary:hover:not(.active) {
            background-color: rgba(0, 102, 204, 0.1);
            border-color: var(--primary-color);
        }

        /* 필터 패널 개선 */
        .filter-panel {
            background: linear-gradient(to bottom, #ffffff, var(--light-bg));
            border-radius: 12px;
            padding: 24px;
            margin-bottom: 24px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            border: 1px solid rgba(0,0,0,0.05);
        }

        .filter-section {
            margin-bottom: 24px;
        }

        .filter-section:last-child {
            margin-bottom: 0;
        }

        .filter-section label {
            font-weight: 600;
            margin-bottom: 12px;
            display: block;
            color: #333;
            font-size: 0.95rem;
        }

        .filter-buttons {
            margin-top: 20px;
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .filter-buttons .btn {
            border-radius: 6px;
            font-weight: 500;
            padding: 0.5rem 1.5rem;
            transition: all 0.2s ease;
        }

        .filter-buttons .btn:hover {
            transform: translateY(-1px);
            box-shadow: 0 2px 8px rgba(0,0,0,0.15);
        }

        .price-range-options {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .stock-status-options {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        /* 커스텀 라디오 버튼 스타일 */
        .form-check-input:checked {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
        }

        .form-check-input:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.25rem rgba(0, 102, 204, 0.25);
        }

        .form-check-label {
            cursor: pointer;
            user-select: none;
            padding-left: 0.5rem;
        }

        .search-input {
            width: 100%;
            border-radius: 6px;
            border: 1px solid #dee2e6;
            padding: 0.75rem;
            transition: all 0.2s ease;
        }

        .search-input:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.25rem rgba(0, 102, 204, 0.25);
        }

        /* 필터 버튼 스타일 */
        .btn[data-bs-toggle="collapse"] {
            border-radius: 6px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.75rem 1.5rem;
            transition: all 0.2s ease;
            border: 1px solid #dee2e6;
            background-color: white;
            color: #495057;
        }

        .btn[data-bs-toggle="collapse"]:hover {
            background-color: var(--light-bg);
            border-color: var(--primary-color);
            color: var(--primary-color);
            transform: translateY(-1px);
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        .btn[data-bs-toggle="collapse"]:focus {
            box-shadow: 0 0 0 0.25rem rgba(0, 102, 204, 0.25);
        }

        /* 필터 버튼 아이콘 애니메이션 */
        .btn[data-bs-toggle="collapse"] svg {
            transition: transform 0.3s ease;
        }

        .btn[data-bs-toggle="collapse"][aria-expanded="true"] svg {
            transform: rotate(180deg);
        }

        /* 반응형 디자인 */
        /* 모바일 (< 768px) */
        @media (max-width: 767.98px) {
            .container {
                padding-left: 1rem;
                padding-right: 1rem;
            }

            .sort-buttons .btn-group {
                width: 100%;
            }

            .sort-buttons .btn {
                flex: 1;
                font-size: 0.875rem;
                padding: 0.5rem;
            }

            .filter-panel {
                padding: 16px;
            }

            .filter-buttons {
                flex-direction: column;
            }

            .filter-buttons .btn {
                width: 100%;
            }

            .navbar-brand {
                font-size: 1.25rem;
            }

            .product-card {
                margin-bottom: 1.5rem;
            }

            /* 상품 그리드 1-2열 */
            .row.g-4 > [class*='col-'] {
                margin-bottom: 1rem;
            }

            h2 {
                font-size: 1.5rem;
            }

            .price {
                font-size: 1.25rem;
            }

            .card-title {
                font-size: 1rem;
                min-height: 2.5rem;
            }
        }

        /* 태블릿 (768px - 992px) */
        @media (min-width: 768px) and (max-width: 991.98px) {
            .product-card {
                margin-bottom: 1.5rem;
            }

            /* 상품 그리드 2-3열 */
            .col-md-4 {
                flex: 0 0 auto;
                width: 50%;
            }

            .filter-section {
                margin-bottom: 20px;
            }
        }

        /* 데스크톱 (> 992px) */
        @media (min-width: 992px) {
            .col-lg-3 {
                flex: 0 0 auto;
                width: 25%;
            }

            .product-card:hover {
                transform: translateY(-10px);
            }

            .filter-panel {
                padding: 28px;
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
                            <div class="mt-auto">
                                <div class="price mb-3">
                                    <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="₩"/>
                                </div>
                                <div class="stock-info mb-3">
                                    <c:choose>
                                        <c:when test="${product.stock > 10}">
                                            <span class="badge bg-success stock-badge">
                                                <svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" fill="currentColor" class="bi bi-check-circle me-1" viewBox="0 0 16 16">
                                                    <path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14zm0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16z"/>
                                                    <path d="M10.97 4.97a.235.235 0 0 0-.02.022L7.477 9.417 2.384 6.323a.75.75 0 0 0-1.06 1.061l4.97 4.97a.75.75 0 0 0 1.079-.02l3.992-4.99a.75.75 0 0 0-1.071-1.05z"/>
                                                </svg>
                                                재고: ${product.stock}개
                                            </span>
                                        </c:when>
                                        <c:when test="${product.stock > 0}">
                                            <span class="badge bg-warning text-dark stock-badge">
                                                <svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" fill="currentColor" class="bi bi-exclamation-triangle me-1" viewBox="0 0 16 16">
                                                    <path d="M7.938 2.016A.13.13 0 0 1 8.002 2a.13.13 0 0 1 .063.016.146.146 0 0 1 .054.057l6.857 11.667c.036.06.035.124.002.183a.163.163 0 0 1-.054.06.116.116 0 0 1-.066.017H1.146a.115.115 0 0 1-.066-.017.163.163 0 0 1-.054-.06.176.176 0 0 1 .002-.183L7.884 2.073a.147.147 0 0 1 .054-.057zm1.044-.45a1.13 1.13 0 0 0-1.96 0L.165 13.233c-.457.778.091 1.767.98 1.767h13.713c.889 0 1.438-.99.98-1.767L8.982 1.566z"/>
                                                    <path d="M7.002 12a1 1 0 1 1 2 0 1 1 0 0 1-2 0zM7.1 5.995a.905.905 0 1 1 1.8 0l-.35 3.507a.552.552 0 0 1-1.1 0L7.1 5.995z"/>
                                                </svg>
                                                재고: ${product.stock}개 (품절임박)
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-danger stock-badge">
                                                <svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" fill="currentColor" class="bi bi-x-circle me-1" viewBox="0 0 16 16">
                                                    <path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14zm0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16z"/>
                                                    <path d="M4.646 4.646a.5.5 0 0 1 .708 0L8 7.293l2.646-2.647a.5.5 0 0 1 .708.708L8.707 8l2.647 2.646a.5.5 0 0 1-.708.708L8 8.707l-2.646 2.647a.5.5 0 0 1-.708-.708L7.293 8 4.646 5.354a.5.5 0 0 1 0-.708z"/>
                                                </svg>
                                                품절
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <a href="${pageContext.request.contextPath}/products/${product.id}"
                                   class="btn btn-primary w-100 mt-auto" style="border-radius: 6px; font-weight: 500;">
                                    상세보기
                                </a>
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
