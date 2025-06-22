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
            .topbar {
                background-color: var(--dark); /* hoặc dùng màu cụ thể: #1F2937 */
                padding: 10px 0;
                box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
                position: fixed;
                top: 0;
                left: 0;
                right: 0;
                z-index: 1030;
            }
            .topbar-brand {
                color: #3B82F6;
                font-size: 28px;
                font-weight: 700;
                text-decoration: none;
                text-transform: uppercase;
                letter-spacing: 1px;
            }
            .topbar-actions .nav-link {
                color: #ffffff; /* trắng trên nền tối */
            }
            .topbar-search {
                position: relative;
                width: 100%;
                max-width: 600px;
                margin: 0 auto;
            }

            .topbar-search input {
                padding: 10px 15px 10px 45px;
                border-radius: 30px;
                border: 1px solid #e5e7eb;
                width: 100%;
                font-size: 15px;
            }

            .topbar-search i {
                position: absolute;
                left: 15px;
                top: 50%;
                transform: translateY(-50%);
                color: var(--secondary);
                font-size: 16px;
            }
            .sidebar {
                width: 250px;
                background-color: #f8f9fa; /* sáng hơn rõ ràng so với topbar */
                border-right: 1px solid #e0e0e0;
                height: 100vh;
                position: fixed;
                top: 60px;
                left: 0;
                padding: 20px 0;
                overflow-y: auto;
                box-shadow: 2px 0 5px rgba(0, 0, 0, 0.05); /* bóng tách topbar */
            }

            .sidebar-menu .nav-link {
                color: var(--dark); /* tối lại cho rõ */
            }

            .sidebar-menu .nav-link:hover,
            .sidebar-menu .nav-link.active {
                background-color: var(--light);
                color: #3B82F6;
            }
            .main-content {
                margin-left: 250px; /* tránh đè sidebar */
                margin-top: 60px;   /* tránh đè topbar */
                padding: 20px;
                background-color: #f9fafb;
                min-height: calc(100vh - 60px);
            }
            .alert-box {
                position: fixed;
                top: 20%;
                left: 50%;
                transform: translateX(-50%);
                background-color: #d4edda;
                color: #155724;
                padding: 16px 32px;
                border: 1px solid #c3e6cb;
                border-radius: 8px;
                box-shadow: 0 4px 8px rgba(0,0,0,0.2);
                z-index: 1000;
                font-size: 1.1rem;
                animation: fadeOut 0.5s ease-in-out 2.5s forwards;
            }

            @keyframes fadeOut {
                to {
                    opacity: 0;
                    visibility: hidden;
                }
            }
        </style>
    </head>

    <body>
        <!-- Topbar -->
        <nav class="navbar navbar-expand-lg topbar">
            <div class="container-fluid px-4 d-flex justify-content-between align-items-center">

                <!-- Left: Brand -->
                <a class="topbar-brand fw-bold text-uppercase" href="#">
                    <i class="fas fa-seedling me-2"></i> <!-- icon cây hoa -->
                    Flower Shop
                </a>

                <!-- Center: Search -->
                <div class="flex-grow-1 mx-5">
                    <div class="topbar-search w-100">
                        <input type="text" class="form-control" placeholder="Tìm kiếm sản phẩm, danh mục...">
                        <i class="fas fa-search"></i>
                    </div>
                </div>

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
                        <i class="fas fa-flower"></i>
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
