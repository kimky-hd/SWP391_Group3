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
    border-radius: 15px;
    overflow: hidden;
    box-shadow: 0 4px 15px rgba(0,0,0,0.08);
    transition: all 0.4s cubic-bezier(0.25, 0.8, 0.25, 1);
    background: #fff;
    height: 100%;
    display: flex;
    flex-direction: column;
}

.product-item:hover {
    transform: translateY(-8px);
    box-shadow: 0 12px 35px rgba(0,0,0,0.15);
}

.product-img {
    height: 250px;
    position: relative;
    overflow: hidden;
    background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
}

.product-img img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    transition: transform 0.6s ease;
}

.product-item:hover .product-img img {
    transform: scale(1.1);
}

/* Product Info Section */
.text-center.py-4 {
    padding: 20px 15px !important;
    flex: 1;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
}

.product-item h6 {
    font-size: 16px;
    font-weight: 600;
    color: #2c3e50;
    margin-bottom: 10px;
    line-height: 1.4;
    height: 44px;
    overflow: hidden;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
}

.product-item h5 {
    color: #e74c3c;
    font-weight: 700;
    font-size: 18px;
    margin: 0;
}

/* Enhanced Product Actions */
.product-action {
    background: rgba(255, 255, 255, 0.95);
    backdrop-filter: blur(10px);
    border-radius: 12px;
    margin: 15px;
    padding: 10px;
    opacity: 0;
    transform: translateY(20px);
}

.product-item:hover .product-action {
    opacity: 1;
    transform: translateY(0);
    transition: all 0.4s ease 0.1s;
}

.product-action .btn {
    width: 40px;
    height: 40px;
    border-radius: 50%;
    margin: 0 5px;
    border: 2px solid #FFD333;
    color: #FFD333;
    background: white;
    transition: all 0.3s ease;
}

.product-action .btn:hover {
    background: #FFD333;
    color: white;
    transform: scale(1.1);
}
/* Enhanced Categories */
.cat-item {
    border-radius: 12px;
    padding: 20px;
    transition: all 0.4s ease;
    background: white;
    box-shadow: 0 2px 10px rgba(0,0,0,0.05);
    border: 1px solid #f1f1f1;
}

.cat-item:hover {
    background: linear-gradient(135deg, #FFD333 0%, #ffed4e 100%);
    transform: translateY(-5px);
    box-shadow: 0 8px 25px rgba(255, 211, 51, 0.3);
}

.cat-item img {
    border-radius: 8px;
    transition: transform 0.4s ease;
}

.cat-item:hover img {
    transform: scale(1.1) rotate(2deg);
}

.cat-item h6 {
    font-weight: 600;
    color: #2c3e50;
    margin: 0;
    transition: color 0.3s ease;
}

.cat-item:hover h6 {
    color: #2c3e50;
}
/* Enhanced Carousel */
#header-carousel {
    border-radius: 15px;
    overflow: hidden;
    box-shadow: 0 8px 30px rgba(0,0,0,0.12);
}

.carousel-item {
    position: relative;
}

.carousel-item::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: linear-gradient(45deg, rgba(0,0,0,0.3) 0%, rgba(0,0,0,0.1) 100%);
    z-index: 1;
}

.carousel-caption {
    z-index: 2;
    background: none;
}

.carousel-caption h1 {
    text-shadow: 2px 2px 4px rgba(0,0,0,0.5);
    font-weight: 700;
}

.carousel-caption p {
    text-shadow: 1px 1px 2px rgba(0,0,0,0.5);
    font-size: 18px;
}

/* Enhanced Carousel Indicators */
.carousel-indicators li {
    width: 12px;
    height: 12px;
    border-radius: 50%;
    background: rgba(255,255,255,0.5);
    border: 2px solid white;
    transition: all 0.3s ease;
}

.carousel-indicators .active {
    width: 30px;
    border-radius: 15px;
    background: #FFD333;
}
/* Enhanced Product Offers */
.product-offer {
    border-radius: 12px;
    overflow: hidden;
    box-shadow: 0 6px 20px rgba(0,0,0,0.1);
    transition: transform 0.4s ease;
}

