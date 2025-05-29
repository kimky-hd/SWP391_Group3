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
    </head>

    <body>
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
                                alert('Hủy đơn hàng thành công!');
                                location.reload();
                            } else {
                                alert(response.message || 'Có lỗi xảy ra khi hủy đơn hàng.');
                            }
                        },
                        error: function() {
                            alert('Có lỗi xảy ra. Vui lòng thử lại.');
                        }
                    });
                }
            }
        </script>
    </body>
</html>