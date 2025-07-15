<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shipper Dashboard</title>
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
                            <i class="fas fa-tachometer-alt me-2"></i>
                            Shipper Dashboard
                        </h1>
                        <p class="page-subtitle">Tổng quan về công việc giao hàng</p>
                    </div>
                </div>
            </div>

            <!-- Stats Cards -->
            <div class="row mb-4">
                <div class="col-md-4">
                    <div class="stats-card card border-0 shadow-sm">
                        <div class="card-body">
                            <div class="d-flex align-items-center">
                                <div class="stats-icon bg-warning text-white rounded-circle me-3">
                                    <i class="fas fa-box"></i>
                                </div>
                                <div>
                                    <h5 class="mb-0">${readyToShip}</h5>
                                    <small class="text-muted">Sẵn sàng giao</small>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="stats-card card border-0 shadow-sm">
                        <div class="card-body">
                            <div class="d-flex align-items-center">
                                <div class="stats-icon bg-primary text-white rounded-circle me-3">
                                    <i class="fas fa-truck"></i>
                                </div>
                                <div>
                                    <h5 class="mb-0">${shipping}</h5>
                                    <small class="text-muted">Đang giao</small>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="stats-card card border-0 shadow-sm">
                        <div class="card-body">
                            <div class="d-flex align-items-center">
                                <div class="stats-icon bg-success text-white rounded-circle me-3">
                                    <i class="fas fa-check-circle"></i>
                                </div>
                                <div>
                                    <h5 class="mb-0">${delivered}</h5>
                                    <small class="text-muted">Đã giao</small>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Quick Actions -->
            <div class="row mb-4">
                <div class="col-12">
                    <div class="card border-0 shadow-sm">
                        <div class="card-header bg-light">
                            <h5 class="mb-0">
                                <i class="fas fa-bolt me-2"></i>
                                Thao tác nhanh
                            </h5>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-3 mb-3">
                                    <a href="${pageContext.request.contextPath}/shipper/orders?status=2" class="btn btn-warning btn-lg w-100">
                                        <i class="fas fa-box me-2"></i>
                                        Đơn sẵn sàng giao
                                    </a>
                                </div>
                                <div class="col-md-3 mb-3">
                                    <a href="${pageContext.request.contextPath}/shipper/orders?status=3" class="btn btn-primary btn-lg w-100">
                                        <i class="fas fa-shipping-fast me-2"></i>
                                        Đang giao hàng
                                    </a>
                                </div>
                                <div class="col-md-3 mb-3">
                                    <a href="${pageContext.request.contextPath}/shipper/orders?status=4" class="btn btn-success btn-lg w-100">
                                        <i class="fas fa-check-circle me-2"></i>
                                        Đã giao hàng
                                    </a>
                                </div>
                                <div class="col-md-3 mb-3">
                                    <a href="${pageContext.request.contextPath}/shipper/orders" class="btn btn-info btn-lg w-100">
                                        <i class="fas fa-list me-2"></i>
                                        Tất cả đơn hàng
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Recent Orders -->
            <div class="row">
                <div class="col-12">
                    <div class="card border-0 shadow-sm">
                        <div class="card-header bg-light d-flex justify-content-between align-items-center">
                            <h5 class="mb-0">
                                <i class="fas fa-clock me-2"></i>
                                Đơn hàng gần đây
                            </h5>
                            
                        </div>
                        <div class="card-body">
                            <c:if test="${empty recentOrders}">
                                <div class="text-center py-5">
                                    <i class="fas fa-inbox text-muted" style="font-size: 4rem;"></i>
                                    <h5 class="mt-3 text-muted">Không có đơn hàng nào</h5>
                                    <p class="text-muted">Hiện tại không có đơn hàng nào cần xử lý</p>
                                </div>
                            </c:if>
                            
                            <c:if test="${not empty recentOrders}">
                                <div class="table-responsive">
                                    <table class="table table-hover align-middle">
                                        <thead class="table-light">
                                            <tr>
                                                <th>Mã đơn hàng</th>
                                                <th>Khách hàng</th>
                                                <th>Địa chỉ</th>
                                                <th>Giá trị</th>
                                                <th>Ngày tạo</th>
                                                <th>Trạng thái</th>
                                                <th>Hành động</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${recentOrders}" var="order" varStatus="loop">
                                                <c:if test="${loop.index < 10}">
                                                    <tr>
                                                        <td>
                                                            <strong>#${order.maHD}</strong>
                                                        </td>
                                                        <td>
                                                            <div>
                                                                <div class="fw-bold">${order.customerName}</div>
                                                                <small class="text-muted">${order.customerPhone}</small>
                                                            </div>
                                                        </td>
                                                        <td>
                                                            <small class="text-muted">${order.customerAddress}</small>
                                                        </td>
                                                        <td>
                                                            <strong class="text-primary">
                                                                <fmt:formatNumber value="${order.tongGia}" pattern="#,##0" />đ
                                                            </strong>
                                                        </td>
                                                        <td>
                                                            <fmt:formatDate value="${order.ngayXuat}" pattern="dd/MM/yyyy" />
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${order.statusID == 2}">
                                                                    <span class="badge bg-warning">Sẵn sàng giao</span>
                                                                </c:when>
                                                                <c:when test="${order.statusID == 3}">
                                                                    <span class="badge bg-primary">Đang giao</span>
                                                                </c:when>
                                                                <c:when test="${order.statusID == 4}">
                                                                    <span class="badge bg-success">Đã giao</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge bg-secondary">${order.statusName}</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <div class="btn-group" role="group">
                                                                <button class="btn btn-sm btn-outline-info" onclick="viewOrderDetails('${order.maHD}')" 
                                                                        data-bs-toggle="tooltip" title="Xem chi tiết">
                                                                    <i class="fas fa-eye"></i>
                                                                </button>
                                                                
                                                                <c:if test="${order.statusID == 2 || order.statusID == 9}">
                                                                    <button class="btn btn-sm btn-primary" onclick="updateStatus('${order.maHD}', '3')">
                                                                        <i class="fas fa-truck me-1"></i>
                                                                        Bắt đầu giao
                                                                    </button>
                                                                </c:if>
                                                                <c:if test="${order.statusID == 3}">
                                                                    <button class="btn btn-sm btn-success" onclick="updateStatus('${order.maHD}', '4')">
                                                                        <i class="fas fa-check me-1"></i>
                                                                        Đã giao
                                                                    </button>
                                                                </c:if>
                                                                <c:if test="${order.statusID == 3}">
                                                                    <button class="btn btn-sm btn-danger" onclick="cancelOrder('${order.maHD}')" 
                                                                            data-bs-toggle="tooltip" title="Hủy đơn hàng">
                                                                        <i class="fas fa-times"></i>
                                                                    </button>
                                                                </c:if>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:if>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Mobile Navigation -->
    <script src="${pageContext.request.contextPath}/js/mobile-navigation.js"></script>
    <!-- Shipper Script -->
    <!-- Order Details Modal -->
    <div class="modal fade" id="orderDetailsModal" tabindex="-1" aria-labelledby="orderDetailsModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="orderDetailsModalLabel">
                        <i class="fas fa-info-circle me-2"></i>
                        Chi tiết đơn hàng
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body" id="orderDetailsContent">
                    <!-- Order details will be loaded here -->
                    <div class="text-center">
                        <div class="spinner-border text-primary" role="status">
                            <span class="visually-hidden">Loading...</span>
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

    <!-- Override getContextPath function to ensure correct context path -->
    <script>
        // Override the getContextPath function to ensure it returns the correct path
        window.getContextPath = function() {
            return '/Onlineshop';
        };
        
        // Test the function immediately
        console.log('Context path override:', getContextPath());
    </script>
    
    <script src="${pageContext.request.contextPath}/js/shipper-script.js?v=<%= System.currentTimeMillis() %>"></script>
    <!-- Dashboard Script -->
    <script src="${pageContext.request.contextPath}/js/shipper-dashboard.js?v=<%= System.currentTimeMillis() %>"></script>
</body>
</html>
