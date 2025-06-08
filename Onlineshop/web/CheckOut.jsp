<%-- 
    Document   : CheckOut
    Created on : May 26, 2025, 10:17:32 AM
    Author     : kimky
--%>
<%@ page import="Model.Account" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="utf-8">
        <title>Thanh Toán - Flower Shop</title>
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
            .error-message {
                color: red;
                font-size: 12px;
                margin-top: 5px;
                display: none;
            }

            .form-group.error .form-control {
                border-color: red;
            }

            .form-group.error .error-message {
                display: block;
            }
        </style>
    </head>

    <body>
        <!-- Thay thẻ <toast-container></toast-container> bằng -->
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
                                <a href="Homepage" class="nav-item nav-link active">Trang chủ</a>
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


        <!-- Checkout Start -->
        <div class="container-fluid">
            <div class="row px-xl-5">
                <div class="col-lg-8">
                    <h5 class="section-title position-relative text-uppercase mb-3"><span class="bg-secondary pr-3">Thông tin giao hàng</span></h5>
                    <div class="bg-light p-30 mb-5">
                        <div class="row">
                            <div class="col-md-6 form-group">
                                <label>Họ và tên <span class="text-danger">*</span></label>
                                <input class="form-control" type="text" placeholder="Nguyễn Văn A" id="fullNameInput">
                                <div class="error-message" id="fullNameError"></div>
                            </div>
                            <div class="col-md-6 form-group">
                                <label>Email</label>
                                <input class="form-control" type="text" placeholder="example@email.com" id="emailInput">
                                <div class="error-message" id="emailError"></div>
                            </div>
                            <div class="col-md-6 form-group">
                                <label>Số điện thoại <span class="text-danger">*</span></label>
                                <input class="form-control" type="text" placeholder="+84 123 456 789" id="phoneInput">
                                <div class="error-message" id="phoneError"></div>
                            </div>
                            <div class="col-md-6 form-group">
                                <label>Địa chỉ <span class="text-danger">*</span></label>
                                <input class="form-control" type="text" placeholder="123 Đường ABC" id="addressInput">
                                <div class="error-message" id="addressError"></div>
                            </div>
                            <div class="col-md-6 form-group">
                                <label>Quận/Huyện <span class="text-danger">*</span></label>
                                <input class="form-control" type="text" placeholder="Quận 1" id="districtInput">
                                <div class="error-message" id="districtError"></div>
                            </div>
                            <div class="col-md-6 form-group">
                                <label>Thành phố <span class="text-danger">*</span></label>
                                <input class="form-control" type="text" placeholder="TP.HCM" id="cityInput">
                                <div class="error-message" id="cityError"></div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-4">
                    <h5 class="section-title position-relative text-uppercase mb-3"><span class="bg-secondary pr-3">Tổng đơn hàng</span></h5>
                    <div class="bg-light p-30 mb-5">
                        <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
                        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

                        <!-- Trong phần hiển thị sản phẩm -->
                        <div class="border-bottom">
                            <h6 class="mb-3">Sản phẩm</h6>
                            <c:forEach items="${cart.items}" var="item">
                                <div class="d-flex justify-content-between">
                                    <p>${item.product.title} x ${item.quantity}</p>
                                    <p><fmt:formatNumber value="${item.total}" type="currency" currencySymbol="" pattern="#,##0"/>đ</p>
                                </div>
                            </c:forEach>
                        </div>
                        <div class="border-bottom pt-3 pb-2">
                            <div class="d-flex justify-content-between mb-3">
                                <h6>Tổng tiền hàng</h6>
                                <h6><fmt:formatNumber value="${cart.total}" type="currency" currencySymbol="" pattern="#,##0"/>đ</h6>
                            </div>
                            <div class="d-flex justify-content-between">
                                <h6 class="font-weight-medium">Phí vận chuyển</h6>
                                <h6 class="font-weight-medium">30.000đ</h6>
                            </div>
                        </div>
                        <div class="pt-2">
                            <div class="d-flex justify-content-between mt-2">
                                <h5>Tổng thanh toán</h5>
                                <h5><fmt:formatNumber value="${cart.total + 30000}" type="currency" currencySymbol="" pattern="#,##0"/>đ</h5>
                            </div>
                        </div>
                    </div>
                    <div class="mb-5">
                        <h5 class="section-title position-relative text-uppercase mb-3"><span class="bg-secondary pr-3">Phương thức thanh toán</span></h5>
                        <div class="bg-light p-30">
                            <div class="form-group">
                                <div class="custom-control custom-radio">
                                    <input type="radio" class="custom-control-input" name="payment" id="paypal">
                                    <label class="custom-control-label" for="paypal">Thanh toán khi nhận hàng</label>
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="custom-control custom-radio">
                                    <input type="radio" class="custom-control-input" name="payment" id="directcheck">
                                    <label class="custom-control-label" for="directcheck">Chuyển khoản ngân hàng</label>
                                </div>
                            </div>
                            <div class="form-group mb-4">
                                <div class="custom-control custom-radio">
                                    <input type="radio" class="custom-control-input" name="payment" id="banktransfer">
                                    <label class="custom-control-label" for="banktransfer">Ví điện tử</label>
                                </div>
                            </div>
                            <!-- Thay thế nút đặt hàng bằng form submit -->
                            <form action="order" method="post" id="orderForm">
                                <input type="hidden" name="action" value="place">
                                <input type="hidden" name="fullName" id="fullName">
                                <input type="hidden" name="phone" id="phone">
                                <input type="hidden" name="email" id="email">
                                <input type="hidden" name="address" id="address">
                                <input type="hidden" name="district" id="district">
                                <input type="hidden" name="city" id="city">
                                <input type="hidden" name="paymentMethod" id="paymentMethod">
                                <button type="button" onclick="validateAndSubmit()" class="btn btn-block btn-primary font-weight-bold py-3">Đặt hàng</button>
                            </form>

                            <script>
                                function validateAndSubmit() {
                                    // Xác thực form
                                    let isValid = true;

                                    // Lấy giá trị từ các trường input
                                    const fullName = $('#fullNameInput').val().trim();
                                    const phone = $('#phoneInput').val().trim();
                                    const email = $('#emailInput').val().trim();
                                    const address = $('#addressInput').val().trim();
                                    const district = $('#districtInput').val().trim();
                                    const city = $('#cityInput').val().trim();

                                    // Reset tất cả thông báo lỗi
                                    $('.error-message').hide();

                                    // Kiểm tra các trường bắt buộc
                                    if (!fullName) {
                                        $('#fullNameError').text('Vui lòng nhập họ tên').show();
                                        isValid = false;
                                    }

                                    if (!phone) {
                                        $('#phoneError').text('Vui lòng nhập số điện thoại').show();
                                        isValid = false;
                                    } else if (!/^\d{10,11}$/.test(phone.replace(/[\s-+]/g, ''))) {
                                        $('#phoneError').text('Số điện thoại không hợp lệ').show();
                                        isValid = false;
                                    }

                                    if (email && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
                                        $('#emailError').text('Email không hợp lệ').show();
                                        isValid = false;
                                    }

                                    if (!address) {
                                        $('#addressError').text('Vui lòng nhập địa chỉ').show();
                                        isValid = false;
                                    }

                                    if (!district) {
                                        $('#districtError').text('Vui lòng nhập quận/huyện').show();
                                        isValid = false;
                                    }

                                    if (!city) {
                                        $('#cityError').text('Vui lòng nhập thành phố').show();
                                        isValid = false;
                                    }

                                    // Kiểm tra phương thức thanh toán
                                    let paymentMethod = '';
                                    if ($('#paypal').is(':checked')) {
                                        paymentMethod = 'COD';
                                    } else if ($('#directcheck').is(':checked')) {
                                        paymentMethod = 'Bank Transfer';
                                    } else if ($('#banktransfer').is(':checked')) {
                                        paymentMethod = 'E-Wallet';
                                    } else {
                                        alert('Vui lòng chọn phương thức thanh toán');
                                        isValid = false;
                                    }

                                    // Nếu có lỗi, dừng xử lý và không gửi form
                                    if (!isValid) {
                                        return false;
                                    }

                                    // Cập nhật giá trị cho form ẩn
                                    $('#fullName').val(fullName);
                                    $('#phone').val(phone);
                                    $('#email').val(email);
                                    $('#address').val(address);
                                    $('#district').val(district);
                                    $('#city').val(city);
                                    $('#paymentMethod').val(paymentMethod);

                                    // Gửi form qua AJAX
                                    $.ajax({
                                        url: 'order',
                                        type: 'POST',
                                        data: $('#orderForm').serialize(),
                                        success: function (response) {
                                            if (response.success) {
                                                showToast(response.message, 'success');
                                                // Chuyển hướng sau khi hiển thị thông báo
                                                setTimeout(function () {
                                                    window.location.href = response.redirectUrl || 'order?action=view';
                                                }, 1500);
                                            } else {
                                                showToast(response.message, 'error');
                                            }
                                        },
                                        error: function () {
                                            showToast('Có lỗi xảy ra khi xử lý thanh toán', 'error');
                                        }
                                    });

                                    return false; // Ngăn form submit thông thường
                                }
                            </script>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- Checkout End -->

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

        <!-- Back to Top -->
        <a href="#" class="btn btn-primary back-to-top"><i class="fa fa-angle-double-up"></i></a>

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

        <script>
                                function showToast(message, type) {
                                    const container = document.querySelector('.toast-container');
                                    const toast = document.createElement('div');
                                    toast.className = `toast ${type}`;
                                    toast.textContent = message;

                                    container.appendChild(toast);

                                    // Trigger reflow to enable transition
                                    toast.offsetHeight;

                                    // Show toast
                                    toast.classList.add('show');

                                    // Remove toast after 3 seconds
                                    setTimeout(() => {
                                        toast.classList.remove('show');
                                        setTimeout(() => {
                                            container.removeChild(toast);
                                        }, 400);
                                    }, 3000);
                                }

                                // Check for message in session
                                const message = '${sessionScope.message}';
                                const messageType = '${sessionScope.messageType}';
                                if (message && messageType) {
                                    showToast(message, messageType);
                                    // Clear the message from session
            <% 
                session.removeAttribute("message");
                session.removeAttribute("messageType");
            %>
                                }
        </script>
    </body>

</html>

<style>
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
</style>