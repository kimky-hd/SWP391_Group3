<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Model.Account" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Danh sách lô sản phẩm có hoa héo</title>
        <link href="css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link href="<c:url value='/css/admin.css'/>" rel="stylesheet">
        <link href="css/style.css" rel="stylesheet">
        <!-- SweetAlert2 -->
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    </head>
    <body>
        <c:if test="${not empty successMessage}">
            <script>
                Swal.fire({
                    icon: 'success',
                    title: 'Thành công!',
                    text: '${successMessage}',
                    confirmButtonText: 'OK'
                });
            </script>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <script>
                Swal.fire({
                    icon: 'error',
                    title: 'Thất bại!',
                    text: '${errorMessage}',
                    confirmButtonText: 'OK'
                });
            </script>
        </c:if>


        <jsp:include page="manager_topbarsidebar.jsp" />
        <main class="main-content">
            <div class="container-fluid">
                <h1 class="h3 mb-2 text-gray-800">Lô sản phẩm cần thay nguyên liệu</h1>

                <div class="card shadow mb-4">

                    <div class="card-body">
                        <c:choose>
                            <c:when test="${not empty wiltedBatches}">
                                <div class="table-responsive">
                                    <table class="table table-bordered table-hover text-center">
                                        <thead class="table-dark">
                                            <tr>
                                                <th>ID Lô</th>
                                                <th>Mã sản phẩm</th>
                                                <th>Số lượng</th>
                                                <th>Giá nhập</th>
                                                <th>Ngày nhập</th>
                                                <th>Hạn sử dụng</th>
                                                <th>Tình trạng</th>
                                                <th>Hành động</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="b" items="${wiltedBatches}">
                                                <tr class="align-middle">
                                                    <td>${b.productBatchID}</td>
                                                    <td>${b.productID}</td>
                                                    <td>${b.quantity}</td>
                                                    <td><fmt:formatNumber value="${b.importPrice}" pattern="#,##0"/> VND</td>
                                                    <td><fmt:formatDate value="${b.dateImport}" pattern="dd-MM-yyyy"/></td>
                                                    <td><fmt:formatDate value="${b.dateExpire}" pattern="dd-MM-yyyy"/></td>
                                                    <td>
                                                        <span class="badge bg-danger text-white px-2 py-1 rounded-pill">
                                                            <i class="fas fa-skull-crossbones"></i> Có hoa héo
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <form action="replacewilted" method="post" class="auto-replace-form">
                                                            <input type="hidden" name="productBatchID" value="${b.productBatchID}" />
                                                            <button type="button" class="btn btn-warning auto-replace-btn">
                                                                Cập nhật nguyên liệu bị héo
                                                            </button>
                                                        </form>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:when>

                            <c:otherwise>
                                <div class="text-center py-5">
                                    <h3 class="text-muted fw-semibold">Không có lô sản phẩm nào chứa nguyên liệu héo.</h3>
                                </div>
                            </c:otherwise>

                        </c:choose>

                    </div>
                </div>
            </div>
        </main>
        <script>
            document.querySelectorAll('.auto-replace-btn').forEach(button => {
                button.addEventListener('click', function () {
                    const form = this.closest('form');

                    Swal.fire({
                        title: 'Bạn chắc chắn?',
                        text: "Bạn có muốn tự động cập nhật nguyên liệu bị héo?",
                        icon: 'warning',
                        showCancelButton: true,
                        confirmButtonColor: '#d33',
                        cancelButtonColor: '#3085d6',
                        confirmButtonText: 'Có, cập nhật!',
                        cancelButtonText: 'Hủy'
                    }).then((result) => {
                        if (result.isConfirmed) {
                            form.submit();
                        }
                    });
                });
            });
        </script>

    </body>
</html>
