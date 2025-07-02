<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- Footer Start -->
<div class="container-fluid bg-pink text-secondary mt-5 pt-5">
    <div class="row px-xl-5 pt-5">
        <div class="col-lg-4 col-md-12 mb-5 pr-3 pr-xl-5">
            <h5 class="text-secondary text-uppercase mb-4">Thông tin liên hệ</h5>
            <p class="mb-4">Chúng tôi chuyên cung cấp các loại hoa tươi, hoa chúc mừng, hoa sinh nhật, hoa khai trương và các dịch vụ hoa tươi chuyên nghiệp.</p>
            <p class="mb-2"><i class="fa fa-map-marker-alt text-primary mr-3"></i>123 Đường ABC, Quận 1, TP.HCM</p>
            <p class="mb-2"><i class="fa fa-envelope text-primary mr-3"></i>info@flowershop.com</p>
            <p class="mb-0"><i class="fa fa-phone-alt text-primary mr-3"></i>+012 345 67890</p>
        </div>
        <div class="col-lg-8 col-md-12">
            <div class="row">
                <div class="col-md-4 mb-5">
                    <h5 class="text-secondary text-uppercase mb-4">Truy cập nhanh</h5>
                    <div class="d-flex flex-column justify-content-start">
                        <a class="text-secondary mb-2" href="Homepage"><i class="fa fa-angle-right mr-2"></i>Trang chủ</a>
                        <a class="text-secondary mb-2" href="ViewListProductController"><i class="fa fa-angle-right mr-2"></i>Sản phẩm</a>
                        <a class="text-secondary mb-2" href="Cart.jsp"><i class="fa fa-angle-right mr-2"></i>Giỏ hàng</a>
                        <a class="text-secondary mb-2" href="CheckOut.jsp"><i class="fa fa-angle-right mr-2"></i>Thanh toán</a>
                        <a class="text-secondary" href="contact.jsp"><i class="fa fa-angle-right mr-2"></i>Liên hệ</a>
                    </div>
                </div>
                <div class="col-md-4 mb-5">
                    <h5 class="text-secondary text-uppercase mb-4">Tài khoản</h5>
                    <div class="d-flex flex-column justify-content-start">
                        <a class="text-secondary mb-2" href="profile"><i class="fa fa-angle-right mr-2"></i>Thông tin cá nhân</a>
                        <a class="text-secondary mb-2" href="VoucherController"><i class="fa fa-angle-right mr-2"></i>Voucher của tôi</a>
                        <a class="text-secondary mb-2" href="order?action=view"><i class="fa fa-angle-right mr-2"></i>Đơn hàng</a>
                        <a class="text-secondary mb-2" href="blogs"><i class="fa fa-angle-right mr-2"></i>Bài viết</a>
                        <a class="text-secondary" href="contact.jsp"><i class="fa fa-angle-right mr-2"></i>Hỗ trợ</a>
                    </div>
                </div>
                <div class="col-md-4 mb-5">
                    <h5 class="text-secondary text-uppercase mb-4">Đăng ký nhận tin</h5>
                    <p>Đăng ký để nhận thông tin về sản phẩm mới và khuyến mãi</p>
                    <form action="">
                        <div class="input-group">
                            <input type="text" class="form-control" placeholder="Địa chỉ email">
                            <div class="input-group-append">
                                <button class="btn btn-primary">Đăng ký</button>
                            </div>
                        </div>
                    </form>
                    <h6 class="text-secondary text-uppercase mt-4 mb-3">Theo dõi chúng tôi</h6>
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
                &copy; <a class="text-primary" href="#">Flower Shop</a>. All Rights Reserved.
            </p>
        </div>
        <div class="col-md-6 px-xl-0 text-center text-md-right">
            <img class="img-fluid" src="img/payments.png" alt="">
        </div>
    </div>
</div>
<!-- Footer End -->

<!-- Back to Top -->
<a href="#" class="btn btn-primary back-to-top"><i class="fa fa-angle-double-up"></i></a>

<!-- Sticky Button for Custom Order -->
<div class="flower-fixed-btn">
    <a href="javascript:void(0)" class="main-btn" title="Tùy chọn">
        <i class="fas fa-seedling"></i>
    </a>
    <div class="flower-dropdown-menu">
        <a href="CustomOrder.jsp" class="dropdown-item">Đặt hoa theo yêu cầu</a>
        <a href="/Onlineshop/custom-cart" class="dropdown-item">Giỏ hàng tự thiết kế</a>
    </div>
</div>
<!-- Sticky Button for Custom Order End -->

<!-- Footer Styles -->
<style>
    .bg-pink {
        background: linear-gradient(45deg, #FFB6C1, #FFA5B5) !important;
    }

    .btn-primary {
        background-color: #FF69B4;
        border-color: #FF69B4;
    }

    .btn-primary:hover {
        background-color: #FF1493;
        border-color: #FF1493;
    }

    .text-primary {
        color: #FF69B4 !important;
    }

    .border-primary {
        border-color: #FF69B4 !important;
    }

    .back-to-top {
        position: fixed;
        right: 30px;
        bottom: 30px;
        z-index: 99;
        transition: all 0.3s ease;
    }

    .back-to-top:hover {
        transform: translateY(-3px);
    }

    .footer-link {
        transition: all 0.3s;
    }

    .footer-link:hover {
        padding-left: 10px;
        color: #FF69B4 !important;
    }

    .social-btn {
        transition: all 0.3s;
    }

    .social-btn:hover {
        transform: translateY(-3px);
    }
</style>

<!-- Footer Scripts -->
<script>
    $(document).ready(function () {
        // Back to top button
        $(window).scroll(function () {
            if ($(this).scrollTop() > 100) {
                $('.back-to-top').fadeIn('slow');
            } else {
                $('.back-to-top').fadeOut('slow');
            }
        });

        $('.back-to-top').click(function () {
            $('html, body').animate({scrollTop: 0}, 1500, 'easeInOutExpo');
            return false;
        });

        // Newsletter form
        $('form').submit(function (e) {
            e.preventDefault();
            // Add your newsletter subscription logic here
            alert('Cảm ơn bạn đã đăng ký nhận tin!');
        });
    });
</script>
