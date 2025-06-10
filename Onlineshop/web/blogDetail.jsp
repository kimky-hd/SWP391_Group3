<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Chi tiết bài viết</title>
        <!-- ====================== Bootstrap CSS ====================== -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/lib/bootstrap/css/bootstrap.min.css" />

        <!-- Font Awesome (nếu header/footer dùng icon fa-*) -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/lib/fontawesome/css/all.min.css" />

        <!-- Custom CSS (ví dụ: css/style.css) -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" />
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #f9f9f9;
                margin: 0;
                padding: 0;
            }
            .container {
                width: 90%;
                max-width: 1000px;
                margin: 20px auto;
                background-color: #fff;
                padding: 20px 30px;
                border-radius: 6px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            }
            h2.page-heading {
                text-align: center;
                font-size: 26px;
                margin-bottom: 10px;
                color: #333;
            }
            p.sub-heading {
                text-align: center;
                color: #777;
                margin-bottom: 25px;
                font-size: 14px;
            }
            .back-btn {
                display: inline-block;
                margin-bottom: 20px;
                text-decoration: none;
                color: #333;
                background-color: #ececec;
                padding: 8px 14px;
                border-radius: 4px;
                border: 1px solid #ddd;
                font-size: 14px;
            }
            .back-btn:hover {
                background-color: #e2e2e2;
            }
            .blog-title {
                font-size: 24px;
                margin-bottom: 10px;
                color: #333;
                border-bottom: 2px solid #eee;
                padding-bottom: 8px;
                word-wrap: break-word;
                overflow-wrap: break-word;
                white-space: pre-wrap;
            }
            .blog-meta {
                color: #777;
                font-size: 13px;
                margin-bottom: 20px;
            }
            /* CSS mới: hiển thị full ảnh, giữ nguyên tỉ lệ */
            .blog-image-detail {
                width: 100%;      /* chạy hết chiều ngang container */
                height: auto;     /* chiều cao tự điều chỉnh theo tỉ lệ gốc */
                margin-bottom: 20px;
                border-radius: 6px;
                border: 1px solid #ddd;
            }
            .blog-content {
                font-size: 15px;
                line-height: 1.7;
                color: #444;
                margin-bottom: 30px;
                word-wrap: break-word;
                overflow-wrap: break-word;
                white-space: pre-wrap;
            }
            .no-data {
                text-align: center;
                color: #d9534f;
                font-size: 16px;
                margin-top: 50px;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h2 class="page-heading">Chi tiết bài viết</h2>
            <jsp:include page="/header.jsp" />
            <p class="sub-heading">Xem nội dung đầy đủ của bài viết</p>

            <a class="back-btn" href="${pageContext.request.contextPath}/blogs?action=list">
                &laquo; Quay về danh sách
            </a>

            <c:if test="${not empty blog}">
                <h3 class="blog-title">${blog.title}</h3>

                <p class="blog-meta">
                    Đăng bởi tài khoản ID: <strong>${blog.accountID}</strong>
                    &nbsp;|&nbsp;
                    Ngày đăng: <strong>${blog.datePosted}</strong>
                </p>

                <c:choose>
                    <c:when test="${not empty blog.image}">
                        <img src="${pageContext.request.contextPath}/img/${blog.image}"
                             alt="Ảnh bài viết"
                             class="blog-image-detail"/>
                    </c:when>
                    <c:otherwise>
                        <img src="${pageContext.request.contextPath}/img/default.png"
                             alt="Không có ảnh"
                             class="blog-image-detail"/>
                    </c:otherwise>
                </c:choose>

                <div class="blog-content">
                    ${blog.content}
                </div>
            </c:if>

            <c:if test="${empty blog}">
                <p class="no-data">Không tìm thấy bài viết.</p>
            </c:if>
        </div>
        <!-- Footer Start -->
        <div class="container-fluid bg-pink text-secondary mt-5 pt-5">
            <div class="row px-xl-5 pt-5">
                <div class="col-lg-4 col-md-12 mb-5 pr-3 pr-xl-5">
                    <h5 class="text-secondary text-uppercase mb-4">Get In Touch</h5>
                    <p class="mb-4">No dolore ipsum accusam no lorem. Invidunt sed clita kasd clita et et dolor sed dolor. Rebum tempor no vero est magna amet no</p>
                    <p class="mb-2"><i class="fa fa-map-marker-alt text-primary mr-3"></i>123 Street, New York, USA</p>
                    <p class="mb-2"><i class="fa fa-envelope text-primary mr-3"></i>info@example.com</p>
                    <p class="mb-0"><i class="fa fa-phone-alt text-primary mr-3"></i>+012 345 67890</p>
                </div>
                <div class="col-lg-8 col-md-12">
                    <div class="row">
                        <div class="col-md-4 mb-5">
                            <h5 class="text-secondary text-uppercase mb-4">Quick Shop</h5>
                            <div class="d-flex flex-column justify-content-start">
                                <a class="text-secondary mb-2" href="#"><i class="fa fa-angle-right mr-2"></i>Home</a>
                                <a class="text-secondary mb-2" href="#"><i class="fa fa-angle-right mr-2"></i>Our Shop</a>
                                <a class="text-secondary mb-2" href="#"><i class="fa fa-angle-right mr-2"></i>Shop Detail</a>
                                <a class="text-secondary mb-2" href="#"><i class="fa fa-angle-right mr-2"></i>Shopping Cart</a>
                                <a class="text-secondary mb-2" href="#"><i class="fa fa-angle-right mr-2"></i>Checkout</a>
                                <a class="text-secondary" href="#"><i class="fa fa-angle-right mr-2"></i>Contact Us</a>
                            </div>
                        </div>
                        <div class="col-md-4 mb-5">
                            <h5 class="text-secondary text-uppercase mb-4">My Account</h5>
                            <div class="d-flex flex-column justify-content-start">
                                <a class="text-secondary mb-2" href="#"><i class="fa fa-angle-right mr-2"></i>Home</a>
                                <a class="text-secondary mb-2" href="#"><i class="fa fa-angle-right mr-2"></i>Our Shop</a>
                                <a class="text-secondary mb-2" href="#"><i class="fa fa-angle-right mr-2"></i>Shop Detail</a>
                                <a class="text-secondary mb-2" href="#"><i class="fa fa-angle-right mr-2"></i>Shopping Cart</a>
                                <a class="text-secondary mb-2" href="#"><i class="fa fa-angle-right mr-2"></i>Checkout</a>
                                <a class="text-secondary" href="#"><i class="fa fa-angle-right mr-2"></i>Contact Us</a>
                            </div>
                        </div>
                        <div class="col-md-4 mb-5">
                            <h5 class="text-secondary text-uppercase mb-4">Newsletter</h5>
                            <p>Duo stet tempor ipsum sit amet magna ipsum tempor est</p>
                            <form action="">
                                <div class="input-group">
                                    <input type="text" class="form-control" placeholder="Your Email Address">
                                    <div class="input-group-append">
                                        <button class="btn btn-primary">Sign Up</button>
                                    </div>
                                </div>
                            </form>
                            <h6 class="text-secondary text-uppercase mt-4 mb-3">Follow Us</h6>
                            <div class="d-flex">
                                <a class="btn btn-primary btn-square mr-2" href="#"><i class="fab fa-twitter"></i></a>
                                <a class="btn btn-primary btn-square mr-2" href="#"><i class="fab fa-facebook-f"></i></a>
                                <a class="btn btn-primary btn-square mr-2" href="#"><i class="fab fa-linkedin-in"></i></a>
                                <a class="btn btn-primary btn-square" href="#"><i class="fab fa-instagram"></i></a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row border-top mx-xl-5 py-4" style="border-color: rgba(256, 256, 256, .1) !important;">
                <div class="col-md-6 px-xl-0">
                    <p class="mb-md-0 text-center text-md-left text-secondary">
                        &copy; <a class="text-primary" href="#">Domain</a>. All Rights Reserved.
                    </p>
                </div>
                <div class="col-md-6 px-xl-0 text-center text-md-right">
                    <img class="img-fluid" src="img/payments.png" alt="">
                </div>
            </div>
        </div>
        <a href="#" class="btn btn-primary back-to-top"><i class="fa fa-angle-double-up"></i></a>


        <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.bundle.min.js"></script>
        <script src="lib/easing/easing.min.js"></script>
        <script src="lib/owlcarousel/owl.carousel.min.js"></script>

        <script src="js/main.js"></script>
        <!-- Footer End -->

    </body>
</html>
