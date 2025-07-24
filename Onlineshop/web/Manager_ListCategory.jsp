<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="Model.Account" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

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
        <%
            String baseUrl = (String) request.getAttribute("baseUrl");
            String extraParams = (String) request.getAttribute("extraParams");
            if (baseUrl == null) baseUrl = "viewcategorylist";
            if (extraParams == null) extraParams = "";
        %>

        <jsp:include page="manager_topbarsidebar.jsp" />

        <!-- Main Content -->
        <main class="main-content">

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

                                                <button type="button"
                                                        class="btn btn-danger btn-icon-split btn-sm"
                                                        onclick="confirmDeleteCategory(${list.categoryID}, '${fn:escapeXml(list.categoryName)}')">
                                                    <span class="icon text-white-50"><i class="fas fa-trash"></i></span>
                                                </button>

                                                </div>
                                            </td>
                                        </tr>


                                    </c:forEach>

                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <c:if test="${tag != null}">
                    <ul class="pagination">
                        <c:if test="${tag != 1}">
                            <li class="page-item">
                                <a class="page-link" href="${baseUrl}?index=${tag - 1}${extraParams}">Previous</a>
                            </li>
                        </c:if>
                        <c:forEach begin="1" end="${endPage}" var="i">
                            <li class="page-item ${tag == i ? 'active' : ''}">
                                <a class="page-link" href="${baseUrl}?index=${i}${extraParams}"
                                   style="${tag == i ? 'text-decoration: underline;' : ''}">${i}</a>
                            </li>
                        </c:forEach>
                        <c:if test="${tag != endPage}">
                            <li class="page-item">
                                <a class="page-link" href="${baseUrl}?index=${tag + 1}${extraParams}">Next</a>
                            </li>
                        </c:if>
                    </ul>
                </c:if>

            </div>
            <!-- /.container-fluid -->
        </main> 

        
        <!-- Logout Modal -->


        <!-- Bootstrap Bundle with Popper -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
        <!-- SweetAlert2 -->
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

        <script>
            /**
             * Hiển thị popup xác nhận xoá
             * @param {number} id   - categoryID
             * @param {string} name - categoryName
             */
            function confirmDeleteCategory(id, name) {
                Swal.fire({
                    title: 'Xác nhận xoá',
                    text: 'Bạn có chắc chắn muốn xoá danh mục "' + name + '"?',
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: '#d33',
                    cancelButtonColor: '#6c757d',
                    confirmButtonText: 'Xoá',
                    cancelButtonText: 'Huỷ'
                }).then((result) => {
                    if (result.isConfirmed) {
                        // Tạo form ẩn và submit
                        const form = document.createElement('form');
                        form.method = 'post';
                        form.action = 'deletecategory';

                        const input = document.createElement('input');
                        input.type = 'hidden';
                        input.name = 'categoryID';
                        input.value = id;
                        form.appendChild(input);

                        document.body.appendChild(form);
                        form.submit();
                    }
                });
            }
        </script>

    </body>
</html>