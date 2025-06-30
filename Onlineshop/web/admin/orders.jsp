<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Đơn hàng - Admin</title>
    
    <!-- CSS Libraries -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/sweetalert2@11.7.32/dist/sweetalert2.min.css" rel="stylesheet">
    
    <style>
        :root {
            --primary-color: #4e73df;
            --success-color: #1cc88a;
            --warning-color: #f6c23e;
            --danger-color: #e74a3b;
            --info-color: #36b9cc;
            --dark-color: #5a5c69;
        }
        
        .main-content {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        
        .icon-circle {
        display: flex;
        align-items: center;
        justify-content: center;
        width: 28px;
        height: 28px;
        border-radius: 50%;
        font-size: 0.8rem;
    }
    
    .dropdown-item:hover {
        background-color: #f8f9fa;
    }
    
    .dropdown-menu {
        min-width: 200px;
    }
        .dashboard-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            border: none;
        }
        
        .dashboard-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 40px rgba(0,0,0,0.15);
        }
        
        .stats-card {
            background: linear-gradient(135deg, var(--primary-color), #224abe);
            color: white;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 20px;
            position: relative;
            overflow: hidden;
        }
        
        .stats-card::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -50%;
            width: 100%;
            height: 100%;
            background: rgba(255,255,255,0.1);
            border-radius: 50%;
            transform: rotate(45deg);
        }
        
        .stats-card.success {
            background: linear-gradient(135deg, var(--success-color), #17a673);
        }
        
        .stats-card.warning {
            background: linear-gradient(135deg, var(--warning-color), #dda20a);
        }
        
        .stats-card.danger {
            background: linear-gradient(135deg, var(--danger-color), #c0392b);
        }
        
        .filter-section {
            background: white;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 25px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
        }
        
        .table-container {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }
        
        .table thead th {
            background: linear-gradient(135deg, var(--primary-color), #224abe);
            color: white;
            border: none;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            padding: 15px;
        }
        
        .table tbody tr {
            transition: all 0.3s ease;
        }
        
        .table tbody tr:hover {
            background-color: #f8f9fc;
            transform: scale(1.01);
        }
        
        .status-badge {
            padding: 8px 16px;
            border-radius: 25px;
            font-weight: 600;
            font-size: 0.8rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }
        
        .status-pending {
            background: linear-gradient(135deg, #ffeaa7, #fdcb6e);
            color: #2d3436;
        }
        
        .status-completed {
            background: linear-gradient(135deg, #00b894, #00a085);
            color: white;
        }
        
        .status-cancelled {
            background: linear-gradient(135deg, #e17055, #d63031);
            color: white;
        }
        
        .action-btn {
            width: 35px;
            height: 35px;
            border-radius: 50%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            margin: 0 3px;
            transition: all 0.3s ease;
            border: none;
        }
        
        .action-btn:hover {
            transform: scale(1.1);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        
        .btn-view {
            background: linear-gradient(135deg, var(--info-color), #2c9faf);
            color: white;
        }
        
        .btn-edit {
            background: linear-gradient(135deg, var(--warning-color), #dda20a);
            color: white;
        }
        
        .btn-delete {
            background: linear-gradient(135deg, var(--danger-color), #c0392b);
            color: white;
        }
        
        .btn-approve {
            background: linear-gradient(135deg, var(--success-color), #17a673);
            color: white;
        }
        
      /* Enhanced search styles */
.search-box {
    position: relative;
}

.search-box input {
    border-radius: 15px;
    padding-left: 50px;
    padding-right: 40px;
    border: 2px solid #e3e6f0;
    transition: all 0.3s ease;
    background: linear-gradient(145deg, #ffffff, #f8f9fc);
    box-shadow: 0 2px 10px rgba(0,0,0,0.05);
}

.search-box input:focus {
    border-color: var(--primary-color);
    box-shadow: 0 0 0 0.2rem rgba(78, 115, 223, 0.25), 0 5px 20px rgba(0,0,0,0.1);
    transform: translateY(-1px);
}

.search-box .search-icon {
    position: absolute;
    left: 18px;
    top: 50%;
    transform: translateY(-50%);
    color: #858796;
    font-size: 1.1rem;
    z-index: 2;
}

.btn-clear-search {
    position: absolute;
    right: 10px;
    top: 50%;
    transform: translateY(-50%);
    background: none;
    border: none;
    color: #858796;
    padding: 5px;
    border-radius: 50%;
    transition: all 0.3s ease;
    z-index: 2;
}

.btn-clear-search:hover {
    background: #f8f9fc;
    color: #e74a3b;
}

.search-suggestions {
    position: absolute;
    top: 100%;
    left: 0;
    right: 0;
    background: white;
    border: 1px solid #e3e6f0;
    border-radius: 10px;
    box-shadow: 0 10px 30px rgba(0,0,0,0.15);
    z-index: 1000;
    max-height: 300px;
    overflow-y: auto;
    display: none;
}

.suggestion-item {
    padding: 12px 15px;
    cursor: pointer;
    border-bottom: 1px solid #f8f9fc;
    transition: all 0.3s ease;
    display: flex;
    align-items: center;
    gap: 10px;
}

.suggestion-item:hover {
    background: linear-gradient(135deg, #f8f9fc, #e3e6f0);
    transform: translateX(5px);
}

.suggestion-item:last-child {
    border-bottom: none;
}

.suggestion-avatar {
    width: 35px;
    height: 35px;
    border-radius: 50%;
    background: linear-gradient(135deg, var(--primary-color), #224abe);
    display: flex;
    align-items: center;
    justify-content: center;
    color: white;
    font-weight: bold;
}

.suggestion-info {
    flex: 1;
}

.suggestion-name {
    font-weight: 600;
    color: #2d3436;
    margin-bottom: 2px;
}

.suggestion-email {
    font-size: 0.85rem;
    color: #636e72;
}

.quick-filters {
    padding: 15px;
    background: linear-gradient(135deg, #f8f9fc, #ffffff);
    border-radius: 10px;
    border: 1px solid #e3e6f0;
}

.quick-filter-btn {
    border-radius: 20px;
    padding: 5px 15px;
    font-size: 0.85rem;
    transition: all 0.3s ease;
}

.quick-filter-btn:hover {
    transform: translateY(-2px);
    box-shadow: 0 5px 15px rgba(0,0,0,0.2);
}

.filter-section {
    background: white;
    border-radius: 20px;
    padding: 30px;
    margin-bottom: 25px;
    box-shadow: 0 10px 30px rgba(0,0,0,0.08);
    border: 1px solid #e3e6f0;
}

.form-label {
    margin-bottom: 8px;
    font-size: 0.9rem;
}

/* Search result highlighting */
.search-highlight {
    background: linear-gradient(135deg, #fff3cd, #ffeaa7);
    padding: 2px 4px;
    border-radius: 3px;
    font-weight: bold;
}

/* Loading state for search */
.search-loading {
    position: absolute;
    right: 45px;
    top: 50%;
    transform: translateY(-50%);
    z-index: 2;
}

.search-loading .spinner-border {
    width: 1rem;
    height: 1rem;
}
        
        .export-btn {
            background: linear-gradient(135deg, #28a745, #20c997);
            border: none;
            border-radius: 25px;
            padding: 10px 25px;
            color: white;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .export-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(40, 167, 69, 0.4);
            color: white;
        }
        
        .page-title {
            color: white;
            font-weight: 700;
            margin-bottom: 30px;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
        }
        
        .animate-fade-in {
            animation: fadeIn 0.5s ease-in;
        }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .loading-spinner {
            display: none;
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            z-index: 9999;
        }
        
        .modal-content {
            border-radius: 15px;
            border: none;
            box-shadow: 0 20px 40px rgba(0,0,0,0.2);
        }
        
        .modal-header {
            background: linear-gradient(135deg, var(--primary-color), #224abe);
            color: white;
            border-radius: 15px 15px 0 0;
        }
    </style>
</head>
<body>
    <jsp:include page="../manager_topbarsidebar.jsp" />
    
    <main class="main-content">
        <div class="container-fluid">
            <h1 class="page-title animate-fade-in">
                <i class="fas fa-shopping-cart me-3"></i>
                Quản lý Đơn hàng
            </h1>
            
            <!-- Statistics Cards -->
            <div class="row mb-4 animate-fade-in">
                <div class="col-xl-3 col-md-6 mb-4">
                    <div class="stats-card">
                        <div class="d-flex align-items-center">
                            <div class="flex-grow-1">
                                <div class="h5 mb-0 font-weight-bold">${statistics.totalOrders}</div>
                                <div class="text-uppercase">Tổng đơn hàng</div>
                            </div>
                            <div class="fa-2x">
                                <i class="fas fa-shopping-bag"></i>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="col-xl-3 col-md-6 mb-4">
                    <div class="stats-card success">
                        <div class="d-flex align-items-center">
                            <div class="flex-grow-1">
                                <div class="h5 mb-0 font-weight-bold">${statistics.statusCount['Completed']}</div>
                                <div class="text-uppercase">Hoàn thành</div>
                            </div>
                            <div class="fa-2x">
                                <i class="fas fa-check-circle"></i>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="col-xl-3 col-md-6 mb-4">
                    <div class="stats-card warning">
                        <div class="d-flex align-items-center">
                            <div class="flex-grow-1">
                                <div class="h5 mb-0 font-weight-bold">${statistics.statusCount['Pending']}</div>
                                <div class="text-uppercase">Đang xử lý</div>
                            </div>
                            <div class="fa-2x">
                                <i class="fas fa-clock"></i>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="col-xl-3 col-md-6 mb-4">
                    <div class="stats-card danger">
                        <div class="d-flex align-items-center">
                            <div class="flex-grow-1">
                                <div class="h5 mb-0 font-weight-bold">${statistics.statusCount['Cancelled']}</div>
                                <div class="text-uppercase">Đã hủy</div>
                            </div>
                            <div class="fa-2x">
                                <i class="fas fa-times-circle"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Filter Section -->
          
<div class="filter-section mb-4">
    <div class="card shadow-sm">
        <div class="card-header bg-primary text-white">
            <h5 class="mb-0">
                <i class="fas fa-filter me-2"></i>Bộ lọc tìm kiếm
            </h5>
        </div>
        <div class="card-body">
           <form id="filterForm" method="get" action="orders">
                <input type="hidden" name="action" value="list">
                <div class="row g-3">
                    <!-- Tên khách hàng -->
                    <div class="col-md-3">
                        <label for="customerName" class="form-label">
                            <i class="fas fa-user me-1"></i>Tên khách hàng
                        </label>
                        <div class="input-group">
                            <input type="text" class="form-control" id="customerName" 
                                   name="customerName" placeholder="Nhập tên khách hàng..."
                                   value="${param.customerName}">
                            <button class="btn btn-outline-secondary" type="button" 
                                    onclick="clearField('customerName')">
                                <i class="fas fa-times"></i>
                            </button>
                        </div>
                    </div>
                    
                    <!-- Trạng thái -->
                    <div class="col-md-2">
                        <label for="status" class="form-label">
                            <i class="fas fa-flag me-1"></i>Trạng thái
                        </label>
                        <select class="form-select" id="status" name="status">
                            <option value="">Tất cả</option>
                            <option value="pending" ${param.status == 'pending' ? 'selected' : ''}>Chờ xử lý</option>
                            <option value="completed" ${param.status == 'completed' ? 'selected' : ''}>Hoàn thành</option>
                            <option value="cancelled" ${param.status == 'cancelled' ? 'selected' : ''}>Đã hủy</option>
                        </select>
                    </div>
                    
                    <!-- Từ ngày -->
                    <div class="col-md-2">
                        <label for="dateFrom" class="form-label">
                            <i class="fas fa-calendar-alt me-1"></i>Từ ngày
                        </label>
                        <input type="date" class="form-control" id="dateFrom" 
                               name="dateFrom" value="${param.dateFrom}">
                    </div>
                    
                    <!-- Đến ngày -->
                    <div class="col-md-2">
                        <label for="dateTo" class="form-label">
                            <i class="fas fa-calendar-alt me-1"></i>Đến ngày
                        </label>
                        <input type="date" class="form-control" id="dateTo" 
                               name="dateTo" value="${param.dateTo}">
                    </div>
                    
                    <!-- Buttons -->
                    <div class="col-md-3">
                        <label class="form-label">&nbsp;</label>
                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-primary flex-fill">
                                <i class="fas fa-search me-1"></i>Tìm kiếm
                            </button>
                            <button type="button" class="btn btn-outline-secondary" 
                                    onclick="resetFilters()">
                                <i class="fas fa-redo me-1"></i>Reset
                            </button>
                        </div>
                    </div>
                </div>
                
                <!-- Quick Filter Buttons -->
                <div class="row mt-3">
                    <div class="col-12">
                        <div class="d-flex gap-2 flex-wrap">
                            <span class="text-muted me-2">Lọc nhanh:</span>
                            <button type="button" class="btn btn-sm btn-outline-warning" 
                                    onclick="quickFilter('pending')">
                                <i class="fas fa-clock me-1"></i>Chờ xử lý
                            </button>
                            <button type="button" class="btn btn-sm btn-outline-success" 
                                    onclick="quickFilter('completed')">
                                <i class="fas fa-check me-1"></i>Hoàn thành
                            </button>
                            <button type="button" class="btn btn-sm btn-outline-danger" 
                                    onclick="quickFilter('cancelled')">
                                <i class="fas fa-times me-1"></i>Đã hủy
                            </button>
                            <button type="button" class="btn btn-sm btn-outline-info" 
                                    onclick="quickFilter('today')">
                                <i class="fas fa-calendar-day me-1"></i>Hôm nay
                            </button>
                            <button type="button" class="btn btn-sm btn-outline-info" 
                                    onclick="quickFilter('week')">
                                <i class="fas fa-calendar-week me-1"></i>Tuần này
                            </button>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>

<<<<<<< kyvk
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-bordered" id="dataTable" width="100%" cellspacing="0">
                            <thead>
                                <tr>
                                    <th>Mã đơn hàng</th>
                                    <th>Khách hàng</th>
                                    <th>Ngày đặt</th>
                                    <th>Tổng tiền</th>
                                    <th>Phương thức</th>
                                    <th>Trạng thái</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${orders}" var="order">
                                    <tr>
                                        <td>#${order.orderId}</td>
                                        <td>${order.fullName}</td>
                                        <td><fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy" /></td>
                                        <td><fmt:formatNumber value="${order.total}" type="currency" currencySymbol="đ" maxFractionDigits="0"/></td>
                                        <td>${order.paymentMethod}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${order.status eq 'Pending'}">
                                                    <span class="status-badge status-pending">Đang xử lý</span>
                                                </c:when>
                                                <c:when test="${order.status eq 'Completed'}">
                                                    <span class="status-badge status-completed">Hoàn thành</span>
                                                </c:when>
                                                <c:when test="${order.status eq 'Cancelled'}">
                                                    <span class="status-badge status-cancelled">Đã hủy</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="status-badge">${order.status}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="action-buttons">
                                            <a href="${pageContext.request.contextPath}/orders?action=detail&orderId=${order.orderId}" class="btn btn-info btn-sm">
=======

            
            <!-- Orders Table -->
            <div class="table-container animate-fade-in">
                <div class="table-responsive">
                    <table class="table table-hover mb-0" id="ordersTable">
                        <thead>
                            <tr>
                                <th><i class="fas fa-hashtag me-2"></i>Mã ĐH</th>
                                <th><i class="fas fa-user me-2"></i>Khách hàng</th>
                                <th><i class="fas fa-calendar me-2"></i>Ngày đặt</th>
                                <th><i class="fas fa-money-bill me-2"></i>Tổng tiền</th>
                                <th><i class="fas fa-info-circle me-2"></i>Trạng thái</th>
                                <th><i class="fas fa-cogs me-2"></i>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${orders}" var="order">
                                <tr data-order-id="${order.orderId}">
                                    <td class="fw-bold">#${order.orderId}</td>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <div class="avatar-sm bg-primary rounded-circle d-flex align-items-center justify-content-center me-3">
                                                <i class="fas fa-user text-white"></i>
                                            </div>
                                            <div>
                                                <div class="fw-bold">${order.fullName}</div>
                                                <small class="text-muted">${order.email}</small>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm" />
                                    </td>
                                    <td class="fw-bold text-success">
                                        <fmt:formatNumber value="${order.total}" type="currency" 
                                                        currencySymbol="₫" maxFractionDigits="0"/>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${order.status eq 'Pending'}">
                                                <span class="status-badge status-pending">
                                                    <i class="fas fa-clock"></i> Đang xử lý
                                                </span>
                                            </c:when>
                                            <c:when test="${order.status eq 'Completed'}">
                                                <span class="status-badge status-completed">
                                                    <i class="fas fa-check"></i> Hoàn thành
                                                </span>
                                            </c:when>
                                            <c:when test="${order.status eq 'Cancelled'}">
                                                <span class="status-badge status-cancelled">
                                                    <i class="fas fa-times"></i> Đã hủy
                                                </span>
                                            </c:when>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <button class="action-btn btn-view" 
                                                    onclick="viewOrder(${order.orderId})" 
                                                    title="Xem chi tiết">
>>>>>>> main
                                                <i class="fas fa-eye"></i>
                                            </button>
                                            
                                            <c:if test="${order.status eq 'Pending'}">
                                                <button class="action-btn btn-approve" 
                                                        onclick="updateStatus(${order.orderId}, 2)" 
                                                        title="Duyệt đơn">
                                                    <i class="fas fa-check"></i>
                                                </button>
                                                
                                                <button class="action-btn btn-edit" 
                                                        onclick="updateStatus(${order.orderId}, 3)" 
                                                        title="Hủy đơn">
                                                    <i class="fas fa-times"></i>
                                                </button>
                                            </c:if>
                                         
<div class="dropdown">
    <button class="action-btn btn-view dropdown-toggle" 
            data-bs-toggle="dropdown" title="Thao tác khác">
        <i class="fas fa-ellipsis-v"></i>
    </button>
    <ul class="dropdown-menu dropdown-menu-end shadow-sm border-0">
        <li>
            <a class="dropdown-item d-flex align-items-center py-2" href="#" 
               onclick="sendNotification(${order.orderId})">
                <span class="icon-circle bg-primary text-white me-2">
                    <i class="fas fa-envelope"></i>
                </span>
                <span>Gửi thông báo</span>
            </a>
        </li>
        <li><hr class="dropdown-divider"></li>
        <li>
            <a class="dropdown-item d-flex align-items-center py-2" href="#" 
               onclick="printOrder(${order.orderId})">
                <span class="icon-circle bg-info text-white me-2">
                    <i class="fas fa-print"></i>
                </span>
                <span>In đơn hàng</span>
            </a>
        </li>
    </ul>
</div>

                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            
                            <c:if test="${empty orders}">
                                <tr>
                                    <td colspan="6" class="text-center py-5">
                                        <div class="text-muted">
                                            <i class="fas fa-inbox fa-3x mb-3"></i>
                                            <h5>Không có đơn hàng nào</h5>
                                            <p>Chưa có đơn hàng nào được tìm thấy với bộ lọc hiện tại.</p>
                                        </div>
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
                
                <!-- Pagination -->
                <c:if test="${totalPages > 1}">
                    <div class="d-flex justify-content-center py-4">
                        <nav>
                            <ul class="pagination pagination-lg">
                                <c:if test="${currentPage > 1}">
                                    <li class="page-item">
                                        <a class="page-link" href="?page=${currentPage - 1}&status=${status}&dateFrom=${dateFrom}&dateTo=${dateTo}&customerName=${customerName}">
                                            <i class="fas fa-chevron-left"></i>
                                        </a>
                                    </li>
                                </c:if>
                                
                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <li class="page-item ${currentPage == i ? 'active' : ''}">
                                        <a class="page-link" href="?page=${i}&status=${status}&dateFrom=${dateFrom}&dateTo=${dateTo}&customerName=${customerName}">
                                            ${i}
                                        </a>
                                    </li>
                                </c:forEach>
                                
                                <c:if test="${currentPage < totalPages}">
                                    <li class="page-item">
                                        <a class="page-link" href="?page=${currentPage + 1}&status=${status}&dateFrom=${dateFrom}&dateTo=${dateTo}&customerName=${customerName}">
                                            <i class="fas fa-chevron-right"></i>
                                        </a>
                                    </li>
                                </c:if>
                            </ul>
                        </nav>
                    </div>
                </c:if>
            </div>
        </div>
    </main>
    
    <!-- Loading Spinner -->
    <div class="loading-spinner">
        <div class="spinner-border text-primary" role="status">
            <span class="visually-hidden">Loading...</span>
        </div>
    </div>
    
    <!-- Order Detail Modal -->
    <div class="modal fade" id="orderDetailModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="fas fa-receipt me-2"></i>
                        Chi tiết đơn hàng #<span id="modalOrderId"></span>
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body" id="orderDetailContent">
                    <!-- Content will be loaded here -->
                </div>
            </div>
        </div>
    </div>
    
    <!-- Notification Modal -->
<div class="modal fade" id="notificationModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title">
                    <i class="fas fa-envelope me-2"></i>
                    Gửi thông báo đơn hàng
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body p-4">
                <form id="notificationForm">
                    <input type="hidden" id="notificationOrderId">
                    <div class="order-info mb-3 p-3 bg-light rounded">
                        <h6 class="fw-bold mb-2">Thông tin đơn hàng: <span id="orderIdDisplay" class="text-primary"></span></h6>
                        <div id="orderSummary" class="small"></div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">Nội dung thông báo:</label>
                        <textarea class="form-control" id="notificationMessage" rows="4" 
                                placeholder="Nhập nội dung thông báo..."></textarea>
                        <div class="form-text">Thông báo sẽ được gửi qua email đến khách hàng.</div>
                    </div>
                </form>
            </div>
            <div class="modal-footer bg-light">
                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">
                    <i class="fas fa-times me-1"></i> Hủy
                </button>
                <button type="button" class="btn btn-primary" onclick="sendNotificationEmail()">
                    <i class="fas fa-paper-plane me-1"></i> Gửi thông báo
                </button>
            </div>
        </div>
    </div>
</div>
    
    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.7.32/dist/sweetalert2.all.min.js"></script>
    
    <script>
        // Enhanced search functionality
$(document).ready(function() {
    let searchTimeout;
    const searchInput = $('#customerSearchInput');
    const searchSuggestions = $('#searchSuggestions');
    const clearButton = $('#clearSearch');
    
    // Real-time search suggestions
    searchInput.on('input', function() {
        const query = $(this).val().trim();
        
        if (query.length > 0) {
            clearButton.show();
            
            clearTimeout(searchTimeout);
            searchTimeout = setTimeout(() => {
                fetchSearchSuggestions(query);
            }, 300);
        } else {
            clearButton.hide();
            searchSuggestions.hide();
        }
    });
    
    // Clear search
    clearButton.on('click', function() {
        searchInput.val('').focus();
        clearButton.hide();
        searchSuggestions.hide();
    });
    
    // Hide suggestions when clicking outside
    $(document).on('click', function(e) {
        if (!$(e.target).closest('.search-box').length) {
            searchSuggestions.hide();
        }
    });
    
    // Fetch search suggestions
    function fetchSearchSuggestions(query) {
        if (query.length < 2) return;
        
        // Show loading
        searchSuggestions.html('<div class="suggestion-item"><div class="search-loading"><div class="spinner-border text-primary" role="status"></div></div><div>Đang tìm kiếm...</div></div>').show();
        
        $.ajax({
            url: '${pageContext.request.contextPath}/orders',
            type: 'GET',
            data: {
                action: 'searchCustomers',
                query: query
            },
            success: function(response) {
                displaySearchSuggestions(response.customers, query);
            },
            error: function() {
                searchSuggestions.hide();
            }
        });
    }
    
    // Display search suggestions
    function displaySearchSuggestions(customers, query) {
        if (!customers || customers.length === 0) {
            searchSuggestions.html('<div class="suggestion-item text-muted"><i class="fas fa-search me-2"></i>Không tìm thấy khách hàng nào</div>').show();
            return;
        }
        
        let html = '';
        customers.forEach(customer => {
            const highlightedName = highlightText(customer.fullName, query);
            const highlightedEmail = highlightText(customer.email, query);
            const avatar = customer.fullName.charAt(0).toUpperCase();
            
            html += `
                <div class="suggestion-item" onclick="selectCustomer('${customer.fullName}')">
                    <div class="suggestion-avatar">${avatar}</div>
                    <div class="suggestion-info">
                        <div class="suggestion-name">${highlightedName}</div>
                        <div class="suggestion-email">${highlightedEmail}</div>
                    </div>
                    <small class="text-muted">${customer.orderCount} đơn hàng</small>
                </div>
            `;
        });
        
        searchSuggestions.html(html).show();
    }
    
    // Highlight matching text
    function highlightText(text, query) {
        if (!text || !query) return text;
        const regex = new RegExp(`(${query})`, 'gi');
        return text.replace(regex, '<span class="search-highlight">$1</span>');
    }
    
    // Select customer from suggestions
    window.selectCustomer = function(customerName) {
        searchInput.val(customerName);
        searchSuggestions.hide();

    };
    
    // Quick search functions
    window.quickSearch = function(type) {
        const form = $('#filterForm');
        const today = new Date();
        
        // Reset form
        form.find('input[type="text"], input[type="date"]').val('');
        form.find('select').val('');
        
        switch(type) {
            case 'Pending':
            case 'Completed':
            case 'Cancelled':
                form.find('select[name="status"]').val(type);
                break;
            case 'today':
                const todayStr = today.toISOString().split('T')[0];
                form.find('input[name="dateFrom"]').val(todayStr);
                form.find('input[name="dateTo"]').val(todayStr);
                break;
            case 'week':
                const weekStart = new Date(today.setDate(today.getDate() - today.getDay()));
                const weekEnd = new Date(today.setDate(today.getDate() - today.getDay() + 6));
                form.find('input[name="dateFrom"]').val(weekStart.toISOString().split('T')[0]);
                form.find('input[name="dateTo"]').val(weekEnd.toISOString().split('T')[0]);
                break;
        }
        
        form.submit();
    };
    
    // Reset filters
    window.resetFilters = function() {
        $('#filterForm')[0].reset();
        clearButton.hide();
        searchSuggestions.hide();
        window.location.href = '${pageContext.request.contextPath}/orders';
    };
    
    // Auto-focus search input
    searchInput.focus();
    
    // Keyboard shortcuts
    $(document).on('keydown', function(e) {
        // Ctrl/Cmd + F to focus search
        if ((e.ctrlKey || e.metaKey) && e.key === 'f') {
            e.preventDefault();
            searchInput.focus().select();
        }
        
        // Escape to clear search
        if (e.key === 'Escape') {
            searchInput.val('');
            clearButton.hide();
            searchSuggestions.hide();
        }
    });
});
        
        // View order detail
        function viewOrder(orderId) {
            showLoading();
            
            $.ajax({
                url: '${pageContext.request.contextPath}/orders',
                type: 'GET',
                data: {
                    action: 'detail',
                    orderId: orderId
                },
                success: function(response) {
                    hideLoading();
                    $('#modalOrderId').text(orderId);
                    $('#orderDetailContent').html(response);
                    $('#orderDetailModal').modal('show');
                },
                error: function() {
                    hideLoading();
                    Swal.fire({
                        icon: 'error',
                        title: 'Lỗi!',
                        text: 'Không thể tải chi tiết đơn hàng'
                    });
                }
            });
        }
        
        // Update order status
       // Cập nhật hàm updateStatus
function updateStatus(orderId, statusId) {
    let statusText = '';
    switch(statusId) {
        case 2: statusText = 'duyệt'; break;
        case 3: statusText = 'chuyển sang vận chuyển'; break;
        case 4: statusText = 'hoàn thành giao hàng'; break;
        case 6: statusText = 'hủy'; break;
        default: statusText = 'cập nhật';
    }
    
    Swal.fire({
        title: 'Xác nhận',
        text: `Bạn có chắc muốn ${statusText} đơn hàng này?`,
        icon: 'question',
        showCancelButton: true,
        confirmButtonText: 'Xác nhận',
        cancelButtonText: 'Hủy'
    }).then((result) => {
        if (result.isConfirmed) {
            showLoading();
            
            $.ajax({
                url: '${pageContext.request.contextPath}/orders',
                type: 'POST',
                data: {
                    action: 'updateStatus',
                    orderId: orderId,
                    statusId: statusId
                },
                success: function(response) {
                    hideLoading();
                    if (response.success) {
                        Swal.fire({
                            icon: 'success',
                            title: 'Thành công!',
                            text: response.message,
                            timer: 2000,
                            showConfirmButton: false
                        }).then(() => {
                            location.reload();
                        });
                    } else {
                        Swal.fire({
                            icon: 'error',
                            title: 'Lỗi!',
                            text: response.message
                        });
                    }
                },
                error: function() {
                    hideLoading();
                    Swal.fire({
                        icon: 'error',
                        title: 'Lỗi!',
                        text: 'Có lỗi xảy ra khi cập nhật trạng thái'
                    });
                }
            });
        }
    });
}
       
        
        // Send notification
        // Send notification
function sendNotification(orderId) {
    $('#notificationOrderId').val(orderId);
    $('#orderIdDisplay').text('#' + orderId);
    $('#notificationMessage').val('');
    
    // Hiển thị thông tin đơn hàng trong modal
    const orderRow = $('tr[data-order-id="' + orderId + '"]');
    const customerName = orderRow.find('td:eq(1)').text().trim();
    const orderDate = orderRow.find('td:eq(2)').text().trim();
    const orderTotal = orderRow.find('td:eq(3)').text().trim();
    const orderStatus = orderRow.find('td:eq(4)').text().trim();
    
    let orderSummary = `
        <div class="row g-2">
            <div class="col-6"><strong>Khách hàng:</strong> ${customerName}</div>
            <div class="col-6"><strong>Ngày đặt:</strong> ${orderDate}</div>
            <div class="col-6"><strong>Tổng tiền:</strong> ${orderTotal}</div>
            <div class="col-6"><strong>Trạng thái:</strong> ${orderStatus}</div>
        </div>
    `;
    
    $('#orderSummary').html(orderSummary);
    $('#notificationModal').modal('show');
}
        
        function sendNotificationEmail() {
            const orderId = $('#notificationOrderId').val();
            const message = $('#notificationMessage').val();
            
            if (!message.trim()) {
                Swal.fire({
                    icon: 'warning',
                    title: 'Cảnh báo!',
                    text: 'Vui lòng nhập nội dung thông báo'
                });
                return;
            }
            
            showLoading();
            
            $.ajax({
                url: '${pageContext.request.contextPath}/orders',
                type: 'POST',
                data: {
                    action: 'notify',
                    orderId: orderId,
                    message: message
                },
                success: function(response) {
                    hideLoading();
                    $('#notificationModal').modal('hide');
                    
                    Swal.fire({
                        icon: response.success ? 'success' : 'error',
                        title: response.success ? 'Thành công!' : 'Lỗi!',
                        text: response.message
                    });
                },
                error: function() {
                    hideLoading();
                    $('#notificationModal').modal('hide');
                    
                    Swal.fire({
                        icon: 'error',
                        title: 'Lỗi!',
                        text: 'Đã xảy ra lỗi khi gửi thông báo'
                    });
                }
            });
        }
        
        // Export Excel
        function exportExcel() {
            showLoading();
            
            window.location.href = '${pageContext.request.contextPath}/orders?action=export';
            
            setTimeout(hideLoading, 2000);
        }
        
        // Print order
        function printOrder(orderId) {
            window.open('${pageContext.request.contextPath}/orders?action=print&orderId=' + orderId, '_blank');
        }
        
        // Loading functions
        function showLoading() {
            $('.loading-spinner').show();
        }
        
        function hideLoading() {
            $('.loading-spinner').hide();
        }
        
       
// Enhanced Filter Functions
function clearField(fieldId) {
    document.getElementById(fieldId).value = '';
}

function resetFilters() {
    document.getElementById('filterForm').reset();
    window.location.href = 'orders?action=list';
}

function quickFilter(type) {
    const form = document.getElementById('filterForm');
    
    // Reset form
    form.reset();
    
    const today = new Date();
    const formatDate = (date) => date.toISOString().split('T')[0];
    
    switch(type) {
        case 'pending':
            document.getElementById('status').value = 'pending';
            break;
        case 'completed':
            document.getElementById('status').value = 'completed';
            break;
        case 'cancelled':
            document.getElementById('status').value = 'cancelled';
            break;
        case 'today':
            document.getElementById('dateFrom').value = formatDate(today);
            document.getElementById('dateTo').value = formatDate(today);
            break;
        case 'week':
            const weekStart = new Date(today);
            weekStart.setDate(today.getDate() - today.getDay());
            const weekEnd = new Date(weekStart);
            weekEnd.setDate(weekStart.getDate() + 6);
            document.getElementById('dateFrom').value = formatDate(weekStart);
            document.getElementById('dateTo').value = formatDate(weekEnd);
            break;
    }
    
    // Tự động submit form sau khi thiết lập các giá trị lọc
    document.getElementById('filterForm').submit();
}

//// Auto-submit form when date changes
//document.addEventListener('DOMContentLoaded', function() {
//    const dateInputs = document.querySelectorAll('#dateFrom, #dateTo');
//    dateInputs.forEach(input => {
//        input.addEventListener('change', function() {
//            // Optional: Auto-submit after date selection
//            // document.getElementById('filterForm').submit();
//        });
//    });
//    
//    // Status change auto-submit
//    document.getElementById('status').addEventListener('change', function() {
//        document.getElementById('filterForm').submit();
//    });
//});

//// Enhanced search with debounce
//let searchTimeout;
//function debounceSearch() {
//    clearTimeout(searchTimeout);
//    searchTimeout = setTimeout(() => {
//        document.getElementById('filterForm').submit();
//    }, 500);
//}
//
//// Add to customer name input
//document.getElementById('customerName').addEventListener('input', debounceSearch);

    </script>
</body>
</html>