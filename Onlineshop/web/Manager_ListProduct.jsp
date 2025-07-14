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

        <!-- CSS -->
        <link href="css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link href="<c:url value='/css/admin.css'/>" rel="stylesheet">
        <link href="css/style.css" rel="stylesheet">

        <!-- Dropdown style tái sử dụng -->
        <style>
            .dropdown {
                position: relative;
                z-index: auto; /* hoặc xóa dòng này */
            }
            .dropdown-button {
                background-color: #f8f9fa;
                border: 1px solid #ccc;
                padding: 8px 16px;
                cursor: pointer;
                font-weight: bold;
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

        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
        </c:if>

        <jsp:include page="manager_topbarsidebar.jsp" />

        <main class="main-content">

            <!-- Flash message -->
            <c:if test="${not empty sessionScope.isactive}">
                <div class="alert alert-success text-center position-fixed top-50 start-50 translate-middle" role="alert" style="z-index:9999;">
                    ${sessionScope.isactive}
                </div>
                <c:remove var="isactive" scope="session"/>
            </c:if>

            <div class="container-fluid">
                <h1 class="h3 mb-2 text-gray-800">Danh sách sản phẩm</h1>

                <!-- === LABEL dropdown === -->
                <c:choose>
                    <c:when test="${param.sortOrder == 'asc'}">
                        <c:set var="sortLabel" value="Giá: Thấp đến cao"/>
                    </c:when>
                    <c:when test="${param.sortOrder == 'desc'}">
                        <c:set var="sortLabel" value="Giá: Cao đến thấp"/>
                    </c:when>
                    <c:otherwise>
                        <c:set var="sortLabel" value="Sắp xếp theo thứ tự"/>
                    </c:otherwise>
                </c:choose>

                <div class="card shadow mb-4">
                    <div class="card-header py-3 d-flex justify-content-between align-items-center flex-wrap gap-3">

                        <!-- BÊN TRÁI: form tìm kiếm + dropdown sort -->
                        <div class="d-flex align-items-center flex-wrap gap-2">
                            <!-- Tìm kiếm -->
                            <form action="searchproduct" method="get" class="d-flex" style="max-width: 300px;">
                                <input type="text" name="txt" class="form-control me-2" placeholder="Tìm kiếm sản phẩm...">
                                <button type="submit" class="btn btn-primary"><i class="fas fa-search"></i></button>
                            </form>

                            <!-- Dropdown sort -->
                            <div class="dropdown">
                                <div class="dropdown-button">${sortLabel} ⏷</div>
                                <div class="dropdown-content">
                                    <a href="managerproductlist">Sắp xếp theo thứ tự</a>
                                    <a href="managersortproduct?sortOrder=asc">Giá: Thấp đến cao</a>
                                    <a href="managersortproduct?sortOrder=desc">Giá: Cao đến thấp</a>
                                </div>
                            </div>
                        </div>

                        <!-- BÊN PHẢI: nút thêm -->
                        <a href="addproduct" class="btn btn-success btn-icon-split">
                            <span class="icon text-white-50"><i class="fa-solid fa-plus"></i></span>
                            <span class="text">Thêm sản phẩm mới</span>
                        </a>
                    </div>


                    <!-- === BẢNG SẢN PHẨM === -->
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-bordered" width="100%" cellspacing="0">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Tên sản phẩm</th>
                                        <th>Ảnh</th>
                                        <th>Giá</th>
                                        <th>Số lượng</th>
                                        <th>Thành phần</th>
                                        <th>Danh mục</th>
                                        <th>Tình Trạng</th>
                                        <th>Trạng thái</th>
                                        <th>Hành động</th>
                                    </tr>
                                </thead>
                                <tbody>

                                    <c:forEach items="${productList}" var="p">
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
                                            <td>
                                                <ul style="padding-left: 1rem;">
                                                    <c:forEach var="c" items="${p.components}">
                                                        <li>${c.material.name} (${c.materialQuantity} ${c.material.unit})</li>
                                                        </c:forEach>
                                                </ul>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${empty p.categories}">
                                                        <span class="text-muted fst-italic">Không có danh mục</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <ul style="padding-left: 1rem; margin-bottom: 0;">
                                                            <c:forEach var="cat" items="${p.categories}">
                                                                <li>${cat.categoryName}</li>
                                                                </c:forEach>
                                                        </ul>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>

                                            <td>
                                                <c:choose>
                                                    <c:when test="${p.status eq 'Tươi mới'}">
                                                        <span class="badge bg-success text-white px-2 py-1 rounded-pill">
                                                            <i class="fas fa-leaf"></i> Tươi mới
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${p.status eq 'Lão hóa'}">
                                                        <span class="badge bg-warning text-dark px-2 py-1 rounded-pill">
                                                            <i class="fas fa-clock"></i> Lão hóa
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${p.status eq 'Đã Héo'}">
                                                        <span class="badge bg-danger text-white px-2 py-1 rounded-pill">
                                                            <i class="fas fa-skull-crossbones"></i> Đã Héo
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary text-white">Không có hàng</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>


                                            <td>
                                                <c:choose>
                                                    <c:when test="${p.isActive}">
                                                        <span style="color: green; font-weight: 600;">Đang sử dụng</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span style="color: red; font-weight: 600;">Đã vô hiệu hóa</span>
                                                    </c:otherwise>
                                                </c:choose>



                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${p.isActive}">
                                                        <form action="inactiveproduct" method="post" style="display:inline;">
                                                            <input type="hidden" name="productID" value="${p.productID}" />
                                                            <button type="submit" class="btn btn-warning btn-sm" style="min-width: 100px;">
                                                                <i class="fas fa-eye-slash"></i> Vô hiệu hóa
                                                            </button>
                                                        </form>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <form action="activeproduct" method="post" style="display:inline;">
                                                            <input type="hidden" name="productID" value="${p.productID}" />
                                                            <button type="submit" class="btn btn-success btn-sm" style="min-width: 100px;">
                                                                <i class="fas fa-eye"></i> Sử dụng
                                                            </button>
                                                        </form>
                                                    </c:otherwise>
                                                </c:choose>
                                                <a href="updateproduct?productID=${p.productID}" class="btn btn-primary btn-sm"><i class="fas fa-edit"></i></a>
                                                <button type="button" class="btn btn-info btn-sm rounded-circle" title="Bổ sung số lượng"
                                                        style="width: 30px; height: 30px; padding: 4px 0; text-align: center;"
                                                        onclick="openAddProductQuantityModal(${p.productID})">
                                                    <i class="fas fa-plus"></i>
                                                </button>
                                            </td>
                                        </tr>
                                    </c:forEach>

                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- phân trang -->
                <c:if test="${tag != null}">
                    <ul class="pagination">
                        <c:if test="${tag != 1}">
                            <li class="page-item"><a class="page-link" href="managerproductlist?index=${tag-1}&sortOrder=${param.sortOrder}">Previous</a></li>
                            </c:if>
                            <c:forEach begin="1" end="${endPage}" var="i">
                            <li class="page-item ${tag == i ? 'active' : ''}">
                                <a class="page-link" href="managerproductlist?index=${i}&sortOrder=${param.sortOrder}">${i}</a>
                            </li>
                        </c:forEach>
                        <c:if test="${tag != endPage}">
                            <li class="page-item"><a class="page-link" href="managerproductlist?index=${tag+1}&sortOrder=${param.sortOrder}">Next</a></li>
                            </c:if>
                    </ul>
                </c:if>
            </div>
        </main>

        <footer class="footer">
            <div class="container-fluid"><h3>Đây là footer</h3></div>
        </footer>

        <!-- JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                                                            setTimeout(() => {
                                                                const a = document.querySelector('.alert');
                                                                if (a)
                                                                    a.remove();
                                                            }, 5000);
        </script>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>

        <!-- Modal Nhập hàng -->
        <div class="modal fade" id="addProductQuantityModal" tabindex="-1" aria-labelledby="addProductQuantityLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <form action="addproductbatch" method="post">
                        <div class="modal-header">
                            <h5 class="modal-title" id="addProductQuantityLabel">Nhập hàng cho sản phẩm</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <input type="hidden" name="productID" id="modalProductID" value="${productID}">

                            <!-- Số lượng -->
                            <div class="mb-3">
                                <label class="form-label">Số lượng <span class="text-danger">*</span></label>
                                <input type="number" class="form-control" name="quantity" value="${quantityVal}">
                                <c:if test="${not empty quantityError}">
                                    <div class="text-danger mt-1">${quantityError}</div>
                                </c:if>
                            </div>

                            <!-- Giá nhập -->
                            <div class="mb-3">
                                <label class="form-label">Giá nhập (mỗi sản phẩm) <span class="text-danger">*</span></label>
                                <input type="number" class="form-control" name="importPrice" value="${importPriceVal}">
                                <c:if test="${not empty priceError}">
                                    <div class="text-danger mt-1">${priceError}</div>
                                </c:if>
                            </div>

                            <!-- Ngày nhập -->
                            <div class="mb-3">
                                <label class="form-label">Ngày nhập <span class="text-danger">*</span></label>
                                <input type="date" class="form-control" name="dateImport" id="dateImportInput" value="${dateImportVal}">
                                <c:if test="${not empty dateImportError}">
                                    <div class="text-danger mt-1">${dateImportError}</div>
                                </c:if>
                            </div>

                            <!-- Ngày hết hạn -->
                            <div class="mb-3">
                                <label class="form-label">Ngày hết hạn <span class="text-danger">*</span></label>
                                <input type="date" class="form-control" name="dateExpire" value="${dateExpireVal}">
                                <c:if test="${not empty dateExpireError}">
                                    <div class="text-danger mt-1">${dateExpireError}</div>
                                </c:if>
                            </div>
                        </div>

                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                            <button type="submit" class="btn btn-primary">Xác nhận nhập hàng</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Script xử lý tự động mở modal nếu có lỗi -->
        <script>
                                                            window.addEventListener('load', () => {
                                                                const errorFlag = '${errorFlag}';
                                                                const productID = '${productID}';
                                                                if (errorFlag === 'true' || errorFlag === true) {
                                                                    openAddProductQuantityModal(productID);
                                                                }
                                                            });

                                                            function openAddProductQuantityModal(productID) {
                                                                document.getElementById("modalProductID").value = productID;
                                                                const modal = new bootstrap.Modal(document.getElementById("addProductQuantityModal"));
                                                                modal.show();
                                                            }

                                                            document.addEventListener('DOMContentLoaded', function () {
                                                                const dateInput = document.getElementById('dateImportInput');
                                                                if (!dateInput.value) {
                                                                    const today = new Date().toISOString().split('T')[0];
                                                                    dateInput.value = today;
                                                                }
                                                            });
        </script>
        <script>
            function updateStatuses() {
                const statusCells = document.querySelectorAll('.status-cell');
                const today = new Date();
                const oneDay = 24 * 60 * 60 * 1000;

                statusCells.forEach(cell => {
                    const importDateStr = cell.getAttribute('data-import');
                    const expireDateStr = cell.getAttribute('data-expire');

                    if (!importDateStr || !expireDateStr) {
                        cell.innerText = 'Không xác định';
                        return;
                    }

                    const importDate = new Date(importDateStr);
                    const expireDate = new Date(expireDateStr);

                    if (expireDate < today) {
                        cell.innerText = 'Đã Héo';
                        cell.classList.add('text-danger');
                    } else {
                        const diffTime = today.getTime() - importDate.getTime();
                        const diffDays = diffTime / oneDay;

                        if (diffDays <= 3) {
                            cell.innerText = 'Tươi mới';
                            cell.classList.remove('text-danger');
                            cell.classList.add('text-success');
                        } else {
                            cell.innerText = 'Lão hóa';
                            cell.classList.remove('text-danger');
                            cell.classList.add('text-warning');
                        }
                    }
                });
            }

            document.addEventListener('DOMContentLoaded', () => {
                updateStatuses();
                setInterval(updateStatuses, 60000);
            });
        </script>
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const importInput = document.querySelector('input[name="dateImport"]');
                const expireInput = document.querySelector('input[name="dateExpire"]');

                // Khi load trang, nếu chưa có ngày hết hạn thì đặt min = ngày nhập
                const updateExpireMin = () => {
                    if (importInput.value) {
                        expireInput.min = importInput.value;
                        if (expireInput.value && expireInput.value < importInput.value) {
                            expireInput.value = importInput.value;
                        }
                    }
                };

                importInput.addEventListener('change', updateExpireMin);
                updateExpireMin();
            });
        </script>

    </body>
</html>
