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
    </head>
    <body>
        <jsp:include page="manager_topbarsidebar.jsp" />

        <main class="main-content">
            <div class="container-fluid">
                <h2>Thêm nguyên liệu mới</h2>

                <form action="creatematerial" method="post">
                    <div class="form-group mb-3">
                        <label for="name">Tên nguyên liệu:</label>
                        <input type="text" id="name" name="name" class="form-control" value="${name != null ? name : ''}" />
                        <c:if test="${not empty errorName}">
                            <small class="text-danger">${errorName}</small>
                        </c:if>
                    </div>

                    <div class="form-group mb-3">
                        <input type="hidden" name="unit" value="cành" />
                    </div>

                    <div class="form-group mb-3">
                        <label for="price">Giá mỗi đơn vị (VNĐ):</label>
                        <input type="text" id="price" name="price" class="form-control" value="${price != null ? price : ''}" />
                        <c:if test="${not empty errorPrice}">
                            <small class="text-danger">${errorPrice}</small>
                        </c:if>
                    </div>

                    <button type="submit" class="btn btn-primary">Thêm nguyên liệu</button>
                </form>
            </div>
        </main>

        <footer class="footer">
            <div class="container-fluid">
                <div class="row">
                    <h3>Đây là footer</h3>
                </div>
            </div>
        </footer>




    </body>

</html>
