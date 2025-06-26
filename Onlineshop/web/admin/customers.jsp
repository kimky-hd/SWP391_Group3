<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="Model.Account" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Khách hàng</title>
    <!-- Bootstrap CSS -->
    <link href="${pageContext.request.contextPath}/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/css/admin.css" rel="stylesheet">
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<style>
    /* CSS cho phần xem chi tiết khách hàng */
    .avatar-circle {
        width: 100px;
        height: 100px;
        background-color: #f8f9fa;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        border: 2px solid #0dcaf0;
    }
    
    .customer-info {
        background-color: #f8f9fa;
        border-radius: 8px;
        padding: 10px;
    }
    
    .info-item {
        transition: all 0.3s;
    }
    
    .info-item:hover {
        background-color: #e9ecef;
    }
    
    .info-label {
        color: #6c757d;
    }
    
    /* CSS cho toast notifications */
    .toast-container {
        z-index: 1060;
    }

    /* Admin Dropdown Styles */
    .admin-dropdown {
        border-radius: 10px;
        box-shadow: 0 5px 15px rgba(0,0,0,0.15);
        border: none;
        padding: 10px 0;
        min-width: 200px;
    }

    .admin-dropdown .dropdown-item {
        padding: 10px 20px;
        font-weight: 500;
        transition: all 0.3s ease;
        border: none;
        background: none;
        width: 100%;
        text-align: left;
    }

    .admin-dropdown .dropdown-item:hover {
        background: linear-gradient(45deg, #dc3545, #c82333);
        color: white;
        transform: translateX(5px);
    }

    .user-dropdown {
        border-radius: 20px;
        font-weight: 500;
        transition: all 0.3s ease;
        text-decoration: none;
        color: inherit;
    }

    .user-dropdown:hover {
        background: rgba(0,0,0,0.1);
        color: inherit;
    }

    .logout-btn {
        cursor: pointer;
    }

    /* Admin Modal Styles */
    .admin-modal {
        border: none;
        border-radius: 15px;
        box-shadow: 0 5px 15px rgba(0,0,0,0.2);
    }

    .admin-modal .modal-header {
        border-top-left-radius: 15px;
        border-top-right-radius: 15px;
        border-bottom: none;
    }

    .admin-modal .btn-danger {
        background: linear-gradient(45deg, #dc3545, #c82333);
        border: none;
        transition: all 0.3s ease;
    }

    .admin-modal .btn-danger:hover {
        transform: translateY(-2px);
        box-shadow: 0 5px 15px rgba(220, 53, 69, 0.4);
    }

    /* Responsive adjustments */
    @media (max-width: 768px) {
        .topbar-search {
            display: none;
        }
        
        .user-dropdown {
            font-size: 0.9rem;
        }
    }
</style>

<body>
    <div id="toast-container" class="toast-container position-fixed bottom-0 end-0 p-3"></div>
    <!-- Topbar -->
    <nav class="navbar navbar-expand-lg topbar">
        <div class="container-fluid px-4">
            <a class="topbar-brand" href="#">Bán Hoa</a>

            <div class="d-flex align-items-center">
                <div class="topbar-search me-4">
                    <input type="text" class="form-control" placeholder="Search Keywords...">
                    <i class="fas fa-search"></i>
                </div>

                <ul class="navbar-nav topbar-actions">
                    <li class="nav-item">
                        <a class="nav-link" href="#">
                            <i class="fas fa-bell"></i>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">
                            <i class="fas fa-cog"></i>
                        </a>
                    </li>
                    <!-- User Dropdown -->
                    <li class="nav-item dropdown">
                        <% if(session.getAttribute("account") != null) { 
                            Account acc = (Account)session.getAttribute("account");
                        %>
                        <a class="nav-link dropdown-toggle user-dropdown" href="#" id="userDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                            <img src="${pageContext.request.contextPath}/img/user.jpg" alt="user" class="rounded-circle me-2" width="32">
                            <%= acc.getUsername() %>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end admin-dropdown" aria-labelledby="userDropdown">
                           
                            <li>
                                <button type="button" class="dropdown-item logout-btn" data-bs-toggle="modal" data-bs-target="#logoutModal">
                                    <i class="fas fa-sign-out-alt me-2"></i>Đăng xuất
                                </button>
                            </li>
                        </ul>
                        <% } else { %>
                        <a class="nav-link" href="login.jsp">
                            <i class="fas fa-sign-in-alt me-2"></i>Đăng nhập
                        </a>
                        <% } %>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Sidebar -->
    <nav class="sidebar">
        <ul class="sidebar-menu">
            <li>
                <a href="${pageContext.request.contextPath}/dashboard" class="nav-link">
                    <i class="fas fa-chart-line"></i>
                    <span>Dashboard</span>
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/products" class="nav-link">
                    <i class="fas fa-flower"></i>
                    <span>Quản lý Sản phẩm</span>
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/categories" class="nav-link">
                    <i class="fas fa-list"></i>
                    <span>Danh mục Sản phẩm</span>
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/orders" class="nav-link">
                    <i class="fas fa-shopping-cart"></i>
                    <span>Quản lý Đơn hàng</span>
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/customers" class="nav-link active">
                    <i class="fas fa-users"></i>
                    <span>Quản lý Người Dùng</span>
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/staff" class="nav-link">
                    <i class="fas fa-user-tie"></i>
                    <span>Quản lý Nhân viên</span>
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/vouchers" class="nav-link">
                    <i class="fas fa-percent"></i>
                    <span>Khuyến mãi</span>
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/blogs" class="nav-link">
                    <i class="fas fa-blog"></i>
                    <span>Quản lý Blog</span>
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/reports" class="nav-link">
                    <i class="fas fa-chart-bar"></i>
                    <span>Báo cáo & Thống kê</span>
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/settings" class="nav-link">
                    <i class="fas fa-cog"></i>
                    <span>Cài đặt Hệ thống</span>
                </a>
            </li>
        </ul>
    </nav>

    <!-- Main Content -->
    <main class="main-content">
        <div class="container-fluid px-4">
            <div class="row mb-4">
                <div class="col">
                    <h2 class="mt-4">Quản Lý Người Dùng</h2>
                </div>
                <div class="col-auto mt-4">
                    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addCustomerModal">
                        <i class="fas fa-plus"></i> Thêm Người Dùng
                    </button>
                </div>
            </div>

            <!-- Thông báo -->
            <c:if test="${not empty message}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    ${message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    ${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <!-- Bảng danh sách khách hàng -->
            <div class="card mb-4">
                <div class="card-header">
                    <i class="fas fa-table me-1"></i>
                    Danh sách Người Dùng
                </div>
                <div class="card-body">
                    <table class="table table-striped table-bordered">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Tên đăng nhập</th>
                                <th>Email</th>
                                <th>Số điện thoại</th>
                                <th>Trạng thái</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="customer" items="${customers}">
                                <tr>
                                    <td>${customer.accountID}</td>
                                    <td>${customer.username}</td>
                                    <td>${customer.email}</td>
                                    <td>${customer.phone}</td>
                                    <td>
                                        <c:if test="${customer.isActive}">
                                            <span class="badge bg-success">Hoạt động</span>
                                        </c:if>
                                        <c:if test="${!customer.isActive}">
                                            <span class="badge bg-danger">Vô hiệu hóa</span>
                                        </c:if>
                                    </td>
                                    <td>
                                        <button class="btn btn-sm btn-info" onclick="viewCustomer(${customer.accountID}, '${customer.username}', '${customer.email}', '${customer.phone}', ${customer.isActive})" data-bs-toggle="modal" data-bs-target="#viewCustomerModal">
                                            <i class="fas fa-eye"></i>
                                        </button>
                                        <button class="btn btn-sm btn-primary" onclick="editCustomer(${customer.accountID}, '${customer.username}', '${customer.email}', '${customer.phone}')" data-bs-toggle="modal" data-bs-target="#editCustomerModal">
                                            <i class="fas fa-edit"></i>
                                        </button>
                                        <c:if test="${customer.isActive}">
                                            <a href="customers?action=toggle&id=${customer.accountID}&status=true" class="btn btn-sm btn-danger" onclick="return confirm('Bạn có chắc chắn muốn vô hiệu hóa tài khoản này?')">
                                                <i class="fas fa-ban"></i>
                                            </a>
                                        </c:if>
                                        <c:if test="${!customer.isActive}">
                                            <a href="customers?action=toggle&id=${customer.accountID}&status=false" class="btn btn-sm btn-success" onclick="return confirm('Bạn có chắc chắn muốn kích hoạt lại tài khoản này?')">
                                                <i class="fas fa-check"></i>
                                            </a>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Phân trang -->
            <nav aria-label="Page navigation">
                <ul class="pagination justify-content-center">
                    <c:if test="${currentPage > 1}">
                        <li class="page-item">
                            <a class="page-link" href="customers?page=${currentPage - 1}" aria-label="Previous">
                                <span aria-hidden="true">&laquo;</span>
                            </a>
                        </li>
                    </c:if>
                    
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <li class="page-item ${currentPage == i ? 'active' : ''}">
                            <a class="page-link" href="customers?page=${i}">${i}</a>
                        </li>
                    </c:forEach>
                    
                    <c:if test="${currentPage < totalPages}">
                        <li class="page-item">
                            <a class="page-link" href="customers?page=${currentPage + 1}" aria-label="Next">
                                <span aria-hidden="true">&raquo;</span>
                            </a>
                        </li>
                    </c:if>
                </ul>
            </nav>
        </div>
    </main>

    <!-- Modal Thêm Khách hàng -->
    <div class="modal fade" id="addCustomerModal" tabindex="-1" aria-labelledby="addCustomerModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addCustomerModalLabel">Thêm người dùng mới</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="customers" method="post">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="add">
                        
                        <div class="mb-3">
                            <label for="username" class="form-label">Tên đăng nhập</label>
                            <input type="text" class="form-control" id="username" name="username" required>
                        </div>
                        
                        <div class="mb-3">
                            <label for="password" class="form-label">Mật khẩu</label>
                            <input type="password" class="form-control" id="password" name="password" required>
                        </div>
                        
                        <div class="mb-3">
                            <label for="email" class="form-label">Email</label>
                            <input type="email" class="form-control" id="email" name="email" required>
                        </div>
                        
                        <div class="mb-3">
                            <label for="phone" class="form-label">Số điện thoại</label>
                            <input type="text" class="form-control" id="phone" name="phone">
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                        <button type="submit" class="btn btn-primary">Lưu</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Modal Xem Chi tiết Khách hàng -->
<div class="modal fade" id="viewCustomerModal" tabindex="-1" aria-labelledby="viewCustomerModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-info text-white">
                <h5 class="modal-title" id="viewCustomerModalLabel">
                    <i class="fas fa-user-circle me-2"></i>Chi Tiết Người Dùng
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="customer-profile text-center mb-4">
                    <div class="avatar-circle mx-auto mb-3">
                        <i class="fas fa-user fa-3x text-info"></i>
                    </div>
                    <h4 id="view-username" class="mb-0 fw-bold"></h4>
                    <p id="view-status" class="mb-0"></p>
                </div>
                
                <div class="customer-info">
                    <div class="info-item d-flex border-bottom py-3">
                        <div class="info-label col-4">
                            <i class="fas fa-id-card me-2 text-secondary"></i>
                            <span class="fw-bold">ID:</span>
                        </div>
                        <div class="info-value col-8" id="view-id"></div>
                    </div>
                    
                    <div class="info-item d-flex border-bottom py-3">
                        <div class="info-label col-4">
                            <i class="fas fa-envelope me-2 text-secondary"></i>
                            <span class="fw-bold">Email:</span>
                        </div>
                        <div class="info-value col-8" id="view-email"></div>
                    </div>
                    
                    <div class="info-item d-flex border-bottom py-3">
                        <div class="info-label col-4">
                            <i class="fas fa-phone me-2 text-secondary"></i>
                            <span class="fw-bold">Số điện thoại:</span>
                        </div>
                        <div class="info-value col-8" id="view-phone"></div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                    <i class="fas fa-times me-1"></i>Đóng
                </button>
               
            </div>
        </div>
    </div>
</div>


    <!-- Modal Chỉnh sửa Khách hàng -->
    <div class="modal fade" id="editCustomerModal" tabindex="-1" aria-labelledby="editCustomerModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="editCustomerModalLabel">Chỉnh Sửa Người Dùng</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="customers" method="post">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" id="edit-id" name="id">
                        
                        <div class="mb-3">
                            <label for="edit-username" class="form-label">Tên đăng nhập</label>
                            <input type="text" class="form-control" id="edit-username" name="username" required>
                        </div>
                        
                        <div class="mb-3">
                            <label for="edit-email" class="form-label">Email</label>
                            <input type="email" class="form-control" id="edit-email" name="email" required>
                        </div>
                        
                        <div class="mb-3">
                            <label for="edit-phone" class="form-label">Số điện thoại</label>
                            <input type="text" class="form-control" id="edit-phone" name="phone">
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                        <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Logout Modal -->
    <div class="modal fade" id="logoutModal" tabindex="-1" aria-labelledby="logoutModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content admin-modal">
                <div class="modal-header bg-danger text-white">
                    <h5 class="modal-title" id="logoutModalLabel">
                        <i class="fas fa-sign-out-alt me-2"></i>Xác nhận đăng xuất
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body py-4 text-center">
                    <div class="mb-3">
                        <i class="fas fa-question-circle text-warning" style="font-size: 3rem;"></i>
                    </div>
                    <p class="mb-0" style="font-size: 1.1rem; color: #000000; font-weight: 600;">
                        Bạn có chắc chắn muốn đăng xuất khỏi tài khoản admin?
                    </p>
                </div>
                <div class="modal-footer justify-content-center border-0 pt-0">
                    <button type="button" class="btn btn-secondary px-4" data-bs-dismiss="modal">
                        <i class="fas fa-times me-2"></i>Hủy
                    </button>
                    <a class="btn btn-danger px-4" href="LogoutServlet">
                        <i class="fas fa-sign-out-alt me-2"></i>Đăng xuất
                    </a>
                </div>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="footer">
        <div class="container-fluid">
            <div class="row">
                <h3>Đây là footer</h3>
            </div>
        </div>
    </footer>

    <!-- Bootstrap Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
    // Hàm xem chi tiết khách hàng
    function viewCustomer(id, username, email, phone, isActive) {
        document.getElementById('view-id').textContent = id;
        document.getElementById('view-username').textContent = username;
        document.getElementById('view-email').textContent = email;
        document.getElementById('view-phone').textContent = phone || 'Chưa cập nhật';
        
        let statusText = isActive ? 'Hoạt động' : 'Vô hiệu hóa';
        let statusClass = isActive ? 'text-success' : 'text-danger';
        
        let statusElement = document.getElementById('view-status');
        statusElement.textContent = statusText;
        statusElement.className = statusClass;
    }
    
    // Hàm chỉnh sửa khách hàng
    function editCustomer(id, username, email, phone) {
        document.getElementById('edit-id').value = id;
        document.getElementById('edit-username').value = username;
        document.getElementById('edit-email').value = email;
        document.getElementById('edit-phone').value = phone || '';
    }
    
    // Hiển thị thông báo sau khi thêm/cập nhật
    document.addEventListener('DOMContentLoaded', function() {
        // Tự động ẩn thông báo sau 2 giây
        const alerts = document.querySelectorAll('.alert');
        alerts.forEach(function(alert) {
            setTimeout(function() {
                const bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            }, 2000);
        });
        
        // Hiển thị thông báo sau khi submit form
        const forms = document.querySelectorAll('form');
        forms.forEach(function(form) {
            form.addEventListener('submit', function() {
                // Lưu thông tin form đang submit để hiển thị thông báo phù hợp
                sessionStorage.setItem('formSubmitted', this.querySelector('input[name="action"]').value);
            });
        });
        
        // Hiển thị toast notification nếu có thông báo từ server
        const formAction = sessionStorage.getItem('formSubmitted');
        if (formAction) {
            const successMessage = document.querySelector('.alert-success');
            const errorMessage = document.querySelector('.alert-danger');
            
            if (successMessage) {
                showToast('Thành công', successMessage.textContent, 'success');
            } else if (errorMessage) {
                showToast('Lỗi', errorMessage.textContent, 'danger');
            } else if (formAction === 'add') {
                showToast('Thành công', 'Thêm khách hàng thành công', 'success');
            } else if (formAction === 'update') {
                showToast('Thành công', 'Cập nhật khách hàng thành công', 'success');
            }
            
            // Xóa thông tin đã lưu
            sessionStorage.removeItem('formSubmitted');
        }

        // Xử lý sự kiện khi nhấn vào nút đăng xuất
        $('.logout-btn').on('click', function(e) {
            e.preventDefault();
            $('#logoutModal').modal('show');
        });

        // Đảm bảo dropdown hoạt động đúng
        $('.user-dropdown').on('click', function(e) {
            e.preventDefault();
        });
    });
    
    // Hiển thị toast notification
    function showToast(title, message, type) {
        const toastContainer = document.getElementById('toast-container');
        if (!toastContainer) {
            const container = document.createElement('div');
            container.id = 'toast-container';
            container.className = 'toast-container position-fixed bottom-0 end-0 p-3';
            document.body.appendChild(container);
        }
        
        const toastId = 'toast-' + Date.now();
        const toastHTML = `
            <div id="${toastId}" class="toast align-items-center text-white bg-${type} border-0" role="alert" aria-live="assertive" aria-atomic="true">
                <div class="d-flex">
                    <div class="toast-body">
                        <strong>${title}</strong>: ${message}
                    </div>
                    <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
                </div>
            </div>
        `;
        
        document.getElementById('toast-container').insertAdjacentHTML('beforeend', toastHTML);
        const toastElement = document.getElementById(toastId);
        const toast = new bootstrap.Toast(toastElement, { delay: 5000 });
        toast.show();
    }
</script>
</body>
</html>
