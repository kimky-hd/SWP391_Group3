<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="Model.Account" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản lý Voucher - Admin Dashboard</title>
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <!-- jQuery -->
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <!-- Flatpickr for datetime picker -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
        <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    </head>

    <style>
        /* Giữ nguyên tất cả CSS cũ */
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

        .main-content {
            margin-left: 250px;
            margin-top: 60px;
            padding: 30px;
            min-height: calc(100vh - 60px);
            background-color: #f8f9fa;
        }

        .page-title {
            color: #5a5c69;
            font-weight: 700;
            margin-bottom: 0.5rem;
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

        .card-body {
            padding: 1.5rem;
        }

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

        .admin-modal {
            border: none;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }

        .admin-modal .modal-header {
            border-top-left-radius: 15px;
            border-top-right-radius: 15px;
            border-bottom: none;
        }

        .admin-modal .btn-danger {
            background: linear-gradient(45deg, #dc3545, #c82333);
            border: none;
            transition: all 0.3s ease;
        }

        .admin-modal .btn-danger:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(220, 53, 69, 0.4);
        }

        /* CSS mới cho ngày tạo */
        .created-date {
            font-size: 0.8rem;
            color: #6c757d;
            font-style: italic;
        }

        .table-responsive {
            overflow-x: auto;
        }

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
        <!-- Include Sidebar và Logout Modal -->
        <jsp:include page="../manager_topbarsidebar.jsp" />

        <!-- Main Content -->
        <main class="main-content">
            <div class="container-fluid">
                <!-- Header -->
                <div class="d-sm-flex align-items-center justify-content-between mb-4">
                    <div>
                        <h1 class="h3 mb-0 text-gray-800">
                            <i class="fas fa-percent me-2"></i>Quản Lý Voucher
                        </h1>
                        <p class="mb-0 text-muted">Quản lý mã giảm giá và khuyến mãi</p>
                    </div>
                    <div>

                        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addVoucherModal">
                            <i class="fas fa-plus me-2"></i>Thêm Voucher mới
                        </button>
                    </div>
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
                <%
                    session.removeAttribute("message");
                    session.removeAttribute("error");
                %>

                <!-- Danh sách Voucher -->
                <div class="card">
                    <div class="card-header">
                        <i class="fas fa-list me-2"></i>Danh sách Voucher
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Mã Voucher</th>
                                        <th>Giảm giá</th>
                                        <th>Đơn tối thiểu</th>
                                        <th>Thời gian hiệu lực</th>
                                        <th>Ngày tạo</th>
                                        <th>Trạng thái</th>
                                        <th>Đã dùng/Giới hạn</th>
                                        <th>Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${vouchers}" var="voucher">
                                        <tr>
                                            <td><span class="fw-bold">${voucher.voucherId}</span></td>
                                            <td><strong>${voucher.code}</strong></td>
                                            <td><fmt:formatNumber value="${voucher.discountAmount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td>
                                            <td><fmt:formatNumber value="${voucher.minOrderValue}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td>
                                            <td>
                                                <small>
                                                    <fmt:formatDate value="${voucher.startDate}" pattern="dd/MM/yyyy HH:mm" /> - 
                                                    <fmt:formatDate value="${voucher.endDate}" pattern="dd/MM/yyyy HH:mm" />
                                                </small>
                                            </td>
                                            <td>
                                                <div class="created-date">
                                                    <i class="fas fa-calendar-plus me-1"></i>
                                                    <fmt:formatDate value="${voucher.createdDate}" pattern="dd/MM/yyyy HH:mm" />
                                                </div>
                                            </td>
                                            <td>
   <c:choose>
    <%-- Hết hạn --%>
    <c:when test="${voucher.isExpired()}">
        <span class="badge bg-danger">
            <i class="fas fa-times-circle me-1"></i>Hết hạn
        </span>
    </c:when>
    <%-- Chưa hiệu lực --%>
    <c:when test="${voucher.isNotStarted()}">
        <span class="badge bg-warning text-dark">
            <i class="fas fa-hourglass-start me-1"></i>Chưa hiệu lực
        </span>
    </c:when>
    <%-- Trong thời gian hiệu lực và hoạt động --%>
    <c:when test="${voucher.isActive()}">
        <span class="badge bg-success">
            <i class="fas fa-check-circle me-1"></i>Hoạt động
        </span>
    </c:when>
    <%-- Trong thời gian hiệu lực nhưng vô hiệu hóa --%>
    <c:otherwise>
        <span class="badge bg-secondary">
            <i class="fas fa-ban me-1"></i>Vô hiệu hóa
        </span>
    </c:otherwise>
</c:choose>

                                            </td>
                                            <td>${voucher.usedCount}/${voucher.usageLimit}</td>
                                            <td>
                                                <div>
                                                    <button class="btn btn-sm btn-info view-btn me-2" data-id="${voucher.voucherId}" title="Xem chi tiết">
                                                        <i class="fas fa-eye"></i>
                                                    </button>
                                                    <button class="btn btn-sm btn-primary edit-btn me-2" data-id="${voucher.voucherId}" title="Chỉnh sửa">
                                                        <i class="fas fa-edit"></i>
                                                    </button>
                                                    <button class="btn btn-sm ${voucher.isActive() ? 'btn-warning' : 'btn-success'} toggle-btn" 
                                                            data-id="${voucher.voucherId}" 
                                                            data-status="${voucher.isActive()}"
                                                            title="${voucher.isActive() ? 'Vô hiệu hóa' : 'Kích hoạt'}">
                                                        <i class="fas ${voucher.isActive() ? 'fa-ban' : 'fa-check'}"></i>
                                                    </button>
                                                </div>
                                            </td>

                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty vouchers}">
                                        <tr>
                                            <td colspan="9" class="text-center py-4">
                                                <i class="fas fa-percent fa-3x text-muted mb-3"></i>
                                                <p class="text-muted mb-0">Không có dữ liệu voucher</p>
                                            </td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>

                        <!-- Phân trang -->
                        <c:if test="${totalPages > 1}">
                            <nav aria-label="Page navigation" class="mt-4">
                                <ul class="pagination justify-content-center">
                                    <c:if test="${currentPage > 1}">
                                        <li class="page-item">
                                            <a class="page-link" href="vouchers?page=${currentPage - 1}" aria-label="Previous">
                                                <span aria-hidden="true"><i class="fas fa-chevron-left"></i></span>
                                            </a>
                                        </li>
                                    </c:if>

                                    <c:forEach begin="1" end="${totalPages}" var="i">
                                        <li class="page-item ${currentPage == i ? 'active' : ''}">
                                            <a class="page-link" href="vouchers?page=${i}">${i}</a>
                                        </li>
                                    </c:forEach>

                                    <c:if test="${currentPage < totalPages}">
                                        <li class="page-item">
                                            <a class="page-link" href="vouchers?page=${currentPage + 1}" aria-label="Next">
                                                <span aria-hidden="true"><i class="fas fa-chevron-right"></i></span>
                                            </a>
                                        </li>
                                    </c:if>
                                </ul>
                            </nav>
                        </c:if>
                    </div>
                </div>
            </div>
        </main>

        <!-- Modal Thêm Voucher -->
        <div class="modal fade" id="addVoucherModal" tabindex="-1" aria-labelledby="addVoucherModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header bg-primary text-white">
                        <h5 class="modal-title" id="addVoucherModalLabel">
                            <i class="fas fa-plus-circle me-2"></i>Thêm Voucher mới
                        </h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <form action="vouchers" method="post">
                        <input type="hidden" name="action" value="add">
                        <div class="modal-body">
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="code" class="form-label">Mã Voucher <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="code" name="code" required>
                                </div>
                                <div class="col-md-6">
                                    <label for="discountAmount" class="form-label">Giá trị giảm (VNĐ) <span class="text-danger">*</span></label>
                                    <input type="number" class="form-control" id="discountAmount" name="discountAmount" min="0" required>
                                </div>
                            </div>
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="minOrderValue" class="form-label">Giá trị đơn hàng tối thiểu (VNĐ) <span class="text-danger">*</span></label>
                                    <input type="number" class="form-control" id="minOrderValue" name="minOrderValue" min="0" required>
                                </div>
                                <div class="col-md-6">
                                    <label for="usageLimit" class="form-label">Giới hạn sử dụng <span class="text-danger">*</span></label>
                                    <input type="number" class="form-control" id="usageLimit" name="usageLimit" min="1" required>
                                </div>
                            </div>
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="startDate" class="form-label">Ngày bắt đầu <span class="text-danger">*</span></label>
                                    <input type="datetime-local" class="form-control datetime-picker" id="startDate" name="startDate" required>
                                </div>
                                <div class="col-md-6">
                                    <label for="endDate" class="form-label">Ngày kết thúc <span class="text-danger">*</span></label>
                                    <input type="datetime-local" class="form-control datetime-picker" id="endDate" name="endDate" required>
                                </div>
                            </div>
                            <div class="mb-3">
                                <label for="description" class="form-label">Mô tả</label>
                                <textarea class="form-control" id="description" name="description" rows="3" placeholder="Nhập mô tả cho voucher..."></textarea>
                            </div>
                            <div class="alert alert-info">
                                <i class="fas fa-info-circle me-2"></i>
                                <strong>Lưu ý:</strong> Ngày tạo voucher sẽ được tự động ghi nhận khi lưu.
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                                <i class="fas fa-times me-2"></i>Hủy
                            </button>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save me-2"></i>Lưu Voucher
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Modal Chỉnh sửa Voucher -->
        <div class="modal fade" id="editVoucherModal" tabindex="-1" aria-labelledby="editVoucherModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header bg-primary text-white">
                        <h5 class="modal-title" id="editVoucherModalLabel">
                            <i class="fas fa-edit me-2"></i>Chỉnh sửa Voucher
                        </h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <form action="vouchers" method="post" id="editVoucherForm">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="id" id="edit-id">
                        <div class="modal-body">
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="edit-code" class="form-label">Mã Voucher <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="edit-code" name="code" required>
                                </div>
                                <div class="col-md-6">
                                    <label for="edit-discountAmount" class="form-label">Giá trị giảm (VNĐ) <span class="text-danger">*</span></label>
                                    <input type="number" class="form-control" id="edit-discountAmount" name="discountAmount" min="0" required>
                                </div>
                            </div>
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="edit-minOrderValue" class="form-label">Giá trị đơn hàng tối thiểu (VNĐ) <span class="text-danger">*</span></label>
                                    <input type="number" class="form-control" id="edit-minOrderValue" name="minOrderValue" min="0" required>
                                </div>
                                <div class="col-md-6">
                                    <label for="edit-usageLimit" class="form-label">Giới hạn sử dụng <span class="text-danger">*</span></label>
                                    <input type="number" class="form-control" id="edit-usageLimit" name="usageLimit" min="1" required>
                                </div>
                            </div>
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="edit-startDate" class="form-label">Ngày bắt đầu <span class="text-danger">*</span></label>
                                    <input type="datetime-local" class="form-control datetime-picker" id="edit-startDate" name="startDate" required>
                                </div>
                                <div class="col-md-6">
                                    <label for="edit-endDate" class="form-label">Ngày kết thúc <span class="text-danger">*</span></label>
                                    <input type="datetime-local" class="form-control datetime-picker" id="edit-endDate" name="endDate" required>
                                </div>
                            </div>
                            <div class="mb-3">
                                <label for="edit-description" class="form-label">Mô tả</label>
                                <textarea class="form-control" id="edit-description" name="description" rows="3"></textarea>
                            </div>
                            <div class="row mb-3">
                                <div class="col-md-4">
                                    <label class="form-label">Số lần đã sử dụng</label>
                                    <input type="text" class="form-control" id="edit-usedCount" readonly>
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label">Trạng thái</label>
                                    <input type="text" class="form-control" id="edit-status" readonly>
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label">Ngày tạo</label>
                                    <input type="text" class="form-control" id="edit-createdDate" readonly>
                                </div>
                            </div>
                            <div class="alert alert-warning">
                                <i class="fas fa-exclamation-triangle me-2"></i>
                                <strong>Lưu ý:</strong> Ngày tạo voucher không thể thay đổi.
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                                <i class="fas fa-times me-2"></i>Hủy
                            </button>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save me-2"></i>Cập nhật
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Modal Xem chi tiết Voucher -->
        <div class="modal fade" id="viewVoucherModal" tabindex="-1" aria-labelledby="viewVoucherModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header bg-info text-white">
                        <h5 class="modal-title" id="viewVoucherModalLabel">
                            <i class="fas fa-info-circle me-2"></i>Chi tiết Voucher
                        </h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <h6 class="fw-bold text-primary">ID Voucher:</h6>
                                <p class="mb-0" id="view-id"></p>
                            </div>
                            <div class="col-md-6">
                                <h6 class="fw-bold text-primary">Mã Voucher:</h6>
                                <p class="mb-0" id="view-code"></p>
                            </div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <h6 class="fw-bold text-primary">Giá trị giảm:</h6>
                                <p class="mb-0 text-success fw-bold" id="view-discountAmount"></p>
                            </div>
                            <div class="col-md-6">
                                <h6 class="fw-bold text-primary">Giá trị đơn hàng tối thiểu:</h6>
                                <p class="mb-0" id="view-minOrderValue"></p>
                            </div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <h6 class="fw-bold text-primary">Thời gian bắt đầu:</h6>
                                <p class="mb-0" id="view-startDate"></p>
                            </div>
                            <div class="col-md-6">
                                <h6 class="fw-bold text-primary">Thời gian kết thúc:</h6>
                                <p class="mb-0" id="view-endDate"></p>
                            </div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <h6 class="fw-bold text-primary">Ngày tạo:</h6>
                                <p class="mb-0 text-info" id="view-createdDate">
                                    <i class="fas fa-calendar-plus me-1"></i>
                                    <span id="view-createdDate-text"></span>
                                </p>
                            </div>
                            <div class="col-md-6">
                                <h6 class="fw-bold text-primary">Trạng thái:</h6>
                                <p class="mb-0" id="view-status"></p>
                            </div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <h6 class="fw-bold text-primary">Sử dụng:</h6>
                                <p class="mb-0" id="view-usage"></p>
                            </div>
                            <div class="col-md-6">
                                <h6 class="fw-bold text-primary">Giới hạn sử dụng:</h6>
                                <p class="mb-0" id="view-usageLimit"></p>
                            </div>
                        </div>
                        <div class="mb-3">
                            <h6 class="fw-bold text-primary">Mô tả:</h6>
                            <p class="mb-0" id="view-description"></p>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                            <i class="fas fa-times me-2"></i>Đóng
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal Xác nhận thay đổi trạng thái -->
        <div class="modal fade" id="toggleStatusModal" tabindex="-1" aria-labelledby="toggleStatusModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content admin-modal">
                    <div class="modal-header bg-warning text-white">
                        <h5 class="modal-title" id="toggleStatusModalLabel">
                            <i class="fas fa-exclamation-triangle me-2"></i>Xác nhận thay đổi trạng thái
                        </h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body py-4 text-center">
                        <div class="mb-3">
                            <i class="fas fa-question-circle text-warning" style="font-size: 3rem;"></i>
                        </div>
                        <p class="mb-0" style="font-size: 1.1rem; color: #000000; font-weight: 600;" id="toggle-message">
                            Bạn có chắc chắn muốn thay đổi trạng thái của voucher này?
                        </p>
                    </div>
                    <div class="modal-footer justify-content-center border-0 pt-0">
                        <button type="button" class="btn btn-secondary px-4" data-bs-dismiss="modal">
                            <i class="fas fa-times me-2"></i>Hủy
                        </button>
                        <a id="toggle-confirm-btn" class="btn btn-warning px-4" href="#">
                            <i class="fas fa-check me-2"></i>Xác nhận
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <!-- Bootstrap Bundle with Popper -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>

        <script>
            $(document).ready(function () {
                // Khởi tạo datetime picker
                flatpickr(".datetime-picker", {
                    enableTime: true,
                    dateFormat: "Y-m-d\\TH:i",
                    time_24hr: true,
                    minDate: "today"
                });

                // Xử lý sự kiện khi nhấn vào nút đăng xuất
                $('.logout-btn').on('click', function (e) {
                    e.preventDefault();
                    $('#logoutModal').modal('show');
                });

                // Đảm bảo dropdown hoạt động đúng
                $('.user-dropdown').on('click', function (e) {
                    e.preventDefault();
                });

                // Xử lý nút Xem chi tiết
                $('.view-btn').on('click', function () {
    var id = $(this).data('id');
    // Gửi AJAX request để lấy thông tin voucher
    $.ajax({
        url: 'vouchers',
        type: 'GET',
        data: {
            action: 'view',
            id: id
        },
        dataType: 'json',
        success: function (voucher) {
            // Sử dụng dữ liệu từ response JSON
            $('#view-id').text(voucher.voucherId);
            $('#view-code').text(voucher.code);
            $('#view-discountAmount').text(new Intl.NumberFormat('vi-VN', {style: 'currency', currency: 'VND'}).format(voucher.discountAmount));
            $('#view-minOrderValue').text(new Intl.NumberFormat('vi-VN', {style: 'currency', currency: 'VND'}).format(voucher.minOrderValue));
            $('#view-usageLimit').text(voucher.usageLimit);

            // Định dạng ngày tháng
            var startDate = new Date(voucher.startDate);
            var endDate = new Date(voucher.endDate);
            var createdDate = new Date(voucher.createdDate);
            var now = new Date();
            var dateOptions = {day: '2-digit', month: '2-digit', year: 'numeric', hour: '2-digit', minute: '2-digit'};

            $('#view-startDate').text(startDate.toLocaleDateString('vi-VN', dateOptions));
            $('#view-endDate').text(endDate.toLocaleDateString('vi-VN', dateOptions));
            $('#view-createdDate-text').text(createdDate.toLocaleDateString('vi-VN', dateOptions));

            // Hiển thị trạng thái với logic tương tự JSP
            var statusText = '';
            if (endDate < now) {
                // Hết hạn
                statusText = '<span class="badge bg-danger"><i class="fas fa-times-circle me-1"></i>Hết hạn</span>';
            } else if (startDate > now) {
                // Chưa hiệu lực
                statusText = '<span class="badge bg-warning text-dark"><i class="fas fa-hourglass-start me-1"></i>Chưa hiệu lực</span>';
            } else if (voucher.isActive || voucher.active) {
                // Hoạt động (kiểm tra cả isActive và active)
                statusText = '<span class="badge bg-success"><i class="fas fa-check-circle me-1"></i>Hoạt động</span>';
            } else {
                // Vô hiệu hóa
                statusText = '<span class="badge bg-secondary"><i class="fas fa-ban me-1"></i>Vô hiệu hóa</span>';
            }
            
            $('#view-status').html(statusText);

            // Hiển thị thông tin sử dụng
            $('#view-usage').text(voucher.usedCount + '/' + voucher.usageLimit);

            // Hiển thị mô tả
            $('#view-description').text(voucher.description || 'Không có mô tả');

            $('#viewVoucherModal').modal('show');
        },
        error: function (xhr, status, error) {
            console.error("AJAX Error:", status, error);
            alert("Có lỗi xảy ra khi lấy thông tin voucher!");
        }
    });
});

                // Xử lý nút Chỉnh sửa
                $('.edit-btn').on('click', function () {
                    var id = $(this).data('id');
                    // Gửi AJAX request để lấy thông tin voucher
                    $.ajax({
                        url: 'vouchers',
                        type: 'GET',
                        data: {
                            action: 'edit',
                            id: id
                        },
                        dataType: 'json',
                        success: function (voucher) {
                            // Điền dữ liệu vào form chỉnh sửa
                            $('#edit-id').val(voucher.voucherId);
                            $('#edit-code').val(voucher.code);
                            $('#edit-discountAmount').val(voucher.discountAmount);
                            $('#edit-minOrderValue').val(voucher.minOrderValue);
                            $('#edit-usageLimit').val(voucher.usageLimit);
                            $('#edit-description').val(voucher.description);
                            $('#edit-usedCount').val(voucher.usedCount);
                            $('#edit-status').val(voucher.isActive ? 'Hoạt động' : 'Không hoạt động');

                            // Định dạng ngày tháng cho datetime-local input
                            var startDate = new Date(voucher.startDate);
                            var endDate = new Date(voucher.endDate);
                            var createdDate = new Date(voucher.createdDate);

                            var formatDateTime = function (date) {
                                var year = date.getFullYear();
                                var month = String(date.getMonth() + 1).padStart(2, '0');
                                var day = String(date.getDate()).padStart(2, '0');
                                var hours = String(date.getHours()).padStart(2, '0');
                                var minutes = String(date.getMinutes()).padStart(2, '0');
                                return year + '-' + month + '-' + day + 'T' + hours + ':' + minutes;
                            };

                            var formatDateTimeDisplay = function (date) {
                                return date.toLocaleDateString('vi-VN', {
                                    day: '2-digit',
                                    month: '2-digit',
                                    year: 'numeric',
                                    hour: '2-digit',
                                    minute: '2-digit'
                                });
                            };

                            $('#edit-startDate').val(formatDateTime(startDate));
                            $('#edit-endDate').val(formatDateTime(endDate));
                            $('#edit-createdDate').val(formatDateTimeDisplay(createdDate));

                            $('#editVoucherModal').modal('show');
                        },
                        error: function (xhr, status, error) {
                            console.error("AJAX Error:", status, error);
                            alert("Có lỗi xảy ra khi lấy thông tin voucher!");
                        }
                    });
                });

                // Xử lý nút thay đổi trạng thái
                $('.toggle-btn').on('click', function () {
                    var id = $(this).data('id');
                    var status = $(this).data('status');
                    var statusText = status ? 'vô hiệu hóa' : 'kích hoạt';

                    $('#toggle-message').text('Bạn có chắc chắn muốn ' + statusText + ' voucher này?');
                    $('#toggle-confirm-btn').attr('href', 'vouchers?action=toggle&id=' + id + '&status=' + status);
                    $('#toggleStatusModal').modal('show');
                });

                // Auto dismiss alerts after 5 seconds
                setTimeout(function () {
                    $('.alert').fadeOut('slow');
                }, 5000);

                // Set minimum date for datetime pickers to today
                var today = new Date();
                var todayString = today.getFullYear() + '-' +
                        String(today.getMonth() + 1).padStart(2, '0') + '-' +
                        String(today.getDate()).padStart(2, '0') + 'T' +
                        String(today.getHours()).padStart(2, '0') + ':' +
                        String(today.getMinutes()).padStart(2, '0');

                $('#startDate').attr('min', todayString);
                $('#endDate').attr('min', todayString);
            });
        </script>
    </body>
</html>