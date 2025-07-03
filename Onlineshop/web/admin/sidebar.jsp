<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="Model.Account" %>

<style>
    /* Sidebar Styles */
    .sidebar {
        position: fixed;
        top: 60px; /* Chiều cao của topbar */
        left: 0;
        width: 250px;
        height: calc(100vh - 60px);
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        padding: 20px 0;
        overflow-y: auto;
        z-index: 1000;
        box-shadow: 2px 0 10px rgba(0,0,0,0.1);
    }

    .sidebar-menu {
        list-style: none;
        padding: 0;
        margin: 0;
    }

    .sidebar-menu li {
        margin: 0;
        padding: 0;
    }

    .sidebar-menu .nav-link {
        display: flex;
        align-items: center;
        padding: 15px 25px;
        color: rgba(255, 255, 255, 0.8);
        text-decoration: none;
        transition: all 0.3s ease;
        border: none;
        background: none;
        font-weight: 500;
    }

    .sidebar-menu .nav-link:hover {
        background: rgba(255, 255, 255, 0.1);
        color: white;
        transform: translateX(5px);
    }

    .sidebar-menu .nav-link.active {
        background: rgba(255, 255, 255, 0.2);
        color: white;
        border-right: 4px solid #fff;
    }

    .sidebar-menu .nav-link i {
        width: 20px;
        margin-right: 12px;
        text-align: center;
        font-size: 16px;
    }

    .sidebar-menu .nav-link span {
        font-size: 14px;
    }

    /* Custom icon styles for better visibility */
    .sidebar-menu .nav-link i.fa-seedling {
        color: #90EE90; /* Light green for plants/flowers */
    }

    .sidebar-menu .nav-link i.fa-chart-line {
        color: #87CEEB; /* Sky blue for dashboard */
    }

    .sidebar-menu .nav-link i.fa-list {
        color: #DDA0DD; /* Plum for categories */
    }

    .sidebar-menu .nav-link i.fa-shopping-cart {
        color: #FFB347; /* Peach for orders */
    }

    .sidebar-menu .nav-link i.fa-users {
        color: #98FB98; /* Pale green for users */
    }

    .sidebar-menu .nav-link i.fa-user-tie {
        color: #F0E68C; /* Khaki for staff */
    }

    .sidebar-menu .nav-link i.fa-percent {
        color: #FF6347; /* Tomato for vouchers */
    }

    .sidebar-menu .nav-link i.fa-blog {
        color: #20B2AA; /* Light sea green for blog */
    }

    .sidebar-menu .nav-link i.fa-chart-bar {
        color: #FFD700; /* Gold for reports */
    }

    .sidebar-menu .nav-link i.fa-cog {
        color: #C0C0C0; /* Silver for settings */
    }

    /* Main content adjustment */
    .main-content {
        margin-left: 250px;
        padding: 20px;
        min-height: calc(100vh - 60px);
        background-color: #f8f9fa;
    }

    /* Topbar styles */
    .topbar {
        position: fixed;
        top: 0;
        left: 0;
        right: 0;
        height: 60px;
        background: white;
        border-bottom: 1px solid #e3e6f0;
        z-index: 1001;
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }

    .topbar-brand {
        font-size: 1.5rem;
        font-weight: bold;
        color: #5a5c69;
        text-decoration: none;
    }

    .topbar-search {
        position: relative;
        width: 300px;
    }

    .topbar-search input {
        padding-left: 40px;
        border-radius: 20px;
        border: 1px solid #d1d3e2;
    }

    .topbar-search i {
        position: absolute;
        left: 15px;
        top: 50%;
        transform: translateY(-50%);
        color: #858796;
    }

    .topbar-actions .nav-link {
        color: #5a5c69;
        padding: 0.5rem;
        margin: 0 0.25rem;
    }

    .topbar-actions .nav-link:hover {
        color: #3a3b45;
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

    /* Responsive adjustments */
    @media (max-width: 768px) {
        .sidebar {
            width: 100%;
            height: auto;
            position: relative;
            top: 0;
        }
        
        .main-content {
            margin-left: 0;
        }
        
        .topbar-search {
            display: none;
        }
        
        .user-dropdown {
            font-size: 0.9rem;
        }
    }
</style>

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
                <i class="fas fa-seedling"></i>
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
    <a href="${pageContext.request.contextPath}/orders" class="nav-link ${param.currentPage == 'orders' ? 'active' : ''}">
        <i class="fas fa-shopping-cart"></i>
        <span>Quản lý Đơn hàng</span>
    </a>
</li>
        <li>
            <a href="${pageContext.request.contextPath}/customers" class="nav-link ${param.currentPage == 'customers' ? 'active' : ''}">
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

<script>
    // JavaScript cho sidebar và logout modal
    document.addEventListener('DOMContentLoaded', function() {
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
