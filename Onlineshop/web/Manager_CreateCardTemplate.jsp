<%-- 
    Document   : Manager_CreateCardTemplate
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
        <title>Tạo Thiệp Mới</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    </head>
    <body>
        <div class="main-content">
            <div class="container-fluid">
                <h2 class="mb-4">Tạo Thiệp Mới</h2>

                <div class="card shadow-sm">
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/manager/cardtemplates" method="post" enctype="multipart/form-data">
                            <input type="hidden" name="action" value="create">

                            <div class="mb-3">
                                <label for="cardName" class="form-label">Tên Thiệp <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="cardName" name="cardName" required>
                            </div>

                            <div class="mb-3">
                                <label for="description" class="form-label">Mô tả</label>
                                <textarea class="form-control" id="description" name="description" rows="3"></textarea>
                            </div>

                            <div class="mb-3">
                                <label for="price" class="form-label">Giá (VNĐ) <span class="text-danger">*</span></label>
                                <input type="number" class="form-control" id="price" name="price" step="0.01" min="0" required>
                            </div>
                            
                            <div class="mb-3">
                                <label for="image" class="form-label">Ảnh Thiệp</label>
                                <input type="file" class="form-control" id="image" name="image" accept="image/*">
                                <small class="form-text text-muted">Chọn ảnh cho thiệp (tùy chọn).</small>
                            </div>

                            <button type="submit" class="btn btn-primary">Tạo Thiệp</button>
                            <a href="${pageContext.request.contextPath}/manager/cardtemplates" class="btn btn-secondary">Hủy</a>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
