<%-- 
    Document   : WhishList
    Created on : June 5, 2025, 12:02:19 AM
    Author     : Admin
--%>
<%@ page import="Model.Account" %>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>Flower Shop - WishList</title>
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
            .product-item {
                transition: transform 0.3s ease;
            }

            .product-item:hover {
                transform: translateY(-5px);
            }

            .product-img img {
                object-fit: contain;
            }
        </style>
        <style>
            /* Giao diện bảng */
            table {
                border-collapse: collapse;
                width: 100%;
                background-color: #fff;
                box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            }

            table thead {
                background-color: #f8f9fa;
            }

            table th, table td {
                border: 1px solid #dee2e6;
                padding: 12px;
                vertical-align: middle;
                text-align: center;
            }

            /* Tiêu đề bảng */
            h2.text-center {
                font-size: 28px;
                font-weight: bold;
                color: #343a40;
            }

            /* Ảnh sản phẩm */
            table img {
                width: 60px;
                height: auto;
                border-radius: 6px;
            }

            /* Nút Remove */
            .wishlist-btn {
                background-color: #dc3545;
                color: white;
                border: none;
                padding: 6px 12px;
                border-radius: 4px;
                cursor: pointer;
                font-size: 14px;
                transition: background-color 0.3s ease;
            }

            .wishlist-btn:hover {
                background-color: #c82333;
            }

            /* Link sản phẩm */
            table a {
                color: #007bff;
                text-decoration: none;
            }

            table a:hover {
                text-decoration: underline;
            }

            /* Responsive nhẹ */
            @media (max-width: 768px) {
                table th, table td {
                    font-size: 14px;
                    padding: 8px;
                }

                h2.text-center {
                    font-size: 22px;
                }

                .wishlist-btn {
                    padding: 5px 10px;
                    font-size: 13px;
                }
            }
        </style>
        <style>
            .modal-overlay {
                display: none;
                position: fixed;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background-color: rgba(0,0,0,0.5);
                z-index: 9999;
                justify-content: center;
                align-items: center;
            }

            .modal-box {
                background-color: white;
                padding: 24px;
                border-radius: 8px;
                max-width: 400px;
                width: 90%;
                box-shadow: 0 4px 12px rgba(0,0,0,0.2);
                text-align: center;
            }

            .modal-buttons {
                margin-top: 20px;
                display: flex;
                justify-content: space-around;
            }

            .btn {
                padding: 8px 16px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
            }

            .btn-danger {
                background-color: #dc3545;
                color: white;
            }

            .btn-secondary {
                background-color: #6c757d;
                color: white;
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
                        <span class="h1 text-uppercase text-light bg-pink px-2">Bán</span>
                        <span class="h1 text-uppercase text-pink bg-light px-2 ml-n1">Hoa</span>
                    </a>
                </div>
                <div class="col-lg-4 col-6 text-left">
                    <form action="SearchProductByTitle">
                        <div class="input-group">
                            <input type="text" name="txt" class="form-control" placeholder="Tìm kiếm sản phẩm" value="${txt}">
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
                                <a href="Homepage" class="nav-item nav-link">Trang chủ</a>
                                <a href="ViewListProductController" class="nav-item nav-link">Sản phẩm</a>
                                
                                <a href="VoucherController" class="nav-item nav-link">Mã giảm giá</a>
                                <a href="blogs" class="nav-item nav-link">Bài viết</a>
                                <div class="nav-item dropdown">
                                    <a href="#" class="nav-link dropdown-toggle" data-toggle="dropdown">Trang <i class="fa fa-angle-down mt-1"></i></a>
                                    <div class="dropdown-menu bg-primary rounded-0 border-0 m-0">
                                        <a href="Cart.jsp" class="dropdown-item">Giỏ hàng</a>
                                        <a href="CheckOut.jsp" class="dropdown-item">Thanh toán</a>
                                    </div>
                                </div>
                                <a href="contact.jsp" class="nav-item nav-link">Contact</a>
                            </div>
                        </div>

                        <div class="d-none d-lg-flex align-items-center ml-auto">
                            <a href="#" class="btn px-0">
                                <i class="fas fa-heart text-primary"></i>
                                <span class="badge text-secondary border border-secondary rounded-circle" style="padding-bottom: 2px;">${countWL}</span>
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

        <!-- Wishlist Section -->
        <div class="container mt-5 mb-5">
            <h2 class="text-center mb-4">Sản Phẩm Yêu Thích</h2>
            <div class="row">
                <table style="width: 100%; text-align: center;">
                    <thead>
                        <tr>
                            <th>Ảnh</th>
                            <th>Tên sản phẩm</th>
                            <th>Còn</th>
                            <th>Giá</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${listWL}" var="listWL">
                            <tr>
                                <td>
                                    <img src="${listWL.getImage()}" 
                                         style="width: 50px; height: auto;" />
                                </td>
                                <td><a href=ViewProductDetail?productid=${listWL.getProductID()}>${listWL.getTitle()}</a></td>
                                <td>${listWL.getQuantity()}</td>
                                <fmt:setLocale value="vi_VN" />
                                <fmt:setBundle basename="path.to.your.resource.bundle" />
                                <td><fmt:formatNumber value="${listWL.getPrice()}" /> VNĐ</td>

                                <td>
                                    <c:set var="isInWishlist" value="false" />
                                    <c:forEach items="${listWLByAcc}" var="listWLByAcc">
                                        <c:if test="${listWL.getProductID() == listWLByAcc.getProductID()}">
                                            <c:set var="isInWishlist" value="true" />
                                            <form action="ManageWishListController" method="post">
                                                <input type="hidden" name="wlid" value="${listWLByAcc.getWishListID()}">
                                                <button type="button" class="wishlist-btn" onclick="openDeleteModal('${listWLByAcc.getWishListID()}')">Xóa</button>

                                            </form>
                                        </c:if>
                                    </c:forEach>
                                    <div id="deleteModal" class="modal-overlay">
                                        <div class="modal-box">
                                            <h4>Bạn có chắc chắn muốn xóa sản phẩm này khỏi danh sách yêu thích?</h4>
                                            <form id="deleteForm" action="ManageWishListController" method="post">
                                                <input type="hidden" name="wlid" id="deleteWlid">
                                                <div class="modal-buttons">
                                                    <button type="submit" class="btn btn-danger">Xóa</button>
                                                    <button type="button" class="btn btn-secondary" onclick="closeModal()">Hủy</button>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </td>


                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

        <-<!-- Footer start -->

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
        </div>

    </body>
    <script>
        window.onload = function () {
            var messageBox = document.getElementById("message-box");
            if (messageBox.innerHTML.trim() !== "") { // Only show if there's a message
                messageBox.style.display = "block";
                setTimeout(function () {
                    messageBox.style.display = "none"; // Hide after 3 seconds
                }, 3000);
            }
        };
    </script>
    <script>
        function openDeleteModal(wlid) {
            document.getElementById("deleteWlid").value = wlid;
            document.getElementById("deleteModal").style.display = "flex";
        }

        function closeModal() {
            document.getElementById("deleteModal").style.display = "none";
        }
    </script>

</html>
