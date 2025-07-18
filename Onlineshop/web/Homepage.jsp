<%-- 
    Document   : Homepage
    Created on : May 24, 2025, 11:28:41 PM
    Author     : Duccon
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Model.Account" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<jsp:include page="subiz-chat.jsp" />
<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="utf-8">
        <title>Flower Commerce Website</title>
        <meta content="width=device-width, initial-scale=1.0" name="viewport">
        <meta content="Free HTML Templates" name="keywords">
        <meta content="Free HTML Templates" name="description">

        <!-- Favicon -->
        <link href="img/favicon.ico" rel="icon">

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
            .product-item {
                height: 100%;
                display: flex;
                flex-direction: column;
                justify-content: space-between;
            }
            .product-img {
                height: 250px;
                display: flex;
                justify-content: center;
                align-items: center;
                background: #fff;
            }
            .product-img img {
                max-height: 100%;
                max-width: 100%;
                object-fit: contain;
            }
            .text-center.py-4 {
                flex: 1 1 auto;
            }
        </style>
    </head>

    <body>

        <jsp:include page="header.jsp" />


        <!-- Carousel Start -->
        <div class="container-fluid mb-3">
            <div class="row px-xl-5">
                <div class="col-lg-8">
                    <div id="header-carousel" class="carousel slide carousel-fade mb-30 mb-lg-0" data-ride="carousel">
                        <ol class="carousel-indicators">
                            <c:forEach var="banner" items="${banners}" varStatus="status">
                                <li data-target="#header-carousel" data-slide-to="${status.index}" class="${status.first ? 'active' : ''}"></li>
                            </c:forEach>
                        </ol>
                        <div class="carousel-inner">
                            <c:forEach var="banner" items="${banners}" varStatus="status">
                                <div class="carousel-item position-relative ${status.first ? 'active' : ''}" style="height: 430px;">
                                    <img class="position-absolute w-100 h-100" src="img/${banner.image}" style="object-fit: cover;">
                                    <div class="carousel-caption d-flex flex-column align-items-center justify-content-center">
                                        <div class="p-3" style="max-width: 700px;">
                                            <h1 class="display-4 text-white mb-3 animate__animated animate__fadeInDown">${banner.title}</h1>
                                            <p class="mx-md-5 px-5 animate__animated animate__bounceIn">${banner.description}</p>
                                            <a href="${banner.link}" class="btn btn-outline-light py-2 px-4 mt-3 animate__animated animate__fadeInUp">Shop Now</a>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>
                <div class="col-lg-4">
                    <div class="product-offer mb-30" style="height: 200px;">
                        <img class="img-fluid" src="img/offer-1.jpg" alt="">
                        <div class="offer-text">
                            <h6 class="text-white text-uppercase">Save 50%</h6>
                            <h3 class="text-white mb-3">Special Offer</h3>
                            <a href="ViewListProductController" class="btn btn-primary">Shop Now</a>
                        </div>
                    </div>
                    <div class="product-offer mb-30" style="height: 200px;">
                        <img class="img-fluid" src="img/offer-2.jpg" alt="">
                        <div class="offer-text">
                            <h6 class="text-white text-uppercase">Save 20%</h6>
                            <h3 class="text-white mb-3">Special Offer</h3>
                            <a href="ViewListProductController" class="btn btn-primary">Shop Now</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- Carousel End -->






        <!-- Categories Start -->
        <div class="container-fluid pt-5">
            <h2 class="section-title position-relative text-uppercase mx-xl-5 mb-4"><span class="bg-secondary pr-3">Categories</span></h2>
            <div class="row px-xl-5 pb-3">
                <c:forEach var="cat" items="${categories}">
                    <div class="col-lg-3 col-md-4 col-sm-6 pb-1">
                        <a class="text-decoration-none" href="Homepage?category=${cat.categoryID}">
                            <div class="cat-item d-flex align-items-center mb-4">
                                <div class="overflow-hidden" style="width: 100px; height: 100px;">
                                    <img class="img-fluid" src="img/cat-${cat.categoryID}.jpg" alt="${cat.categoryName}">
                                </div>
                                <div class="flex-fill pl-3">
                                    <h6>${cat.categoryName}</h6>
                                </div>
                            </div>
                        </a>
                    </div>
                </c:forEach>
            </div>
        </div>
        <!-- Categories End -->


        <!--         Products Start -->
        <div class="container-fluid pt-5 pb-3">
            <h2 class="section-title position-relative text-uppercase mx-xl-5 mb-4"><span class="bg-secondary pr-3">Featured Products</span></h2>
            <div class="row px-xl-5">
                <c:if test="${empty featuredProducts}">
                    <div class="alert alert-info w-100 text-center">Không có sản phẩm nào!</div>
                </c:if>
                <c:forEach var="product" items="${featuredProducts}">
                    <div class="col-lg-3 col-md-4 col-sm-6 pb-1">
                        <div class="product-item bg-light mb-4">
                            <div class="product-img position-relative overflow-hidden">
                                <img class="img-fluid w-100" src="${pageContext.request.contextPath}/img/${product.image}" alt="${product.title}">
                                <div class="product-action">
                                    <a class="btn btn-outline-dark btn-square" href="cart?action=add&productId=${product.productID}&quantity=1"><i class="fa fa-shopping-cart"></i></a>
                                    <a class="btn btn-outline-dark btn-square" href="AddWishlistController?pid=${product.productID}"><i class="far fa-heart"></i></a>
                                    <a class="btn btn-outline-dark btn-square" href="#"><i class="fa fa-sync-alt"></i></a>
                                    <a class="btn btn-outline-dark btn-square" href="ViewProductDetail?productid=${product.productID}"><i class="fa fa-search"></i></a>
                                </div>
                            </div>
                            <div class="text-center py-4">
                                <a class="h6 text-decoration-none text-truncate" href="ViewProductDetail?productid=${product.productID}">${product.title}</a>
                                <div class="d-flex align-items-center justify-content-center mt-2">
                                    <h5><fmt:formatNumber value="${product.price}" pattern="#,#00"/> VNĐ</h5>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
            <!-- Pagination Start -->
            <div class="row px-xl-5">
                <div class="col-12">
                    <nav>
                        <ul class="pagination justify-content-center">
                            <c:if test="${currentPage > 1}">
                                <li class="page-item">
                                    <a class="page-link" href="Homepage?page=${currentPage - 1}">Previous</a>
                                </li>
                            </c:if>
                            <c:forEach var="i" begin="1" end="${totalPages}">
                                <li class="page-item ${i == currentPage ? 'active' : ''}">
                                    <a class="page-link" href="Homepage?page=${i}">${i}</a>
                                </li>
                            </c:forEach>
                            <c:if test="${currentPage < totalPages}">
                                <li class="page-item">
                                    <a class="page-link" href="Homepage?page=${currentPage + 1}">Next</a>
                                </li>
                            </c:if>
                        </ul>
                    </nav>
                </div>
            </div>
            <!-- Pagination End -->
        </div>
        <!--Products End -->






        <!-- Footer Start -->

        <jsp:include page="footer.jsp" />
        <!-- Footer End -->


        <!-- Back to Top -->
        <a href="#" class="btn btn-primary back-to-top"><i class="fa fa-angle-double-up"></i></a>

        <!-- Logout Modal-->


        <!-- Thêm style cho modal -->


        <!-- Custom Javascript -->
        <script>
            $(document).ready(function () {
                // Xử lý sự kiện khi nhấn vào nút đăng xuất
                $('.dropdown-item[data-toggle="modal"]').on('click', function (e) {
                    e.preventDefault();
                    $('#logoutModal').modal('show');
                });
            });
        </script>

        <script src="https://widget.subiz.net/sbz/app.js?account_id=acpzooihzhalzeskamky"></script>

        <!-- JavaScript Libraries -->
        <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.bundle.min.js"></script>
        <script src="lib/easing/easing.min.js"></script>
        <script src="lib/owlcarousel/owl.carousel.min.js"></script>

        <!-- Contact Javascript File -->
        <script src="mail/jqBootstrapValidation.min.js"></script>
        <script src="mail/contact.js"></script>

        <!-- Template Javascript -->
        <script src="js/main.js"></script>
        <!-- Sticky Button for Custom Order -->
        <div class="flower-fixed-btn">
            <a href="CustomOrder.jsp" title="Đặt hoa theo yêu cầu">
                <i class="fas fa-seedling"></i> <!-- Bạn có thể thay bằng: fa-pencil-alt, fa-heart, fa-rose -->
            </a>
        </div>
        <!-- Sticky Button for Custom Order End -->
    </body>
</html>