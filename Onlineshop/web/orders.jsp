<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="Model.Account" %>
<jsp:include page="subiz-chat.jsp" />
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

        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">

        <link href="lib/animate/animate.min.css" rel="stylesheet">
        <link href="lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">

        <link href="css/style.css" rel="stylesheet">
        <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.bundle.min.js"></script>
        <script src="lib/easing/easing.min.js"></script>
        <script src="lib/owlcarousel/owl.carousel.min.js"></script>
        <script src="mail/jqBootstrapValidation.min.js"></script>
        <script src="mail/contact.js"></script>
        <script src="js/main.js"></script>
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
                font-family: 'Montserrat', sans-serif;
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
        <jsp:include page="header.jsp" />

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
                                <span class="badge ${order.status eq 'Chờ duyệt' ? 'badge-warning' : 
                                                     order.status eq 'Đã giao hàng thành công' ? 'badge-success' : 
                                                     order.status eq 'Đã hủy' ? 'badge-danger' : 'badge-info'} order-status-badge">
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
                                                                <img src="img/${detail.product.image}" alt="${detail.product.title}">
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

                                        <c:if test="${order.status eq 'Chờ duyệt'}">
                                            <div class="text-right mt-4">
                                                <button class="btn btn-danger" onclick="cancelOrder(${order.orderId})">
                                                    <i class="fa fa-times-circle mr-2"></i> Hủy đơn hàng
                                                </button>
                                            </div>
                                        </c:if>
                                        <c:if test="${order.status eq 'Đơn hàng đang được vận chuyển'}">
                                            <div class="text-right mt-4">
                                                <button class="btn btn-success" onclick="confirmReceived(${order.orderId})">
                                                    <i class="fa fa-check-circle mr-2"></i> Đã nhận được hàng
                                                </button>
                                            </div>
                                        </c:if>
                                        <c:if test="${order.status eq 'Đã giao hàng thành công'}">
                                            <div class="text-right mt-4">
                                                <a href="complaint?action=showForm&maHD=${order.orderId}" class="btn btn-warning">
                                                    <i class="fa fa-exclamation-triangle mr-2"></i> Gửi khiếu nại
                                                </a>
                                            </div>
                                        </c:if>

                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:if>
            </div>
            <jsp:include page="footer.jsp" />
            <script>
// Hàm hiển thị thông báo dạng "toast"
                function showToast(message, type) {
                    const container = document.querySelector('.toast-container');

                    // Nếu chưa có container chứa toast, tạo mới và thêm vào DOM
                    if (!container) {
                        const newContainer = document.createElement('div');
                        newContainer.className = 'toast-container';
                        document.body.appendChild(newContainer);
                    }

                    // Tạo phần tử toast mới
                    const toast = document.createElement('div');
                    toast.className = `toast ${type}`; // Gán class theo loại thông báo: success, error, warning,...
                    toast.textContent = message; // Nội dung thông báo

                    // Thêm toast vào container
                    document.querySelector('.toast-container').appendChild(toast);

                    // Kích hoạt reflow để áp dụng hiệu ứng transition
                    toast.offsetHeight;

                    // Thêm class hiển thị toast
                    toast.classList.add('show');

                    // Sau 3 giây, ẩn toast đi và xóa khỏi DOM
                    setTimeout(() => {
                        toast.classList.remove('show');
                        setTimeout(() => {
                            if (toast.parentNode) { // Kiểm tra nếu toast vẫn còn trong DOM
                                toast.parentNode.removeChild(toast); // Xóa khỏi DOM
                            }
                        }, 400); // Thời gian khớp với transition CSS
                    }, 3000);
                }

