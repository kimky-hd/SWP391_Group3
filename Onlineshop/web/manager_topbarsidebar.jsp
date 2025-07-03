<%-- 
    Document   : manager_topbarsidebar
    Created on : Jun 17, 2025, 4:38:39 AM
    Author     : Admin
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="Model.Account" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Product Manager</title>
        <!-- Bootstrap CSS -->
        <link href="css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <!-- Custom CSS -->
        <link href="<c:url value='/css/admin.css'/>" rel="stylesheet">
        <link href="css/style.css" rel="stylesheet">
        <style>
            /* ===== TOPBAR (WHITE) ===== */
            .topbar {
                background: #ffffff !important;
                height: 60px;
                padding: 0 24px;
                border-bottom: 1px solid #e5e7eb;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
                position: fixed;
                top: 0;
                left: 0;
                right: 0;
                z-index: 1030;
            }
            .topbar-brand {
                color: #111827 !important; /* đen khói */
                font-size: 24px;
                font-weight: 700;
                text-transform: uppercase;
                display: flex;
                align-items: center;
                gap: 8px;
                text-decoration: none;
            }
            .topbar-actions .nav-link {
                color: #1f2937 !important;
                font-size: 18px;
                margin-left: 12px;
            }
            .topbar-actions .nav-link:hover {
                color: #3b82f6 !important; /* primary */
            }
            /* Search */
            .topbar-search {
                position: relative;
                max-width: 400px;
                width: 100%;
            }
            .topbar-search input {
                padding: 10px 15px 10px 40px;
                border-radius: 30px;
                border: 1px solid #d1d5db;
                background: #f9fafb;
                font-size: 14px;
                color: #111827;
                width: 100%;
            }
            .topbar-search i {
                position: absolute;
                left: 14px;
                top: 50%;
                transform: translateY(-50%);
                color: #9ca3af;
            }
            /* Avatar */
            .user-dropdown img {
                border: 2px solid #e5e7eb;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
            }

            /* ===== SIDEBAR (GRADIENT) ===== */
            :root {
                --sidebar-width: 260px;
                --sidebar-grad-start: #4c1d95;
                --sidebar-grad-end:   #6d28d9;
            }
            .sidebar {
                width: var(--sidebar-width);
                height: 100vh;
                position: fixed;
                top: 60px; /* dưới topbar */
                left: 0;
                overflow-y: auto;
                padding: 0;
                background: linear-gradient(180deg, var(--sidebar-grad-start) 0%, var(--sidebar-grad-end) 100%);
                box-shadow: inset -1px 0 0 rgba(255,255,255,.05);
            }
            .sidebar-menu {
                list-style: none;
                margin: 0;
                padding: 0;
            }
            .sidebar-menu .nav-link {
                position: relative;
                display: flex;
                align-items: center;
                gap: 12px;
                padding: 12px 24px;
                font-size: 15px;
                font-weight: 500;
                color: #f1f5f9;
                text-decoration: none;
                transition: background .25s ease;
            }
            .sidebar-menu .nav-link i {
                font-size: 18px;
                min-width: 20px;
                text-align: center;
            }
            /* Hover + Active */
            .sidebar-menu .nav-link:hover,
            .sidebar-menu .nav-link.active {
                background: rgba(255,255,255,.12);
                color: #ffffff;
            }
            .sidebar-menu .nav-link.active::before {
                content: '';
                position: absolute;
                left: 0;
                top: 0;
                width: 4px;
                height: 100%;
                background: #ffffff;
            }
            /* Icon màu */
            .sidebar-menu li:nth-child(1)  i{
                color:#3b82f6;
            }
            .sidebar-menu li:nth-child(2)  i{
                color:#22c55e;
            }
            .sidebar-menu li:nth-child(3)  i{
                color:#ec4899;
            }
            .sidebar-menu li:nth-child(4)  i{
                color:#f97316;
            }
            .sidebar-menu li:nth-child(5)  i{
                color:#22c55e;
            }
            .sidebar-menu li:nth-child(6)  i{
                color:#eab308;
            }
            .sidebar-menu li:nth-child(7)  i{
                color:#ef4444;
            }
            .sidebar-menu li:nth-child(8)  i{
                color:#0ea5e9;
            }
            .sidebar-menu li:nth-child(9)  i{
                color:#facc15;
            }
            .sidebar-menu li:nth-child(10) i{
                color:#d1d5db;
            }
            /* Main content offset */
            .main-content {
                margin-left: var(--sidebar-width);
                margin-top: 60px;
                padding: 20px;
                background: #f9fafb;
                min-height: calc(100vh - 60px);
            }
        </style>
    </head>

    <body>
        <!-- Topbar -->
        <nav class="navbar navbar-expand-lg topbar">
            <div class="container-fluid px-4 d-flex justify-content-between align-items-center">

                <!-- Left: Brand -->
                <a class="topbar-brand fw-bold text-uppercase" href="managerproductlist">
                    <i class="fas fa-seedling me-2"></i> <!-- icon cây hoa -->
                    Flower Shop
                </a>

                <!-- Right: Actions -->
                <ul class="navbar-nav topbar-actions d-flex align-items-center">
                    <li class="nav-item">
                        <a class="nav-link" href="#"><i class="fas fa-bell"></i></a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#"><i class="fas fa-cog"></i></a>
                    </li>
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
                    <a href="managerproductlist" class="nav-link">
                        <i class="fas fa-list"></i>
                        <span>Quản lý Sản phẩm</span>
                    </a>
                </li>
                <li>
                    <a href="viewcategorylist" class="nav-link">
                        <i class="fas fa-list"></i>
                        <span>Danh mục Sản phẩm</span>
                    </a>
                </li>
                <li>
                    <a href="managermateriallist" class="nav-link">
                        <i class="fas fa-list"></i>
                        <span>Quản lý nguyên liệu</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/orders" class="nav-link">
                        <i class="fas fa-shopping-cart"></i>
                        <span>Quản lý Đơn hàng</span>
                    </a>
                </li>
                <!-- Thêm liên kết đến trang quản lý đơn hàng tự thiết kế -->
                <li>
                    <a href="${pageContext.request.contextPath}/manager/custom-orders" class="nav-link">
                        <i class="fas fa-palette"></i>
                        <span>Quản lý đơn hàng tự thiết kế</span>
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
    </body>
</html>
