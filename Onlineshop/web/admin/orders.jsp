<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="Model.Account" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Đơn hàng - Admin</title>
    <!-- Bootstrap CSS -->
    <link href="${pageContext.request.contextPath}/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="<c:url value='/css/admin.css'/>" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
    <style>
        .order-table th, .order-table td {
            vertical-align: middle;
        }
        .status-badge {
            padding: 5px 10px;
            border-radius: 20px;
            font-weight: 500;
            font-size: 0.85rem;
        }
        .status-pending {
            background-color: #ffeeba;
            color: #856404;
        }
        .status-completed {
            background-color: #d4edda;
            color: #155724;
        }
        .status-cancelled {
            background-color: #f8d7da;
            color: #721c24;
        }
        .action-buttons .btn {
            margin-right: 5px;
        }
        .search-box {
            margin-bottom: 20px;
        }
        .filter-section {
            margin-bottom: 20px;
            padding: 15px;
            background-color: #f8f9fa;
            border-radius: 5px;
        }
    </style>
</head>
<body>
    <jsp:include page="../manager_topbarsidebar.jsp" />

    <main class="main-content">
        <div class="container-fluid">
            <h1 class="h3 mb-2 text-gray-800">Quản lý Đơn hàng</h1>

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
            <div class="card shadow mb-4">
                <div class="card-header py-3 d-flex justify-content-between align-items-center">
                    <div class="d-flex" style="max-width: 300px;">
                        <input type="text" id="searchInput" class="form-control me-2" placeholder="Tìm kiếm đơn hàng..." />
                        <button type="button" class="btn btn-primary">
                            <i class="fas fa-search"></i>
                        </button>
                    </div>

                    <div class="d-flex">
                        <div class="me-3">
                            <select class="form-select" id="statusFilter">
                                <option value="">Tất cả trạng thái</option>
                                <option value="Pending">Đang xử lý</option>
                                <option value="Completed">Hoàn thành</option>
                                <option value="Cancelled">Đã hủy</option>
                            </select>
                        </div>
                        <div>
                            <input type="date" class="form-control" id="dateFilter">
                        </div>
                    </div>
                </div>

                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-bordered" id="dataTable" width="100%" cellspacing="0">
                            <thead>
                                <tr>
                                    <th>Mã đơn hàng</th>
                                    <th>Khách hàng</th>
                                    <th>Ngày đặt</th>
                                    <th>Tổng tiền</th>
                                    <th>Trạng thái</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${orders}" var="order">
                                    <tr>
                                        <td>#${order.orderId}</td>
                                        <td>${order.fullName}</td>
                                        <td><fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy" /></td>
                                        <td><fmt:formatNumber value="${order.total}" type="currency" currencySymbol="đ" maxFractionDigits="0"/></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${order.status eq 'Pending'}">
                                                    <span class="status-badge status-pending">Đang xử lý</span>
                                                </c:when>
                                                <c:when test="${order.status eq 'Completed'}">
                                                    <span class="status-badge status-completed">Hoàn thành</span>
                                                </c:when>
                                                <c:when test="${order.status eq 'Cancelled'}">
                                                    <span class="status-badge status-cancelled">Đã hủy</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="status-badge">${order.status}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="action-buttons">
                                            <a href="${pageContext.request.contextPath}/orders?action=detail&orderId=${order.orderId}" class="btn btn-info btn-sm">
                                                <i class="fas fa-eye"></i>
                                            </a>
                                            <c:if test="${order.status eq 'Pending'}">
                                                <button class="btn btn-success btn-sm" onclick="updateStatus(${order.orderId}, 2)">
                                                    <i class="fas fa-check"></i>
                                                </button>
                                                <button class="btn btn-warning btn-sm" onclick="updateStatus(${order.orderId}, 3)">
                                                    <i class="fas fa-times"></i>
                                                </button>
                                            </c:if>
                                            <button class="btn btn-danger btn-sm" onclick="confirmDelete(${order.orderId})">
                                                <i class="fas fa-trash"></i>
                                            </button>
                                        </td>
                                    </tr>
                                </c:forEach>
                                
                                <c:if test="${empty orders}">
                                    <tr>
                                        <td colspan="6" class="text-center">Không có đơn hàng nào</td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Phân trang -->
            <c:if test="${tag != null}">
                <ul class="pagination">
                    <c:if test="${tag != 1}">
                        <li class="page-item">
                            <a class="page-link" href="orders?index=${tag - 1}">Previous</a>
                        </li>
                    </c:if>
                    <c:forEach begin="1" end="${endPage}" var="i">
                        <li class="page-item ${tag == i ? 'active' : ''}">
                            <a class="page-link" href="orders?index=${i}">${i}</a>
                        </li>
                    </c:forEach>
                    <c:if test="${tag != endPage}">
                        <li class="page-item">
                            <a class="page-link" href="orders?index=${tag + 1}">Next</a>
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

    <!-- Modal xác nhận xóa -->
    <div class="modal fade" id="deleteModal" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="deleteModalLabel">Xác nhận xóa</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    Bạn có chắc chắn muốn xóa đơn hàng này không? Hành động này không thể hoàn tác.
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="button" class="btn btn-danger" id="confirmDeleteBtn">Xóa</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Biến lưu trữ ID đơn hàng cần xóa
        let orderIdToDelete = null;
        
        // Hàm hiển thị modal xác nhận xóa
        function confirmDelete(orderId) {
            orderIdToDelete = orderId;
            $('#deleteModal').modal('show');
        }
        
        // Hàm cập nhật trạng thái đơn hàng
        function updateStatus(orderId, statusId) {
            if (confirm('Bạn có chắc chắn muốn cập nhật trạng thái đơn hàng này?')) {
                $.ajax({
                    url: '${pageContext.request.contextPath}/orders',
                    type: 'POST',
                    data: {
                        action: 'update',
                        orderId: orderId,
                        statusId: statusId
                    },
                    success: function(response) {
                        if (response.success) {
                            alert(response.message);
                            location.reload();
                        } else {
                            alert(response.message);
                        }
                    },
                    error: function() {
                        alert('Đã xảy ra lỗi khi cập nhật trạng thái đơn hàng.');
                    }
                });
            }
        }
        
        // Xử lý sự kiện khi nhấn nút xác nhận xóa trong modal
        $(document).ready(function() {
            $('#confirmDeleteBtn').click(function() {
                if (orderIdToDelete) {
                    $.ajax({
                        url: '${pageContext.request.contextPath}/orders',
                        type: 'POST',
                        data: {
                            action: 'delete',
                            orderId: orderIdToDelete
                        },
                        success: function(response) {
                            $('#deleteModal').modal('hide');
                            if (response.success) {
                                alert(response.message);
                                location.reload();
                            } else {
                                alert(response.message);
                            }
                        },
                        error: function() {
                            $('#deleteModal').modal('hide');
                            alert('Đã xảy ra lỗi khi xóa đơn hàng.');
                        }
                    });
                }
            });
            
            // Xử lý lọc theo trạng thái
            $('#statusFilter').change(function() {
                filterOrders();
            });
            
            // Xử lý lọc theo ngày
            $('#dateFilter').change(function() {
                filterOrders();
            });
            
            // Xử lý tìm kiếm
            $('#searchInput').keyup(function() {
                filterOrders();
            });
            
            // Hàm lọc đơn hàng
            function filterOrders() {
                const searchText = $('#searchInput').val().toLowerCase();
                const statusFilter = $('#statusFilter').val();
                const dateFilter = $('#dateFilter').val();
                
                $('table tbody tr').each(function() {
                    const orderIdText = $(this).find('td:nth-child(1)').text().toLowerCase();
                    const customerText = $(this).find('td:nth-child(2)').text().toLowerCase();
                    const dateText = $(this).find('td:nth-child(3)').text();
                    const statusText = $(this).find('td:nth-child(5) span').text();
                    
                    let showRow = true;
                    
                    // Lọc theo từ khóa tìm kiếm
                    if (searchText && !(orderIdText.includes(searchText) || customerText.includes(searchText))) {
                        showRow = false;
                    }
                    
                    // Lọc theo trạng thái
                    if (statusFilter && !statusText.includes(statusFilter === 'Pending' ? 'Đang xử lý' : 
                                                 statusFilter === 'Completed' ? 'Hoàn thành' : 
                                                 statusFilter === 'Cancelled' ? 'Đã hủy' : '')) {
                        showRow = false;
                    }
                    
                    // Lọc theo ngày
                    if (dateFilter) {
                        const filterDate = new Date(dateFilter);
                        const orderDate = parseVietnameseDate(dateText);
                        
                        if (filterDate.toDateString() !== orderDate.toDateString()) {
                            showRow = false;
                        }
                    }
                    
                    $(this).toggle(showRow);
                });
            }
            
            // Hàm chuyển đổi ngày định dạng dd/MM/yyyy sang đối tượng Date
            function parseVietnameseDate(dateStr) {
                const parts = dateStr.split('/');
                return new Date(parts[2], parts[1] - 1, parts[0]);
            }
        });
    </script>
</body>
</html>