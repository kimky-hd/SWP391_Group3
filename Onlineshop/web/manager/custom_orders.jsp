<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản lý đơn hàng tự thiết kế</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            /* Thiết lập chung */
            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background-color: #f8f9fa;
                color: #333;
            }

            /* Topbar và sidebar */
            .topbar {
                background-color: #1F2937;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            }

            /* Card styling */
            .card {
                border: none;
                border-radius: 10px;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
                transition: transform 0.3s ease, box-shadow 0.3s ease;
            }

            .card:hover {
                transform: translateY(-5px);
                box-shadow: 0 10px 15px rgba(0, 0, 0, 0.1);
            }

            .card-header {
                background-color: #f8f9fa;
                border-bottom: 1px solid #edf2f7;
                font-weight: 600;
                padding: 15px 20px;
            }

            /* Table styling */
            .table {
                border-collapse: separate;
                border-spacing: 0;
            }

            .table thead th {
                background-color: #f8f9fa;
                color: #4b5563;
                font-weight: 600;
                text-transform: uppercase;
                font-size: 0.75rem;
                letter-spacing: 0.05em;
                padding: 12px;
                border-bottom: 2px solid #e5e7eb;
            }

            .table tbody tr {
                transition: background-color 0.2s ease;
            }

            .table tbody tr:hover {
                background-color: #f9fafb;
            }

            .table tbody td {
                padding: 12px;
                vertical-align: middle;
                border-bottom: 1px solid #e5e7eb;
            }

            /* Status badges */
            .status-badge {
                padding: 6px 12px;
                border-radius: 30px;
                font-size: 0.75rem;
                font-weight: 600;
                display: inline-flex;
                align-items: center;
                gap: 5px;
            }

            .status-1 {
                background-color: #f8d7da;
                color: #721c24;
            } /* Chờ duyệt */
            .status-2 {
                background-color: #d4edda;
                color: #155724;
            } /* Đã duyệt và đóng gói */
            .status-3 {
                background-color: #fff3cd;
                color: #856404;
            } /* Đang vận chuyển */
            .status-4 {
                background-color: #cce5ff;
                color: #004085;
            } /* Đã giao hàng */
            .status-5 {
                background-color: #d1ecf1;
                color: #0c5460;
            } /* Đã thanh toán */
            .status-6 {
                background-color: #e2e3e5;
                color: #383d41;
            } /* Đã hủy */
            .status-7 {
                background-color: #c3e6cb;
                color: #155724;
            } /* Đã duyệt đơn thiết kế */
            .status-8 {
                background-color: #f5c6cb;
                color: #721c24;
            } /* Từ chối đơn thiết kế */

            /* Filter section */
            .filter-section {
                background-color: #ffffff;
                padding: 20px;
                border-radius: 10px;
                margin-bottom: 25px;
                box-shadow: 0 2px 5px rgba(0,0,0,0.05);
            }

            .filter-section .form-label {
                font-weight: 500;
                color: #4b5563;
                margin-bottom: 8px;
            }

            .filter-section .form-control,
            .filter-section .form-select {
                border-radius: 8px;
                border: 1px solid #e5e7eb;
                padding: 10px 15px;
                transition: border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
            }

            .filter-section .form-control:focus,
            .filter-section .form-select:focus {
                border-color: #3b82f6;
                box-shadow: 0 0 0 0.25rem rgba(59, 130, 246, 0.25);
            }

            /* Custom order image */
            .custom-order-image {
                width: 80px;
                height: 80px;
                object-fit: cover;
                border-radius: 8px;
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
                transition: transform 0.3s ease, box-shadow 0.3s ease;
            }

            .custom-order-image:hover {
                transform: scale(1.15);
                box-shadow: 0 5px 15px rgba(0,0,0,0.2);
            }

            /* Buttons */
            .btn {
                padding: 8px 16px;
                font-weight: 500;
                border-radius: 8px;
                transition: all 0.3s ease;
            }

            .btn:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            }

            .btn-sm {
                padding: 5px 10px;
                font-size: 0.75rem;
            }

            .btn-primary {
                background-color: #3b82f6;
                border-color: #3b82f6;
            }

            .btn-primary:hover {
                background-color: #2563eb;
                border-color: #2563eb;
            }

            .btn-info {
                background-color: #0ea5e9;
                border-color: #0ea5e9;
                color: white;
            }

            .btn-info:hover {
                background-color: #0284c7;
                border-color: #0284c7;
                color: white;
            }

            /* Pagination */
            .pagination {
                margin-top: 30px;
            }

            .pagination .page-item .page-link {
                border: none;
                color: #4b5563;
                margin: 0 3px;
                border-radius: 8px;
                transition: all 0.2s ease;
            }

            .pagination .page-item.active .page-link {
                background-color: #3b82f6;
                color: white;
            }

            .pagination .page-item .page-link:hover {
                background-color: #e5e7eb;
                color: #1f2937;
            }

            /* Empty state */
            .empty-state {
                text-align: center;
                padding: 40px 0;
            }

            .empty-state i {
                font-size: 3rem;
                color: #9ca3af;
                margin-bottom: 15px;
            }

            .empty-state p {
                color: #6b7280;
                font-size: 1rem;
            }

            /* Alerts */
            .alert {
                border-radius: 8px;
                border: none;
                padding: 15px 20px;
                margin-bottom: 20px;
                box-shadow: 0 2px 5px rgba(0,0,0,0.05);
            }

            .alert-success {
                background-color: #d1fae5;
                color: #065f46;
            }

            .alert-danger {
                background-color: #fee2e2;
                color: #991b1b;
            }
        </style>
    </head>
    <body>
        <%
            // Kiểm tra quyền truy cập - chỉ cho phép manager (roleID = 2)
            Model.Account account = (Model.Account) session.getAttribute("account");
            if (account == null || account.getRole() != 2) {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }
        %>
        <div class="container-fluid">
            <div class="row">
                <!-- Sidebar -->
                <jsp:include page="../manager_topbarsidebar.jsp"></jsp:include>

                    <!-- Main Content -->
                    <div class="col-md-10 ms-sm-auto col-lg-10 px-md-4">
                        <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                            <h1 class="h2">
                                <i class="fas fa-palette me-2"></i>Quản lý đơn hàng tự thiết kế
                            </h1>
                        </div>

                        <!-- Thông báo lỗi/thành công -->
                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger" role="alert">
                            <i class="fas fa-exclamation-circle me-2"></i>${errorMessage}
                        </div>
                    </c:if>
                    <c:if test="${not empty successMessage}">
                        <div class="alert alert-success" role="alert">
                            <i class="fas fa-check-circle me-2"></i>${successMessage}
                        </div>
                    </c:if>

                    <!-- Phần lọc -->
                    <div class="card mb-4">
                        <div class="card-header bg-white">
                            <i class="fas fa-filter me-2"></i>Bộ lọc
                        </div>
                        <div class="card-body">
                            <form action="${pageContext.request.contextPath}/manager/custom-orders" method="get" class="row g-3">
                                <div class="col-md-4">
                                    <label for="customerName" class="form-label">
                                        <i class="fas fa-user me-1"></i>Tên khách hàng
                                    </label>
                                    <input type="text" class="form-control" id="customerName" name="customerName" value="${customerName}">
                                </div>
                                <div class="col-md-4">
                                    <label for="status" class="form-label">
                                        <i class="fas fa-tag me-1"></i>Trạng thái
                                    </label>
                                    <select class="form-select" id="status" name="status">
                                        <option value="" ${empty status ? 'selected' : ''}>Tất cả</option>
                                        <option value="1" ${status == '1' ? 'selected' : ''}>Chờ duyệt</option>
                                        <option value="2" ${status == '2' ? 'selected' : ''}>Đã duyệt và đóng gói</option>
                                        <option value="3" ${status == '3' ? 'selected' : ''}>Đang vận chuyển</option>
                                        <option value="4" ${status == '4' ? 'selected' : ''}>Đã giao hàng</option>
                                        <option value="5" ${status == '5' ? 'selected' : ''}>Đã thanh toán</option>
                                        <option value="6" ${status == '6' ? 'selected' : ''}>Đã hủy</option>
                                        <option value="7" ${status == '7' ? 'selected' : ''}>Đã duyệt đơn thiết kế</option>
                                        <option value="8" ${status == '8' ? 'selected' : ''}>Từ chối đơn thiết kế</option>
                                    </select>
                                </div>
                                <div class="col-md-4 d-flex align-items-end">
                                    <button type="submit" class="btn btn-primary me-2">
                                        <i class="fas fa-search me-1"></i>Lọc
                                    </button>
                                    <a href="${pageContext.request.contextPath}/manager/custom-orders" class="btn btn-secondary">
                                        <i class="fas fa-redo me-1"></i>Đặt lại
                                    </a>
                                </div>
                            </form>
                        </div>
                    </div>

                    <!-- Bảng đơn hàng -->
                    <div class="card">
                        <div class="card-header bg-white d-flex justify-content-between align-items-center">
                            <span><i class="fas fa-list me-2"></i>Danh sách đơn hàng tự thiết kế</span>
                        </div>
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover mb-0">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Hình ảnh</th>
                                            <th>Khách hàng</th>
                                            <th>Mô tả</th>
                                            <th>Số lượng</th>
                                            <th>Ngày tạo</th>
                                            <th>Trạng thái</th>
                                            <th>Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${customOrders}" var="order">
                                            <tr>
                                                <td>${order.customCartID}</td>
                                                <td>
                                                    <img src="${pageContext.request.contextPath}/${order.referenceImage}" alt="Hình ảnh tham khảo" class="custom-order-image">
                                                </td>
                                                <td>${order.accountID}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${order.description.length() > 50}">
                                                            ${order.description.substring(0, 50)}...
                                                        </c:when>
                                                        <c:otherwise>
                                                            ${order.description}
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>${order.quantity}</td>
                                                <td><fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm" /></td>
                                                <td>
                                                    <span class="status-badge status-${order.statusID}">
                                                        <c:choose>
                                                            <c:when test="${order.statusID == 1}">
                                                                <i class="fas fa-clock me-1"></i>
                                                            </c:when>
                                                            <c:when test="${order.statusID == 2 || order.statusID == 7}">
                                                                <i class="fas fa-check me-1"></i>
                                                            </c:when>
                                                            <c:when test="${order.statusID == 3}">
                                                                <i class="fas fa-truck me-1"></i>
                                                            </c:when>
                                                            <c:when test="${order.statusID == 4}">
                                                                <i class="fas fa-home me-1"></i>
                                                            </c:when>
                                                            <c:when test="${order.statusID == 5}">
                                                                <i class="fas fa-money-bill-wave me-1"></i>
                                                            </c:when>
                                                            <c:when test="${order.statusID == 6 || order.statusID == 8}">
                                                                <i class="fas fa-ban me-1"></i>
                                                            </c:when>
                                                        </c:choose>
                                                        ${order.status}
                                                    </span>
                                                </td>
                                                <td>
                                                    <div class="btn-group" role="group">
                                                        <a href="${pageContext.request.contextPath}/manager/custom-orders?action=detail&id=${order.customCartID}" class="btn btn-sm btn-info" title="Chi tiết">
                                                            <i class="fas fa-eye"></i>
                                                        </a>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>

                                        <c:if test="${empty customOrders}">
                                            <tr>
                                                <td colspan="8" class="text-center py-4">
                                                    <div class="empty-state">
                                                        <i class="fas fa-palette fa-3x text-muted mb-3"></i>
                                                        <p class="text-muted mb-0">Không có đơn hàng tự thiết kế nào</p>
                                                    </div>
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
                                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                    <a class="page-link" href="${pageContext.request.contextPath}/manager/custom-orders?page=${currentPage - 1}&customerName=${customerName}&status=${status}" aria-label="Previous">
                                        <span aria-hidden="true"><i class="fas fa-chevron-left"></i></span>
                                    </a>
                                </li>

                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <li class="page-item ${currentPage == i ? 'active' : ''}"><a class="page-link" href="${pageContext.request.contextPath}/manager/custom-orders?page=${i}&customerName=${customerName}&status=${status}">${i}</a></li>
                                    </c:forEach>

                                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                    <a class="page-link" href="${pageContext.request.contextPath}/manager/custom-orders?page=${currentPage + 1}&customerName=${customerName}&status=${status}" aria-label="Next">
                                        <span aria-hidden="true"><i class="fas fa-chevron-right"></i></span>
                                    </a>
                                </li>
                            </ul>
                        </nav>
                    </c:if>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    </body>
</html>