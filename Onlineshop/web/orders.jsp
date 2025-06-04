<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>Đơn hàng của tôi - Flower Shop</title>
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
        <!-- Thêm thẻ div toast-container ngay sau thẻ body -->
        <div class="toast-container" style="position: fixed; top: 20px; right: 20px; z-index: 9999;"></div>
        
        <!-- Include your header/navigation here -->

        <!-- Orders Start -->
        <div class="container-fluid">
            <div class="row px-xl-5">
                <div class="col-12">
                    <h3 class="section-title position-relative text-uppercase mb-4"><span class="bg-secondary pr-3">Đơn hàng của tôi</span></h3>
                    
                    <c:if test="${empty orders}">
                        <div class="text-center py-5">
                            <h4>Bạn chưa có đơn hàng nào</h4>
                            <a href="shop.jsp" class="btn btn-primary mt-3">Tiếp tục mua sắm</a>
                        </div>
                    </c:if>
                    
                    <c:if test="${not empty orders}">
                        <div class="table-responsive mb-5">
                            <table class="table table-light table-borderless table-hover text-center mb-0">
                                <thead class="thead-dark">
                                    <tr>
                                        <th>Mã đơn hàng</th>
                                        <th>Ngày đặt</th>
                                        <th>Địa chỉ</th>
                                        <th>Tổng tiền</th>
                                        <th>Trạng thái</th>
                                        <th>Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody class="align-middle">
                                    <c:forEach items="${orders}" var="order">
                                        <tr>
                                            <td class="align-middle">#${order.orderId}</td>
                                            <td class="align-middle">
                                                <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm" />
                                            </td>
                                            <td class="align-middle">${order.address}</td>
                                            <td class="align-middle">
                                                <fmt:formatNumber value="${order.total}" type="currency" currencySymbol="đ"/>
                                            </td>
                                            <td class="align-middle">
                                                <span class="badge ${order.status eq 'Pending' ? 'badge-warning' : 
                                                                   order.status eq 'Completed' ? 'badge-success' : 
                                                                   order.status eq 'Cancelled' ? 'badge-danger' : 'badge-info'}">
                                                    ${order.status}
                                                </span>
                                            </td>
                                            <td class="align-middle">
                                                <c:if test="${order.status eq 'Pending'}">
                                                    <button class="btn btn-sm btn-danger" onclick="cancelOrder(${order.orderId})">
                                                        Hủy đơn
                                                    </button>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
        <!-- Orders End -->

        <!-- Include your footer here -->

        <!-- JavaScript Libraries -->
        <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.bundle.min.js"></script>
        <script src="lib/easing/easing.min.js"></script>
        <script src="lib/owlcarousel/owl.carousel.min.js"></script>

        <!-- Order Operations JavaScript -->
        <script>
            function cancelOrder(orderId) {
                if (confirm('Bạn có chắc chắn muốn hủy đơn hàng này?')) {
                    $.ajax({
                        url: 'order?action=cancel',
                        type: 'POST',
                        data: { orderId: orderId },
                        success: function(response) {
                            if (response.success) {
                                showToast('Hủy đơn hàng thành công!', 'success');
                                setTimeout(function() {
                                    location.reload();
                                }, 1500);
                            } else {
                                showToast(response.message || 'Có lỗi xảy ra khi hủy đơn hàng.', 'error');
                            }
                        },
                        error: function() {
                            showToast('Có lỗi xảy ra. Vui lòng thử lại.', 'error');
                        }
                    });
                }
            }
            
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
            
            // Đảm bảo DOM đã tải xong
            document.addEventListener('DOMContentLoaded', function() {
                // Check for message in session
                const message = '${sessionScope.message}';
                const messageType = '${sessionScope.messageType}';
                if (message && messageType) {
                    showToast(message, messageType);
                }
                
                // Kiểm tra xem toast có hoạt động không bằng cách hiển thị một thông báo test
                // Bỏ comment dòng dưới để test
                // showToast('Đây là thông báo test', 'success');
            });
        </script>
        
        <% 
        // Clear the message from session
        session.removeAttribute("message");
        session.removeAttribute("messageType");
        %>
    </body>
</html>