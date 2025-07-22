<%-- 
    Document   : Manager_UpdateCardTemplate
    Created on : Jul 22, 2025, 1:15:00 AM
    Author     : Cline
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<jsp:include page="manager_topbarsidebar.jsp" />
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Cập nhật Thiệp</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <style>
            .current-image-preview {
                max-width: 200px;
                height: auto;
                margin-top: 10px;
                border: 1px solid #ddd;
                border-radius: 5px;
            }
        </style>
    </head>
    <body>
        <div class="main-content">
            <div class="container-fluid">
                <h2 class="mb-4">Cập nhật Thiệp</h2>

                <div class="card shadow-sm">
                    <div class="card-body">
                        <c:if test="${card != null}">
                            <form action="${pageContext.request.contextPath}/manager/cardtemplates" method="post" enctype="multipart/form-data">
                                <input type="hidden" name="action" value="update">
                                <input type="hidden" name="cardId" value="${card.cardId}">
                                <input type="hidden" name="existingImage" value="${card.image}">

                                <div class="mb-3">
                                    <label for="cardName" class="form-label">Tên Thiệp <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="cardName" name="cardName" value="${card.cardName}" required>
                                </div>

                                <div class="mb-3">
                                    <label for="description" class="form-label">Mô tả</label>
                                    <textarea class="form-control" id="description" name="description" rows="3">${card.description}</textarea>
                                </div>

                                <div class="mb-3">
                                    <label for="price" class="form-label">Giá (VNĐ) <span class="text-danger">*</span></label>
                                    <input type="number" class="form-control" id="price" name="price" step="0.01" min="0" value="${card.price}" required>
                                </div>

                                <div class="mb-3">
                                    <label for="image" class="form-label">Ảnh Thiệp Hiện Tại</label>
                                    <c:if test="${not empty card.image}">
                                        <img src="${pageContext.request.contextPath}/img/${card.image}" alt="Current Card Image" class="current-image-preview">
                                    </c:if>
                                    <input type="file" class="form-control mt-2" id="image" name="image" accept="image/*">
                                    <small class="form-text text-muted">Chọn ảnh mới để thay thế ảnh hiện tại (tùy chọn).</small>
                                </div>
                                
                                <div class="mb-3 form-check">
                                    <input type="checkbox" class="form-check-input" id="isActive" name="isActive" value="true" ${card.isActive ? 'checked' : ''}>
                                    <label class="form-check-label" for="isActive">Hoạt động</label>
                                </div>

                                <button type="submit" class="btn btn-primary">Cập nhật Thiệp</button>
                                <a href="${pageContext.request.contextPath}/manager/cardtemplates" class="btn btn-secondary">Hủy</a>
                            </form>
                        </c:if>
                        <c:if test="${card == null}">
                            <div class="alert alert-warning" role="alert">
                                Không tìm thấy thiệp để cập nhật.
                            </div>
                            <a href="${pageContext.request.contextPath}/manager/cardtemplates" class="btn btn-info">Quay lại danh sách</a>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
