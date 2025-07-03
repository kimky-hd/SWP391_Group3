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
        }
    </style>

    <body>
        <div id="toast-container" class="toast-container position-fixed bottom-0 end-0 p-3"></div>

        <!-- Topbar -->
        <nav class="navbar navbar-expand-lg topbar">
            <div class="container-fluid px-4">
                <a class="topbar-brand" href="#">
                    <i class="fas fa-flower me-2"></i>Bán Hoa
                </a>

                <div class="d-flex align-items-center">
                    <div class="topbar-search me-4">
                        <input type="text" class="form-control" placeholder="Tìm kiếm...">
                        <i class="fas fa-search"></i>
                    </div>

                    <ul class="navbar-nav topbar-actions">
                        <li class="nav-item">
                            <a class="nav-link" href="#" title="Thông báo">
                                <i class="fas fa-bell"></i>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#" title="Cài đặt">
                                <i class="fas fa-cog"></i>
                            </a>
                        </li>
                        <!-- User Dropdown -->
                        <li class="nav-item dropdown">
                            <% if(session.getAttribute("account") != null) { 
                                Account acc = (Account)session.getAttribute("account");
                            %>
                            <a class="nav-link dropdown-toggle user-dropdown" href="#" id="userDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                <img src="${pageContext.request.contextPath}/img/user.jpg" alt="user" class="rounded-circle me-2" width="32" height="32">
                                <%= acc.getUsername() %>
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end admin-dropdown" aria-labelledby="userDropdown">
                                <li>
                                    <button type="button" class="dropdown-item logout-btn" data-bs-toggle="modal" data-bs-target="#logoutModal">
                                        <i class="fas fa-sign-out-alt me-2"></i>Đăng xuất
                                    </button>
                                </li>
                            </ul>
                            <% } else { %>
                            <a class="nav-link" href="login.jsp">
                                <i class="fas fa-sign-in-alt me-2"></i>Đăng nhập
                            </a>
                            <% } %>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>

        <!-- Include Sidebar và Logout Modal -->
        <jsp:include page="/admin/sidebar.jsp">
            <jsp:param name="currentPage" value="customers" />
        </jsp:include>

        <!-- Main Content -->
        <main class="main-content">
            <div class="container-fluid">
                <!-- Header -->
                <div class="d-sm-flex align-items-center justify-content-between mb-4">
                    <div>
                        <h1 class="h3 mb-0 text-gray-800">
                            <i class="fas fa-users me-2"></i>Quản Lý Người Dùng
                        </h1>
                        <p class="mb-0 text-muted">Quản lý thông tin khách hàng và tài khoản người dùng</p>
                    </div>
                    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addCustomerModal">
                        <i class="fas fa-plus me-2"></i>Thêm Người Dùng
                    </button>
                </div>

                <!-- Thông báo -->
                <c:if test="${not empty message}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle me-2"></i>${message}
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-circle me-2"></i>${error}
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <!-- Bảng danh sách khách hàng -->
                <div class="card">
                    <div class="card-header">
                        <i class="fas fa-table me-2"></i>Danh sách Người Dùng
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Tên đăng nhập</th>
                                        <th>Email</th>
                                        <th>Số điện thoại</th>
                                        <th>Vai trò</th>
                                        <th>Trạng thái</th>
                                        <th>Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="user" items="${users}">
                                        <tr>
                                            <td><span class="fw-bold">${user.accountID}</span></td>
                                            <td>
                                                <div class="d-flex align-items-center">
                                                    <div class="avatar-sm me-2">
                                                        <div class="rounded-circle bg-primary d-flex align-items-center justify-content-center" style="width: 35px; height: 35px;">
                                                            <i class="fas ${user.role == 2 ? 'fa-user-tie' : 'fa-user'} text-white"></i>
                                                        </div>
                                                    </div>
                                                    <span class="fw-bold">${user.username}</span>
                                                </div>
                                            </td>
                                            <td>${user.email}</td>
                                            <td>${user.phone != null ? user.phone : '<span class="text-muted">Chưa cập nhật</span>'}</td>
                                            <td>
                                                <!-- Hiển thị role -->
                                                <span class="badge ${user.roleClass}">
                                                    <i class="fas ${user.role == 2 ? 'fa-user-tie' : 'fa-user'} me-1"></i>
                                                    ${user.roleText}
                                                </span>
                                            </td>
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
                                                            onclick="viewUser(${user.accountID}, '${user.username}', '${user.email}', '${user.phone}', ${user.role}, '${user.roleText}', ${user.isActive})" 
                                                            data-bs-toggle="modal" 
                                                            data-bs-target="#viewUserModal"
                                                            title="Xem chi tiết">
                                                        <i class="fas fa-eye"></i>
                                                    </button>
                                                    <button class="btn btn-sm btn-primary" 
                                                            onclick="editUser(${user.accountID}, '${user.username}', '${user.email}', '${user.phone}', ${user.role})" 
                                                            data-bs-toggle="modal" 
                                                            data-bs-target="#editUserModal"
                                                            title="Chỉnh sửa">
                                                        <i class="fas fa-edit"></i>
                                                    </button>
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
                                    </c:forEach>
                                    <c:if test="${empty users}">
                                        <tr>
                                            <td colspan="7" class="text-center py-4">
                                                <i class="fas fa-users fa-3x text-muted mb-3"></i>
                                                <p class="text-muted mb-0">Không có dữ liệu người dùng</p>
                                            </td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Phân trang -->
                <c:if test="${totalPages > 1}">
                    <nav aria-label="Page navigation" class="mt-4">
                        <ul class="pagination justify-content-center">
                            <c:if test="${currentPage > 1}">
                                <li class="page-item">
                                    <a class="page-link" href="customers?page=${currentPage - 1}" aria-label="Previous">
                                        <span aria-hidden="true"><i class="fas fa-chevron-left"></i></span>
                                    </a>
                                </li>
                            </c:if>

                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <li class="page-item ${currentPage == i ? 'active' : ''}">
                                    <a class="page-link" href="customers?page=${i}">${i}</a>
                                </li>
                            </c:forEach>

                            <c:if test="${currentPage < totalPages}">
                                <li class="page-item">
                                    <a class="page-link" href="customers?page=${currentPage + 1}" aria-label="Next">
                                        <span aria-hidden="true"><i class="fas fa-chevron-right"></i></span>
                                    </a>
                                </li>
                            </c:if>
                        </ul>
                    </nav>
                </c:if>
            </div>
        </main>

        <!-- Modal Thêm người dùng -->
        <div class="modal fade" id="addCustomerModal" tabindex="-1" aria-labelledby="addCustomerModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header bg-primary text-white">
                        <h5 class="modal-title" id="addCustomerModalLabel">
                            <i class="fas fa-user-plus me-2"></i>Thêm người dùng mới
                        </h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <form action="customers" method="post" id="addCustomerForm">
                        <div class="modal-body">
                            <input type="hidden" name="action" value="add">

                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="username" class="form-label">
                                            <i class="fas fa-user me-1"></i>Tên đăng nhập <span class="text-danger">*</span>
                                        </label>
                                        <input type="text" class="form-control" id="username" name="username" required>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="password" class="form-label">
                                            <i class="fas fa-lock me-1"></i>Mật khẩu <span class="text-danger">*</span>
                                        </label>
                                        <input type="password" class="form-control" id="password" name="password" required>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="email" class="form-label">
                                            <i class="fas fa-envelope me-1"></i>Email <span class="text-danger">*</span>
                                        </label>
                                        <input type="email" class="form-control" id="email" name="email" required>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="phone" class="form-label">
                                            <i class="fas fa-phone me-1"></i>Số điện thoại
                                        </label>
                                        <input type="text" class="form-control" id="phone" name="phone">
                                    </div>
                                </div>
                            </div>

                            <!-- Thêm trường chọn vai trò -->
                            <div class="row">
                                <div class="col-md-12">
                                    <div class="mb-3">
                                        <label for="role" class="form-label">
                                            <i class="fas fa-user-tag me-1"></i>Vai trò <span class="text-danger">*</span>
                                        </label>
                                        <select class="form-control" id="role" name="role" required>
                                            <option value="">Chọn vai trò</option>
                                            <option value="0">Khách hàng</option>
                                            <option value="2">Quản lý</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                                <i class="fas fa-times me-1"></i>Đóng
                            </button>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save me-1"></i>Lưu
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Modal Xem Chi tiết -->
        <div class="modal fade" id="viewUserModal" tabindex="-1" aria-labelledby="viewUserModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header bg-info text-white">
                        <h5 class="modal-title" id="viewUserModalLabel">
                            <i class="fas fa-user-circle me-2"></i>Chi Tiết Người Dùng
                        </h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="customer-profile text-center mb-4">
                            <div class="avatar-circle mx-auto mb-3">
                                <i id="view-role-icon" class="fas fa-user fa-3x"></i>
                            </div>
                            <h4 id="view-username" class="mb-1 fw-bold"></h4>
                            <p id="view-role-badge" class="mb-0"></p>
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


        <!-- Modal Chỉnh sửa -->
        <div class="modal fade" id="editUserModal" tabindex="-1" aria-labelledby="editUserModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="editUserModalLabel">Chỉnh Sửa Người Dùng</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <form action="customers" method="post">
                        <div class="modal-body">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" id="edit-id" name="id">

                            <div class="mb-3">
                                <label for="edit-username" class="form-label">Tên đăng nhập</label>
                                <input type="text" class="form-control" id="edit-username" name="username" required>
                            </div>

                            <div class="mb-3">
                                <label for="edit-email" class="form-label">Email</label>
                                <input type="email" class="form-control" id="edit-email" name="email" required>
                            </div>

                            <div class="mb-3">
                                <label for="edit-phone" class="form-label">Số điện thoại</label>
                                <input type="text" class="form-control" id="edit-phone" name="phone">
                            </div>

                            <!-- Thêm trường chọn vai trò -->
                            <div class="mb-3">
                                <label for="edit-role" class="form-label">Vai trò</label>
                                <select class="form-control" id="edit-role" name="role" required>
                                    <option value="0">Khách hàng</option>
                                    <option value="2">Quản lý</option>
                                </select>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                            <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
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
                                                               // Hàm xem chi tiết khách hàng
                                                               function viewUser(id, username, email, phone, role, roleText, isActive) {
                                                                   document.getElementById('view-id').textContent = id;
                                                                   document.getElementById('view-username').textContent = username;
                                                                   document.getElementById('view-email').textContent = email;
                                                                   document.getElementById('view-phone').textContent = phone || 'Chưa cập nhật';

                                                                   // Hiển thị role
                                                                   const roleIcon = document.getElementById('view-role-icon');
                                                                   const roleBadge = document.getElementById('view-role-badge');

                                                                   if (role == 2) {
                                                                       roleIcon.className = 'fas fa-user-tie fa-3x';
                                                                       roleBadge.innerHTML = '<span class="badge bg-warning text-dark"><i class="fas fa-user-tie me-1"></i>' + roleText + '</span>';
                                                                   } else {
                                                                       roleIcon.className = 'fas fa-user fa-3x';
                                                                       roleBadge.innerHTML = '<span class="badge bg-info"><i class="fas fa-user me-1"></i>' + roleText + '</span>';
                                                                   }

                                                                   // Hiển thị trạng thái
                                                                   let statusText = isActive ? 'Hoạt động' : 'Vô hiệu hóa';
                                                                   let statusClass = isActive ? 'text-success' : 'text-danger';

                                                                   let statusElement = document.getElementById('view-status');
                                                                   statusElement.textContent = statusText;
                                                                   statusElement.className = statusClass;
                                                               }

