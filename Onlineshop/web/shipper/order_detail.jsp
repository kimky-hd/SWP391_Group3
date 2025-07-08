<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết đơn hàng - Shipper</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/css/shipper-style.css" rel="stylesheet">
</head>
<body>
    <!-- Include topbar and sidebar -->
    <jsp:include page="../manager_topbarsidebar.jsp" />

    <!-- Main Content -->
    <div class="main-content">
        <div class="container-fluid">
            <!-- Page Header -->
            <div class="row mb-4">
                <div class="col-12">
                    <div class="page-header">
                        <h1 class="page-title">
                            <i class="fas fa-file-invoice me-2"></i>
                            Chi tiết đơn hàng #${order.maHD}
                        </h1>
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/shipper/dashboard">Dashboard</a></li>
                                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/shipper/orders">Đơn hàng</a></li>
                                <li class="breadcrumb-item active" aria-current="page">Chi tiết đơn hàng</li>
                            </ol>
                        </nav>
                    </div>
                </div>
            </div>

            <!-- Order Details -->
            <div class="row">
                <!-- Order Information -->
                <div class="col-md-8">
                    <div class="card mb-4">
                        <div class="card-header">
                            <h5 class="card-title mb-0">
                                <i class="fas fa-info-circle me-2"></i>
                                Thông tin đơn hàng
                            </h5>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-6">
                                    <table class="table table-borderless">
                                        <tr>
                                            <td><strong>Mã đơn hàng:</strong></td>
                                            <td>${order.maHD}</td>
                                        </tr>
                                        <tr>
                                            <td><strong>Ngày đặt:</strong></td>
                                            <td><fmt:formatDate value="${order.ngayXuat}" pattern="dd/MM/yyyy HH:mm" /></td>
                                        </tr>
                                        <tr>
                                            <td><strong>Trạng thái:</strong></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${order.statusID == 1}">
                                                        <span class="badge bg-warning">Chờ duyệt</span>
                                                    </c:when>
                                                    <c:when test="${order.statusID == 2}">
                                                        <span class="badge bg-info">Đã duyệt</span>
                                                    </c:when>
                                                    <c:when test="${order.statusID == 3}">
                                                        <span class="badge bg-primary">Đang giao</span>
                                                    </c:when>
                                                    <c:when test="${order.statusID == 4}">
                                                        <span class="badge bg-success">Đã giao</span>
                                                    </c:when>
                                                    <c:when test="${order.statusID == 6}">
                                                        <span class="badge bg-danger">Đã hủy</span>
                                                    </c:when>
                                                    <c:when test="${order.statusID == 9}">
                                                        <span class="badge bg-secondary">Sẵn sàng giao</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-light text-dark">${order.statusName}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td><strong>Phương thức thanh toán:</strong></td>
                                            <td>${order.paymentMethod}</td>
                                        </tr>
                                        <tr>
                                            <td><strong>Tổng tiền:</strong></td>
                                            <td><strong class="text-primary"><fmt:formatNumber value="${order.tongGia}" pattern="#,##0" /> VND</strong></td>
                                        </tr>
                                        <c:if test="${not empty order.note}">
                                            <tr>
                                                <td><strong>Ghi chú:</strong></td>
                                                <td class="text-danger">${order.note}</td>
                                            </tr>
                                        </c:if>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Order Items -->
                    <div class="card mb-4">
                        <div class="card-header">
                            <h5 class="card-title mb-0">
                                <i class="fas fa-box me-2"></i>
                                Sản phẩm đã đặt
                            </h5>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-striped">
                                    <thead>
                                        <tr>
                                            <th>Sản phẩm</th>
                                            <th>Số lượng</th>
                                            
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${orderDetails}" var="detail">
                                            <tr>
                                                <td>
                                                    <div class="d-flex align-items-center">
                                                        <c:if test="${not empty detail.product.image}">
                                                            <img src="${pageContext.request.contextPath}/img/${detail.product.image}" 
                                                                 alt="${detail.product.title}" 
                                                                 class="me-2" 
                                                                 style="width: 40px; height: 40px; object-fit: cover;">
                                                        </c:if>
                                                        <div>
                                                            <div class="fw-bold">${detail.product.title}</div>
                                                            <small class="text-muted">ID: ${detail.productId}</small>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>${detail.quantity}</td>
                                                
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Customer Information -->
                <div class="col-md-4">
                    <div class="card">
                        <div class="card-header">
                            <h5 class="card-title mb-0">
                                <i class="fas fa-user me-2"></i>
                                Thông tin khách hàng
                            </h5>
                        </div>
                        <div class="card-body">
                            <table class="table table-borderless">
                                <tr>
                                    <td><strong>Tên khách hàng:</strong></td>
                                    <td>${order.customerName}</td>
                                </tr>
                                <tr>
                                    <td><strong>Email:</strong></td>
                                    <td>${order.customerEmail}</td>
                                </tr>
                                <tr>
                                    <td><strong>Số điện thoại:</strong></td>
                                    <td class="text-primary fw-bold">${order.customerPhone}</td>
                                </tr>
                                <tr>
                                    <td><strong>Địa chỉ:</strong></td>
                                    <td>${order.customerAddress}</td>
                                </tr>
                            </table>
                        </div>
                    </div>

                    <!-- Action Buttons -->
                    <div class="card mt-4">
                        <div class="card-header">
                            <h5 class="card-title mb-0">
                                <i class="fas fa-cogs me-2"></i>
                                Hành động
                            </h5>
                        </div>
                        <div class="card-body">
                            <c:choose>
                                <c:when test="${order.statusID == 2}">
                                    <button class="btn btn-success btn-sm mb-2 w-100" onclick="updateOrderStatus(${order.maHD}, 9)">
                                        <i class="fas fa-check me-2"></i>
                                        Chuẩn bị giao hàng
                                    </button>
                                </c:when>
                                <c:when test="${order.statusID == 9}">
                                    <button class="btn btn-primary btn-sm mb-2 w-100" onclick="updateOrderStatus(${order.maHD}, 3)">
                                        <i class="fas fa-shipping-fast me-2"></i>
                                        Bắt đầu giao hàng
                                    </button>
                                </c:when>
                                <c:when test="${order.statusID == 3}">
                                    <button class="btn btn-success btn-sm mb-2 w-100" onclick="updateOrderStatus(${order.maHD}, 4)">
                                        <i class="fas fa-check-circle me-2"></i>
                                        Đã giao thành công
                                    </button>
                                    <button class="btn btn-danger btn-sm mb-2 w-100" onclick="showCancelModal(${order.maHD})">
                                        <i class="fas fa-times me-2"></i>
                                        Hủy đơn hàng
                                    </button>
                                </c:when>
                                <c:otherwise>
                                    <p class="text-muted mb-0">Không có hành động nào khả dụng</p>
                                </c:otherwise>
                            </c:choose>
                            
                            <a href="${pageContext.request.contextPath}/shipper/orders" class="btn btn-secondary btn-sm w-100">
                                <i class="fas fa-arrow-left me-2"></i>
                                Quay lại danh sách
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Cancel Order Modal -->
    <div class="modal fade" id="cancelOrderModal" tabindex="-1" aria-labelledby="cancelOrderModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="cancelOrderModalLabel">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        Hủy đơn hàng
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p>Bạn có chắc chắn muốn hủy đơn hàng này không?</p>
                    <div class="mb-3">
                        <label for="cancelReason" class="form-label">Lý do hủy đơn hàng:</label>
                        <textarea class="form-control" id="cancelReason" rows="3" placeholder="Vui lòng nhập lý do hủy đơn hàng..." required></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="button" class="btn btn-danger" onclick="confirmCancel()">Xác nhận hủy</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    
    <script>
        let currentOrderId = 0;
        
        function updateOrderStatus(orderId, statusId) {
            if (confirm('Bạn có chắc chắn muốn cập nhật trạng thái đơn hàng này?')) {
                $.ajax({
                    url: '${pageContext.request.contextPath}/shipper/update-status',
                    method: 'POST',
                    data: {
                        orderId: orderId,
                        statusId: statusId
                    },
                    success: function(response) {
                        alert('Cập nhật trạng thái thành công!');
                        location.reload();
                    },
                    error: function(xhr, status, error) {
                        alert('Có lỗi xảy ra: ' + xhr.responseText);
                    }
                });
            }
        }
        
        function showCancelModal(orderId) {
            currentOrderId = orderId;
            $('#cancelOrderModal').modal('show');
        }
        
        function confirmCancel() {
            const reason = document.getElementById('cancelReason').value.trim();
            
            if (!reason) {
                alert('Vui lòng nhập lý do hủy đơn hàng');
                return;
            }
            
            $.ajax({
                url: '${pageContext.request.contextPath}/shipper/update-status',
                method: 'POST',
                data: {
                    orderId: currentOrderId,
                    statusId: 6,
                    note: reason
                },
                success: function(response) {
                    alert('Đã hủy đơn hàng thành công!');
                    $('#cancelOrderModal').modal('hide');
                    location.reload();
                },
                error: function(xhr, status, error) {
                    alert('Có lỗi xảy ra: ' + xhr.responseText);
                }
            });
        }
    </script>
</body>
</html>
