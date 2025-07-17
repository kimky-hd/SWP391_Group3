<%-- 
    Document   : Manager_MaterialBatchHistory
    Created on : Jul 16, 2025, 3:10:23 AM
    Author     : Duccon
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="Model.Account" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Material History</title>
        <!-- Bootstrap CSS -->
        <link href="css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <!-- Custom CSS -->
        <link href="<c:url value='/css/admin.css'/>" rel="stylesheet">
        <link href="css/style.css" rel="stylesheet">
        <style>
            .dropdown {
                position: relative;
                z-index: auto; /* hoặc xóa dòng này */
            }
            .dropdown-button {
                background-color: #1a73e8; /* xanh Google-like */
                color: white;              /* chữ trắng */
                border: none;
                padding: 8px 16px;
                cursor: pointer;
                font-weight: bold;
                border-radius: 4px;
            }
            .dropdown-content {
                display: none;
                position: absolute;
                top: 100%;
                right: 0;
                background-color: white;
                border: 1px solid #ccc;
                min-width: 200px;
                box-shadow: 0 4px 8px rgba(0,0,0,0.1);
                z-index: 1000;
            }
            .dropdown-content a {
                color: black;
                padding: 10px 14px;
                text-decoration: none;
                display: block;
            }
            .dropdown-content a:hover {
                background-color: #f1f1f1;
            }
            .dropdown:hover .dropdown-content {
                display: block;
            }

            .btn-close {
                background:none;
                border:none;
                font-size:1.5rem;
                line-height:1;
            }
            .btn-close::before {
                content:"×";
            }

            .card-header {
                position: relative !important; /* hoặc static */
                overflow: visible !important;
                z-index: auto !important;
            }
        </style>

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
                        <div class="table-responsive">
                            <table class="table table-bordered table-hover" width="100%" cellspacing="0">
                                <thead class="table-dark text-center">
                                    <tr>
                                        <th>ID Lô</th>
                                        <th>Tên nguyên liệu</th>
                                        <th>Số lượng</th>
                                        <th>Giá nhập</th>
                                        <th>Ngày nhập</th>
                                        <th>Hạn sử dụng</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="b" items="${materialBatchList}">
                                        <tr class="text-center align-middle">
                                            <td>${b.materialBatchID}</td>
                                            <td class="text-start">${b.materialName}</td>
                                            <td>${b.quantity}</td>
                                            <td><fmt:formatNumber value="${b.importPrice}" pattern="#,##0"/> VND</td>
                                            <td><fmt:formatDate value="${b.dateImport}" pattern="dd-MM-yyyy"/></td>
                                            <td><fmt:formatDate value="${b.dateExpire}" pattern="dd-MM-yyyy"/></td>

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
                    </div>
                </div>
                <c:if test="${tag != null}">
                    <ul class="pagination">
                        <c:if test="${tag != 1}">
                            <li class="page-item">
                                <a class="page-link" href="materialbatchhistory?index=${tag - 1}">Previous</a>
                            </li>
                        </c:if>
                        <c:forEach begin="1" end="${endPage}" var="i">
                            <li class="page-item ${tag == i ? 'active' : ''}">
                                <a class="page-link" href="materialbatchhistory?index=${i}">${i}</a>
                            </li>
                        </c:forEach>
                        <c:if test="${tag != endPage}">
                            <li class="page-item">
                                <a class="page-link" href="materialbatchhistory?index=${tag + 1}">Next</a>
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
    </body>
</html>
