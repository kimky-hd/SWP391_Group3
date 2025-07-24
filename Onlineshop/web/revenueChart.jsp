<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Báo Cáo Doanh Thu</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <!-- Custom CSS -->
        <link href="<c:url value='/css/admin.css'/>" rel="stylesheet">
        <link href="css/style.css" rel="stylesheet">
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #f5f5f5;
            }
            .main-content {
                padding: 20px;
            }
            .card {
                border: none;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                margin-bottom: 25px;
            }
            .card-header {
                background-color: #4e73df;
                color: white;
                padding: 15px;
                border-radius: 8px 8px 0 0 !important;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }
            .chart-container {
                height: 250px;
                padding: 15px;
            }
            .filter-box {
                background: white;
                padding: 10px;
                border-radius: 5px;
                margin-bottom: 15px;
                display: flex;
                gap: 10px;
            }
            .total-card {
                background: linear-gradient(135deg, #4e73df 0%, #224abe 100%);
                color: white;
                padding: 20px;
                border-radius: 8px;
                margin-bottom: 20px;
            }
        </style>
    </head>
    <body>
        <jsp:include page="manager_topbarsidebar.jsp" />

        <div class="main-content">
            <!-- Header -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2><i class="fas fa-chart-line me-2"></i>Báo Cáo Doanh Thu</h2>
            </div>

            <!-- Tổng doanh thu -->
            <div class="total-card">
                <div class="row">
                    <div class="col-md-8">
                        <h5>Tổng Doanh Thu</h5>
                        <h2><fmt:formatNumber value="${totalRevenue}" pattern="#,##0"/> VND</h2>
                    </div>
                    <div class="col-md-4 text-end">
                        <i class="fas fa-wallet fa-4x opacity-50"></i>
                    </div>
                </div>
            </div>

            <!-- Doanh thu theo tháng -->
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0"><i class="fas fa-calendar-alt me-2"></i>Doanh Thu Theo Tháng</h5>
                </div>
                <div class="card-body">
                    <div class="chart-container">
                        <canvas id="monthlyChart"></canvas>
                    </div>
                    
                    <form method="GET" action="revenue-chart" class="filter-box">
                        <select name="selectedMonth" class="form-select" style="width: 200px;">
                            <option value="">Tất cả tháng</option>
                            <c:forEach begin="1" end="12" var="month">
                                <option value="${month}" ${param.selectedMonth eq month ? 'selected' : ''}>Tháng ${month}</option>
                            </c:forEach>
                        </select>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-filter me-1"></i> Lọc
                        </button>
                        <a href="revenue-chart" class="btn btn-outline-secondary">
                            <i class="fas fa-redo me-1"></i> Reset
                        </a>
                    </form>
                    
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>Tháng</th>
                                    <th class="text-end">Doanh thu</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="item" items="${revenueList}">
                                    <tr>
                                        <td>Tháng ${item.month}</td>
                                        <td class="text-end"><fmt:formatNumber value="${item.revenue}" pattern="#,##0"/> VND</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Trạng thái đơn hàng -->
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0"><i class="fas fa-clipboard-list me-2"></i>Trạng Thái Đơn Hàng</h5>
                </div>
                <div class="card-body">
                    <div class="chart-container">
                        <canvas id="statusChart"></canvas>
                    </div>
                    
                    <form method="GET" action="revenue-chart" class="filter-box">
                        <select name="statusSearch" class="form-select" style="width: 200px;">
                            <option value="">Tất cả trạng thái</option>
                            <c:forEach var="status" items="${statusMap.keySet()}">
                                <option value="${status}" ${param.statusSearch eq status ? 'selected' : ''}>${status}</option>
                            </c:forEach>
                        </select>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-filter me-1"></i> Lọc
                        </button>
                        <a href="revenue-chart" class="btn btn-outline-secondary">
                            <i class="fas fa-redo me-1"></i> Reset
                        </a>
                    </form>
                    
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>Trạng thái</th>
                                    <th class="text-end">Số lượng</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="entry" items="${orderStatusSummary}">
                                    <tr>
                                        <td>${entry.key}</td>
                                        <td class="text-end">${entry.value}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Doanh thu theo sản phẩm -->
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0"><i class="fas fa-boxes me-2"></i>Doanh Thu Theo Sản Phẩm</h5>
                </div>
                <div class="card-body">
                    <form method="GET" action="revenue-chart" class="filter-box">
                        <input type="text" name="productSearch" class="form-control" placeholder="Tìm sản phẩm..." value="${param.productSearch}">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-search me-1"></i> Tìm kiếm
                        </button>
                        <a href="revenue-chart" class="btn btn-outline-secondary">
                            <i class="fas fa-redo me-1"></i> Reset
                        </a>
                    </form>
                    
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>Sản phẩm</th>
                                    <th class="text-end">Số lượng</th>
                                    <th class="text-end">Doanh thu</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="item" items="${productRevenueList}">
                                    <tr>
                                        <td>${item.title}</td>
                                        <td class="text-end">${item.totalSold}</td>
                                        <td class="text-end"><fmt:formatNumber value="${item.totalRevenue}" pattern="#,##0"/> VND</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Doanh thu theo khách hàng -->
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0"><i class="fas fa-users me-2"></i>Doanh Thu Theo Khách Hàng</h5>
                </div>
                <div class="card-body">
                    <form method="GET" action="revenue-chart" class="filter-box">
                        <input type="text" name="userSearch" class="form-control" placeholder="Tìm khách hàng..." value="${param.userSearch}">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-search me-1"></i> Tìm kiếm
                        </button>
                        <a href="revenue-chart" class="btn btn-outline-secondary">
                            <i class="fas fa-redo me-1"></i> Reset
                        </a>
                    </form>
                    
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>Khách hàng</th>
                                    <th class="text-end">Tổng chi tiêu</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="item" items="${customerRevenueList}">
                                    <tr>
                                        <td>${item.fullName} (${item.username})</td>
                                        <td class="text-end"><fmt:formatNumber value="${item.totalSpent}" pattern="#,##0"/> VND</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            // Biểu đồ doanh thu theo tháng
            new Chart(
                document.getElementById('monthlyChart').getContext('2d'),
                {
                    type: 'bar',
                    data: {
                        labels: [
                            <c:forEach var="item" items="${revenueList}">
                                'Tháng ${item.month}',
                            </c:forEach>
                        ],
                        datasets: [{
                            label: 'Doanh thu',
                            data: [
                                <c:forEach var="item" items="${revenueList}">
                                    ${item.revenue},
                                </c:forEach>
                            ],
                            backgroundColor: '#4e73df'
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false
                    }
                }
            );

            // Biểu đồ trạng thái đơn hàng
            new Chart(
                document.getElementById('statusChart').getContext('2d'),
                {
                    type: 'doughnut',
                    data: {
                        labels: [
                            <c:forEach var="entry" items="${orderStatusSummary}">
                                '${entry.key}',
                            </c:forEach>
                        ],
                        datasets: [{
                            data: [
                                <c:forEach var="entry" items="${orderStatusSummary}">
                                    ${entry.value},
                                </c:forEach>
                            ],
                            backgroundColor: [
                                '#4e73df', '#1cc88a', '#36b9cc', '#f6c23e'
                            ]
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false
                    }
                }
            );
        </script>
    </body>
</html>