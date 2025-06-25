<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="Model.Account" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết Đơn hàng - Admin</title>
    <!-- Bootstrap CSS -->
    <link href="${pageContext.request.contextPath}/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/css/admin.css" rel="stylesheet">
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        .order-info-card {
            margin-bottom: 20px;
        }
        .order-info-card .card-header {
            background-color: #f8f9fa;
            font-weight: bold;
        }
        .status-badge {
            padding: 5px 10px;
            border-radius: 20px;
            font-weight: 500;
            font-size: 0.85rem;
        }
        .status-pending {
            background-color: #ffeeba;
            color: #856404;
        }
        .status-completed {
            background-color: #d4edda;
            color: #155724;
        }
        .status-cancelled {
            background-color: #f8d7da;
            color: #721c24;
        }
        .product-img {
            width: 60px;
            height: 60px;
            object-fit: cover;
        }
        .action-buttons {
            margin-top: 20px;
        }
.product-img {
    width: 60px;
    height: 60px;
    object-fit: cover;
    border-radius: 4px;
    border: 1px solid #dee2e6;
}

.text-muted {
    color: #6c757d !important;
    font-style: italic;
}

.table-warning {
    background-color: #fff3cd;
}

.error-message {
    background-color: #f8d7da;
    color: #721c24;
    padding: 10px;
    border-radius: 4px;
    margin-bottom: 20px;
}
    </style>
</head>
<body>
    <!-- Topbar -->
    <nav class="navbar navbar-expand-lg topbar">
        <div class="container-fluid px-4">
            <a class="topbar-brand" href="#">Bán Hoa Admin</a>

            <div class="d-flex align-items-center">
                <div class="dropdown">
                    <a class="dropdown-toggle d-flex align-items-center hidden-arrow" href="#" role="button" id="navbarDropdownMenuAvatar" data-bs-toggle="dropdown" aria-expanded="false">
                        <i class="fas fa-user-circle fa-lg"></i>
                        <span class="ms-2">${sessionScope.account.fullName}</span>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="navbarDropdownMenuAvatar">
                        <li>
                            <a class="dropdown-item" href="${pageContext.request.contextPath}/profile">Hồ sơ của tôi</a>
                        </li>
                        <li>
                            <a class="dropdown-item" href="#" data-bs-toggle="modal" data-bs-target="#logoutModal">Đăng xuất</a>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </nav>

    <!-- Sidebar & Content -->
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <nav class="col-md-3 col-lg-2 d-md-block sidebar">
                <ul class="nav flex-column">
                    <li>
                        <a href="${pageContext.request.contextPath}/admin" class="nav-link">
                            <i class="fas fa-tachometer-alt"></i>
                            <span>Dashboard</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/products" class="nav-link">
                            <i class="fas fa-flower"></i>
                            <span>Quản lý Sản phẩm</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/categories" class="nav-link">
                            <i class="fas fa-list"></i>
                            <span>Danh mục Sản phẩm</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/orders" class="nav-link active">
                            <i class="fas fa-shopping-cart"></i>
                            <span>Quản lý Đơn hàng</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/customers" class="nav-link">
                            <i class="fas fa-users"></i>
                            <span>Quản lý Người Dùng</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/staff" class="nav-link">
                            <i class="fas fa-user-tie"></i>
                            <span>Quản lý Nhân viên</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/vouchers" class="nav-link">
                            <i class="fas fa-percent"></i>
                            <span>Khuyến mãi</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/blogs" class="nav-link">
                            <i class="fas fa-blog"></i>
                            <span>Quản lý Blog</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/reports" class="nav-link">
                            <i class="fas fa-chart-bar"></i>
                            <span>Báo cáo & Thống kê</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/settings" class="nav-link">
                            <i class="fas fa-cog"></i>
                            <span>Cài đặt Hệ thống</span>
                        </a>
                    </li>
                </ul>
            </nav>

            <!-- Main Content -->
            <!-- Thêm vào đầu main content -->
<c:if test="${errorMessage != null}">
    <div class="alert alert-danger error-message" role="alert">
        <i class="fas fa-exclamation-triangle"></i> ${errorMessage}
    </div>
</c:if>
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 py-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">Chi tiết Đơn hàng #${order.orderId}</h1>
                    <a href="${pageContext.request.contextPath}/orders" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Quay lại
                    </a>
                </div>

                <!-- Thông tin đơn hàng -->
                <div class="row">
                    
<c:if test="${order.processedBy != null}">
    <p><strong>Người xử lý:</strong> ${order.processedBy}</p>
</c:if>
                    <!-- Thông tin chung -->
                    <div class="col-md-6">
                        <div class="card order-info-card">
                            <div class="card-header">Thông tin đơn hàng</div>
                            <div class="card-body">
                                <p><strong>Mã đơn hàng:</strong> #${order.orderId}</p>
                                <!-- Trong phần thông tin đơn hàng, sau dòng ngày đặt -->
