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
                                                    <c:when test="${order.statusID == 10}">
                                                        <span class="badge bg-danger">Giao không thành công</span>
                                                    </c:when>
                                                    <c:when test="${order.statusID == 10}">
                                                        <span class="badge bg-secondary">Không thành công</span>
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
                                        <c:if test="${not empty order.imageNote}">
                                            <tr>
                                                <td><strong>Ảnh minh chứng:</strong></td>
                                                <td>
                                                    <a href="${pageContext.request.contextPath}/${order.imageNote}" 
                                                       target="_blank" class="btn btn-sm btn-outline-primary">
                                                        <i class="fas fa-image me-1"></i>
                                                        Xem ảnh
                                                    </a>
                                                    <div class="mt-2">
                                                        <img src="${pageContext.request.contextPath}/${order.imageNote}" 
                                                             alt="Evidence" 
                                                             class="img-thumbnail" 
                                                             style="max-width: 200px; max-height: 150px; cursor: pointer;"
                                                             onclick="window.open('${pageContext.request.contextPath}/${order.imageNote}', '_blank')">
                                                    </div>
                                                </td>
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
                                                                 style="width: 40px; height: 40px; object-fit: cover;">
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
                                    <button class="btn btn-success btn-sm mb-2 w-100" onclick="updateOrderStatus(${order.maHD}, 3)">
                                        <i class="fas fa-shipping-fast me-2"></i>
                                        Bắt đầu giao hàng
                                    </button>
                                </c:when>
                                <c:when test="${order.statusID == 3}">
                                    <button class="btn btn-success btn-sm mb-2 w-100" onclick="showDeliveryModal(${order.maHD}, 4)">
                                        <i class="fas fa-check-circle me-2"></i>
                                        Đã giao thành công
                                    </button>
                                    <button class="btn btn-danger btn-sm mb-2 w-100" onclick="showDeliveryModal(${order.maHD}, 10)">
                                        <i class="fas fa-times me-2"></i>
                                        Giao không thành công
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

    <!-- Delivery Status Modal -->
    <div class="modal fade" id="deliveryStatusModal" tabindex="-1" aria-labelledby="deliveryStatusModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="deliveryStatusModalLabel">
                        <i class="fas fa-truck me-2"></i>
                        Cập nhật trạng thái giao hàng
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form id="deliveryForm" enctype="multipart/form-data">
                    <div class="modal-body">
                        <input type="hidden" id="modalOrderId" name="orderId" value="">
                        <input type="hidden" id="modalStatusId" name="statusId" value="">
                        
                        <div id="noteSection" class="mb-3" style="display: none;">
                            <label for="deliveryNote" class="form-label">Lý do giao không thành công: <span class="text-danger">*</span></label>
                            <textarea class="form-control" id="deliveryNote" name="note" rows="3" 
                                placeholder="Vui lòng nhập lý do cụ thể..."></textarea>
                        </div>
                        
                        <div class="mb-3">
                            <label for="deliveryImage" class="form-label">
                                Ảnh minh chứng: 
                                <span id="imageRequired" class="text-danger" style="display: none;">*</span>
                                <span id="imageOptional" class="text-muted" style="display: none;">(Tùy chọn)</span>
                            </label>
                            <input type="file" class="form-control" id="deliveryImage" name="image" 
                                accept="image/*" onchange="previewImage(this)">
                            <div class="form-text">Chỉ chấp nhận file JPG, JPEG, PNG, GIF. Tối đa 5MB.</div>
                        </div>
                        
                        <div id="imagePreview" class="mb-3" style="display: none;">
                            <label class="form-label">Xem trước ảnh:</label>
                            <div class="text-center">
                                <img id="previewImg" src="" alt="Preview" class="img-thumbnail" style="max-width: 300px; max-height: 200px;">
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="button" class="btn btn-primary" onclick="confirmDeliveryStatus()">
                            <i class="fas fa-save me-2"></i>
                            Xác nhận
                        </button>
                    </div>
                </form>
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
                    <button type="button" class="btn btn-danger" onclick="confirmCancel()">Xác nhận</button>
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
        
        function showDeliveryModal(orderId, statusId) {
            document.getElementById('modalOrderId').value = orderId;
            document.getElementById('modalStatusId').value = statusId;
            
            const noteSection = document.getElementById('noteSection');
            const imageRequired = document.getElementById('imageRequired');
            const imageOptional = document.getElementById('imageOptional');
            const deliveryNote = document.getElementById('deliveryNote');
            const deliveryImage = document.getElementById('deliveryImage');
            
            if (statusId == 10) {
                // Failed delivery - require both note and image
                noteSection.style.display = 'block';
                imageRequired.style.display = 'inline';
                imageOptional.style.display = 'none';
                deliveryNote.required = true;
                deliveryImage.required = true;
                document.getElementById('deliveryStatusModalLabel').innerHTML = 
                    '<i class="fas fa-exclamation-triangle me-2"></i>Giao hàng không thành công';
            } else {
                // Successful delivery - optional image
                noteSection.style.display = 'none';
                imageRequired.style.display = 'none';
                imageOptional.style.display = 'inline';
                deliveryNote.required = false;
                deliveryImage.required = false;
                document.getElementById('deliveryStatusModalLabel').innerHTML = 
                    '<i class="fas fa-check-circle me-2"></i>Giao hàng thành công';
            }
            
            // Reset form
            document.getElementById('deliveryForm').reset();
            document.getElementById('modalOrderId').value = orderId;
            document.getElementById('modalStatusId').value = statusId;
            hideImagePreview();
            
            $('#deliveryStatusModal').modal('show');
        }
        
        function previewImage(input) {
            if (input.files && input.files[0]) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    document.getElementById('previewImg').src = e.target.result;
                    document.getElementById('imagePreview').style.display = 'block';
                };
                reader.readAsDataURL(input.files[0]);
            } else {
                hideImagePreview();
            }
        }
        
        function hideImagePreview() {
            document.getElementById('imagePreview').style.display = 'none';
            document.getElementById('previewImg').src = '';
        }
        
        function confirmDeliveryStatus() {
            const orderId = document.getElementById('modalOrderId').value;
            const statusId = document.getElementById('modalStatusId').value;
            const note = document.getElementById('deliveryNote').value.trim();
            const imageFile = document.getElementById('deliveryImage').files[0];
            
            // Validation
            if (statusId == 10) {
                if (!note) {
                    alert('Vui lòng nhập lý do giao hàng không thành công');
                    return;
                }
                if (!imageFile) {
                    alert('Vui lòng chọn ảnh minh chứng cho việc giao hàng không thành công');
                    return;
                }
            }
            
            // Create FormData for file upload
            const formData = new FormData();
            formData.append('orderId', orderId);
            formData.append('statusId', statusId);
            if (note) {
                formData.append('note', note);
            }
            if (imageFile) {
                formData.append('image', imageFile);
            }
            
            $.ajax({
                url: '${pageContext.request.contextPath}/shipper/update-status',
                method: 'POST',
                data: formData,
                processData: false,
                contentType: false,
                success: function(response) {
                    alert('Cập nhật trạng thái thành công!');
                    $('#deliveryStatusModal').modal('hide');
                    location.reload();
                },
                error: function(xhr, status, error) {
                    alert('Có lỗi xảy ra: ' + xhr.responseText);
                }
            });
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
                    statusId: 9,
                    note: reason
                },
                success: function(response) {
                    alert('Đã cập nhật đơn hàng không thành công!');
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
