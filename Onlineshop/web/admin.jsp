<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
                    <li class="nav-item">
                        <a class="nav-link" href="#">
                            <img src="${pageContext.request.contextPath}/img/user.jpg" alt="user" class="rounded-circle" width="32">
                        </a>
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
                    <span>Quản lý Khách hàng</span>
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
    </footer>

    <!-- Bootstrap Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>