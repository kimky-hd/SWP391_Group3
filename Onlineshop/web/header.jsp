<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Model.Account" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!-- Topbar Start -->
<div class="container-fluid">
    <div class="row bg-secondary py-1 px-xl-5">
        <div class="col-lg-6 d-none d-lg-block">
            <div class="d-inline-flex align-items-center h-100">
                <a class="text-body mr-3 hover-link" href="">About</a>
                <a class="text-body mr-3 hover-link" href="">Contact</a>
                <a class="text-body mr-3 hover-link" href="">Help</a>
                <a class="text-body mr-3 hover-link" href="">FAQs</a>
            </div>
        </div>
        <div class="col-lg-6 text-center text-lg-right">
            <div class="d-inline-flex align-items-center">
                <% if(session.getAttribute("account") != null) { 
                    Account acc = (Account)session.getAttribute("account");
                %>
                <div class="btn-group">
                    <button type="button" class="btn btn-sm btn-light dropdown-toggle user-dropdown" data-toggle="dropdown">
                        <i class="fas fa-user-circle mr-2"></i><%= acc.getUsername() %>
                    </button>
                    <div class="dropdown-menu dropdown-menu-right">

                        <a href="profile" class="dropdown-item"><i class="fas fa-user mr-2"></i>Thông tin cá nhân</a>
                        <a href="VoucherController" class="dropdown-item"><i class="fas fa-ticket-alt mr-2"></i>Voucher của tôi</a>
                        <div class="dropdown-divider"></div>
                        <button type="button" class="dropdown-item" data-toggle="modal" data-target="#logoutModal">
                            <i class="fas fa-sign-out-alt mr-2"></i>Đăng xuất
                        </button>

                    </div>
                </div>
                <% } else { %>
                    <a href="login.jsp" class="btn btn-sm btn-light mr-2 auth-btn">
                        <i class="fas fa-sign-in-alt mr-2"></i>Đăng nhập
                    </a>
                    <a href="register.jsp" class="btn btn-sm btn-light auth-btn">
                        <i class="fas fa-user-plus mr-2"></i>Đăng ký
                    </a>
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
            <a href="Homepage.jsp" class="text-decoration-none logo-container">
                <span class="h1 text-uppercase text-light bg-pink px-2">Flower</span>
                <span class="h1 text-uppercase text-pink bg-light px-2 ml-n1">Shop</span>
            </a>
        </div>
        <div class="col-lg-4 col-6 text-left">
            <form action="" class="search-form">
                <div class="input-group">
                    <input type="text" class="form-control" placeholder="Tìm kiếm sản phẩm...">
                    <div class="input-group-append">
                        <button class="btn btn-pink">
                            <i class="fa fa-search"></i>
                        </button>
                    </div>
                </div>
            </form>
        </div>
        <div class="col-lg-4 col-6 text-right">
            <p class="m-0">Hỗ trợ khách hàng</p>
            <h5 class="m-0 text-pink">+012 345 6789</h5>
        </div>
    </div>
</div>
<!-- Topbar End -->

<!-- Navbar Start -->
<div class="container-fluid bg-pink mb-30">
    <div class="row px-xl-5">
        <div class="col-lg-12">
            <nav class="navbar navbar-expand-lg bg-pink navbar-dark py-3 py-lg-0 px-0 w-100">

                <a href="Homepage.jsp" class="text-decoration-none d-block d-lg-none mobile-logo">
                    <span class="h1 text-uppercase text-light bg-pink px-2">Flower</span>
                    <span class="h1 text-uppercase text-pink bg-light px-2 ml-n1">Shop</span>
                </a>
                <button type="button" class="navbar-toggler" data-toggle="collapse" data-target="#navbarCollapse">
                    <span class="navbar-toggler-icon"></span>
                </button>

                <div class="collapse navbar-collapse justify-content-center" id="navbarCollapse">
                    <div class="navbar-nav py-0">
                        <a href="Homepage" class="nav-item nav-link active">Trang chủ</a>
                        <a href="ViewListProductController" class="nav-item nav-link">Sản phẩm</a>
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
                    <a href="#" class="btn px-0 ml-3 icon-btn">
                        <i class="fas fa-heart text-primary"></i>
                        <span class="badge text-secondary border border-secondary rounded-circle" style="padding-bottom: 2px;">0</span>
                    </a>
                    <a href="Cart.jsp" class="btn px-0 ml-3 icon-btn">
                        <i class="fas fa-shopping-cart text-primary"></i>
                        <span class="badge text-secondary border border-secondary rounded-circle" style="padding-bottom: 2px;">
                            ${sessionScope.cartItemCount != null ? sessionScope.cartItemCount : (sessionScope.cart != null ? sessionScope.cart.getTotalItems() : 0)}
                        </span>
                    </a>
                    <a href="order?action=view" class="btn px-0 ml-3 icon-btn">
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

<!-- Logout Modal-->
<div class="modal fade" id="logoutModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content">
            <div class="modal-header bg-pink text-white">
                <h5 class="modal-title" id="exampleModalLabel">
                    <i class="fas fa-sign-out-alt mr-2"></i>Xác nhận đăng xuất
                </h5>
                <button class="close text-white" type="button" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span>
                </button>
            </div>
            <div class="modal-body py-4">
                <div class="text-center mb-3">
                    <i class="fas fa-question-circle text-pink" style="font-size: 3rem;"></i>
                </div>
                <p class="text-center mb-0" style="font-size: 1.1rem; color: #000000; font-weight: 600;">
                    Bạn có chắc chắn muốn đăng xuất khỏi tài khoản?
                </p>
            </div>
            <div class="modal-footer justify-content-center border-0 pt-0">
                <button class="btn btn-secondary px-4" type="button" data-dismiss="modal">
                    <i class="fas fa-times mr-2"></i>Hủy
                </button>
                <a class="btn btn-pink px-4" href="LogoutServlet">
                    <i class="fas fa-sign-out-alt mr-2"></i>Đăng xuất
                </a>
            </div>
        </div>
    </div>
</div>

<style>
    :root {
        --primary-pink: #FFB6C1;
        --secondary-pink: #FFA5B5;
        --dark-pink: #FF69B4;
        --light-pink: #FFF0F5;
    }

    /* Logo Styles */
    .logo-container {
        display: inline-block;
        transition: all 0.3s ease;
        position: relative;
        padding: 5px;
    }

    .logo-container:hover {
        transform: translateY(-2px);
    }

    .logo-container::after {
        content: '';
        position: absolute;
        bottom: -2px;
        left: 0;
        width: 100%;
        height: 2px;
        background: linear-gradient(45deg, var(--primary-pink), var(--dark-pink));
        transform: scaleX(0);
        transition: transform 0.3s ease;
    }

    .logo-container:hover::after {
        transform: scaleX(1);
    }

    /* Navigation Styles */
    .navbar {
        box-shadow: 0 4px 6px rgba(0,0,0,0.1);
    }

    .navbar-nav .nav-link {
        font-weight: 500;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        padding: 15px 20px;
        transition: all 0.3s ease;
    }

    .navbar-nav .nav-link:hover {
        color: var(--light-pink) !important;
        background: rgba(255,255,255,0.1);
        transform: translateY(-2px);
    }

    /* Search Form Styles */
    .search-form .form-control {
        border-radius: 20px 0 0 20px;
        border: 2px solid var(--primary-pink);
        border-right: none;
    }

    .search-form .btn-pink {
        border-radius: 0 20px 20px 0;
        background: linear-gradient(45deg, var(--primary-pink), var(--dark-pink));
        border: none;
        padding: 0.375rem 1.25rem;
    }

    /* Button Styles */
    .auth-btn {
        border-radius: 20px;
        transition: all 0.3s ease;
        font-weight: 500;
    }

    .auth-btn:hover {
        transform: translateY(-2px);
        box-shadow: 0 2px 5px rgba(0,0,0,0.1);
    }

    .icon-btn {
        transition: all 0.3s ease;
    }

    .icon-btn:hover {
        transform: translateY(-2px);
    }

    .icon-btn:hover i {
        animation: heartBeat 1s infinite;
    }

    /* Badge Styles */
    .badge {
        transition: all 0.3s ease;
        font-weight: 600;
    }

    .icon-btn:hover .badge {
        transform: scale(1.1);
    }

    /* Dropdown Styles */
    .dropdown-menu {
        border-radius: 10px;
        box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        border: none;
        padding: 10px 0;
    }

    .dropdown-item {
        padding: 8px 20px;
        font-weight: 500;
        transition: all 0.3s ease;
    }

    .dropdown-item:hover {
        background: linear-gradient(45deg, var(--primary-pink), var(--dark-pink));
        color: white;
        transform: translateX(5px);
    }

    /* User Dropdown */
    .user-dropdown {
        border-radius: 20px;
        font-weight: 500;
        transition: all 0.3s ease;
    }

    .user-dropdown:hover {
        background: var(--light-pink);
    }

    /* Top Links */
    .hover-link {
        transition: all 0.3s ease;
        position: relative;
    }

    .hover-link::after {
        content: '';
        position: absolute;
        bottom: -2px;
        left: 0;
        width: 100%;
        height: 2px;
        background: var(--primary-pink);
        transform: scaleX(0);
        transition: transform 0.3s ease;
    }

    .hover-link:hover::after {
        transform: scaleX(1);
    }

    /* Animations */
    @keyframes heartBeat {
        0% { transform: scale(1); }
        50% { transform: scale(1.2); }
        100% { transform: scale(1); }
    }

    /* Modal Styles */
    .modal-content {
        border: none;
        border-radius: 15px;
        box-shadow: 0 5px 15px rgba(0,0,0,0.1);
    }

    .modal-header {
        border-top-left-radius: 15px;
        border-top-right-radius: 15px;
        border-bottom: none;
    }

    .btn-pink {
        background: linear-gradient(45deg, var(--primary-pink), var(--dark-pink));
        border: none;
        color: white;
        transition: all 0.3s ease;
    }

    .btn-pink:hover {
        transform: translateY(-2px);
        box-shadow: 0 5px 15px rgba(255, 182, 193, 0.4);
    }

    /* Responsive Styles */
    @media (max-width: 991.98px) {
        .navbar-nav {
            padding: 10px 0;
        }

        .navbar-nav .nav-link {
            padding: 10px 15px;
        }

        .mobile-logo {
            margin: 10px 0;
        }
    }
</style>

<script>
    $(document).ready(function() {
        // Xử lý sự kiện khi nhấn vào nút đăng xuất
        $('.dropdown-item[data-toggle="modal"]').on('click', function(e) {
            e.preventDefault();
            $('#logoutModal').modal('show');
        });

        // Active nav-link based on current page
        const currentLocation = window.location.href;
        $('.navbar-nav .nav-link').each(function() {
            if (currentLocation.includes($(this).attr('href'))) {
                $(this).addClass('active');
            }
        });
    });
</script>
