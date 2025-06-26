<%--
    Document   : Cartmain
    Created on : May 26, 2025, 10:25:03 AM
    Author     : kimky
--%>
<%@ page import="Model.Account" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<jsp:include page="subiz-chat.jsp" />
<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="utf-8">
        <title>Giỏ Hàng - Flower Shop</title>
        <meta content="width=device-width, initial-scale=1.0" name="viewport">
        <meta content="Free HTML Templates" name="keywords">
        <meta content="Free HTML Templates" name="description">

        <link href="img/favicon.ico" rel="icon">

        <link rel="preconnect" href="https://fonts.gstatic.com">
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">  

        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">

        <link href="lib/animate/animate.min.css" rel="stylesheet">
        <link href="lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">

        <link href="css/style.css" rel="stylesheet">

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

            /* Styles for Toast Message Container */
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

            html {
                position: relative;
                min-height: 100%;
            }

            body {
                background-color: #fff;
                font-family: 'Montserrat', sans-serif;
                color: #555;
                background-image: url('img/Pink Watercolor Abstract Linktree Background.png');
                background-size: cover;
                background-attachment: fixed;
                background-position: center;
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

            /* Styles for Toast Message Container */
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

            /* Tùy chọn thay đổi hình nền */
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

            /* Styles for Toast Message Container */
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

            /* Tùy chọn thay đổi hình nền */
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
                                <a href="profile" class="dropdown-item">Thông tin cá nhân</a>
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
                    <a href="" class="text-decoration-none">
                        <span class="h1 text-uppercase text-light bg-pink px-2">Bán</span>
                        <span class="h1 text-uppercase text-pink bg-light px-2 ml-n1">Hoa</span>
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



                                <a href="Homepage" class="nav-item nav-link">Trang chủ</a>
                                <a href="ViewListProductController" class="nav-item nav-link ">Sản phẩm</a>
                                <a href="detail.html" class="nav-item nav-link">Shop Detail</a>
                                <a href="VoucherController" class="nav-item nav-link">Mã giảm giá</a>
                                <a href="blogs" class="nav-item nav-link">Bài viết</a>

                                <div class="nav-item dropdown">
                                    <a href="#" class="nav-link dropdown-toggle" data-toggle="dropdown">Trang<i class="fa fa-angle-down mt-1"></i></a>
                                    <div class="dropdown-menu bg-primary rounded-0 border-0 m-0">

                                        <a href="Cart.jsp" class="dropdown-item">Giỏ hàng</a>
                                        <a href="CheckOut.jsp" class="dropdown-item">Thanh toán</a>

                                    </div>
                                </div>
                                <a href="contact.jsp" class="nav-item nav-link">Liên hệ</a>
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
        <div class="page-content-wrapper">
            <div class="container-fluid">
                <div class="row px-xl-5">
                    <div class="col-lg-8 table-responsive mb-5">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h2 class="font-weight-semi-bold mb-0">Giỏ hàng của tôi</h2>
                            <button class="btn btn-sm btn-outline-primary" onclick="refreshCart()">
                                <i class="fas fa-sync-alt"></i> Cập nhật giỏ hàng
                            </button>
                        </div>
                        <table class="table table-light table-borderless table-hover text-center mb-0">

                            <thead class="bg-pink-pastel text-dark-purple">

                                <tr>
                                    <th>Sản phẩm</th>
                                    <th>Giá</th>
                                    <th>Số lượng</th>
                                    <th>Tổng</th>
                                    <th>Xóa</th>
                                </tr>
                            </thead>

                            <tbody class="align-middle">
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
                                        <c:forEach var="item" items="${sessionScope.cart.items}">
                                            <tr>
                                                <td class="align-middle">
                                                    <img src="${item.product.image}" alt="${item.product.title}" style="width: 50px;">
                                                    ${item.product.title}
                                                </td>
                                                <td class="align-middle">
                                                    <fmt:formatNumber value="${item.product.price}" type="currency" currencySymbol="" pattern="#,##0"/>đ
                                                </td>
                                                <td class="align-middle">
                                                    <div class="input-group quantity mx-auto" style="width: 150px;">
                                                        <div class="input-group-btn">
                                                            <button class="btn btn-sm btn-minus" onclick="updateQuantity(${item.product.productID}, ${item.quantity - 1})">
                                                                <i class="fa fa-minus"></i>
                                                            </button>
                                                        </div>
                                                        <input type="text" class="form-control form-control-sm border-0 text-center quantity-input" 
                                                               value="${item.quantity}" 
                                                               onchange="updateQuantity(${item.product.productID}, this.value)"
                                                               min="1" max="${item.product.quantity}">
                                                        <div class="input-group-btn">
                                                            <button class="btn btn-sm btn-plus" onclick="updateQuantity(${item.product.productID}, ${item.quantity + 1})">
                                                                <i class="fa fa-plus"></i>
                                                            </button>
                                                        </div>
                                                    </div>
                                                    <c:choose>
                                                        <c:when test="${item.product.quantity == 0}">
                                                            <small class="text-danger font-weight-bold">Hết Hàng</small>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <small class="text-success font-weight-bold">Còn lại: ${item.product.quantity}</small>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="align-middle">
                                                    <fmt:formatNumber value="${item.total}" type="currency" currencySymbol="" pattern="#,##0"/>đ
                                                </td>
                                                <td class="align-middle">
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
                    <div class="col-lg-4">
                        <h5 class="section-title position-relative text-uppercase mb-3"><span class="bg-secondary pr-3">Tổng giỏ hàng</span></h5>
                        <div class="bg-light p-30 mb-5">

                            <c:set var="shippingFee" value="30000"/>

                            <div class="border-bottom pb-2">
                                <div class="d-flex justify-content-between mb-3">
                                    <h6>Tổng tiền hàng</h6>
                                    <h6>
                                        <fmt:formatNumber value="${sessionScope.cart.total != null ? sessionScope.cart.total : 0}" type="currency" currencySymbol="" pattern="#,##0"/>đ
                                    </h6>
                                </div>
                                <div class="d-flex justify-content-between">
                                    <h6 class="font-weight-medium">Phí vận chuyển</h6>
                                    <h6 class="font-weight-medium">
                                        <fmt:formatNumber value="${shippingFee}" type="currency" currencySymbol="" pattern="#,##0"/>đ
                                    </h6>
                                </div>
                            </div>
                            <div class="pt-2">
                                <div class="d-flex justify-content-between mt-2">
                                    <h5>Tổng thanh toán</h5>
                                    <h5>
                                        <fmt:formatNumber value="${sessionScope.cart.total + shippingFee}" type="currency" currencySymbol="" pattern="#,##0"/>đ
                                    </h5>
                                </div>
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
                </div>
            </div>
            <div class="toast-container"></div>
        </div>
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

        <script>
                                                        function refreshCart() {
                                                            // Gửi request đến server để cập nhật giỏ hàng
                                                            window.location.href = 'cart?action=view&t=' + new Date().getTime();
                                                        }

// Hàm cập nhật số lượng sản phẩm trong giỏ hàng
                                                        function updateQuantity(productId, newQuantity) {
                                                            // Nếu số lượng mới nhỏ hơn 1, reload trang sau 1 giây và kết thúc hàm
                                                            if (newQuantity < 1) {
                                                                setTimeout(function () {
                                                                    location.reload();
                                                                }, 1000);
                                                                return;
                                                            }

                                                            // Lấy số lượng tồn kho tối đa từ input tương ứng với sản phẩm
                                                            const maxQuantity = parseInt(document.querySelector(`input[onchange*="updateQuantity(${productId}"]`).getAttribute('max'));

                                                            // Nếu số lượng vượt quá tồn kho, reload trang sau 1 giây và kết thúc hàm
                                                            if (newQuantity > maxQuantity) {
                                                                setTimeout(function () {
                                                                    location.reload();
                                                                }, 1000);
                                                                return;
                                                            }

                                                            // Gửi AJAX request để cập nhật số lượng sản phẩm trong giỏ hàng
                                                            $.ajax({
                                                                url: 'cart',
                                                                type: 'POST',
                                                                data: {
                                                                    action: 'update', // hành động là "update"
                                                                    productId: productId, // ID sản phẩm cần cập nhật
                                                                    quantity: newQuantity      // số lượng mới
                                                                },
                                                                success: function (response) {
                                                                    // Nếu server trả về thành công, reload lại trang
                                                                    if (response.success) {
                                                                        location.reload();
                                                                    } else {
                                                                        // Nếu có lỗi, hiển thị thông báo và reload trang ngay lập tức
                                                                        showToast(response.message, 'error');
                                                                        setTimeout(function () {
                                                                            location.reload();
                                                                        }, 0);
                                                                    }
                                                                },
                                                                error: function () {
                                                                    // Nếu lỗi khi gửi request, hiển thị thông báo và reload trang ngay
                                                                    showToast("Đã xảy ra lỗi khi cập nhật giỏ hàng!", 'error');
                                                                    setTimeout(function () {
                                                                        location.reload();
                                                                    }, 0);
                                                                }
                                                            });
                                                        }

// Hàm xóa một sản phẩm khỏi giỏ hàng
                                                        function removeFromCart(productId) {
                                                            // Hiển thị hộp thoại xác nhận trước khi xóa
                                                            if (confirm('Bạn có chắc chắn muốn xóa sản phẩm này khỏi giỏ hàng?')) {
                                                                // Gửi AJAX request để xóa sản phẩm
                                                                $.ajax({
                                                                    url: 'cart',
                                                                    type: 'POST',
                                                                    data: {
                                                                        action: 'remove', // hành động là "remove"
                                                                        productId: productId     // ID sản phẩm cần xóa
                                                                    },
                                                                    success: function (response) {
                                                                        // Nếu xóa thành công, reload lại trang
                                                                        if (response.success) {
                                                                            location.reload();
                                                                        } else {
                                                                            // Nếu có lỗi, hiển thị thông báo lỗi
                                                                            showToast(response.message, 'error');
                                                                        }
                                                                    },
                                                                    error: function () {
                                                                        // Nếu lỗi khi gửi request, hiển thị thông báo lỗi
                                                                        showToast('Có lỗi xảy ra khi xóa sản phẩm', 'error');
                                                                    }
                                                                });
                                                            }
                                                        }

// Hàm xóa toàn bộ sản phẩm trong giỏ hàng
                                                        function clearCart() {
                                                            // Hiển thị hộp thoại xác nhận trước khi xóa tất cả
                                                            if (confirm('Bạn có chắc chắn muốn xóa toàn bộ giỏ hàng?')) {
                                                                // Gửi AJAX request để xóa toàn bộ giỏ hàng
                                                                $.ajax({
                                                                    url: 'cart',
                                                                    type: 'POST',
                                                                    data: {
                                                                        action: 'clear' // hành động là "clear"
                                                                    },
                                                                    success: function (response) {
                                                                        // Reload lại trang sau khi xóa thành công
                                                                        location.reload();
                                                                    },
                                                                    error: function () {
                                                                        // Nếu có lỗi, hiển thị thông báo lỗi
                                                                        showToast('Có lỗi xảy ra khi xóa giỏ hàng', 'error');
                                                                    }
                                                                });
                                                            }
                                                        }
        </script>

        <script>
// Hàm hiển thị thông báo dạng toast
            function showToast(message, type) {
                // Lấy phần tử container để chứa toast (ví dụ: <div class="toast-container"></div>)
                const container = document.querySelector('.toast-container');

                // Tạo một div mới để hiển thị thông báo
                const toast = document.createElement('div');
                toast.className = `toast ${type}`;  // Gán class tùy theo kiểu (success, error, info,...)
                toast.textContent = message;        // Gán nội dung thông báo

                // Thêm toast vào container
                container.appendChild(toast);

                // Kích hoạt reflow để đảm bảo transition được áp dụng
                toast.offsetHeight;

                // Thêm class 'show' để hiển thị toast với hiệu ứng CSS
                toast.classList.add('show');

                // Tự động ẩn toast sau 3 giây
                setTimeout(() => {
                    toast.classList.remove('show'); // Bắt đầu ẩn toast
                    setTimeout(() => {
                        container.removeChild(toast); // Xóa khỏi DOM sau khi ẩn hoàn tất
                    }, 400); // Đợi 400ms cho hiệu ứng ẩn hoàn tất
                }, 3000); // Thời gian hiển thị 3 giây
            }

// Kiểm tra xem có thông báo từ session gửi xuống không
            const message = '${sessionScope.message}';
            const messageType = '${sessionScope.messageType}';

            if (message && messageType) {
                // Nếu có, hiển thị thông báo toast
                showToast(message, messageType);

                // Xóa thông báo khỏi session sau khi hiển thị để không hiện lại sau khi reload
            <% 
    session.removeAttribute("message");
    session.removeAttribute("messageType");
            %>
            }

        </script>

        <div class="modal fade" id="logoutModal" tabindex="-1" role="dialog" aria-labelledby="logoutModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="logoutModalLabel">Xác nhận đăng xuất</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        Bạn có chắc chắn muốn đăng xuất không?
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Hủy</button>
                        <a href="LogoutController" class="btn btn-primary">Đăng xuất</a>
                    </div>
                </div>
            </div>
        </div>
    </body>

</html>
</body>
<script>
// Thêm xử lý cho các nút tăng/giảm số lượng sau khi trang được tải xong
    document.addEventListener('DOMContentLoaded', function () {
        // Lấy tất cả các nút "tăng số lượng"
        const plusButtons = document.querySelectorAll('.btn-plus');

        plusButtons.forEach(button => {
            button.addEventListener('click', function (e) {
                // Lấy input chứa số lượng (nằm trước nút hiện tại trong HTML)
                const input = this.parentElement.previousElementSibling;
                const currentValue = parseInt(input.value);           // Giá trị hiện tại
                const maxValue = parseInt(input.getAttribute('max')); // Số lượng tối đa trong kho

                // Nếu người dùng muốn vượt quá số lượng tồn kho
                if (currentValue >= maxValue) {
                    e.preventDefault();      // Ngăn hành vi mặc định của button
                    e.stopPropagation();     // Ngăn sự kiện lan ra phần tử cha
                    showToast('Số lượng yêu cầu vượt quá số lượng có sẵn trong kho', 'error');
                    return false;            // Dừng tiếp tục thực hiện
                }

                // Nếu hợp lệ, gọi hàm cập nhật số lượng (tăng thêm 1)
                updateQuantity(input.getAttribute('data-product-id'), currentValue + 1);

                // Ngăn sự kiện mặc định để tránh việc sự kiện bị gọi nhiều lần
                e.preventDefault();
                e.stopPropagation();
            });
        });

        // Tương tự: xử lý cho các nút "giảm số lượng"
        const minusButtons = document.querySelectorAll('.btn-minus');

        minusButtons.forEach(button => {
            button.addEventListener('click', function (e) {
                // Lấy input chứa số lượng (nằm sau nút hiện tại trong HTML)
                const input = this.parentElement.nextElementSibling;
                const currentValue = parseInt(input.value); // Giá trị hiện tại

                // Nếu số lượng nhỏ hơn hoặc bằng 1 thì không được giảm nữa
                if (currentValue <= 1) {
                    e.preventDefault();
                    e.stopPropagation();
                    showToast('Số lượng phải lớn hơn 0', 'error');
                    return false;
                }

                // Nếu hợp lệ, cập nhật số lượng (giảm đi 1)
                updateQuantity(input.getAttribute('data-product-id'), currentValue - 1);

                // Ngăn sự kiện mặc định và lan truyền
                e.preventDefault();
                e.stopPropagation();
            });
        });
    });

</script>
