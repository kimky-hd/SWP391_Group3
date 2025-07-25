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
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link href="${pageContext.request.contextPath}/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/css/shipper-style.css" rel="stylesheet">
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
                        <div class="page-header">
                            <h1 class="page-title">
                                <i class="fas fa-box-open me-2"></i>
                                Đơn hàng tự thiết kế
                            </h1>
                            <p class="page-subtitle">Quản lý đơn hàng tự thiết kế cần giao</p>
                        </div>
                    </div>
                </div>

                <!-- Filter Card -->
                <div class="card mb-4">
                    <div class="card-header">
                        <i class="fas fa-filter me-2"></i>Bộ lọc
                    </div>
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/shipper/custom-orders" method="GET" class="row g-3">
                            <div class="col-md-3">
                                <label for="orderId" class="form-label">Mã đơn hàng</label>
                                <input type="number" class="form-control" id="orderId" name="orderId" value="${orderId}" placeholder="Nhập mã đơn hàng">
                            </div>
                            <div class="col-md-3">
                                <label for="customerName" class="form-label">Tên khách hàng</label>
                                <input type="text" class="form-control" id="customerName" name="customerName" value="${customerName}" placeholder="Nhập tên khách hàng">
                            </div>
                            <div class="col-md-3">
                                <label for="status" class="form-label">Trạng thái</label>
                                <select class="form-select" id="status" name="status">
                                    <option value="" ${empty status ? 'selected' : ''}>Tất cả trạng thái</option>
                                    <option value="2" ${status == '2' ? 'selected' : ''}>Đã duyệt</option>
                                    <option value="3" ${status == '3' ? 'selected' : ''}>Đang vận chuyển</option>
                                    <option value="4" ${status == '4' ? 'selected' : ''}>Đã giao hàng thành công</option>
                                    <option value="9" ${status == '9' ? 'selected' : ''}>Không thành công</option>
                                </select>
                            </div>
                            <div class="col-md-3 d-flex align-items-end">
                                <button type="submit" class="btn btn-primary me-2">
                                    <i class="fas fa-search me-1"></i>Tìm kiếm
                                </button>
                                <a href="${pageContext.request.contextPath}/shipper/custom-orders" class="btn btn-secondary">
                                    <i class="fas fa-redo me-1"></i>Đặt lại
                                </a>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Orders List Card -->
                <div class="card">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <div>
                            <i class="fas fa-list me-2"></i>Danh sách đơn hàng tự thiết kế
                        </div>
                    </div>
                    <div class="card-body">
                        <c:if test="${not empty errorMessage}">
                            <div class="alert alert-danger" role="alert">
                                <i class="fas fa-exclamation-circle me-2"></i>${errorMessage}
                            </div>
                        </c:if>

                        <c:if test="${empty customOrders}">
                            <div class="text-center py-5">
                                <i class="fas fa-box-open text-muted" style="font-size: 4rem;"></i>
                                <h5 class="mt-3 text-muted">Không có đơn hàng nào</h5>
                                <p class="text-muted">Hiện tại không có đơn hàng tự thiết kế nào cần giao</p>
                            </div>
                        </c:if>

                        <c:if test="${not empty customOrders}">
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th>Mã đơn hàng</th>
                                            <th>Khách hàng</th>
                                            <th>Thông tin liên hệ</th>
                                            <th>Số lượng</th>
                                            <th>Giá mong muốn</th>
                                            <th>Ngày tạo</th>
                                            <th>Trạng thái</th>
                                            <th>Hành động</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${customOrders}" var="order">
                                            <tr>
                                                <td><strong>#${order.customCartID}</strong></td>
                                                <td>${order.fullName}</td>
                                                <td>
                                                    <div><i class="fas fa-phone-alt me-1 text-muted"></i> ${order.phone}</div>
                                                    <div><i class="fas fa-envelope me-1 text-muted"></i> ${order.email}</div>
                                                </td>
                                                <td>${order.quantity}</td>
                                                <td>
                                                    <fmt:formatNumber value="${order.desiredPrice}" type="currency" currencySymbol="" maxFractionDigits="0"/> VNĐ
                                                </td>
                                                <td>
                                                    <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy" />
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${order.statusID eq 2}">
                                                            <span class="status-badge status-2">
                                                                <i class="fas fa-check-circle"></i>Đã duyệt
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${order.statusID eq 3}">
                                                            <span class="status-badge status-3">
                                                                <i class="fas fa-truck"></i>Đang vận chuyển
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${order.statusID eq 4}">
                                                            <span class="status-badge status-4">
                                                                <i class="fas fa-check-double"></i>Đã giao hàng thành công
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${order.statusID eq 9}">
                                                            <span class="status-badge status-9">
                                                                <i class="fas fa-times-circle"></i>Không thành công
                                                            </span>
                                                        </c:when>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <div class="btn-group" role="group">
                                                        <a href="${pageContext.request.contextPath}/shipper/custom-orders?action=detail&id=${order.customCartID}" class="btn btn-sm btn-outline-primary">
                                                            <i class="fas fa-eye"></i>
                                                        </a>
                                                        <!-- DEBUG: Order #${order.customCartID} has statusID: [${order.statusID}] Type: [${order.statusID.class.simpleName}] Test==2: [${order.statusID == 2}] Test eq 2: [${order.statusID eq 2}] -->
                                                        <c:if test="${order.statusID eq 2}">
                                                            <button type="button" class="btn btn-sm btn-primary start-shipping-btn" data-id="${order.customCartID}">
                                                                <i class="fas fa-truck me-1"></i>Bắt đầu giao
                                                            </button>
                                                        </c:if>
                                                        <c:if test="${order.statusID eq 3}">
                                                            <button type="button" class="btn btn-sm btn-success complete-shipping-btn" data-id="${order.customCartID}">
                                                                <i class="fas fa-check me-1"></i>Đã giao
                                                            </button>
                                                            <button type="button" class="btn btn-sm btn-danger cancel-order-btn" data-id="${order.customCartID}">
                                                                <i class="fas fa-times"></i>
                                                            </button>
                                                        </c:if>
                                                        <!-- Status 4 and 9 have no action buttons -->
                                                        <c:if test="${order.statusID eq 4 || order.statusID eq 9}">
                                                            <!-- Final status - no actions available -->
                                                        </c:if>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>

                            <!-- Pagination -->
                            <c:if test="${totalPages > 1}">
                                <nav aria-label="Page navigation" class="mt-4">
                                    <ul class="pagination justify-content-center">
                                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                            <a class="page-link" href="${pageContext.request.contextPath}/shipper/custom-orders?page=${currentPage - 1}&orderId=${orderId}&customerName=${customerName}&status=${status}">
                                                <i class="fas fa-chevron-left"></i>
                                            </a>
                                        </li>
                                        <c:forEach begin="1" end="${totalPages}" var="i">
                                            <li class="page-item ${currentPage == i ? 'active' : ''}">
                                                <a class="page-link" href="${pageContext.request.contextPath}/shipper/custom-orders?page=${i}&orderId=${orderId}&customerName=${customerName}&status=${status}">
                                                    ${i}
                                                </a>
                                            </li>
                                        </c:forEach>
                                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                            <a class="page-link" href="${pageContext.request.contextPath}/shipper/custom-orders?page=${currentPage + 1}&orderId=${orderId}&customerName=${customerName}&status=${status}">
                                                <i class="fas fa-chevron-right"></i>
                                            </a>
                                        </li>
                                    </ul>
                                </nav>
                            </c:if>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>

        <!-- Cancel Order Modal -->
        <div class="modal fade" id="cancelOrderModal" tabindex="-1" aria-labelledby="cancelOrderModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="cancelOrderModalLabel">
                            <i class="fas fa-exclamation-triangle me-2"></i>
                            Hủy đơn hàng
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <p>Bạn có chắc chắn muốn hủy đơn hàng này không?</p>
                        <div class="mb-3">
                            <label for="cancelReason" class="form-label">Lý do hủy đơn hàng:</label>
                            <textarea class="form-control" id="cancelReason" rows="3" placeholder="Vui lòng nhập lý do hủy đơn hàng..." required></textarea>
                        </div>
                        <input type="hidden" id="cancelOrderId" value="">
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="button" class="btn btn-danger" id="confirmCancelBtn">Xác nhận hủy</button>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script>
            $(document).ready(function () {
                // Debug: Log tất cả các nút start-shipping-btn
                console.log("Found start-shipping buttons:", $(".start-shipping-btn").length);
                $(".start-shipping-btn").each(function() {
                    console.log("Start button for order:", $(this).data("id"));
                });

                // Xử lý nút bắt đầu giao hàng
                $(".start-shipping-btn").click(function () {
                    const orderId = $(this).data("id");
                    if (confirm("Bạn có chắc chắn muốn bắt đầu giao đơn hàng #" + orderId + "?")) {
                        updateOrderStatus(orderId, 3);
                    }
                });

                // Xử lý nút hoàn thành giao hàng
                $(".complete-shipping-btn").click(function () {
                    const orderId = $(this).data("id");
                    if (confirm("Bạn có chắc chắn đã giao thành công đơn hàng #" + orderId + "?")) {
                        updateOrderStatus(orderId, 4);
                    }
                });

                // Xử lý nút hủy đơn hàng
                $(".cancel-order-btn").click(function () {
                    const orderId = $(this).data("id");
                    $("#cancelOrderId").val(orderId);
                    $("#cancelOrderModal").modal("show");
                });

                // Xử lý nút xác nhận hủy đơn hàng
                $("#confirmCancelBtn").click(function () {
                    const orderId = $("#cancelOrderId").val();
                    const reason = $("#cancelReason").val();

                    if (!reason.trim()) {
                        alert("Vui lòng nhập lý do hủy đơn hàng!");
                        return;
                    }

                    // Hiển thị trạng thái đang tải
                    $(this).html('<i class="fas fa-spinner fa-spin me-1"></i>Đang xử lý...');
                    $(this).prop('disabled', true);

                    // Gửi yêu cầu AJAX
                    $.ajax({
                        url: "${pageContext.request.contextPath}/shipper/custom-orders",
                        type: "POST",
                        data: {
                            action: "updateStatus",
                            customCartId: orderId,
                            statusId: 9,
                            note: reason
                        },
                        success: function (response) {
                            if (response.success) {
                                alert("Cập nhật đơn hàng không thành công!");
                                location.reload();
                            } else {
                                alert("Lỗi: " + response.message);
                                $("#confirmCancelBtn").html('Xác nhận hủy');
                                $("#confirmCancelBtn").prop('disabled', false);
                            }
                        },
                        error: function () {
                            alert("Đã xảy ra lỗi khi gửi yêu cầu!");
                            $("#confirmCancelBtn").html('Xác nhận hủy');
                            $("#confirmCancelBtn").prop('disabled', false);
                        }
                    });
                });

                // Hàm cập nhật trạng thái đơn hàng
                function updateOrderStatus(orderId, statusId) {
                    $.ajax({
                        url: "${pageContext.request.contextPath}/shipper/custom-orders",
                        type: "POST",
                        data: {
                            action: "updateStatus",
                            customCartId: orderId,
                            statusId: statusId
                        },
                        success: function (response) {
                            if (response.success) {
                                alert("Cập nhật trạng thái thành công!");
                                location.reload();
                            } else {
                                alert("Lỗi: " + response.message);
                            }
                        },
                        error: function () {
                            alert("Đã xảy ra lỗi khi gửi yêu cầu!");
                        }
                    });
                }
            });
        </script>
    </body>
</html>