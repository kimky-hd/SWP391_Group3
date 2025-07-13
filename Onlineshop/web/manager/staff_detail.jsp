<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết Nhân viên</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<style>
    body {
        margin: 0;
        padding: 0;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        background-color: #f8f9fa;
    }

    .topbar {
        position: fixed;
        top: 0;
        left: 0;
        right: 0;
        height: 60px;
        background: white;
        border-bottom: 1px solid #e3e6f0;
        z-index: 1001;
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }

    .main-content {
        margin-left: 250px;
        margin-top: 80px;
        padding: 30px;
        min-height: calc(100vh - 60px);
        background-color: #f8f9fa;
    }

    .card {
        border: none;
        border-radius: 15px;
        box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15);
        margin-bottom: 2rem;
    }

    .card-header {
        background: linear-gradient(45deg, #007bff, #0056b3);
        color: white;
        border-bottom: 1px solid #e3e6f0;
        border-radius: 15px 15px 0 0 !important;
        padding: 1.5rem;
        font-weight: 600;
    }

    .card-body {
        padding: 2rem;
    }

    .info-section {
        margin-bottom: 2rem;
    }

    .section-title {
        font-size: 1.25rem;
        font-weight: 600;
        color: #495057;
        margin-bottom: 1rem;
        padding-bottom: 0.5rem;
        border-bottom: 2px solid #e9ecef;
    }

    .info-row {
        display: flex;
        margin-bottom: 1rem;
        padding: 0.75rem;
        border-radius: 8px;
        transition: background-color 0.2s ease;
    }

    .info-row:hover {
        background-color: #f8f9fc;
    }

    .info-label {
        font-weight: 600;
        color: #495057;
        min-width: 180px;
        display: flex;
        align-items: center;
    }

    .info-label i {
        margin-right: 8px;
        width: 20px;
        text-align: center;
        color: #007bff;
    }

    .info-value {
        color: #212529;
        flex: 1;
        word-break: break-word;
    }

    /* Đơn giản hóa trạng thái */
    .status-badge {
        padding: 0.5rem 1rem;
        border-radius: 5px;
        font-size: 0.9rem;
        font-weight: 600;
        display: inline-block;
    }

    /* Trạng thái tài khoản */
    .status-active {
        background-color: #28a745;
        color: white;
    }

    .status-inactive {
        background-color: #dc3545;
        color: white;
    }

    /* Trạng thái làm việc */
    .status-working {
        background-color: #17a2b8;
        color: white;
    }

    .status-finished {
        background-color: #6c757d;
        color: white;
    }

    .status-pending {
        background-color: #ffc107;
        color: #212529;
    }

    .salary-display {
        font-size: 1.25rem;
        font-weight: bold;
        color: #28a745;
    }

    .date-display {
        font-weight: 500;
        color: #495057;
    }

    .avatar-section {
        text-align: center;
        margin-bottom: 2rem;
    }

    .avatar-circle {
        width: 120px;
        height: 120px;
        border-radius: 50%;
        background: linear-gradient(45deg, #007bff, #0056b3);
        display: inline-flex;
        align-items: center;
        justify-content: center;
        color: white;
        font-weight: bold;
        font-size: 3rem;
        margin-bottom: 1rem;
        box-shadow: 0 4px 8px rgba(0,0,0,0.1);
    }

    .avatar-name {
        font-size: 1.5rem;
        font-weight: 600;
        color: #495057;
        margin-bottom: 0.5rem;
    }

    .avatar-role {
        color: #6c757d;
        font-size: 1rem;
    }

    .btn {
        border-radius: 8px;
        font-weight: 500;
        padding: 0.75rem 1.5rem;
        transition: all 0.3s ease;
    }

    .btn-secondary {
        background: linear-gradient(45deg, #6c757d, #495057);
        border: none;
    }

    .btn-secondary:hover {
        transform: translateY(-2px);
        box-shadow: 0 5px 15px rgba(108, 117, 125, 0.4);
    }

    .action-buttons {
        text-align: center;
        padding-top: 1rem;
        border-top: 1px solid #e9ecef;
        margin-top: 2rem;
    }

    .action-buttons .btn {
        margin: 0 0.5rem;
    }

    .contract-info {
        background: linear-gradient(45deg, #f8f9fc, #e9ecef);
        border-radius: 10px;
        padding: 1.5rem;
        margin-top: 1rem;
    }

    .contract-status {
        text-align: center;
        margin-bottom: 1rem;
    }

    .no-data {
        text-align: center;
        color: #6c757d;
        font-style: italic;
        padding: 1rem;
        background-color: #f8f9fa;
        border-radius: 8px;
    }

    @media (max-width: 768px) {
        .main-content {
            margin-left: 0;
            padding: 15px;
            margin-top: 60px;
        }

        .card-body {
            padding: 1rem;
        }

        .info-row {
            flex-direction: column;
        }

        .info-label {
            min-width: auto;
            margin-bottom: 0.25rem;
        }

        .avatar-circle {
            width: 80px;
            height: 80px;
            font-size: 2rem;
        }

        .avatar-name {
            font-size: 1.25rem;
        }

        .action-buttons .btn {
            margin: 0.25rem;
            display: block;
            width: 100%;
        }

        .status-badge {
            font-size: 0.8rem;
            padding: 0.5rem 1rem;
        }
    }
</style>


<body>
    <jsp:include page="../manager_topbarsidebar.jsp" />

    <!-- Main Content -->
    <main class="main-content">
        <div class="container-fluid">
            <!-- Header -->
            <div class="d-sm-flex align-items-center justify-content-between mb-4">
                <div>
                    <h1 class="h3 mb-0 text-gray-800">
                        <i class="fas fa-user-tie me-2"></i>Chi tiết Nhân viên
                    </h1>
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item">
                                <a href="${pageContext.request.contextPath}/manager/staff">Quản lý Nhân viên</a>
                            </li>
                            <li class="breadcrumb-item active">Chi tiết</li>
                        </ol>
                    </nav>
                </div>
            </div>

            <!-- Thông báo -->
            <c:if test="${not empty param.message}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle me-2"></i>${param.message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${not empty message}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle me-2"></i>${message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${not empty param.error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-circle me-2"></i>${param.error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-circle me-2"></i>${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <!-- Nội dung chi tiết nhân viên -->
            <c:choose>
                <c:when test="${not empty staff}">
                    <div class="row">
                        <!-- Thông tin cơ bản -->
                        <div class="col-lg-4">
                            <div class="card">
                                <div class="card-header text-center">
                                    <h5 class="mb-0">
                                        <i class="fas fa-user me-2"></i>Thông tin cá nhân
                                    </h5>
                                </div>
                                <div class="card-body">
                                    <div class="avatar-section">
                                        <div class="avatar-circle">
                                            ${fn:substring(staff.username, 0, 1).toUpperCase()}
                                        </div>
                                        <div class="avatar-name">${staff.username}</div>
                                        <div class="avatar-role">Nhân viên</div>
                                    </div>

                                    <div class="info-section">
                                        <div class="info-row">
                                            <div class="info-label">
                                                <i class="fas fa-id-badge"></i>ID:
                                            </div>
                                            <div class="info-value">${staff.staffID}</div>
                                        </div>

                                        <div class="info-row">
                                            <div class="info-label">
                                                <i class="fas fa-envelope"></i>Email:
                                            </div>
                                            <div class="info-value">
                                                <c:choose>
                                                    <c:when test="${not empty staff.email}">
                                                        <a href="mailto:${staff.email}">${staff.email}</a>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="no-data">Chưa cập nhật</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>

                                        <div class="info-row">
                                            <div class="info-label">
                                                <i class="fas fa-phone"></i>Điện thoại:
                                            </div>
                                            <div class="info-value">
                                                <c:choose>
                                                    <c:when test="${not empty staff.phone}">
                                                        <a href="tel:${staff.phone}">${staff.phone}</a>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="no-data">Chưa cập nhật</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>

                                        <div class="info-row">
                                            <div class="info-label">
                                                <i class="fas fa-toggle-on"></i>Trạng thái tài khoản:
                                            </div>
                                            <div class="info-value">
                                                <span class="status-badge ${staff.active ? 'status-active' : 'status-inactive'}">
                                                    ${staff.active ? 'Đang hoạt động' : 'Đã vô hiệu hóa'}
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Thông tin công việc -->
                        <div class="col-lg-8">
                            <div class="card">
                                <div class="card-header">
                                    <h5 class="mb-0">
                                        <i class="fas fa-briefcase me-2"></i>Thông tin công việc
                                    </h5>
                                </div>
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="info-section">
                                                <div class="section-title">
                                                    <i class="fas fa-calendar-alt me-2"></i>Thời gian làm việc
                                                </div>

                                                <div class="info-row">
                                                    <div class="info-label">
                                                        <i class="fas fa-play"></i>Ngày bắt đầu:
                                                    </div>
                                                    <div class="info-value">
                                                        <c:choose>
                                                            <c:when test="${not empty staff.startMonth}">
                                                                <span class="date-display">
                                                                    <fmt:formatDate value="${staff.startMonth}" pattern="dd/MM/yyyy"/>
                                                                </span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="no-data">Chưa cập nhật</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </div>

                                                <div class="info-row">
                                                    <div class="info-label">
                                                        <i class="fas fa-stop"></i>Ngày kết thúc:
                                                    </div>
                                                    <div class="info-value">
                                                        <c:choose>
                                                            <c:when test="${not empty staff.endMonth}">
                                                                <span class="date-display">
                                                                    <fmt:formatDate value="${staff.endMonth}" pattern="dd/MM/yyyy"/>
                                                                </span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="status-badge status-working">Không thời hạn</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </div>

                                                <div class="info-row">
                                                    <div class="info-label">
                                                        <i class="fas fa-user-clock"></i>Trạng thái làm việc:
                                                    </div>
                                                    <div class="info-value">
                                                        <span class="status-badge ${staff.statusClass}">
                                                            ${staff.workStatus}
                                                        </span>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="col-md-6">
                                            <div class="info-section">
                                                <div class="section-title">
                                                    <i class="fas fa-money-bill-wave me-2"></i>Thông tin lương
                                                </div>

                                                <div class="info-row">
                                                    <div class="info-label">
                                                        <i class="fas fa-dollar-sign"></i>Lương cơ bản:
                                                    </div>
                                                    <div class="info-value">
                                                        <c:choose>
                                                            <c:when test="${not empty staff.salary}">
                                                                <span class="salary-display">
                                                                    <fmt:formatNumber value="${staff.salary}" type="number" groupingUsed="true"/> VNĐ
                                                                </span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="no-data">Chưa cập nhật</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </div>

                                                <c:if test="${not empty staff.salary}">
                                                    <div class="contract-info">
                                                        <div class="contract-status">
                                                            <h6 class="mb-3">Thông tin hợp đồng</h6>
                                                        </div>
                                                        
                                                        <div class="row text-center">
                                                            <div class="col-6">
                                                                <div class="mb-2">
                                                                    <i class="fas fa-calendar-day text-primary"></i>
                                                                </div>
                                                                <div class="fw-bold">Lương/tháng</div>
                                                                <div class="text-success">
                                                                    <fmt:formatNumber value="${staff.salary}" type="number" groupingUsed="true"/> VNĐ
                                                                </div>
                                                            </div>
                                                            <div class="col-6">
                                                                <div class="mb-2">
                                                                    <i class="fas fa-calendar-alt text-info"></i>
                                                                </div>
                                                                <div class="fw-bold">Lương/năm</div>
                                                                <div class="text-info">
                                                                    <fmt:formatNumber value="${staff.salary * 12}" type="number" groupingUsed="true"/> VNĐ
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </c:if>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Chỉ có nút Quay lại -->
                                    <div class="action-buttons">
                                        <a href="${pageContext.request.contextPath}/manager/staff" class="btn btn-secondary">
                                            <i class="fas fa-arrow-left me-2"></i>Quay lại danh sách
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="card">
                        <div class="card-body text-center">
                            <i class="fas fa-user-times fa-3x text-muted mb-3"></i>
                            <h5 class="text-muted">Không tìm thấy thông tin nhân viên</h5>
                            <p class="text-muted">Nhân viên có thể đã bị xóa hoặc không tồn tại.</p>
                            <a href="${pageContext.request.contextPath}/manager/staff" class="btn btn-secondary">
                                <i class="fas fa-arrow-left me-2"></i>Quay lại danh sách
                            </a>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </main>

    <!-- Bootstrap Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        // Tự động ẩn thông báo sau 3 giây
        document.addEventListener('DOMContentLoaded', function() {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(function(alert) {
                setTimeout(function() {
                    const bsAlert = new bootstrap.Alert(alert);
                    bsAlert.close();
                }, 3000);
            });
        });
    </script>
</body>
</html>
