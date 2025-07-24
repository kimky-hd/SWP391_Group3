<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý nhà cung cấp</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* Main content container - tránh chồng lấn với sidebar */
        .main-content {
            margin-left: 250px; /* Điều chỉnh theo width của sidebar */
            padding: 20px;
            min-height: 100vh;
            transition: margin-left 0.3s ease;
        }
        
        /* Responsive cho sidebar collapse */
        @media (max-width: 768px) {
            .main-content {
                margin-left: 0;
                padding: 15px;
            }
        }
        
        /* Khi sidebar thu gọn */
        .sidebar-collapsed .main-content {
            margin-left: 80px; /* Width của sidebar khi collapsed */
        }
        
        @media (max-width: 768px) {
            .sidebar-collapsed .main-content {
                margin-left: 0;
            }
        }
        
        .search-container {
            margin-bottom: 20px;
        }
        .pagination {
            justify-content: center;
            margin-top: 20px;
        }
        .action-buttons .btn {
            margin-right: 3px;
            margin-bottom: 2px;
        }
        .modal-header {
            background-color: #f8f9fa;
        }
        .error-feedback {
            color: #dc3545;
            font-size: 0.875em;
            margin-top: 0.25rem;
        }
        
        /* Responsive table styles */
        .table-responsive {
            border-radius: 0.375rem;
            box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
            margin-bottom: 1rem;
        }
        
        /* Tối ưu cho màn hình laptop 13-16 inch với sidebar */
        @media (min-width: 768px) and (max-width: 1400px) {
            .main-content {
                padding: 15px;
            }
            
            .table th,
            .table td {
                padding: 0.4rem 0.25rem;
                font-size: 0.8rem;
                vertical-align: middle;
            }
            
            .table th:nth-child(1), /* ID */
            .table td:nth-child(1) {
                width: 50px;
                min-width: 50px;
            }
            
            .table th:nth-child(2), /* Tên */
            .table td:nth-child(2) {
                width: 22%;
                min-width: 120px;
            }
            
            .table th:nth-child(3), /* Email */
            .table td:nth-child(3) {
                width: 25%;
                min-width: 140px;
            }
            
            .table th:nth-child(4), /* Phone */
            .table td:nth-child(4) {
                width: 15%;
                min-width: 100px;
            }
            
            .table th:nth-child(5), /* Address */
            .table td:nth-child(5) {
                width: 23%;
                min-width: 120px;
                max-width: 180px;
                word-wrap: break-word;
                overflow-wrap: break-word;
            }
            
            .table th:nth-child(6), /* Actions */
            .table td:nth-child(6) {
                width: 15%;
                min-width: 90px;
            }
            
            .action-buttons .btn {
                padding: 0.2rem 0.35rem;
                font-size: 0.7rem;
                margin-right: 1px;
            }
            
            /* Thu nhỏ form controls */
            .form-control, .btn {
                font-size: 0.875rem;
            }
            
            .btn {
                padding: 0.375rem 0.75rem;
            }
        }
        
        /* Cho màn hình laptop nhỏ với sidebar */
        @media (min-width: 768px) and (max-width: 1200px) {
            .main-content {
                padding: 10px;
            }
            
            .table th,
            .table td {
                padding: 0.3rem 0.2rem;
                font-size: 0.75rem;
            }
            
            .action-buttons .btn {
                padding: 0.15rem 0.25rem;
                font-size: 0.65rem;
            }
            
            /* Ẩn một số cột không quan trọng */
            .table th:nth-child(5),
            .table td:nth-child(5) {
                display: none;
            }
        }
        
        /* Cho màn hình mobile */
        @media (max-width: 767px) {
            .main-content {
                margin-left: 0;
                padding: 10px;
            }
            
            .table-responsive {
                font-size: 0.7rem;
            }
            
            .table th,
            .table td {
                padding: 0.3rem 0.15rem;
                white-space: nowrap;
            }
            
            .action-buttons .btn {
                padding: 0.15rem 0.2rem;
                font-size: 0.6rem;
                margin-right: 1px;
            }
            
            /* Ẩn cột địa chỉ và phone trên mobile */
            .table th:nth-child(4),
            .table td:nth-child(4),
            .table th:nth-child(5),
            .table td:nth-child(5) {
                display: none;
            }
            
            /* Responsive search form */
            .search-container .d-flex {
                flex-direction: column;
                gap: 10px;
            }
            
            .search-container .d-flex .form-control {
                margin-right: 0;
                margin-bottom: 10px;
            }
        }
        
        /* Cho màn hình rất lớn */
        @media (min-width: 1400px) {
            .table th,
            .table td {
                padding: 0.75rem 0.5rem;
            }
        }
        
        /* Truncate text cho các cột dài */
        .text-truncate-custom {
            max-width: 150px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
        
        @media (min-width: 1200px) {
            .text-truncate-custom {
                max-width: 200px;
            }
        }
        
        /* Tooltip cho text bị cắt */
        [data-bs-toggle="tooltip"] {
            cursor: help;
        }
        
        /* Responsive modal */
        @media (max-width: 768px) {
            .modal-dialog {
                margin: 0.5rem;
                max-width: calc(100% - 1rem);
            }
            
            .modal-body .row {
                margin: 0;
            }
            
            .modal-body .col-md-6 {
                padding: 0 0.5rem;
            }
        }
        
        /* Container responsive */
        .content-container {
            max-width: 100%;
            padding-right: 15px;
            padding-left: 15px;
        }
        
        @media (min-width: 1200px) {
            .content-container {
                padding-right: 20px;
                padding-left: 20px;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="../manager_topbarsidebar.jsp" />

    <!-- Main content area - tránh chồng lấn với sidebar -->
    <div class="main-content">
        <div class="content-container">
            <h2 class="mb-4">Quản lý nhà cung cấp</h2>
            
            <!-- Thông báo -->
            <div id="alert-container">
                <c:if test="${not empty sessionScope.message}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        ${sessionScope.message}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                    <c:remove var="message" scope="session" />
                </c:if>
                
                <c:if test="${not empty sessionScope.error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        ${sessionScope.error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                    <c:remove var="error" scope="session" />
                </c:if>
            </div>

            <!-- Tìm kiếm và thêm mới -->
            <div class="row search-container">
                <div class="col-lg-8 col-md-7 mb-2 mb-md-0">
                    <form action="supplier" method="get" class="d-flex">
                        <input type="hidden" name="action" value="search">
                        <input type="text" name="keyword" class="form-control me-2" placeholder="Tìm kiếm theo tên, email hoặc số điện thoại" value="${keyword}">
                        <button type="submit" class="btn btn-primary flex-shrink-0">
                            <i class="fas fa-search d-none d-md-inline"></i>
                            <span class="d-md-none">Tìm</span>
                            <span class="d-none d-md-inline">Tìm kiếm</span>
                        </button>
                    </form>
                </div>
                <div class="col-lg-4 col-md-5 text-end">
    <button type="button" class="btn btn-success btn-sm" data-bs-toggle="modal" data-bs-target="#addSupplierModal">
        <i class="fas fa-plus"></i>
        <span class="d-none d-sm-inline">Thêm nhà cung cấp</span>
        <span class="d-sm-none">Thêm</span>
    </button>
</div>

            </div>

            <!-- Bảng danh sách nhà cung cấp với responsive tối ưu -->
            <div class="table-responsive">
                <table class="table table-striped table-hover mb-0">
                    <thead class="table-dark">
                        <tr>
                            <th class="text-center">ID</th>
                            <th>Tên nhà cung cấp</th>
                            <th>Email</th>
                            <th class="d-none d-md-table-cell">Điện thoại</th>
                            <th class="d-none d-lg-table-cell">Địa chỉ</th>
                            <th class="text-center">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${suppliers}" var="supplier">
                            <tr>
                                <td class="text-center">${supplier.supplierID}</td>
                                <td>
                                    <div class="text-truncate-custom" 
                                         data-bs-toggle="tooltip" 
                                         data-bs-placement="top" 
                                         title="${supplier.supplierName}">
                                        ${supplier.supplierName}
                                    </div>
                                </td>
                                <td>
                                    <div class="text-truncate-custom" 
                                         data-bs-toggle="tooltip" 
                                         data-bs-placement="top" 
                                         title="${supplier.email}">
                                        ${supplier.email}
                                    </div>
                                </td>
                                <td class="d-none d-md-table-cell">${supplier.phone}</td>
                                <td class="d-none d-lg-table-cell">
                                    <div class="text-truncate-custom" 
                                         data-bs-toggle="tooltip" 
                                         data-bs-placement="top" 
                                         title="${supplier.address}">
                                        ${supplier.address}
                                    </div>
                                </td>
                                <td class="action-buttons text-center">
                                    <button class="btn btn-sm btn-info view-btn" 
                                            data-id="${supplier.supplierID}" 
                                            data-bs-toggle="modal" 
                                            data-bs-target="#viewSupplierModal"
                                            title="Xem chi tiết">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                    <button class="btn btn-sm btn-primary edit-btn" 
                                            data-id="${supplier.supplierID}" 
                                            data-bs-toggle="modal" 
                                            data-bs-target="#editSupplierModal"
                                            title="Chỉnh sửa">
                                        <i class="fas fa-edit"></i>
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                        
                        <c:if test="${empty suppliers}">
                            <tr>
                                <td colspan="6" class="text-center py-4">
                                    <i class="fas fa-inbox fa-2x text-muted mb-2"></i>
                                    <p class="text-muted mb-0">Không tìm thấy nhà cung cấp nào</p>
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>

            <!-- Phân trang responsive -->
            <c:if test="${totalPages > 1}">
                <nav aria-label="Page navigation" class="mt-4">
                    <ul class="pagination pagination-sm justify-content-center">
                        <c:if test="${currentPage > 1}">
                            <li class="page-item">
                                <a class="page-link" href="supplier?action=${empty keyword ? 'list' : 'search'}&page=${currentPage - 1}${not empty keyword ? '&keyword='.concat(keyword) : ''}" aria-label="Previous">
                                    <span aria-hidden="true">&laquo;</span>
                                </a>
                            </li>
                        </c:if>
                        
                        <!-- Hiển thị trang đầu -->
                        <c:if test="${currentPage > 3}">
                            <li class="page-item">
                                <a class="page-link" href="supplier?action=${empty keyword ? 'list' : 'search'}&page=1${not empty keyword ? '&keyword='.concat(keyword) : ''}">1</a>
                            </li>
                            <c:if test="${currentPage > 4}">
                                <li class="page-item disabled">
                                    <span class="page-link">...</span>
                                </li>
                            </c:if>
                        </c:if>
                        
                        <!-- Hiển thị các trang xung quanh trang hiện tại -->
                        <c:forEach begin="${currentPage > 2 ? currentPage - 1 : 1}" 
                                   end="${currentPage < totalPages - 1 ? currentPage + 1 : totalPages}" 
                                   var="i">
                            <li class="page-item ${currentPage == i ? 'active' : ''}">
                                <a class="page-link" href="supplier?action=${empty keyword ? 'list' : 'search'}&page=${i}${not empty keyword ? '&keyword='.concat(keyword) : ''}">${i}</a>
                            </li>
                        </c:forEach>
                        
                        <!-- Hiển thị trang cuối -->
                        <c:if test="${currentPage < totalPages - 2}">
                            <c:if test="${currentPage < totalPages - 3}">
                                <li class="page-item disabled">
                                    <span class="page-link">...</span>
                                </li>
                            </c:if>
                            <li class="page-item">
                                <a class="page-link" href="supplier?action=${empty keyword ? 'list' : 'search'}&page=${totalPages}${not empty keyword ? '&keyword='.concat(keyword) : ''}">${totalPages}</a>
                            </li>
                        </c:if>
                        
                        <c:if test="${currentPage < totalPages}">
                            <li class="page-item">
                                <a class="page-link" href="supplier?action=${empty keyword ? 'list' : 'search'}&page=${currentPage + 1}${not empty keyword ? '&keyword='.concat(keyword) : ''}" aria-label="Next">
                                    <span aria-hidden="true">&raquo;</span>
                                </a>
                            </li>
                        </c:if>
                    </ul>
                </nav>
            </c:if>
        </div>
    </div>

    <!-- Modal Thêm nhà cung cấp -->
    <div class="modal fade" id="addSupplierModal" tabindex="-1" aria-labelledby="addSupplierModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addSupplierModalLabel">Thêm nhà cung cấp mới</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form id="addSupplierForm">
                    <div class="modal-body">
                        <div id="add-form-errors" class="alert alert-danger d-none"></div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="supplierName" class="form-label">Tên nhà cung cấp <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="supplierName" name="supplierName" required>
                                <div class="error-feedback" id="supplierName-error"></div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="email" class="form-label">Email <span class="text-danger">*</span></label>
                                <input type="email" class="form-control" id="email" name="email" required>
                                <div class="error-feedback" id="email-error"></div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="phone" class="form-label">Số điện thoại</label>
                                <input type="tel" class="form-control" id="phone" name="phone">
                                <div class="error-feedback" id="phone-error"></div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="address" class="form-label">Địa chỉ</label>
                                <textarea class="form-control" id="address" name="address" rows="3"></textarea>
                                <div class="error-feedback" id="address-error"></div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="button" id="addSupplierBtn" class="btn btn-success">Thêm mới</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Modal Xem chi tiết nhà cung cấp -->
    <div class="modal fade" id="viewSupplierModal" tabindex="-1" aria-labelledby="viewSupplierModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="viewSupplierModalLabel">Chi tiết nhà cung cấp</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="fw-bold">ID:</label>
                            <p id="view-id" class="mb-0"></p>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="fw-bold">Tên nhà cung cấp:</label>
                            <p id="view-name" class="mb-0"></p>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="fw-bold">Email:</label>
                            <p id="view-email" class="mb-0"></p>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="fw-bold">Số điện thoại:</label>
                            <p id="view-phone" class="mb-0"></p>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="fw-bold">Địa chỉ:</label>
                        <p id="view-address" class="mb-0"></p>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal Chỉnh sửa nhà cung cấp -->
    <div class="modal fade" id="editSupplierModal" tabindex="-1" aria-labelledby="editSupplierModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="editSupplierModalLabel">Chỉnh sửa nhà cung cấp</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form id="editSupplierForm">
                    <input type="hidden" id="edit-id" name="id">
                    <div class="modal-body">
                        <div id="edit-form-errors" class="alert alert-danger d-none"></div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="edit-supplierName" class="form-label">Tên nhà cung cấp <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="edit-supplierName" name="supplierName" required>
                                <div class="error-feedback" id="edit-supplierName-error"></div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="edit-email" class="form-label">Email <span class="text-danger">*</span></label>
                                <input type="email" class="form-control" id="edit-email" name="email" required>
                                <div class="error-feedback" id="edit-email-error"></div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="edit-phone" class="form-label">Số điện thoại</label>
                                <input type="tel" class="form-control" id="edit-phone" name="phone">
                                <div class="error-feedback" id="edit-phone-error"></div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="edit-address" class="form-label">Địa chỉ</label>
                                <textarea class="form-control" id="edit-address" name="address" rows="3"></textarea>
                                <div class="error-feedback" id="edit-address-error"></div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="button" id="updateSupplierBtn" class="btn btn-primary">Lưu thay đổi</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS và Popper.js -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    
    <script>
        $(document).ready(function() {
            // Khởi tạo tooltips cho text bị cắt
            var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
            var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
                return new bootstrap.Tooltip(tooltipTriggerEl)
            });
            
            // Hiển thị thông báo
            function showAlert(message, type) {
                const alertHtml = `
                    <div class="alert alert-${type} alert-dismissible fade show" role="alert">
                        ${message}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                `;
                $("#alert-container").html(alertHtml);
                
                // Tự động ẩn thông báo sau 5 giây
                setTimeout(function() {
                    $(".alert").alert('close');
                }, 5000);
            }
            
            // Xử lý khi nhấn nút xem chi tiết
            $('.view-btn').click(function() {
                const supplierId = $(this).data('id');
                
                $.ajax({
                    url: 'supplier',
                    type: 'GET',
                    data: {
                        action: 'view',
                        id: supplierId
                    },
                    dataType: 'json',
                    success: function(response) {
                        $('#view-id').text(response.supplierID);
                        $('#view-name').text(response.supplierName);
                        $('#view-email').text(response.email);
                        $('#view-phone').text(response.phone || 'Không có');
                        $('#view-address').text(response.address || 'Không có');
                    },
                    error: function(xhr) {
                        showAlert('Đã xảy ra lỗi khi tải thông tin nhà cung cấp.', 'danger');
                    }
                });
            });
            
            // Xử lý khi nhấn nút chỉnh sửa
            $('.edit-btn').click(function() {
                const supplierId = $(this).data('id');
                
                // Reset form errors
                $('#edit-form-errors').addClass('d-none').html('');
                $('.error-feedback').text('');
                
                $.ajax({
                    url: 'supplier',
                    type: 'GET',
                    data: {
                        action: 'edit',
                        id: supplierId
                    },
                    dataType: 'json',
                    success: function(response) {
                        $('#edit-id').val(response.supplierID);
                        $('#edit-supplierName').val(response.supplierName);
                        $('#edit-email').val(response.email);
                        $('#edit-phone').val(response.phone);
                        $('#edit-address').val(response.address);
                    },
                    error: function(xhr) {
                        showAlert('Đã xảy ra lỗi khi tải thông tin nhà cung cấp.', 'danger');
                    }
                });
            });
            
            // Xử lý thêm mới nhà cung cấp với Ajax
            $('#addSupplierBtn').click(function() {
                // Reset form errors
                $('#add-form-errors').addClass('d-none').html('');
                $('.error-feedback').text('');
                
                const formData = {
                    action: 'add',
                    supplierName: $('#supplierName').val(),
                    email: $('#email').val(),
                    phone: $('#phone').val(),
                    address: $('#address').val()
                };
                
                $.ajax({
                    url: 'supplier',
                    type: 'POST',
                    data: formData,
                    dataType: 'json',
                    success: function(response) {
                                                if (response.status === 'success') {
                            // Đóng modal
                            $('#addSupplierModal').modal('hide');
                            
                            // Hiển thị thông báo thành công
                            showAlert(response.message, 'success');
                            
                            // Tải lại trang sau 1 giây
                            setTimeout(function() {
                                location.reload();
                            }, 1000);
                        } else {
                            // Hiển thị lỗi
                            if (response.errors) {
                                // Hiển thị lỗi cụ thể cho từng trường
                                for (const field in response.errors) {
                                    $(`#${field}-error`).text(response.errors[field]);
                                }
                            }
                            
                            if (response.message) {
                                $('#add-form-errors').removeClass('d-none').html(response.message);
                            }
                        }
                    },
                    error: function(xhr) {
                        showAlert('Đã xảy ra lỗi khi thêm nhà cung cấp.', 'danger');
                    }
                });
            });
            
            // Xử lý cập nhật nhà cung cấp với Ajax
            $('#updateSupplierBtn').click(function() {
                // Reset form errors
                $('#edit-form-errors').addClass('d-none').html('');
                $('.error-feedback').text('');
                
                const formData = {
                    action: 'update',
                    id: $('#edit-id').val(),
                    supplierName: $('#edit-supplierName').val(),
                    email: $('#edit-email').val(),
                    phone: $('#edit-phone').val(),
                    address: $('#edit-address').val()
                };
                
                $.ajax({
                    url: 'supplier',
                    type: 'POST',
                    data: formData,
                    dataType: 'json',
                    success: function(response) {
                        if (response.status === 'success') {
                            // Đóng modal
                            $('#editSupplierModal').modal('hide');
                            
                            // Hiển thị thông báo thành công
                            showAlert(response.message, 'success');
                            
                            // Tải lại trang sau 1 giây
                            setTimeout(function() {
                                location.reload();
                            }, 1000);
                        } else {
                            // Hiển thị lỗi
                            if (response.errors) {
                                // Hiển thị lỗi cụ thể cho từng trường
                                for (const field in response.errors) {
                                    $(`#edit-${field}-error`).text(response.errors[field]);
                                }
                            }
                            
                            if (response.message) {
                                $('#edit-form-errors').removeClass('d-none').html(response.message);
                            }
                        }
                    },
                    error: function(xhr) {
                        showAlert('Đã xảy ra lỗi khi cập nhật nhà cung cấp.', 'danger');
                    }
                });
            });
            
            // Reset form khi đóng modal
            $('#addSupplierModal').on('hidden.bs.modal', function () {
                $('#addSupplierForm')[0].reset();
                $('#add-form-errors').addClass('d-none').html('');
                $('.error-feedback').text('');
            });
            
            $('#editSupplierModal').on('hidden.bs.modal', function () {
                $('#edit-form-errors').addClass('d-none').html('');
                $('.error-feedback').text('');
            });
            
            // Xử lý responsive sidebar toggle (nếu có)
            $(document).on('click', '.sidebar-toggle', function() {
                $('body').toggleClass('sidebar-collapsed');
            });
        });
    </script>
</body>
</html>

