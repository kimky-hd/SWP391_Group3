<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Báo Cáo Doanh Thu Chi Tiết</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    
    <!-- Custom CSS -->
    <link href="css/revenue-chart.css" rel="stylesheet">
    <link href="css/admin.css" rel="stylesheet">
    
    <!-- Inline CSS to ensure header visibility -->
    <style>
        body {
            -webkit-font-smoothing: antialiased !important;
            -moz-osx-font-smoothing: grayscale !important;
            text-rendering: optimizeLegibility !important;
        }
        
        .page-header {
            background: linear-gradient(135deg, #e8f4fd 0%, #f0f8ff 50%, #f5f5f5 100%) !important;
            color: #333 !important;
            padding: 35px !important;
            border-radius: 12px !important;
            margin-bottom: 30px !important;
            box-shadow: 0 6px 20px rgba(0,0,0,0.15) !important;
            position: relative !important;
            z-index: 1 !important;
            border: 2px solid rgba(0,0,0,0.1) !important;
        }
        
        .page-header h1 {
            margin: 0 !important;
            font-size: 2.8rem !important;
            font-weight: 700 !important;
            color: #2c3e50 !important;
            text-shadow: none !important;
            display: flex !important;
            align-items: center !important;
            letter-spacing: 0.5px !important;
            text-rendering: optimizeLegibility !important;
            -webkit-font-smoothing: antialiased !important;
        }
        
        .page-header h1 i {
            color: #3498db !important;
            margin-right: 15px !important;
            font-size: 2.5rem !important;
            text-shadow: none !important;
        }
        
        .page-header .subtitle {
            opacity: 1 !important;
            font-size: 1.2rem !important;
            margin-top: 12px !important;
            color: #555 !important;
            font-weight: 500 !important;
            text-shadow: none !important;
            letter-spacing: 0.3px !important;
            line-height: 1.4 !important;
        }
        
        .main-content {
            padding: 20px !important;
            margin-left: 250px !important;
            min-height: 100vh !important;
            background-color: #f8f9fa !important;
            position: relative !important;
        }
        
        /* Improve text rendering globally */
        * {
            -webkit-font-smoothing: antialiased;
            -moz-osx-font-smoothing: grayscale;
            text-rendering: optimizeLegibility;
        }
    </style>
</head>
<body>
    <!-- Include sidebar -->
    <jsp:include page="manager_topbarsidebar.jsp" />

    <div class="main-content">
        <!-- Page Header -->
        <div class="page-header">
            <h1><i class="fas fa-chart-line me-3"></i>Báo Cáo Doanh Thu Chi Tiết</h1>
            <p class="subtitle">Phân tích toàn diện về doanh thu, chi phí và hiệu quả kinh doanh</p>
        </div>

      

        <!-- Summary Cards -->
        <div class="summary-cards">
            <div class="summary-card revenue">
                <i class="fas fa-dollar-sign"></i>
                <h3><fmt:formatNumber value="${totalRevenue}" pattern="#,##0"/></h3>
                <p>Tổng Doanh Thu (VND)</p>
            </div>
            
            <div class="summary-card import">
                <i class="fas fa-truck"></i>
                <h3>
                    <c:choose>
                        <c:when test="${totalImportCost != null}">
                            <fmt:formatNumber value="${totalImportCost}" pattern="#,##0"/>
                        </c:when>
                        <c:otherwise>0</c:otherwise>
                    </c:choose>
                </h3>
                <p>Chi Phí Nhập Hàng (VND)</p>
            </div>
            
            <div class="summary-card damaged">
                <i class="fas fa-exclamation-triangle"></i>
                <h3>
                    <c:choose>
                        <c:when test="${totalDamagedCost != null}">
                            <fmt:formatNumber value="${totalDamagedCost}" pattern="#,##0"/>
                        </c:when>
                        <c:otherwise>0</c:otherwise>
                    </c:choose>
                </h3>
                <p>Thiệt Hại Hoa Hết Hạn (VND)</p>
            </div>
        </div>

      
        
        

      
        <!-- Filter Section -->
        <div class="filter-section">
            <h5><i class="fas fa-filter me-2"></i>Bộ Lọc Dữ Liệu</h5>
            <form method="GET" action="revenue-chart">
                <div class="filter-row">
                    <div class="filter-group">
                        <label>Tháng:</label>
                        <select name="selectedMonth" class="form-select">
                            <option value="">Tất cả tháng</option>
                            <c:forEach begin="1" end="12" var="month">
                                <option value="${month}" ${param.selectedMonth eq month ? 'selected' : ''}>
                                    Tháng ${month}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    
                    <div class="filter-group">
                        <label>Tìm sản phẩm:</label>
                        <input type="text" name="productSearch" class="form-control" 
                               placeholder="Nhập tên sản phẩm..." value="${param.productSearch}">
                    </div>
                    
                    <div class="filter-group">
                        <label>Tìm khách hàng:</label>
                        <input type="text" name="userSearch" class="form-control" 
                               placeholder="Nhập tên khách hàng..." value="${param.userSearch}">
                    </div>
                    
                    <div class="filter-group">
                        <label>Trạng thái đơn hàng:</label>
                        <select name="statusSearch" class="form-select">
                            <option value="">Tất cả trạng thái</option>
                            <c:forEach var="status" items="${statusMap}">
                                <option value="${status.key}" ${param.statusSearch eq status.key ? 'selected' : ''}>
                                    ${status.key}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    
                    <div class="filter-group">
                        <button type="submit" class="btn-filter">
                            <i class="fas fa-search me-2"></i>Lọc
                        </button>
                    </div>
                </div>
            </form>
        </div>

        <!-- Charts Grid -->
        <div class="chart-grid">
            <!-- 1. Doanh thu theo tháng -->
            <div class="chart-card">
                <div class="chart-card-header">
                    <h5><i class="fas fa-calendar-alt me-2"></i>Doanh Thu Theo Tháng</h5>
                    <i class="fas fa-chart-bar"></i>
                </div>
                <div class="chart-card-body">
                    <div class="chart-container">
                        <canvas id="monthlyChart"></canvas>
                    </div>
                </div>
            </div>

            <!-- 2. Trạng thái đơn hàng -->
            <div class="chart-card">
                <div class="chart-card-header">
                    <h5><i class="fas fa-tasks me-2"></i>Trạng Thái Đơn Hàng</h5>
                    <i class="fas fa-chart-pie"></i>
                </div>
                <div class="chart-card-body">
                    <div class="chart-container">
                        <canvas id="statusChart"></canvas>
                    </div>
                </div>
            </div>

            <!-- 3. Doanh thu theo sản phẩm -->
            <div class="chart-card">
                <div class="chart-card-header">
                    <h5><i class="fas fa-shopping-bag me-2"></i>Doanh Thu Theo Sản Phẩm</h5>
                    <i class="fas fa-chart-column"></i>
                </div>
                <div class="chart-card-body">
                    <div class="chart-container">
                        <canvas id="productChart"></canvas>
                    </div>
                    <!-- Data table for products -->
                    <div class="mt-3">
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <h6>Chi tiết sản phẩm:</h6>
                            <input type="text" id="productSearch" class="form-control" style="max-width: 200px;" 
                                   placeholder="Tìm sản phẩm..." onkeyup="filterTable('productTable', this.value)">
                        </div>
                        <div class="table-responsive">
                            <table class="table data-table" id="productTable">
                                <thead>
                                    <tr>
                                        <th>STT</th>
                                        <th>Sản phẩm</th>
                                        <th>Số lượng bán</th>
                                        <th>Doanh thu</th>
                                        <th>Tỷ lệ đóng góp</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="product" items="${productRevenueList}" varStatus="status">
                                        <tr>
                                            <td>${status.index + 1}</td>
                                            <td>
                                                <div class="text-truncate" style="max-width: 200px;" title="${product.title}">
                                                    ${product.title}
                                                </div>
                                            </td>
                                            <td>
                                                <span class="badge bg-info">${product.totalSold}</span>
                                            </td>
                                            <td>
                                                <strong><fmt:formatNumber value="${product.totalRevenue}" pattern="#,##0"/> VND</strong>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${totalRevenue > 0}">
                                                        <span class="badge bg-success">
                                                            <fmt:formatNumber value="${(product.totalRevenue / totalRevenue) * 100}" pattern="#0.0"/>%
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>0%</c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 4. Top khách hàng -->
            <div class="chart-card">
                <div class="chart-card-header">
                    <h5><i class="fas fa-users me-2"></i>Top Khách Hàng</h5>
                    <i class="fas fa-chart-bar"></i>
                </div>
                <div class="chart-card-body">
                    <div class="chart-container">
                        <canvas id="customerChart"></canvas>
                    </div>
                    <!-- Data table for customers -->
                    <div class="mt-3">
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <h6>Chi tiết khách hàng:</h6>
                            <input type="text" id="customerSearch" class="form-control" style="max-width: 200px;" 
                                   placeholder="Tìm khách hàng..." onkeyup="filterTable('customerTable', this.value)">
                        </div>
                        <div class="table-responsive">
                            <table class="table data-table" id="customerTable">
                                <thead>
                                    <tr>
                                        <th>STT</th>
                                        <th>Tên khách hàng</th>
                                        <th>Username</th>
                                        <th>Tổng chi tiêu</th>
                                        <th>Xếp hạng</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="customer" items="${customerRevenueList}" varStatus="status">
                                        <tr>
                                            <td>${status.index + 1}</td>
                                            <td>
                                                <div class="d-flex align-items-center">
                                                    <i class="fas fa-user-circle me-2 text-primary"></i>
                                                    ${customer.fullName}
                                                </div>
                                            </td>
                                            <td>
                                                <code>${customer.username}</code>
                                            </td>
                                            <td>
                                                <strong><fmt:formatNumber value="${customer.totalSpent}" pattern="#,##0"/> VND</strong>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${status.index < 3}">
                                                        <span class="badge bg-warning">
                                                            <i class="fas fa-crown me-1"></i>VIP
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${status.index < 10}">
                                                        <span class="badge bg-info">
                                                            <i class="fas fa-star me-1"></i>Thân thiết
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary">Thường</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 5. Thiệt hại hoa hết hạn -->
            <div class="chart-card">
                <div class="chart-card-header">
                    <h5><i class="fas fa-exclamation-triangle me-2"></i>Thiệt Hại Hoa Hết Hạn</h5>
                    <i class="fas fa-chart-line"></i>
                </div>
                <div class="chart-card-body">
                    <div class="chart-container">
                        <canvas id="damagedChart"></canvas>
                    </div>
                    <!-- Damaged flowers table -->
                    <div class="mt-3">
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <h6>Chi tiết hoa thiệt hại:</h6>
                            <input type="text" id="damagedSearch" class="form-control" style="max-width: 200px;" 
                                   placeholder="Tìm nguyên liệu..." onkeyup="filterTable('damagedTable', this.value)">
                        </div>
                        <div class="table-responsive">
                            <table class="table data-table" id="damagedTable">
                                <thead>
                                    <tr>
                                        <th>STT</th>
                                        <th>Tên nguyên liệu</th>
                                        <th>Số lượng</th>
                                        <th>Giá nhập</th>
                                        <th>Tổng thiệt hại</th>
                                        <th>Mức độ</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:if test="${damagedFlowerRevenue != null && damagedFlowerRevenue.details != null}">
                                        <c:forEach var="damaged" items="${damagedFlowerRevenue.details}" varStatus="status">
                                            <tr>
                                                <td>${status.index + 1}</td>
                                                <td>
                                                    <div class="d-flex align-items-center">
                                                        <i class="fas fa-seedling me-2 text-danger"></i>
                                                        ${damaged.materialName}
                                                    </div>
                                                </td>
                                                <td>
                                                    <span class="badge bg-warning">${damaged.quantity}</span>
                                                </td>
                                                <td>
                                                    <fmt:formatNumber value="${damaged.importPrice}" pattern="#,##0"/> VND
                                                </td>
                                                <td class="text-danger">
                                                    <strong><fmt:formatNumber value="${damaged.totalLoss}" pattern="#,##0"/> VND</strong>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${damaged.totalLoss > 500000}">
                                                            <span class="badge bg-danger">
                                                                <i class="fas fa-exclamation-triangle me-1"></i>Cao
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${damaged.totalLoss > 100000}">
                                                            <span class="badge bg-warning">
                                                                <i class="fas fa-exclamation me-1"></i>Trung bình
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-info">Thấp</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 6. Chi phí nhập hàng -->
            <div class="chart-card">
                <div class="chart-card-header">
                    <h5><i class="fas fa-truck me-2"></i>Chi Phí Nhập Hàng</h5>
                    <i class="fas fa-chart-bar"></i>
                </div>
                <div class="chart-card-body">
                    <div class="chart-container">
                        <canvas id="importChart"></canvas>
                    </div>
                    <!-- Import details table -->
                    <div class="mt-3">
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <h6>Chi tiết nhập hàng gần đây:</h6>
                            <input type="text" id="importSearch" class="form-control" style="max-width: 200px;" 
                                   placeholder="Tìm nguyên liệu..." onkeyup="filterTable('importTable', this.value)">
                        </div>
                        <div class="table-responsive">
                            <table class="table data-table" id="importTable">
                                <thead>
                                    <tr>
                                        <th>STT</th>
                                        <th>Nguyên liệu</th>
                                        <th>Số lượng</th>
                                        <th>Giá nhập</th>
                                        <th>Tổng tiền</th>
                                        <th>Ngày nhập</th>
                                        <th>Trạng thái</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:if test="${importRevenue != null && importRevenue.details != null}">
                                        <c:forEach var="importItem" items="${importRevenue.details}" varStatus="status">
                                            <tr>
                                                <td>${status.index + 1}</td>
                                                <td>
                                                    <div class="d-flex align-items-center">
                                                        <i class="fas fa-box me-2 text-success"></i>
                                                        ${importItem.materialName}
                                                    </div>
                                                </td>
                                                <td>
                                                    <span class="badge bg-primary">${importItem.quantity}</span>
                                                </td>
                                                <td>
                                                    <fmt:formatNumber value="${importItem.importPrice}" pattern="#,##0"/> VND
                                                </td>
                                                <td>
                                                    <strong><fmt:formatNumber value="${importItem.totalImport}" pattern="#,##0"/> VND</strong>
                                                </td>
                                                <td>
                                                    <small class="text-muted">
                                                        <i class="fas fa-calendar me-1"></i>
                                                        <fmt:formatDate value="${importItem.dateImport}" pattern="dd/MM/yyyy"/>
                                                    </small>
                                                </td>
                                                <td>
                                                    <span class="badge bg-success">
                                                        <i class="fas fa-check me-1"></i>Đã nhập
                                                    </span>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 7. Biểu đồ so sánh tổng quan -->
            <div class="chart-card chart-grid-full">
                <div class="chart-card-header">
                    <h5><i class="fas fa-chart-line me-2"></i>So Sánh Doanh Thu - Chi Phí - Thiệt Hại</h5>
                    <i class="fas fa-analytics"></i>
                </div>
                <div class="chart-card-body">
                    <div class="chart-container">
                        <canvas id="comparisonChart"></canvas>
                    </div>
                    <div class="mt-3">
                        <div class="row">
                            <div class="col-md-4">
                                <div class="text-center">
                                    <h6 class="text-success">Lợi nhuận ước tính</h6>
                                    <h4 class="text-success">
                                        <c:choose>
                                            <c:when test="${profit != null}">
                                                <fmt:formatNumber value="${profit}" pattern="#,##0"/> VND
                                            </c:when>
                                            <c:otherwise>0 VND</c:otherwise>
                                        </c:choose>
                                    </h4>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="text-center">
                                    <h6 class="text-info">Tỷ lệ lợi nhuận</h6>
                                    <h4 class="text-info">
                                        <c:choose>
                                            <c:when test="${profitMargin != null}">
                                                <fmt:formatNumber value="${profitMargin}" pattern="#0.0"/>%
                                            </c:when>
                                            <c:otherwise>0%</c:otherwise>
                                        </c:choose>
                                    </h4>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="text-center">
                                    <h6 class="text-warning">Tỷ lệ thiệt hại</h6>
                                    <h4 class="text-warning">
                                        <c:choose>
                                            <c:when test="${damageRate != null}">
                                                <fmt:formatNumber value="${damageRate}" pattern="#0.0"/>%
                                            </c:when>
                                            <c:otherwise>0%</c:otherwise>
                                        </c:choose>
                                    </h4>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Export Section -->
        <div class="export-section">
            <h5><i class="fas fa-download me-2"></i>Xuất Báo Cáo</h5>
            <p class="mb-3">Tải xuống báo cáo doanh thu với nhiều định dạng khác nhau</p>
            <div class="export-buttons">
              
                <button onclick="exportToExcel()" class="btn-export">
                    <i class="fas fa-file-excel"></i>Xuất Excel
                </button>
               
                <button onclick="exportCharts()" class="btn-export">
                    <i class="fas fa-chart-line"></i>Xuất Biểu Đồ
                </button>
            </div>
            
            <!-- Loading spinner -->
            <div class="loading-spinner" id="exportLoading">
                <div class="spinner"></div>
                <p>Đang chuẩn bị file...</p>
            </div>
        </div>
    </div>

    <!-- JavaScript Data -->
    <script>
        // Dữ liệu doanh thu theo tháng
        var revenueData = [];
        var revenueLabels = [];
        <c:if test="${revenueList != null}">
            <c:forEach var="revenue" items="${revenueList}">
                revenueData.push(${revenue.revenue});
                revenueLabels.push('Tháng ${revenue.month}');
            </c:forEach>
        </c:if>

        // Dữ liệu trạng thái đơn hàng
        var statusData = [];
        var statusLabels = [];
        <c:if test="${orderStatusSummary != null}">
            <c:forEach var="status" items="${orderStatusSummary}">
                statusData.push(${status.value});
                statusLabels.push('${status.key}');
            </c:forEach>
        </c:if>

        // Dữ liệu sản phẩm
        var productData = [];
        var productLabels = [];
        var productQuantities = [];
        <c:if test="${productRevenueList != null}">
            <c:forEach var="product" items="${productRevenueList}" varStatus="status">
                <c:if test="${status.index < 10}">
                    productData.push(${product.totalRevenue});
                    productLabels.push('${product.title}');
                    productQuantities.push(${product.totalSold});
                </c:if>
            </c:forEach>
        </c:if>

        // Dữ liệu khách hàng
        var customerData = [];
        var customerLabels = [];
        <c:if test="${customerRevenueList != null}">
            <c:forEach var="customer" items="${customerRevenueList}" varStatus="status">
                <c:if test="${status.index < 10}">
                    customerData.push(${customer.totalSpent});
                    customerLabels.push('${customer.fullName}');
                </c:if>
            </c:forEach>
        </c:if>

        // Dữ liệu nhập hàng theo tháng
        var importMonthData = [];
        var importMonthLabels = [];
        <c:if test="${importRevenueByMonth != null}">
            <c:forEach var="importItem" items="${importRevenueByMonth}">
                importMonthData.push(${importItem.totalImport});
                importMonthLabels.push('Tháng ${importItem.month}');
            </c:forEach>
        </c:if>

        // Dữ liệu thiệt hại theo tháng
        var damagedMonthData = [];
        var damagedMonthLabels = [];
        <c:if test="${damagedRevenueByMonth != null}">
            <c:forEach var="damaged" items="${damagedRevenueByMonth}">
                damagedMonthData.push(${damaged.totalDamaged});
                damagedMonthLabels.push('Tháng ${damaged.month}');
            </c:forEach>
        </c:if>
    </script>
    
    <!-- Debug Script -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Wait for charts to load
            setTimeout(function() {
                updateDebugInfo();
            }, 2000);
        });
        
        function updateDebugInfo() {
            let debugInfo = '<ul class="mb-0">';
            
            // Chi tiết dữ liệu JavaScript arrays
            debugInfo += '<li><strong>🔍 JavaScript Arrays:</strong></li>';
            
            // Revenue data
            debugInfo += '<li style="margin-left: 20px;">revenueData: [';
            if (typeof revenueData !== 'undefined' && revenueData.length > 0) {
                debugInfo += revenueData.join(', ');
            } else {
                debugInfo += 'KHÔNG CÓ DỮ LIỆU';
            }
            debugInfo += ']</li>';
            
            // Revenue labels
            debugInfo += '<li style="margin-left: 20px;">revenueLabels: [';
            if (typeof revenueLabels !== 'undefined' && revenueLabels.length > 0) {
                debugInfo += revenueLabels.join(', ');
            } else {
                debugInfo += 'KHÔNG CÓ DỮ LIỆU';
            }
            debugInfo += ']</li>';
            
            // Import data
            debugInfo += '<li style="margin-left: 20px;">importMonthData: [';
            if (typeof importMonthData !== 'undefined' && importMonthData.length > 0) {
                debugInfo += importMonthData.join(', ');
            } else {
                debugInfo += 'KHÔNG CÓ DỮ LIỆU';
            }
            debugInfo += ']</li>';
            
            // Damaged data
            debugInfo += '<li style="margin-left: 20px;">damagedMonthData: [';
            if (typeof damagedMonthData !== 'undefined' && damagedMonthData.length > 0) {
                debugInfo += damagedMonthData.join(', ');
            } else {
                debugInfo += 'KHÔNG CÓ DỮ LIỆU';
            }
            debugInfo += ']</li>';
            
            // Doanh thu từ chart
            if (typeof revenueData !== 'undefined' && revenueData.length > 0) {
                const totalRevenueFromChart = revenueData.reduce((sum, val) => sum + val, 0);
                debugInfo += '<li><strong>Doanh thu (từ chart): ' + totalRevenueFromChart.toLocaleString('vi-VN') + ' VND</strong></li>';
                debugInfo += '<li style="margin-left: 20px;">📊 Số tháng có data: ' + revenueData.length + '</li>';
            } else {
                debugInfo += '<li><strong>❌ Doanh thu (từ chart): KHÔNG CÓ DỮ LIỆU</strong></li>';
                debugInfo += '<li style="margin-left: 20px;">revenueData type: ' + typeof revenueData + ', length: ' + (typeof revenueData !== 'undefined' ? revenueData.length : 'N/A') + '</li>';
            }
            
            // Chi phí nhập từ chart  
            if (typeof importMonthData !== 'undefined' && importMonthData.length > 0) {
                const totalImportFromChart = importMonthData.reduce((sum, val) => sum + val, 0);
                debugInfo += '<li><strong>Chi phí nhập (từ chart): ' + totalImportFromChart.toLocaleString('vi-VN') + ' VND</strong></li>';
                debugInfo += '<li style="margin-left: 20px;">📊 Số tháng có data: ' + importMonthData.length + '</li>';
            } else {
                debugInfo += '<li><strong>❌ Chi phí nhập (từ chart): KHÔNG CÓ DỮ LIỆU</strong></li>';
                debugInfo += '<li style="margin-left: 20px;">importMonthData type: ' + typeof importMonthData + ', length: ' + (typeof importMonthData !== 'undefined' ? importMonthData.length : 'N/A') + '</li>';
            }
            
            // Thiệt hại từ chart
            if (typeof damagedMonthData !== 'undefined' && damagedMonthData.length > 0) {
                const totalDamagedFromChart = damagedMonthData.reduce((sum, val) => sum + val, 0);
                debugInfo += '<li><strong>Thiệt hại (từ chart): ' + totalDamagedFromChart.toLocaleString('vi-VN') + ' VND</strong></li>';
                debugInfo += '<li style="margin-left: 20px;">📊 Số tháng có data: ' + damagedMonthData.length + '</li>';
            } else {
                debugInfo += '<li><strong>❌ Thiệt hại (từ chart): KHÔNG CÓ DỮ LIỆU</strong></li>';
                debugInfo += '<li style="margin-left: 20px;">damagedMonthData type: ' + typeof damagedMonthData + ', length: ' + (typeof damagedMonthData !== 'undefined' ? damagedMonthData.length : 'N/A') + '</li>';
            }
            
            // Phân tích sự chênh lệch
            debugInfo += '<li><strong>🔍 PHÂN TÍCH SỰ CHÊNH LỆCH:</strong></li>';
            debugInfo += '<li style="margin-left: 20px; color: red;">Server: 6,650,000 VND vs Chi tiết tháng 7: 7,040,000 VND</li>';
            debugInfo += '<li style="margin-left: 20px; color: red;">Chênh lệch: ' + (7040000 - 6650000).toLocaleString('vi-VN') + ' VND</li>';
            
            // Tính lợi nhuận từ dữ liệu chart (nếu có đủ dữ liệu)
            if (typeof revenueData !== 'undefined' && revenueData.length > 0 && 
                typeof importMonthData !== 'undefined' && importMonthData.length > 0 && 
                typeof damagedMonthData !== 'undefined' && damagedMonthData.length > 0) {
                const revChart = revenueData.reduce((sum, val) => sum + val, 0);
                const impChart = importMonthData.reduce((sum, val) => sum + val, 0);
                const damChart = damagedMonthData.reduce((sum, val) => sum + val, 0);
                const profitChart = revChart - impChart - damChart;
                debugInfo += '<li><strong>Lợi nhuận (từ chart): ' + profitChart.toLocaleString('vi-VN') + ' VND</strong></li>';
            }
            
            // Kiểm tra các biến JavaScript có sẵn
            debugInfo += '<li><strong>🔧 Các biến JS khác:</strong></li>';
            debugInfo += '<li style="margin-left: 20px;">productData length: ' + (typeof productData !== 'undefined' ? productData.length : 'undefined') + '</li>';
            debugInfo += '<li style="margin-left: 20px;">customerData length: ' + (typeof customerData !== 'undefined' ? customerData.length : 'undefined') + '</li>';
            debugInfo += '<li style="margin-left: 20px;">statusData length: ' + (typeof statusData !== 'undefined' ? statusData.length : 'undefined') + '</li>';
            
            debugInfo += '</ul>';
            
            const debugElement = document.getElementById('chartDebugInfo');
            if (debugElement) {
                debugElement.innerHTML = debugInfo;
            }
        }
    </script>

    <!-- Include JavaScript -->
    <script src="js/revenue-chart.js"></script>
    <script src="js/table-pagination.js"></script>
    
    <!-- Additional JavaScript -->
    <script>
        // Filter function for tables
        function filterTable(tableId, searchTerm) {
            if (window.tablePaginations && window.tablePaginations[tableId]) {
                window.tablePaginations[tableId].filter(searchTerm);
            }
        }
        
        // Enhanced export functions
        function exportToExcel() {
            if (window.excelExporter) {
                document.getElementById('exportLoading').style.display = 'block';
                setTimeout(() => {
                    window.excelExporter.exportRevenueData();
                    document.getElementById('exportLoading').style.display = 'none';
                }, 1000);
            }
        }
        
        function exportToPDF() {
            // Enhanced print for PDF
            const printContent = document.querySelector('.main-content').innerHTML;
            const printWindow = window.open('', '_blank');
            printWindow.document.write(`
                <html>
                <head>
                    <title>Báo Cáo Doanh Thu</title>
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                    <link href="css/revenue-chart.css" rel="stylesheet">
                    <style>
                        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
                        .chart-container { height: 300px !important; }
                        .pagination-container, .btn, .export-section { display: none !important; }
                    </style>
                </head>
                <body>${printContent}</body>
                </html>
            `);
            printWindow.document.close();
            printWindow.print();
        }
        
        function exportCharts() {
            if (window.revenueChartManager) {
                const charts = ['monthly', 'status', 'product', 'customer', 'damaged', 'import', 'comparison'];
                charts.forEach(chartName => {
                    if (window.revenueChartManager.charts[chartName]) {
                        window.revenueChartManager.exportChart(chartName);
                    }
                });
            }
        }
        
        // Auto-refresh data every 5 minutes
        setInterval(() => {
            if (confirm('Bạn có muốn làm mới dữ liệu báo cáo không?')) {
                location.reload();
            }
        }, 300000); // 5 minutes
    </script>
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>