// Hàm chỉnh sửa người dùng
                                                               function editUser(id, username, email, phone, role) {
                                                                   document.getElementById('edit-id').value = id;
                                                                   document.getElementById('edit-username').value = username;
                                                                   document.getElementById('edit-email').value = email;
                                                                   document.getElementById('edit-phone').value = phone || '';
                                                                   document.getElementById('edit-role').value = role;
                                                               }

                                                               // Hiển thị thông báo sau khi thêm/cập nhật
                                                               document.addEventListener('DOMContentLoaded', function () {
                                                                   // Tự động ẩn thông báo sau 2 giây
                                                                   const alerts = document.querySelectorAll('.alert');
                                                                   alerts.forEach(function (alert) {
                                                                       setTimeout(function () {
                                                                           const bsAlert = new bootstrap.Alert(alert);
                                                                           bsAlert.close();
                                                                       }, 2000);
                                                                   });

                                                                   // Hiển thị thông báo sau khi submit form
                                                                   const forms = document.querySelectorAll('form');
                                                                   forms.forEach(function (form) {
                                                                       form.addEventListener('submit', function () {
                                                                           // Lưu thông tin form đang submit để hiển thị thông báo phù hợp
                                                                           sessionStorage.setItem('formSubmitted', this.querySelector('input[name="action"]').value);
                                                                       });
                                                                   });

                                                                   // Hiển thị toast notification nếu có thông báo từ server
                                                                   const formAction = sessionStorage.getItem('formSubmitted');
                                                                   if (formAction) {
                                                                       const successMessage = document.querySelector('.alert-success');
                                                                       const errorMessage = document.querySelector('.alert-danger');

                                                                       if (successMessage) {
                                                                           showToast('Thành công', successMessage.textContent, 'success');
                                                                       } else if (errorMessage) {
                                                                           showToast('Lỗi', errorMessage.textContent, 'danger');
                                                                       } else if (formAction === 'add') {
                                                                           showToast('Thành công', 'Thêm khách hàng thành công', 'success');
                                                                       } else if (formAction === 'update') {
                                                                           showToast('Thành công', 'Cập nhật khách hàng thành công', 'success');
                                                                       }

                                                                       // Xóa thông tin đã lưu
                                                                       sessionStorage.removeItem('formSubmitted');
                                                                   }
                                                               });

                                                               // Hiển thị toast notification
                                                               function showToast(title, message, type) {
                                                                   const toastContainer = document.getElementById('toast-container');
                                                                   if (!toastContainer) {
                                                                       const container = document.createElement('div');
                                                                       container.id = 'toast-container';
                                                                       container.className = 'toast-container position-fixed bottom-0 end-0 p-3';
                                                                       document.body.appendChild(container);
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

                                                                   document.getElementById('toast-container').insertAdjacentHTML('beforeend', toastHTML);
                                                                   const toastElement = document.getElementById(toastId);
                                                                   const toast = new bootstrap.Toast(toastElement, {delay: 5000});
                                                                   toast.show();
                                                               }
        </script>
    </body>
</html>
