<%-- 
    Document   : Manager_ListCardTemplate
    Created on : Jul 22, 2025, 1:15:00 AM
    Author     : Cline
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<jsp:include page="manager_topbarsidebar.jsp" />
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Quản lý Thiệp</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <style>
            .card-img-preview {
                max-width: 100px;
                max-height: 100px;
                object-fit: cover;
                border-radius: 5px;
            }
        </style>
    </head>
    <body>
        <div class="main-content">
            <div class="container-fluid">
                <h2 class="mb-4">Quản lý Thiệp</h2>

                <div class="d-flex justify-content-between align-items-center mb-3">
                    <a href="${pageContext.request.contextPath}/manager/cardtemplates?action=create" class="btn btn-primary">
                        <i class="fas fa-plus"></i> Thêm Thiệp Mới
                    </a>
                </div>

                <div class="card shadow-sm">
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover table-striped">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Tên Thiệp</th>
                                        <th>Mô tả</th>
                                        <th>Giá</th>
                                        <th>Ảnh</th>
                                        <th>Trạng thái</th>
                                        <th>Hành động</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${cardTemplates}" var="card">
                                        <tr>
                                            <td>${card.cardId}</td>
                                            <td>${card.cardName}</td>
                                            <td>${card.description}</td>
                                            <td><fmt:formatNumber value="${card.price}" type="currency" currencySymbol="" pattern="#,##0"/>đ</td>
                                            <td>
                                                <c:if test="${not empty card.image}">
                                                    <img src="${pageContext.request.contextPath}/img/${card.image}" alt="${card.cardName}" class="card-img-preview">
                                                </c:if>
                                            </td>
                                            <td>
                                                <span class="badge ${card.isActive ? 'bg-success' : 'bg-danger'}">
                                                    ${card.isActive ? 'Hoạt động' : 'Vô hiệu hóa'}
                                                </span>
                                            </td>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/manager/cardtemplates?action=edit&cardId=${card.cardId}" class="btn btn-sm btn-info me-1" title="Chỉnh sửa">
                                                    <i class="fas fa-edit"></i>
                                                </a>
                                                <c:if test="${card.isActive}">
                                                    <button type="button" class="btn btn-sm btn-warning me-1" onclick="confirmAction(${card.cardId}, 'deactivate')" title="Vô hiệu hóa">
                                                        <i class="fas fa-ban"></i>
                                                    </button>
                                                </c:if>
                                                <c:if test="${!card.isActive}">
                                                    <button type="button" class="btn btn-sm btn-success me-1" onclick="confirmAction(${card.cardId}, 'activate')" title="Kích hoạt">
                                                        <i class="fas fa-check-circle"></i>
                                                    </button>
                                                </c:if>
                                                <button type="button" class="btn btn-sm btn-danger" onclick="confirmAction(${card.cardId}, 'delete')" title="Xóa">
                                                    <i class="fas fa-trash"></i>
                                                </button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty cardTemplates}">
                                        <tr>
                                            <td colspan="7" class="text-center">Không có thiệp nào được tìm thấy.</td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Confirmation Modal -->
        <div class="modal fade" id="confirmationModal" tabindex="-1" aria-labelledby="confirmationModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="confirmationModalLabel">Xác nhận hành động</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body" id="modalMessage">
                        Bạn có chắc chắn muốn thực hiện hành động này?
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="button" class="btn btn-primary" id="confirmButton">Xác nhận</button>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            var currentCardId;
            var currentAction;

            function confirmAction(cardId, action) {
                currentCardId = cardId;
                currentAction = action;
                let message = "";
                switch (action) {
                    case 'delete':
                        message = "Bạn có chắc chắn muốn xóa thiệp này? Hành động này không thể hoàn tác.";
                        break;
                    case 'activate':
                        message = "Bạn có chắc chắn muốn kích hoạt thiệp này?";
                        break;
                    case 'deactivate':
                        message = "Bạn có chắc chắn muốn vô hiệu hóa thiệp này?";
                        break;
                }
                $('#modalMessage').text(message);
                var confirmationModal = new bootstrap.Modal(document.getElementById('confirmationModal'));
                confirmationModal.show();
            }

            document.getElementById('confirmButton').addEventListener('click', function() {
                var confirmationModal = bootstrap.Modal.getInstance(document.getElementById('confirmationModal'));
                confirmationModal.hide();
                window.location.href = "${pageContext.request.contextPath}/manager/cardtemplates?action=" + currentAction + "&cardId=" + currentCardId;
            });
        </script>
    </body>
</html>
