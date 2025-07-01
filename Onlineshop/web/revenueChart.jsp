<%@ page import="java.util.*, Model.RevenueByMonth, Model.RevenueByProduct, Model.RevenueByCustomer, Model.Account" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Báo cáo doanh thu</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link href="${pageContext.request.contextPath}/css/admin.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8f9fa; /* Light background for Bootstrap feel */
            margin: 0;
            padding: 20px 0;
            color: #343a40;
            line-height: 1.6;
        }

        .container-fluid {
            max-width: 1300px; /* Slightly wider container */
            margin: 0 auto;
            padding: 30px 20px;
        }

        .card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.08);
            margin-bottom: 30px;
        }

        .card-header {
            background-color: #007bff; /* Primary Bootstrap blue */
            color: white;
            border-top-left-radius: 12px;
            border-top-right-radius: 12px;
            padding: 20px;
            font-size: 1.5em;
            font-weight: 600;
        }

        .card-body {
            padding: 30px;
        }

        h1 {
            text-align: center;
            color: #007bff; /* Primary blue for main title */
            margin-bottom: 40px;
            font-size: 2.8em;
            letter-spacing: 1px;
            text-transform: uppercase;
            position: relative;
            padding-bottom: 15px;
        }

        h1::after {
            content: '';
            position: absolute;
            left: 50%;
            bottom: 0;
            transform: translateX(-50%);
            height: 3px;
            width: 80px;
            background-color: #28a745; /* Green accent */
            border-radius: 5px;
        }

        h2 {
            color: #343a40;
            margin-top: 35px;
            margin-bottom: 25px;
            font-size: 2em;
            padding-left: 15px;
            border-left: 5px solid #17a2b8; /* Info blue accent */
            font-weight: 600;
        }

        /* Total Revenue Section */
        .total-revenue-card {
            background: linear-gradient(45deg, #28a745, #218838); /* Green gradient */
            color: white;
            padding: 30px;
            border-radius: 12px;
            text-align: center;
            margin-bottom: 30px;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .total-revenue-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 30px rgba(0, 0, 0, 0.2);
        }

        .total-revenue-card p {
            font-size: 1.2em;
            margin-bottom: 10px;
            opacity: 0.9;
        }

        .total-revenue-card strong {
            font-size: 3.5em;
            font-weight: 700;
            display: block;
            margin-top: 10px;
            letter-spacing: 1px;
        }

        /* Form styling */
        .form-control-container {
            display: flex;
            gap: 15px;
            margin-bottom: 25px;
            align-items: center;
            flex-wrap: wrap; /* Allow wrapping on smaller screens */
        }

        .form-control-container label {
            font-weight: 600;
            color: #495057;
        }

        .form-control {
            border-radius: 0.5rem;
            padding: 0.75rem 1rem;
            border: 1px solid #ced4da;
            flex-grow: 1; /* Allow inputs to grow */
            max-width: 300px; /* Limit max width for inputs */
        }

        .btn-primary, .btn-info {
            border-radius: 0.5rem;
            padding: 0.75rem 1.5rem;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .btn-primary {
            background-color: #007bff;
            border-color: #007bff;
        }

        .btn-primary:hover {
            background-color: #0056b3;
            border-color: #0056b3;
            transform: translateY(-2px);
        }

        .btn-info {
            background-color: #17a2b8;
            border-color: #17a2b8;
        }

        .btn-info:hover {
            background-color: #138496;
            border-color: #138496;
            transform: translateY(-2px);
        }

        /* Table styling */
        .table-responsive {
            margin-bottom: 30px;
        }

        .table {
            border-collapse: separate;
            border-spacing: 0;
            background-color: #ffffff;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
        }

        .table th, .table td {
            padding: 15px 20px;
            text-align: left;
            border-bottom: 1px solid #e9ecef; /* Lighter border */
        }

        .table thead th {
            background-color: #343a40; /* Darker header */
            color: white;
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.9em;
            letter-spacing: 0.5px;
        }

        .table tbody tr:nth-child(even) {
            background-color: #f8f9fa; /* Lighter stripe */
        }

        .table tbody tr:hover {
            background-color: #e2f2ff; /* Light blue on hover */
            transition: background-color 0.2s ease;
        }

        .table .text-right {
            text-align: right;
            font-weight: 500;
            color: #0056b3;
        }
        
        /* No data message */
        .no-data-message {
            text-align: center;
            color: #6c757d;
            padding: 20px;
            font-style: italic;
        }

        /* Chart styling */
        .chart-container {
            position: relative;
            /* Thay đổi chiều cao để phù hợp với 3 biểu đồ trên 1 hàng */
            height: 300px; /* Chiều cao cố định cho mỗi biểu đồ nhỏ */
            width: 100%; /* Đảm bảo canvas lấp đầy cột Bootstrap */
        }
        /* Đảm bảo canvas responsive bên trong chart-container */
        .chart-container canvas {
            display: block; /* Loại bỏ khoảng trắng dưới canvas */
            max-width: 100%;
            height: 100%;
        }

        /* Responsive adjustments for tables */
        @media (max-width: 768px) {
            .container-fluid {
                padding: 15px;
            }
            h1 {
                font-size: 2.2em;
            }
            h2 {
                font-size: 1.7em;
            }
            .total-revenue-card strong {
                font-size: 3em;
            }
            .form-control-container {
                flex-direction: column;
                align-items: stretch;
            }
            .form-control-container .form-control,
            .form-control-container .btn {
                width: 100%;
                max-width: none;
            }

            .table thead {
                display: none; /* Hide table headers on small screens */
            }

            .table, .table tbody, .table tr, .table td {
                display: block;
                width: 100%;
            }

            .table tr {
                margin-bottom: 15px;
                border: 1px solid #dee2e6;
                border-radius: 8px;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
            }

            .table td {
                text-align: right;
                padding-left: 50%; /* Space for the data-label */
                position: relative;
                border: none;
                border-bottom: 1px solid #e9ecef;
            }

            .table td:last-child {
                border-bottom: none;
            }

            .table td::before {
                content: attr(data-label);
                position: absolute;
                left: 15px;
                width: calc(50% - 30px);
                text-align: left;
                font-weight: 700;
                color: #495057;
            }
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
</head>
<body>
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
                <a href="${pageContext.request.contextPath}/revenue-chart" class="nav-link active">
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
    <main class="main-content">
        <div class="container-fluid">
            <h1>BÁO CÁO DOANH THU</h1>

            <div class="card bg-success text-white total-revenue-card">
                <div class="card-body">
                    <p class="card-title">Tổng doanh thu từ tất cả các hoạt động:</p>
                    <%
                        Double totalRevenue = (Double) request.getAttribute("totalRevenue");
                        if (totalRevenue == null) totalRevenue = 0.0;
                    %>
                    <strong><%= String.format("%,.0f", totalRevenue) %> VNĐ</strong>
                </div>
            </div>

            <%-- Sử dụng hàng (row) và cột (col) của Bootstrap để đặt 3 biểu đồ trên một hàng --%>
            <div class="row mb-4"> <%-- Thêm mb-4 để tạo khoảng cách dưới hàng biểu đồ --%>
                <div class="col-md-4"> <%-- col-md-4 sẽ chiếm 1/3 chiều rộng trên màn hình trung bình trở lên --%>
                    <div class="card h-100"> <%-- h-100 để các card có chiều cao bằng nhau --%>
                        <div class="card-header text-center">Doanh thu theo tháng</div>
                        <div class="card-body d-flex justify-content-center align-items-center"> <%-- Căn giữa nội dung --%>
                            <div class="chart-container">
                                <canvas id="revenueByMonthChart"></canvas>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="card h-100">
                        <div class="card-header text-center">Doanh thu theo sản phẩm</div>
                        <div class="card-body d-flex justify-content-center align-items-center">
                            <div class="chart-container">
                                <canvas id="revenueByProductChart"></canvas>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="card h-100">
                        <div class="card-header text-center">Doanh thu theo khách hàng</div>
                        <div class="card-body d-flex justify-content-center align-items-center">
                            <div class="chart-container">
                                <canvas id="revenueByCustomerChart"></canvas>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <%-- Hàng mới cho biểu đồ tỉ lệ thành công, hủy đơn --%>
            <div class="row mb-4">
                <div class="col-md-6 offset-md-3"> <%-- Căn giữa biểu đồ với offset --%>
                    <div class="card h-100">
                        <div class="card-header text-center">Tỉ lệ đơn hàng: Thành công và Hủy</div>
                        <div class="card-body d-flex justify-content-center align-items-center">
                            <div class="chart-container" style="height: 400px; width: 100%;"> <%-- Tăng chiều cao cho biểu đồ tròn --%>
                                <canvas id="orderStatusPieChart"></canvas>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <%-- Bắt đầu các bảng báo cáo --%>
            <div class="card">
                <div class="card-header">Doanh thu theo tháng</div>
                <div class="card-body">
                    <%
                        List<RevenueByMonth> monthList = (List<RevenueByMonth>) request.getAttribute("revenueList");
                    %>
                    <form method="get" action="revenue-chart" class="form-control-container">
                        <label for="selectedMonth" class="form-label mb-0">Chọn tháng:</label>
                        <select id="selectedMonth" name="selectedMonth" class="form-select">
                            <option value="0">Tất cả</option>
                            <% for (int i = 1; i <= 12; i++) { %>
                                <option value="<%= i %>" <%= request.getParameter("selectedMonth") != null && request.getParameter("selectedMonth").equals(String.valueOf(i)) ? "selected" : "" %>>
                                    Tháng <%= i %>
                                </option>
                            <% } %>
                        </select>
                        <button type="submit" class="btn btn-primary">Lọc</button>
                    </form>
                    <div class="table-responsive">
                        <table class="table table-striped table-hover">
                            <thead>
                                <tr>
                                    <th>Tháng</th>
                                    <th class="text-right">Doanh thu (VNĐ)</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (monthList != null && !monthList.isEmpty()) { %>
                                    <% for (RevenueByMonth r : monthList) { %>
                                    <tr>
                                        <td data-label="Tháng">Tháng <%= r.getMonth() %></td>
                                        <td data-label="Doanh thu (VNĐ)" class="text-right"><%= String.format("%,.0f", r.getRevenue()) %></td>
                                    </tr>
                                    <% } %>
                                <% } else { %>
                                    <tr>
                                        <td colspan="2" class="no-data-message">Không có dữ liệu doanh thu theo tháng.</td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <div class="card">
                <div class="card-header">Doanh thu theo sản phẩm</div>
                <div class="card-body">
                    <%
                        List<RevenueByProduct> productList = (List<RevenueByProduct>) request.getAttribute("productRevenueList");
                    %>
                    <form method="get" action="revenue-chart" class="form-control-container">
                        <label for="productSearch" class="form-label mb-0">Tên sản phẩm:</label>
                        <input type="text" id="productSearch" name="productSearch" class="form-control" placeholder="Nhập tên sản phẩm" value="<%= request.getParameter("productSearch") != null ? request.getParameter("productSearch") : "" %>">
                        <button type="submit" class="btn btn-primary">Tìm kiếm</button>
                    </form>
                    <div class="table-responsive">
                        <table class="table table-striped table-hover">
                            <thead>
                                <tr>
                                    <th>Tên sản phẩm</th>
                                    <th>Số lượng đã bán</th>
                                    <th class="text-right">Doanh thu (VNĐ)</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (productList != null && !productList.isEmpty()) { %>
                                    <% for (RevenueByProduct p : productList) { %>
                                    <tr>
                                        <td data-label="Tên sản phẩm"><%= p.getTitle() %></td>
                                        <td data-label="Số lượng đã bán"><%= p.getTotalSold() %></td>
                                        <td data-label="Doanh thu (VNĐ)" class="text-right"><%= String.format("%,.0f", p.getTotalRevenue()) %></td>
                                    </tr>
                                    <% } %>
                                <% } else { %>
                                    <tr>
                                        <td colspan="3" class="no-data-message">Không có dữ liệu doanh thu theo sản phẩm.</td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <div class="card">
                <div class="card-header">Doanh thu theo khách hàng</div>
                <div class="card-body">
                    <%
                        List<RevenueByCustomer> customerList = (List<RevenueByCustomer>) request.getAttribute("customerRevenueList");
                    %>
                    <form method="get" action="revenue-chart" class="form-control-container">
                        <label for="userSearch" class="form-label mb-0">Tên người dùng:</label>
                        <input type="text" id="userSearch" name="userSearch" class="form-control" placeholder="Nhập tên người dùng" value="<%= request.getParameter("userSearch") != null ? request.getParameter("userSearch") : "" %>">
                        <button type="submit" class="btn btn-primary">Tìm kiếm</button>
                    </form>
                    <div class="table-responsive">
                        <table class="table table-striped table-hover">
                            <thead>
                                <tr>
                                    <th>Tên đăng nhập</th>
                                    <th>Họ tên</th>
                                    <th class="text-right">Tổng chi tiêu (VNĐ)</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (customerList != null && !customerList.isEmpty()) { %>
                                    <% for (RevenueByCustomer c : customerList) { %>
                                    <tr>
                                        <td data-label="Tên đăng nhập"><%= c.getUsername() %></td>
                                        <td data-label="Họ tên"><%= c.getFullName() %></td>
                                        <td data-label="Tổng chi tiêu (VNĐ)" class="text-right"><%= String.format("%,.0f", c.getTotalSpent()) %></td>
                                    </tr>
                                    <% } %>
                                <% } else { %>
                                    <tr>
                                        <td colspan="3" class="no-data-message">Không có dữ liệu doanh thu theo khách hàng.</td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <div class="card">
                <div class="card-header">Thống kê đơn hàng theo trạng thái</div>
                <div class="card-body">
                    <%
                        Map<String, Integer> statusMap = (Map<String, Integer>) request.getAttribute("orderStatusSummary");
                    %>
                    <form method="get" action="revenue-chart" class="form-control-container">
                        <label for="statusSearch" class="form-label mb-0">Chọn trạng thái:</label>
                        <select name="statusSearch" id="statusSearch" class="form-select">
                            <option value="">Tất cả</option>
                            <%
                                if (statusMap != null && !statusMap.isEmpty()) {
                                    for (Map.Entry<String, Integer> entry : statusMap.entrySet()) {
                            %>
                            <option value="<%= entry.getKey() %>" <%= request.getParameter("statusSearch") != null && request.getParameter("statusSearch").equals(entry.getKey()) ? "selected" : "" %>>
                                <%= entry.getKey() %>
                            </option>
                            <%
                                    }
                                }
                            %>
                        </select>
                        <button type="submit" class="btn btn-primary">Tìm kiếm</button>
                    </form>
                    <div class="table-responsive">
                        <table class="table table-striped table-hover">
                            <thead>
                                <tr>
                                    <th>Trạng thái</th>
                                    <th class="text-right">Số đơn hàng</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (statusMap != null && !statusMap.isEmpty()) { %>
                                    <% for (Map.Entry<String, Integer> entry : statusMap.entrySet()) { %>
                                    <tr>
                                        <td data-label="Trạng thái"><%= entry.getKey() %></td>
                                        <td data-label="Số đơn hàng" class="text-right"><%= entry.getValue() %></td>
                                    </tr>
                                    <% } %>
                                <% } else { %>
                                    <tr>
                                        <td colspan="2" class="no-data-message">Không có dữ liệu thống kê trạng thái đơn hàng.</td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </main>
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
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Lấy dữ liệu từ JSP sang JavaScript
        const monthList = [
            <% if (monthList != null) { %>
                <% for (int i = 0; i < monthList.size(); i++) { %>
                    { month: <%= monthList.get(i).getMonth() %>, revenue: <%= monthList.get(i).getRevenue() %> }<%= (i < monthList.size() - 1) ? "," : "" %>
                <% } %>
            <% } %>
        ];

        const productList = [
            <% if (productList != null) { %>
                <% for (int i = 0; i < productList.size(); i++) { %>
                    { title: '<%= productList.get(i).getTitle().replace("'", "\\'") %>', totalSold: <%= productList.get(i).getTotalSold() %>, totalRevenue: <%= productList.get(i).getTotalRevenue() %> }<%= (i < productList.size() - 1) ? "," : "" %>
                <% } %>
            <% } %>
        ];

        const customerList = [
            <% if (customerList != null) { %>
                <% for (int i = 0; i < customerList.size(); i++) { %>
                    { username: '<%= customerList.get(i).getUsername().replace("'", "\\'") %>', fullName: '<%= customerList.get(i).getFullName() != null ? customerList.get(i).getFullName().replace("'", "\\'") : "" %>', totalSpent: <%= customerList.get(i).getTotalSpent() %> }<%= (i < customerList.size() - 1) ? "," : "" %>
                <% } %>
            <% } %>
        ];

        const orderStatusSummary = {
            <% if (statusMap != null) { %>
                <%
                    int entryCount = 0;
                    for (Map.Entry<String, Integer> entry : statusMap.entrySet()) {
                        if (entryCount > 0) {
                            out.print(",");
                        }
                        out.print("'" + entry.getKey().replace("'", "\\'") + "': " + entry.getValue());
                        entryCount++;
                    }
                %>
            <% } %>
        };

        // Hàm vẽ biểu đồ
        function createChart(chartId, type, labels, data, labelText, backgroundColor, borderColor, options = {}) {
            const ctx = document.getElementById(chartId);
            if (!ctx) { // Kiểm tra xem canvas có tồn tại không
                console.warn(`Canvas element with ID '${chartId}' not found.`);
                return;
            }
            const context = ctx.getContext('2d');
            new Chart(context, {
                type: type,
                data: {
                    labels: labels,
                    datasets: [{
                        label: labelText,
                        data: data,
                        backgroundColor: backgroundColor,
                        borderColor: borderColor || backgroundColor.map(color => color.replace('0.2', '1')), // Màu border đậm hơn
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false, // Quan trọng để điều chỉnh kích thước tùy ý
                    scales: {
                        y: {
                            beginAtZero: true,
                            title: {
                                display: true,
                                text: 'Doanh thu (VNĐ)'
                            },
                            ticks: {
                                callback: function(value, index, values) {
                                    return value.toLocaleString('vi-VN') + ' VNĐ'; // Định dạng tiền tệ
                                }
                            }
                        },
                        x: {
                            title: {
                                display: true,
                                text: (chartId === 'revenueByMonthChart' ? 'Tháng' : (chartId === 'revenueByProductChart' ? 'Tên sản phẩm' : 'Khách hàng'))
                            },
                            // Điều chỉnh số lượng nhãn hiển thị trên trục X nếu có quá nhiều
                            ticks: {
                                autoSkip: true,
                                maxRotation: 45,
                                minRotation: 45
                            }
                        }
                    },
                    plugins: {
                        legend: {
                            display: false // Ẩn legend nếu bạn thấy nó chiếm quá nhiều không gian với biểu đồ nhỏ
                        },
                        tooltip: {
                            callbacks: {
                                label: function(context) {
                                    let label = context.dataset.label || '';
                                    if (label) {
                                        label += ': ';
                                    }
                                    if (context.parsed.y !== null) {
                                        label += context.parsed.y.toLocaleString('vi-VN') + ' VNĐ';
                                    }
                                    return label;
                                }
                            }
                        }
                    },
                    ...options // Merge options tùy chỉnh
                }
            });
        }

        // Hàm vẽ biểu đồ tròn (Pie/Doughnut)
        function createPieChart(chartId, labels, data, backgroundColor, labelText) {
            const ctx = document.getElementById(chartId);
            if (!ctx) {
                console.warn(`Canvas element with ID '${chartId}' not found.`);
                return;
            }
            const context = ctx.getContext('2d');
            new Chart(context, {
                type: 'pie',
                data: {
                    labels: labels,
                    datasets: [{
                        label: labelText,
                        data: data,
                        backgroundColor: backgroundColor,
                        hoverOffset: 4
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'top',
                        },
                        tooltip: {
                            callbacks: {
                                label: function(context) {
                                    let label = context.label || '';
                                    if (label) {
                                        label += ': ';
                                    }
                                    if (context.parsed !== null) {
                                        label += context.parsed;
                                    }
                                    return label;
                                }
                            }
                        }
                    }
                }
            });
        }

        // Tạo biểu đồ Doanh thu theo tháng
        if (monthList.length > 0) {
            const monthLabels = monthList.map(item => `Tháng ${item.month}`);
            const monthData = monthList.map(item => item.revenue);
            const monthColors = monthList.map(() => 'rgba(75, 192, 192, 0.6)'); // Màu xanh lá cây
            createChart('revenueByMonthChart', 'bar', monthLabels, monthData, 'Doanh thu theo tháng', monthColors);
        } else {
            const chartContainer = document.getElementById('revenueByMonthChart')?.parentElement;
            if (chartContainer) {
                chartContainer.innerHTML = '<p class="no-data-message">Không có dữ liệu.</p>';
            }
        }

        // Tạo biểu đồ Doanh thu theo sản phẩm (chỉ lấy top 5-7 sản phẩm để biểu đồ dễ nhìn hơn với không gian nhỏ)
        if (productList.length > 0) {
            const sortedProducts = [...productList].sort((a, b) => b.totalRevenue - a.totalRevenue).slice(0, 7); // Giảm xuống top 7
            const productLabels = sortedProducts.map(item => item.title);
            const productData = sortedProducts.map(item => item.totalRevenue);
            const productColors = sortedProducts.map(() => 'rgba(153, 102, 255, 0.6)'); // Màu tím
            createChart('revenueByProductChart', 'bar', productLabels, productData, 'Doanh thu theo sản phẩm', productColors);
        } else {
            const chartContainer = document.getElementById('revenueByProductChart')?.parentElement;
            if (chartContainer) {
                chartContainer.innerHTML = '<p class="no-data-message">Không có dữ liệu.</p>';
            }
        }

        // Tạo biểu đồ Doanh thu theo khách hàng (chỉ lấy top 5-7 khách hàng)
        if (customerList.length > 0) {
            const sortedCustomers = [...customerList].sort((a, b) => b.totalSpent - a.totalSpent).slice(0, 7); // Giảm xuống top 7
            const customerLabels = sortedCustomers.map(item => item.fullName || item.username);
            const customerData = sortedCustomers.map(item => item.totalSpent);
            const customerColors = sortedCustomers.map(() => 'rgba(255, 159, 64, 0.6)'); // Màu cam
            createChart('revenueByCustomerChart', 'bar', customerLabels, customerData, 'Tổng chi tiêu theo khách hàng', customerColors);
        } else {
            const chartContainer = document.getElementById('revenueByCustomerChart')?.parentElement;
            if (chartContainer) {
                chartContainer.innerHTML = '<p class="no-data-message">Không có dữ liệu.</p>';
            }
        }

        // Tạo biểu đồ Tỉ lệ thành công, hủy đơn
        if (Object.keys(orderStatusSummary).length > 0) {
            const statusLabels = Object.keys(orderStatusSummary);
            const statusData = Object.values(orderStatusSummary);
            const statusColors = [];
            
            // Định nghĩa màu sắc cho các trạng thái cụ thể
            statusLabels.forEach(label => {
                if (label.toLowerCase().includes('thành công')) {
                    statusColors.push('rgba(40, 167, 69, 0.7)'); // Xanh lá cây cho thành công
                } else if (label.toLowerCase().includes('hủy')) {
                    statusColors.push('rgba(220, 53, 69, 0.7)'); // Đỏ cho hủy
                } else if (label.toLowerCase().includes('đang xử lý')) {
                    statusColors.push('rgba(255, 193, 7, 0.7)'); // Vàng cho đang xử lý
                } else {
                    statusColors.push('rgba(23, 162, 184, 0.7)'); // Màu khác cho các trạng thái còn lại
                }
            });
            createPieChart('orderStatusPieChart', statusLabels, statusData, statusColors, 'Số đơn hàng');
        } else {
            const chartContainer = document.getElementById('orderStatusPieChart')?.parentElement;
            if (chartContainer) {
                chartContainer.innerHTML = '<p class="no-data-message">Không có dữ liệu.</p>';
            }
        }

        // jQuery cho modal đăng xuất
        $(document).ready(function() {
            $('.logout-btn').on('click', function(e) {
                e.preventDefault();
                $('#logoutModal').modal('show');
            });
            $('.user-dropdown').on('click', function(e) {
                e.preventDefault();
            });
        });
    </script>
</body>
</html>