// Hàm hủy đơn hàng theo ID
                function cancelOrder(orderId) {
                    // Hỏi xác nhận người dùng trước khi hủy
                    if (confirm('Bạn có chắc chắn muốn hủy đơn hàng này? Việc này không thể hoàn tác.')) {
                        $.ajax({
                            url: 'order?action=cancel', // Đường dẫn xử lý hủy đơn hàng (Servlet)
                            type: 'POST',
                            data: {orderId: orderId}, // Gửi dữ liệu orderId
                            success: function (response) {
                                // Thử chuyển đổi phản hồi thành JSON
                                try {
                                    response = JSON.parse(response);
                                } catch (e) {
                                    console.error("Không thể parse JSON response:", response);
                                    // Nếu lỗi, vẫn hiển thị toast và reload vì có thể backend đã xử lý xong
                                    showToast('Đơn hàng đã được hủy thành công!', 'warning');
                                    setTimeout(function () {
                                        location.reload();
                                    }, 2000);
                                    return;
                                }

                                // Nếu phản hồi thành công -> thông báo và reload
                                if (response.success) {
                                    showToast('Đơn hàng đã được hủy thành công!', 'success');
                                    setTimeout(function () {
                                        location.reload(); // Tải lại trang để cập nhật trạng thái đơn hàng
                                    }, 1500); // Đợi 1.5 giây cho người dùng đọc
                                } else {
                                    // Nếu có lỗi từ backend -> hiển thị thông báo lỗi
                                    showToast(response.message || 'Có lỗi xảy ra khi hủy đơn hàng. Vui lòng thử lại.', 'error');
                                }
                            },
                            error: function (xhr, status, error) {
                                // Lỗi khi không thể kết nối server
                                console.error("Lỗi AJAX: ", status, error);
                                showToast('Không thể kết nối máy chủ. Vui lòng thử lại sau.', 'error');
                            }
                        });
                    }
                }

// Sự kiện khi DOM đã sẵn sàng
                document.addEventListener('DOMContentLoaded', function () {
                    // Lấy thông báo từ session (do server trả về)
                    const message = '${sessionScope.message}';
                    const messageType = '${sessionScope.messageType}';

                    // Nếu có thông báo -> hiển thị bằng toast
                    if (message && messageType) {
                        showToast(message, messageType);
                    }
                });

// Xóa thông báo khỏi session sau khi render để không hiển thị lại lần sau
                <%
session.removeAttribute("message");
session.removeAttribute("messageType");
                %>

// Khi trang được tải, gọi API để cập nhật số lượng đơn hàng
                document.addEventListener('DOMContentLoaded', function () {
                    // Chỉ gọi khi người dùng đã đăng nhập (kiểm tra session ở phía server)
                <% if (session.getAttribute("account") != null) { %>
                    fetch('ordercount'); // Gửi yêu cầu lấy số lượng đơn hàng
                <% } %>
                });

// Hàm xác nhận đã nhận được hàng
                function confirmReceived(orderId) {
                    // Hỏi xác nhận người dùng trước khi cập nhật
                    if (confirm('Bạn xác nhận đã nhận được hàng? Đơn hàng sẽ được chuyển sang trạng thái "Đã giao hàng thành công".')) {
                        $.ajax({
                            url: 'order?action=confirm_received', // Đường dẫn xử lý xác nhận đã nhận hàng
                            type: 'POST',
                            data: {orderId: orderId}, // Gửi dữ liệu orderId
                            success: function (response) {
                                // Thử chuyển đổi phản hồi thành JSON
                                try {
                                    response = JSON.parse(response);
                                } catch (e) {
                                    console.error("Không thể parse JSON response:", response);
                                    // Nếu lỗi, vẫn hiển thị toast và reload vì có thể backend đã xử lý xong
                                    showToast('Đã xác nhận nhận hàng thành công!', 'success');
                                    setTimeout(function () {
                                        location.reload();
                                    }, 2000);
                                    return;
                                }

                                // Nếu phản hồi thành công -> thông báo và reload
                                if (response.success) {
                                    showToast('Đã xác nhận nhận hàng thành công!', 'success');
                                    setTimeout(function () {
                                        location.reload(); // Tải lại trang để cập nhật trạng thái đơn hàng
                                    }, 1500); // Đợi 1.5 giây cho người dùng đọc
                                } else {
                                    // Nếu có lỗi từ backend -> hiển thị thông báo lỗi
                                    showToast(response.message || 'Có lỗi xảy ra khi xác nhận. Vui lòng thử lại.', 'error');
                                }
                            },
                            error: function (xhr, status, error) {
                                // Lỗi khi không thể kết nối server
                                console.error("Lỗi AJAX: ", status, error);
                                showToast('Không thể kết nối máy chủ. Vui lòng thử lại sau.', 'error');
                            }
                        });
                    }
                }
            </script>
        </body>
    </html>
