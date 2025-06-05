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
        </style>
    </head>



    <body>
        <div class="toast-container"></div> 
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
        <div class="container-fluid bg-pink mb-30">
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
                                <a href="Homepage" class="nav-item nav-link active">Home</a>
                                <a href="ViewListProductController" class="nav-item nav-link">Shop</a>
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
                            <a href="order?action=view" class="btn px-0 ml-3">
                                <i class="fas fa-clipboard-list text-primary"></i>
                                <span class="badge text-secondary border border-secondary rounded-circle" style="padding-bottom: 2px;">
                                    ${sessionScope.orderCount != null ? sessionScope.orderCount : 0}
                                </span>
                            </a>
                        </div>
                    </nav>
                </div>
            </div>
        </div>
        <!-- Navbar End -->

        <!-- Product Start -->



        <section id="product-detail" class="leaf-pattern-overlay">
            <div class="container">
                <div class="row justify-content-center">
                    <div class="col-md-8">
                        <div class="row">
                            <div class="col-md-6">
                                <figure class="products-thumb">
                                    <img src="${detail.getImage()}" 
                                         alt="product" class="single-image" height="700px" width="350px">
                                </figure>
                            </div>
                            <div class="col-md-6">
                                <div class="product-entry">
                                    <h2 class="section-title divider">${detail.getTitle()}</h2>
                                    <div class="products-content">
                                        <div class="item-title">Mô tả: ${detail.getDescription()}</div><br>
                                        <div class="price-wrapper">
                                            <span class="price">Giá: <fmt:formatNumber value="${detail.getPrice()}" type="currency" currencySymbol="VNĐ" /></span>
                                        </div>
                                        <div class="price-wrapper">
                                            <span class="price">Còn lại: ${detail.getQuantity()} sản phẩm</span>
                                        </div>
                                        <div class="price-wrapper">
                                            <span class="price">AVG Rate: ${rate} ★</span>
                                        </div>
                                        <div class="btns-wrapper d-flex justify-content-center mt-3">
                                            <div class="btn-wrap mr-3">
                                                <a href="cart?action=add&productId=${detail.getProductID()}&quantity=1" class="btn btn-sm text-dark p-0">
                                                    <i class="fas fa-shopping-cart text-primary mr-1"></i>Add To Cart
                                                </a>
                                            </div>
                                            <div class="btn-wrap">
                                                <a href="wishlist?action=add&id=${detail.getProductID()}" class="btn-accent-arrow wishlist-btn">
                                                    YÊU THÍCH <i class="icon icon-ns-arrow-right"></i>
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>


        <!-- Product End -->

        <!<!-- Rate and Comment -->

        <div class="comment-section">
            <div id="comment-list">
                <h4 class="comment-title">Tổng cộng: ${totalFeedback} bình luận</h4>
                <ul id="comments-display" class="comment-list">
                    <c:forEach items="${listFeedback}" var="feedback">
                        <c:forEach items="${listAccountProfile}" var="profile">
                            <c:if test="${feedback.getAccount_ID() == profile.getAccount_ID()}">
                                <li class="comment-item">
                                    <span class="comment-author">${profile.getFullName()}</span>
                                    <span class="comment-text">${feedback.getComment()}</span>
                                    <span class="comment-star">${feedback.getRate()} ★</span>
                                </li>
                            </c:if>
                        </c:forEach>
                    </c:forEach>
                </ul>
            </div>

            <hr class="comment-divider">

            <form id="comment-form" action="AddRatingController" class="comment-form">
                <input type="hidden" name="pid" value="${detail.getProductID()}" />

                <label for="rating" class="form-label">Đánh giá:</label>
                <div class="star-rating">
                    <input type="radio" id="star5" name="rating" value="5" />
                    <label for="star5" title="5 sao">&#9733;</label>

                    <input type="radio" id="star4" name="rating" value="4" />
                    <label for="star4" title="4 sao">&#9733;</label>

                    <input type="radio" id="star3" name="rating" value="3" />
                    <label for="star3" title="3 sao">&#9733;</label>

                    <input type="radio" id="star2" name="rating" value="2" />
                    <label for="star2" title="2 sao">&#9733;</label>

                    <input type="radio" id="star1" name="rating" value="1" />
                    <label for="star1" title="1 sao">&#9733;</label>
                </div>

                <label for="comment" class="form-label">Bình luận: *</label>
                <textarea id="comment" name="comment" rows="4" class="form-control" placeholder="Nhập bình luận..." required></textarea>

                <div class="text-center">
                    <button type="submit" class="submit-button">GỬI BÌNH LUẬN <i class="fas fa-paper-plane"></i></button>
                </div>
            </form>
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
                /* Styles cho Toast Message Container */
                .toast-container {
                    position: fixed;
                    top: 20px;
                    right: 20px;
                    z-index: 9999;
                    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                }

                .toast {
                    padding: 15px 25px;
                    margin-bottom: 12px;
                    border-radius: 12px;
                    color: #5f375f;
                    background-color: #fce4ec; /* pastel pink background */
                    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
                    opacity: 0;
                    transform: translateX(100%);
                    transition: all 0.4s ease-in-out;
                    border-left: 6px solid #f48fb1; /* pastel rose accent */
                }

                .toast.show {
                    opacity: 1;
                    transform: translateX(0);
                }

                .toast.success {
                    background-color: #f8bbd0; /* light pastel pink */
                    border-left-color: #40ec46;
                }

                .toast.error {
                    background-color: #fce4ec;
                    border-left-color: #d81b60;
                }

                .bg-pink-pastel {
                    background-color: #fddde6;
                }

                .text-dark-purple {
                    color: #5c4b51;
                }
            </style>
            <style>
                .star-rating {
                    direction: rtl; /* đảo ngược thứ tự hiển thị */
                    unicode-bidi: bidi-override; /* fix hiển thị ngược */
                    font-size: 24px;
                    display: inline-flex;
                }
                .star-rating input[type="radio"] {
                    display: none;
                }
                .star-rating label {
                    color: #ccc;
                    cursor: pointer;
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

                function showToast(message, type) {
                    const container = document.querySelector('.toast-container');
                    const toast = document.createElement('div');
                    toast.className = `toast ${type}`;
                    toast.textContent = message;

                    container.appendChild(toast);

                    // Reflow để kích hoạt animation
                    toast.offsetHeight;

                    // Show toast
                    toast.classList.add('show');

                    // Tự động biến mất sau 3s
                    setTimeout(() => {
                        toast.classList.remove('show');
                        setTimeout(() => {
                            container.removeChild(toast);
                        }, 400);
                    }, 3000);
                }

                // Lấy message từ session JSP
                const message = '<%= session.getAttribute("message") != null ? session.getAttribute("message") : "" %>';
                const messageType = '<%= session.getAttribute("messageType") != null ? session.getAttribute("messageType") : "" %>';

                if (message && messageType) {
                    showToast(message, messageType);
                }
            </script>
    </body>
</html>

