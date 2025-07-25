<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:choose>
    <c:when test="${not empty error}">
        <div class="alert alert-danger">
            <i class="fas fa-exclamation-triangle me-2"></i>
            <strong>Lỗi:</strong> ${error}
        </div>
    </c:when>
    <c:when test="${not empty order}">
        <div class="container-fluid">
            <div class="row">
                <!-- Order Information -->
                <div class="col-md-8">
                    <div class="card mb-4">
                        <div class="card-header">
                            <h6 class="card-title mb-0">
                                <i class="fas fa-info-circle me-2"></i>
                                Thông tin đơn hàng #${order.maHD}
                            </h6>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-12">
                                    <table class="table table-borderless table-sm">
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
                                                    <c:when test="${order.statusID == 2}">
                                                        <span class="badge bg-info">Đã duyệt</span>
                                                    </c:when>
                                                    <c:when test="${order.statusID == 4}">
                                                        <span class="badge bg-success">Đã giao</span>
                                                    </c:when>
                                                    <c:when test="${order.statusID == 10}">
                                                        <span class="badge bg-danger">Không thành công</span>
                                                    </c:when>
                                                    <c:when test="${order.statusID == 3}">
                                                        <span class="badge bg-primary">Đang vận chuyển</span>
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
                    <div class="card">
                        <div class="card-header">
                            <h6 class="card-title mb-0">
                                <i class="fas fa-box me-2"></i>
                                Sản phẩm đã đặt
                            </h6>
                        </div>
                        <div class="card-body">
                            <c:choose>
                                <c:when test="${not empty orderDetails}">
                                    <div class="table-responsive">
                                        <table class="table table-striped table-sm">
                                            <thead>
                                                <tr>
                                                    <th>Sản phẩm</th>
                                                    <th>Số lượng</th>
                                                    <th>Đơn giá</th>
                                                    <th>Thành tiền</th>
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
                                                                         style="width: 30px; height: 30px; object-fit: cover;">
                                                                </c:if>
                                                                <div>
                                                                    <div class="fw-bold">${detail.product.title}</div>
                                                                    <small class="text-muted">ID: ${detail.productId}</small>
                                                                </div>
                                                            </div>
                                                        </td>
                                                        <td>${detail.quantity}</td>
                                                        <td><fmt:formatNumber value="${detail.price}" pattern="#,##0" /> VND</td>
                                                        <td><fmt:formatNumber value="${detail.total}" pattern="#,##0" /> VND</td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="alert alert-info">
                                        <i class="fas fa-info-circle me-2"></i>
                                        Không có sản phẩm nào trong đơn hàng này.
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

                <!-- Customer Information -->
                <div class="col-md-4">
                    <div class="card">
                        <div class="card-header">
                            <h6 class="card-title mb-0">
                                <i class="fas fa-user me-2"></i>
                                Thông tin khách hàng
                            </h6>
                        </div>
                        <div class="card-body">
                            <table class="table table-borderless table-sm">
                                <tr>
                                    <td><strong>Tên khách hàng:</strong></td>
                                    <td>${not empty order.customerName ? order.customerName : 'Chưa có thông tin'}</td>
                                </tr>
                                <tr>
                                    <td><strong>Email:</strong></td>
                                    <td>${not empty order.customerEmail ? order.customerEmail : 'Chưa có thông tin'}</td>
                                </tr>
                                <tr>
                                    <td><strong>Số điện thoại:</strong></td>
                                    <td class="text-primary fw-bold">${not empty order.customerPhone ? order.customerPhone : 'Chưa có thông tin'}</td>
                                </tr>
                                <tr>
                                    <td><strong>Địa chỉ:</strong></td>
                                    <td>${not empty order.customerAddress ? order.customerAddress : 'Chưa có thông tin'}</td>
                                </tr>
                            </table>
                        </div>
                    </div>

                    <!-- Action Buttons -->
                    <div class="card mt-3">
                        <div class="card-header">
                            <h6 class="card-title mb-0">
                                <i class="fas fa-cogs me-2"></i>
                                Hành động
                            </h6>
                        </div>
                        <div class="card-body">
                            <c:choose>
                                <c:when test="${order.statusID == 2}">
                                    <button class="btn btn-success btn-sm mb-2 w-100" onclick="updateOrderStatusInModal(${order.maHD}, 9)">
                                        <i class="fas fa-check me-2"></i>
                                        Chuẩn bị giao hàng
                                    </button>
                                </c:when>
                                <c:when test="${order.statusID == 9}">
                                    <button class="btn btn-primary btn-sm mb-2 w-100" onclick="updateOrderStatusInModal(${order.maHD}, 3)">
                                        <i class="fas fa-shipping-fast me-2"></i>
                                        Bắt đầu giao hàng
                                    </button>
                                </c:when>
                                <c:when test="${order.statusID == 3}">
                                    <button class="btn btn-success btn-sm mb-2 w-100" onclick="updateOrderStatusInModal(${order.maHD}, 4)">
                                        <i class="fas fa-check-circle me-2"></i>
                                        Đã giao thành công
                                    </button>
                                    <button class="btn btn-danger btn-sm mb-2 w-100" onclick="showCancelModalFromDetail(${order.maHD})">
                                        <i class="fas fa-times me-2"></i>
                                        Hủy đơn hàng
                                    </button>
                                </c:when>
                                <c:otherwise>
                                    <p class="text-muted mb-0">Không có hành động nào khả dụng</p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </c:when>
    <c:otherwise>
        <div class="alert alert-warning">
            <i class="fas fa-exclamation-triangle me-2"></i>
            <strong>Không tìm thấy đơn hàng</strong>
            <br>Đơn hàng yêu cầu không tồn tại hoặc đã bị xóa.
        </div>
    </c:otherwise>
</c:choose>

<script>
    // Modal-specific functions
    function updateOrderStatusInModal(orderId, statusId) {
        if (confirm('Bạn có chắc chắn muốn cập nhật trạng thái đơn hàng này?')) {
            fetch('${pageContext.request.contextPath}/shipper/update-status', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'orderId=' + orderId + '&statusId=' + statusId
            })
            .then(response => {
                if (response.ok) {
                    alert('Cập nhật trạng thái thành công!');
                    // Close modal and reload parent page
                    const modal = bootstrap.Modal.getInstance(document.getElementById('orderDetailsModal'));
                    if (modal) modal.hide();
                    window.location.reload();
                } else {
                    return response.text().then(text => { throw new Error(text) });
                }
            })
            .catch(error => {
                console.error('Error updating status:', error);
                alert('Có lỗi xảy ra: ' + error.message);
            });
        }
    }

    function showCancelModalFromDetail(orderId) {
        // Close detail modal first
        const detailModal = bootstrap.Modal.getInstance(document.getElementById('orderDetailsModal'));
        if (detailModal) detailModal.hide();
        
        // Set the order ID and show cancel modal
        if (typeof window.parent.cancelOrder === 'function') {
            window.parent.cancelOrder(orderId);
        } else {
            // Fallback: set global variable and show modal directly
            window.parent.currentOrderId = orderId;
            const cancelModal = new bootstrap.Modal(window.parent.document.getElementById('cancelOrderModal'));
            cancelModal.show();
        }
    }
</script>
