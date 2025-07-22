<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản lý Nhân viên</title>
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <!-- jQuery -->
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    </head>

    <style>
        /* Giữ nguyên CSS từ file gốc */
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
            margin-top: 60px;
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
            background-color: #f8f9fc;
            border-bottom: 1px solid #e3e6f0;
            border-radius: 15px 15px 0 0 !important;
            padding: 1rem 1.5rem;
            font-weight: 600;
            color: #5a5c69;
        }

        /* Pagination styles */
        .pagination-container {
            margin-top: 1.5rem;
        }

        .pagination-info {
            color: #6c757d;
            font-size: 0.9rem;
        }

        .page-numbers {
            display: inline-flex;
            align-items: center;
        }

        .page-number {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            margin: 0 3px;
            border: 1px solid #dee2e6;
            background-color: #fff;
            color: #495057;
            font-size: 0.875rem;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .page-number:hover {
            background-color: #e9ecef;
            border-color: #dee2e6;
        }

        .page-number.active {
            background-color: #4e73df;
            border-color: #4e73df;
            color: #fff;
            font-weight: bold;
        }

        .page-ellipsis {
            width: 32px;
            text-align: center;
            color: #6c757d;
        }

        #prevPage, #nextPage {
            border-radius: 20px;
            padding: 0.25rem 0.75rem;
            font-size: 0.875rem;
        }

        #prevPage:disabled, #nextPage:disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }

        @media (max-width: 576px) {
            .pagination-container {
                flex-direction: column;
                align-items: center;
            }

            .pagination-info {
                margin-bottom: 0.5rem;
            }

            .page-number {
                width: 28px;
                height: 28px;
                font-size: 0.8rem;
                margin: 0 2px;
            }

            #prevPage, #nextPage {
                padding: 0.2rem 0.5rem;
                font-size: 0.8rem;
            }
        }

        .card-body {
            padding: 1.5rem;
        }

        .table thead th {
            border-top: none;
            border-bottom: 2px solid #e3e6f0;
            font-weight: 600;
            color: #5a5c69;
            background-color: #f8f9fc;
            padding: 1rem 0.75rem;
        }

        .table tbody td {
            padding: 1rem 0.75rem;
            vertical-align: middle;
            border-top: 1px solid #e3e6f0;
        }

        .table tbody tr:hover {
            background-color: #f8f9fc;
        }

        .btn {
            border-radius: 8px;
            font-weight: 500;
            padding: 0.5rem 1rem;
            transition: all 0.3s ease;
        }

        .btn-primary {
            background: linear-gradient(45deg, #4e73df, #224abe);
            border: none;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(78, 115, 223, 0.4);
        }

        .btn-sm {
            padding: 0.25rem 0.5rem;
            font-size: 0.875rem;
            margin: 0 2px;
        }

        .btn-info {
            background: linear-gradient(45deg, #36b9cc, #258391);
            border: none;
        }

        .btn-success {
            background: linear-gradient(45deg, #1cc88a, #13855c);
            border: none;
        }

        .btn-danger {
            background: linear-gradient(45deg, #e74a3b, #c0392b);
            border: none;
        }

        .btn-warning {
            background: linear-gradient(45deg, #f6c23e, #dda20a);
            border: none;
        }

        .badge {
            font-size: 0.75rem;
            font-weight: 500;
            padding: 0.5rem 0.75rem;
            border-radius: 10px;
        }

        .modal-content {
            border: none;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }

        .modal-header {
            border-bottom: 1px solid #e3e6f0;
            border-radius: 15px 15px 0 0;
            padding: 1.5rem;
        }

        .modal-body {
            padding: 1.5rem;
        }

        .modal-footer {
            border-top: 1px solid #e3e6f0;
            border-radius: 0 0 15px 15px;
            padding: 1rem 1.5rem;
        }

        .form-control {
            border-radius: 10px;
            border: 1px solid #d1d3e2;
            padding: 0.75rem 1rem;
            transition: all 0.3s ease;
        }

        .form-control:focus {
            border-color: #4e73df;
            box-shadow: 0 0 0 0.2rem rgba(78, 115, 223, 0.25);
        }

        .form-label {
            font-weight: 600;
            color: #5a5c69;
            margin-bottom: 0.5rem;
        }

        .filter-panel {
            background: white;
            border-radius: 10px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15);
        }

        .search-box {
            position: relative;
        }

        .search-box input {
            padding-left: 40px;
            border-radius: 25px;
            border: 2px solid #e3e6f0;
            transition: all 0.3s ease;
        }

        .search-box input:focus {
            border-color: #4e73df;
            box-shadow: 0 0 0 0.2rem rgba(78, 115, 223, 0.25);
        }

        .search-box i {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #858796;
            z-index: 10;
        }

        .stats-card {
            background: white;
            border-radius: 10px;
            padding: 1.5rem;
            box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15);
            border-left: 4px solid #4e73df;
            margin-bottom: 1rem;
        }

        .stats-number {
            font-size: 2rem;
            font-weight: bold;
            color: #4e73df;
        }

        .stats-label {
            color: #858796;
            font-weight: 500;
            text-transform: uppercase;
            font-size: 0.875rem;
        }

        .alert {
            border: none;
            border-radius: 10px;
            font-weight: 500;
        }

        .alert-success {
            background: linear-gradient(45deg, #1cc88a, #17a673);
            color: white;
        }

        .alert-danger {
            background: linear-gradient(45deg, #e74a3b, #c0392b);
            color: white;
        }

        .salary-display {
            font-weight: bold;
            color: #28a745;
        }

        .work-period {
            font-size: 0.9em;
            color: #6c757d;
        }

        .status-working {
            background: linear-gradient(45deg, #28a745, #20c997);
            color: white;
        }

        .status-finished {
            background: linear-gradient(45deg, #6c757d, #495057);
            color: white;
        }

        .avatar-circle {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: linear-gradient(45deg, #007bff, #0056b3);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
            font-size: 1.1rem;
            flex-shrink: 0;
        }

        @media (max-width: 768px) {
            .main-content {
                margin-left: 0;
                padding: 15px;
            }
            .card-body {
                padding: 1rem;
            }
            .table-responsive {
                font-size: 0.875rem;
            }
            .filter-panel {
                padding: 1rem;
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
                            <i class="fas fa-user-tie me-2"></i>Quản Lý Nhân Viên
                        </h1>
                        <p class="mb-0 text-muted">Quản lý thông tin nhân viên và lương</p>
                    </div>
                    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addStaffModal">
                        <i class="fas fa-plus me-2"></i>Thêm Nhân Viên
                    </button>
                </div>

                <!-- Statistics Cards -->
                <div class="row mb-4">
                    <div class="col-xl-3 col-md-6">
                        <div class="stats-card">
                            <div class="d-flex align-items-center">
                                <div class="flex-grow-1">
                                    <div class="stats-number">${totalStaff}</div>
                                    <div class="stats-label">Tổng nhân viên</div>
                                </div>
                                <div class="text-primary">
                                    <i class="fas fa-user-tie fa-2x"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-xl-3 col-md-6">
                        <div class="stats-card" style="border-left-color: #1cc88a;">
                            <div class="d-flex align-items-center">
                                <div class="flex-grow-1">
                                    <div class="stats-number text-success">${activeStaff}</div>
                                    <div class="stats-label">Đang hoạt động</div>
                                </div>
                                <div class="text-success">
                                    <i class="fas fa-user-check fa-2x"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-xl-3 col-md-6">
                        <div class="stats-card" style="border-left-color: #36b9cc;">
                            <div class="d-flex align-items-center">
                                <div class="flex-grow-1">
                                    <div class="stats-number text-info">${workingStaff}</div>
                                    <div class="stats-label">Đang làm việc</div>
                                </div>
                                <div class="text-info">
                                    <i class="fas fa-briefcase fa-2x"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-xl-3 col-md-6">
                        <div class="stats-card" style="border-left-color: #e74a3b;">
                            <div class="d-flex align-items-center">
                                <div class="flex-grow-1">
                                    <div class="stats-number text-danger">${inactiveStaff}</div>
                                    <div class="stats-label">Vô hiệu hóa</div>
                                </div>
                                <div class="text-danger">
                                    <i class="fas fa-user-times fa-2x"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Thông báo -->
                <c:if test="${not empty param.message}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle me-2"></i>${param.message}
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>
                <c:if test="${not empty message}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle me-2"></i>${message}
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>
                <c:if test="${not empty param.error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-circle me-2"></i>${param.error}
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-circle me-2"></i>${error}
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <!-- Filter Panel -->
                <div class="filter-panel">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h5 class="mb-0">
                            <i class="fas fa-search me-2"></i>Tìm kiếm & Lọc
                        </h5>
                    </div>

                    <div class="row">
                        <div class="col-md-8">
                            <div class="search-box">
                                <i class="fas fa-search"></i>
                                <input type="text" id="searchInput" class="form-control" 
                                       placeholder="Tìm kiếm theo tên, email, số điện thoại...">
                            </div>
                        </div>
                        <div class="col-md-4">
                            <select id="statusFilter" class="form-control" onchange="applyFilters()">
                                <option value="">Tất cả trạng thái</option>
                                <option value="working">Đang làm việc</option>
                                <option value="finished">Đã nghỉ việc</option>
                            </select>
                        </div>
                    </div>
                </div>

                <!-- Bảng danh sách nhân viên -->
                <div class="card">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h6 class="m-0 font-weight-bold text-primary">
                            <i class="fas fa-table me-2"></i>Danh Sách Nhân Viên
                        </h6>
                        <span class="badge bg-primary" id="table-count">
                            ${totalStaff} nhân viên
                        </span>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle">
                                <thead class="table-dark">
                                    <tr>
                                        <th>ID</th>
                                        <th>Thông tin nhân viên</th>
                                        <th>Số điện thoại</th>
                                        <th>Lương/Tháng</th>
                                        <th>Thời gian hợp đồng</th>
                                        <th>Trạng thái</th>
                                        <th>Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="staff" items="${staffList}">
                                        <tr class="staff-row">
                                            <td>${staff.staffID}</td>
                                            <td>
                                                <div class="d-flex align-items-center">
                                                    <div class="avatar-circle me-3">
                                                        ${fn:substring(staff.username, 0, 1).toUpperCase()}
                                                    </div>
                                                    <div>
                                                        <div class="fw-bold">${staff.username}</div>
                                                        <small class="text-muted">${staff.email}</small>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${staff.phone != null && !empty staff.phone}">
                                                        ${staff.phone}
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">Chưa cập nhật</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${staff.salary != null}">
                                                        <span class="salary-display">
                                                            <fmt:formatNumber value="${staff.salary}" type="number" groupingUsed="true"/> VNĐ
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">Chưa cập nhật</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <div class="work-period">
                                                    <c:choose>
                                                        <c:when test="${staff.startMonth != null}">
                                                            <div><strong>Bắt đầu:</strong> 
                                                                <fmt:formatDate value="${staff.startMonth}" pattern="dd/MM/yyyy"/>
                                                            </div>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="text-muted">Chưa có hợp đồng</div>
                                                        </c:otherwise>
                                                    </c:choose>

                                                    <c:choose>
                                                        <c:when test="${staff.endMonth != null}">
                                                            <div><strong>Kết thúc:</strong> 
                                                                <fmt:formatDate value="${staff.endMonth}" pattern="dd/MM/yyyy"/>
                                                            </div>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="text-info"><strong>Không thời hạn</strong></div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </td>
                                            <td>
                                                <span class="badge ${staff.statusClass}">
                                                    ${staff.workStatus}
                                                </span>
                                            </td>
                                            <td>
                                                <div class="btn-group" role="group">
                                                    <!-- XEM CHI TIẾT - CHUYỂN SANG TRANG RIÊNG -->
                                                    <a href="staff?action=detail&id=${staff.staffID}" 
                                                       class="btn btn-info btn-sm" title="Xem chi tiết">
                                                        <i class="fas fa-eye"></i>
                                                    </a>

                                                    <!-- CHỈNH SỬA -->
                                                    <button type="button" class="btn btn-warning btn-sm" 
                                                            onclick="editStaff(${staff.staffID}, '${fn:escapeXml(staff.username)}', '${fn:escapeXml(staff.email)}', '${fn:escapeXml(staff.phone)}',
                                                            <c:choose>
                                                                <c:when test="${staff.startMonth != null}">new Date('${staff.startMonth}')</c:when>
                                                                <c:otherwise>null</c:otherwise>
                                                            </c:choose>,
                                                            <c:choose>
                                                                <c:when test="${staff.endMonth != null}">new Date('${staff.endMonth}')</c:when>
                                                                <c:otherwise>null</c:otherwise>
                                                            </c:choose>,
                                                            ${staff.salary}
                                                                        )" 
                                                            data-bs-toggle="modal" data-bs-target="#editStaffModal" title="Chỉnh sửa">
                                                        <i class="fas fa-edit"></i>
                                                    </button>

                                                    <!-- KÍCH HOẠT/VÔ HIỆU HÓA -->
                                                    <c:choose>
                                                        <c:when test="${staff.active}">
                                                            <a href="staff?action=toggle&id=${staff.staffID}&status=${staff.active}" 
                                                               class="btn btn-secondary btn-sm" 
                                                               onclick="return confirm('Bạn có chắc chắn muốn vô hiệu hóa tài khoản nhân viên này?')" 
                                                               title="Vô hiệu hóa tài khoản">
                                                                <i class="fas fa-ban"></i>
                                                            </a>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <a href="staff?action=toggle&id=${staff.staffID}&status=${staff.active}" 
                                                               class="btn btn-success btn-sm" 
                                                               onclick="return confirm('Bạn có chắc chắn muốn kích hoạt tài khoản nhân viên này?')" 
                                                               title="Kích hoạt tài khoản">
                                                                <i class="fas fa-check"></i>
                                                            </a>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>

                        <!-- Hiển thị khi không có kết quả -->
                        <div id="noResults" style="display: none;" class="text-center py-4">
                            <i class="fas fa-search fa-3x text-muted mb-3"></i>
                            <h5 class="text-muted">Không tìm thấy nhân viên nào</h5>
                            <p class="text-muted">Thử thay đổi từ khóa tìm kiếm hoặc bộ lọc</p>
                        </div>

                        <!-- Phân trang -->
                        <div class="pagination-container mt-4">
                            <div class="d-flex justify-content-between align-items-center">
                                <div class="pagination-info">
                                    <span id="paginationInfo">Trang 1/1</span>
                                </div>
                                <div class="pagination-controls">
                                    <button id="prevPage" class="btn btn-sm btn-outline-primary" disabled>
                                        <i class="fas fa-chevron-left"></i> Trước
                                    </button>
                                    <div id="pageNumbers" class="page-numbers d-inline-block mx-2">
                                        <!-- Page numbers will be inserted here -->
                                    </div>
                                    <button id="nextPage" class="btn btn-sm btn-outline-primary">
                                        Sau <i class="fas fa-chevron-right"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>

        <!-- Modal Thêm nhân viên -->
        <div class="modal fade" id="addStaffModal" tabindex="-1">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">
                            <i class="fas fa-user-plus me-2"></i>Thêm nhân viên mới
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <form action="staff" method="post">
                        <input type="hidden" name="action" value="add">
                        <div class="modal-body">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="add-username" class="form-label">Tên đăng nhập <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control" id="add-username" name="username" required>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="add-password" class="form-label">Mật khẩu <span class="text-danger">*</span></label>
                                        <input type="password" class="form-control" id="add-password" name="password" required>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="add-email" class="form-label">Email <span class="text-danger">*</span></label>
                                        <input type="email" class="form-control" id="add-email" name="email" required>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="add-phone" class="form-label">Số điện thoại</label>
                                        <input type="tel" class="form-control" id="add-phone" name="phone">
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="add-startMonth" class="form-label">Ngày bắt đầu <span class="text-danger">*</span></label>
                                        <input type="date" class="form-control" id="add-startMonth" name="startMonth" required>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="add-endMonth" class="form-label">Ngày kết thúc hợp đồng <span class="text-danger">*</span></label>
                                        <input type="date" class="form-control" id="add-endMonth" name="endMonth" required>
                                    </div>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label for="add-salary" class="form-label">Lương (VNĐ) <span class="text-danger">*</span></label>
                                <input type="number" class="form-control" id="add-salary" name="salary" min="0" step="1000" required>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save me-1"></i>Thêm nhân viên
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Modal chỉnh sửa -->
        <div class="modal fade" id="editStaffModal" tabindex="-1">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">
                            <i class="fas fa-user-edit me-2"></i>Chỉnh sửa thông tin nhân viên
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <form action="staff" method="post">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" id="edit-id" name="id">
                        <div class="modal-body">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="edit-username" class="form-label">Tên đăng nhập <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control" id="edit-username" name="username" required>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="edit-email" class="form-label">Email <span class="text-danger">*</span></label>
                                        <input type="email" class="form-control" id="edit-email" name="email" required>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="edit-phone" class="form-label">Số điện thoại</label>
                                        <input type="tel" class="form-control" id="edit-phone" name="phone">
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="edit-salary" class="form-label">Lương (VNĐ)</label>
                                        <input type="number" class="form-control" id="edit-salary" name="salary" min="0" step="1000">
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="edit-startMonth" class="form-label">Ngày bắt đầu</label>
                                        <input type="date" class="form-control" id="edit-startMonth" name="startMonth">
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="edit-endMonth" class="form-label">Ngày kết thúc hợp đồng</label>
                                        <input type="date" class="form-control" id="edit-endMonth" name="endMonth">
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save me-1"></i>Cập nhật
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Footer -->
        <footer class="footer">
            <div class="container-fluid">
                <div class="row">
                    <h3>Đây là footer</h3>
                </div>
            </div>
        </footer>

        <!-- Bootstrap Bundle with Popper -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>

        <script>
            // Global variables
            let allStaff = [];
            let filteredStaff = [];
            let currentPage = 1;
            const itemsPerPage = 5;

            // Khởi tạo dữ liệu khi trang load
            document.addEventListener('DOMContentLoaded', function () {
                initializeStaffData();
                setupEventListeners();

                // Hiển thị trang đầu tiên
                displayCurrentPage();

                // Tự động ẩn thông báo sau 3 giây
                const alerts = document.querySelectorAll('.alert');
                alerts.forEach(function (alert) {
                    setTimeout(function () {
                        const bsAlert = new bootstrap.Alert(alert);
                        bsAlert.close();
                    }, 3000);
                });
            });

            // Khởi tạo dữ liệu nhân viên
            function initializeStaffData() {
                const rows = document.querySelectorAll('.staff-row');
                allStaff = [];

                rows.forEach(row => {
                    const staff = {
                        id: row.cells[0].textContent.trim(),
                        username: row.cells[1].querySelector('.fw-bold').textContent.trim(),
                        email: row.cells[1].querySelector('small').textContent.trim(),
                        phone: row.cells[2].textContent.trim(),
                        salary: row.cells[3].textContent.trim(),
                        startMonth: row.cells[4].querySelector('div:first-child') ?
                                row.cells[4].querySelector('div:first-child').textContent.trim() : '',
                        endMonth: row.cells[4].querySelector('div:last-child') ?
                                row.cells[4].querySelector('div:last-child').textContent.trim() : '',
                        workStatus: row.cells[5].querySelector('.badge').textContent.trim(),
                        isActive: !row.cells[5].querySelector('.badge').textContent.includes('Vô hiệu hóa'),
                        element: row
                    };
                    allStaff.push(staff);
                });

                filteredStaff = [...allStaff];
                updateTableCount();
            }

            // Setup event listeners
            function setupEventListeners() {
                // Search input
                const searchInput = document.getElementById('searchInput');
                if (searchInput) {
                    searchInput.addEventListener('input', debounce(handleSearch, 300));
                }

                // Status filter
                const statusFilter = document.getElementById('statusFilter');
                if (statusFilter) {
                    statusFilter.addEventListener('change', applyFilters);
                }

                // Pagination buttons
                document.getElementById('prevPage').addEventListener('click', function () {
                    if (currentPage > 1) {
                        currentPage--;
                        displayCurrentPage();
                    }
                });

                document.getElementById('nextPage').addEventListener('click', function () {
                    const totalPages = Math.ceil(filteredStaff.length / itemsPerPage);
                    if (currentPage < totalPages) {
                        currentPage++;
                        displayCurrentPage();
                    }
                });
            }

            // Debounce function
            function debounce(func, wait) {
                let timeout;
                return function executedFunction(...args) {
                    const later = () => {
                        clearTimeout(timeout);
                        func(...args);
                    };
                    clearTimeout(timeout);
                    timeout = setTimeout(later, wait);
                };
            }

            // Handle search
            function handleSearch() {
                currentPage = 1; // Reset to first page when searching
                applyFilters();
            }

            // Apply all filters
            function applyFilters() {
                const searchInput = document.getElementById('searchInput');
                const statusFilter = document.getElementById('statusFilter');

                const searchTerm = searchInput ? searchInput.value.toLowerCase() : '';
                const statusFilterValue = statusFilter ? statusFilter.value : '';

                // Filter staff
                filteredStaff = allStaff.filter(staff => {
                    // Search filter
                    const matchesSearch = !searchTerm ||
                            staff.username.toLowerCase().includes(searchTerm) ||
                            staff.email.toLowerCase().includes(searchTerm) ||
                            staff.phone.toLowerCase().includes(searchTerm);

                    // Status filter
                    let matchesStatus = true;
                    if (statusFilterValue) {
                        switch (statusFilterValue) {
                            case 'working':
                                matchesStatus = staff.element.querySelector('.badge').textContent.includes('Đang làm việc');
                                break;
                            case 'finished':
                                matchesStatus = staff.element.querySelector('.badge').textContent.includes('Nghỉ việc');
                                break;
                        }
                    }

                    return matchesSearch && matchesStatus;
                });

                // Reset to first page when filtering
                currentPage = 1;

                // Update display
                displayCurrentPage();
                updateTableCount();
                updatePaginationInfo();
            }

            // Display current page
            function displayCurrentPage() {
                // Hide all rows first
                allStaff.forEach(staff => {
                    staff.element.style.display = 'none';
                });

                const noResults = document.getElementById('noResults');

                if (filteredStaff.length === 0) {
                    if (noResults)
                        noResults.style.display = 'block';
                                        updatePaginationInfo();
                    return;
                }

                if (noResults)
                    noResults.style.display = 'none';

                // Calculate start and end indices for current page
                const startIndex = (currentPage - 1) * itemsPerPage;
                const endIndex = Math.min(startIndex + itemsPerPage, filteredStaff.length);

                // Show only rows for current page
                for (let i = startIndex; i < endIndex; i++) {
                    filteredStaff[i].element.style.display = '';
                }

                // Update pagination info
                updatePaginationInfo();
            }

            // Update pagination information
            function updatePaginationInfo() {
                const totalPages = Math.ceil(filteredStaff.length / itemsPerPage);
                const paginationInfo = document.getElementById('paginationInfo');
                const prevButton = document.getElementById('prevPage');
                const nextButton = document.getElementById('nextPage');

                if (paginationInfo) {
                    if (filteredStaff.length === 0) {
                        paginationInfo.textContent = 'Không có kết quả';
                    } else {
                        paginationInfo.textContent = `Trang ${currentPage}/${totalPages}`;
                    }
                }

                // Disable/enable prev/next buttons
                if (prevButton) {
                    prevButton.disabled = currentPage === 1;
                }

                if (nextButton) {
                    nextButton.disabled = currentPage === totalPages || totalPages === 0;
                }

                // Update page numbers
                updatePageNumbers(totalPages);
            }

            // Update page number buttons
            function updatePageNumbers(totalPages) {
                const pageNumbersContainer = document.getElementById('pageNumbers');
                if (!pageNumbersContainer)
                    return;

                pageNumbersContainer.innerHTML = '';

                // Limit number of page buttons to show
                const maxButtons = 5;
                let startPage = Math.max(1, currentPage - Math.floor(maxButtons / 2));
                let endPage = Math.min(totalPages, startPage + maxButtons - 1);

                if (endPage - startPage + 1 < maxButtons) {
                    startPage = Math.max(1, endPage - maxButtons + 1);
                }

                // Add first page button if not visible
                if (startPage > 1) {
                    const firstPageBtn = createPageButton(1);
                    pageNumbersContainer.appendChild(firstPageBtn);

                    if (startPage > 2) {
                        const ellipsis = document.createElement('span');
                        ellipsis.className = 'page-ellipsis';
                        ellipsis.textContent = '...';
                        pageNumbersContainer.appendChild(ellipsis);
                    }
                }

                // Add page number buttons
                for (let i = startPage; i <= endPage; i++) {
                    const pageBtn = createPageButton(i);
                    pageNumbersContainer.appendChild(pageBtn);
                }

                // Add last page button if not visible
                if (endPage < totalPages) {
                    if (endPage < totalPages - 1) {
                        const ellipsis = document.createElement('span');
                        ellipsis.className = 'page-ellipsis';
                        ellipsis.textContent = '...';
                        pageNumbersContainer.appendChild(ellipsis);
                    }

                    const lastPageBtn = createPageButton(totalPages);
                    pageNumbersContainer.appendChild(lastPageBtn);
                }
            }

            // Create a page number button
            function createPageButton(pageNum) {
                const button = document.createElement('button');
                button.type = 'button';
                button.className = 'page-number' + (pageNum === currentPage ? ' active' : '');
                button.textContent = pageNum;
                button.addEventListener('click', function () {
                    currentPage = pageNum;
                    displayCurrentPage();
                });
                return button;
            }

            // Update table count
            function updateTableCount() {
                const countElement = document.getElementById('table-count');
                if (countElement) {
                    const count = filteredStaff.length;
                    const countText = count === 1 ? '1 nhân viên' : `${count} nhân viên`;
                    countElement.textContent = countText;
                }
            }

            // Helper functions for date formatting
            function formatDateDisplay(dateObj) {
                if (!dateObj)
                    return '';

                if (typeof dateObj === 'string') {
                    dateObj = new Date(dateObj);
                }

                if (isNaN(dateObj.getTime()))
                    return '';

                return dateObj.toLocaleDateString('vi-VN', {
                    year: 'numeric',
                    month: '2-digit',
                    day: '2-digit'
                });
            }

            function formatDateForInput(dateObj) {
                if (!dateObj)
                    return '';

                if (typeof dateObj === 'string') {
                    dateObj = new Date(dateObj);
                }

                if (isNaN(dateObj.getTime()))
                    return '';

                const year = dateObj.getFullYear();
                const month = String(dateObj.getMonth() + 1).padStart(2, '0');
                const day = String(dateObj.getDate()).padStart(2, '0');

                return `${year}-${month}-${day}`;
            }

            // Hàm chỉnh sửa nhân viên
            function editStaff(id, username, email, phone, startMonth, endMonth, salary) {
                document.getElementById('edit-id').value = id;
                document.getElementById('edit-username').value = username || '';
                document.getElementById('edit-email').value = email || '';
                document.getElementById('edit-phone').value = phone || '';

                // Set salary
                if (salary && salary !== 'null' && salary !== null) {
                    document.getElementById('edit-salary').value = salary;
                } else {
                    document.getElementById('edit-salary').value = '';
                }

                // Set start date
                if (startMonth && startMonth !== 'null' && startMonth !== null) {
                    document.getElementById('edit-startMonth').value = formatDateForInput(startMonth);
                } else {
                    document.getElementById('edit-startMonth').value = '';
                }

                // Set end date
                if (endMonth && endMonth !== 'null' && endMonth !== null) {
                    document.getElementById('edit-endMonth').value = formatDateForInput(endMonth);
                } else {
                    document.getElementById('edit-endMonth').value = '';
                }
            }
        </script>
    </body>
</html>

