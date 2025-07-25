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
    <style>
        .clickable-card {
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .clickable-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0,0,0,0.1) !important;
        }
        .clickable-card.active {
            border: 2px solid #007bff;
            background-color: #f8f9ff;
        }
        .order-row {
            transition: all 0.3s ease;
        }
        .order-row.hidden {
            display: none;
        }
        .btn-group .btn {
            border-radius: 0;
        }
        .btn-group .btn:first-child {
            border-top-left-radius: 0.375rem;
            border-bottom-left-radius: 0.375rem;
        }
        .btn-group .btn:last-child {
            border-top-right-radius: 0.375rem;
            border-bottom-right-radius: 0.375rem;
        }
        
        /* Order Details Modal Styles */
        #orderDetailsModal .modal-dialog {
            max-width: 900px;
        }
        
        #orderDetailsModal .modal-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 0.5rem 0.5rem 0 0;
        }
        
        #orderDetailsModal .modal-header .btn-close {
            filter: invert(1);
        }
        
        #orderDetailsModal .modal-body {
            padding: 0;
            background-color: #f8f9fa;
        }
        
        .order-detail-section {
            background: white;
            margin: 15px;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            border-left: 4px solid #007bff;
        }
        
        .order-detail-section h6 {
            color: #495057;
            font-weight: 600;
            margin-bottom: 15px;
            padding-bottom: 8px;
            border-bottom: 2px solid #e9ecef;
        }
        
        .order-info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 15px;
        }
        
        .info-item {
            display: flex;
            align-items: center;
            padding: 8px;
            background: #f8f9fa;
            border-radius: 5px;
            border-left: 3px solid #28a745;
        }
        
        .info-item i {
            width: 20px;
            color: #6c757d;
            margin-right: 10px;
        }
        
        .info-item .label {
            font-weight: 500;
            color: #495057;
            margin-right: 8px;
        }
        
        .info-item .value {
            color: #212529;
            font-weight: 400;
        }
        
        .status-badge {
            display: inline-flex;
            align-items: center;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.875rem;
            font-weight: 500;
        }
        
        .status-badge i {
            margin-right: 6px;
        }
        
        .order-items-table {
            margin-top: 10px;
        }
        
        .order-items-table th {
            background-color: #e9ecef;
            font-weight: 600;
            border: none;
            padding: 12px;
        }
        
        .order-items-table td {
            padding: 12px;
            vertical-align: middle;
            border-top: 1px solid #dee2e6;
        }
        
        .product-image {
            width: 50px;
            height: 50px;
            object-fit: cover;
            border-radius: 5px;
            border: 2px solid #e9ecef;
        }
        
        .total-section {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            margin: 15px;
            padding: 20px;
            border-radius: 8px;
            text-align: center;
        }
        
        .total-amount {
            font-size: 1.5rem;
            font-weight: 700;
            margin-top: 5px;
        }
        
        .loading-spinner {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 200px;
            flex-direction: column;
        }
        
        .loading-spinner .spinner-border {
            width: 3rem;
            height: 3rem;
        }
        
        .error-state {
            text-align: center;
            padding: 40px 20px;
            color: #dc3545;
        }
        
        .error-state i {
            font-size: 4rem;
            margin-bottom: 20px;
            opacity: 0.7;
        }
        
        @media (max-width: 768px) {
            #orderDetailsModal .modal-dialog {
                margin: 10px;
                max-width: calc(100% - 20px);
            }
            
            .order-info-grid {
                grid-template-columns: 1fr;
            }
            
            .info-item {
                flex-direction: column;
                align-items: flex-start;
                text-align: left;
            }
            
            .info-item i {
                margin-bottom: 5px;
            }
        }
    </style>
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
                <div class="col-md-3">
                    <div class="stats-card card border-0 shadow-sm clickable-card" onclick="filterOrders(2)" data-status="2">
                        <div class="card-body">
                            <div class="d-flex align-items-center">
                                <div class="stats-icon bg-info text-white rounded-circle me-3">
                                    <i class="fas fa-clipboard-check"></i>
                                </div>
                                <div>
                                    <h5 class="mb-0">${approvedOrders}</h5>
                                    <small class="text-muted">Đã duyệt</small>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stats-card card border-0 shadow-sm clickable-card" onclick="filterOrders(3)" data-status="3">
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
                <div class="col-md-3">
                    <div class="stats-card card border-0 shadow-sm clickable-card" onclick="filterOrders(4)" data-status="4">
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
                <div class="col-md-3">
                    <div class="stats-card card border-0 shadow-sm clickable-card" onclick="filterOrders(9)" data-status="9">
                        <div class="card-body">
                            <div class="d-flex align-items-center">
                                <div class="stats-icon bg-danger text-white rounded-circle me-3">
                                    <i class="fas fa-times-circle"></i>
                                </div>
                                <div>
                                    <h5 class="mb-0">${cancelled}</h5>
                                    <small class="text-muted">Không thành công</small>
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
                                <span id="orderListTitle">Đơn hàng gần đây</span>
                            </h5>
                            <div class="btn-group" role="group">
                                <button type="button" class="btn btn-outline-secondary btn-sm active" onclick="filterOrders('all')" id="btnAll">
                                    <i class="fas fa-list me-1"></i>Tất cả
                                </button>
                                <button type="button" class="btn btn-outline-info btn-sm" onclick="filterOrders(2)" id="btn2">
                                    <i class="fas fa-clipboard-check me-1"></i>Đã duyệt
                                </button>
                                <button type="button" class="btn btn-outline-primary btn-sm" onclick="filterOrders(3)" id="btn3">
                                    <i class="fas fa-truck me-1"></i>Đang giao
                                </button>
                                <button type="button" class="btn btn-outline-success btn-sm" onclick="filterOrders(4)" id="btn4">
                                    <i class="fas fa-check-circle me-1"></i>Đã giao
                                </button>
                                <button type="button" class="btn btn-outline-danger btn-sm" onclick="filterOrders(9)" id="btn9">
                                    <i class="fas fa-times-circle me-1"></i>Không thành công
                                </button>
                            </div>
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
                                                <th>Thanh Toán</th>
                                                <th>Ngày tạo</th>
                                                <th>Trạng thái</th>
                                                <th>Hành động</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${recentOrders}" var="order" varStatus="loop">
                                                <c:if test="${loop.index < 10}">
                                                    <tr class="order-row" data-status="${order.statusID}">
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
                                                            <small class="text-muted">${order.paymentMethod}</small>
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
                                                                
                                                                <c:if test="${order.statusID == 2}">
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
                         Giao hàng không thành công                   
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p>Bạn có chắc chắn đơn hàng này không được giao thành công không?</p>
                    <div class="mb-3">
                        <label for="cancelReason" class="form-label">Lý do Giao hàng không thành công:</label>
                        <textarea class="form-control" id="cancelReason" rows="3" placeholder="Vui lòng nhập lý do Giao hàng không thành công đơn hàng..." required></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="button" class="btn btn-danger" onclick="confirmCancel()">Xác nhận hủy</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Confirm Action Modal -->
    <div class="modal fade" id="confirmActionModal" tabindex="-1" aria-labelledby="confirmActionModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="confirmActionModalLabel">
                        <i class="fas fa-question-circle me-2"></i>
                        Xác nhận hành động
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="text-center mb-3">
                        <i id="confirmIcon" class="fas fa-truck text-primary" style="font-size: 3rem;"></i>
                    </div>
                    <p id="confirmMessage" class="text-center mb-0">Bạn có chắc chắn muốn thực hiện hành động này?</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="button" class="btn btn-primary" id="confirmActionBtn" onclick="executeConfirmedAction()">Xác nhận</button>
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
    
    <!-- Simple Filter Script -->
    <script>
        let currentFilter = 'all';
        
        function filterOrders(status) {
            currentFilter = status;
            
            // Update button active state
            document.querySelectorAll('.btn-group .btn').forEach(btn => {
                btn.classList.remove('active');
            });
            
            if (status === 'all') {
                document.getElementById('btnAll').classList.add('active');
                document.getElementById('orderListTitle').textContent = 'Tất cả đơn hàng';
            } else {
                document.getElementById('btn' + status).classList.add('active');
                const statusNames = {
                    2: 'Đơn hàng đã duyệt',
                    3: 'Đơn hàng đang giao',
                    4: 'Đơn hàng đã giao',
                    9: 'Giao hàng không thành công'
                };
                document.getElementById('orderListTitle').textContent = statusNames[status];
            }
            
            // Update stats card active state
            document.querySelectorAll('.clickable-card').forEach(card => {
                card.classList.remove('active');
            });
            
            if (status !== 'all') {
                const activeCard = document.querySelector('[data-status="' + status + '"]');
                if (activeCard) {
                    activeCard.classList.add('active');
                }
            }
            
            // Filter table rows
            const rows = document.querySelectorAll('.order-row');
            let visibleCount = 0;
            
            rows.forEach(row => {
                const rowStatus = row.getAttribute('data-status');
                if (status === 'all' || rowStatus == status) {
                    row.style.display = '';
                    visibleCount++;
                } else {
                    row.style.display = 'none';
                }
            });
            
            // Show/hide empty state
            const emptyState = document.querySelector('.text-center.py-5');
            const tableContainer = document.querySelector('.table-responsive');
            
            if (visibleCount === 0) {
                if (tableContainer) tableContainer.style.display = 'none';
                if (emptyState) {
                    emptyState.style.display = 'block';
                    
                    // Update empty state message based on filter
                    const emptyMessages = {
                        'all': {
                            title: 'Không có đơn hàng nào',
                            subtitle: 'Hiện tại không có đơn hàng nào cần xử lý',
                            icon: 'fas fa-inbox'
                        },
                        2: {
                            title: 'Không có đơn hàng đã duyệt',
                            subtitle: 'Hiện tại không có đơn hàng nào ở trạng thái "Đã duyệt"',
                            icon: 'fas fa-clipboard-check'
                        },
                        3: {
                            title: 'Không có đơn hàng đang giao',
                            subtitle: 'Hiện tại không có đơn hàng nào ở trạng thái "Đang giao"',
                            icon: 'fas fa-truck'
                        },
                        4: {
                            title: 'Không có đơn hàng đã giao',
                            subtitle: 'Hiện tại không có đơn hàng nào ở trạng thái "Đã giao"',
                            icon: 'fas fa-check-circle'
                        },
                        9: {
                            title: 'Giao hàng không thành công',
                            subtitle: 'Hiện tại không có đơn hàng nào ở trạng thái "Giao hàng không thành công"',
                            icon: 'fas fa-times-circle'
                        }
                    };
                    
                    const message = emptyMessages[status] || emptyMessages['all'];
                    const iconElement = emptyState.querySelector('i');
                    const titleElement = emptyState.querySelector('h5');
                    const subtitleElement = emptyState.querySelector('p');
                    
                    if (iconElement) iconElement.className = message.icon + ' text-muted';
                    if (titleElement) titleElement.textContent = message.title;
                    if (subtitleElement) subtitleElement.textContent = message.subtitle;
                }
            } else {
                if (tableContainer) tableContainer.style.display = 'block';
                if (emptyState) emptyState.style.display = 'none';
            }
        }
        
        // Initialize on page load
        document.addEventListener('DOMContentLoaded', function() {
            filterOrders('all');
        });
    </script>
</body>
</html>