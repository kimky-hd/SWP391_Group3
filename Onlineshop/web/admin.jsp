<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="Model.Account" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard</title>
    <!-- Bootstrap CSS -->
    <link href="${pageContext.request.contextPath}/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/css/admin.css" rel="stylesheet">
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
    <!-- Topbar -->
    <nav class="navbar navbar-expand-lg topbar">
        <div class="container-fluid px-4">
            <a class="topbar-brand" href="#">Bán Hoa </a>

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
                <a href="${pageContext.request.contextPath}/dashboard" class="nav-link active">
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
                <a href="${pageContext.request.contextPath}/customers" class="nav-link">
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
                <a href="${pageContext.request.contextPath}/promotions" class="nav-link">
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
        <!-- Your content here -->
    </main>

    <!-- Footer -->
    <footer class="footer">
        <div class="container-fluid">
            <div class="row">
                <h3>Đây là footer</h3>
            </div>
        </div>
    </footer>

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

    <!-- Bootstrap Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>

    <style>
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

    <script>
        $(document).ready(function() {
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
    </script>
</body>
</html>
