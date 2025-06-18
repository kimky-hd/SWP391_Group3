<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="Model.Account" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Product Manager</title>
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

        <!-- Main Content -->
        <main class="main-content">
            <c:if test="${not empty success}">
                <div id="successMessage" class="alert-box">
                    ${success}
                </div>
            </c:if>
            <c:if test="${not empty msg}">
                <div id="errorMessage" class="alert-box" style="background-color: #f8d7da; color: #721c24; border-color: #f5c6cb;">
                    ${msg}
                </div>
            </c:if>
            <div class="container-fluid">

                <!-- Page Heading -->
                <h1 class="h3 mb-2 text-gray-800">Danh mục sản phẩm</h1>

                <!-- DataTales Example -->
                <div class="card shadow mb-4">
                    <div class="card-header py-3 d-flex justify-content-between align-items-center">

                        <!-- Ô tìm kiếm bên trái -->
                        <form action="searchcategorybyname" method="get" class="d-flex" style="max-width: 300px;">
                            <input type="text" name="txt" class="form-control me-2" placeholder="Tìm kiếm danh mục..." />
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-search"></i>
                            </button>
                        </form>

                        <!-- Nút thêm danh mục bên phải -->
                        <a href="Manager_CreateCategory.jsp" class="btn btn-success btn-icon-split">
                            <span class="icon text-white-50">
                                <i class="fa-solid fa-plus"></i>
                            </span>
                            <span class="text">Thêm danh mục sản phẩm</span>
                        </a>

                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-bordered" id="dataTable" width="100%" cellspacing="0">
                                <thead>
                                    <tr>
                                        <th>ID danh mục</th>
                                        <th>Tên danh mục sản phẩm</th>
                                        <th>Hành động</th>
                                    </tr>
                                </thead>

                                <tbody>

                                    <c:forEach items="${requestScope.catelist}" var="list">
                                        <tr>
                                            <td>${list.categoryID}</td>
                                            <!--Name-->
                                            <td>${list.categoryName}</td>

                                            <td>

                                                <form action="updatecategory" method="get" style="display:inline;">
                                                    <input type="hidden" name="categoryID" value="${list.categoryID}" />
                                                    <button type="submit" class="btn btn-primary btn-icon-split" >
                                                        <span class="icon text-white-50">
                                                            <i class="fa-solid fa-pen-to-square"></i>
                                                        </span>
                                                    </button>
                                                </form>    

                                                <form action="deletecategory" method="post" style="display:inline;">
                                                    <input type="hidden" name="categoryID" value="${list.categoryID}" />
                                                    <button type="submit" class="btn btn-danger btn-icon-split btn-sm" onclick="return confirm('Bạn có chắc chắn muốn xóa danh mục này?');">
                                                        <span class="icon text-white-50">
                                                            <i class="fas fa-trash"></i>
                                                        </span>
                                                    </button>
                                                </form>                            
                                                </div>
                                            </td>
                                        </tr>


                                    </c:forEach>

                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

            </div>
            <!-- /.container-fluid -->
        </main> 

        <!-- Footer -->
        <footer class="footer">
            <div class="container-fluid">
                <div class="row">
                    <h3>Đây là footer</h3>
                </div>
        </footer>
        <!-- Logout Modal -->


        <!-- Bootstrap Bundle with Popper -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>