<p><strong>Ngày đặt:</strong> <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm" /></p>
<!-- Thêm các dòng này -->
<c:if test="${order.updatedDate != null}">
    <p><strong>Ngày cập nhật:</strong> <fmt:formatDate value="${order.updatedDate}" pattern="dd/MM/yyyy HH:mm" /></p>
</c:if>
<c:if test="${order.deliveryDate != null}">
    <p><strong>Ngày giao hàng:</strong> <fmt:formatDate value="${order.deliveryDate}" pattern="dd/MM/yyyy HH:mm" /></p>
</c:if>
                                <p>
                                    <strong>Trạng thái:</strong> 
                                    <c:choose>
                                        <c:when test="${order.status eq 'Pending'}">
                                            <span class="status-badge status-pending">Đang xử lý</span>
                                        </c:when>
                                        <c:when test="${order.status eq 'Completed'}">
                                            <span class="status-badge status-completed">Hoàn thành</span>
                                        </c:when>
                                        <c:when test="${order.status eq 'Cancelled'}">
                                            <span class="status-badge status-cancelled">Đã hủy</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-badge">${order.status}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </p>
                                <p><strong>Phương thức thanh toán:</strong> ${order.paymentMethod}</p>
                                
<c:if test="${order.notes != null && !empty order.notes}">
    <p><strong>Ghi chú:</strong> ${order.notes}</p>
</c:if>
                                <p><strong>Tổng tiền:</strong> <fmt:formatNumber value="${order.total}" type="currency" currencySymbol="đ" maxFractionDigits="0"/></p>
                            </div>
                        </div>
                    </div>

                    <!-- Thông tin khách hàng -->
                    <!-- Thêm một card mới sau phần thông tin khách hàng -->
<div class="col-md-12 mt-3">
    <div class="card order-info-card">
        <div class="card-header">Lịch sử đơn hàng</div>
        <div class="card-body">
            <div class="timeline">
                <div class="timeline-item">
                    <div class="timeline-marker bg-primary"></div>
                    <div class="timeline-content">
                        <h6 class="timeline-title">Đơn hàng được tạo</h6>
                        <p class="timeline-description">
                            <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm" />
                        </p>
                    </div>
                </div>
                <c:if test="${order.status eq 'Completed'}">
                    <div class="timeline-item">
                        <div class="timeline-marker bg-success"></div>
                        <div class="timeline-content">
                            <h6 class="timeline-title">Đơn hàng hoàn thành</h6>
                            <p class="timeline-description">
                                <fmt:formatDate value="${order.completedDate}" pattern="dd/MM/yyyy HH:mm" />
                            </p>
                        </div>
                    </div>
                </c:if>
            </div>
        </div>
    </div>
</div>
                    <div class="col-md-6">
                        <div class="card order-info-card">
                            <div class="card-header">Thông tin khách hàng</div>
                            <div class="card-body">
                                <p><strong>Họ tên:</strong> ${order.fullName}</p>
                                <p><strong>Email:</strong> ${order.email}</p>
                                <p><strong>Số điện thoại:</strong> ${order.phone}</p>
                                <p><strong>Địa chỉ giao hàng:</strong></p>
<div class="ms-3">
    <p class="mb-1">${order.fullName}</p>
    <p class="mb-1">${order.phone}</p>
    <p class="mb-0">${order.address}</p>
</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Chi tiết sản phẩm -->
                <div class="card mt-4">
                    <div class="card-header">Chi tiết sản phẩm</div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-striped">
                                <thead>
                                    <tr>
                                        <th>Sản phẩm</th>
                                        <th>Tên sản phẩm</th>
                                        <th>Đơn giá</th>
                                        <th>Số lượng</th>
                                        <th>Thành tiền</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <!-- Trong phần hiển thị sản phẩm -->
<c:forEach items="${orderDetails}" var="detail">
    <tr>
        <td>
            <c:choose>
                <c:when test="${detail.product.image != null && !empty detail.product.image}">
                    <img src="${pageContext.request.contextPath}${detail.product.image}" 
                         alt="${detail.product.title}" 
                         class="product-img"
                         onerror="this.src='${pageContext.request.contextPath}/img/no-image.jpg'">
                </c:when>
                <c:otherwise>
                    <img src="${pageContext.request.contextPath}/img/no-image.jpg" 
                         alt="Không có hình ảnh" 
                         class="product-img">
                </c:otherwise>
            </c:choose>
        </td>
        <td>
            <c:choose>
                <c:when test="${detail.product.title != null && !empty detail.product.title}">
                    ${detail.product.title}
                </c:when>
                <c:otherwise>
                    <span class="text-muted">Sản phẩm không xác định (ID: ${detail.productId})</span>
                </c:otherwise>
            </c:choose>
        </td>
        <td><fmt:formatNumber value="${detail.price}" type="currency" currencySymbol="đ" maxFractionDigits="0"/></td>
        <td>${detail.quantity}</td>
        <td><fmt:formatNumber value="${detail.total}" type="currency" currencySymbol="đ" maxFractionDigits="0"/></td>
    </tr>
