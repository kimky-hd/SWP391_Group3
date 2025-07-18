<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Model.Account" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Material History</title>
        <link href="css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link href="<c:url value='/css/admin.css'/>" rel="stylesheet">
        <link href="css/style.css" rel="stylesheet">
    </head>
    <body>
        <jsp:include page="manager_topbarsidebar.jsp" />
        <main class="main-content">
            <div class="container-fluid">
                <h1 class="h3 mb-2 text-gray-800">Lịch sử nhập lô hàng</h1>

                <div class="card shadow mb-4">
                    <div class="card-header py-3 d-flex justify-content-between align-items-center">
                        <h6 class="m-0 font-weight-bold text-primary">Toàn bộ lô hàng đã nhập</h6>
                        <a href="managermateriallist" class="btn btn-secondary">
                            <i class="fas fa-arrow-left"></i> Quay lại
                        </a>
                    </div>

                    <div class="card-body">
                        <!-- Form lọc -->
                        <form action="materialbatchhistory" class="row g-3 mb-4 align-items-end">
                            <!-- Tên nguyên liệu -->
                            <div class="col-md-3">
                                <label for="materialName">Tên nguyên liệu</label>
                                <input type="text" name="materialName" value="${param.materialName}" class="form-control" placeholder="Nhập tên nguyên liệu">
                            </div>

                            <!-- Ngày bắt đầu -->
                            <div class="col-md-2">
                                <label for="fromDate">Từ ngày</label>
                                <input type="date" name="fromDate" value="${param.fromDate}" class="form-control">
                            </div>

                            <!-- Ngày kết thúc -->
                            <div class="col-md-2">
                                <label for="toDate">Đến ngày</label>
                                <input type="date" name="toDate" value="${param.toDate}" class="form-control">
                            </div>

                            <!-- Dropdown Nhà cung cấp -->
                            <div class="col-md-3">
                                <label for="supplierName">Nhà cung cấp</label>
                                <select name="supplierName" class="form-control">
                                    <option value="">Tất cả</option>
                                    <c:forEach var="sup" items="${supplierList}">
                                        <option value="${sup.getSupplierName()}"
                                                <c:if test="${param.supplierName eq sup.getSupplierName()}">selected</c:if>>
                                            ${sup.getSupplierName()}
                                        </option>
                                    </c:forEach>
                                </select>
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
                                        <th>Tên nguyên liệu</th>
                                        <th>Số lượng</th>
                                        <th>Giá nhập</th>
                                        <th>Ngày nhập</th>
                                        <th>Hạn sử dụng</th>
                                        <th>Nhà cung cấp</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="b" items="${materialBatchList}">
                                        <tr class="align-middle">
                                            <td>${b.materialBatchID}</td>
                                            <td class="text-start">${b.materialName}</td>
                                            <td>${b.quantity}</td>
                                            <td><fmt:formatNumber value="${b.importPrice}" pattern="#,##0"/> VND</td>
                                            <td><fmt:formatDate value="${b.dateImport}" pattern="dd-MM-yyyy"/></td>
                                            <td><fmt:formatDate value="${b.dateExpire}" pattern="dd-MM-yyyy"/></td>
                                            <td class="text-start">${b.supplierName}</td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty materialBatchList}">
                                        <tr>
                                            <td colspan="7" class="text-center text-muted">Không có dữ liệu</td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>

                        <!-- Phân trang (chỉ hiện khi không lọc) -->
                        <c:if test="${param.materialName == null and param.fromDate == null and param.toDate == null and param.supplierName == null}">
                            <c:if test="${tag != null}">
                                <ul class="pagination">
                                    <c:if test="${tag > 1}">
                                        <li class="page-item">
                                            <a class="page-link" href="materialbatchhistory?index=${tag - 1}">Previous</a>
                                        </li>
                                    </c:if>
                                    <c:forEach begin="1" end="${endPage}" var="i">
                                        <li class="page-item ${tag == i ? 'active' : ''}">
                                            <a class="page-link" href="materialbatchhistory?index=${i}">${i}</a>
                                        </li>
                                    </c:forEach>
                                    <c:if test="${tag < endPage}">
                                        <li class="page-item">
                                            <a class="page-link" href="materialbatchhistory?index=${tag + 1}">Next</a>
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
