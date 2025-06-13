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
        <jsp:include page="header.jsp" />
        <div class="page-content-wrapper">
            <div class="container-fluid">
                <div class="row px-xl-5">
                    <div class="col-lg-8 table-responsive mb-5">
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
                                                    <small class="text-muted">Còn lại: ${item.product.quantity}</small>
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
        <jsp:include page="footer.jsp" />
        <a href="#" class="btn btn-primary back-to-top"><i class="fa fa-angle-double-up"></i></a>


        <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.bundle.min.js"></script>
        <script src="lib/easing/easing.min.js"></script>
        <script src="lib/owlcarousel/owl.carousel.min.js"></script>

        <script src="js/main.js"></script>

        <script>
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
