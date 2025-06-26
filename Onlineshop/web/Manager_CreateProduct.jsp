<%-- 
    Document   : Manager_ListMaterial
    Created on : Jun 21, 2025, 2:55:29 AM
    Author     : Duccon
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="Model.Account" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Material Manager</title>
        <!-- Bootstrap CSS -->
        <link href="css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <!-- Custom CSS -->
        <link href="<c:url value='/css/admin.css'/>" rel="stylesheet">
        <link href="css/style.css" rel="stylesheet">
        <!-- Select2 CSS -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.13/css/select2.min.css" rel="stylesheet" />
    </head>
    <body>
        <jsp:include page="manager_topbarsidebar.jsp" />

        <main class="main-content">
            <h2>Thêm sản phẩm mới</h2>
            <form action="addproduct" method="post" enctype="multipart/form-data">
                <div class="mb-3">
                    <label for="title" class="form-label fw-bold fs-5 text-dark">Tên sản phẩm</label>
                    <input type="text" class="form-control" name="title" id="title" required>
                    <img id="previewImage" src="#" alt="Ảnh sản phẩm" style="max-width: 200px; display: none; margin-top: 10px;">

                </div>

                <div class="mb-3">
                    <label for="image" class="form-label fw-bold fs-5 text-dark">Ảnh sản phẩm</label>
                    <input type="file" class="form-control" name="image" id="image" accept="image/*" required>
                </div>

                <div class="mb-3">
                    <label for="price" class="form-label fw-bold fs-5 text-dark">Giá bán (VNĐ)</label>
                    <input type="text" class="form-control" name="price" id="price" required>
                </div>

                <div class="mb-3">
                    <label for="description" class="form-label fw-bold fs-5 text-dark">Mô tả</label>
                    <textarea class="form-control" name="description" id="description" rows="3"></textarea>
                </div>

                <div class="mb-3">
                    <label for="colorID" class="form-label fw-bold fs-5 text-dark">Màu sắc</label>
                    <select name="colorID">
                        <c:forEach var="color" items="${colorList}">
                            <option value="${color.colorID}">${color.colorName}</option>
                        </c:forEach>
                    </select>

                </div>

                <div class="mb-3">
                    <label for="seasonID" class="form-label fw-bold fs-5 text-dark">Mùa</label>
                    <select name="seasonID">
                        <c:forEach var="season" items="${seasonList}">
                            <option value="${season.seasonID}">${season.seasonName}</option>
                        </c:forEach>
                    </select>

                </div>

                <div class="mb-3">
                    <label for="categoryID" class="form-label fw-bold fs-5 text-dark">Danh mục</label>
                    <select id="categoryID" name="categoryID" class="form-control" multiple>
                        <c:forEach var="cat" items="${categoryList}">
                            <option value="${cat.categoryID}">${cat.categoryName}</option>
                        </c:forEach>
                    </select>
                </div>


                <div class="mb-3">
                    <label class="form-label fw-bold fs-5 text-dark">Chọn nguyên liệu</label>
                    <c:forEach var="m" items="${materialList}">
                        <div class="row mb-1">
                            <div class="col-md-6">
                                <label>${m.name} (${m.unit})</label>
                            </div>
                            <div class="col-md-6">
                                <input type="number" min="0" class="form-control" name="material_${m.materialID}" placeholder="Số lượng sử dụng">
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <button type="submit" class="btn btn-primary">Thêm sản phẩm</button>
            </form>
        </main>

        <footer class="footer">
            <div class="container-fluid">
                <div class="row">
                    <h3>Đây là footer</h3>
                </div>
            </div>
        </footer>
        <!-- jQuery -->
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <!-- Select2 JS -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.13/js/select2.min.js"></script>
        <script>
            $(document).ready(function () {
                $('#categoryID').select2({
                    placeholder: "Chọn danh mục",
                    allowClear: true,
                    width: '100%'
                });
            });
        </script>
        <script>
            document.getElementById('image').addEventListener('change', function (event) {
                const file = event.target.files[0];
                if (file) {
                    const reader = new FileReader();
                    reader.onload = function (e) {
                        const img = document.getElementById('previewImage');
                        img.src = e.target.result;
                        img.style.display = 'block';
                    };
                    reader.readAsDataURL(file);
                }
            });
        </script>

    </body>

</html>
