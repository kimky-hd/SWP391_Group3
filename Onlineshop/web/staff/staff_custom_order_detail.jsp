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
                        <a href="${pageContext.request.contextPath}/staff/staff_custom-orders" class="btn btn-secondary">
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
                                <div class="card-header">
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
                                                            <i class="fas fa"></i>Đơn hàng đang được đóng gói
                                                        </c:when>
                                                        <c:when test="${customOrder.statusID == 3}">
                                                            <i class="fas fa"></i>Đơn hàng đang được vận chuyển
                                                        </c:when>
                                                        <c:when test="${customOrder.statusID == 4}">
                                                            <i class="fas fa"></i>Đã giao hàng thành công
                                                        </c:when>
                                                        <c:when test="${customOrder.statusID == 5}">
                                                            <i class="fas fa"></i>Đã thanh toán thành công
                                                        </c:when>
                                                        <c:when test="${customOrder.statusID == 6}">
                                                            <i class="fas fa"></i>Đã hủy
                                                        </c:when>
                                                        <c:when test="${customOrder.statusID == 7}">
                                                            <i class="fas fa"></i>Đã duyệt đơn thiết kế
                                                        </c:when>
                                                        <c:when test="${customOrder.statusID == 8}">
                                                            <i class="fas fa"></i>Đơn thiết kế đã bị từ chối
                                                        </c:when>
                                                        <c:when test="${customOrder.statusID == 9}">
                                                            <i class="fas fa"></i>Sẵn sàng giao
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
                                                <option value="2" ${customOrder.statusID == 2 ? 'selected' : ''}>Đơn hàng đang được đóng gói</option>
                                                <option value="9" ${customOrder.statusID == 9 ? 'selected' : ''}>Sẵn sàng giao</option>
                                                <option value="3" ${customOrder.statusID == 3 ? 'selected' : ''}>Đang vận chuyển</option>
                                                <option value="5" ${customOrder.statusID == 5 ? 'selected' : ''}>Đã thanh toán thành công</option>
                                                <option value="6" ${customOrder.statusID == 6 ? 'selected' : ''}>Đã hủy</option>
                                                
                                            </select>
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
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

        <script>
            $(document).ready(function () {
                // Xử lý sự kiện khi nhấn nút cập nhật trạng thái
                $("#updateStatusBtn").click(function () {
                    // Hiển thị trạng thái đang tải
                    $(this).html('<i class="fas fa-spinner fa-spin me-1"></i>Đang cập nhật...');
                    $(this).prop('disabled', true);

                    // Lấy dữ liệu từ form
                    var customCartId = $("input[name='customCartId']").val();
                    var statusId = $("#statusId").val();
                    var action = $("input[name='action']").val();

                    // Gửi yêu cầu AJAX
                    $.ajax({
                        url: "${pageContext.request.contextPath}/staff/staff_custom-orders",
                        type: "POST",
                        data: {
                            customCartId: customCartId,
                            statusId: statusId,
                            action: action
                        },
                        dataType: "json",
                        success: function (response) {
                            // Hiển thị thông báo
                            var statusMessage = $("#statusMessage");
                            statusMessage.removeClass("alert-success alert-danger");

                            if (response.success) {
                                statusMessage.addClass("alert-success");
                                // Cập nhật hiển thị trạng thái trên trang
                                updateStatusDisplay(statusId);
                            } else {
                                statusMessage.addClass("alert-danger");
                            }

                            statusMessage.html(response.message);
                            statusMessage.show();

                            // Tự động ẩn thông báo sau 5 giây
                            setTimeout(function () {
                                statusMessage.fadeOut();
                            }, 5000);

                            // Khôi phục trạng thái nút
                            $("#updateStatusBtn").html('<i class="fas fa-save me-1"></i>Cập nhật trạng thái');
                            $("#updateStatusBtn").prop('disabled', false);
                        },
                        error: function (xhr, status, error) {
                            // Hiển thị thông báo lỗi
                            var statusMessage = $("#statusMessage");
                            statusMessage.removeClass("alert-success alert-danger");
                            statusMessage.addClass("alert-danger");
                            statusMessage.html("Đã xảy ra lỗi khi cập nhật trạng thái: " + error);
                            statusMessage.show();

                            // Khôi phục trạng thái nút
                            $("#updateStatusBtn").html('<i class="fas fa-save me-1"></i>Cập nhật trạng thái');
                            $("#updateStatusBtn").prop('disabled', false);
                        }
                    });
                });

                // Hàm cập nhật hiển thị trạng thái trên trang
                function updateStatusDisplay(statusId) {
                    var statusBadge = $(".status-badge");
                    statusBadge.removeClass();
                    statusBadge.addClass("status-badge status-" + statusId);

                    var statusText = "";
                    var statusIcon = '<i class="fas fa-check me-1"></i>';

                    switch (parseInt(statusId)) {
                        case 2:
                            statusText = "Đã duyệt và đóng gói";
                            break;
                        case 3:
                            statusText = "Đang vận chuyển";
                            statusIcon = '<i class="fas fa-truck me-1"></i>';
                            break;
                        case 6:
                            statusText = "Đã hủy";
                            statusIcon = '<i class="fas fa-times me-1"></i>';
                            break;
                        case 9:
                            statusText = "Sẵn sàng giao";
                            statusIcon = '<i class="fas fa-box me-1"></i>';
                            break;
                        default:
                            statusText = "Chờ duyệt";
                            statusIcon = '<i class="fas fa-clock me-1"></i>';
                    }

                    statusBadge.html(statusIcon + statusText);
                }
            });
        </script>
    </body>
</html>