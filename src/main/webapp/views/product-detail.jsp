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
        /* 메인 컬러 변수 (product-list.jsp와 동일) */
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

        .navbar-nav .nav-link:hover {
            background-color: rgba(255, 255, 255, 0.1);
            border-radius: 4px;
        }

        /* 상품 이미지 스타일 */
        .product-image {
            max-width: 100%;
            height: auto;
            max-height: 500px;
            object-fit: contain;
            background-color: var(--light-bg);
            border-radius: 12px;
            padding: 20px;
        }

        .product-image-card {
            border: none;
            border-radius: 12px;
            box-shadow: var(--card-shadow);
            overflow: hidden;
        }

        /* 가격 표시 개선 */
        .price {
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: 1.5rem;
        }

        /* 재고 상태 스타일 */
        .stock-info {
            font-size: 1.1rem;
            margin-bottom: 1.5rem;
        }

        .stock-badge {
            padding: 0.5rem 1rem;
            font-size: 1rem;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
            border-radius: 8px;
            margin-left: 0.5rem;
        }

        .stock-available {
            color: var(--success-color);
            font-weight: 500;
        }

        .stock-low {
            color: var(--warning-color);
            font-weight: 500;
        }

        .stock-out {
            color: var(--danger-color);
            font-weight: 500;
        }

        /* 상품 정보 영역 */
        .product-info-card {
            padding: 2rem;
            background-color: white;
            border-radius: 12px;
            box-shadow: var(--card-shadow);
        }

        .product-info-card h1 {
            font-size: 2rem;
            font-weight: 700;
            color: #333;
            margin-bottom: 1.5rem;
        }

        /* 상품 설명 영역 */
        .product-detail-section {
            background: linear-gradient(to bottom, #ffffff, var(--light-bg));
            padding: 2rem;
            border-radius: 12px;
            margin-top: 2rem;
            box-shadow: var(--card-shadow);
            border: 1px solid rgba(0,0,0,0.05);
        }

        .product-detail-section h3 {
            font-size: 1.5rem;
            font-weight: 600;
            color: #333;
            margin-bottom: 1rem;
        }

        .product-detail-section hr {
            margin: 1rem 0 1.5rem 0;
            opacity: 0.1;
        }

        .product-detail-section .lead {
            font-size: 1.1rem;
            line-height: 1.8;
            color: #555;
        }

        /* 버튼 스타일 개선 */
        .btn-primary {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
            border-radius: 8px;
            font-weight: 500;
            padding: 0.75rem 1.5rem;
            transition: all 0.2s ease;
        }

        .btn-primary:hover:not(:disabled) {
            background-color: var(--primary-dark);
            border-color: var(--primary-dark);
            transform: translateY(-1px);
            box-shadow: 0 2px 8px rgba(0, 102, 204, 0.3);
        }

        .btn-outline-secondary {
            border-radius: 8px;
            font-weight: 500;
            padding: 0.75rem 1.5rem;
            transition: all 0.2s ease;
        }

        .btn-outline-secondary:hover {
            transform: translateY(-1px);
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        /* Breadcrumb 스타일 */
        .breadcrumb {
            background-color: transparent;
            padding: 0;
            margin-bottom: 2rem;
        }

        .breadcrumb-item a {
            color: var(--primary-color);
            text-decoration: none;
        }

        .breadcrumb-item a:hover {
            text-decoration: underline;
        }

        /* 반응형 디자인 */
        @media (max-width: 767.98px) {
            .price {
                font-size: 2rem;
            }

            .product-info-card h1 {
                font-size: 1.5rem;
            }

            .product-info-card {
                padding: 1.5rem;
                margin-top: 1rem;
            }

            .product-detail-section {
                padding: 1.5rem;
            }

            .navbar-brand {
                font-size: 1.25rem;
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
            <div class="col-md-6 mb-4">
                <div class="card product-image-card">
                    <c:choose>
                        <c:when test="${product.imageUrl != null && product.imageUrl != ''}">
                            <img src="${product.imageUrl}" class="card-img-top product-image" alt="${product.name}">
                        </c:when>
                        <c:otherwise>
                            <div class="card-img-top product-image d-flex align-items-center justify-content-center bg-light" style="min-height: 500px;">
                                <span class="text-muted fs-4">이미지 없음</span>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Product Information -->
            <div class="col-md-6 mb-4">
                <div class="product-info-card">
                    <h1>${product.name}</h1>

                    <div class="price">
                        <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="₩"/>
                    </div>

                    <div class="stock-info">
                        <strong>재고 상태:</strong>
                        <c:choose>
                            <c:when test="${product.stock > 10}">
                                <span class="badge bg-success stock-badge">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" fill="currentColor" class="bi bi-check-circle me-1" viewBox="0 0 16 16">
                                        <path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14zm0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16z"/>
                                        <path d="M10.97 4.97a.235.235 0 0 0-.02.022L7.477 9.417 2.384 6.323a.75.75 0 0 0-1.06 1.061l4.97 4.97a.75.75 0 0 0 1.079-.02l3.992-4.99a.75.75 0 0 0-1.071-1.05z"/>
                                    </svg>
                                    재고: ${product.stock}개 (충분)
                                </span>
                            </c:when>
                            <c:when test="${product.stock > 0}">
                                <span class="badge bg-warning text-dark stock-badge">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" fill="currentColor" class="bi bi-exclamation-triangle me-1" viewBox="0 0 16 16">
                                        <path d="M7.938 2.016A.13.13 0 0 1 8.002 2a.13.13 0 0 1 .063.016.146.146 0 0 1 .054.057l6.857 11.667c.036.06.035.124.002.183a.163.163 0 0 1-.054.06.116.116 0 0 1-.066.017H1.146a.115.115 0 0 1-.066-.017.163.163 0 0 1-.054-.06.176.176 0 0 1 .002-.183L7.884 2.073a.147.147 0 0 1 .054-.057zm1.044-.45a1.13 1.13 0 0 0-1.96 0L.165 13.233c-.457.778.091 1.767.98 1.767h13.713c.889 0 1.438-.99.98-1.767L8.982 1.566z"/>
                                        <path d="M7.002 12a1 1 0 1 1 2 0 1 1 0 0 1-2 0zM7.1 5.995a.905.905 0 1 1 1.8 0l-.35 3.507a.552.552 0 0 1-1.1 0L7.1 5.995z"/>
                                    </svg>
                                    재고: ${product.stock}개 (품절임박)
                                </span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-danger stock-badge">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" fill="currentColor" class="bi bi-x-circle me-1" viewBox="0 0 16 16">
                                        <path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14zm0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16z"/>
                                        <path d="M4.646 4.646a.5.5 0 0 1 .708 0L8 7.293l2.646-2.647a.5.5 0 0 1 .708.708L8.707 8l2.647 2.646a.5.5 0 0 1-.708.708L8 8.707l-2.646 2.647a.5.5 0 0 1-.708-.708L7.293 8 4.646 5.354a.5.5 0 0 1 0-.708z"/>
                                    </svg>
                                    품절
                                </span>
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

                    <div>
                        <a href="${pageContext.request.contextPath}/products" class="btn btn-outline-secondary w-100">
                            목록으로 돌아가기
                        </a>
                    </div>
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
