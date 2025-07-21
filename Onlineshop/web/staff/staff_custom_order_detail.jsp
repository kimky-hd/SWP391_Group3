<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Chi tiết đơn hàng tự thiết kế #${customOrder.customCartID}</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link href="${pageContext.request.contextPath}/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/css/admin.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
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
                margin-bottom: 25px;
            }

            .card:hover {
                transform: translateY(-5px);
                box-shadow: 0 10px 15px rgba(0, 0, 0, 0.1);
            }

            .card-header {
                border-radius: 10px 10px 0 0 !important;
                font-weight: 600;
                padding: 15px 20px;
            }

            .card-body {
                padding: 20px;
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
            .status-7 {
                background-color: #c3e6cb;
                color: #155724;
            } /* Đã duyệt đơn thiết kế */

            /* Reference image */
            .reference-image-container {
                position: relative;
                overflow: hidden;
                border-radius: 10px;
                box-shadow: 0 4px 8px rgba(0,0,0,0.1);
                margin-bottom: 20px;
            }

            .reference-image {
                width: 100%;
                height: auto;
                max-height: 500px;
                object-fit: contain;
                transition: transform 0.5s ease;
            }

            .reference-image:hover {
                transform: scale(1.03);
            }

            /* Order info */
            .info-table {
                width: 100%;
            }

            .info-table th {
                width: 40%;
                padding: 12px 15px;
                color: #4b5563;
                font-weight: 600;
                border-bottom: 1px solid #e5e7eb;
            }

            .info-table td {
                padding: 12px 15px;
                border-bottom: 1px solid #e5e7eb;
            }

            .info-table tr:last-child th,
            .info-table tr:last-child td {
                border-bottom: none;
            }

            /* Order description */
            .order-description {
                background-color: #ffffff;
                padding: 20px;
                border-radius: 10px;
                box-shadow: 0 2px 5px rgba(0,0,0,0.05);
                margin-bottom: 25px;
            }

            .order-description h5 {
                color: #4b5563;
                font-weight: 600;
                margin-bottom: 15px;
                border-bottom: 1px solid #e5e7eb;
                padding-bottom: 10px;
            }

            .order-description p {
                color: #6b7280;
                line-height: 1.6;
                white-space: pre-line;
            }

            /* Buttons */
            .btn {
                padding: 10px 20px;
                font-weight: 500;
                border-radius: 8px;
                transition: all 0.3s ease;
            }

            .btn:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            }

            .btn-secondary {
                background-color: #6b7280;
                border-color: #6b7280;
            }

            .btn-secondary:hover {
                background-color: #4b5563;
                border-color: #4b5563;
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
                                <i class="fas fa-palette me-2"></i>Chi tiết đơn hàng tự thiết kế #${customOrder.customCartID}
                        </h1>
                        <a href="${pageContext.request.contextPath}/staff/custom-orders" class="btn btn-secondary">
                            <i class="fas fa-arrow-left me-1"></i>Quay lại
                        </a>
                    </div>

                    <!-- Thông báo lỗi/thành công -->
                    <div id="statusMessage" style="display: none;" class="alert" role="alert"></div>

                    <div class="row">
                        <!-- Thông tin đơn hàng -->
                        <div class="col-md-6">
                            <!-- Thông tin đơn hàng -->
                            <div class="card">
                                <div class="card-header bg-primary text-white">
                                    <i class="fas fa-info-circle me-2"></i>Thông tin đơn hàng
                                </div>
                                <div class="card-body">
                                    <table class="info-table">
                                        <tr>
                                            <th><i class="fas fa-hashtag me-2"></i>Mã đơn hàng:</th>
                                            <td>#${customOrder.customCartID}</td>
                                        </tr>
                                        <tr>
                                            <th><i class="fas fa-user me-2"></i>Mã khách hàng:</th>
                                            <td>${customOrder.accountID}</td>
                                        </tr>
                                        <!-- Thông tin liên hệ khách hàng -->
                                        <tr>
                                            <th><i class="fas fa-user-tag me-2"></i>Tên khách hàng:</th>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty customOrder.fullName}">
                                                        ${customOrder.fullName}
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted"><i class="fas fa-exclamation-circle me-1"></i>Không có</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th><i class="fas fa-phone-alt me-2"></i>Số điện thoại:</th>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty customOrder.phone}">
                                                        ${customOrder.phone}
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted"><i class="fas fa-exclamation-circle me-1"></i>Không có</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th><i class="fas fa-envelope me-2"></i>Email:</th>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty customOrder.email}">
                                                        ${customOrder.email}
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted"><i class="fas fa-exclamation-circle me-1"></i>Không có</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th><i class="fas fa-money-bill-wave me-2"></i>Giá mong muốn:</th>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty customOrder.desiredPrice}">
                                                        <p><fmt:formatNumber value="${customOrder.desiredPrice}" type="currency" currencySymbol="" maxFractionDigits="0"/> VNĐ</p>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted"><i class="fas fa-exclamation-circle me-1"></i>Không có</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>

                                        <tr>
                                            <th><i class="fas fa-cubes me-2"></i>Số lượng:</th>
                                            <td>${customOrder.quantity}</td>
                                        </tr>
                                        <tr>
                                            <th><i class="fas fa-calendar-alt me-2"></i>Ngày tạo:</th>
                                            <td><fmt:formatDate value="${customOrder.createdAt}" pattern="dd/MM/yyyy HH:mm:ss" /></td>
                                        </tr>
                                        <tr>
                                            <th><i class="fas fa-tag me-2"></i>Trạng thái:</th>
                                            <td>
                                                <span class="status-badge status-${customOrder.statusID}">
                                                    <c:choose>
                                                        <c:when test="${customOrder.statusID == 2}">
                                                            <i class="fas fa-check me-1"></i>Đã duyệt và đóng gói
                                                        </c:when>
                                                        <c:when test="${customOrder.statusID == 7}">
                                                            <i class="fas fa-check me-1"></i>Đã duyệt đơn thiết kế
                                                        </c:when>
                                                    </c:choose>
                                                </span>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th><i class="fas fa-comment me-2"></i>Nhận xét của quản lý:</th>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty customOrder.managerComment}">
                                                        <p class="mb-0">${customOrder.managerComment}</p>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted"><i class="fas fa-exclamation-circle me-1"></i>Không có</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </div>

                            <!-- Mô tả đơn hàng -->
                            <div class="card">
                                <div class="card-header bg-info text-white">
                                    <i class="fas fa-file-alt me-2"></i>Mô tả chi tiết
                                </div>
                                <div class="card-body">
                                    <p class="mb-0">${customOrder.description}</p>
                                </div>
                            </div>
                        </div>

                        <!-- Hình ảnh tham khảo -->
                        <div class="col-md-6">
                            <div class="card">
                                <div class="card-header bg-info text-white">
                                    <i class="fas fa-image me-2"></i>Hình ảnh tham khảo
                                </div>
                                <div class="card-body text-center">
                                    <!-- Hình ảnh chính -->
                                    <div class="reference-image-container mb-3">
                                        <c:choose>
                                            <c:when test="${empty customOrder.referenceImage}">
                                                <img src="${pageContext.request.contextPath}/img/user.jpg" alt="Hình ảnh mặc định" class="reference-image">
                                            </c:when>
                                            <c:otherwise>
                                                <img src="${pageContext.request.contextPath}/${customOrder.referenceImage}" alt="Hình ảnh tham khảo chính" class="reference-image" onerror="this.src='${pageContext.request.contextPath}/img/user.jpg'">
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                    <!-- Hình ảnh bổ sung -->
                                    <div class="additional-images row">
                                        <c:if test="${not empty customOrder.referenceImage2}">
                                            <div class="col-md-6 mb-3">
                                                <div class="reference-image-container">
                                                    <img src="${pageContext.request.contextPath}/${customOrder.referenceImage2}" alt="Hình ảnh tham khảo 2" class="reference-image" onerror="this.style.display='none'">
                                                </div>
                                            </div>
                                        </c:if>
                                        <c:if test="${not empty customOrder.referenceImage3}">
                                            <div class="col-md-6 mb-3">
                                                <div class="reference-image-container">
                                                    <img src="${pageContext.request.contextPath}/${customOrder.referenceImage3}" alt="Hình ảnh tham khảo 3" class="reference-image" onerror="this.style.display='none'">
                                                </div>
                                            </div>
                                        </c:if>
                                        <c:if test="${not empty customOrder.referenceImage4}">
                                            <div class="col-md-6 mb-3">
                                                <div class="reference-image-container">
                                                    <img src="${pageContext.request.contextPath}/${customOrder.referenceImage4}" alt="Hình ảnh tham khảo 4" class="reference-image" onerror="this.style.display='none'">
                                                </div>
                                            </div>
                                        </c:if>
                                        <c:if test="${not empty customOrder.referenceImage5}">
                                            <div class="col-md-6 mb-3">
                                                <div class="reference-image-container">
                                                    <img src="${pageContext.request.contextPath}/${customOrder.referenceImage5}" alt="Hình ảnh tham khảo 5" class="reference-image" onerror="this.style.display='none'">
                                                </div>
                                            </div>
                                        </c:if>
                                    </div>

                                    <div class="mt-3">
                                        <a href="${pageContext.request.contextPath}/${customOrder.referenceImage}" class="btn btn-outline-primary" target="_blank">
                                            <i class="fas fa-external-link-alt me-1"></i>Xem ảnh đầy đủ
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    </body>
</html>