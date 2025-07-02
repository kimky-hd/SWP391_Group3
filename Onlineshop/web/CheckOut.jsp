<%-- 
    Document   : CheckOut
    Created on : May 26, 2025, 10:17:32 AM
    Author     : kimky
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Model.Account" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<jsp:include page="subiz-chat.jsp" />
<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="utf-8">
        <title>Thanh Toán - Flower Shop</title>
        <meta content="width=device-width, initial-scale=1.0" name="viewport">
        <meta content="Free HTML Templates" name="keywords">
        <meta content="Free HTML Templates" name="description">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
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
            body {
                background-color: #fff;
                font-family: 'Montserrat', sans-serif;
                color: #555;
                background-image: url('img/Pink Watercolor Abstract Linktree Background.png');
                background-size: cover;
                background-attachment: fixed;
                background-position: center;
            }

            /* CSS cho dropdown box */
            select.form-control {
                border: 2px solid #f8bbd0;
                border-radius: 8px;
                padding: 8px 12px;
                background-color: #fffafc;
                color: #5f375f;
                transition: all 0.3s ease;
                box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05);
                -webkit-appearance: none;
                -moz-appearance: none;
                appearance: none;
                background-image: url('data:image/svg+xml;utf8,<svg fill="%23f48fb1" height="24" viewBox="0 0 24 24" width="24" xmlns="http://www.w3.org/2000/svg"><path d="M7 10l5 5 5-5z"/><path d="M0 0h24v24H0z" fill="none"/></svg>');
                background-repeat: no-repeat;
                background-position: right 10px center;
            }

            select.form-control:focus {
                border-color: #e91e63;
                box-shadow: 0 0 0 3px rgba(233, 30, 99, 0.1);
                outline: none;
            }

            select.form-control option {
                background-color: #fff;
                color: #5f375f;
                padding: 10px;
            }

            select.form-control option:hover,
            select.form-control option:focus {
                background-color: #fce4ec;
            }

            /* Thêm hiệu ứng hover cho select */
            select.form-control:hover {
                border-color: #e91e63;
            }

            /* Tùy chỉnh màu sắc khi chọn option */
            select.form-control option:checked {
                background-color: #fce4ec;
                color: #e91e63;
            }
        </style>
    </head>

    <body>

        <!-- Thay thẻ <toast-container></toast-container> bằng -->
        <div class="toast-container"></div>
        <!-- Topbar Start -->
        <jsp:include page="header.jsp" />



        <!-- Checkout Start -->
        <div class="container-fluid">
            <div class="row px-xl-5">
                <div class="col-lg-8">
                    <h5 class="section-title position-relative text-uppercase mb-3"><span class="bg-secondary pr-3">Thông tin giao hàng</span></h5>
                    <div class="bg-light p-30 mb-5">
                        <!-- Thêm thông báo lưu ý về khu vực giao hàng -->
                        <div class="alert alert-info mb-4">
                            <strong>Lưu ý:</strong> Sản phẩm chỉ được bán trong nội thành Hà Nội với giá vận chuyển cố định: 30.000 đ
                        </div>
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
                                <label>Thành phố <span class="text-danger">*</span></label>
                                <input class="form-control" type="text" value="Hà Nội" id="cityInput" readonly>
                                <div class="error-message" id="cityError"></div>
                            </div>          
                            <div class="col-md-6 form-group">
                                <label>Quận/Huyện <span class="text-danger">*</span></label>
                                <select class="form-control" id="districtInput">
                                    <option value="">Chọn quận/huyện</option>
                                    <option value="Ba Đình">Ba Đình</option>
                                    <option value="Hoàn Kiếm">Hoàn Kiếm</option>
                                    <option value="Hai Bà Trưng">Hai Bà Trưng</option>
                                    <option value="Đống Đa">Đống Đa</option>
                                    <option value="Tây Hồ">Tây Hồ</option>
                                    <option value="Cầu Giấy">Cầu Giấy</option>
                                    <option value="Thanh Xuân">Thanh Xuân</option>
                                    <option value="Hoàng Mai">Hoàng Mai</option>
                                    <option value="Long Biên">Long Biên</option>
                                    <option value="Nam Từ Liêm">Nam Từ Liêm</option>
                                    <option value="Bắc Từ Liêm">Bắc Từ Liêm</option>
                                    <option value="Hà Đông">Hà Đông</option>
                                </select>
                                <div class="error-message" id="districtError"></div>
                            </div>          
                            <div class="col-md-6 form-group">
                                <label>Địa chỉ <span class="text-danger">*</span></label>
                                <input class="form-control" type="text" placeholder="123 Đường ABC" id="addressInput">
                                <div class="error-message" id="addressError"></div>
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
                        <div class="border-bottom pt-3 pb-3">
                            <div class="d-flex justify-content-between mb-3">
                                <h6>Voucher</h6>
                                <button type="button" class="btn btn-outline-primary" data-bs-toggle="modal" data-bs-target="#voucherModal">
                                    Chọn mã giảm
                                </button>
                                <!-- Bootstrap Modal -->
                                <div class="modal fade" id="voucherModal" tabindex="-1" aria-labelledby="voucherModalLabel" aria-hidden="true">
                                    <div class="modal-dialog modal-dialog-centered">
                                        <div class="modal-content">

                                            <div class="modal-header">
                                                <h5 class="modal-title" id="voucherModalLabel">Chọn mã giảm giá</h5>
                                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
                                            </div>

                                            <div class="modal-body">
                                                <c:choose>
                                                    <c:when test="${not empty vouchers}">
                                                        <ul class="list-group">
                                                            <c:forEach items="${vouchers}" var="v">
                                                                <li class="list-group-item voucher-item" data-id="${v.voucherId}" data-discount="${v.discountAmount}" style="cursor: pointer;">
                                                                    <strong>${v.code}</strong><br/>
                                                                    <small>
                                                                        <fmt:formatDate value="${v.startDate}" pattern="dd/MM/yyyy" /> -
                                                                        <fmt:formatDate value="${v.endDate}" pattern="dd/MM/yyyy" />
                                                                    </small><br/>
                                                                    <span>${v.description}</span>
                                                                </li>
                                                            </c:forEach>
                                                        </ul>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <p>Không có mã giảm giá nào khả dụng.</p>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>

                                        </div>
                                    </div>
                                </div>


                            </div>

                            <!--                        <div class="pt-2">
                                                        <div class="d-flex justify-content-between mt-2">
                                                            <h5>Tổng thanh toán</h5>
                                                            <h5><fmt:formatNumber value="${cart.total + 30000}" type="currency" currencySymbol="" pattern="#,##0"/>đ</h5>
                                                        </div>
                                                    </div>-->

                            <!-- Số tiền giảm -->
                            <div class="d-flex justify-content-between mt-2" id="discountRow" style="display: none;">
                                <h6>Được giảm</h6>
                                <h6 id="discountAmount">-0đ</h6>
                            </div>
                            <!-- Hiển thị tổng thanh toán -->
                            <div class="pt-2">
                                <div class="d-flex justify-content-between mt-2">
                                    <h5>Tổng thanh toán</h5>
                                    <h5 id="totalDisplay">
                                        <fmt:formatNumber value="${cart.total + 30000}" type="currency" currencySymbol="" pattern="#,##0"/>đ
                                    </h5>
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
                                        <label class="custom-control-label" for="directcheck">Chuyển khoản qua VN Pay</label>
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
                                    <!-- Hidden input to store selected voucher -->
                                    <input type="hidden" name="selectedVoucherId" id="selectedVoucherId" />
                                    <!-- Hidden để giữ total gốc -->
                                    <input type="hidden" name="originalTotal" id="originalTotal" value="${cart.total + 30000}" />
                                    <input type="hidden" name="totalAfterDiscount" id="totalAfterDiscount" value="${cart.total + 30000}" />
                                    <button type="button" onclick="validateAndSubmit()" class="btn btn-block btn-primary font-weight-bold py-3">Đặt hàng</button>
                                </form>

                                <!-- Thay thế script validateAndSubmit() -->                                
                                <script>
                                    function validateAndSubmit() {
                                        // Biến kiểm tra tính hợp lệ của form
                                        let isValid = true;

                                        // Lấy giá trị từ các trường input và loại bỏ khoảng trắng dư thừa
                                        const fullName = $('#fullNameInput').val().trim();
                                        const phone = $('#phoneInput').val().trim();
                                        const email = $('#emailInput').val().trim();
                                        const address = $('#addressInput').val().trim();
                                        const district = $('#districtInput').val().trim();
                                        const city = $('#cityInput').val().trim();

                                        const selectedVoucherId = $('#selectedVoucherId').val().trim();
                                        const totalAfterDiscount = $('#totalAfterDiscount').val().trim();

                                        // Ẩn tất cả các thông báo lỗi trước đó
                                        $('.error-message').hide();

                                        // Xác thực trường Họ tên
                                        if (!fullName) {
                                            $('#fullNameError').text('Vui lòng nhập họ tên').show();
                                            isValid = false;
                                        }

                                        // Xác thực trường Số điện thoại
                                        if (!phone) {
                                            $('#phoneError').text('Vui lòng nhập số điện thoại').show();
                                            isValid = false;
                                        } else if (!/^\d{10,11}$/.test(phone.replace(/[\s-+]/g, ''))) {
                                            // Kiểm tra định dạng số điện thoại: chỉ cho phép 10-11 chữ số
                                            $('#phoneError').text('Số điện thoại không hợp lệ').show();
                                            isValid = false;
                                        }

                                        // Xác thực Email (nếu người dùng có nhập)
                                        if (email && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
                                            $('#emailError').text('Email không hợp lệ').show();
                                            isValid = false;
                                        }

                                        // Xác thực các trường địa chỉ
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

                                        // Kiểm tra lựa chọn phương thức thanh toán
                                        let paymentMethod = '';
                                        if ($('#paypal').is(':checked')) {
                                            paymentMethod = 'COD'; // Thanh toán khi nhận hàng
                                        } else if ($('#directcheck').is(':checked')) {
                                            paymentMethod = 'VN Pay'; // Chuyển khoản qua VN Pay
                                        } else if ($('#banktransfer').is(':checked')) {
                                            paymentMethod = 'E-Wallet'; // Ví điện tử
                                        } else {
                                            alert('Vui lòng chọn phương thức thanh toán');
                                            isValid = false;
                                        }

                                        // Nếu có bất kỳ lỗi nào, không gửi form
                                        if (!isValid) {
                                            return false;
                                        }

                                        // Nếu hợp lệ, gán lại giá trị vào các input ẩn trước khi gửi
                                        $('#fullName').val(fullName);
                                        $('#phone').val(phone);
                                        $('#email').val(email);
                                        $('#address').val(address);
                                        $('#district').val(district);
                                        $('#city').val(city);
                                        $('#paymentMethod').val(paymentMethod);

                                        $('#selectedVoucherId').val(selectedVoucherId);
                                        $('#totalAfterDiscount').val(totalAfterDiscount);

                                        // Nếu phương thức thanh toán là VN Pay, chuyển hướng đến VNPayController
                                        if (paymentMethod === 'VN Pay') {
                                            // Tạo form mới để gửi đến VNPayController
                                            const vnpayForm = document.createElement('form');
                                            vnpayForm.method = 'POST';
                                            vnpayForm.action = 'vnpay';

                                            // Thêm các trường dữ liệu
                                            const addField = (name, value) => {
                                                const input = document.createElement('input');
                                                input.type = 'hidden';
                                                input.name = name;
                                                input.value = value;
                                                vnpayForm.appendChild(input);
                                            };

                                            addField('fullName', fullName);
                                            addField('phone', phone);
                                            addField('email', email);
                                            addField('address', address);
                                            addField('district', district);
                                            addField('city', city);

                                            addField('selectedVoucherId', selectedVoucherId);
                                            addField('totalAfterDiscount', totalAfterDiscount);

                                            // Thêm form vào body và submit
                                            document.body.appendChild(vnpayForm);
                                            vnpayForm.submit();
                                            return false;
                                        }

                                        // Gửi dữ liệu form bằng AJAX để xử lý đặt hàng cho các phương thức khác
                                        $.ajax({
                                            url: 'order',
                                            type: 'POST',
                                            data: $('#orderForm').serialize(), // Gửi toàn bộ dữ liệu form
                                            success: function (response) {
                                                if (response.success) {
                                                    // Hiển thị thông báo thành công
                                                    showToast(response.message, 'success');
                                                    // Sau 1.5s thì chuyển hướng đến trang khác (xem đơn hàng)
                                                    setTimeout(function () {
                                                        window.location.href = response.redirectUrl || 'order?action=view';
                                                    }, 1500);
                                                } else {
                                                    // Hiển thị lỗi nếu xử lý thất bại
                                                    showToast(response.message, 'error');
                                                }
                                            },
                                            error: function () {
                                                // Lỗi kết nối hoặc server
                                                showToast('Có lỗi xảy ra khi xử lý thanh toán', 'error');
                                            }
                                        });

                                        return false; // Ngăn trình duyệt gửi form theo cách mặc định
                                    }
                                </script>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- Checkout End -->

            <!-- Footer Start -->
            <jsp:include page="footer.jsp" />
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
            <!-- Sticky Button for Custom Order -->
            <div class="flower-fixed-btn">
                <a href="CustomOrder.jsp" title="Đặt hoa theo yêu cầu">
                    <i class="fas fa-seedling"></i> <!-- Bạn có thể thay bằng: fa-pencil-alt, fa-heart, fa-rose -->
                </a>
            </div>
            <!-- Sticky Button for Custom Order End -->

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

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
            <script>
                                    document.querySelectorAll('.voucher-item').forEach(item => {
                                        item.addEventListener('click', function () {
                                            const voucherId = this.dataset.id;
                                            const code = this.querySelector('strong')?.innerText || "Đã chọn";

                                            // Set giá trị vào input
                                            document.getElementById('selectedVoucherId').value = voucherId;

                                            // Cập nhật lại nút nếu muốn
                                            document.querySelector('button[data-bs-target="#voucherModal"]').textContent = code;

                                            const discount = parseInt(this.dataset.discount || '0');
                                            const originalTotal = parseInt(document.getElementById('originalTotal').value);
                                            // Tính tổng sau giảm
                                            const newTotal = Math.max(originalTotal - discount, 0);
                                            // Format tiền VND (có thể chỉnh theo nhu cầu)
                                            const formatted = newTotal.toLocaleString('vi-VN') + 'đ';
                                            // Hiển thị số tiền được giảm
                                            // Format tiền kiểu VND
                                            const formatVND = (value) => value.toLocaleString('vi-VN') + 'đ';
                                            document.getElementById('discountAmount').textContent = '-' + formatVND(discount);
                                            document.getElementById('discountRow').style.display = 'flex';

                                            // Gán lại tổng mới vào HTML
                                            document.getElementById('totalDisplay').textContent = formatted;
                                            document.getElementById('totalAfterDiscount').value = newTotal;

                                            // Đóng modal
                                            const modal = bootstrap.Modal.getInstance(document.getElementById('voucherModal'));
                                            modal.hide();
                                        });
                                    });
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