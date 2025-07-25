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
        <link href="${pageContext.request.contextPath}/css/shipper-style.css" rel="stylesheet">

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
                background-color: #c3e6cb;
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
                background-color: #cff4fc;
                color: #055160;
            } /* Đã duyệt */
            .status-3 {
                background-color: #cfe2ff;
                color: #084298;
            } /* Đang vận chuyển */
            .status-4 {
                background-color: #d1e7dd;
                color: #0f5132;
            } /* Đã giao hàng thành công */
            .status-9 {
                background-color: #f8d7da;
                color: #721c24;
            } /* Không thành công */

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
                border-radius: 10px;
                padding: 15px 20px;
                margin-bottom: 25px;
                border: none;
            }

            .alert-success {
                background-color: #d1e7dd;
                color: #0f5132;
            }

            .alert-danger {
                background-color: #f8d7da;
                color: #721c24;
            }
        </style>
    </head>
    <body>
        <!-- Include topbar and sidebar -->
        <jsp:include page="../manager_topbarsidebar.jsp" />

        <!-- Main Content -->
        <div class="main-content">
            <div class="container-fluid">
                <!-- Page Header -->
                <div class="row mb-4">
                    <div class="col-12">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h1 class="page-title">
                                    <i class="fas fa-box-open me-2"></i>
                                    Chi tiết đơn hàng tự thiết kế #${customOrder.customCartID}
                                </h1>
                                <nav aria-label="breadcrumb">
                                    <ol class="breadcrumb">
                                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/shipper/dashboard">Dashboard</a></li>
                                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/shipper/custom-orders">Đơn hàng tự thiết kế</a></li>
                                        <li class="breadcrumb-item active" aria-current="page">Chi tiết đơn hàng #${customOrder.customCartID}</li>
                                    </ol>
                                </nav>
                            </div>
                            <div>
                                <a href="${pageContext.request.contextPath}/shipper/custom-orders" class="btn btn-secondary">
                                    <i class="fas fa-arrow-left me-1"></i>Quay lại
                                </a>
                            </div>
                        </div>
                    </div>
                </div>

                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger" role="alert">
                        <i class="fas fa-exclamation-circle me-2"></i>${errorMessage}
                    </div>
                </c:if>

                <div class="row">
                    <!-- Thông tin đơn hàng -->
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-header">
                                <i class="fas fa-info-circle me-2"></i>Thông tin đơn hàng
                            </div>
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="info-table">
                                        <tr>
                                            <th><i class="fas fa-hashtag me-2"></i>Mã đơn hàng:</th>
                                            <td><strong>#${customOrder.customCartID}</strong></td>
                                        </tr>
                                        <tr>
                                            <th><i class="fas fa-user me-2"></i>Khách hàng:</th>
                                            <td>${customOrder.fullName}</td>
                                        </tr>
                                        <tr>
                                            <th><i class="fas fa-phone-alt me-2"></i>Số điện thoại:</th>
                                            <td>${customOrder.phone}</td>
                                        </tr>
                                        <tr>
                                            <th><i class="fas fa-envelope me-2"></i>Email:</th>
                                            <td>${customOrder.email}</td>
                                        </tr>
                                        <!-- Thông tin địa chỉ khách hàng -->
                                        <tr>
                                            <th><i class="fas fa-map-marker-alt me-2"></i>Địa chỉ:</th>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty customOrder.address}">
                                                        ${customOrder.address}
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted"><i class="fas fa-exclamation-circle me-1"></i>Không có</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th><i class="fas fa-city me-2"></i>Quận/Huyện:</th>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty customOrder.district}">
                                                        ${customOrder.district}
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted"><i class="fas fa-exclamation-circle me-1"></i>Không có</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th><i class="fas fa-map me-2"></i>Thành phố:</th>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty customOrder.city}">
                                                        ${customOrder.city}
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
                                                            <i class="fas fa-check-circle"></i>Đã duyệt
                                                        </c:when>
                                                        <c:when test="${customOrder.statusID == 9}">
                                                            <i class="fas fa-times-circle"></i>Không thành công
                                                        </c:when>
                                                        <c:when test="${customOrder.statusID == 3}">
                                                            <i class="fas fa-truck"></i>Đang vận chuyển
                                                        </c:when>
                                                        <c:when test="${customOrder.statusID == 4}">
                                                            <i class="fas fa-check-double"></i>Đã giao hàng thành công
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
                        </div>

                        <!-- Mô tả đơn hàng -->
                        <div class="card">
                            <div class="card-header">
                                <i class="fas fa-file-alt me-2"></i>Mô tả chi tiết
                            </div>
                            <div class="card-body">
                                <p class="mb-0">${customOrder.description}</p>
                            </div>
                        </div>

                        <!-- Cập nhật trạng thái -->
                        <div class="card">
                            <div class="card-header">
                                <i class="fas fa-edit me-2"></i>Cập nhật trạng thái
                            </div>
                            <div class="card-body">
                                <form id="updateStatusForm">
                                    <input type="hidden" name="customCartId" value="${customOrder.customCartID}">
                                    <input type="hidden" name="action" value="updateStatus">

                                    <div class="mb-3">
                                        <label for="statusId" class="form-label">Trạng thái mới:</label>
                                        <select class="form-select" id="statusId" name="statusId" required>
                                            <c:if test="${customOrder.statusID == 2}">
                                                <option value="3">Đang vận chuyển</option>
                                                <option value="9">Không thành công</option>
                                            </c:if>
                                            <c:if test="${customOrder.statusID == 3}">
                                                <option value="4">Đã giao hàng thành công</option>
                                                <option value="9">Không thành công</option>
                                            </c:if>
                                        </select>
                                    </div>

                                    <div class="mb-3" id="cancelReasonGroup" style="display: none;">
                                        <label for="note" class="form-label">Lý do không thành công:</label>
                                        <textarea class="form-control" id="note" name="note" rows="3" placeholder="Vui lòng nhập lý do không thành công..."></textarea>
                                    </div>

                                    <button type="button" id="updateStatusBtn" class="btn btn-primary">
                                        <i class="fas fa-save me-1"></i>Cập nhật trạng thái
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>

                    <!-- Hình ảnh tham khảo -->
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-header">
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

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

        <script>
            $(document).ready(function () {
                // Hiển thị/ẩn trường lý do hủy đơn hàng dựa trên trạng thái được chọn
                $("#statusId").change(function () {
                    if ($(this).val() == "9") {
                        $("#cancelReasonGroup").show();
                        $("#note").attr("required", true);
                    } else {
                        $("#cancelReasonGroup").hide();
                        $("#note").attr("required", false);
                    }
                });

                // Xử lý sự kiện khi nhấn nút cập nhật trạng thái
                $("#updateStatusBtn").click(function () {
                    // Kiểm tra nếu là hủy đơn hàng thì phải có lý do
                    if ($("#statusId").val() == "9" && $("#note").val().trim() === "") {
                        alert("Vui lòng nhập lý do không thành công!");
                        return;
                    }

                    // Hiển thị trạng thái đang tải
                    $(this).html('<i class="fas fa-spinner fa-spin me-1"></i>Đang cập nhật...');
                    $(this).prop('disabled', true);

                    // Lấy dữ liệu từ form
                    var formData = $("#updateStatusForm").serialize();

                    // Gửi yêu cầu AJAX
                    $.ajax({
                        url: "${pageContext.request.contextPath}/shipper/custom-orders",
                        type: "POST",
                        data: formData,
                        success: function (response) {
                            if (response.success) {
                                alert("Cập nhật trạng thái thành công!");
                                window.location.href = "${pageContext.request.contextPath}/shipper/custom-orders";
                            } else {
                                alert("Lỗi: " + response.message);
                                $("#updateStatusBtn").html('<i class="fas fa-save me-1"></i>Cập nhật trạng thái');
                                $("#updateStatusBtn").prop('disabled', false);
                            }
                        },
                        error: function () {
                            alert("Đã xảy ra lỗi khi gửi yêu cầu!");
                            $("#updateStatusBtn").html('<i class="fas fa-save me-1"></i>Cập nhật trạng thái');
                            $("#updateStatusBtn").prop('disabled', false);
                        }
                    });
                });
            });
        </script>
    </body>
</html>