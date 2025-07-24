<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Xem đơn hàng tự thiết kế</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link href="${pageContext.request.contextPath}/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/css/admin.css" rel="stylesheet">
        <style>
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
                background-color: #f0fdf4;
                border-bottom: 1px solid #d1fae5;
                font-weight: 600;
                padding: 15px 20px;
            }

            /* Table styling */
            .table {
                border-collapse: separate;
                border-spacing: 0;
            }

            .table thead th {
                background-color: #f0fdf4;
                color: #064e3b;
                font-weight: 600;
                text-transform: uppercase;
                font-size: 0.75rem;
                letter-spacing: 0.05em;
                padding: 12px;
                border-bottom: 2px solid #d1fae5;
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

            .status-2 {
                background-color: #d4edda;
                color: #155724;
            } /* Đã duyệt và đóng gói */
            .status-3 {
                background-color: #cff4fc;
                color: #055160;
            } /* Đơn hàng đang được vận chuyển */
            .status-4 {
                background-color: #d1e7dd;
                color: #0f5132;
            } /* Đã giao hàng thành công */
            .status-5 {
                background-color: #e8f5e9;
                color: #1b5e20;
            } /* Đã thanh toán thành công */
            .status-6 {
                background-color: #f8d7da;
                color: #842029;
            } /* Đã hủy */
            .status-7 {
                background-color: #c3e6cb;
                color: #155724;
            } /* Đã duyệt đơn thiết kế */
            .status-8 {
                background-color: #f8d7da;
                color: #721c24;
            } /* Đơn thiết kế đã bị từ chối */
            .status-9 {
                background-color: #fff3cd;
                color: #664d03;
            } /* Sẵn sàng giao */

            /* Filter section */
            .filter-section {
                background-color: #ffffff;
                padding: 20px;
                border-radius: 10px;
                margin-bottom: 25px;
                box-shadow: 0 2px 5px rgba(0,0,0,0.05);
                border-left: 4px solid #059669;
            }

            .filter-section .form-label {
                font-weight: 500;
                color: #064e3b;
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
            // Kiểm tra quyền truy cập - chỉ cho phép staff (roleID = 2)
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
                                <i class="fas fa-palette me-2"></i>Đơn hàng tự thiết kế đã duyệt
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
                            <form action="${pageContext.request.contextPath}/staff/staff_custom-orders" method="get" class="row g-3">
                                <div class="col-md-3">
                                    <label for="orderId" class="form-label">
                                        <i class="fas fa-hashtag me-1"></i>ID đơn hàng
                                    </label>
                                    <input type="number" class="form-control" id="orderId" name="orderId" value="${orderId}" min="1">
                                </div>
                                <div class="col-md-3">
                                    <label for="customerName" class="form-label">
                                        <i class="fas fa-user me-1"></i>Tên khách hàng
                                    </label>
                                    <input type="text" class="form-control" id="customerName" name="customerName" value="${customerName}">
                                </div>
                                <div class="col-md-3">
                                    <label for="status" class="form-label">
                                        <i class="fas fa-tag me-1"></i>Trạng thái
                                    </label>
                                    <select class="form-select" id="status" name="status">
                                        <option value="" ${empty status ? 'selected' : ''}>Tất cả</option>
                                        <option value="2" ${status == '2' ? 'selected' : ''}>Đơn hàng đang được đóng gói</option>
                                        <option value="3" ${status == '3' ? 'selected' : ''}>Đơn hàng đang được vận chuyển</option>
                                        <option value="4" ${status == '4' ? 'selected' : ''}>Đã giao hàng thành công</option>
                                        <option value="5" ${status == '5' ? 'selected' : ''}>Đã thanh toán thành công</option>
                                        <option value="6" ${status == '6' ? 'selected' : ''}>Đã hủy</option>
                                        <option value="7" ${status == '7' ? 'selected' : ''}>Đơn thiết kế đã duyệt</option>
                                        <option value="8" ${status == '8' ? 'selected' : ''}>Đơn hàng thiết kế riêng bị từ chối</option>
                                        <option value="9" ${status == '9' ? 'selected' : ''}>Sẵn sàng giao</option>
                                    </select>
                                </div>
                                <div class="col-md-3 d-flex align-items-end">
                                    <button type="submit" class="btn btn-primary me-2">
                                        <i class="fas fa-search me-1"></i>Lọc
                                    </button>
                                    <a href="${pageContext.request.contextPath}/staff/staff_custom-orders" class="btn btn-secondary">
                                        <i class="fas fa-redo me-1"></i>Đặt lại
                                    </a>
                                </div>
                            </form>
                        </div>
                    </div>

                    <!-- Bảng đơn hàng -->
                    <div class="card">
                        <div class="card-header bg-white d-flex justify-content-between align-items-center">
                            <span><i class="fas fa-list me-2"></i>Danh sách đơn hàng tự thiết kế đã duyệt</span>
                        </div>
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover mb-0">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Hình ảnh</th>
                                            <th>Khách hàng</th>
                                            <th>Liên hệ</th>
                                            <th>Số lượng</th>
                                            <th>Mô tả</th>
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
                                                    <c:if test="${not empty order.referenceImage2 or not empty order.referenceImage3 or not empty order.referenceImage4 or not empty order.referenceImage5}">
                                                        <span class="badge bg-info ms-1">+${(not empty order.referenceImage2 ? 1 : 0) + (not empty order.referenceImage3 ? 1 : 0) + (not empty order.referenceImage4 ? 1 : 0) + (not empty order.referenceImage5 ? 1 : 0)}</span>
                                                    </c:if>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty order.fullName}">
                                                            ${order.fullName}
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted">ID: ${order.accountID}</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:if test="${not empty order.phone}">
                                                        <div><i class="fas fa-phone-alt me-1 text-primary"></i>${order.phone}</div>
                                                        </c:if>
                                                        <c:if test="${not empty order.email}">
                                                        <div><i class="fas fa-envelope me-1 text-primary"></i>${order.email}</div>
                                                        </c:if>
                                                </td>
                                                <td>${order.quantity}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${order.description.length() > 50}">
                                                            ${order.description.substring(0, 50)}...
                                                        </c:when>
                                                        <c:otherwise>
                                                            ${order.description}
                                                            <img src="img/${item.product.image}" alt="${item.product.title}" style="width: 50px;"><img src="img/${item.product.image}" alt="${item.product.title}" style="width: 50px;"><img src="img/${item.product.image}" alt="${item.product.title}" style="width: 50px;">                    </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td><fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm" /></td>
                                                <td>
                                                    <span class="status-badge status-${order.statusID}">
                                                        <c:choose>
                                                            <c:when test="${order.statusID == 2}">
                                                                <i class="fas fa"></i>Đơn hàng đang được đóng gói
                                                            </c:when>
                                                            <c:when test="${order.statusID == 3}">
                                                                <i class="fas fa"></i>Đơn hàng đang được vận chuyển
                                                            </c:when>
                                                            <c:when test="${order.statusID == 4}">
                                                                <i class="fas fa"></i>Đã giao hàng thành công
                                                            </c:when>
                                                            <c:when test="${order.statusID == 5}">
                                                                <i class="fas fa"></i>Đã thanh toán thành công
                                                            </c:when>
                                                            <c:when test="${order.statusID == 6}">
                                                                <i class="fas fa"></i>Đã hủy
                                                            </c:when>
                                                            <c:when test="${order.statusID == 7}">
                                                                <i class="fas fa"></i>Đã duyệt đơn thiết kế
                                                            </c:when>
                                                            <c:when test="${order.statusID == 8}">
                                                                <i class="fas fa"></i>Đơn thiết kế đã bị từ chối
                                                            </c:when>
                                                            <c:when test="${order.statusID == 9}">
                                                                <i class="fas fa"></i>Sẵn sàng giao
                                                            </c:when>
                                                        </c:choose>
                                                    </span>
                                                </td>
                                                <td>
                                                    <div class="btn-group" role="group">
                                                        <a href="${pageContext.request.contextPath}/staff/staff_custom-orders?action=detail&id=${order.customCartID}" class="btn btn-sm btn-info" title="Chi tiết">
                                                            <i class="fas fa-eye"></i>
                                                        </a>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>

                                        <c:if test="${empty customOrders}">
                                            <tr>
                                                <td colspan="9" class="text-center py-4">
                                                    <div class="empty-state">
                                                        <i class="fas fa-palette fa-3x text-muted mb-3"></i>
                                                        <p class="text-muted mb-0">Không có đơn hàng tự thiết kế đã duyệt nào</p>
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
                                    <a class="page-link" href="${pageContext.request.contextPath}/staff/staff_custom-orders?page=${currentPage - 1}&orderId=${orderId}&customerName=${customerName}&status=${status}" aria-label="Previous">
                                        <span aria-hidden="true"><i class="fas fa-chevron-left"></i></span>
                                    </a>
                                </li>

                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <li class="page-item ${currentPage == i ? 'active' : ''}"><a class="page-link" href="${pageContext.request.contextPath}/staff/staff_custom-orders?page=${i}&orderId=${orderId}&customerName=${customerName}&status=${status}">${i}</a></li>
                                    </c:forEach>

                                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                    <a class="page-link" href="${pageContext.request.contextPath}/staff/staff_custom-orders?page=${currentPage + 1}&orderId=${orderId}&customerName=${customerName}&status=${status}" aria-label="Next">
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
