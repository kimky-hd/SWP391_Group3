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
        <link href="${pageContext.request.contextPath}/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <!-- Custom CSS -->
        <link href="${pageContext.request.contextPath}/css/admin.css" rel="stylesheet">
        <!-- jQuery -->
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <!-- Flatpickr for datetime picker -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
        <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    </head>
    <body>
        <!-- Topbar -->
        <nav class="navbar navbar-expand-lg topbar">
            <div class="container-fluid px-4">
                <a class="topbar-brand" href="#">Bán Hoa </a>

                <div class="d-flex align-items-center">
                    <div class="topbar-search me-4">
                        <input type="text" class="form-control" placeholder="Search Keywords...">
                        <i class="fas fa-search"></i>
                    </div>

                    <ul class="navbar-nav topbar-actions">
                        <li class="nav-item">
                            <a class="nav-link" href="#">
                                <i class="fas fa-bell"></i>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#">
                                <i class="fas fa-cog"></i>
                            </a>
                        </li>
                        <!-- User Dropdown -->
                        <li class="nav-item dropdown">
                            <% if(session.getAttribute("account") != null) { 
                                Account acc = (Account)session.getAttribute("account");
                            %>
                            <a class="nav-link dropdown-toggle user-dropdown" href="#" id="userDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                <img src="${pageContext.request.contextPath}/img/user.jpg" alt="user" class="rounded-circle me-2" width="32">
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

        <!-- Sidebar -->
        <nav class="sidebar">
            <ul class="sidebar-menu">
                <li>
                    <a href="${pageContext.request.contextPath}/dashboard" class="nav-link">
                        <i class="fas fa-chart-line"></i>
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
                    <a href="${pageContext.request.contextPath}/orders" class="nav-link">
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
                    <a href="${pageContext.request.contextPath}/vouchers" class="nav-link active">
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
        <main class="main-content">
            <div class="container-fluid p-4">
                <div class="row mb-4">
                    <div class="col-md-6">
                        <h2 class="page-title"><i class="fas fa-percent me-2"></i>Quản lý Voucher</h2>
                    </div>
                     <div class="col-md-6 d-flex justify-content-end"> <!-- Thay đổi ở đây -->
                <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addVoucherModal">
                    <i class="fas fa-plus me-2"></i>Thêm Voucher mới
                </button>
            </div>
                </div>

                <!-- Thông báo -->
                <c:if test="${not empty message}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        ${message}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        ${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>
                <%
    session.removeAttribute("message");
    session.removeAttribute("error");
%>
                <!-- Danh sách Voucher -->
                <div class="card shadow-sm">
                    <div class="card-header bg-white py-3">
                        <h5 class="mb-0"><i class="fas fa-list me-2"></i>Danh sách Voucher</h5>
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
                                        <th>Thời gian</th>
                                        <th>Trạng thái</th>
                                        <th>Đã dùng/Giới hạn</th>
                                        <th>Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${vouchers}" var="voucher">
                                        <tr>
                                            <td>${voucher.voucherId}</td>
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
                                                <c:choose>
                                                    <c:when test="${voucher.isActive()}">
                                                        <span class="badge bg-success">Hoạt động</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary">Không hoạt động</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>${voucher.usedCount}/${voucher.usageLimit}</td>
                                            <td>
                                                <div class="btn-group">
                                                    <button class="btn btn-sm btn-info view-btn" data-id="${voucher.voucherId}">
                                                        <i class="fas fa-eye"></i>
                                                    </button>
                                                    <button class="btn btn-sm btn-primary edit-btn" data-id="${voucher.voucherId}">
                                                        <i class="fas fa-edit"></i>
                                                    </button>
                                                    <button class="btn btn-sm ${voucher.isActive() ? 'btn-warning' : 'btn-success'} toggle-btn" 
                                                            data-id="${voucher.voucherId}" 
                                                            data-status="${voucher.isActive()}">
                                                        <i class="fas ${voucher.isActive() ? 'fa-ban' : 'fa-check'}"></i>
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>

                        <!-- Phân trang -->
                        <c:if test="${totalPages > 1}">
                            <nav aria-label="Page navigation">
                                <ul class="pagination justify-content-center mt-4">
                                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                        <a class="page-link" href="vouchers?page=${currentPage - 1}" aria-label="Previous">
                                            <span aria-hidden="true">&laquo;</span>
                                        </a>
                                    </li>
                                    <c:forEach begin="1" end="${totalPages}" var="i">
                                        <li class="page-item ${currentPage == i ? 'active' : ''}">
                                            <a class="page-link" href="vouchers?page=${i}">${i}</a>
                                        </li>
                                    </c:forEach>
                                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                        <a class="page-link" href="vouchers?page=${currentPage + 1}" aria-label="Next">
                                            <span aria-hidden="true">&raquo;</span>
                                        </a>
                                    </li>
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
                                <textarea class="form-control" id="description" name="description" rows="3"></textarea>
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
                                <div class="col-md-6">
                                    <label class="form-label">Số lần đã sử dụng</label>
                                    <input type="text" class="form-control" id="edit-usedCount" readonly>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Trạng thái</label>
                                    <input type="text" class="form-control" id="edit-status" readonly>
                                </div>
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
                                <h6 class="fw-bold">ID Voucher:</h6>
                                <p id="view-id"></p>
                            </div>
                            <div class="col-md-6">
                                <h6 class="fw-bold">Mã Voucher:</h6>
                                <p id="view-code"></p>
                            </div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <h6 class="fw-bold">Giá trị giảm:</h6>
                                <p id="view-discountAmount"></p>
                            </div>
                            <div class="col-md-6">
                                <h6 class="fw-bold">Giá trị đơn hàng tối thiểu:</h6>
                                <p id="view-minOrderValue"></p>
                            </div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <h6 class="fw-bold">Thời gian bắt đầu:</h6>
                                <p id="view-startDate"></p>
                            </div>
                            <div class="col-md-6">
                                <h6 class="fw-bold">Thời gian kết thúc:</h6>
                                <p id="view-endDate"></p>
                            </div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <h6 class="fw-bold">Trạng thái:</h6>
                                <p id="view-status"></p>
                            </div>
                            <div class="col-md-6">
                                <h6 class="fw-bold">Sử dụng:</h6>
                                <p id="view-usage"></p>
                            </div>
                        </div>
                        <div class="mb-3">
                            <h6 class="fw-bold">Mô tả:</h6>
                            <p id="view-description"></p>
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

        <!-- Logout Modal -->
        <div class="modal fade" id="logoutModal" tabindex="-1" aria-labelledby="logoutModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content admin-modal">
                    <div class="modal-header bg-danger text-white">
                        <h5 class="modal-title" id="logoutModalLabel">
                            <i class="fas fa-sign-out-alt me-2"></i>Xác nhận đăng xuất
                        </h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body py-4 text-center">
                        <div class="mb-3">
                            <i class="fas fa-question-circle text-warning" style="font-size: 3rem;"></i>
                        </div>
                        <p class="mb-0" style="font-size: 1.1rem; color: #000000; font-weight: 600;">
                            Bạn có chắc chắn muốn đăng xuất khỏi tài khoản admin?
                        </p>
                    </div>
                    <div class="modal-footer justify-content-center border-0 pt-0">
                        <button type="button" class="btn btn-secondary px-4" data-bs-dismiss="modal">
                            <i class="fas fa-times me-2"></i>Hủy
                        </button>
                        <a class="btn btn-danger px-4" href="LogoutServlet">
                            <i class="fas fa-sign-out-alt me-2"></i>Đăng xuất
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <!-- Bootstrap Bundle with Popper -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>

        <style>
            /* Admin Dropdown Styles */
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

            .user-dropdown {
                border-radius: 20px;
                font-weight: 500;
                transition: all 0.3s ease;
                text-decoration: none;
                color: inherit;
            }

            .user-dropdown:hover {
                background: rgba(0,0,0,0.1);
                color: inherit;
            }

            .logout-btn {
                cursor: pointer;
            }

            /* Admin Modal Styles */
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

            /* Voucher specific styles */
            .card {
                border-radius: 10px;
                overflow: hidden;
            }

            .card-header {
                border-bottom: 1px solid rgba(0,0,0,0.1);
            }

            .table th {
                font-weight: 600;
                background-color: #f8f9fa;
            }

            .badge {
                padding: 6px 10px;
                border-radius: 20px;
                font-weight: 500;
            }

            .btn-group .btn {
                margin-right: 5px;
                border-radius: 5px;
            }

            /* Responsive adjustments */
            @media (max-width: 768px) {
                .topbar-search {
                    display: none;
                }

                .user-dropdown {
                    font-size: 0.9rem;
                }
            }
        </style>

        <script>
            
            $(document).ready(function () {
                // Khởi tạo datetime picker
                flatpickr(".datetime-picker", {
                    enableTime: true,
                    dateFormat: "Y-m-d H:i",
                    time_24hr: true
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
        dataType: 'json', // Thêm dòng này để xác định response là JSON
        success: function (voucher) {
            // Sử dụng dữ liệu từ response JSON thay vì từ bảng
            $('#view-id').text(voucher.voucherId);
            $('#view-code').text(voucher.code);
            $('#view-discountAmount').text(new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(voucher.discountAmount));
            $('#view-minOrderValue').text(new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(voucher.minOrderValue));
            
            // Định dạng ngày tháng
            var startDate = new Date(voucher.startDate);
            var endDate = new Date(voucher.endDate);
            var dateOptions = { day: '2-digit', month: '2-digit', year: 'numeric', hour: '2-digit', minute: '2-digit' };
            
            $('#view-startDate').text(startDate.toLocaleDateString('vi-VN', dateOptions));
            $('#view-endDate').text(endDate.toLocaleDateString('vi-VN', dateOptions));
            
            // Hiển thị trạng thái
            var statusText = voucher.isActive ? 'Hoạt động' : 'Không hoạt động';
            $('#view-status').text(statusText);
            
            // Hiển thị thông tin sử dụng
            $('#view-usage').text(voucher.usedCount + '/' + voucher.usageLimit);
            
            // Hiển thị mô tả
            $('#view-description').text(voucher.description || 'Không có mô tả');
            
            $('#viewVoucherModal').modal('show');
        },
        error: function(xhr, status, error) {
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
                        success: function (response) {
                            // Dữ liệu sẽ được truyền qua request attribute và hiển thị trong JSP
                            // Vì đây là demo nên chúng ta giả định dữ liệu từ bảng
                            var row = $('button[data-id="' + id + '"]').closest('tr');
                            var voucherId = row.find('td:eq(0)').text();
                            var code = row.find('td:eq(1)').text();
                            var discountAmount = row.find('td:eq(2)').text().replace(/[^\d]/g, '');
                            var minOrderValue = row.find('td:eq(3)').text().replace(/[^\d]/g, '');
                            var timeRange = row.find('td:eq(4)').text();
                            var startDate = timeRange.split(' - ')[0].trim();
                            var endDate = timeRange.split(' - ')[1].trim();
                            var status = row.find('td:eq(5)').text().trim();
                            var usage = row.find('td:eq(6)').text();
                            var usedCount = usage.split('/')[0];
                            var usageLimit = usage.split('/')[1];
                            var description = row.find('td:eq(9)').text(); // Giả định

                            // Chuyển đổi định dạng ngày tháng
                            var startParts = startDate.split(' ')[0].split('/');
                            var startTime = startDate.split(' ')[1];
                            var formattedStartDate = startParts[2] + '-' + startParts[1] + '-' + startParts[0] + ' ' + startTime;

                            var endParts = endDate.split(' ')[0].split('/');
                            var endTime = endDate.split(' ')[1];
                            var formattedEndDate = endParts[2] + '-' + endParts[1] + '-' + endParts[0] + ' ' + endTime;

                            $('#edit-id').val(voucherId);
                            $('#edit-code').val(code);
                            $('#edit-discountAmount').val(discountAmount);
                            $('#edit-minOrderValue').val(minOrderValue);
                            $('#edit-startDate').val(formattedStartDate);
                            $('#edit-endDate').val(formattedEndDate);
                            $('#edit-usageLimit').val(usageLimit);
                            $('#edit-description').val(description);
                            $('#edit-usedCount').val(usedCount);
                            $('#edit-status').val(status);

                            $('#editVoucherModal').modal('show');
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
            });
        </script>
        <script>
    flatpickr(".datetime-picker", {
        enableTime: true,
        dateFormat: "Y-m-d H:i",
        time_24hr: true,
        // Không cần chuyển đổi thêm, giữ nguyên định dạng yyyy-MM-dd'T'HH:mm
        altInput: true,
        altFormat: "d/m/Y H:i",
    });
</script>
    </body>
</html>