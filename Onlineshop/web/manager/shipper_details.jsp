<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:useBean id="now" class="java.util.Date"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết Shipper</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/css/manager.css" rel="stylesheet">
    <style>
        .profile-header {
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 20px;
        }
        .profile-img {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            object-fit: cover;
            border: 5px solid #fff;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .detail-card {
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            margin-bottom: 20px;
            transition: all 0.3s ease;
        }
        .detail-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 15px rgba(0,0,0,0.1);
        }
        .status-badge {
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
        }
        .status-active {
            background-color: #d4edda;
            color: #155724;
        }
        .status-inactive {
            background-color: #f8d7da;
            color: #721c24;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar và Topbar -->
            <jsp:include page="../manager_topbarsidebar.jsp" />
            
            <!-- Main Content -->
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">Chi tiết Shipper</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <a href="${pageContext.request.contextPath}/manager/shipper" class="btn btn-sm btn-outline-secondary">
                            <i class="fas fa-arrow-left"></i> Quay lại
                        </a>
                    </div>
                </div>
                
                <!-- Thông báo lỗi hoặc thành công -->
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger" role="alert">
                        ${errorMessage}
                    </div>
                </c:if>
                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success" role="alert">
                        ${successMessage}
                    </div>
                </c:if>
                
                <!-- Thông tin chính -->
                <div class="profile-header d-flex align-items-center">
                    <div class="me-4">
                        <img src="${pageContext.request.contextPath}/images/default-avatar.png" alt="Avatar" class="profile-img">
                    </div>
                    <div>
                        <h2>${shipper.username}</h2>
                        <p class="text-muted mb-1"><i class="fas fa-envelope me-2"></i>${shipper.email}</p>
                        <p class="text-muted mb-1"><i class="fas fa-phone me-2"></i>${shipper.phone}</p>
                        <span class="status-badge ${shipper.active ? 'status-active' : 'status-inactive'}">
                            ${shipper.active ? 'Đang hoạt động' : 'Không hoạt động'}
                        </span>
                    </div>
                </div>
                
                <div class="row">
                    <!-- Thông tin cá nhân -->
                    <div class="col-md-6 mb-4">
                        <div class="card detail-card h-100">
                            <div class="card-header bg-primary text-white">
                                <h5 class="card-title mb-0"><i class="fas fa-user me-2"></i>Thông tin cá nhân</h5>
                            </div>
                            <div class="card-body">
                                <ul class="list-group list-group-flush">
                                    <li class="list-group-item d-flex justify-content-between align-items-center">
                                        ID:
                                        <span class="badge bg-primary rounded-pill">${shipper.shipperID}</span>
                                    </li>
                                    <li class="list-group-item d-flex justify-content-between align-items-center">
                                        Tên đăng nhập:
                                        <span>${shipper.username}</span>
                                    </li>
                                    <li class="list-group-item d-flex justify-content-between align-items-center">
                                        Email:
                                        <span>${shipper.email}</span>
                                    </li>
                                    <li class="list-group-item d-flex justify-content-between align-items-center">
                                        Số điện thoại:
                                        <span>${shipper.phone}</span>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Thông tin công việc -->
                    <div class="col-md-6 mb-4">
                        <div class="card detail-card h-100">
                            <div class="card-header bg-success text-white">
                                <h5 class="card-title mb-0"><i class="fas fa-briefcase me-2"></i>Thông tin công việc</h5>
                            </div>
                            <div class="card-body">
                                <ul class="list-group list-group-flush">
                                    <li class="list-group-item d-flex justify-content-between align-items-center">
                                        Ngày bắt đầu:
                                        <span><fmt:formatDate value="${shipper.startDate}" pattern="dd/MM/yyyy" /></span>
                                    </li>
                                    <li class="list-group-item d-flex justify-content-between align-items-center">
                                        Ngày kết thúc:
                                        <span>
                                            <c:choose>
                                                <c:when test="${shipper.endDate != null}">
                                                    <fmt:formatDate value="${shipper.endDate}" pattern="dd/MM/yyyy" />
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">Chưa xác định</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </span>
                                    </li>
                                    <li class="list-group-item d-flex justify-content-between align-items-center">
                                        Trạng thái:
                                        <span class="status-badge ${shipper.active ? 'status-active' : 'status-inactive'}">
                                            ${shipper.active ? 'Đang hoạt động' : 'Không hoạt động'}
                                        </span>
                                    </li>
                                    <li class="list-group-item d-flex justify-content-between align-items-center">
                                        Thời gian làm việc:
                                        <span>
                                            <c:choose>
                                                <c:when test="${shipper.endDate != null}">
                                                    <c:set var="startMillis" value="${shipper.startDate.time}" />
                                                    <c:set var="endMillis" value="${shipper.endDate.time}" />
                                                    <c:set var="diff" value="${endMillis - startMillis}" />
                                                    <c:set var="diffDays" value="${diff / (24 * 60 * 60 * 1000)}" />
                                                    ${diffDays} ngày
                                                </c:when>
                                                <c:otherwise>
                                                    <c:set var="startMillis" value="${shipper.startDate.time}" />
                                                    <c:set var="nowMillis" value="${now.time}" />
                                                    <c:set var="diff" value="${nowMillis - startMillis}" />
                                                    <c:set var="diffDays" value="${diff / (24 * 60 * 60 * 1000)}" />
                                                    ${diffDays} ngày (đang làm việc)
                                                </c:otherwise>
                                            </c:choose>
                                        </span>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Thông tin lương -->
                    <div class="col-md-6 mb-4">
                        <div class="card detail-card h-100">
                            <div class="card-header bg-info text-white">
                                <h5 class="card-title mb-0"><i class="fas fa-money-bill-wave me-2"></i>Thông tin lương</h5>
                            </div>
                            <div class="card-body">
                                <ul class="list-group list-group-flush">
                                    <li class="list-group-item d-flex justify-content-between align-items-center">
                                        Lương cơ bản:
                                        <span><fmt:formatNumber value="${shipper.baseSalary}" type="currency" currencySymbol="₫" /></span>
                                    </li>
                                    <li class="list-group-item d-flex justify-content-between align-items-center">
                                        Thưởng mỗi đơn:
                                        <span><fmt:formatNumber value="${shipper.bonusPerOrder}" type="currency" currencySymbol="₫" /></span>
                                    </li>
                                    <li class="list-group-item d-flex justify-content-between align-items-center">
                                        Đơn hàng đã giao:
                                        <span class="badge bg-info rounded-pill">${shipper.ordersDelivered}</span>
                                    </li>
                                    <li class="list-group-item d-flex justify-content-between align-items-center">
                                        Tổng thưởng:
                                        <span><fmt:formatNumber value="${shipper.ordersDelivered * shipper.bonusPerOrder}" type="currency" currencySymbol="₫" /></span>
                                    </li>
                                    <li class="list-group-item d-flex justify-content-between align-items-center fw-bold">
                                        Tổng lương:
                                        <span><fmt:formatNumber value="${totalSalary}" type="currency" currencySymbol="₫" /></span>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Thống kê đơn hàng -->
                    <div class="col-md-6 mb-4">
                        <div class="card detail-card h-100">
                            <div class="card-header bg-warning text-dark">
                                <h5 class="card-title mb-0"><i class="fas fa-chart-line me-2"></i>Thống kê đơn hàng</h5>
                            </div>
                            <div class="card-body">
                                <div class="text-center mb-4">
                                    <h1 class="display-4">${shipper.ordersDelivered}</h1>
                                    <p class="text-muted">Tổng số đơn hàng đã giao</p>
                                </div>
                                
                                <!-- Đây là nơi bạn có thể thêm biểu đồ thống kê nếu cần -->
                                <div class="progress mb-3" style="height: 25px;">
                                    <div class="progress-bar bg-success" role="progressbar" style="width: ${shipper.ordersDelivered > 0 ? 100 : 0}%;" 
                                         aria-valuenow="${shipper.ordersDelivered}" aria-valuemin="0" aria-valuemax="100">
                                        ${shipper.ordersDelivered} đơn
                                    </div>
                                </div>
                                
                                <div class="text-center mt-3">
                                    <a href="#" class="btn btn-outline-warning">
                                        <i class="fas fa-list"></i> Xem chi tiết đơn hàng
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Nút quay lại ở cuối trang -->
                <div class="row mb-4">
                    <div class="col-12 text-center">
                        <a href="${pageContext.request.contextPath}/manager/shipper" class="btn btn-primary">
                            <i class="fas fa-arrow-left"></i> Quay lại danh sách Shipper
                        </a>
                    </div>
                </div>
            </main>
        </div>
    </div>
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Custom JS -->
    <script src="${pageContext.request.contextPath}/js/manager.js"></script>
</body>
</html>
