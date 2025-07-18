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
        .search-container {
            margin-bottom: 20px;
        }
        .pagination {
            justify-content: center;
            margin-top: 20px;
        }
        .status-badge {
            font-size: 0.8rem;
            padding: 0.25rem 0.5rem;
        }
        .action-buttons .btn {
            margin-right: 5px;
        }
        .modal-header {
            background-color: #f8f9fa;
        }
    </style>
</head>
<body>
     <jsp:include page="../manager_topbarsidebar.jsp" />

    <div class="container mt-4">
        <h2 class="mb-4">Quản lý nhà cung cấp</h2>
        
        <!-- Thông báo -->
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

        <!-- Tìm kiếm và thêm mới -->
        <div class="row search-container">
            <div class="col-md-8">
                <form action="supplier" method="get" class="d-flex">
                    <input type="hidden" name="action" value="search">
                    <input type="text" name="keyword" class="form-control me-2" placeholder="Tìm kiếm theo tên, email hoặc số điện thoại" value="${keyword}">
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-search"></i> Tìm kiếm
                    </button>
                </form>
            </div>
            <div class="col-md-4 text-end">
                <button type="button" class="btn btn-success" data-bs-toggle="modal" data-bs-target="#addSupplierModal">
                    <i class="fas fa-plus"></i> Thêm nhà cung cấp
                </button>
            </div>
        </div>

        <!-- Bảng danh sách nhà cung cấp -->
        <div class="table-responsive">
            <table class="table table-striped table-hover">
                <thead class="table-dark">
                    <tr>
                        <th>ID</th>
                        <th>Tên nhà cung cấp</th>
                        <th>Email</th>
                        <th>Điện thoại</th>
                        <th>Địa chỉ</th>
                        <th>Trạng thái</th>
                        <th>Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${suppliers}" var="supplier">
                        <tr>
                            <td>${supplier.supplierID}</td>
                            <td>${supplier.supplierName}</td>
                            <td>${supplier.email}</td>
                            <td>${supplier.phone}</td>
                            <td>${supplier.address}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${supplier.isActive}">
                                        <span class="badge bg-success status-badge">Hoạt động</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-danger status-badge">Không hoạt động</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="action-buttons">
                                <button class="btn btn-sm btn-info view-btn" 
                                        data-id="${supplier.supplierID}" 
                                        data-bs-toggle="modal" 
                                        data-bs-target="#viewSupplierModal">
                                    <i class="fas fa-eye"></i>
                                </button>
                                <button class="btn btn-sm btn-primary edit-btn" 
                                        data-id="${supplier.supplierID}" 
                                        data-bs-toggle="modal" 
                                        data-bs-target="#editSupplierModal">
                                    <i class="fas fa-edit"></i>
                                </button>
                                <form action="supplier" method="post" class="d-inline">
                                    <input type="hidden" name="action" value="toggle">
                                    <input type="hidden" name="id" value="${supplier.supplierID}">
                                    <input type="hidden" name="status" value="${supplier.isActive}">
                                    <button type="submit" class="btn btn-sm ${supplier.isActive ? 'btn-warning' : 'btn-success'}" 
                                            onclick="return confirm('Bạn có chắc chắn muốn ${supplier.isActive ? 'vô hiệu hóa' : 'kích hoạt'} nhà cung cấp này?')">
                                        <i class="fas ${supplier.isActive ? 'fa-ban' : 'fa-check'}"></i>
                                    </button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                    
                    <c:if test="${empty suppliers}">
                        <tr>
                            <td colspan="7" class="text-center">Không tìm thấy nhà cung cấp nào</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>

        <!-- Phân trang -->
        <c:if test="${totalPages > 1}">
            <nav aria-label="Page navigation">
                <ul class="pagination">
                    <c:if test="${currentPage > 1}">
                        <li class="page-item">
                            <a class="page-link" href="supplier?action=${empty keyword ? 'list' : 'search'}&page=${currentPage - 1}${not empty keyword ? '&keyword='.concat(keyword) : ''}" aria-label="Previous">
                                <span aria-hidden="true">&laquo;</span>
                            </a>
                        </li>
                    </c:if>
                    
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <li class="page-item ${currentPage == i ? 'active' : ''}">
                            <a class="page-link" href="supplier?action=${empty keyword ? 'list' : 'search'}&page=${i}${not empty keyword ? '&keyword='.concat(keyword) : ''}">${i}</a>
                        </li>
                    </c:forEach>
                    
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

    <!-- Modal Thêm nhà cung cấp -->
    <div class="modal fade" id="addSupplierModal" tabindex="-1" aria-labelledby="addSupplierModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addSupplierModalLabel">Thêm nhà cung cấp mới</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="supplier" method="post">
                    <input type="hidden" name="action" value="add">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label for="supplierName" class="form-label">Tên nhà cung cấp <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="supplierName" name="supplierName" required>
                        </div>
                        <div class="mb-3">
                            <label for="email" class="form-label">Email <span class="text-danger">*</span></label>
                            <input type="email" class="form-control" id="email" name="email" required>
                        </div>
                        <div class="mb-3">
                            <label for="phone" class="form-label">Số điện thoại</label>
                            <input type="tel" class="form-control" id="phone" name="phone">
                        </div>
                        <div class="mb-3">
                            <label for="address" class="form-label">Địa chỉ</label>
                            <textarea class="form-control" id="address" name="address" rows="3"></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-success">Thêm mới</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Modal Xem chi tiết nhà cung cấp -->
    <div class="modal fade" id="viewSupplierModal" tabindex="-1" aria-labelledby="viewSupplierModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="viewSupplierModalLabel">Chi tiết nhà cung cấp</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="fw-bold">ID:</label>
                        <p id="view-id"></p>
                    </div>
                    <div class="mb-3">
                        <label class="fw-bold">Tên nhà cung cấp:</label>
                        <p id="view-name"></p>
                    </div>
                    <div class="mb-3">
                        <label class="fw-bold">Email:</label>
                        <p id="view-email"></p>
                    </div>
                    <div class="mb-3">
                        <label class="fw-bold">Số điện thoại:</label>
                        <p id="view-phone"></p>
                    </div>
                    <div class="mb-3">
                        <label class="fw-bold">Địa chỉ:</label>
                        <p id="view-address"></p>
                    </div>
                    <div class="mb-3">
                        <label class="fw-bold">Trạng thái:</label>
                        <p id="view-status"></p>
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
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="editSupplierModalLabel">Chỉnh sửa nhà cung cấp</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="supplier" method="post">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="id" id="edit-id">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label for="edit-supplierName" class="form-label">Tên nhà cung cấp <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="edit-supplierName" name="supplierName" required>
                        </div>
                        <div class="mb-3">
                            <label for="edit-email" class="form-label">Email <span class="text-danger">*</span></label>
                            <input type="email" class="form-control" id="edit-email" name="email" required>
                        </div>
                        <div class="mb-3">
                            <label for="edit-phone" class="form-label">Số điện thoại</label>
                            <input type="tel" class="form-control" id="edit-phone" name="phone">
                        </div>
                        <div class="mb-3">
                            <label for="edit-address" class="form-label">Địa chỉ</label>
                            <textarea class="form-control" id="edit-address" name="address" rows="3"></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
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
                    success: function(response) {
                        $('#view-id').text(response.supplierID);
                        $('#view-name').text(response.supplierName);
                        $('#view-email').text(response.email);
                        $('#view-phone').text(response.phone || 'Không có');
                        $('#view-address').text(response.address || 'Không có');
                        $('#view-status').html(response.isActive ? 
                            '<span class="badge bg-success">Hoạt động</span>' : 
                            '<span class="badge bg-danger">Không hoạt động</span>');
                    },
                    error: function(xhr) {
                        alert('Đã xảy ra lỗi khi tải thông tin nhà cung cấp.');
                    }
                });
            });
            
            // Xử lý khi nhấn nút chỉnh sửa
            $('.edit-btn').click(function() {
                const supplierId = $(this).data('id');
                
                $.ajax({
                    url: 'supplier',
                    type: 'GET',
                    data: {
                        action: 'edit',
                        id: supplierId
                    },
                    success: function(response) {
                        $('#edit-id').val(response.supplierID);
                        $('#edit-supplierName').val(response.supplierName);
                        $('#edit-email').val(response.email);
                        $('#edit-phone').val(response.phone);
                        $('#edit-address').val(response.address);
                    },
                    error: function(xhr) {
                        alert('Đã xảy ra lỗi khi tải thông tin nhà cung cấp.');
                    }
                });
            });
        });
    </script>
</body>
</html>