</c:forEach>
                                </tbody>
                                <tfoot>
    <tr>
        <td colspan="4" class="text-end"><strong>Tổng tiền sản phẩm:</strong></td>
        <td>
            <c:choose>
                <c:when test="${subtotal != null}">
                    <fmt:formatNumber value="${subtotal}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                </c:when>
                <c:otherwise>
                    <fmt:formatNumber value="${order.total - (shippingFee != null ? shippingFee : 30000)}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                </c:otherwise>
            </c:choose>
        </td>
    </tr>
    <tr>
        <td colspan="4" class="text-end"><strong>Phí vận chuyển:</strong></td>
        <td>
            <fmt:formatNumber value="${shippingFee != null ? shippingFee : 30000}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
        </td>
    </tr>
    <tr class="table-warning">
        <td colspan="4" class="text-end"><strong>Tổng thanh toán:</strong></td>
        <td><strong><fmt:formatNumber value="${order.total}" type="currency" currencySymbol="đ" maxFractionDigits="0"/></strong></td>
    </tr>
</tfoot>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Các nút thao tác -->
                <div class="action-buttons">
                    <c:if test="${order.status eq 'Pending'}">
                        <button class="btn btn-success" onclick="updateStatus(${order.orderId}, 2)">
                            <i class="fas fa-check"></i> Xác nhận hoàn thành
                        </button>
                        <button class="btn btn-warning" onclick="updateStatus(${order.orderId}, 3)">
                            <i class="fas fa-times"></i> Hủy đơn hàng
                        </button>
                    </c:if>
                    <button class="btn btn-danger" onclick="confirmDelete(${order.orderId})">
                        <i class="fas fa-trash"></i> Xóa đơn hàng
                    </button>
                    <button class="btn btn-info" onclick="printOrder()">
                        <i class="fas fa-print"></i> In đơn hàng
                    </button>
                </div>
            </main>
        </div>
    </div>

    <!-- Modal xác nhận xóa -->
    <div class="modal fade" id="deleteModal" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="deleteModalLabel">Xác nhận xóa</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    Bạn có chắc chắn muốn xóa đơn hàng #${order.orderId} không? Hành động này không thể hoàn tác.
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="button" class="btn btn-danger" id="confirmDeleteBtn">Xóa</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal đăng xuất -->
    <div class="modal fade" id="logoutModal" tabindex="-1" aria-labelledby="logoutModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content admin-modal">
                <div class="modal-header bg-danger text-white">
                    <h5 class="modal-title" id="logoutModalLabel">
                        <i class="fas fa-sign-out-alt me-2"></i>Xác nhận đăng xuất
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p>Bạn có chắc chắn muốn đăng xuất khỏi hệ thống?</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <a href="${pageContext.request.contextPath}/logout" class="btn btn-danger">Đăng xuất</a>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Hàm cập nhật trạng thái đơn hàng
        function updateStatus(orderId, statusId) {
            if (confirm('Bạn có chắc chắn muốn cập nhật trạng thái đơn hàng này?')) {
                $.ajax({
                    url: '${pageContext.request.contextPath}/orders',
                    type: 'POST',
                    data: {
                        action: 'update',
                        orderId: orderId,
                        statusId: statusId
                    },
                    success: function(response) {
                        if (response.success) {
                            alert(response.message);
                            location.reload();
                        } else {
                            alert(response.message);
                        }
                    },
                    error: function() {
                        alert('Đã xảy ra lỗi khi cập nhật trạng thái đơn hàng.');
                    }
                });
            }
        }
        
        // Hàm xác nhận xóa đơn hàng
        function confirmDelete(orderId) {
            $('#deleteModal').modal('show');
        }
        
        // Hàm in đơn hàng
        function printOrder() {
            window.print();
        }
        
        // Xử lý sự kiện khi nhấn nút xác nhận xóa trong modal
        $(document).ready(function() {
            $('#confirmDeleteBtn').click(function() {
                $.ajax({
                    url: '${pageContext.request.contextPath}/orders',
                    type: 'POST',
                    data: {
                        action: 'delete',
                        orderId: ${order.orderId}
                    },
                    success: function(response) {
                        $('#deleteModal').modal('hide');
                        if (response.success) {
                            alert(response.message);
                            window.location.href = '${pageContext.request.contextPath}/orders';
                        } else {
                            alert(response.message);
                        }
                    },
                    error: function() {
                        $('#deleteModal').modal('hide');
                        alert('Đã xảy ra lỗi khi xóa đơn hàng.');
                    }
                });
            });
        });
    </script>
</body>
</html>