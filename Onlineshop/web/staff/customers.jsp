<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="Model.Account" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản lý Khách hàng</title>
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <!-- jQuery -->
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    </head>

    <style>
        /* Body và Layout chính */
        body {
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8f9fa;
        }

        /* Topbar Styles */
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

        .topbar-brand {
            font-size: 1.5rem;
            font-weight: bold;
            color: #5a5c69;
            text-decoration: none;
        }

        .topbar-brand:hover {
            color: #3a3b45;
        }

        .topbar-search {
            position: relative;
            width: 300px;
        }

        .topbar-search input {
            padding-left: 40px;
            border-radius: 20px;
            border: 1px solid #d1d3e2;
            background-color: #f8f9fc;
        }

        .topbar-search input:focus {
            background-color: white;
            box-shadow: 0 0 0 0.2rem rgba(78, 115, 223, 0.25);
        }

        .topbar-search i {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #858796;
        }

        .topbar-actions .nav-link {
            color: #5a5c69;
            padding: 0.5rem;
            margin: 0 0.25rem;
            border-radius: 50%;
            transition: all 0.3s ease;
        }

        .topbar-actions .nav-link:hover {
            color: #3a3b45;
            background-color: #eaecf4;
        }

        /* User Dropdown Styles */
        .user-dropdown {
            border-radius: 20px;
            font-weight: 500;
            transition: all 0.3s ease;
            text-decoration: none;
            color: inherit;
            padding: 8px 15px;
        }

        .user-dropdown:hover {
            background: rgba(0,0,0,0.1);
            color: inherit;
        }

        .admin-dropdown {
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.15);
            border: none;
            padding: 10px 0;
            min-width: 200px;
        }

        .admin-dropdown .dropdown-item {
            padding: 10px 20px;
            font-weight: 500;
            transition: all 0.3s ease;
            border: none;
            background: none;
            width: 100%;
            text-align: left;
        }

        .admin-dropdown .dropdown-item:hover {
            background: linear-gradient(45deg, #dc3545, #c82333);
            color: white;
            transform: translateX(5px);
        }

        .logout-btn {
            cursor: pointer;
        }

        /* Main Content Styles */
        .main-content {
            margin-left: 250px;
            margin-top: 60px;
            padding: 30px;
            min-height: calc(100vh - 60px);
            background-color: #f8f9fa;
        }

        /* Card Styles */
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

        .card-body {
            padding: 1.5rem;
        }

        /* Table Styles */
        .table {
            margin-bottom: 0;
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

        /* Button Styles */
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

        .btn-outline-secondary {
            border-color: #d1d3e2;
            color: #5a5c69;
        }

        .btn-outline-secondary:hover {
            background-color: #5a5c69;
            border-color: #5a5c69;
        }

        /* Badge Styles */
        .badge {
            font-size: 0.75rem;
            font-weight: 500;
            padding: 0.5rem 0.75rem;
            border-radius: 10px;
        }

        /* Modal Styles */
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

        /* Form Styles */
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

        /* Filter Panel Styles */
        .filter-panel {
            background: white;
            border-radius: 10px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15);
        }

        .filter-toggle {
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .filter-toggle:hover {
            color: #4e73df;
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

        .clear-search {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            color: #858796;
            cursor: pointer;
            z-index: 10;
        }

        .clear-search:hover {
            color: #5a5c69;
        }

        /* Avatar và Customer Info Styles */
        .avatar-circle {
            width: 100px;
            height: 100px;
            background: linear-gradient(45deg, #4e73df, #224abe);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            border: 3px solid #e3e6f0;
            color: white;
        }

        .customer-info {
            background-color: #f8f9fc;
            border-radius: 10px;
            padding: 1rem;
            border: 1px solid #e3e6f0;
        }

        .info-item {
            transition: all 0.3s;
            border-radius: 8px;
            margin: 0.25rem 0;
        }

        .info-item:hover {
            background-color: #eaecf4;
            padding: 0.5rem;
        }

        .info-label {
            color: #6c757d;
            font-weight: 600;
        }

        .info-value {
            color: #5a5c69;
            font-weight: 500;
        }

        /* Alert Styles */
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

        /* Pagination Styles */
        .pagination .page-link {
            border-radius: 8px;
            margin: 0 2px;
            border: 1px solid #d1d3e2;
            color: #5a5c69;
            font-weight: 500;
        }

        .pagination .page-item.active .page-link {
            background: linear-gradient(45deg, #4e73df, #224abe);
            border-color: #4e73df;
        }

        .pagination .page-link:hover {
            background-color: #eaecf4;
            border-color: #d1d3e2;
        }

        /* Toast Styles */
        .toast-container {
            z-index: 1060;
        }

        /* No Results Styles */
        .no-results {
            text-align: center;
            padding: 3rem 1rem;
            color: #6c757d;
        }

        .no-results i {
            font-size: 4rem;
            margin-bottom: 1rem;
            opacity: 0.5;
        }

        /* Stats Cards */
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

        /* Responsive */
        @media (max-width: 768px) {
            .main-content {
                margin-left: 0;
                padding: 15px;
            }

            .topbar-search {
                display: none;
            }

            .user-dropdown {
                font-size: 0.9rem;
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

            .search-box {
                margin-bottom: 1rem;
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
                            <i class="fas fa-users me-2"></i>Quản Lý Khách Hàng
                        </h1>
                        <p class="mb-0 text-muted">Quản lý thông tin khách hàng</p>
                    </div>
                    <!-- Thành: -->
                    <a href="${pageContext.request.contextPath}/staff/customers?action=showAdd" class="btn btn-primary">
                        <i class="fas fa-plus me-2"></i>Thêm Khách Hàng
                    </a>
                </div>

                <!-- Statistics Cards -->
                <div class="row mb-4">
                    <div class="col-xl-3 col-md-6">
                        <div class="stats-card">
                            <div class="d-flex align-items-center">
                                <div class="flex-grow-1">
                                    <div class="stats-number" id="total-customers">0</div>
                                    <div class="stats-label">Tổng khách hàng</div>
                                </div>
                                <div class="text-primary">
                                    <i class="fas fa-users fa-2x"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-xl-3 col-md-6">
                        <div class="stats-card" style="border-left-color: #1cc88a;">
                            <div class="d-flex align-items-center">
                                <div class="flex-grow-1">
                                    <div class="stats-number text-success" id="active-customers">0</div>
                                    <div class="stats-label">Đang hoạt động</div>
                                </div>
                                <div class="text-success">
                                    <i class="fas fa-user-check fa-2x"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-xl-3 col-md-6">
                        <div class="stats-card" style="border-left-color: #e74a3b;">
                            <div class="d-flex align-items-center">
                                <div class="flex-grow-1">
                                    <div class="stats-number text-danger" id="inactive-customers">0</div>
                                    <div class="stats-label">Vô hiệu hóa</div>
                                </div>
                                <div class="text-danger">
                                    <i class="fas fa-user-times fa-2x"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-xl-3 col-md-6">
                        <div class="stats-card" style="border-left-color: #36b9cc;">
                            <div class="d-flex align-items-center">
                                <div class="flex-grow-1">
                                    <div class="stats-number text-info" id="filtered-count">0</div>
                                    <div class="stats-label">Kết quả hiển thị</div>
                                </div>
                                <div class="text-info">
                                    <i class="fas fa-filter fa-2x"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Hiển thị thông báo thành công từ session -->
                <c:if test="${not empty sessionScope.successMessage}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle me-2"></i>
                        ${sessionScope.successMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                    <% session.removeAttribute("successMessage"); %>
                </c:if>

                <!-- Filter Panel -->
                <div class="filter-panel">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h5 class="mb-0">
                            <i class="fas fa-search me-2"></i>Tìm kiếm & Lọc
                        </h5>
                        <span class="filter-toggle" onclick="toggleAdvancedFilter()">
                            <i class="fas fa-chevron-down" id="filter-toggle-icon"></i>
                            <span id="filter-toggle-text">Hiển thị bộ lọc</span>
                        </span>
                    </div>

                    <!-- Search Box -->
                    <div class="row mb-3">
                        <div class="col-md-8">
                            <div class="search-box">
                                <i class="fas fa-search"></i>
                                <input type="text" id="searchInput" class="form-control" 
                                       placeholder="Tìm kiếm theo tên, email, số điện thoại...">
                                <button class="clear-search" onclick="clearSearch()" style="display: none;">
                                    <i class="fas fa-times"></i>
                                </button>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <button class="btn btn-outline-secondary w-100" onclick="resetAllFilters()">
                                <i class="fas fa-undo me-2"></i>Reset tất cả
                            </button>
                        </div>
                    </div>

                    <!-- Advanced Filters -->
                    <div id="advancedFilters" style="display: none;">
                        <div class="row">
                            <div class="col-md-6">
                                <label class="form-label">Trạng thái</label>
                                <select id="statusFilter" class="form-control" onchange="applyFilters()">
                                    <option value="">Tất cả trạng thái</option>
                                    <option value="active">Hoạt động</option>
                                    <option value="inactive">Vô hiệu hóa</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Sắp xếp theo</label>
                                <select id="sortFilter" class="form-control" onchange="applyFilters()">
                                    <option value="id-asc">ID tăng dần</option>
                                    <option value="id-desc">ID giảm dần</option>
                                    <option value="name-asc">Tên A-Z</option>
                                    <option value="name-desc">Tên Z-A</option>
                                    <option value="email-asc">Email A-Z</option>
                                    <option value="email-desc">Email Z-A</option>
                                </select>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Bảng danh sách khách hàng -->
                <div class="card">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <span>
                            <i class="fas fa-table me-2"></i>Danh sách Khách Hàng
                        </span>
                        <span class="badge bg-primary" id="table-count">0 khách hàng</span>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover" id="customersTable">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Tên đăng nhập</th>
                                        <th>Email</th>
                                        <th>Số điện thoại</th>
                                        <th>Trạng thái</th>
                                        <th>Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody id="customersTableBody">
                                    <!-- Đếm số lượng khách hàng -->
                                    <c:set var="customerCount" value="0"/>
                                    <c:forEach var="user" items="${users}">
                                        <c:if test="${user.role == 0}">
                                            <c:set var="customerCount" value="${customerCount + 1}"/>
                                            <tr class="customer-row" 
                                                data-id="${user.accountID}"
                                                data-username="${user.username}"
                                                data-email="${user.email}"
                                                data-phone="${user.phone}"
                                                data-status="${user.isActive ? 'active' : 'inactive'}"
                                                data-has-phone="${user.phone != null && user.phone != '' ? 'yes' : 'no'}">
                                                <td><span class="fw-bold">${user.accountID}</span></td>
                                                <td>
                                                    <div class="d-flex align-items-center">
                                                        <div class="avatar-sm me-2">
                                                            <div class="rounded-circle bg-primary d-flex align-items-center justify-content-center" style="width: 35px; height: 35px;">
                                                                <i class="fas fa-user text-white"></i>
                                                            </div>
                                                        </div>
                                                        <span class="fw-bold">${user.username}</span>
                                                    </div>
                                                </td>
                                                <td>${user.email}</td>
                                                <td>${user.phone != null && user.phone != '' ? user.phone : '<span class="text-muted">Chưa cập nhật</span>'}</td>
                                                <td>
                                                    <c:if test="${user.isActive}">
                                                        <span class="badge bg-success">
                                                            <i class="fas fa-check me-1"></i>Hoạt động
                                                        </span>
                                                    </c:if>
                                                    <c:if test="${!user.isActive}">
                                                        <span class="badge bg-danger">
                                                            <i class="fas fa-ban me-1"></i>Vô hiệu hóa
                                                        </span>
                                                    </c:if>
                                                </td>
                                                <td>
                                                    <div class="btn-group" role="group">
                                                        <button class="btn btn-sm btn-info" 
                                                                onclick="viewUser(${user.accountID}, '${user.username}', '${user.email}', '${user.phone}', ${user.role}, 'Khách hàng', ${user.isActive})" 
                                                                data-bs-toggle="modal" 
                                                                data-bs-target="#viewUserModal"
                                                                title="Xem chi tiết">
                                                            <i class="fas fa-eye"></i>
                                                        </button>
                                                                <a href="${pageContext.request.contextPath}/staff/customers?action=edit&id=${user.accountID}" 
                                                                   class="btn btn-sm btn-primary" 
                                                                   title="Chỉnh sửa">
                                                                    <i class="fas fa-edit"></i>
                                                                </a>
                                                        <c:if test="${user.isActive}">
                                                            <a href="customers?action=toggle&id=${user.accountID}&status=true" 
                                                               class="btn btn-sm btn-danger" 
                                                               onclick="return confirm('Bạn có chắc chắn muốn vô hiệu hóa tài khoản này?')"
                                                               title="Vô hiệu hóa">
                                                                <i class="fas fa-ban"></i>
                                                            </a>
                                                        </c:if>
                                                        <c:if test="${!user.isActive}">
                                                            <a href="customers?action=toggle&id=${user.accountID}&status=false" 
                                                               class="btn btn-sm btn-success" 
                                                               onclick="return confirm('Bạn có chắc chắn muốn kích hoạt lại tài khoản này?')"
                                                               title="Kích hoạt">
                                                                <i class="fas fa-check"></i>
                                                            </a>
                                                        </c:if>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:if>
                                    </c:forEach>
                                </tbody>
                            </table>

                            <!-- No Results Message -->
                            <div id="noResults" class="no-results" style="display: none;">
                                <i class="fas fa-search"></i>
                                <h5>Không tìm thấy kết quả</h5>
                                <p>Không có khách hàng nào phù hợp với tiêu chí tìm kiếm của bạn.</p>
                                <button class="btn btn-outline-primary" onclick="resetAllFilters()">
                                    <i class="fas fa-undo me-2"></i>Reset bộ lọc
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Phân trang -->
                <c:if test="${totalPages > 0}">
                    <nav aria-label="Page navigation" class="mt-4">
                        <ul class="pagination justify-content-center">
                            <!-- Nút Previous -->
                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                <a class="page-link" href="customers?page=${currentPage - 1}" ${currentPage == 1 ? 'tabindex="-1" aria-disabled="true"' : ''}>
                                    <i class="fas fa-chevron-left"></i>
                                </a>
                            </li>

                            <!-- Hiển thị các số trang -->
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <li class="page-item ${currentPage == i ? 'active' : ''}">
                                    <a class="page-link" href="customers?page=${i}">${i}</a>
                                </li>
                            </c:forEach>
                            <!-- Nút Next -->
                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                <a class="page-link" href="customers?page=${currentPage + 1}" ${currentPage == totalPages ? 'tabindex="-1" aria-disabled="true"' : ''}>
                                    <i class="fas fa-chevron-right"></i>
                                </a>
                            </li>
                        </ul>
                    </nav>
                </c:if>


            </div>
        </main>


        <!-- Modal Xem Chi tiết -->
        <div class="modal fade" id="viewUserModal" tabindex="-1" aria-labelledby="viewUserModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header bg-info text-white">
                        <h5 class="modal-title" id="viewUserModalLabel">
                            <i class="fas fa-user-circle me-2"></i>Chi Tiết Khách Hàng
                        </h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="customer-profile text-center mb-4">
                            <div class="avatar-circle mx-auto mb-3">
                                <i class="fas fa-user fa-3x"></i>
                            </div>
                            <h4 id="view-username" class="mb-1 fw-bold"></h4>
                            <p id="view-status" class="mb-0"></p>
                        </div>

                        <div class="customer-info">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="info-item d-flex border-bottom py-3">
                                        <div class="info-label col-5">
                                            <i class="fas fa-id-card me-2 text-secondary"></i>
                                            <span class="fw-bold">ID:</span>
                                        </div>
                                        <div class="info-value col-7" id="view-id"></div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="info-item d-flex border-bottom py-3">
                                        <div class="info-label col-5">
                                            <i class="fas fa-envelope me-2 text-secondary"></i>
                                            <span class="fw-bold">Email:</span>
                                        </div>
                                        <div class="info-value col-7" id="view-email"></div>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6">
                                    <div class="info-item d-flex py-3">
                                        <div class="info-label col-5">
                                            <i class="fas fa-phone me-2 text-secondary"></i>
                                            <span class="fw-bold">Số điện thoại:</span>
                                        </div>
                                        <div class="info-value col-7" id="view-phone"></div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="info-item d-flex py-3">
                                        <div class="info-label col-5">
                                            <i class="fas fa-calendar me-2 text-secondary"></i>
                                            <span class="fw-bold">Ngày tạo:</span>
                                        </div>
                                        <div class="info-value col-7">
                                            <span class="text-muted">Chưa cập nhật</span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                            <i class="fas fa-times me-1"></i>Đóng
                        </button>
                    </div>
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
            let allCustomers = [];
            let filteredCustomers = [];

            // Khởi tạo dữ liệu khi trang load
            document.addEventListener('DOMContentLoaded', function () {
                initializeCustomerData();
                updateStatistics();
                setupEventListeners();

                // Tự động ẩn thông báo sau 3 giây
                const alerts = document.querySelectorAll('.alert');
                alerts.forEach(function (alert) {
                    setTimeout(function () {
                        const bsAlert = new bootstrap.Alert(alert);
                        bsAlert.close();
                    }, 3000);
                });
            });
            
            function paginateResults() {
                const pageSize = 5; // Số lượng user mỗi trang
                const currentPage = parseInt(new URLSearchParams(window.location.search).get('page')) || 1;

                // Chỉ áp dụng khi đang lọc
                if (document.getElementById('searchInput').value ||
                        document.getElementById('statusFilter').value) {

                    // Tính toán chỉ mục bắt đầu và kết thúc
                    const startIndex = (currentPage - 1) * pageSize;
                    const endIndex = startIndex + pageSize;

                    // Hiển thị chỉ những user thuộc trang hiện tại
                    filteredCustomers.forEach((customer, index) => {
                        if (index >= startIndex && index < endIndex) {
                            customer.element.style.display = '';
                        } else {
                            customer.element.style.display = 'none';
                        }
                    });

                    // Cập nhật phân trang
                    updatePagination(filteredCustomers.length, pageSize, currentPage);
                }
            }

            // Cập nhật UI phân trang
            function updatePagination(totalItems, pageSize, currentPage) {
                const totalPages = Math.ceil(totalItems / pageSize);
                const paginationContainer = document.querySelector('nav[aria-label="Page navigation"]');

                if (!paginationContainer)
                    return;

                const pagination = document.createElement('ul');
                pagination.className = 'pagination justify-content-center';

                // Nút Previous
                const prevLi = document.createElement('li');
                prevLi.className = `page-item ${currentPage == 1 ? 'disabled' : ''}`;
                prevLi.innerHTML = `
                    <a class="page-link" href="customers?page=${currentPage - 1}" aria-label="Previous">
                        <span aria-hidden="true"><i class="fas fa-chevron-left"></i></span>
                    </a>
                `;
                pagination.appendChild(prevLi);

                // Hiển thị các số trang
                const startPage = Math.max(1, currentPage - 2);
                const endPage = Math.min(totalPages, currentPage + 2);

                // Trang đầu và dấu ...
                if (startPage > 1) {
                    const firstLi = document.createElement('li');
                    firstLi.className = 'page-item';
                    firstLi.innerHTML = `<a class="page-link" href="customers?page=1">1</a>`;
                    pagination.appendChild(firstLi);

                    if (startPage > 2) {
                        const ellipsisLi = document.createElement('li');
                        ellipsisLi.className = 'page-item disabled';
                        ellipsisLi.innerHTML = `<span class="page-link">...</span>`;
                        pagination.appendChild(ellipsisLi);
                    }
                }

                // Các trang giữa
                for (let i = startPage; i <= endPage; i++) {
                    const pageLi = document.createElement('li');
                    pageLi.className = `page-item ${currentPage == i ? 'active' : ''}`;
                    pageLi.innerHTML = `<a class="page-link" href="customers?page=${i}">${i}</a>`;
                    pagination.appendChild(pageLi);
                }

                // Trang cuối và dấu ...
                if (endPage < totalPages) {
                    if (endPage < totalPages - 1) {
                        const ellipsisLi = document.createElement('li');
                        ellipsisLi.className = 'page-item disabled';
                        ellipsisLi.innerHTML = `<span class="page-link">...</span>`;
                        pagination.appendChild(ellipsisLi);
                    }

                    const lastLi = document.createElement('li');
                    lastLi.className = 'page-item';
                    lastLi.innerHTML = `<a class="page-link" href="customers?page=${totalPages}">${totalPages}</a>`;
                    pagination.appendChild(lastLi);
                }

                // Nút Next
                const nextLi = document.createElement('li');
                nextLi.className = `page-item ${currentPage == totalPages ? 'disabled' : ''}`;
                nextLi.innerHTML = `
                    <a class="page-link" href="customers?page=${currentPage + 1}" aria-label="Next">
                        <span aria-hidden="true"><i class="fas fa-chevron-right"></i></span>
                    </a>
                `;
                pagination.appendChild(nextLi);

                // Thay thế phân trang cũ
                paginationContainer.innerHTML = '';
                paginationContainer.appendChild(pagination);

                // Thêm sự kiện click cho các liên kết phân trang
                document.querySelectorAll('.pagination .page-link').forEach(link => {
                    link.addEventListener('click', function (e) {
                        if (!this.parentElement.classList.contains('disabled')) {
                            e.preventDefault();
                            const href = this.getAttribute('href');
                            const pageNum = new URLSearchParams(href.substring(href.indexOf('?'))).get('page');
                            if (pageNum) {
                                window.history.pushState({}, '', `customers?page=${pageNum}`);
                                applyFilters();
                            }
                        }
                    });
                });
            }

            // Sửa hàm applyFilters để gọi paginateResults
            function applyFilters() {
                const searchTerm = document.getElementById('searchInput').value.toLowerCase();
                const statusFilter = document.getElementById('statusFilter').value;
                const sortFilter = document.getElementById('sortFilter').value;

                // Filter customers
                filteredCustomers = allCustomers.filter(customer => {
                    // Search filter
                    const matchesSearch = !searchTerm ||
                            customer.username.toLowerCase().includes(searchTerm) ||
                            customer.email.toLowerCase().includes(searchTerm) ||
                            (customer.phone && customer.phone.toLowerCase().includes(searchTerm));

                    // Status filter
                    const matchesStatus = !statusFilter || customer.status === statusFilter;

                    return matchesSearch && matchesStatus;
                });

                // Sort customers
                sortCustomers(sortFilter);

                // Update display
                updateTableDisplay();
                updateStatistics();
                updateTableCount();

                // Áp dụng phân trang
                paginateResults();
            }
            
            // Khởi tạo dữ liệu khách hàng
            function initializeCustomerData() {
                const rows = document.querySelectorAll('.customer-row');
                allCustomers = [];

                rows.forEach(row => {
                    const customer = {
                        id: parseInt(row.dataset.id),
                        username: row.dataset.username,
                        email: row.dataset.email,
                        phone: row.dataset.phone,
                        status: row.dataset.status,
                        hasPhone: row.dataset.hasPhone,
                        element: row
                    };
                    allCustomers.push(customer);
                });

                filteredCustomers = [...allCustomers];
                updateTableCount();
            }

            // Setup event listeners
            function setupEventListeners() {
                // Search input
                const searchInput = document.getElementById('searchInput');
                searchInput.addEventListener('input', debounce(handleSearch, 300));

                // Clear search button
                searchInput.addEventListener('input', function () {
                    const clearBtn = document.querySelector('.clear-search');
                    if (this.value.length > 0) {
                        clearBtn.style.display = 'block';
                    } else {
                        clearBtn.style.display = 'none';
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
                const searchTerm = document.getElementById('searchInput').value.toLowerCase();
                applyFilters();
            }

            // Sort customers
            function sortCustomers(sortType) {
                switch (sortType) {
                    case 'id-asc':
                        filteredCustomers.sort((a, b) => a.id - b.id);
                        break;
                    case 'id-desc':
                        filteredCustomers.sort((a, b) => b.id - a.id);
                        break;
                    case 'name-asc':
                        filteredCustomers.sort((a, b) => a.username.localeCompare(b.username));
                        break;
                    case 'name-desc':
                        filteredCustomers.sort((a, b) => b.username.localeCompare(a.username));
                        break;
                    case 'email-asc':
                        filteredCustomers.sort((a, b) => a.email.localeCompare(b.email));
                        break;
                    case 'email-desc':
                        filteredCustomers.sort((a, b) => b.email.localeCompare(a.email));
                        break;
                    default:
                        filteredCustomers.sort((a, b) => a.id - b.id);
                }
            }

            // Update table display
            function updateTableDisplay() {
                const tbody = document.getElementById('customersTableBody');
                const noResults = document.getElementById('noResults');

                // Hide all rows first
                allCustomers.forEach(customer => {
                    customer.element.style.display = 'none';
                });

                if (filteredCustomers.length === 0) {
                    noResults.style.display = 'block';
                } else {
                    noResults.style.display = 'none';

                    // Show filtered rows in correct order
                    filteredCustomers.forEach((customer, index) => {
                        customer.element.style.display = '';
                        // Reorder elements
                        tbody.appendChild(customer.element);
                    });
                }
            }

            // Update statistics
            function updateStatistics() {
                const totalCustomers = allCustomers.length;
                const activeCustomers = allCustomers.filter(c => c.status === 'active').length;
                const inactiveCustomers = allCustomers.filter(c => c.status === 'inactive').length;
                const filteredCount = filteredCustomers.length;

                document.getElementById('total-customers').textContent = totalCustomers;
                document.getElementById('active-customers').textContent = activeCustomers;
                document.getElementById('inactive-customers').textContent = inactiveCustomers;
                document.getElementById('filtered-count').textContent = filteredCount;
            }

            // Update table count
            function updateTableCount() {
                const count = filteredCustomers.length;
                const countText = count === 1 ? '1 khách hàng' : `${count} khách hàng`;
                document.getElementById('table-count').textContent = countText;
            }

            // Toggle advanced filter
            function toggleAdvancedFilter() {
                const advancedFilters = document.getElementById('advancedFilters');
                const icon = document.getElementById('filter-toggle-icon');
                const text = document.getElementById('filter-toggle-text');

                if (advancedFilters.style.display === 'none') {
                    advancedFilters.style.display = 'block';
                    icon.className = 'fas fa-chevron-up';
                    text.textContent = 'Ẩn bộ lọc';
                } else {
                    advancedFilters.style.display = 'none';
                    icon.className = 'fas fa-chevron-down';
                    text.textContent = 'Hiển thị bộ lọc';
                }
            }

            // Clear search
            function clearSearch() {
                document.getElementById('searchInput').value = '';
                document.querySelector('.clear-search').style.display = 'none';
                applyFilters();
            }

            // Reset all filters
            function resetAllFilters() {
                document.getElementById('searchInput').value = '';
                document.getElementById('statusFilter').value = '';
                document.getElementById('sortFilter').value = 'id-asc';
                document.querySelector('.clear-search').style.display = 'none';

                applyFilters();

                // Show success message
                showToast('Thành công', 'Đã reset tất cả bộ lọc', 'success');
            }

            // Hàm xem chi tiết khách hàng
            function viewUser(id, username, email, phone, role, roleText, isActive) {
                document.getElementById('view-id').textContent = id;
                document.getElementById('view-username').textContent = username;
                document.getElementById('view-email').textContent = email;
                document.getElementById('view-phone').textContent = phone || 'Chưa cập nhật';

                // Hiển thị trạng thái
                let statusText = isActive ? 'Hoạt động' : 'Vô hiệu hóa';
                let statusClass = isActive ? 'text-success' : 'text-danger';

                let statusElement = document.getElementById('view-status');
                statusElement.textContent = statusText;
                statusElement.className = statusClass;
            }

            // Hàm chỉnh sửa khách hàng
           

            // Hiển thị toast notification
            function showToast(title, message, type) {
                let toastContainer = document.getElementById('toast-container');
                if (!toastContainer) {
                    toastContainer = document.createElement('div');
                    toastContainer.id = 'toast-container';
                    toastContainer.className = 'toast-container position-fixed bottom-0 end-0 p-3';
                    document.body.appendChild(toastContainer);
                }

                const toastId = 'toast-' + Date.now();
                const toastHTML = `
                    <div id="${toastId}" class="toast align-items-center text-white bg-${type} border-0" role="alert" aria-live="assertive" aria-atomic="true">
                        <div class="d-flex">
                            <div class="toast-body">
                                <strong>${title}</strong>: ${message}
                            </div>
                            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
                        </div>
                    </div>
                `;

                toastContainer.insertAdjacentHTML('beforeend', toastHTML);
                const toastElement = document.getElementById(toastId);
                const toast = new bootstrap.Toast(toastElement, {delay: 5000});
                toast.show();
            }

           
            // Validation form chỉnh sửa khách hàng
           

            // Xác nhận trước khi vô hiệu hóa/kích hoạt tài khoản
            document.querySelectorAll('a[href*="action=toggle"]').forEach(function (link) {
                link.addEventListener('click', function (e) {
                    const isActivating = this.href.includes('status=false');
                    const action = isActivating ? 'kích hoạt lại' : 'vô hiệu hóa';
                    const confirmMessage = `Bạn có chắc chắn muốn ${action} tài khoản này?`;

                    if (!confirm(confirmMessage)) {
                        e.preventDefault();
                    }
                });
            });

           

            // Hiệu ứng loading khi submit form
            document.querySelectorAll('form').forEach(function (form) {
                form.addEventListener('submit', function () {
                    const submitBtn = this.querySelector('button[type="submit"]');
                    if (submitBtn) {
                        const originalText = submitBtn.innerHTML;

                        submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-1"></i>Đang xử lý...';
                        submitBtn.disabled = true;

                        // Khôi phục lại nút sau 3 giây (phòng trường hợp lỗi)
                        setTimeout(function () {
                            submitBtn.innerHTML = originalText;
                            submitBtn.disabled = false;
                        }, 3000);
                    }
                });
            });

            // Keyboard shortcuts
            document.addEventListener('keydown', function (e) {
                // Ctrl + F để focus vào search
                if (e.ctrlKey && e.key === 'f') {
                    e.preventDefault();
                    document.getElementById('searchInput').focus();
                }

                // Esc để clear search
                if (e.key === 'Escape') {
                    if (document.getElementById('searchInput').value) {
                        clearSearch();
                    }
                }
            });

            // Export functions (có thể thêm sau)
            function exportToCSV() {
                // Implementation for CSV export
                showToast('Thông báo', 'Chức năng xuất CSV đang được phát triển', 'info');
            }

            function exportToPDF() {
                // Implementation for PDF export
                showToast('Thông báo', 'Chức năng xuất PDF đang được phát triển', 'info');
            }
        </script>
    </body>
</html>
