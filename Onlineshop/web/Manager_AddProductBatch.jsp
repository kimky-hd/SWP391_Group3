<%-- 
    Document   : Manager_AddProductBatch
    Created on : Jul 21, 2025, 1:03:00 AM
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
        <title>Product Manager</title>

        <!-- CSS -->
        <link href="css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
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
            <a href="managerproductlist" class="btn btn-secondary">
                <i class="fas fa-arrow-left"></i> Quay lại
            </a>
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger text-center mt-3 mx-auto" role="alert" style="max-width: 600px; font-weight: bold;">
                    <i class="fas fa-exclamation-triangle"></i> ${errorMessage}
                </div>
            </c:if>

            <h2>Nhập thêm lô sản phẩm: ${product.title}</h2>

            <form action="previewproductbatchcost" method="post">
                <input type="hidden" name="productID" value="${product.productID}" />

                <h4>Thành phần sản phẩm</h4>
                <ul>
                    <c:forEach var="c" items="${product.components}">
                        <li>${c.material.name}: ${c.materialQuantity} ${c.material.unit} / sản phẩm</li>
                        </c:forEach>
                </ul>

                <h4>Danh sách lô nguyên liệu</h4>
                <c:forEach var="entry" items="${materialBatches}">
                    <c:set var="material" value="${entry.key}" />
                    <h5>${material.name}</h5>
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>Mã lô</th>
                                <th>Số lượng</th>
                                <th>Ngày hết hạn</th>
                                <th>Giá nhập</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="batch" items="${entry.value}">
                                <tr>
                                    <td>${batch.materialBatchID}</td>
                                    <td>${batch.quantity}</td>
                                    <td><fmt:formatDate value="${batch.dateExpire}" pattern="dd-MM-yyyy"/></td>
                                    <td><fmt:formatNumber value="${batch.importPrice}" type="currency" currencySymbol="₫"/></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:forEach>

                <div class="mb-3">
                    <label class="form-label">Số lượng sản phẩm muốn nhập:</label>
                    <input type="text" name="quantity" class="form-control"
                           value="${not empty quantity ? quantity : ''}">
                    <c:if test="${not empty errorQuantity}">
                        <div class="text-danger mt-1">${errorQuantity}</div>
                    </c:if>
                </div>


                <button type="submit" class="btn btn-primary">Tính chi phí</button>
            </form>

            <c:if test="${not empty materialUsageMap}">
                <h4 class="mt-4">Chi tiết nguyên liệu tiêu thụ :</h4>
                <table class="table table-striped">
                    <thead>
                        <tr>
                            <th>Nguyên liệu</th>
                            <th>Mã lô</th>
                            <th>Số lượng dùng</th>
                            <th>Giá nhập</th>
                            <th>Thành tiền</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="entry" items="${materialUsageMap}">
                            <c:set var="material" value="${entry.key}" />
                            <c:forEach var="usage" items="${entry.value}">
                                <tr>
                                    <td>${material.name}</td>
                                    <td>${usage.materialBatchID}</td>
                                    <td>${usage.quantityUsed}</td>
                                    <td><fmt:formatNumber value="${usage.importPrice}" type="currency" currencySymbol="₫"/></td>
                                    <td><fmt:formatNumber value="${usage.importPrice * usage.quantityUsed}" type="currency" currencySymbol="₫"/></td>
                                </tr>
                            </c:forEach>
                        </c:forEach>
                    </tbody>
                </table>

                <p><strong>Tổng chi phí:</strong> <fmt:formatNumber value="${totalCost}" type="currency" currencySymbol="₫"/></p>
                <p><strong>Giá trung bình 1 sản phẩm:</strong> <fmt:formatNumber value="${estimatedUnitCost}" type="currency" currencySymbol="₫"/></p>
                <p><strong>Ngày hết hạn của lô sản phẩm mới:</strong> <fmt:formatDate value="${earliestExpireDate}" pattern="dd-MM-yyyy"/></p>


                <form action="addproductbatch" method="post">
                    <input type="hidden" name="productID" value="${productID}" />
                    <input type="hidden" name="quantity" value="${quantity}" />
                    <input type="hidden" name="importPrice" value="${estimatedUnitCost}" />
                    <input type="hidden" name="dateImport" value="<fmt:formatDate value='${earliestExpireDate}' pattern='yyyy-MM-dd'/>" />
                    <input type="hidden" name="dateExpire" value="<fmt:formatDate value='${earliestExpireDate}' pattern='yyyy-MM-dd'/>" />             

                    <button type="submit" class="btn btn-success mt-3">Xác nhận nhập lô hàng</button>
                </form>
            </c:if>


        </main>

    </body>
</html>