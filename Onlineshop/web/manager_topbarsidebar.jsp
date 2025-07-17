<%-- 
    Document   : manager_topbarsidebar
    Created on : Jun 17, 2025, 4:38:39 AM
    Author     : Admin
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="Model.Account" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
    Account account = (Account) session.getAttribute("account");
    int roleId = 0;
    String roleName = "";
    if (account != null) {
        roleId = account.getRole(); // Sử dụng getRole() thay vì getRoleId()
        switch (roleId) {
            case 1:
                roleName = "manager";
                break;
            case 2:
                roleName = "staff";
                break;
            case 3:
                roleName = "shipper";
                break;
            default:
                roleName = "guest";
        }
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>
            <% if (roleId == 1) { %>Quản lý hệ thống<% } 
               else if (roleId == 2) { %>Nhân viên<% } 
               else if (roleId == 3) { %>Shipper<% } 
               else { %>Hệ thống<% } %>
        </title>
        <!-- Bootstrap CSS -->
        <link href="${pageContext.request.contextPath}/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <!-- Role-specific CSS -->
        <% if (roleId == 1) { %>
        <link href="${pageContext.request.contextPath}/css/manager-style.css" rel="stylesheet">
        <% } else if (roleId == 2) { %>
        <link href="${pageContext.request.contextPath}/css/staff-style.css" rel="stylesheet">
        <% } else if (roleId == 3) { %>
        <link href="${pageContext.request.contextPath}/css/shipper-style.css" rel="stylesheet">
        <% } else { %>
        <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
        <% } %>
        <!-- Common responsive CSS -->
        <link href="${pageContext.request.contextPath}/css/common-responsive.css" rel="stylesheet">
        <!-- Dropdown fallback CSS -->
        <link href="${pageContext.request.contextPath}/css/dropdown-fallback.css" rel="stylesheet">
    </head>

    <body data-role="<%= roleId %>">
        <!-- Mobile Toggle Button -->
        <button class="mobile-toggle" type="button" id="mobileToggle" aria-label="Toggle navigation">
            <i class="fas fa-bars"></i>
        </button>

        <!-- Sidebar Overlay for Mobile -->
        <div class="sidebar-overlay" id="sidebarOverlay"></div>

        <!-- Topbar -->
        <nav class="navbar navbar-expand-lg topbar">
            <div class="container-fluid px-4 d-flex justify-content-between align-items-center">

                <!-- Left: Brand -->
                <a class="topbar-brand fw-bold text-uppercase" href="<%= roleId == 1 ? "managerproductlist" : (roleId == 2 ? "staffdashboard" : (roleId == 3 ? "shipperdashboard" : "#")) %>">
                    <div class="brand-icon">
                        <% if (roleId == 1) { %>
                        <i class="fas fa-crown"></i>
                        <% } else if (roleId == 2) { %>
                        <i class="fas fa-user-tie"></i>
                        <% } else if (roleId == 3) { %>
                        <i class="fas fa-truck"></i>
                        <% } else { %>
                        <i class="fas fa-seedling"></i>
                        <% } %>
                    </div>
                    <span>
                        <% if (roleId == 1) { %>
                        Manager Panel
                        <% } else if (roleId == 2) { %>
                        Staff Panel
                        <% } else if (roleId == 3) { %>
                        Shipper Panel
                        <% } else { %>
                        Flower Shop
                        <% } %>
                    </span>
                </a>

                <!-- Right: Actions -->
                <ul class="navbar-nav topbar-actions d-flex align-items-center">
                    <li class="nav-item">
                        <a class="nav-link" href="#" data-bs-toggle="tooltip" title="Thông báo">
                            <i class="fas fa-bell"></i>
                            <span class="badge bg-danger position-absolute top-0 start-100 translate-middle rounded-pill">3</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#" data-bs-toggle="tooltip" title="Cài đặt">
                            <i class="fas fa-cog"></i>
                        </a>
                    </li>
                    <li class="nav-item dropdown">
                        <% if(session.getAttribute("account") != null) { 
                            Account acc = (Account)session.getAttribute("account");
                        %>
                        <a class="nav-link dropdown-toggle user-dropdown" href="#" id="userDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                            <img src="${pageContext.request.contextPath}/img/user.jpg" alt="user" class="rounded-circle me-2" width="32">
                            <%= acc.getUsername() %>
                            <span class="badge bg-secondary ms-2">
                                <% if (roleId == 1) { %>Manager<% } 
                                   else if (roleId == 2) { %>Staff<% } 
                                   else if (roleId == 3) { %>Shipper<% } 
                                   else { %>Guest<% } %>
                            </span>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end admin-dropdown" aria-labelledby="userDropdown">
                            <li>
                                <a class="dropdown-item" href="${pageContext.request.contextPath}/profile.jsp">
                                    <i class="fas fa-user me-2"></i>Thông tin cá nhân
                                </a>
                            </li>
                            <li>
                                <a class="dropdown-item" href="${pageContext.request.contextPath}/logout">
                                    <i class="fas fa-sign-out-alt me-2"></i>Đăng xuất
                                </a>
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
                <% if (roleId == 1) { // Manager Menu %>
                <li>
                    <a href="${pageContext.request.contextPath}/dashboard" class="nav-link">
                        <i class="fas fa-chart-line"></i>
                        <span>Dashboard</span>
                    </a>
                </li>
                <li>
                    <a href="managerproductlist" class="nav-link">
                        <i class="fas fa-boxes"></i>
                        <span>Quản lý Sản phẩm</span>
                    </a>
                </li>
                <li>
                    <a href="viewcategorylist" class="nav-link">
                        <i class="fas fa-tags"></i>
                        <span>Danh mục Sản phẩm</span>
                    </a>
                </li>
                <li>
                    <a href="managermateriallist" class="nav-link">
                        <i class="fas fa-seedling"></i>
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
                    <a href="${pageContext.request.contextPath}/manager/custom-orders" class="nav-link">
                        <i class="fas fa-palette"></i>
                        <span>Đơn hàng tự thiết kế</span>
                    </a>
                </li>

                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/manager/staff">
                        <i class="fas fa-user-tie"></i>
                        <span>Quản lý Nhân viên</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/manager/shipper" class="nav-link">
                        <i class="fas fa-users"></i>
                        <span>Quản lý Shippers</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/manager/supplier" class="nav-link">
                        <i class="fas fa-users"></i>
                        <span>Quản lý Nhà cung cấp</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/vouchers" class="nav-link">
                        <i class="fas fa-percent"></i>
                        <span>Khuyến mãi</span>
                    </a>
                </li>
               
                <li>
                    <a href="${pageContext.request.contextPath}/manager/blogs" class="nav-link">
                        <i class="fas fa-blog"></i>
                        <span>Quản lý Blog</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/revenue-chart" class="nav-link">
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
                <% } else if (roleId == 2) { // Staff Menu %>

                <li>
                    <a href="${pageContext.request.contextPath}/staff/blogs" class="nav-link">
                        <i class="fas fa-blog"></i>
                        <span>Quản lý Blog</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/staff/customers" class="nav-link">
                        <i class="fas fa-users"></i>
                        <span>Quản lý Khách hàng</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/staff/complaints" class="nav-link">
                        <i class="fas fa-users"></i>
                        <span>Quản lý Khiếu Nại</span>
                    </a>
                </li>
                
                <% } else if (roleId == 3) { // Shipper Menu %>
                <li>
                    <a href="${pageContext.request.contextPath}/shipper/dashboard" class="nav-link">
                        <i class="fas fa-route"></i>
                        <span>Dashboard</span>
                    </a>
                </li>


                <% } else { // Guest or Default Menu %>
                <li>
                    <a href="login.jsp" class="nav-link">
                        <i class="fas fa-sign-in-alt"></i>
                        <span>Đăng nhập</span>
                    </a>
                </li>
                <% } %>
            </ul>
        </nav>

        <!-- Logout Modal -->


        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
        <!-- Dropdown Fix JS -->
        <script src="${pageContext.request.contextPath}/js/dropdown-fix.js"></script>
        <!-- Mobile Navigation -->
        <script src="${pageContext.request.contextPath}/js/mobile-navigation.js"></script>
        <!-- Role-specific JS -->
        <% if (roleId == 1) { %>
        <script src="${pageContext.request.contextPath}/js/manager-script.js"></script>
        <% } else if (roleId == 2) { %>
        <script src="${pageContext.request.contextPath}/js/staff-script.js"></script>
        <% } else if (roleId == 3) { %>
        <script src="${pageContext.request.contextPath}/js/shipper-script.js"></script>
        <% } else { %>
        <script src="${pageContext.request.contextPath}/js/main.js"></script>
        <% } %>
    </body>
</html>
