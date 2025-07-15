<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Shipper</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/css/manager.css" rel="stylesheet">
    <style>
        .status-badge {
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
        }
        .status-active {
            background-color: #d4edda;
            color: #155724;
        }
        .status-inactive {
            background-color: #f8d7da;
            color: #721c24;
        }
        .action-buttons a, .action-buttons button {
            margin-right: 5px;
        }
        .stats-card {
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
        }
        .stats-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 15px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar và Topbar -->
            <jsp:include page="../manager_topbarsidebar.jsp" />
            
            <!-- Main Content -->
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">Quản lý Shipper</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <a href="${pageContext.request.contextPath}/manager/shipper/add" class="btn btn-primary">
                            <i class="fas fa-plus"></i> Thêm Shipper mới
                        </a>
                    </div>
                </div>
                
                <!-- Thống kê -->
                <div class="row mb-4">
                    <div class="col-md-3">
                        <div class="card stats-card bg-primary text-white">
                            <div class="card-body">
                                <h5 class="card-title">Tổng Shipper</h5>
                                <h2 class="card-text">
                                    <c:out value="${totalShippers}" default="0" />
                                </h2>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card stats-card bg-success text-white">
                            <div class="card-body">
                                <h5 class="card-title">Đang hoạt động</h5>
                                <h2 class="card-text">
                                    <c:out value="${activeShippers}" default="0" />
                                </h2>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card stats-card bg-info text-white">
                            <div class="card-body">
                                <h5 class="card-title">Đang làm việc</h5>
                                <h2 class="card-text">
                                    <c:out value="${workingShippers}" default="0" />
                                </h2>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card stats-card bg-danger text-white">
                            <div class="card-body">
                                <h5 class="card-title">Không hoạt động</h5>
                                <h2 class="card-text">
                                    <c:out value="${inactiveShippers}" default="0" />
                                </h2>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Thông báo lỗi hoặc thành công -->
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger" role="alert">
                        ${errorMessage}
                    </div>
                </c:if>
                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success" role="alert">
                        ${successMessage}
                    </div>
                </c:if>
                
                <!-- Bộ lọc và tìm kiếm -->
                <div class="row mb-3">
                    <div class="col-md-6">
                        <form action="${pageContext.request.contextPath}/manager/shipper" method="get" class="d-flex">
                            <input type="text" name="search" class="form-control me-2" placeholder="Tìm kiếm theo tên, email..." value="${param.search}">
                            <button type="submit" class="btn btn-outline-primary">Tìm kiếm</button>
                        </form>
                    </div>
                    <div class="col-md-6 text-end">
                        <!-- Filter theo trạng thái -->
                        <div class="d-inline-block me-2">
                            <select class="form-select" id="statusSelect" onchange="filterByStatus(this.value)">
                                <option value="">Lọc theo trạng thái</option>
                                <option value="all" ${empty param.status ? 'selected' : ''}>Tất cả</option>
                                <option value="active" ${param.status == 'active' ? 'selected' : ''}>Đang hoạt động</option>
                                <option value="inactive" ${param.status == 'inactive' ? 'selected' : ''}>Không hoạt động</option>
                            </select>
                        </div>
                        
                        <!-- Sắp xếp -->
                        <div class="d-inline-block">
                            <select class="form-select" id="sortSelect" onchange="sortBy(this.value)">
                                <option value="">Sắp xếp theo</option>
                                <option value="name" ${param.sort == 'name' ? 'selected' : ''}>Tên</option>
                                <option value="salary" ${param.sort == 'salary' ? 'selected' : ''}>Lương</option>
                                <option value="orders" ${param.sort == 'orders' ? 'selected' : ''}>Số đơn hàng</option>
                                <option value="date" ${param.sort == 'date' ? 'selected' : ''}>Ngày bắt đầu</option>
                            </select>
                        </div>
                    </div>
                </div>
                
                <!-- Bảng danh sách shipper -->
                <div class="table-responsive">
                    <table class="table table-striped table-hover">
                        <thead class="table-dark">
                            <tr>
                                <th scope="col">ID</th>
                                <th scope="col">Tên đăng nhập</th>
                                <th scope="col">Email</th>
                                <th scope="col">Số điện thoại</th>
                                <th scope="col">Ngày bắt đầu</th>
                                <th scope="col">Lương cơ bản</th>
                                <th scope="col">Đơn đã giao</th>
                                <th scope="col">Trạng thái</th>
                                <th scope="col">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${shippers}" var="shipper">
                                <tr>
                                    <td>${shipper.shipperID}</td>
                                    <td>${shipper.username}</td>
                                    <td>${shipper.email}</td>
                                    <td>${shipper.phone}</td>
                                    <td><fmt:formatDate value="${shipper.startDate}" pattern="dd/MM/yyyy" /></td>
                                    <td><fmt:formatNumber value="${shipper.baseSalary}" type="currency" currencySymbol="₫" /></td>
                                    <td>${shipper.ordersDelivered}</td>
                                    <td>
                                        <span class="status-badge ${shipper.active ? 'status-active' : 'status-inactive'}">
                                            ${shipper.active ? 'Hoạt động' : 'Không hoạt động'}
                                        </span>
                                    </td>
                                    <td class="action-buttons">
                                        <a href="${pageContext.request.contextPath}/manager/shipper/view?id=${shipper.shipperID}" class="btn btn-sm btn-outline-info" title="Xem chi tiết">
                                            <i class="fas fa-eye"></i>
                                        </a>
                                        <a href="${pageContext.request.contextPath}/manager/shipper/edit?id=${shipper.shipperID}" class="btn btn-sm btn-outline-primary" title="Chỉnh sửa">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                        
                                        <!-- Toggle trạng thái -->
                                        <button type="button" class="btn btn-sm ${shipper.active ? 'btn-outline-warning' : 'btn-outline-success'}" 
                                                data-bs-toggle="modal" data-bs-target="#toggleModal${shipper.shipperID}"
                                                title="${shipper.active ? 'Vô hiệu hóa' : 'Kích hoạt'}">
                                            <i class="fas ${shipper.active ? 'fa-ban' : 'fa-check'}"></i>
                                        </button>
                                        
                                        <!-- Modal xác nhận thay đổi trạng thái -->
                                        <div class="modal fade" id="toggleModal${shipper.shipperID}" tabindex="-1" aria-labelledby="toggleModalLabel${shipper.shipperID}" aria-hidden="true">
                                            <div class="modal-dialog">
                                                <div class="modal-content">
                                                    <div class="modal-header">
                                                        <h5 class="modal-title" id="toggleModalLabel${shipper.shipperID}">Xác nhận thay đổi trạng thái</h5>
                                                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                    </div>
                                                    <div class="modal-body">
                                                        Bạn có chắc chắn muốn ${shipper.active ? 'vô hiệu hóa' : 'kích hoạt'} tài khoản shipper <strong>${shipper.username}</strong> không?
                                                    </div>
                                                    <div class="modal-footer">
                                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                                                        <a href="${pageContext.request.contextPath}/manager/shipper/toggle?id=${shipper.shipperID}&status=${!shipper.active}" class="btn ${shipper.active ? 'btn-warning' : 'btn-success'}">
                                                            ${shipper.active ? 'Vô hiệu hóa' : 'Kích hoạt'}
                                                        </a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            
                            <!-- Hiển thị thông báo nếu không có shipper nào -->
                            <c:if test="${empty shippers}">
                                <tr>
                                    <td colspan="9" class="text-center">Không có shipper nào được tìm thấy</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
                
                <!-- Phân trang -->
                <c:if test="${totalPages > 1}">
                    <nav aria-label="Page navigation">
                        <ul class="pagination justify-content-center">
                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/manager/shipper?page=${currentPage - 1}${not empty param.status ? '&status='.concat(param.status) : ''}${not empty param.sort ? '&sort='.concat(param.sort) : ''}${not empty param.search ? '&search='.concat(param.search) : ''}" aria-label="Previous">
                                    <span aria-hidden="true">&laquo;</span>
                                </a>
                            </li>
                            
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <li class="page-item ${currentPage == i ? 'active' : ''}">
                                    <a class="page-link" href="${pageContext.request.contextPath}/manager/shipper?page=${i}${not empty param.status ? '&status='.concat(param.status) : ''}${not empty param.sort ? '&sort='.concat(param.sort) : ''}${not empty param.search ? '&search='.concat(param.search) : ''}">${i}</a>
                                </li>
                            </c:forEach>
                            
                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/manager/shipper?page=${currentPage + 1}${not empty param.status ? '&status='.concat(param.status) : ''}${not empty param.sort ? '&sort='.concat(param.sort) : ''}${not empty param.search ? '&search='.concat(param.search) : ''}" aria-label="Next">
                                    <span aria-hidden="true">&raquo;</span>
                                </a>
                            </li>
                        </ul>
                    </nav>
                </c:if>
            </main>
        </div>
    </div>
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Custom JS -->
    <script src="${pageContext.request.contextPath}/js/manager.js"></script>
    
    <script>
        // Function để filter theo trạng thái
        function filterByStatus(status) {
            if (status === '') return;
            
            let url = '${pageContext.request.contextPath}/manager/shipper';
            let params = [];
            
            if (status !== 'all') {
                params.push('status=' + status);
            }
            
            // Giữ nguyên search parameter nếu có
            if ('${param.search}' !== '') {
                params.push('search=' + encodeURIComponent('${param.search}'));
            }
            
            // Giữ nguyên sort parameter nếu có
            if ('${param.sort}' !== '') {
                params.push('sort=' + '${param.sort}');
            }
            
            if (params.length > 0) {
                url += '?' + params.join('&');
            }
            
            window.location.href = url;
        }
        
        // Function để sắp xếp
        function sortBy(sort) {
            if (sort === '') return;
            
            let url = '${pageContext.request.contextPath}/manager/shipper?sort=' + sort;
            
            // Giữ nguyên status parameter nếu có
            if ('${param.status}' !== '') {
                url += '&status=' + '${param.status}';
            }
            
            // Giữ nguyên search parameter nếu có
            if ('${param.search}' !== '') {
                url += '&search=' + encodeURIComponent('${param.search}');
            }
            
            window.location.href = url;
        }
    </script>
</body>
</html>
