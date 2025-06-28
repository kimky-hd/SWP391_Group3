<%@ page import="Model.Account" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <title>Flower Shop - Product List</title>
        <meta content="width=device-width, initial-scale=1.0" name="viewport">

        <!-- Google Web Fonts -->
        <link rel="preconnect" href="https://fonts.gstatic.com">
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">  

        <!-- Font Awesome -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">

        <!-- Libraries Stylesheet -->
        <link href="lib/animate/animate.min.css" rel="stylesheet">
        <link href="lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">


        <!-- Customized Bootstrap Stylesheet -->
        <link href="css/style.css" rel="stylesheet">
        <style>

            .product-img {
                height: 250px; /* Hoặc chiều cao mong muốn */
                display: flex;
                justify-content: center;
                align-items: center;
            }

            .product-img img {
                height: 100%;
                width: auto;
                object-fit: contain;
            }
            .sidebar-pink {
                background-color: #fce4ec;
                border-radius: 8px;
                padding: 20px;
            }
            .black-link {
                color: black;
                text-decoration: none; /* nếu không muốn gạch chân */
            }
            .icon-search-button {
                background-color: transparent;
                border: none;
                cursor: pointer;
            }
            .icon-search-button .icon {
                font-size: 20px; /* Điều chỉnh kích thước icon */
                color: #333; /* Màu của icon */
            }
            ul {
                list-style-type: disc;
                color: #333;
            }
            .sticky-navbar {
                position: sticky;
                top: 0;
                z-index: 1020;
                background-color: var(--primary);
            }

        </style>

        <style>
            .detail-box {
                background-color: #fff0f5;
                padding: 20px;
                border-radius: 12px;
                border: 1px solid #f8bbd0;
                margin-top: 20px;
            }

            .detail-box h5 {
                font-weight: bold;
                color: #d63384;
                margin-bottom: 15px;
            }

            .detail-box ul {
                padding-left: 20px;
                color: #333;
            }

            .detail-box li {
                margin-bottom: 6px;
                font-size: 1rem;
                line-height: 1.4;
            }

            .label-title {
                font-weight: bold;
                color: #444;
                display: inline-block;
                width: 100px;
            }

            .text-danger {
                font-weight: bold;
                color: #dc3545;
            }

            .badge {
                font-size: 0.9rem;
                padding: 6px 12px;
                border-radius: 20px;
                display: inline-block;
                margin: 4px 4px 0 0;
                text-decoration: none;
                transition: background-color 0.3s ease, color 0.3s ease;
            }

            .bg-info {
                background-color: #cce5ff;
            }

            .badge.bg-info:hover {
                background-color: #339af0;
                color: #fff !important;
            }

            .text-dark {
                color: #333 !important;
            }

            .me-1 {
                margin-right: 0.5rem !important;
            }

            .category-label {
                display: block;
                font-weight: bold;
                margin-top: 15px;
                color: #444;
            }
            .badge.bg-warning:hover {
                background-color: #ffca2c;
                color: #000 !important;
            }

            .badge.bg-success:hover {
                background-color: #198754;
                color: #fff !important;
            }

        </style>

    </head>



    <body>

        <!-- Topbar Start -->
        <jsp:include page="header.jsp" />
        <!-- Topbar End -->




        <!-- Product Start -->

        <section class="product-detail-section py-5">
            <div class="container">
                <!-- Tên sản phẩm & Đánh giá lệch trái -->
                <div class="mb-4">
                    <h2 class="font-weight-bold text-left">${detail.getTitle()}</h2>
                    <p class="text-left mb-0"><span class="text-warning font-weight-bold">${rate} ★</span></p>
                </div>

                <!-- Bố cục chính -->
                <div class="row align-items-stretch">
                    <!-- Trái: ảnh + mô tả (nền hồng) -->
                    <div class="col-md-7">
                        <div class="p-4 rounded h-100" style="background-color: #f78fb3;">
                            <div class="row">
                                <!-- Ảnh -->
                                <div class="col-md-6 text-center mb-3 mb-md-0">
                                    <img src="${pageContext.request.contextPath}/img/${detail.getImage()}" 
                                         alt="${detail.getTitle()}" 
                                         class="img-fluid bg-white rounded p-2 shadow" 
                                         style="max-height: 300px; object-fit: contain;">
                                </div>
                                <!-- Mô tả -->
                                <div class="col-md-6 text-white d-flex align-items-center">
                                    <p class="mb-0" style="font-size: 1.1rem;">${detail.getDescription()}</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Phải: giá, đơn vị, số lượng, nút -->
                    <div class="col-md-5 mt-4 mt-md-0">
                        <!-- KHUNG GIÁ -->
                        <div class="bg-white rounded shadow-sm p-3 mb-4 text-center">
                            <h5 class="text-muted mb-1">Giá</h5>
                            <h3 class="text-danger font-weight-bold mb-0">
                                <fmt:formatNumber value="${detail.getPrice()}" type="number"/> VNĐ
                            </h3>
                        </div>



                        <!-- Thành phần nguyên liệu -->
                        <div class="detail-box mt-4">
                            <h5>Thành phần sản phẩm:</h5>
                            <ul>
                                <c:forEach var="comp" items="${componentList}">
                                    <li>${comp.material.name}: ${comp.materialQuantity} ${comp.material.unit}</li>
                                    </c:forEach>
                            </ul>

                            <!-- Số lượng -->
                            <p><span class="label-title">Số lượng:</span>
                                <c:choose>
                                    <c:when test="${detail.getQuantity() == 0}">
                                        <span class="text-danger">Hết hàng</span>
                                    </c:when>
                                    <c:otherwise>
                                        ${detail.getQuantity()}
                                    </c:otherwise>
                                </c:choose>
                            </p>

                            <!-- Status -->
                            <p><span class="label-title">Tình trạng:</span> ${detail.status}</p>

                            <!-- Danh mục -->
                            <p class="category-label">Danh mục:</p>
                            <c:if test="${not empty categoryList}">
                                <c:forEach var="cat" items="${categoryList}">
                                    <a href="productlist?categoryID=${cat.categoryID}" class="badge bg-info text-dark me-1">${cat.categoryName}</a>
                                </c:forEach>
                            </c:if>
                            <c:if test="${empty categoryList}">
                                <span><em>Không có</em></span>
                            </c:if>
                        </div>



                        <!-- Nút thêm vào giỏ & yêu thích -->
                        <div class="mt-4">
                            <form action="cart" method="get" class="d-inline-block mr-2">
                                <input type="hidden" name="action" value="add">
                                <input type="hidden" name="productId" value="${detail.getProductID()}">
                                <input type="hidden" name="quantity" value="1">
                                <c:choose>
                                    <c:when test="${detail.getQuantity() == 0}">
                                        <button type="button" class="btn btn-secondary btn-lg" disabled>
                                            <i class="fas fa-shopping-cart mr-1"></i> Hết hàng
                                        </button>
                                    </c:when>
                                    <c:otherwise>
                                        <button type="submit" class="btn btn-primary btn-lg">
                                            <i class="fas fa-shopping-cart mr-1"></i> Thêm vào giỏ
                                        </button>
                                    </c:otherwise>
                                </c:choose>
                            </form>

                            <a href="AddWishlistController?pid=${detail.getProductID()}" class="btn btn-outline-danger btn-lg">
                                <i class="far fa-heart mr-1"></i> Yêu thích
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </section>
        <!-- Product End -->

        <!<!-- Rate and Comment -->

        <section class="comment-section py-5 bg-light">
            <div class="container">
                <h4 class="mb-4">Bình luận (${totalFeedback})</h4>

                <!-- Danh sách bình luận -->
                <ul class="list-unstyled mb-5">
                    <c:forEach items="${listFeedback}" var="feedback">
                        <c:forEach items="${listAccountProfile}" var="profile">
                            <c:if test="${feedback.getAccount_ID() == profile.getAccount_ID()}">
                                <li class="mb-3 p-3 border rounded bg-white shadow-sm">
                                    <strong>${profile.getFullName()}</strong> 
                                    <span class="text-warning">${feedback.getRate()} ★</span><br>
                                    <span>${feedback.getComment()}</span>
                                </li>
                            </c:if>
                        </c:forEach>
                    </c:forEach>
                </ul>

                

            </div>
        </section>






        <!-- Footer Start -->
        <jsp:include page="footer.jsp" />

        <!-- Footer End -->

        <style>.comment-section {
                background: #fff;
                padding: 25px;
                border-radius: 12px;
                box-shadow: 0 0 15px rgba(0,0,0,0.07);
                max-width: 700px;
                margin: 0 auto;
                font-family: 'Segoe UI', sans-serif;
            }

            .comment-title {
                font-size: 20px;
                margin-bottom: 20px;
                color: #333;
            }

            .comment-list {
                list-style: none;
                padding-left: 0;
                margin-bottom: 20px;
            }

            .comment-item {
                padding: 12px 15px;
                border-bottom: 1px solid #eee;
                display: flex;
                flex-direction: column;
                margin-bottom: 10px;
            }

            .comment-author {
                font-weight: bold;
                color: #2c3e50;
            }

            .comment-text {
                margin-top: 5px;
                color: #555;
            }

            .comment-star {
                margin-top: 5px;
                color: #f39c12;
                font-weight: bold;
            }

            .comment-divider {
                border-top: 1px solid #ccc;
                margin: 30px 0;
            }

            .comment-form .form-label {
                font-weight: bold;
                margin-top: 10px;
                display: block;
            }





            textarea.form-control {
                width: 100%;
                padding: 12px;
                border-radius: 8px;
                border: 1px solid #ccc;
                resize: vertical;
                margin-top: 5px;
                font-size: 14px;
            }

            .submit-button {
                background-color: #3498db;
                color: #fff;
                padding: 10px 25px;
                border: none;
                border-radius: 30px;
                font-weight: bold;
                cursor: pointer;
                transition: background-color 0.3s;
                margin-top: 15px;
            }

            .submit-button:hover {
                background-color: #2980b9;
            }
        </style>
        <style>
            .star-rating label {
                font-size: 24px;
                color: #ccc;
                cursor: pointer;
                transition: color 0.2s;
                margin-right: 5px;
            }

            .star-rating input:checked ~ label,
            .star-rating label:hover,
            .star-rating label:hover ~ label {
                color: #f39c12;
            }

        </style>

        <!-- JavaScript Libraries -->
        <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.bundle.min.js"></script>
        <script src="lib/easing/easing.min.js"></script>
        <script src="lib/owlcarousel/owl.carousel.min.js"></script>

        <!-- Template Javascript -->
        <script src="js/main.js"></script>

        <script>
            document.addEventListener("DOMContentLoaded", function () {
                var messageBox = document.getElementById("message-box");
                if (messageBox.innerHTML.trim() !== "") {
                    messageBox.style.display = "block";
                    setTimeout(function () {
                        messageBox.style.display = "none";
                    }, 3000); // Ẩn sau 3 giây
                }
            });
        </script>
    </body>
</html>