.product-offer:hover {
    transform: scale(1.02);
}

.offer-text {
    background: linear-gradient(135deg, rgba(0,0,0,0.7) 0%, rgba(0,0,0,0.4) 100%);
    backdrop-filter: blur(5px);
}

.offer-text h6 {
    font-size: 14px;
    letter-spacing: 1px;
    margin-bottom: 8px;
}

.offer-text h3 {
    font-weight: 700;
    margin-bottom: 15px;
}

.offer-text .btn {
    border-radius: 25px;
    padding: 8px 25px;
    font-weight: 600;
    transition: all 0.3s ease;
}
/* Enhanced Section Titles */
.section-title {
    font-size: 2.5rem;
    font-weight: 700;
    color: #2c3e50;
    margin-bottom: 3rem;
    position: relative;
}

.section-title span {
    background: linear-gradient(135deg, #FFD333 0%, #ffed4e 100%);
    padding: 10px 30px;
    border-radius: 25px;
    color: #2c3e50;
    box-shadow: 0 4px 15px rgba(255, 211, 51, 0.3);
}

.section-title::after {
    border-top: 2px dashed #FFD333;
    opacity: 0.6;
}
/* Enhanced Pagination */
.pagination {
    margin-top: 3rem;
}

.page-link {
    border: 2px solid #f1f1f1;
    color: #2c3e50;
    padding: 10px 15px;
    margin: 0 3px;
    border-radius: 8px;
    transition: all 0.3s ease;
}

.page-link:hover {
    background: #FFD333;
    border-color: #FFD333;
    color: #2c3e50;
    transform: translateY(-2px);
}

.page-item.active .page-link {
    background: #FFD333;
    border-color: #FFD333;
    color: #2c3e50;
    box-shadow: 0 4px 15px rgba(255, 211, 51, 0.4);
}
/* Responsive Enhancements */
@media (max-width: 768px) {
    .product-img {
        height: 200px;
    }
    
    .section-title {
        font-size: 2rem;
    }
    
    .section-title span {
        padding: 8px 20px;
    }
    
    .cat-item {
        padding: 15px;
        margin-bottom: 15px;
    }
    
    .flower-fixed-btn {
        bottom: 20px;
        right: 20px;
    }
    
    .flower-fixed-btn a {
        width: 50px;
        height: 50px;
        font-size: 20px;
    }
}

@media (max-width: 576px) {
    .container-fluid {
        padding-left: 1rem;
        padding-right: 1rem;
    }
    
    .product-item h6 {
        font-size: 14px;
        height: auto;
    }
    
    .carousel-caption h1 {
        font-size: 1.8rem;
    }
    
    .carousel-caption p {
        font-size: 14px;
    }
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
                                            <a href="${banner.link}" class="btn btn-outline-light py-2 px-4 mt-3 animate__animated animate__fadeInUp">Vào Ngay</a>
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
                            <h6 class="text-white text-uppercase">Sale 50%</h6>
                            <h3 class="text-white mb-3">Special Offer</h3>
                            <a href="ViewListProductController" class="btn btn-primary">Vào Ngay</a>
                        </div>
                    </div>
                    <div class="product-offer mb-30" style="height: 200px;">
                        <img class="img-fluid" src="img/offer-2.jpg" alt="">
                        <div class="offer-text">
                            <h6 class="text-white text-uppercase">Sale 20%</h6>
                            <h3 class="text-white mb-3">Special Offer</h3>
                            <a href="ViewListProductController" class="btn btn-primary">Vào Ngay</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- Carousel End -->






        <!-- Categories Start -->
<div class="container-fluid pt-5">
    <h2 class="section-title position-relative text-uppercase mx-xl-5 mb-4"><span class="bg-secondary pr-3">Danh Mục Sản Phẩm</span></h2>
    <div class="row px-xl-5 pb-3">
        <c:forEach var="cat" items="${categories}" varStatus="status">
    <c:if test="${status.index < 4}">
        <div class="col-lg-3 col-md-4 col-sm-6 pb-1">
            <a class="text-decoration-none" href="ViewListProductController?category=${cat.categoryID}">
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
    </c:if>
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
        <script>
$(document).ready(function() {
    // Animate elements on scroll
    function animateOnScroll() {
        $('.product-item, .cat-item').each(function() {
            var elementTop = $(this).offset().top;
            var elementBottom = elementTop + $(this).outerHeight();
            var viewportTop = $(window).scrollTop();
            var viewportBottom = viewportTop + $(window).height();
            
            if (elementBottom > viewportTop && elementTop < viewportBottom) {
                $(this).addClass('loaded');
            }
        });
    }
    
    // Initial animation
    setTimeout(animateOnScroll, 100);
    
    // Animate on scroll
    $(window).scroll(animateOnScroll);
    
    // Smooth hover effects for product items
    $('.product-item').hover(
        function() {
            $(this).find('.product-img img').css('transform', 'scale(1.08)');
        },
        function() {
            $(this).find('.product-img img').css('transform', 'scale(1)');
        }
    );
    
    // Enhanced carousel auto-play
    $('#header-carousel').carousel({
        interval: 5000,
        pause: 'hover'
    });
    
    // Add loading effect to images
    $('img').on('load', function() {
        $(this).addClass('loaded');
    });
    
    // Parallax effect for carousel
    $(window).scroll(function() {
        var scrolled = $(window).scrollTop();
        var parallax = scrolled * 0.5;
        $('#header-carousel .carousel-item img').css('transform', 'translateY(' + parallax + 'px)');
    });
});
</script>
<script>
$(document).ready(function() {
    // Enhanced scroll animations
    function animateOnScroll() {
        $('.product-item, .cat-item').each(function(index) {
            var elementTop = $(this).offset().top;
            var elementBottom = elementTop + $(this).outerHeight();
            var viewportTop = $(window).scrollTop();
            var viewportBottom = viewportTop + $(window).height();
            
            if (elementBottom > viewportTop && elementTop < viewportBottom) {
                setTimeout(() => {
                    $(this).addClass('loaded');
                }, index * 100); // Staggered animation
            }
        });
    }
    
    // Intersection Observer for better performance
    if ('IntersectionObserver' in window) {
        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.classList.add('loaded');
                }
            });
        }, { threshold: 0.1 });
        
        document.querySelectorAll('.product-item, .cat-item').forEach(el => {
            observer.observe(el);
        });
    } else {
        // Fallback for older browsers
        animateOnScroll();
        $(window).scroll(animateOnScroll);
    }
    
    // Enhanced product hover effects
    $('.product-item').hover(
        function() {
            $(this).find('.product-img img').css({
                'transform': 'scale(1.1)',
                'filter': 'brightness(1.1)'
            });
        },
        function() {
            $(this).find('.product-img img').css({
                'transform': 'scale(1)',
                'filter': 'brightness(1)'
            });
        }
    );
    
    // Smooth page transitions
    $('a[href^="Homepage"]').on('click', function(e) {
        e.preventDefault();
        const href = $(this).attr('href');
        $('body').fadeOut(300, function() {
            window.location.href = href;
        });
    });
    
    // Loading animation for images
    $('img').each(function() {
        if (this.complete) {
            $(this).addClass('loaded');
        } else {
            $(this).on('load', function() {
                $(this).addClass('loaded');
            });
        }
    });
    
    // Enhanced carousel with touch support
    $('#header-carousel').carousel({
        interval: 6000,
        pause: 'hover',
        wrap: true,
        touch: true
    });
    
    // Parallax effect for hero section
    $(window).scroll(function() {
        const scrolled = $(window).scrollTop();
        const parallax = scrolled * 0.3;
        $('#header-carousel .carousel-item.active img').css('transform', `translateY(${parallax}px) scale(1.1)`);
    });
    
    // Smooth scroll for anchor links
    $('a[href^="#"]').on('click', function(e) {
        e.preventDefault();
        const target = $($(this).attr('href'));
        if (target.length) {
            $('html, body').animate({
                scrollTop: target.offset().top - 100
            }, 800);
        }
    });
});
</script>
        <!-- Sticky Button for Custom Order End -->
    </body>
</html>