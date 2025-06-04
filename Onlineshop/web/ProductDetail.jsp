<%@ page import="Model.Account" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
    </head>



    <body>

        <!-- Topbar Start -->
        <div class="container-fluid">
            <div class="row bg-secondary py-1 px-xl-5">
                <div class="col-lg-6 d-none d-lg-block">
                    <div class="d-inline-flex align-items-center h-100">
                        <a class="text-body mr-3" href="">About</a>
                        <a class="text-body mr-3" href="">Contact</a>
                        <a class="text-body mr-3" href="">Help</a>
                        <a class="text-body mr-3" href="">FAQs</a>
                    </div>
                </div>
                <div class="col-lg-6 text-center text-lg-right">
                    <div class="d-inline-flex align-items-center">
                        <% if(session.getAttribute("account") != null) { 
                            Account acc = (Account)session.getAttribute("account");
                        %>
                        <div class="btn-group">
                            <button type="button" class="btn btn-sm btn-light dropdown-toggle" data-toggle="dropdown">
                                <%= acc.getUsername() %>
                            </button>
                            <div class="dropdown-menu dropdown-menu-right">
                                <a href="VoucherController" class="dropdown-item">Voucher của tôi</a>
                                <a href="#" class="dropdown-item" data-toggle="modal" data-target="#logoutModal">Đăng xuất</a>
                            </div>
                        </div>
                        <% } else { %>
                        <a href="login.jsp" class="btn btn-sm btn-light mr-2">Đăng nhập</a>
                        <a href="register.jsp" class="btn btn-sm btn-light">Đăng ký</a>
                        <% } %>
                    </div>
                    <div class="d-inline-flex align-items-center d-block d-lg-none">
                        <a href="" class="btn px-0 ml-2">
                            <i class="fas fa-heart text-dark"></i>
                            <span class="badge text-dark border border-dark rounded-circle" style="padding-bottom: 2px;">0</span>
                        </a>
                        <a href="" class="btn px-0 ml-2">
                            <i class="fas fa-shopping-cart text-dark"></i>
                            <span class="badge text-dark border border-dark rounded-circle" style="padding-bottom: 2px;">0</span>
                        </a>
                    </div>
                </div>
            </div>
            <div class="row align-items-center bg-light py-3 px-xl-5 d-none d-lg-flex">
                <div class="col-lg-4">
                    <a href="Homepage" class="text-decoration-none">
                        <span class="h1 text-uppercase text-light bg-pink px-2">Flower</span>
                        <span class="h1 text-uppercase text-pink bg-light px-2 ml-n1">Shop</span>
                    </a>
                </div>
                <div class="col-lg-4 col-6 text-left">
                    <form action="SearchProductByTitle">
                        <div class="input-group">
                            <input type="text" name="txt" class="form-control" placeholder="Search for products" value="${txt}">
                            <button type="submit" class="icon-search-button">
                                <i class="icon icon-search"></i> 
                            </button>
                        </div>
                    </form>
                </div>
                <div class="col-lg-4 col-6 text-right">
                    <p class="m-0">Customer Service</p>
                    <h5 class="m-0">+012 345 6789</h5>
                </div>
            </div>
        </div>
        <!-- Topbar End -->


        <!-- Navbar Start -->
        <div class="container-fluid bg-pink mb-0 p-0 sticky-navbar">
            <div class="row px-xl-5">
                <div class="col-lg-12">
                    <nav class="navbar navbar-expand-lg bg-pink navbar-dark py-3 py-lg-0 px-0 w-100">

                        <a href="#" class="text-decoration-none d-block d-lg-none">
                            <span class="h1 text-uppercase text-light bg-pink px-2">Shop</span>
                            <span class="h1 text-uppercase text-pink bg-light px-2 ml-n1">Hoa</span>
                        </a>

                        <button type="button" class="navbar-toggler" data-toggle="collapse" data-target="#navbarCollapse">
                            <span class="navbar-toggler-icon"></span>
                        </button>

                        <div class="collapse navbar-collapse justify-content-center" id="navbarCollapse">
                            <div class="navbar-nav py-0">
                                <a href="Homepage" class="nav-item nav-link">Home</a>
                                <a href="ViewListProductController" class="nav-item nav-link active">Shop</a>
                                <a href="detail.html" class="nav-item nav-link">Shop Detail</a>
                                <a href="VoucherController" class="nav-item nav-link">Voucher</a>
                                <div class="nav-item dropdown">
                                    <a href="#" class="nav-link dropdown-toggle" data-toggle="dropdown">Pages <i class="fa fa-angle-down mt-1"></i></a>
                                    <div class="dropdown-menu bg-primary rounded-0 border-0 m-0">
                                        <a href="Cart.jsp" class="dropdown-item">Shopping Cart</a>
                                        <a href="CheckOut.jsp" class="dropdown-item">Checkout</a>
                                    </div>
                                </div>
                                <a href="contact.html" class="nav-item nav-link">Contact</a>
                            </div>
                        </div>

                        <div class="d-none d-lg-flex align-items-center ml-auto">
                            <a href="#" class="btn px-0">
                                <i class="fas fa-heart text-primary"></i>
                                <span class="badge text-secondary border border-secondary rounded-circle" style="padding-bottom: 2px;">0</span>
                            </a>
                            <a href="Cart.jsp" class="btn px-0 ml-3">
                                <i class="fas fa-shopping-cart text-primary"></i>
                                <span class="badge text-secondary border border-secondary rounded-circle" style="padding-bottom: 2px;">
                                    ${sessionScope.cartItemCount != null ? sessionScope.cartItemCount : (sessionScope.cart != null ? sessionScope.cart.getTotalItems() : 0)}
                                </span>
                            </a>
                        </div>
                    </nav>
                </div>
            </div>
        </div>
        <!-- Navbar End -->

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
                                    <img src="${detail.getImage()}" 
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

                        <!-- Đơn vị -->
                        <p style="font-size: 1.2rem;"><strong>Đơn vị:</strong> ${detail.getUnit()}</p>

                        <!-- Số lượng -->
                        <c:choose>
                            <c:when test="${detail.getQuantity() == 0}">
                                <p style="font-size: 1.2rem;"><strong>Số lượng:</strong> <span class="text-danger">Hết hàng</span></p>
                            </c:when>
                            <c:otherwise>
                                <p style="font-size: 1.2rem;"><strong>Số lượng:</strong> ${detail.getQuantity()}</p>
                            </c:otherwise>
                        </c:choose>

                        <!-- Nút thêm vào giỏ & yêu thích -->
                        <div class="mt-4">
                            <form action="cart" class="d-inline-block mr-2">
                                <input type="hidden" name="id" value="${detail.getProductID()}">
                                <input type="hidden" name="num" value="1">
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

                            <a href="addWishList?pid=${detail.getProductID()}" class="btn btn-outline-danger btn-lg">
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

                <!-- Form gửi bình luận -->
                <form action="AddRatingController" method="post" class="p-4 border rounded bg-white shadow-sm">
                    <input type="hidden" name="pid" value="${detail.getProductID()}" />

                    <!-- Căn chữ "Đánh giá:" và sao cùng hàng -->
                    <div class="form-group d-flex align-items-center">
                        <label class="mb-0 mr-3" style="min-width: 80px;">Đánh giá:</label>
                        <div class="star-rating d-flex flex-row-reverse">
                            <c:forEach var="i" begin="1" end="5">
                                <input type="radio" id="star${i}" name="rating" value="${i}" style="display: none;" />
                                <label for="star${i}" class="star" title="${i} sao">&#9733;</label>
                            </c:forEach>
                        </div>
                    </div>

                    <!-- Bình luận -->
                    <div class="form-group">
                        <label for="comment">Bình luận:</label>
                        <textarea name="comment" id="comment" class="form-control" rows="4" placeholder="Viết bình luận..." required></textarea>
                    </div>

                    <button type="submit" class="btn btn-success mt-3">Gửi bình luận</button>
                </form>

            </div>
        </section>






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

