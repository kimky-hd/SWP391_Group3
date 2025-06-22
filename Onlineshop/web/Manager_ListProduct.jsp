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

        <main class="main-content">
            <div class="container-fluid">
                <h1 class="h3 mb-2 text-gray-800">Danh sách sản phẩm</h1>

                <div class="card shadow mb-4">
                    <div class="card-header py-3 d-flex justify-content-between align-items-center">
                        <form action="searchproduct" method="get" class="d-flex" style="max-width: 300px;">
                            <input type="text" name="txt" class="form-control me-2" placeholder="Tìm kiếm sản phẩm..." />
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-search"></i>
                            </button>
                        </form>

                        <a href="Manager_CreateProduct.jsp" class="btn btn-success btn-icon-split">
                            <span class="icon text-white-50">
                                <i class="fa-solid fa-plus"></i>
                            </span>
                            <span class="text">Thêm sản phẩm mới</span>
                        </a>
                    </div>

                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-bordered" id="dataTable" width="100%" cellspacing="0">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Tên sản phẩm</th>
                                        <th>Ảnh</th>
                                        <th>Giá</th>
                                        <th>Số lượng</th>
                                        <th>Trạng thái</th>
                                        <th>Hành động</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${requestScope.productList}" var="p">
                                        <tr>
                                            <td>${p.productID}</td>
                                            <td>${p.title}</td>
                                            <td><img src="${pageContext.request.contextPath}/img/${p.image}" width="60"></td>
                                            <td><fmt:formatNumber value="${p.price}" pattern="#,##0" /> VND</td>

                                            <td>
                                                <c:choose>
                                                    <c:when test="${p.quantity == 0}">
                                                        <small class="text-danger">Hết Hàng</small>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <small class="text-muted">${p.quantity}</small>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>

                                            <td>${p.status}</td>
                                            <td>
                                                <a href="updateproduct?productID=${p.productID}" class="btn btn-primary btn-sm">
                                                    <i class="fas fa-edit"></i>
                                                </a>
                                                <a href="updatematerial?materialID=${p.productID}" class="btn btn-info btn-sm rounded-circle" title="Bổ sung số lượng" style="width: 30px; height: 30px; padding: 4px 0; text-align: center;">
                                                    <i class="fas fa-plus"></i>
                                                </a>
                                                <form action="deleteproduct" method="post" style="display:inline;">
                                                    <input type="hidden" name="productID" value="${p.productID}" />
                                                    <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('Bạn có chắc muốn xóa sản phẩm này?');">
                                                        <i class="fas fa-trash"></i>
                                                    </button>
                                                </form>
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
                                <a class="page-link" href="managerproductlist?index=${tag - 1}">Previous</a>
                            </li>
                        </c:if>
                        <c:forEach begin="1" end="${endPage}" var="i">
                            <li class="page-item ${tag == i ? 'active' : ''}">
                                <a class="page-link" href="managerproductlist?index=${i}">${i}</a>
                            </li>
                        </c:forEach>
                        <c:if test="${tag != endPage}">
                            <li class="page-item">
                                <a class="page-link" href="managerproductlist?index=${tag + 1}">Next</a>
                            </li>
                        </c:if>
                    </ul>
                </c:if>
            </div>
        </main>

        <footer class="footer">
            <div class="container-fluid">
                <div class="row">
                    <h3>Đây là footer</h3>
                </div>
            </div>
        </footer>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>