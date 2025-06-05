<%--
    Document   : Cartmain
    Created on : May 26, 2025, 10:25:03 AM
    Author     : kimky

    Mục đích: Trang này hiển thị giỏ hàng của người dùng, cho phép họ xem các sản phẩm đã thêm,
    cập nhật số lượng, xóa sản phẩm và tiến hành thanh toán.
--%>

<%-- Import các lớp cần thiết --%>
<%@ page import="Model.Account" %>
<%-- Thiết lập kiểu nội dung và mã hóa trang --%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%-- Import JSTL Core Tag Library để sử dụng các thẻ điều khiển luồng (ví dụ: c:forEach, c:if) --%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%-- Import JSTL Formatting Tag Library để định dạng số và tiền tệ --%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>Giỏ Hàng - Flower Shop</title>
        <meta content="width=device-width, initial-scale=1.0" name="viewport">
        <meta content="Free HTML Templates" name="keywords">
        <meta content="Free HTML Templates" name="description">

        <%-- Favicon --%>
        <link href="img/favicon.ico" rel="icon">

        <%-- Google Web Fonts --%>
        <link rel="preconnect" href="https://fonts.gstatic.com">
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">    

        <%-- Font Awesome Icons --%>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">

        <%-- Thư viện bên thứ ba (Animate.css, Owl Carousel) --%>
        <link href="lib/animate/animate.min.css" rel="stylesheet">
        <link href="lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">

        <%-- Stylesheet tùy chỉnh của ứng dụng --%>
        <link href="css/style.css" rel="stylesheet">

        <%-- CSS nội tuyến để tùy chỉnh giao diện --%>
        <style>
            html {
                position: relative;
                min-height: 100%;
            }

            body {
                display: flex;
                flex-direction: column;
                min-height: 100vh; /* Đảm bảo body chiếm ít nhất 100% chiều cao của viewport */
                margin: 0 !important; /* Loại bỏ margin mặc định của body do trình duyệt hoặc Bootstrap */
                padding: 0 !important; /* Loại bỏ padding mặc định của body */
            }

            /* Wrapper cho nội dung chính, sẽ co giãn để đẩy footer xuống */
            .page-content-wrapper {
                flex: 1; /* Cho phép vùng này co giãn để lấp đầy không gian còn lại */
                display: flex; /* Dùng flex để các phần tử bên trong nó cũng có thể sắp xếp */
                flex-direction: column; /* Sắp xếp nội dung bên trong theo cột */
            }

            /* Đảm bảo các phần tử như Topbar, Navbar không bị co lại */
            .container-fluid.bg-secondary.py-1.px-xl-5, /* Topbar */
            .container-fluid.bg-pink.mb-30 /* Navbar */ {
                flex-shrink: 0;
            }

            /* Footer của bạn, đảm bảo không bị co lại và dính xuống cuối */
            .container-fluid.bg-pink.text-secondary.mt-5.pt-5 {
                flex-shrink: 0;
                margin-top: auto; /* Đẩy footer xuống dưới cùng khi dùng flex-direction: column trên body */
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

            /* Nút tăng giảm số lượng nữ tính */
            .quantity .btn-minus,
            .quantity .btn-plus {
                background-color: #fce4ec;
                border: 1px solid #f8bbd0;
                color: #ec407a;
                border-radius: 50%;
                width: 32px;
                height: 32px;
                display: flex;
                align-items: center;
                justify-content: center;
                transition: all 0.3s ease;
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            }

            .quantity .btn-minus:hover,
            .quantity .btn-plus:hover {
                background-color: #f8bbd0;
                transform: scale(1.05);
            }

            .quantity .btn-minus:active,
            .quantity .btn-plus:active {
                transform: scale(0.95);
            }

            .quantity-input {
                background-color: #fff9fc !important;
                border: 1px solid #f8bbd0 !important;
                color: #ec407a;
                font-weight: bold;
                border-radius: 15px !important;
                margin: 0 5px;
            }

            /* Tùy chọn thay đổi hình nền (khu vực này có vẻ không được sử dụng trong nội dung chính) */
            .background-selector {
                position: fixed;
                bottom: 20px;
                left: 20px;
                background-color: #fff;
                border-radius: 10px;
                padding: 15px;
                box-shadow: 0 4px 15px rgba(0,0,0,0.1);
                z-index: 1000;
                border: 1px solid #f8bbd0;
            }

            .background-selector h5 {
                color: #ec407a;
                margin-bottom: 10px;
                font-size: 16px;
            }

            .background-options {
                display: flex;
                gap: 10px;
            }

            .bg-option {
                width: 30px;
                height: 30px;
                border-radius: 50%;
                cursor: pointer;
                border: 2px solid transparent;
                transition: all 0.3s ease;
            }

            .bg-option:hover {
                transform: scale(1.1);
            }

            .bg-option.active {
                border-color: #ec407a;
            }

            /* Các tùy chọn màu nền */
            .bg-default {
                background-color: #ffffff;
            }

            .bg-pink-light {
                background-color: #fff9fc;
            }

            .bg-lavender {
                background-color: #f3e5f5;
            }

            .bg-mint {
                background-color: #e0f2f1;
            }

            .bg-pattern {
                background-image: url('img/bg-pattern.png');
                background-size: 100px;
            }
        </style>
    </head>

    <body>
        <%-- Topbar Start --%>
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
                        <%-- Logic hiển thị tên người dùng hoặc nút đăng nhập/đăng ký --%>
                        <% if(session.getAttribute("account") != null) { 
                                Account acc = (Account)session.getAttribute("account");
                        %>
                        <div class="btn-group">
                            <button type="button" class="btn btn-sm btn-light dropdown-toggle" data-toggle="dropdown">
                                <%= acc.getUsername() %>
                            </button>
                            <div class="dropdown-menu dropdown-menu-right">
                                <a href="VoucherController" class="dropdown-item">Voucher của tôi</a>
                                <button type="button" class="dropdown-item" data-toggle="modal" data-target="#logoutModal">Đăng xuất</button>
                            </div>
                        </div>
                        <% } else { %>
                        <a href="login.jsp" class="btn btn-sm btn-light mr-2">Đăng nhập</a>
                        <a href="register.jsp" class="btn btn-sm btn-light">Đăng ký</a>
                        <% } %>
                    </div>
                    <%-- Các biểu tượng giỏ hàng/yêu thích cho thiết bị di động (hiển thị khi màn hình nhỏ) --%>
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
            <%-- Header (Logo, Tìm kiếm, Thông tin liên hệ) --%>
            <div class="row align-items-center bg-light py-3 px-xl-5 d-none d-lg-flex">
                <div class="col-lg-4">
                    <a href="" class="text-decoration-none">
                        <span class="h1 text-uppercase text-light bg-pink px-2">Flower</span>
                        <span class="h1 text-uppercase text-pink bg-light px-2 ml-n1">Shop</span>
                    </a>
                </div>
                <div class="col-lg-4 col-6 text-left">
                    <form action="">
                        <div class="input-group">
                            <input type="text" class="form-control" placeholder="Search for products">
                            <div class="input-group-append">
                                <span class="input-group-text bg-transparent text-primary">
                                    <i class="fa fa-search"></i>
                                </span>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="col-lg-4 col-6 text-right">
                    <p class="m-0">Customer Service</p>
                    <h5 class="m-0">+012 345 6789</h5>
                </div>
            </div>
        </div>
        <%-- Topbar End --%>

        <%-- Navbar Start --%>
        <div class="container-fluid bg-pink mb-30">
            <div class="row px-xl-5">
                <div class="col-lg-12">
                    <nav class="navbar navbar-expand-lg bg-pink navbar-dark py-3 py-lg-0 px-0 w-100">
                        <%-- Logo cho thiết bị di động --%>
                        <a href="#" class="text-decoration-none d-block d-lg-none">
                            <span class="h1 text-uppercase text-light bg-pink px-2">Shop</span>
                            <span class="h1 text-uppercase text-pink bg-light px-2 ml-n1">Hoa</span>
                        </a>
                        <%-- Nút bật/tắt Navbar cho thiết bị di động --%>
                        <button type="button" class="navbar-toggler" data-toggle="collapse" data-target="#navbarCollapse">
                            <span class="navbar-toggler-icon"></span>
                        </button>
                        <%-- Các mục điều hướng chính --%>
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
                        <%-- Biểu tượng giỏ hàng/yêu thích trên Navbar cho màn hình lớn --%>
                        <div class="d-none d-lg-flex align-items-center ml-auto">
                            <a href="#" class="btn px-0">
                                <i class="fas fa-heart text-primary"></i>
                                <span class="badge text-secondary border border-secondary rounded-circle" style="padding-bottom: 2px;">0</span>
                            </a>
                            <a href="Cart.jsp" class="btn px-0 ml-3">
                                <i class="fas fa-shopping-cart text-primary"></i>
                                <span class="badge text-secondary border border-secondary rounded-circle" style="padding-bottom: 2px;">
                                    <%-- Hiển thị số lượng sản phẩm trong giỏ hàng. Ưu tiên sessionScope.cartItemCount,
                                        nếu không có thì lấy từ sessionScope.cart.getTotalItems(), mặc định là 0. --%>
                                    ${sessionScope.cartItemCount != null ? sessionScope.cartItemCount : (sessionScope.cart != null ? sessionScope.cart.getTotalItems() : 0)}
                                </span>
                            </a>
                            <a href="order?action=view" class="btn px-0 ml-3">
                                <i class="fas fa-clipboard-list text-primary"></i>
                                <span class="badge text-secondary border border-secondary rounded-circle" style="padding-bottom: 2px;">
                                    <%-- Hiển thị số lượng đơn hàng, mặc định là 0. --%>
                                    ${sessionScope.orderCount != null ? sessionScope.orderCount : 0}
                                </span>
                            </a>
                        </div>
                    </nav>
                </div>
            </div>
        </div>
        <%-- Navbar End --%>

        <%-- Page Content Wrapper - Đảm bảo footer luôn ở cuối trang --%>
        <div class="page-content-wrapper">
            <%-- Cart Table Start --%>
            <div class="container-fluid">
                <div class="row px-xl-5">
                    <div class="col-lg-8 table-responsive mb-5">
                        <table class="table table-light table-borderless table-hover text-center mb-0">
                            <%-- Tiêu đề bảng giỏ hàng --%>
                            <thead class="bg-pink-pastel text-dark-purple">
                                <tr>
                                    <th>Sản phẩm</th>
                                    <th>Giá</th>
                                    <th>Số lượng</th>
                                    <th>Tổng</th>
                                    <th>Xóa</th>
                                </tr>
                            </thead>
                            <%-- Nội dung bảng giỏ hàng --%>
                            <tbody class="align-middle">
                                <%-- Kiểm tra nếu giỏ hàng rỗng --%>
                                <c:choose>
                                    <c:when test="${empty sessionScope.cart or empty sessionScope.cart.items}">
                                        <tr>
                                            <td colspan="5" class="text-center py-5">
                                                <h5>Giỏ hàng của bạn đang trống</h5>
                                                <a href="ViewListProductController" class="btn btn-primary mt-3">Tiếp tục mua sắm</a>
                                            </td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <%-- Lặp qua từng sản phẩm trong giỏ hàng --%>
                                        <c:forEach var="item" items="${sessionScope.cart.items}">
                                            <tr>
                                                <td class="align-middle">
                                                    <img src="${item.product.image}" alt="${item.product.title}" style="width: 50px;">
                                                    ${item.product.title}
                                                </td>
                                                <td class="align-middle">
                                                    <%-- Định dạng giá sản phẩm --%>
                                                    <fmt:formatNumber value="${item.product.price}" type="currency" currencySymbol="" pattern="#,##0"/>đ
                                                </td>
                                                <td class="align-middle">
                                                    <div class="input-group quantity mx-auto" style="width: 150px;">
                                                        <div class="input-group-btn">
                                                            <%-- Nút giảm số lượng. Gọi hàm JavaScript updateQuantity khi click. --%>
                                                            <button class="btn btn-sm btn-minus" onclick="updateQuantity(${item.product.productID}, ${item.quantity - 1})">
                                                                <i class="fa fa-minus"></i>
                                                            </button>
                                                        </div>
                                                        <%-- Input hiển thị và cho phép chỉnh sửa số lượng.
                                                            Gọi hàm JavaScript updateQuantity khi giá trị thay đổi.
                                                            Đặt min và max dựa trên số lượng hiện có và số lượng tồn kho. --%>
                                                        <input type="text" class="form-control form-control-sm border-0 text-center quantity-input" 
                                                               value="${item.quantity}" 
                                                               onchange="updateQuantity(${item.product.productID}, this.value)"
                                                               min="1" max="${item.product.quantity}">
                                                        <div class="input-group-btn">
                                                            <%-- Nút tăng số lượng. Gọi hàm JavaScript updateQuantity khi click. --%>
                                                            <button class="btn btn-sm btn-plus" onclick="updateQuantity(${item.product.productID}, ${item.quantity + 1})">
                                                                <i class="fa fa-plus"></i>
                                                            </button>
                                                        </div>
                                                    </div>
                                                    <%-- Hiển thị số lượng sản phẩm còn lại trong kho --%>
                                                    <small class="text-muted">Còn lại: ${item.product.quantity}</small>
                                                </td>
                                                <td class="align-middle">
                                                    <%-- Định dạng tổng tiền cho sản phẩm --%>
                                                    <fmt:formatNumber value="${item.total}" type="currency" currencySymbol="" pattern="#,##0"/>đ
                                                </td>
                                                <td class="align-middle">
                                                    <%-- Nút xóa sản phẩm khỏi giỏ hàng. Gọi hàm JavaScript removeFromCart khi click. --%>
                                                    <button class="btn btn-sm btn-danger" onclick="removeFromCart(${item.product.productID})">
                                                        <i class="fa fa-times"></i>
                                                    </button>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                    <%-- Cart Summary Start --%>
                    <div class="col-lg-4">
                        <h5 class="section-title position-relative text-uppercase mb-3"><span class="bg-secondary pr-3">Tổng giỏ hàng</span></h5>
                        <div class="bg-light p-30 mb-5">
                            <%-- Đặt phí vận chuyển cố định --%>
                            <c:set var="shippingFee" value="30000"/>

                            <div class="border-bottom pb-2">
                                <div class="d-flex justify-content-between mb-3">
                                    <h6>Tổng tiền hàng</h6>
                                    <h6>
                                        <%-- Định dạng tổng tiền hàng từ giỏ hàng. Mặc định là 0 nếu giỏ hàng rỗng. --%>
                                        <fmt:formatNumber value="${sessionScope.cart.total != null ? sessionScope.cart.total : 0}" type="currency" currencySymbol="" pattern="#,##0"/>đ
                                    </h6>
                                </div>
                                <div class="d-flex justify-content-between">
                                    <h6 class="font-weight-medium">Phí vận chuyển</h6>
                                    <h6 class="font-weight-medium">
                                        <%-- Định dạng phí vận chuyển --%>
                                        <fmt:formatNumber value="${shippingFee}" type="currency" currencySymbol="" pattern="#,##0"/>đ
                                    </h6>
                                </div>
                            </div>
                            <div class="pt-2">
                                <div class="d-flex justify-content-between mt-2">
                                    <h5>Tổng thanh toán</h5>
                                    <h5>
                                        <%-- Định dạng tổng thanh toán (tổng tiền hàng + phí vận chuyển) --%>
                                        <fmt:formatNumber value="${sessionScope.cart.total + shippingFee}" type="currency" currencySymbol="" pattern="#,##0"/>đ
                                    </h5>
                                </div>
                                <%-- Nút tiến hành thanh toán. Bị vô hiệu hóa nếu giỏ hàng rỗng. --%>
                                <c:choose>
                                    <c:when test="${empty sessionScope.cart or empty sessionScope.cart.items}">
                                        <button class="btn btn-block btn-secondary font-weight-bold my-3 py-3" disabled>Giỏ hàng trống</button>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="checkout" class="btn btn-block btn-primary font-weight-bold my-3 py-3">Tiến hành thanh toán</a>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                    <%-- Cart Summary End --%>
                </div>
            </div>
            <%-- Toast Message Container --%>
            <div class="toast-container"></div>
        </div>
        <%-- Page Content Wrapper End --%>

        <%-- Footer Start --%>
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
            <%-- Bản quyền và Phương thức thanh toán --%>
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
        <%-- Footer End --%>

        <%-- Back to Top Button --%>
        <a href="#" class="btn btn-primary back-to-top"><i class="fa fa-angle-double-up"></i></a>

        <%-- JavaScript Libraries --%>
        <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.bundle.min.js"></script>
        <script src="lib/easing/easing.min.js"></script>
        <script src="lib/owlcarousel/owl.carousel.min.js"></script>

        <%-- Custom Javascript --%>
        <script src="js/main.js"></script>

        <%-- JavaScript tùy chỉnh cho trang giỏ hàng --%>
        <script>
            /**
             * Hàm cập nhật số lượng sản phẩm trong giỏ hàng thông qua AJAX.
             * @param {number} productId ID của sản phẩm cần cập nhật.
             * @param {number} newQuantity Số lượng mới của sản phẩm.
             */
            function updateQuantity(productId, newQuantity) {
                // Đảm bảo số lượng không nhỏ hơn 1
                if (newQuantity < 1) {
                    return;
                }
                
                // Lấy số lượng tồn kho tối đa từ thuộc tính 'max' của input số lượng
                const maxQuantityElement = document.querySelector(`input[onchange*="updateQuantity(${productId}"]`);
                if (!maxQuantityElement) {
                    console.error("Không tìm thấy phần tử input cho sản phẩm ID:", productId);
                    return;
                }
                const maxQuantity = parseInt(maxQuantityElement.getAttribute('max'));

                // Kiểm tra nếu số lượng mới vượt quá số lượng tồn kho
                if (newQuantity > maxQuantity) {
                    alert(`Số lượng không thể vượt quá số lượng tồn kho: ${maxQuantity}`);
                    // Cập nhật lại giá trị hiển thị trong input về số lượng tồn kho tối đa
                    maxQuantityElement.value = maxQuantity; 
                    // Tải lại trang để phản ánh trạng thái giỏ hàng chính xác
                    location.reload(); 
                    return;
                }

                $.ajax({
                    url: 'cart', // URL của Servlet xử lý giỏ hàng
                    type: 'POST', // Phương thức HTTP
                    data: {
                        action: 'update', // Hành động: cập nhật số lượng
                        productId: productId,
                        quantity: newQuantity
                    },
                    success: function (response) {
                        // Nếu cập nhật thành công, tải lại trang để hiển thị giỏ hàng mới nhất
                        if (response.success) {
                            location.reload();
                        } else {
                            // Nếu có lỗi, tải lại trang để hiển thị trạng thái hiện tại (hoặc hiển thị toast message nếu có)
                            setTimeout(function () {
                                location.reload();
                            }, 500); // Thêm một độ trễ nhỏ trước khi reload
                        }
                    },
                    error: function (xhr, status, error) {
                        // Xử lý lỗi AJAX (ví dụ: hiển thị thông báo lỗi)
                        console.error("Lỗi khi cập nhật số lượng:", error);
                        // showToastMessage('Đã xảy ra lỗi khi cập nhật số lượng.', 'error'); // Giả định có hàm showToastMessage
                        location.reload(); // Tải lại trang trong trường hợp lỗi để đồng bộ dữ liệu
                    }
                });
            }

            /**
             * Hàm xóa sản phẩm khỏi giỏ hàng thông qua AJAX.
             * @param {number} productId ID của sản phẩm cần xóa.
             */
            function removeFromCart(productId) {
                if (confirm('Bạn có chắc chắn muốn xóa sản phẩm này khỏi giỏ hàng?')) {
                    $.ajax({
                        url: 'cart', // URL của Servlet xử lý giỏ hàng
                        type: 'POST', // Phương thức HTTP
                        data: {
                            action: 'remove', // Hành động: xóa sản phẩm
                            productId: productId
                        },
                        success: function (response) {
                            // Nếu xóa thành công, tải lại trang
                            if (response.success) {
                                location.reload();
                            } else {
                                // Xử lý lỗi nếu có
                                alert('Không thể xóa sản phẩm khỏi giỏ hàng: ' + response.message);
                                // showToastMessage('Không thể xóa sản phẩm khỏi giỏ hàng.', 'error'); // Giả định có hàm showToastMessage
                                location.reload();
                            }
                        },
                        error: function (xhr, status, error) {
                            // Xử lý lỗi AJAX
                            console.error("Lỗi khi xóa sản phẩm:", error);
                            // showToastMessage('Đã xảy ra lỗi khi xóa sản phẩm.', 'error'); // Giả định có hàm showToastMessage
                            location.reload(); // Tải lại trang trong trường hợp lỗi
                        }
                    });
                }
            }

            /**
             * Hàm hiển thị thông báo Toast.
             * Cần có các phần tử HTML .toast-container và .toast đã định nghĩa trong CSS.
             * @param {string} message Nội dung thông báo.
             * @param {string} type Kiểu thông báo ('success', 'error', hoặc mặc định).
             */
            function showToastMessage(message, type = '') {
                const toastContainer = document.querySelector('.toast-container');
                const toast = document.createElement('div');
                toast.classList.add('toast');
                if (type) {
                    toast.classList.add(type);
                }
                toast.textContent = message;
                toastContainer.appendChild(toast);

                // Hiển thị toast
                setTimeout(() => {
                    toast.classList.add('show');
                }, 100);

                // Tự động ẩn toast sau 3 giây
                setTimeout(() => {
                    toast.classList.remove('show');
                    toast.addEventListener('transitionend', () => {
                        toast.remove();
                    });
                }, 3000);
            }

            // Xử lý modal đăng xuất (nếu có)
            $(document).ready(function() {
                $('#logoutModal').on('show.bs.modal', function (event) {
                    // Có thể thêm logic ở đây nếu cần trước khi modal hiện ra
                });
            });
        </script>
    </body>
</html>