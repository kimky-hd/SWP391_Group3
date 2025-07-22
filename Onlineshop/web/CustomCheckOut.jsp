<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Thanh toán đơn hàng tùy chỉnh</title>
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css"
              rel="stylesheet">
        <!-- Font Awesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <!-- Custom CSS -->
        <link rel="stylesheet" href="css/style.css">
        <style>
            .checkout-container {
                max-width: 1200px;
                margin: 0 auto;
                padding: 20px;
            }

            .checkout-header {
                margin-bottom: 30px;
                text-align: center;
            }

            .checkout-form {
                background-color: #f8f9fa;
                padding: 20px;
                border-radius: 5px;
                margin-bottom: 20px;
            }

            .order-summary {
                background-color: #f8f9fa;
                padding: 20px;
                border-radius: 5px;
            }

            .payment-methods {
                margin-top: 20px;
            }

            .payment-method {
                border: 1px solid #ddd;
                padding: 15px;
                margin-bottom: 10px;
                border-radius: 5px;
                cursor: pointer;
            }

            .payment-method.selected {
                border-color: #007bff;
                background-color: #f0f7ff;
            }

            .payment-method img {
                height: 30px;
                margin-right: 10px;
            }

            .voucher-section {
                margin-top: 20px;
                padding: 15px;
                border: 1px solid #ddd;
                border-radius: 5px;
            }

            .order-summary img {
                border: 1px solid #ddd;
                border-radius: 4px;
                padding: 3px;
                transition: transform 0.3s ease;
            }

            .order-summary img:hover {
                transform: scale(1.05);
                cursor: pointer;
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
        </style>
    </head>

    <body>
        <!-- Include Header -->
        <jsp:include page="header.jsp"></jsp:include>

            <!-- Thêm container cho toast messages -->
            <div class="toast-container"></div>

            <div class="checkout-container">
                <div class="checkout-header">
                    <h2>Thanh toán đơn hàng tùy chỉnh</h2>
                </div>

                <div class="row">
                    <!-- Thông tin giao hàng -->
                    <div class="col-md-7">
                        <div class="checkout-form">
                            <h4>Thông tin giao hàng</h4>
                            <form id="checkoutForm" method="post" action="custom-vnpay">
                                <input type="hidden" name="customCartId" value="${customOrderCart.customCartID}">

                            <div class="mb-3">
                                <label for="fullName" class="form-label">Họ và tên</label>
                                <input type="text" class="form-control" id="fullName" name="fullName"
                                       value="${customOrderCart.fullName}" required>
                                <div class="error-message" id="fullNameError"></div>
                            </div>

                            <div class="mb-3">
                                <label for="phone" class="form-label">Số điện thoại</label>
                                <input type="tel" class="form-control" id="phone" name="phone"
                                       value="${customOrderCart.phone}" required>
                                <div class="error-message" id="phoneError"></div>
                            </div>

                            <div class="mb-3">
                                <label for="email" class="form-label">Email</label>
                                <input type="email" class="form-control" id="email" name="email"
                                       value="${customOrderCart.email}" required>
                                <div class="error-message" id="emailError"></div>
                            </div>

                            <div class="mb-3">
                                <label for="address" class="form-label">Địa chỉ</label>
                                <input type="text" class="form-control" id="address" name="address" required>
                                <div class="error-message" id="addressError"></div>
                            </div>

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="district" class="form-label">Quận/Huyện</label>
                                    <select class="form-select" id="district" name="district" required>
                                        <option value="" selected disabled>Chọn quận/huyện</option>
                                        <option value="Hà Đông">Hà Đông</option>
                                        <option value="Thanh Xuân">Thanh Xuân</option>
                                        <option value="Nam Từ Liêm">Nam Từ Liêm</option>
                                        <option value="Bắc Từ Liêm">Bắc Từ Liêm</option>
                                        <option value="Hoàng Mai">Hoàng Mai</option>
                                        <option value="Cầu Giấy">Cầu Giấy</option>
                                        <option value="Hai Bà Trưng">Hai Bà Trưng</option>
                                        <option value="Hoàn Kiếm">Hoàn Kiếm</option>
                                        <option value="Đống Đa">Đống Đa</option>
                                        <option value="Ba Đình">Ba Đình</option>
                                        <option value="Tây Hồ">Tây Hồ</option>
                                        <option value="Long Biên">Long Biên</option>
                                    </select>
                                    <div class="error-message" id="districtError"></div>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="city" class="form-label">Tỉnh/Thành phố</label>
                                    <input type="text" class="form-control" id="city" name="city" value="Hà Nội"
                                           readonly>
                                    <div class="error-message" id="cityError"></div>
                                </div>
                            </div>

                            <!-- Lưu ý về phí vận chuyển -->
                            <div class="alert alert-info mt-3">
                                <h5>Lưu ý: Phí vận chuyển sẽ được tính dựa trên khu vực giao hàng:</h5>
                                <ul>
                                    <li>Phí ship 30.000đ (khu vực gần Hà Đông): Hà Đông, Thanh Xuân, Nam Từ
                                        Liêm, Bắc Từ Liêm, Hoàng Mai, Cầu Giấy</li>
                                    <li>Phí ship 50.000đ (khu vực xa Hà Đông): Hai Bà Trưng, Hoàn Kiếm, Đống Đa,
                                        Ba Đình, Tây Hồ, Long Biên</li>
                                </ul>
                            </div>

                            <!-- Phương thức thanh toán -->
                            <div class="payment-methods">
                                <h4>Phương thức thanh toán</h4>
                                <div class="payment-method selected" data-method="vnpay">
                                    <input type="radio" name="paymentMethod" value="vnpay" checked>
                                    <span>Thanh toán qua VN Pay</span>
                                </div>
                            </div>

                            <!-- Voucher Section -->
                            <div class="voucher-section">
                                <h4>Mã giảm giá</h4>
                                <select class="form-select" id="voucherSelect" name="selectedVoucherId">
                                    <option value="">Không sử dụng mã giảm giá</option>
                                    <c:forEach items="${vouchers}" var="voucher">
                                        <option value="${voucher.voucherID}"
                                                data-discount="${voucher.discountAmount}"
                                                data-type="${voucher.discountType}">
                                            ${voucher.code} - <c:if
                                                test="${voucher.discountType == 'percentage'}">Giảm
                                                ${voucher.discountAmount}%</c:if>
                                            <c:if test="${voucher.discountType == 'fixed'}">Giảm
                                                <fmt:formatNumber value="${voucher.discountAmount}"
                                                                  type="currency" currencySymbol="₫" maxFractionDigits="0" />
                                            </c:if>
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>

                            <input type="hidden" id="totalAfterDiscount" name="totalAfterDiscount"
                                   value="${customOrderCart.desiredPrice}">
                            <input type="hidden" id="shippingFee" name="shippingFee" value="0">

                            <button type="submit" class="btn btn-primary mt-4 w-100">Tiến hành thanh
                                toán</button>
                        </form>
                    </div>
                </div>

                <!-- Tóm tắt đơn hàng -->
                <div class="col-md-5">
                    <div class="order-summary">
                        <h4>Tóm tắt đơn hàng</h4>
                        <div class="card mb-3">
                            <div class="card-body">
                                <div class="d-flex justify-content-between">
                                    <h5 class="card-title">Đơn hàng tùy chỉnh #${customOrderCart.customCartID}
                                    </h5>
                                </div>
                                <p class="card-text">${customOrderCart.description}</p>
                                <div class="d-flex justify-content-between">
                                    <span>Số lượng:</span>
                                    <span>${customOrderCart.quantity}</span>
                                </div>
                                <c:if test="${not empty customOrderCart.referenceImage}">
                                    <div class="mt-2">
                                        <h5>Hình ảnh tham khảo:</h5>
                                        <div class="row">
                                            <div class="col-md-4 mb-2">
                                                <img src="${customOrderCart.referenceImage}"
                                                     alt="Hình ảnh tham khảo" class="img-fluid"
                                                     style="max-height: 150px;">
                                            </div>

                                            <c:if test="${not empty customOrderCart.referenceImage2}">
                                                <div class="col-md-4 mb-2">
                                                    <img src="${customOrderCart.referenceImage2}"
                                                         alt="Hình ảnh tham khảo 2" class="img-fluid"
                                                         style="max-height: 150px;">
                                                </div>
                                            </c:if>

                                            <c:if test="${not empty customOrderCart.referenceImage3}">
                                                <div class="col-md-4 mb-2">
                                                    <img src="${customOrderCart.referenceImage3}"
                                                         alt="Hình ảnh tham khảo 3" class="img-fluid"
                                                         style="max-height: 150px;">
                                                </div>
                                            </c:if>

                                            <c:if test="${not empty customOrderCart.referenceImage4}">
                                                <div class="col-md-4 mb-2">
                                                    <img src="${customOrderCart.referenceImage4}"
                                                         alt="Hình ảnh tham khảo 4" class="img-fluid"
                                                         style="max-height: 150px;">
                                                </div>
                                            </c:if>

                                            <c:if test="${not empty customOrderCart.referenceImage5}">
                                                <div class="col-md-4 mb-2">
                                                    <img src="${customOrderCart.referenceImage5}"
                                                         alt="Hình ảnh tham khảo 5" class="img-fluid"
                                                         style="max-height: 150px;">
                                                </div>
                                            </c:if>
                                        </div>
                                    </div>
                                </c:if>
                            </div>
                        </div>

                        <div class="card">
                            <div class="card-body">
                                <h5 class="card-title">Chi tiết thanh toán</h5>

                                <div class="d-flex justify-content-between mb-2">
                                    <span>Tạm tính:</span>
                                    <span id="subtotal">
                                        <fmt:formatNumber value="${customOrderCart.desiredPrice}" type="currency" currencySymbol="₫" maxFractionDigits="0" />
                                        × ${customOrderCart.quantity}
                                        =
                                        <fmt:formatNumber value="${customOrderCart.desiredPrice * customOrderCart.quantity}" type="currency" currencySymbol="₫" maxFractionDigits="0" />
                                    </span>
                                </div>

                                <div class="d-flex justify-content-between mb-2">
                                    <span>Giảm giá:</span>
                                    <span id="discount">0 ₫</span>
                                </div>

                                <div class="d-flex justify-content-between mb-2">
                                    <span>Phí vận chuyển:</span>
                                    <span id="shipping">0 ₫</span>
                                </div>

                                <hr>

                                <div class="d-flex justify-content-between fw-bold">
                                    <span>Tổng cộng:</span>
                                    <span id="total">
                                        <fmt:formatNumber value="${customOrderCart.desiredPrice * customOrderCart.quantity}" type="currency" currencySymbol="₫" maxFractionDigits="0" />
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Include Footer -->
        <jsp:include page="footer.jsp"></jsp:include>

        <!-- Bootstrap JS -->
        <script
        src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
        <!-- jQuery -->
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        
        <script>
            $(document).ready(function() {
                // Danh sách các quận gần Hà Đông (phí ship 30.000đ)
                const nearbyDistricts = ['Hà Đông', 'Thanh Xuân', 'Nam Từ Liêm', 'Bắc Từ Liêm', 'Hoàng Mai', 'Cầu Giấy'];

                // Danh sách các quận xa Hà Đông (phí ship 50.000đ)
                const farDistricts = ['Hai Bà Trưng', 'Hoàn Kiếm', 'Đống Đa', 'Ba Đình', 'Tây Hồ', 'Long Biên'];

                // Phí ship mặc định
                const defaultShippingFee = 30000;
                const farShippingFee = 50000;
                
                // Hàm tạo và hiển thị toast message
                function showToast(message, type = 'error') {
                    // Tạo phần tử toast
                    const toast = document.createElement('div');
                    toast.className = `toast ${type}`;
                    toast.textContent = message;
                    
                    // Thêm vào container
                    document.querySelector('.toast-container').appendChild(toast);
                    
                    // Kích hoạt reflow để đảm bảo transition được áp dụng
                    toast.offsetHeight;
                    
                    // Hiển thị toast
                    setTimeout(() => {
                        toast.classList.add('show');
                    }, 100);
                    
                    // Tự động ẩn sau 3 giây
                    setTimeout(() => {
                        toast.classList.remove('show'); // Bắt đầu ẩn toast
                        setTimeout(() => {
                            toast.removeChild(toast); // Xóa khỏi DOM sau khi ẩn hoàn tất
                        }, 400); // Đợi 400ms cho hiệu ứng ẩn hoàn tất
                    }, 3000); // Thời gian hiển thị 3 giây
                }
                
                // Hàm định dạng tiền tệ
                function formatCurrency(amount) {
                    return amount.toLocaleString('vi-VN') + ' ₫';
                }
                
                // Hàm tính phí ship dựa trên quận được chọn
                function getShippingFee(district) {
                    if (farDistricts.includes(district)) {
                        return farShippingFee;
                    }
                    return defaultShippingFee;
                }
                
                // Hàm tính tổng thanh toán
                function calculateTotal() {
                    const subtotal = ${customOrderCart.desiredPrice * customOrderCart.quantity};
                    let discount = 0;
                    
                    // Tính giảm giá nếu có voucher được chọn
                    const selectedVoucher = $('#voucherSelect option:selected');
                    if (selectedVoucher.val()) {
                        const discountType = selectedVoucher.data('type');
                        const discountAmount = parseFloat(selectedVoucher.data('discount'));
                        
                        if (discountType === 'percentage') {
                            discount = (subtotal * discountAmount) / 100;
                        } else if (discountType === 'fixed') {
                            discount = discountAmount;
                        }
                    }
                    
                    // Lấy phí ship
                    const selectedDistrict = $('#district').val();
                    const shippingFee = selectedDistrict ? getShippingFee(selectedDistrict) : 0;
                    
                    // Tính tổng
                    let total = subtotal - discount + shippingFee;
                    
                    // Đảm bảo tổng không nhỏ hơn phí ship
                    if (total < shippingFee) {
                        total = shippingFee;
                    }
                    
                    // Cập nhật hiển thị
                    $('#discount').text(formatCurrency(discount));
                    $('#shipping').text(formatCurrency(shippingFee));
                    $('#total').text(formatCurrency(total));
                    
                    // Cập nhật giá trị input ẩn
                    $('#totalAfterDiscount').val(total);
                    $('#shippingFee').val(shippingFee);
                }
                
                // Xử lý khi chọn quận/huyện
                $('#district').change(function() {
                    calculateTotal();
                });
                
                // Xử lý khi chọn voucher
                $('#voucherSelect').change(function() {
                    calculateTotal();
                });
                
                // Xử lý khi submit form
                $('#checkoutForm').submit(function(e) {
                    // Kiểm tra xem đã chọn quận/huyện chưa
                    if (!$('#district').val()) {
                        e.preventDefault();
                        showToast('Vui lòng chọn quận/huyện để tính phí vận chuyển');
                        return false;
                    }
                    
                    // Kiểm tra các trường khác
                    const fullName = $('#fullName').val().trim();
                    const phone = $('#phone').val().trim();
                    const email = $('#email').val().trim();
                    const address = $('#address').val().trim();
                    
                    if (!fullName || fullName.length < 2 || fullName.length > 50) {
                        e.preventDefault();
                        showToast('Họ tên phải từ 2-50 ký tự');
                        return false;
                    }
                    
                    // Kiểm tra số điện thoại Việt Nam
                    const phoneRegex = /(84|0[3|5|7|8|9])+([0-9]{8})\b/;
                    if (!phone || !phoneRegex.test(phone)) {
                        e.preventDefault();
                        showToast('Số điện thoại không hợp lệ');
                        return false;
                    }
                    
                    // Kiểm tra email
                    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                    if (!email || !emailRegex.test(email)) {
                        e.preventDefault();
                        showToast('Email không hợp lệ');
                        return false;
                    }
                    
                    // Kiểm tra địa chỉ
                    if (!address || address.length < 5 || address.length > 200) {
                        e.preventDefault();
                        showToast('Địa chỉ phải từ 5-200 ký tự');
                        return false;
                    }
                });
                
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
                
                // Tính toán ban đầu khi trang được tải
                calculateTotal();
            });
        </script>
        
        <style>
            .checkout-container {
                max-width: 1200px;
                margin: 0 auto;
                padding: 20px;
            }

            .checkout-header {
                margin-bottom: 30px;
                text-align: center;
            }

            .checkout-form {
                background-color: #f8f9fa;
                padding: 20px;
                border-radius: 5px;
                margin-bottom: 20px;
            }

            .order-summary {
                background-color: #f8f9fa;
                padding: 20px;
                border-radius: 5px;
            }

            .payment-methods {
                margin-top: 20px;
            }

            .payment-method {
                border: 1px solid #ddd;
                padding: 15px;
                margin-bottom: 10px;
                border-radius: 5px;
                cursor: pointer;
            }

            .payment-method.selected {
                border-color: #007bff;
                background-color: #f0f7ff;
            }

            .payment-method img {
                height: 30px;
                margin-right: 10px;
            }

            .voucher-section {
                margin-top: 20px;
                padding: 15px;
                border: 1px solid #ddd;
                border-radius: 5px;
            }

            .order-summary img {
                border: 1px solid #ddd;
                border-radius: 4px;
                padding: 3px;
                transition: transform 0.3s ease;
            }

            .order-summary img:hover {
                transform: scale(1.05);
                cursor: pointer;
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
        </style>