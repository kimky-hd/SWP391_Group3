<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Model.Account" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Product Batch History</title>
        <link href="css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link href="<c:url value='/css/admin.css'/>" rel="stylesheet">
        <link href="css/style.css" rel="stylesheet">
    </head>
    <body>
        <jsp:include page="manager_topbarsidebar.jsp" />
        <main class="main-content">
            <div class="container-fluid">
                <h1 class="h3 mb-2 text-gray-800">Lịch sử nhập lô sản phẩm</h1>

                <div class="card shadow mb-4">
                    <div class="card-header py-3 d-flex justify-content-between align-items-center">
                        <h6 class="m-0 font-weight-bold text-primary">Toàn bộ lô sản phẩm đã nhập</h6>
                        <a href="managerproductlist" class="btn btn-secondary">
                            <i class="fas fa-arrow-left"></i> Quay lại
                        </a>
                    </div>

                    <div class="card-body">
                        <!-- Form lọc -->
                        <form action="productbatchhistory" class="row g-3 mb-4 align-items-end">
                            <!-- Tên sản phẩm -->
                            <div class="col-md-4">
                                <label for="productName">Tên sản phẩm</label>
                                <input type="text" name="productName" value="${param.productName}" class="form-control" placeholder="Nhập tên sản phẩm">
                            </div>

                            <!-- Ngày bắt đầu -->
                            <div class="col-md-3">
                                <label for="dateFrom">Từ ngày</label>
                                <input type="date" name="dateFrom" value="${param.dateFrom}" class="form-control">
                            </div>

                            <!-- Ngày kết thúc -->
                            <div class="col-md-3">
                                <label for="dateTo">Đến ngày</label>
                                <input type="date" name="dateTo" value="${param.dateTo}" class="form-control">
                            </div>

                            <!-- Nút lọc -->
                            <div class="col-md-2 d-flex align-items-end">
                                <button type="submit" class="btn btn-primary w-100">Lọc</button>
                            </div>
                        </form>

                        <!-- Bảng dữ liệu -->
                        <div class="table-responsive">
                            <table class="table table-bordered table-hover text-center">
                                <thead class="table-dark">
                                    <tr>
                                        <th>ID Lô</th>
                                        <th>Tên sản phẩm</th>
                                        <th>Số lượng</th>
                                        <th>Giá nhập</th>
                                        <th>Ngày nhập</th>
                                        <th>Hạn sử dụng</th>
                                        <td>Tình trạng</td>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="b" items="${productBatchList}">
                                        <tr class="align-middle">
                                            <td>${b.productBatchID}</td>
                                            <td class="text-start">${b.product.title}</td>
                                            <td>${b.quantity}</td>
                                            <td><fmt:formatNumber value="${b.importPrice}" pattern="#,##0"/> VND</td>
                                            <td><fmt:formatDate value="${b.dateImport}" pattern="dd-MM-yyyy"/></td>
                                            <td><fmt:formatDate value="${b.dateExpire}" pattern="dd-MM-yyyy"/></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${b.status eq 'Tươi mới'}">
                                                        <span class="badge bg-success text-white px-2 py-1 rounded-pill">
                                                            <i class="fas fa-leaf"></i> Tươi mới
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${b.status eq 'Lão hóa'}">
                                                        <span class="badge bg-warning text-dark px-2 py-1 rounded-pill">
                                                            <i class="fas fa-clock"></i> Lão hóa
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${b.status eq 'Đã Héo'}">
                                                        <span class="badge bg-danger text-white px-2 py-1 rounded-pill">
                                                            <i class="fas fa-skull-crossbones"></i> Đã Héo
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary text-white">Không có hàng</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty productBatchList}">
                                        <tr>
                                            <td colspan="7" class="text-center text-muted">Không có dữ liệu</td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>

                        <!-- Phân trang -->
                        <c:if test="${param.productName == null and param.dateFrom == null and param.dateTo == null}">
                            <c:if test="${tag != null}">
                                <ul class="pagination justify-content-center">
                                    <c:if test="${tag > 1}">
                                        <li class="page-item">
                                            <a class="page-link" href="productbatchhistory?index=${tag - 1}">Previous</a>
                                        </li>
                                    </c:if>
                                    <c:forEach begin="1" end="${endPage}" var="i">
                                        <li class="page-item ${tag == i ? 'active' : ''}">
                                            <a class="page-link" href="productbatchhistory?index=${i}">${i}</a>
                                        </li>
                                    </c:forEach>
                                    <c:if test="${tag < endPage}">
                                        <li class="page-item">
                                            <a class="page-link" href="productbatchhistory?index=${tag + 1}">Next</a>
                                        </li>
                                    </c:if>
                                </ul>
                            </c:if>
                        </c:if>
                    </div>
                </div>
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
