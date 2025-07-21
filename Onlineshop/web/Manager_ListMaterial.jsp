<%-- 
    Document   : Manager_ListMaterial
    Created on : Jun 21, 2025, 2:55:29 AM
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
        <title>Material Manager</title>
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
            <c:if test="${not empty sessionScope.isactive}">
                <div class="alert alert-success text-center position-fixed top-50 start-50 translate-middle" role="alert" style="z-index: 9999;">
                    ${sessionScope.isactive}
                </div>
                <c:remove var="isactive" scope="session"/>
            </c:if>
            <div class="container-fluid">
                <h1 class="h3 mb-2 text-gray-800">Danh sách nguyên liệu</h1>
                

                <div class="card shadow mb-4">
                    <div class="card-header py-3 d-flex justify-content-between align-items-center flex-wrap gap-3">
                        <div class="d-flex align-items-center flex-wrap gap-2">
                            <form action="searchmaterialname" method="get" class="d-flex" style="max-width: 300px;">
                                <input type="text" name="txt" class="form-control me-2" placeholder="Tìm kiếm nguyên liệu..." />
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-search"></i>
                                </button>
                            </form>
                        </div>
                        <div class="d-flex gap-2">
                            <a href="materialbatchhistory" class="btn btn-outline-primary">
                                <i class="fas fa-clock-rotate-left"></i> Lịch sử nhập lô hàng
                            </a>        
                            <a href="Manager_CreateMaterial.jsp" class="btn btn-success btn-icon-split">
                                <span class="icon text-white-50"><i class="fa-solid fa-plus"></i></span>
                                <span  class="text">Thêm nguyên liệu mới</span>
                            </a>
                        </div>
                    </div>

                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-bordered" id="dataTable" width="100%" cellspacing="0">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Tên nguyên liệu</th>
                                        <th>Đơn vị</th>
                                        <th>Số lượng</th>
                                        <th>Tình Trạng</th>
                                        <th>Trạng thái</th>
                                        <th>Hành động</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${materialList}" var="m">
                                        <tr>
                                            <td>${m.materialID}</td>
                                            <td>${m.name}</td>
                                            <td>${m.unit}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${m.quantity == 0}">
                                                        <small class="text-danger">Hết Hàng</small>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <small class="text-muted">${m.quantity}</small>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${m.status eq 'Tươi mới'}">
                                                        <span class="badge bg-success text-white px-2 py-1 rounded-pill">
                                                            <i class="fas fa-leaf"></i> Tươi mới
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${m.status eq 'Lão hóa'}">
                                                        <span class="badge bg-warning text-dark px-2 py-1 rounded-pill">
                                                            <i class="fas fa-clock"></i> Lão hóa
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${m.status eq 'Đã Héo'}">
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
                                                    <c:when test="${m.isActive}">
                                                        <span style="color: green; font-weight: 600;">Đang sử dụng</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span style="color: red; font-weight: 600;">Đã vô hiệu hóa</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>

                                            <td>
                                                <c:choose>
                                                    <c:when test="${m.isActive}">
                                                        <form action="inactive" method="post" style="display:inline;">
                                                            <input type="hidden" name="materialID" value="${m.materialID}" />
                                                            <input type="hidden" name="index" value="${param.index}" />
                                                            <input type="hidden" name="sortOrder" value="${param.sortOrder}" />
                                                            <button type="button" class="btn btn-warning btn-sm" onclick="openHideModal(${m.materialID}, '${m.name}')" style="min-width: 100px;">
                                                                <i class="fas fa-eye-slash"></i> Ẩn
                                                            </button>
                                                        </form>

                                                    </c:when>
                                                    <c:otherwise>
                                                        <form action="active" method="post" style="display:inline;">
                                                            <input type="hidden" name="materialID" value="${m.materialID}" />
                                                            <input type="hidden" name="index" value="${param.index}" />
                                                            <input type="hidden" name="sortOrder" value="${param.sortOrder}" />
                                                            <button type="submit" class="btn btn-success btn-sm" style="min-width: 100px;">
                                                                <i class="fas fa-eye"></i> Hiện
                                                            </button>
                                                        </form>

                                                    </c:otherwise>
                                                </c:choose>
                                                <button type="button" class="btn btn-info btn-sm rounded-circle" 
                                                        title="Bổ sung số lượng" 
                                                        style="width: 30px; height: 30px; padding: 4px 0; text-align: center;"
                                                        onclick="openAddQuantityModal(${m.materialID})">
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

                <c:if test="${tag != null}">
                    <ul class="pagination">
                        <c:if test="${tag != 1}">
                            <li class="page-item">
                                <a class="page-link" href="managermateriallist?index=${tag - 1}">Previous</a>
                            </li>
                        </c:if>
                        <c:forEach begin="1" end="${endPage}" var="i">
                            <li class="page-item ${tag == i ? 'active' : ''}">
                                <a class="page-link" href="managermateriallist?index=${i}">${i}</a>
                            </li>
                        </c:forEach>
                        <c:if test="${tag != endPage}">
                            <li class="page-item">
                                <a class="page-link" href="managermateriallist?index=${tag + 1}">Next</a>
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
        <script>
            setTimeout(() => {
                const alertBox = document.querySelector('.alert');
                if (alertBox)
                    alertBox.remove();
            }, 3000);
        </script>
        <script>
            function openHideModal(id, name) {
                document.getElementById("materialIDHidden").value = id;
                document.getElementById("materialName").innerText = name;
                var myModal = new bootstrap.Modal(document.getElementById('confirmHideModal'), {
                    keyboard: false
                });
                myModal.show();
            }
        </script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
        <!-- Modal xác nhận -->
        <div class="modal fade" id="confirmHideModal" tabindex="-1" aria-labelledby="confirmHideLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <form method="post" action="inactive">
                        <div class="modal-header">
                            <h5 class="modal-title" id="confirmHideLabel">Xác nhận ẩn nguyên liệu</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            Bạn có chắc chắn muốn ẩn nguyên liệu <strong id="materialName"></strong>?
                            <input type="hidden" name="materialID" id="materialIDHidden" />
                            <input type="hidden" name="index" value="${param.index}" />
                            <input type="hidden" name="sortOrder" value="${param.sortOrder}" />
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                            <button type="submit" class="btn btn-warning">Xác nhận</button>
                        </div>
                    </form>

                </div>
            </div>
        </div>
        <!-- Modal bổ sung số lượng nguyên liệu -->
        <div class="modal fade" id="addQuantityModal" tabindex="-1" aria-labelledby="addQuantityModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <form method="post" action="addmaterialbatchcontroller" onsubmit="return validateForm();">
                        <div class="modal-header">
                            <h5 class="modal-title" id="addQuantityModalLabel">Bổ sung số lượng nguyên liệu</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close">
                                <i class="fas fa-times"></i>
                            </button>
                        </div>

                        <div class="modal-body">
                            <input type="hidden" name="materialID" id="batchMaterialID" />

                            <div class="form-group mb-2">
                                <label>Giá nhập (VNĐ): <span class="text-danger">*</span></label>
                                <input type="text" name="importPrice" value="${importPrice}" class="form-control" id="importPriceInput" oninput="formatPrice(this)" />
                                <c:if test="${not empty errorPrice}">
                                    <small class="text-danger">${errorPrice}</small>
                                </c:if>
                            </div>

                            <div class="form-group mb-2">
                                <label>Số lượng: <span class="text-danger">*</span></label>
                                <input type="number" name="quantity" value="${quantity}" class="form-control" />
                                <c:if test="${not empty errorQuantity}">
                                    <small class="text-danger">${errorQuantity}</small>
                                </c:if>
                            </div>

                            <div class="form-group mb-2">
                                <label>Ngày nhập: <span class="text-danger">*</span></label>
                                <input type="date" name="dateImport"
                                       value="${dateImport != null ? dateImport : ''}"
                                       class="form-control" id="dateImportInput" />
                                <c:if test="${not empty errorDateImport}">
                                    <small class="text-danger">${errorDateImport}</small>
                                </c:if>
                            </div>

                            <div class="form-group mb-2">
                                <label>Ngày hết hạn: <span class="text-danger">*</span></label>
                                <input type="date" name="dateExpire"
                                       value="${dateExpire != null ? dateExpire : ''}"
                                       class="form-control" id="dateExpireInput" />
                                <c:if test="${not empty errorDateExpire}">
                                    <small class="text-danger">${errorDateExpire}</small>
                                </c:if>
                            </div>

                            <div class="form-group mb-2">
                                <label>Nhà cung cấp: <span class="text-danger">*</span></label>
                                <select name="supplierID" class="form-control">
                                    <option value="">-- Chọn nhà cung cấp --</option>
                                    <c:forEach var="s" items="${supplierList}">
                                        <option value="${s.supplierID}"
                                                <c:if test="${s.supplierID == supplierID}">selected</c:if>>
                                            ${s.supplierName}
                                        </option>
                                    </c:forEach>
                                </select>
                                <c:if test="${not empty errorSupplier}">
                                    <small class="text-danger">${errorSupplier}</small>
                                </c:if>
                            </div>

                            <p id="batchErrorMsg" class="text-danger"></p>
                        </div>

                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                            <button type="submit" class="btn btn-primary">Xác nhận</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>


        <script>
            function openAddQuantityModal(materialID) {
                // Set hidden field
                document.getElementById("batchMaterialID").value = materialID;

                // Set dateImport to current date
                const today = new Date().toISOString().split('T')[0];
                document.getElementById("dateImportInput").value = today;
                document.getElementById("dateExpireInput").min = today;

                // Show modal
                var myModal = new bootstrap.Modal(document.getElementById('addQuantityModal'), {
                    keyboard: false
                });
                myModal.show();
            }

            function validateBatchForm() {
                const importDate = document.getElementById("dateImportInput").value;
                const expireDate = document.getElementById("dateExpireInput").value;

                if (expireDate < importDate) {
                    document.getElementById("batchErrorMsg").innerText = "Ngày hết hạn không được trước ngày nhập.";
                    return false;
                }

                return true;
            }
        </script>
        <script>
            function formatPrice(input) {
                // Lưu vị trí con trỏ chuột
                const cursorPosition = input.selectionStart;
                const originalLength = input.value.length;

                // Loại bỏ mọi ký tự không phải số
                let rawValue = input.value.replace(/[^0-9]/g, '');
                if (rawValue === '') {
                    input.value = '';
                    return;
                }

                // Định dạng theo dấu phẩy ngăn cách hàng nghìn
                let formattedValue = Number(rawValue).toLocaleString('vi-VN');
                input.value = formattedValue;

                // Khôi phục lại vị trí con trỏ (gần đúng)
                const newLength = input.value.length;
                input.setSelectionRange(cursorPosition + (newLength - originalLength), cursorPosition + (newLength - originalLength));
            }
        </script>


        <script>
            function validateForm() {
                let isValid = true;

                // Xóa các lỗi cũ
                document.getElementById("error-importPrice").innerText = "";
                document.getElementById("error-quantity").innerText = "";

                // Lấy giá trị người dùng nhập
                const importPrice = document.getElementById("importPrice").value.trim();
                const quantity = document.getElementById("quantity").value.trim();

                // Validate giá nhập
                if (importPrice === "") {
                    document.getElementById("error-importPrice").innerText = "Vui lòng nhập giá nhập.";
                    isValid = false;
                } else if (isNaN(importPrice) || Number(importPrice) <= 0) {
                    document.getElementById("error-importPrice").innerText = "Giá nhập phải là số dương.";
                    isValid = false;
                }

                // Validate số lượng
                if (quantity === "") {
                    document.getElementById("error-quantity").innerText = "Vui lòng nhập số lượng.";
                    isValid = false;
                } else if (!Number.isInteger(Number(quantity)) || Number(quantity) <= 0) {
                    document.getElementById("error-quantity").innerText = "Số lượng phải là số nguyên dương.";
                    isValid = false;
                }

                return isValid;
            }
        </script>

        <c:if test="${showModal == true}">
            <script>
                document.addEventListener("DOMContentLoaded", function () {
                    var myModal = new bootstrap.Modal(document.getElementById('addQuantityModal'));
                    myModal.show();
                });
            </script>
        </c:if>
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
                setInterval(updateStatuses, 60000); // mỗi phút
            });
        </script>


    </body>

</html>
