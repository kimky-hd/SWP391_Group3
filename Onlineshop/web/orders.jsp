<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="Model.Account" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="utf-8">
        <title>Hóa đơn - Flower Shop</title>
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
            /* --- GENERAL STYLES & PASTEL PALETTE --- */
            :root {
                --pink-pastel: #F8BBD0; /* Soft Pink */
                --light-pink: #FCE4EC;  /* Lighter Pink */
                --dark-pink: #D81B60;   /* Raspberry Pink for accents */
                --rose-accent: #F48FB1; /* Rose Pink for borders */
                --text-dark: #5f375f;   /* Dark Plum for text */
                --text-light: #888;     /* Lighter gray for secondary text */
                --bg-light: #FFF;
                --bg-secondary: #F7F7F7; /* Light background for sections */
                --success-color: #4CAF50; /* Green for success */
                --warning-color: #FFC107; /* Orange for warning */
                --danger-color: #DC3545; /* Red for danger */
                --info-color: #17A2B8;   /* Blue for info */
            }

            body {
                font-family: 'Montserrat', sans-serif;
                background-color: var(--light-pink); /* Nền nhẹ nhàng */
                color: var(--text-dark);
            }

            h1, h2, h3, h4, h5, h6 {
                font-family: 'Dancing Script', cursive; /* Tiêu đề mềm mại hơn */
                color: var(--dark-pink);
                margin-bottom: 1rem;
            }

            .section-title span {
                background-color: var(--light-pink) !important; /* Đảm bảo nền tiêu đề khớp */
                padding-right: 0.75rem;
            }

            .btn-primary {
                background-color: var(--dark-pink) !important;
                border-color: var(--dark-pink) !important;
                color: #fff;
                padding: 0.8rem 1.5rem;
                border-radius: 30px; /* Nút bo tròn */
                font-weight: 600;
                transition: background-color 0.3s ease, transform 0.2s ease;
            }
            .btn-primary:hover {
                background-color: #c7004d !important; /* Đậm hơn khi hover */
                transform: translateY(-2px);
            }

            .btn-danger {
                background-color: var(--danger-color) !important;
                border-color: var(--danger-color) !important;
                color: #fff;
                padding: 0.6rem 1.2rem;
                border-radius: 20px;
                font-weight: 500;
                transition: background-color 0.3s ease;
            }
            .btn-danger:hover {
                background-color: #b02a37 !important;
            }

            /* --- TABLE STYLES --- */
            .table-responsive {
                border-radius: 15px; /* Bo tròn bảng */
                overflow: hidden; /* Đảm bảo nội dung không tràn */
                box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1); /* Tạo chiều sâu */
            }

            .table-light {
                background-color: var(--bg-light);
            }

            .table-light thead.thead-dark {
                background-color: var(--dark-pink); /* Nền đầu bảng màu hồng đậm */
                color: #fff;
                font-weight: 600;
                text-transform: uppercase;
            }

            .table-light th, .table-light td {
                vertical-align: middle;
                border-color: var(--pink-pastel); /* Đường kẻ bảng màu hồng nhạt */
                padding: 1rem;
            }

            .table-light tbody tr:hover {
                background-color: var(--light-pink); /* Hiệu ứng hover nhẹ nhàng */
            }

            .badge {
                font-size: 0.85em;
                padding: 0.5em 0.8em;
                border-radius: 15px; /* Bo tròn badge */
                font-weight: 600;
                white-space: nowrap; /* Ngăn trạng thái bị ngắt dòng */
            }
            .badge-warning {
                background-color: var(--warning-color);
                color: #fff;
            }
            .badge-success {
                background-color: var(--success-color);
                color: #fff;
            }
            .badge-danger {
                background-color: var(--danger-color);
                color: #fff;
            }
            .badge-info {
                background-color: var(--info-color);
                color: #fff;
            }

            /* --- ACCORDION STYLES --- */
            .accordion .card {
                border: none; /* Bỏ viền card mặc định */
                margin-bottom: 15px;
                border-radius: 15px; /* Bo tròn card */
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08); /* Đổ bóng nhẹ nhàng */
                overflow: hidden;
            }

            .accordion .card-header {
                background-color: var(--pink-pastel); /* Nền header accordion */
                padding: 1rem 1.5rem;
                border-bottom: 1px solid var(--rose-accent);
                border-radius: 15px 15px 0 0;
                cursor: pointer;
                display: flex; /* Sử dụng flexbox */
                justify-content: space-between; /* Đẩy các phần tử ra hai bên */
                align-items: center; /* Căn giữa theo chiều dọc */
            }

            .accordion .card-header h5 {
                margin-bottom: 0;
                flex-grow: 1; /* Cho phép phần tiêu đề mở rộng */
            }

            .accordion .card-header .btn-link {
                color: var(--text-dark); /* Màu chữ trong button link */
                font-weight: 700;
                text-decoration: none;
                font-family: 'Montserrat', sans-serif; /* Font cho button link */
                display: flex;
                align-items: center;
                width: 100%; /* Đảm bảo button chiếm toàn bộ chiều rộng header */
                padding: 0; /* Bỏ padding mặc định của btn-link */
                text-align: left; /* Căn trái nội dung */
            }
            .accordion .card-header .btn-link:hover {
                color: var(--dark-pink);
            }
            .accordion .card-header .btn-link i {
                margin-right: 10px;
            }
            /* Icon mũi tên */
            .accordion .card-header .btn-link::after {
                font-family: 'Montserrat', sans-serif;
                font-weight: 900;
                content: "\f078"; /* fa-chevron-down */
                margin-left: auto; /* Đẩy mũi tên sang phải */
                transition: transform 0.3s ease;
            }
            .accordion .card-header .btn-link.collapsed::after {
                content: "\f077"; /* fa-chevron-up */
                transform: rotate(180deg);
            }

            /* Vị trí badge */
            .accordion .card-header .order-status-badge {
                margin-left: 20px; /* Khoảng cách với tiêu đề đơn hàng */
            }
            /* Tổng tiền trong header */
            .accordion .card-header .order-total {
                font-weight: 700;
                color: var(--dark-pink);
                white-space: nowrap; /* Đảm bảo tổng tiền không bị ngắt dòng */
            }

            .accordion .card-body {
                background-color: var(--bg-light);
                padding: 1.5rem;
                border-radius: 0 0 15px 15px;
            }

            .accordion .card-body h6 {
                color: var(--dark-pink);
                font-family: 'Montserrat', sans-serif;
                font-weight: 600;
                margin-bottom: 1rem;
                display: flex;
                align-items: center;
            }
            .accordion .card-body h6 i {
                margin-right: 8px;
            }

            .accordion .card-body p {
                margin-bottom: 0.5rem;
                color: var(--text-dark);
                font-size: 0.95rem;
            }

            .accordion .card-body table {
                width: 100%;
                margin-top: 1rem;
                border-collapse: collapse;
            }
            .accordion .card-body table th,
            .accordion .card-body table td {
                border: 1px solid var(--pink-pastel);
                padding: 0.8rem;
                text-align: left;
                color: var(--text-dark);
            }
            .accordion .card-body table thead {
                background-color: var(--light-pink);
                font-weight: 600;
            }
            .accordion .card-body table img {
                width: 60px;
                height: 60px;
                border-radius: 8px;
                object-fit: cover;
            }

            /* --- TOAST MESSAGE STYLES --- */
            .toast-container {
                position: fixed;
                top: 20px;
                right: 20px;
                z-index: 9999;
                font-family: 'Montserrat', sans-serif;
            }

            .toast {
                padding: 15px 25px;
                margin-bottom: 12px;
                border-radius: 12px;
                color: var(--text-dark);
                background-color: var(--light-pink); /* pastel pink background */
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
                opacity: 0;
                transform: translateX(100%);
                transition: all 0.4s ease-in-out;
                border-left: 6px solid var(--rose-accent); /* pastel rose accent */
                display: flex;
                align-items: center;
            }

            .toast.show {
                opacity: 1;
                transform: translateX(0);
            }

            .toast.success {
                background-color: #e6ffe6; /* Rất nhạt xanh lá cho success */
                border-left-color: var(--success-color);
            }

            .toast.error {
                background-color: #ffe6e6; /* Rất nhạt đỏ cho error */
                border-left-color: var(--danger-color);
            }
            /* Customize for responsiveness */
            @media (max-width: 768px) {
                .container-fluid {
                    padding: 0 15px;
                }
                .table-responsive table {
                    font-size: 0.85em;
                }
                .table-responsive th, .table-responsive td {
                    padding: 0.75rem;
                }
                .section-title {
                    text-align: center;
                }
                .accordion .card-header {
                    flex-direction: column; /* Xếp chồng trên màn hình nhỏ */
                    align-items: flex-start;
                }
                .accordion .card-header .btn-link {
                    margin-bottom: 5px; /* Khoảng cách giữa button và các thông tin khác */
                }
                .accordion .card-header .order-status-badge,
                .accordion .card-header .order-total {
                    margin-left: 0; /* Reset margin trên màn hình nhỏ */
                    width: 100%;
                    text-align: right;
                }
                .accordion .card-header .order-status-badge {
                    text-align: left;
                }
            }
        </style>
    </head>
    <body>
        <div class="container-fluid">
            <div class="row bg-secondary py-1 px-xl-5">
                <div class="col-lg-6 d-none d-lg-block">
                    <div class="d-inline-flex align-items-center h-100">
                        <a class="text-body mr-3" href="#">About</a>
                        <a class="text-body mr-3" href="#">Contact</a>
                        <a class="text-body mr-3" href="#">Help</a>
                        <a class="text-body mr-3" href="#">FAQs</a>
                    </div>
                </div>
                <div class="col-lg-6 text-center text-lg-right">
                    <div class="d-inline-flex align-items-center">
                        <% if(session.getAttribute("account") != null) { 
                            Account acc = (Account)session.getAttribute("account");
                        %>
                        <div class="btn-group">
                            <button type="button" class="btn btn-sm btn-light dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
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

                        <a href="homepage" class="text-decoration-none d-block d-lg-none">
                            <span class="h1 text-uppercase text-light bg-pink px-2">Shop</span>
                            <span class="h1 text-uppercase text-pink bg-light px-2 ml-n1">Hoa</span>
                        </a>

                        <button type="button" class="navbar-toggler" data-toggle="collapse" data-target="#navbarCollapse">
                            <span class="navbar-toggler-icon"></span>
                        </button>

                        <div class="collapse navbar-collapse justify-content-center" id="navbarCollapse">
                            <div class="navbar-nav py-0">



                                <a href="Homepage" class="nav-item nav-link active">Trang chủ</a>
                                <a href="ViewListProductController" class="nav-item nav-link ">Sản phẩm</a>
                                
                                <a href="VoucherController" class="nav-item nav-link">Mã giảm giá</a>
                                <a href="blogs" class="nav-item nav-link">Bài viết</a>

                                <div class="nav-item dropdown">
                                    <a href="#" class="nav-link dropdown-toggle" data-toggle="dropdown">Trang<i class="fa fa-angle-down mt-1"></i></a>
                                    <div class="dropdown-menu bg-primary rounded-0 border-0 m-0">

                                        <a href="Cart.jsp" class="dropdown-item">Giỏ hàng</a>
                                        <a href="CheckOut.jsp" class="dropdown-item">Thanh toán</a>

                                    </div>
                                </div>
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
                        Bạn có chắc chắn muốn đăng xuất?
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Hủy</button>
                        <a href="LogoutController" class="btn btn-primary">Đăng xuất</a>
                    </div>
                </div>
            </div>
        </div>

        <div class="container-fluid py-5">
            <h2 class="text-center mb-4">Đơn hàng của bạn</h2>
            <c:if test="${empty orders}">
                <div class="text-center py-5">
                    <img src="https://i.ibb.co/L52qFzQ/no-orders.png" alt="No orders yet" style="width: 150px; margin-bottom: 20px;">
                    <h4 class="text-dark-pink">Bạn chưa có đơn hàng nào</h4>
                    <p class="text-light">Hãy khám phá thế giới hoa tươi đẹp của chúng tôi!</p>
                    <a href="ViewListProductController" class="btn btn-primary mt-3"><i class="fa fa-shopping-bag mr-2"></i>Tiếp tục mua sắm</a>
                </div>
            </c:if>

            <c:if test="${not empty orders}">
                <div class="accordion" id="orderAccordion">
                    <c:forEach items="${orders}" var="order" varStatus="status">
                        <div class="card mb-3">
                            <div class="card-header d-flex justify-content-between align-items-center" id="heading${order.orderId}">
                                <h5 class="mb-0 flex-grow-1">
                                    <button class="btn btn-link ${status.first ? '' : 'collapsed'}" type="button" data-toggle="collapse" 
                                            data-target="#collapse${order.orderId}" aria-expanded="${status.first ? 'true' : 'false'}" 
                                            aria-controls="collapse${order.orderId}">
                                        <i class="fa fa-receipt"></i> Đơn hàng #${order.orderId} - <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy" />
                                    </button>
                                </h5>
                                <span class="badge ${order.status eq 'Pending' ? 'badge-warning' : 
                                                     order.status eq 'Completed' ? 'badge-success' : 
                                                     order.status eq 'Cancelled' ? 'badge-danger' : 'badge-info'} order-status-badge">
                                          ${order.status}
                                      </span>
                                      <strong class="order-total ml-4">Tổng tiền: <fmt:formatNumber value="${order.total}" type="currency" currencySymbol="đ"/></strong>
                                </div>

                                <div id="collapse${order.orderId}" class="collapse ${status.first ? 'show' : ''}" aria-labelledby="heading${order.orderId}" data-parent="#orderAccordion">
                                    <div class="card-body">
                                        <div class="row mb-4">
                                            <div class="col-md-6">
                                                <h6><i class="fa fa-truck"></i> Thông tin giao hàng</h6>
                                                <p><strong>Người nhận:</strong> ${order.fullName}</p>
                                                <p><strong>Địa chỉ:</strong> ${order.address}</p>
                                                <p><strong>Điện thoại:</strong> ${order.phone}</p>
                                                <p><strong>Email:</strong> ${order.email}</p>
                                            </div>
                                            <div class="col-md-6">
                                                <h6><i class="fa fa-money-check-alt"></i> Thông tin thanh toán</h6>
                                                <p><strong>Phương thức:</strong> ${order.paymentMethod}</p>
                                                <p><strong>Ngày đặt:</strong> <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy" /></p>
                                                <p><strong>Trạng thái:</strong> <span class="badge ${order.status eq 'Pending' ? 'badge-warning' : 
                                                                                                     order.status eq 'Completed' ? 'badge-success' : 
                                                                                                     order.status eq 'Cancelled' ? 'badge-danger' : 'badge-info'}">${order.status}</span></p>
                                            </div>
                                        </div>

                                        <h6><i class="fa fa-box-open"></i> Chi tiết đơn hàng</h6>
                                        <div class="table-responsive">
                                            <table class="table table-bordered">
                                                <thead>
                                                    <tr>
                                                        <th>Sản phẩm</th>
                                                        <th>Hình ảnh</th>
                                                        <th>Số lượng</th>
                                                        <th>Đơn giá</th>
                                                        <th>Thành tiền</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach items="${requestScope['details_'.concat(order.orderId)]}" var="detail">
                                                        <tr>
                                                            <td>${detail.product.title}</td>
                                                            <td>
                                                                <img src="${detail.product.image}" alt="${detail.product.title}">
                                                            </td>
                                                            <td>${detail.quantity}</td>
                                                            <td><fmt:formatNumber value="${detail.price}" type="currency" currencySymbol="đ"/></td>
                                                            <td><fmt:formatNumber value="${detail.total}" type="currency" currencySymbol="đ"/></td>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                                <tfoot>
                                                    <tr>
                                                        <td colspan="4" class="text-right"><strong>Tổng tiền sản phẩm:</strong></td>
                                                        <td>
                                                            <fmt:formatNumber value="${order.total}" type="currency" currencySymbol="đ"/>
                                                        </td>
                                                    </tr>
                                                    <c:if test="${not empty requestScope['voucher_'.concat(order.orderId)]}">
                                                        <tr>
                                                            <td colspan="4" class="text-right"><strong>Voucher giảm giá:</strong></td>
                                                            <td>
                                                                <fmt:formatNumber value="${requestScope['voucher_'.concat(order.orderId)].discountAmount}" type="currency" currencySymbol="đ"/>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="4" class="text-right"><strong>Thành tiền sau giảm giá:</strong></td>
                                                            <td>
                                                                <fmt:formatNumber value="${order.total - requestScope['voucher_'.concat(order.orderId)].discountAmount}" type="currency" currencySymbol="đ"/>
                                                            </td>
                                                        </tr>
                                                    </c:if>
                                                </tfoot>
                                            </table>
                                        </div>

                                        <c:if test="${order.status eq 'Pending'}">
                                            <div class="text-right mt-4">
                                                <button class="btn btn-danger" onclick="cancelOrder(${order.orderId})">
                                                    <i class="fa fa-times-circle mr-2"></i> Hủy đơn hàng
                                                </button>
                                            </div>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:if>
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
            <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
            <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.bundle.min.js"></script>
            <script src="lib/easing/easing.min.js"></script>
            <script src="lib/owlcarousel/owl.carousel.min.js"></script>

            <script src="mail/jqBootstrapValidation.min.js"></script>
            <script src="mail/contact.js"></script>

            <script src="js/main.js"></script>

            <script>
                                                    // Toast notification functions
                                                    function showToast(message, type) {
                                                        const container = document.querySelector('.toast-container');
                                                        // Create container if it doesn't exist
                                                        if (!container) {
                                                            const newContainer = document.createElement('div');
                                                            newContainer.className = 'toast-container';
                                                            document.body.appendChild(newContainer);
                                                        }

                                                        const toast = document.createElement('div');
                                                        toast.className = `toast ${type}`;
                                                        toast.textContent = message;

                                                        document.querySelector('.toast-container').appendChild(toast);

                                                        // Trigger reflow to enable transition
                                                        toast.offsetHeight;

                                                        // Show toast
                                                        toast.classList.add('show');

                                                        // Remove toast after 3 seconds
                                                        setTimeout(() => {
                                                            toast.classList.remove('show');
                                                            setTimeout(() => {
                                                                if (toast.parentNode) { // Check before removing
                                                                    toast.parentNode.removeChild(toast);
                                                                }
                                                            }, 400); // Should match CSS transition duration
                                                        }, 3000);
                                                    }

                                                    function cancelOrder(orderId) {
                                                        if (confirm('Bạn có chắc chắn muốn hủy đơn hàng này? Việc này không thể hoàn tác.')) {
                                                            $.ajax({
                                                                url: 'order?action=cancel', // Make sure this URL is correct for your Servlet
                                                                type: 'POST',
                                                                data: {orderId: orderId},
                                                                success: function (response) {
                                                                    // Parse JSON response
                                                                    try {
                                                                        response = JSON.parse(response);
                                                                    } catch (e) {
                                                                        console.error("Could not parse JSON response:", response);
                                                                        // Vẫn reload trang vì hành động có thể đã thành công
                                                                        showToast('Đơn hàng đã được hủy thành công!', 'warning');
                                                                        setTimeout(function () {
                                                                            location.reload();
                                                                        }, 2000);
                                                                        return;
                                                                    }

                                                                    if (response.success) {
                                                                        showToast('Đơn hàng đã được hủy thành công!', 'success');
                                                                        setTimeout(function () {
                                                                            location.reload(); // Reload the page to update order status
                                                                        }, 1500); // Wait 1.5s for user to read the message
                                                                    } else {
                                                                        showToast(response.message || 'Có lỗi xảy ra khi hủy đơn hàng. Vui lòng thử lại.', 'error');
                                                                    }
                                                                },
                                                                error: function (xhr, status, error) {
                                                                    console.error("AJAX Error: ", status, error);
                                                                    showToast('Không thể kết nối máy chủ. Vui lòng thử lại sau.', 'error');
                                                                }
                                                            });
                                                        }
                                                    }

                                                    // Load event listener for showing session messages
                                                    document.addEventListener('DOMContentLoaded', function () {
                                                        const message = '${sessionScope.message}';
                                                        const messageType = '${sessionScope.messageType}';
                                                        if (message && messageType) {
                                                            showToast(message, messageType);
                                                        }
                                                    });

                                                    // This scriptlet ensures the message is cleared server-side right after render
                <%
                session.removeAttribute("message");
                session.removeAttribute("messageType");
                %>
            </script>
        </body>
    </html>
