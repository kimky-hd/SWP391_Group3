<%-- 
    Document   : Manager_UpdateProduct
    Created on : Jun 27, 2025, 1:30:12 AM
    Author     : Duccon
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Cập nhật sản phẩm</title>
        <link href="css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body>

        <jsp:include page="manager_topbarsidebar.jsp" />

        <main class="main-content">
            <div class="container mt-5">
                <h2>Cập nhật sản phẩm</h2>

                <form action="updateproduct" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="productID" value="${product.productID}"/>

                    <div class="mb-3">
                        <label for="title">Tên sản phẩm:</label>
                        <input type="text" class="form-control" name="title" value="${product.title}">
                        <c:if test="${not empty errorTitle}">
                            <small class="text-danger">${errorTitle}</small>
                        </c:if>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Ảnh hiện tại:</label><br>
                        <img src="${pageContext.request.contextPath}/img/${product.image}" width="120" class="mb-2">
                        <input type="file" name="image" class="form-control"/>
                        <small class="text-muted">Chọn ảnh mới nếu muốn thay đổi.</small>
                    </div>

                    <div class="mb-3">
                        <label for="price">Giá (VND):</label>
                        <input type="text" class="form-control" name="price" value="${product.price}">
                        <c:if test="${not empty errorPrice}">
                            <small class="text-danger">${errorPrice}</small>
                        </c:if>
                    </div>

                    <div class="mb-3">
                        <label>Mô tả:</label>
                        <textarea class="form-control" name="description">${product.description}</textarea>
                        <c:if test="${not empty errorDescription}">
                            <small class="text-danger">${errorDescription}</small>
                        </c:if>
                    </div>

                    <div class="mb-3">
                        <label>Màu sắc:</label>
                        <select class="form-control" name="color">
                            <c:forEach var="c" items="${colorList}">
                                <option value="${c.colorID}" ${c.colorID == product.colorID ? "selected" : ""}>${c.colorName}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label>Mùa:</label>
                        <select class="form-control" name="season">
                            <c:forEach var="s" items="${seasonList}">
                                <option value="${s.seasonID}" ${s.seasonID == product.seasonID ? "selected" : ""}>${s.seasonName}</option>
                            </c:forEach>
                        </select>
                    </div>



                    <button type="submit" class="btn btn-warning">Cập nhật</button>
                    <a href="managerproductlist" class="btn btn-secondary">Hủy</a>

                    <c:if test="${not empty successMsg}">
                        <div class="alert alert-success mt-2">${successMsg}</div>
                    </c:if>
                </form>
            </div>
        </main>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>

