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
        <title>Thêm sản phẩm</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.13/css/select2.min.css" rel="stylesheet" />

        <style>
            body {
                background-color: #f8f9fa;
            }

            .main-content {
                margin: 40px auto;
                background-color: #fff;
                padding: 20px 30px;
                border-radius: 16px;
                box-shadow: 0 0 20px rgba(0,0,0,0.1);
            }

            h2 {
                text-align: center;
                font-weight: bold;
                margin-bottom: 30px;
            }

            .form-label {
                font-weight: 600;
            }

            .form-control {
                border-radius: 10px;
                box-shadow: none;
            }

            .select2-container .select2-selection--multiple {
                border-radius: 10px;
            }

            #previewImage {
                max-width: 100%;
                max-height: 250px;
                display: block;
                margin: 10px auto;
                border-radius: 12px;
                border: 1px solid #dee2e6;
            }

            .form-section {
                margin-bottom: 20px;
            }

            .btn-primary {
                border-radius: 10px;
                padding: 10px 25px;
                font-weight: bold;
            }
        </style>
    </head>
    <body>
        <jsp:include page="manager_topbarsidebar.jsp" />

        <div class="main-content">
            <h2>Thêm sản phẩm mới</h2>
            <form action="addproduct" method="post" enctype="multipart/form-data">
                <div class="form-section">
                    <label for="title" class="form-label">Tên sản phẩm</label>
                    <input type="text" class="form-control" name="title" id="title" required>
                </div>

                <div class="form-section text-center">
                    <img id="previewImage" src="#" alt="Ảnh sản phẩm" style="display: none;">
                    <input type="file" class="form-control mt-2" name="image" id="image" accept="image/*" required>
                </div>

                <div class="form-section">
                    <label for="price" class="form-label">Giá bán (VNĐ)</label>
                    <input type="text" class="form-control" name="price" id="price" required>
                </div>

                <div class="form-section">
                    <label for="description" class="form-label">Mô tả</label>
                    <textarea class="form-control" name="description" id="description" rows="3"></textarea>
                </div>

                <div class="form-section">
                    <label for="colorID" class="form-label">Màu sắc</label>
                    <select name="colorID" class="form-control">
                        <c:forEach var="color" items="${colorList}">
                            <option value="${color.colorID}">${color.colorName}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="form-section">
                    <label for="seasonID" class="form-label">Mùa</label>
                    <select name="seasonID" class="form-control">
                        <c:forEach var="season" items="${seasonList}">
                            <option value="${season.seasonID}">${season.seasonName}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="form-section">
                    <label for="categoryID" class="form-label">Danh mục</label>
                    <select id="categoryID" name="categoryID" class="form-control" multiple>
                        <c:forEach var="cat" items="${categoryList}">
                            <option value="${cat.categoryID}">${cat.categoryName}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="form-section">
                    <label class="form-label">Nguyên liệu sử dụng</label>
                    <c:forEach var="m" items="${materialList}">
                        <div class="row mb-2">
                            <div class="col-md-6 d-flex align-items-center">
                                <span>${m.name} (${m.unit})</span>
                            </div>
                            <div class="col-md-6">
                                <input type="number" min="0" class="form-control" name="material_${m.materialID}" placeholder="Số lượng sử dụng">
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <div class="text-center">
                    <button type="submit" class="btn btn-primary">Thêm sản phẩm</button>
                </div>
            </form>
        </div>

        <footer class="footer text-center mt-5">
            <p>&copy; Quản lý sản phẩm - 2025</p>
        </footer>

        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.13/js/select2.min.js"></script>
        <script>
            $(document).ready(function () {
                $('#categoryID').select2({
                    placeholder: "Chọn danh mục",
                    allowClear: true,
                    width: '100%'
                });

                // Preview ảnh
                $('#image').on('change', function (event) {
                    const file = event.target.files[0];
                    if (file) {
                        const reader = new FileReader();
                        reader.onload = function (e) {
                            $('#previewImage').attr('src', e.target.result).show();
                        };
                        reader.readAsDataURL(file);
                    }
                });
            });
        </script>
    </body>
</html>

