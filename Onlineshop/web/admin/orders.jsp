<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Quản lý Đơn hàng - Admin</title>

                    <!-- CSS Libraries -->
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                        rel="stylesheet">
                    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
                        rel="stylesheet">
                    <link href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css" rel="stylesheet">
                    <link href="https://cdn.jsdelivr.net/npm/sweetalert2@11.7.32/dist/sweetalert2.min.css"
                        rel="stylesheet">

                    <!-- Bootstrap CSS -->
        <link href="css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <!-- Custom CSS -->
        <link href="<c:url value='/css/admin.css'/>" rel="stylesheet">
        <link href="css/style.css" rel="stylesheet">
                    <style>
                        .main-content {
                            background: #f8f9fa;
                            min-height: 100vh;
                            padding: 20px;
                        }

                        .dashboard-card {
                            background: white;
                            border-radius: 4px;
                            border: 1px solid #dee2e6;
                            padding: 15px;
                        }

                        .stats-card {
                            background: #6c757d;
                            color: white;
                            border-radius: 4px;
                            padding: 15px;
                            margin-bottom: 15px;
                        }

                        .filter-section {
                            background: white;
                            border-radius: 4px;
                            padding: 15px;
                            margin-bottom: 15px;
                            border: 1px solid #dee2e6;
                        }

                        .customer-info-compact {
                            padding: 10px;
                            background: #f8f9fa;
                            border-bottom: 1px solid #dee2e6;
                        }

                        .customer-card {
                            display: flex;
                            align-items: center;
                            gap: 10px;
                            background: white;
                            padding: 10px;
                            border-radius: 4px;
                            border: 1px solid #dee2e6;
                        }

                        .customer-avatar {
                            width: 35px;
                            height: 35px;
                            background: #6c757d;
                            border-radius: 50%;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            color: white;
                            font-size: 14px;
                        }

                        .status-badge-compact {
                            padding: 4px 8px;
                            border-radius: 3px;
                            font-size: 12px;
                            font-weight: 500;
                        }

                        .message-form {
                            padding: 15px;
                        }

                        .message-input {
                            border: 1px solid #dee2e6;
                            border-radius: 4px;
                            padding: 8px;
                            font-size: 14px;
                        }

                        .template-btn {
                            background: #f8f9fa;
                            border: 1px solid #dee2e6;
                            color: #495057;
                            padding: 6px 12px;
                            border-radius: 3px;
                            font-size: 12px;
                            cursor: pointer;
                        }

                        .btn-send {
                            background: #6c757d;
                            border: none;
                            padding: 8px 16px;
                            border-radius: 3px;
                            color: white;
                        }

                        .table-container {
                            background: white;
                            border-radius: 4px;
                            overflow: hidden;
                            border: 1px solid #dee2e6;
                        }

                        .sort-section {
                            background: #6c757d;
                            border-radius: 4px;
                            padding: 15px;
                            border: 1px solid #dee2e6;
                            margin-bottom: 15px;
                        }

                        .sort-header {
                            display: flex;
                            justify-content: space-between;
                            align-items: center;
                            margin-bottom: 15px;
                        }

                        .sort-label {
                            font-size: 16px;
                            font-weight: 600;
                            color: #fff;
                        }

                        .count-badge {
                            background: rgba(255, 255, 255, 0.2);
                            color: #fff;
                            padding: 4px 8px;
                            border-radius: 3px;
                            font-weight: 500;
                            font-size: 12px;
                        }

                        .table thead th {
                            background: #6c757d;
                            color: white;
                            border: none;
                            font-weight: 500;
                            padding: 10px;
                        }

                        .status-badge {
                            padding: 4px 8px;
                            border-radius: 3px;
                            font-weight: 500;
                            font-size: 0.75rem;
                            display: inline-block;
                        }

                        .status-pending {
                            background: #ffc107;
                            color: #000;
                        }

                        .status-completed {
                            background: #28a745;
                            color: white;
                        }

                        .status-cancelled {
                            background: #dc3545;
                            color: white;
                        }

                        .action-btn {
                            width: 30px;
                            height: 30px;
                            border-radius: 3px;
                            display: inline-flex;
                            align-items: center;
                            justify-content: center;
                            margin: 0 2px;
                            border: none;
                            font-size: 12px;
                        }

                        .btn-view {
                            background: #17a2b8;
                            color: white;
                        }

                        .btn-edit {
                            background: #ffc107;
                            color: #000;
                        }

                        .btn-delete {
                            background: #dc3545;
                            color: white;
                        }

                        .btn-approve {
                            background: #28a745;
                            color: white;
                        }

                        .btn-notification {
                            background: #6c757d;
                            color: white;
                        }

                        .btn-print {
                            background: #343a40;
                            color: white;
                        }

                        .search-box {
                            position: relative;
                        }

                        .search-box input {
                            border-radius: 4px;
                            padding-left: 35px;
                            padding-right: 30px;
                            border: 1px solid #dee2e6;
                            background: white;
                        }

                        .search-box .search-icon {
                            position: absolute;
                            left: 10px;
                            top: 50%;
                            transform: translateY(-50%);
                            color: #6c757d;
                            font-size: 14px;
                        }

                        .btn-clear-search {
                            position: absolute;
                            right: 5px;
                            top: 50%;
                            transform: translateY(-50%);
                            background: none;
                            border: none;
                            color: #6c757d;
                            padding: 2px;
                        }



                        .filter-header {
                            background: #6c757d;
                            color: white;
                            padding: 12px 15px;
                            border-radius: 4px 4px 0 0;
                        }

                        .sort-btn {
                            margin: 2px;
                            border-radius: 3px;
                            padding: 6px 12px;
                            font-size: 0.8rem;
                            font-weight: 500;
                            border: 1px solid #dee2e6;
                        }

                        .sort-btn.active {
                            font-weight: 600;
                            background-color: #6c757d;
                            color: white;
                        }

                        .btn-group {
                            gap: 3px;
                        }



                        .filter-body {
                            padding: 15px;
                            background: white;
                        }

                        .quick-search-section {
                            background: #f8f9fa;
                            border-radius: 4px;
                            padding: 12px;
                            margin-bottom: 15px;
                            border: 1px solid #dee2e6;
                        }

                        .form-control {
                            border-radius: 3px;
                            border: 1px solid #dee2e6;
                            padding: 6px 10px;
                            background: white;
                        }

                        .form-select {
                            border-radius: 3px;
                            border: 1px solid #dee2e6;
                            padding: 6px 10px;
                            background: white;
                        }

                        .btn-primary {
                            background: #6c757d;
                            border: 1px solid #6c757d;
                            border-radius: 3px;
                            padding: 6px 12px;
                            font-weight: 500;
                        }

                        .btn-outline-secondary {
                            border-radius: 3px;
                            border: 1px solid #6c757d;
                            padding: 6px 12px;
                        }

                        .input-group-text {
                            background: #f8f9fa;
                            border: 1px solid #dee2e6;
                            border-radius: 3px 0 0 3px;
                            color: #6c757d;
                            font-weight: 500;
                        }

                        .form-label {
                            font-weight: 500;
                            color: #495057;
                            margin-bottom: 6px;
                            font-size: 0.9rem;
                        }

                        /* Search result highlighting */
                        .search-highlight {
                            background: #fff3cd;
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
                            background: #28a745;
                            border: none;
                            border-radius: 4px;
                            padding: 10px 25px;
                            color: white;
                            font-weight: 600;
                        }

                        /* Removed hover effect for export button */

                        .page-title {
                            color: white;
                            font-weight: 700;
                            margin-bottom: 30px;
                        }

                        .animate-fade-in {
                            opacity: 1;
                        }

                        .loading-spinner {
                            display: none;
                            position: fixed;
                            top: 50%;
                            left: 50%;
                            transform: translate(-50%, -50%);
                            z-index: 9999;
                        }

                        /* Fix dropdown menu position */
                        .table-container {
                            background: white;
                            border-radius: 4px;
                            overflow: visible;
                            /* Thay đổi từ hidden thành visible */
                            border: 1px solid #dee2e6;
                        }

                        /* Ensure dropdown menu appears above other elements */
                        .dropdown-menu {
                            z-index: 1050 !important;
                            position: absolute !important;
                            border: 1px solid #e3e6f0 !important;
                            border-radius: 4px !important;
                        }

                        /* Fix table row position */
                        .table tbody tr {
                            position: relative;
                            z-index: 1;
                        }

                        /* Ensure dropdown toggle button has proper z-index */
                        .dropdown-toggle {
                            position: relative;
                            z-index: 2;
                        }

                        /* Fix dropdown menu positioning for last rows */
                        .table tbody tr:nth-last-child(-n+3) .dropdown-menu {
                            transform: translateY(-100%);
                            top: auto;
                            bottom: 100%;
                        }

                        /* Ensure dropdown menu is fully visible */
                        .dropdown {
                            position: static;
                        }

                        .table-responsive {
                            overflow: visible;
                        }

                        .modal-content {
                            border-radius: 4px;
                            border: 1px solid #dee2e6;
                        }

                        .modal-header {
                            background: #6c757d;
                            color: white;
                            border-radius: 4px 4px 0 0;
                        }

                        .action-btn.btn-notification {
                            background: #007bff;
                            color: white;
                            margin-left: 5px;
                        }

                        /* Removed hover effect for notification button */

                        .action-btn.btn-print {
                            background: #17a2b8;
                            color: white;
                            margin-left: 5px;
                        }

                        /* Removed hover effect for print button */
                        /* Enhanced Modal Styles */
                        .bg-gradient-primary {
                            background: #6c757d !important;
                        }

                        .modal-lg {
                            max-width: 800px;
                        }

                        #orderDetailInfo .col-md-6 {
                            margin-bottom: 1rem;
                        }

                        #orderDetailInfo i {
                            width: 20px;
                            text-align: center;
                        }

                        .form-control-lg {
                            font-size: 1rem;
                            padding: 0.75rem 1rem;
                        }

                        .btn-outline-secondary.btn-sm {
                            font-size: 0.8rem;
                            padding: 0.25rem 0.5rem;
                        }

                        .modal-content {
                            border-radius: 15px;
                            overflow: hidden;
                        }

                        .modal-header {
                            border-bottom: none;
                        }

                        .modal-footer {
                            border-top: none;
                        }
                    </style>
                    <style>
                        /* Thêm vào phần <head> hoặc cuối file trước </body> */

                        /* Tooltip styles */
                        .tooltip-cell {
                            position: relative;
                            cursor: pointer;
                            max-width: 200px;
                            overflow: hidden;
                            text-overflow: ellipsis;
                            white-space: nowrap;
                        }

                        .tooltip-cell {
                            overflow: visible;
                            white-space: normal;
                            z-index: 1000;
                        }

                        /* Custom tooltip */
                        .custom-tooltip {
                            position: relative;
                            display: inline-block;
                            cursor: pointer;
                        }

                        .custom-tooltip .tooltip-text {
                            visibility: hidden;
                            width: 300px;
                            background-color: #333;
                            color: #fff;
                            text-align: left;
                            border-radius: 6px;
                            padding: 10px;
                            position: absolute;
                            z-index: 1001;
                            bottom: 125%;
                            left: 50%;
                            margin-left: -150px;
                            opacity: 0;
                            font-size: 12px;
                            line-height: 1.4;
                        }

                        .custom-tooltip .tooltip-text::after {
                            content: "";
                            position: absolute;
                            top: 100%;
                            left: 50%;
                            margin-left: -5px;
                            border-width: 5px;
                            border-style: solid;
                            border-color: #333 transparent transparent transparent;
                        }



                        /* Expandable cell */
                        .expandable-cell {
                            max-width: 200px;
                            overflow: hidden;
                            text-overflow: ellipsis;
                            white-space: nowrap;
                        }

                        /* Table improvements */
                        .table td {
                            vertical-align: middle;
                            position: relative;
                        }

                        .customer-info {
                            max-width: 180px;
                        }



                        /* Status badge improvements */
                        .status-badge {
                            white-space: nowrap;
                            display: inline-flex;
                            align-items: center;
                            gap: 5px;
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
                                    <div class="stats-card">
                                        <div class="d-flex align-items-center">
                                            <div class="flex-grow-1">
                                                <div class="h5 mb-0 font-weight-bold">
                                                    ${statistics.statusCount['Completed']}</div>
                                                <div class="text-uppercase">Hoàn thành</div>
                                            </div>
                                            <div class="fa-2x">
                                                <i class="fas fa-check-circle"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="col-xl-3 col-md-6 mb-4">
                                    <div class="stats-card">
                                        <div class="d-flex align-items-center">
                                            <div class="flex-grow-1">
                                                <div class="h5 mb-0 font-weight-bold">
                                                    ${statistics.statusCount['Pending']}</div>
                                                <div class="text-uppercase">Đang xử lý</div>
                                            </div>
                                            <div class="fa-2x">
                                                <i class="fas fa-clock"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="col-xl-3 col-md-6 mb-4">
                                    <div class="stats-card">
                                        <div class="d-flex align-items-center">
                                            <div class="flex-grow-1">
                                                <div class="h5 mb-0 font-weight-bold">
                                                    ${statistics.statusCount['Cancelled']}</div>
                                                <div class="text-uppercase">Đã hủy</div>
                                            </div>
                                            <div class="fa-2x">
                                                <i class="fas fa-times-circle"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- THÊM PHẦN NÀY: Alert Messages for Search Results -->
                        <c:if test="${not empty successMessage}">
                            <div class="alert alert-success alert-dismissible fade show animate-fade-in" role="alert">
                                <i class="fas fa-check-circle me-2"></i>
                                <strong>Thành công!</strong> ${successMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"
                                    aria-label="Close"></button>
                            </div>
                        </c:if>

                        <c:if test="${not empty warningMessage}">
                            <div class="alert alert-warning alert-dismissible fade show animate-fade-in" role="alert">
                                <i class="fas fa-exclamation-triangle me-2"></i>
                                <strong>Cảnh báo!</strong> ${warningMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"
                                    aria-label="Close"></button>
                            </div>
                        </c:if>

                        <c:if test="${not empty errorMessage}">
                            <div class="alert alert-danger alert-dismissible fade show animate-fade-in" role="alert">
                                <i class="fas fa-times-circle me-2"></i>
                                <strong>Lỗi!</strong> ${errorMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"
                                    aria-label="Close"></button>
                            </div>
                        </c:if>

                        <!-- Search Result Info -->
                        <c:if test="${not empty searchedOrderId}">
                            <div class="alert alert-info alert-dismissible fade show animate-fade-in" role="alert">
                                <i class="fas fa-info-circle me-2"></i>
                                <strong>Kết quả tìm kiếm:</strong> Đang hiển thị kết quả cho mã đơn hàng
                                <strong>#${searchedOrderId}</strong>
                                <a href="orders?action=list" class="alert-link ms-2">
                                    <i class="fas fa-list me-1"></i>Xem tất cả đơn hàng
                                </a>
                                <button type="button" class="btn-close" data-bs-dismiss="alert"
                                    aria-label="Close"></button>
                            </div>
                        </c:if>


                        <!-- Enhanced Filter Section -->
                        <div class="filter-section animate-fade-in">
                            <!-- Filter Header -->
                            <div class="filter-header">
                                <h5 class="mb-0 d-flex align-items-center">
                                    <i class="fas fa-filter me-3"></i>
                                    <span>Bộ lọc tìm kiếm nâng cao</span>
                                    <div class="ms-auto">
                                        <small class="opacity-75">Tìm kiếm và lọc đơn hàng</small>
                                    </div>
                                </h5>
                            </div>

                            <div class="filter-body">
                                <!-- Quick Search Section -->
                                <div class="quick-search-section">
                                    <div class="row align-items-center">
                                        <div class="col-md-3">
                                            <h6 class="mb-0 text-primary">
                                                <i class="fas fa-bolt me-2"></i>Tìm kiếm nhanh
                                            </h6>
                                            <small class="text-muted">Theo mã đơn hàng</small>
                                        </div>
                                        <div class="col-md-9">
                                            <form id="quickSearchForm" method="get" action="orders"
                                                class="d-flex gap-2">
                                                <input type="hidden" name="action" value="quickSearch">
                                                <div class="input-group">
                                                    <span class="input-group-text">
                                                        <i class="fas fa-hashtag"></i>
                                                    </span>
                                                    <input type="text" class="form-control" id="quickOrderId"
                                                        name="quickOrderId"
                                                        placeholder="Nhập mã đơn hàng (VD: 1, 2, 3...)"
                                                        value="${param.quickOrderId}">
                                                    <button class="btn btn-primary" type="submit">
                                                        <i class="fas fa-search me-1"></i>Tìm ngay
                                                    </button>

                                                    <button class="btn btn-warning" type="button"
                                                        onclick="clearQuickSearch()">
                                                        <i class="fas fa-times"></i>
                                                    </button>

                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </div>

                                <!-- Advanced Filter Form -->
                                <form id="filterForm" method="get" action="orders">
                                    <input type="hidden" name="action" value="list">

                                    <div class="row g-4">
                                        <!-- Customer Name -->
                                        <div class="col-md-4">
                                            <label for="customerName" class="form-label">
                                                <i class="fas fa-user me-2 text-primary"></i>Tên khách hàng
                                            </label>
                                            <div class="input-group">
                                                <span class="input-group-text">
                                                    <i class="fas fa-user-circle"></i>
                                                </span>
                                                <input type="text" class="form-control" id="customerName"
                                                    name="customerName" placeholder="Nhập tên khách hàng..."
                                                    value="${fn:escapeXml(param.customerName)}" autocomplete="off">
                                                <button class="btn btn-warning" type="button"
                                                    onclick="clearField('customerName')">
                                                    <i class="fas fa-times"></i>
                                                </button>
                                            </div>
                                        </div>

                                        <!-- Status -->
                                        <div class="col-md-2">
                                            <label for="status" class="form-label">
                                                <i class="fas fa-flag me-2 text-warning"></i>Trạng thái
                                            </label>
                                            <select class="form-select" id="status" name="status">
                                                <option value="">Tất cả trạng thái</option>
                                                <option value="pending" ${param.status=='pending' ? 'selected' : '' }>
                                                    🕐 Chờ xử lý
                                                </option>
                                                <option value="completed" ${param.status=='completed' ? 'selected' : ''
                                                    }>
                                                    ✅ Hoàn thành
                                                </option>
                                                <option value="cancelled" ${param.status=='cancelled' ? 'selected' : ''
                                                    }>
                                                    ❌ Đã hủy
                                                </option>
                                            </select>
                                        </div>

                                        <!-- Date From -->
                                        <div class="col-md-2">
                                            <label for="dateFrom" class="form-label">
                                                <i class="fas fa-calendar-alt me-2 text-success"></i>Từ ngày
                                            </label>
                                            <input type="date" class="form-control" id="dateFrom" name="dateFrom"
                                                value="${param.dateFrom}">
                                        </div>

                                        <!-- Date To -->
                                        <div class="col-md-2">
                                            <label for="dateTo" class="form-label">
                                                <i class="fas fa-calendar-check me-2 text-success"></i>Đến ngày
                                            </label>
                                            <input type="date" class="form-control" id="dateTo" name="dateTo"
                                                value="${param.dateTo}">
                                        </div>

                                        <!-- Action Buttons -->
                                        <div class="col-md-2">
                                            <label class="form-label">&nbsp;</label>
                                            <div class="d-grid gap-2">
                                                <button type="submit" class="btn btn-primary">
                                                    <i class="fas fa-search me-2"></i>Tìm kiếm
                                                </button>
                                                <button type="button" class="btn btn-warning btn-refresh"
                                                    onclick="resetFilters()">
                                                    <i class="fas fa-redo me-2"></i>Làm mới
                                                </button>
                                            </div>
                                        </div>
                                    </div>


                                </form>
                            </div>
                        </div>

                        <!-- Sort Section -->
                        <div class="sort-section-modern mb-4">
                            <div class="sort-container">
                                <div class="sort-header">
                                    <div class="sort-title">
                                        <i class="fas fa-sort-amount-down sort-icon"></i>
                                        <span class="sort-label">Sắp xếp đơn hàng</span>
                                    </div>
                                    <div class="sort-count">
                                        <span class="count-text">Tổng:</span>
                                        <span class="count-badge">${fn:length(orders)} đơn hàng</span>
                                    </div>
                                </div>

                                <div class="sort-buttons-grid">
                                    <button type="button" class="sort-btn-modern" onclick="sortOrders('date_desc')"
                                        data-sort="date_desc">
                                        <div class="btn-icon">
                                            <i class="fas fa-calendar-alt"></i>
                                        </div>
                                        <div class="btn-content">
                                            <span class="btn-title">Mới nhất</span>
                                            <span class="btn-subtitle">Đơn hàng gần đây</span>
                                        </div>
                                    </button>

                                    <button type="button" class="sort-btn-modern" onclick="sortOrders('date_asc')"
                                        data-sort="date_asc">
                                        <div class="btn-icon">
                                            <i class="fas fa-history"></i>
                                        </div>
                                        <div class="btn-content">
                                            <span class="btn-title">Cũ nhất</span>
                                            <span class="btn-subtitle">Đơn hàng cũ trước</span>
                                        </div>
                                    </button>

                                    <button type="button" class="sort-btn-modern" onclick="sortOrders('total_desc')"
                                        data-sort="total_desc">
                                        <div class="btn-icon">
                                            <i class="fas fa-arrow-up"></i>
                                        </div>
                                        <div class="btn-content">
                                            <span class="btn-title">Giá cao</span>
                                            <span class="btn-subtitle">Từ cao đến thấp</span>
                                        </div>
                                    </button>

                                    <button type="button" class="sort-btn-modern" onclick="sortOrders('total_asc')"
                                        data-sort="total_asc">
                                        <div class="btn-icon">
                                            <i class="fas fa-arrow-down"></i>
                                        </div>
                                        <div class="btn-content">
                                            <span class="btn-title">Giá thấp</span>
                                            <span class="btn-subtitle">Từ thấp đến cao</span>
                                        </div>
                                    </button>

                                    <button type="button" class="sort-btn-modern" onclick="sortOrders('status')"
                                        data-sort="status">
                                        <div class="btn-icon">
                                            <i class="fas fa-tasks"></i>
                                        </div>
                                        <div class="btn-content">
                                            <span class="btn-title">Trạng thái</span>
                                            <span class="btn-subtitle">Theo tình trạng</span>
                                        </div>
                                    </button>

                                    <button type="button" class="sort-btn-modern" onclick="sortOrders('order_id')"
                                        data-sort="order_id">
                                        <div class="btn-icon">
                                            <i class="fas fa-hashtag"></i>
                                        </div>
                                        <div class="btn-content">
                                            <span class="btn-title">Mã đơn</span>
                                            <span class="btn-subtitle">Theo ID đơn hàng</span>
                                        </div>
                                    </button>
                                </div>
                            </div>
                        </div>


                        <!-- Orders Table -->
                        <div class="table-container animate-fade-in">
                            <div class="table-responsive">
                                <table class="table mb-0" id="ordersTable">
                                    <thead>
                                        <tr>
                                            <th><i class="fas fa-hashtag me-2"></i>Mã ĐH</th>
                                            <th><i class="fas fa-calendar me-2"></i>Ngày đặt</th>
                                            <th><i class="fas fa-user me-2"></i>Khách hàng</th>
                                            <th><i class="fas fa-money-bill me-2"></i>Tổng tiền</th>
                                            <th><i class="fas fa-shipping-fast me-2"></i>Shipper</th>
                                            <th><i class="fas fa-info-circle me-2"></i>Trạng thái</th>
                                            <th><i class="fas fa-cogs me-2"></i>Thao tác</th>
                                        </tr>
                                    </thead>

                                    <tbody>
                                        <c:forEach items="${orders}" var="order">
                                            <tr data-order-id="${order.orderId}">
                                                <td class="fw-bold">#${order.orderId}</td>
                                                <td class="custom-tooltip">
                                                    <span class="expandable-cell">
                                                        <fmt:formatDate value="${order.orderDate}"
                                                            pattern="dd/MM/yyyy HH:mm" />
                                                    </span>
                                                    <span class="tooltip-text">
                                                        <strong>Thời gian đặt hàng:</strong><br>
                                                        <fmt:formatDate value="${order.orderDate}"
                                                            pattern="EEEE, dd/MM/yyyy 'lúc' HH:mm:ss" />
                                                    </span>
                                                </td>
                                                <td>
                                                    <div class="d-flex align-items-center customer-info">
                                                        <div
                                                            class="avatar-sm bg-primary rounded-circle d-flex align-items-center justify-content-center me-3">
                                                            <i class="fas fa-user text-white"></i>
                                                        </div>
                                                        <div class="custom-tooltip">
                                                            <div class="expandable-cell">
                                                                <div class="fw-bold">${order.fullName}</div>
                                                                <small class="text-muted">${order.email}</small>
                                                            </div>
                                                            <span class="tooltip-text">
                                                                <strong>Thông tin khách hàng:</strong><br>
                                                                <strong>Tên:</strong> ${order.fullName}<br>
                                                                <strong>Email:</strong> ${order.email}<br>
                                                                <strong>Số điện thoại:</strong> ${order.phone}<br>
                                                                <strong>Địa chỉ:</strong> ${order.address}
                                                            </span>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td class="fw-bold text-success custom-tooltip">
                                                    <span class="expandable-cell">
                                                        <fmt:formatNumber value="${order.total}" type="currency"
                                                            currencySymbol="₫" maxFractionDigits="0" />
                                                    </span>
                                                    <span class="tooltip-text">
                                                        <strong>Chi tiết thanh toán:</strong><br>
                                                        <strong>Tổng tiền:</strong>
                                                        <fmt:formatNumber value="${order.total}" type="currency"
                                                            currencySymbol="₫" maxFractionDigits="0" /><br>
                                                        <strong>Phương thức:</strong> ${order.paymentMethod != null ?
                                                        order.paymentMethod : 'Chưa xác định'}
                                                    </span>
                                                </td>
                                                <td class="custom-tooltip">
                                                    <div class="d-flex align-items-center">
                                                        <div class="avatar-sm bg-info rounded-circle d-flex align-items-center justify-content-center me-2">
                                                            <i class="fas fa-shipping-fast text-white"></i>
                                                        </div>
                                                        <div class="expandable-cell">
                                                            <c:choose>
                                                                <c:when test="${order.shipperName != null}">
                                                                    <div class="fw-bold">${order.shipperName}</div>
                                                                    <small class="text-muted">${order.shipperPhone}</small>
                                                                    <div class="text-success mt-1">
                                                                        <i class="fas fa-check-circle"></i> Đã phân công
                                                                    </div>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <div class="text-muted">
                                                                        <i class="fas fa-truck"></i> Tự động phân công
                                                                    </div>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                    </div>
                                                    <c:choose>
                                                        <c:when test="${order.shipperName != null}">
                                                            <span class="tooltip-text">
                                                                <strong>Thông tin shipper:</strong><br>
                                                                <strong>Tên:</strong> ${order.shipperName}<br>
                                                                <strong>Email:</strong> ${order.shipperEmail}<br>
                                                                <strong>Số điện thoại:</strong> ${order.shipperPhone}
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="tooltip-text">
                                                                <strong>Trạng thái shipper:</strong><br>
                                                                Shipper sẽ được tự động phân công khi duyệt đơn hàng.<br>
                                                                Hệ thống sẽ chọn shipper có ít đơn hàng nhất.
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${order.statusId == 1}">
                                                            <span class="status-badge status-pending custom-tooltip">
                                                                <i class="fas fa-clock"></i> Chờ duyệt
                                                                <span class="tooltip-text">
                                                                    <strong>Trạng thái:</strong> Chờ duyệt<br>
                                                                    <strong>Mô tả:</strong> Đơn hàng đang chờ duyệt
                                                                </span>
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${order.statusId == 2}">
                                                            <span class="status-badge status-approved custom-tooltip">
                                                                <i class="fas fa-box"></i> Đã duyệt & đóng gói
                                                                <span class="tooltip-text">
                                                                    <strong>Trạng thái:</strong> Đã duyệt và đóng
                                                                    gói<br>
                                                                    <strong>Mô tả:</strong> Đơn hàng đã được duyệt và
                                                                    đang đóng gói
                                                                </span>
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${order.statusId == 9}">
                                                            <span class="status-badge status-approved custom-tooltip">
                                                                <i class="fas fa-check-circle"></i> Đã duyệt
                                                                <span class="tooltip-text">
                                                                    <strong>Trạng thái:</strong> Đã duyệt<br>
                                                                    <strong>Mô tả:</strong> Đơn hàng đã được staff duyệt
                                                                </span>
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${order.statusId == 3}">
                                                            <span class="status-badge status-shipping custom-tooltip">
                                                                <i class="fas fa-truck"></i> Đang vận chuyển
                                                                <span class="tooltip-text">
                                                                    <strong>Trạng thái:</strong> Đang vận chuyển<br>
                                                                    <strong>Mô tả:</strong> Đơn hàng đang được vận
                                                                    chuyển
                                                                </span>
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${order.statusId == 4}">
                                                            <span class="status-badge status-completed custom-tooltip">
                                                                <i class="fas fa-check"></i> Đã giao thành công
                                                                <span class="tooltip-text">
                                                                    <strong>Trạng thái:</strong> Đã giao hàng thành
                                                                    công<br>
                                                                    <strong>Mô tả:</strong> Đơn hàng đã được giao thành
                                                                    công
                                                                </span>
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${order.statusId == 5}">
                                                            <span class="status-badge status-paid custom-tooltip">
                                                                <i class="fas fa-credit-card"></i> Đã thanh toán
                                                                <span class="tooltip-text">
                                                                    <strong>Trạng thái:</strong> Đã thanh toán thành
                                                                    công<br>
                                                                    <strong>Mô tả:</strong> Đơn hàng đã được thanh toán
                                                                </span>
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${order.statusId == 6}">
                                                            <span class="status-badge status-cancelled custom-tooltip">
                                                                <i class="fas fa-times"></i> Đã hủy
                                                                <span class="tooltip-text">
                                                                    <strong>Trạng thái:</strong> Đã hủy<br>
                                                                    <strong>Mô tả:</strong> Đơn hàng đã bị hủy bỏ
                                                                </span>
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${order.statusId == 7}">
                                                            <span class="status-badge status-approved custom-tooltip">
                                                                <i class="fas fa-paint-brush"></i> Đã duyệt thiết kế
                                                                riêng
                                                                <span class="tooltip-text">
                                                                    <strong>Trạng thái:</strong> Đã duyệt đơn hàng thiết
                                                                    kế riêng<br>
                                                                    <strong>Mô tả:</strong> Đơn hàng thiết kế riêng đã
                                                                    được duyệt
                                                                </span>
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${order.statusId == 8}">
                                                            <span class="status-badge status-cancelled custom-tooltip">
                                                                <i class="fas fa-ban"></i> Thiết kế riêng bị từ chối
                                                                <span class="tooltip-text">
                                                                    <strong>Trạng thái:</strong> Đơn hàng thiết kế riêng
                                                                    bị từ chối<br>
                                                                    <strong>Mô tả:</strong> Đơn hàng thiết kế riêng đã
                                                                    bị từ chối
                                                                </span>
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="status-badge status-unknown custom-tooltip">
                                                                <i class="fas fa-question"></i> ${order.status}
                                                                <span class="tooltip-text">
                                                                    <strong>Trạng thái:</strong> ${order.status}<br>
                                                                    <strong>StatusID:</strong> ${order.statusId}<br>
                                                                    <strong>Mô tả:</strong> Trạng thái không xác định
                                                                </span>
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <div class="d-flex align-items-center">
                                                        <c:if test="${order.statusId == 1}">
                                                            <button class="action-btn btn-approve"
                                                                onclick="updateStatus('${order.orderId}', 2)"
                                                                title="Xác nhận đơn hàng #${order.orderId}">
                                                                <i class="fas fa-check"></i>
                                                            </button>

                                                            <button class="action-btn btn-edit"
                                                                onclick="showCancelModal('${order.orderId}')"
                                                                title="Hủy đơn hàng #${order.orderId}">
                                                                <i class="fas fa-times"></i>
                                                            </button>
                                                        </c:if>

                                                        <button class="action-btn btn-notification"
                                                            onclick="sendNotification('${order.orderId}')"
                                                            title="Gửi thông báo cho khách hàng về đơn hàng #${order.orderId}">
                                                            <i class="fas fa-envelope"></i>
                                                        </button>

                                                        <button class="action-btn btn-print"
                                                            onclick="printOrder('${order.orderId}')"
                                                            title="In hóa đơn cho đơn hàng #${order.orderId}">
                                                            <i class="fas fa-print"></i>
                                                        </button>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>

                                        <c:if test="${empty orders}">
                                            <tr>
                                                <td colspan="7" class="text-center py-5">
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
                                                    <a class="page-link"
                                                        href="?page=${currentPage - 1}&status=${status}&dateFrom=${dateFrom}&dateTo=${dateTo}&customerName=${customerName}">
                                                        <i class="fas fa-chevron-left"></i>
                                                    </a>
                                                </li>
                                            </c:if>

                                            <c:forEach begin="1" end="${totalPages}" var="i">
                                                <li class="page-item ${currentPage == i ? 'active' : ''}">
                                                    <a class="page-link"
                                                        href="?page=${i}&status=${status}&dateFrom=${dateFrom}&dateTo=${dateTo}&customerName=${customerName}">
                                                        ${i}
                                                    </a>
                                                </li>
                                            </c:forEach>

                                            <c:if test="${currentPage < totalPages}">
                                                <li class="page-item">
                                                    <a class="page-link"
                                                        href="?page=${currentPage + 1}&status=${status}&dateFrom=${dateFrom}&dateTo=${dateTo}&customerName=${customerName}">
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
                                    <button type="button" class="btn-close btn-close-white"
                                        data-bs-dismiss="modal"></button>
                                </div>
                                <div class="modal-body" id="orderDetailContent">
                                    <!-- Content will be loaded here -->
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Enhanced Notification Modal -->
                    <!-- Thay thế modal hiện tại (từ dòng 1657) bằng code này -->
                    <div class="modal fade" id="notificationModal" tabindex="-1">
                        <div class="modal-dialog modal-dialog-centered">
                            <div class="modal-content border-0 shadow-lg">
                                <!-- Header với gradient đẹp -->
                                <div class="modal-header bg-gradient text-white border-0">
                                    <h5 class="modal-title d-flex align-items-center mb-0">
                                        <div class="notification-icon me-3">
                                            <i class="fas fa-paper-plane"></i>
                                        </div>
                                        <div>
                                            <div class="fw-bold">Gửi thông báo</div>
                                            <small class="opacity-75">Đơn hàng <span id="orderIdDisplay"
                                                    class="fw-bold"></span></small>
                                        </div>
                                    </h5>
                                    <button type="button" class="btn-close btn-close-white"
                                        data-bs-dismiss="modal"></button>
                                </div>

                                <div class="modal-body p-0">
                                    <!-- Thông tin khách hàng gọn gàng -->
                                    <div class="customer-info-compact">
                                        <div class="customer-card">
                                            <div class="customer-avatar">
                                                <i class="fas fa-user"></i>
                                            </div>
                                            <div class="customer-details">
                                                <div class="customer-name" id="customerName">Đang tải...</div>
                                                <div class="customer-email" id="customerEmail">Đang tải...</div>
                                            </div>
                                            <div class="order-status">
                                                <span id="orderStatus" class="status-badge-compact">Đang tải...</span>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Form nhập tin nhắn -->
                                    <div class="message-form">
                                        <form id="notificationForm">
                                            <input type="hidden" id="notificationOrderId">

                                            <div class="form-group">
                                                <label class="form-label">
                                                    <i class="fas fa-edit me-2"></i>Nội dung thông báo
                                                </label>
                                                <textarea class="form-control message-input" id="notificationMessage"
                                                    rows="4"
                                                    placeholder="Nhập tin nhắn gửi đến khách hàng..."></textarea>
                                            </div>

                                            <!-- Quick templates -->
                                            <div class="quick-templates">
                                                <label class="form-label small text-muted mb-2">
                                                    <i class="fas fa-magic me-1"></i>Mẫu tin nhắn nhanh:
                                                </label>
                                                <div class="template-buttons">
                                                    <button type="button" class="template-btn"
                                                        onclick="setTemplate('approved')">
                                                        Đã duyệt
                                                    </button>
                                                    <button type="button" class="template-btn"
                                                        onclick="setTemplate('shipping')">
                                                        Đang giao
                                                    </button>
                                                    <button type="button" class="template-btn"
                                                        onclick="setTemplate('completed')">
                                                        Hoàn thành
                                                    </button>
                                                    <button type="button" class="template-btn"
                                                        onclick="setTemplate('cancelled')">
                                                        Đã hủy
                                                    </button>
                                                </div>
                                            </div>
                                        </form>
                                    </div>
                                </div>

                                <!-- Footer với buttons đẹp -->
                                <div class="modal-footer border-0 bg-light">
                                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">
                                        <i class="fas fa-times me-1"></i>Hủy
                                    </button>
                                    <button type="button" class="btn btn-primary btn-send"
                                        onclick="sendNotificationEmail()">
                                        <i class="fas fa-paper-plane me-1"></i>Gửi thông báo
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Modal nhập lý do hủy -->
                    <div class="modal fade" id="cancelOrderModal" tabindex="-1">
                        <div class="modal-dialog modal-lg">
                            <div class="modal-content">
                                <div class="modal-header bg-danger text-white">
                                    <h5 class="modal-title"><i class="fas fa-times me-2"></i>Hủy đơn hàng</h5>
                                    <button type="button" class="btn-close btn-close-white"
                                        data-bs-dismiss="modal"></button>
                                </div>
                                <div class="modal-body">
                                    <input type="hidden" id="cancelOrderId">
                                    <input type="hidden" id="cancelOrderPaymentMethod">

                                    <div class="mb-3">
                                        <label class="form-label">Lý do hủy đơn hàng</label>
                                        <textarea class="form-control" id="cancelReason" rows="3"
                                            placeholder="Nhập lý do hủy..."></textarea>
                                    </div>

                                    <!-- Form xin thông tin hoàn tiền cho VNPay -->
                                    <div id="refundInfoSection" class="mt-4" style="display: none;">
                                        <div class="alert alert-warning">
                                            <i class="fas fa-exclamation-triangle me-2"></i>
                                            <strong>Đơn hàng đã thanh toán qua VNPay</strong><br>
                                            Vui lòng gửi tin nhắn cho khách hàng để xin thông tin hoàn tiền.
                                        </div>

                                        <div class="card">
                                            <div class="card-header bg-info text-white">
                                                <h6 class="mb-0"><i class="fas fa-envelope me-2"></i>Mẫu tin nhắn xin thông tin hoàn tiền</h6>
                                            </div>
                                            <div class="card-body">
                                                <textarea class="form-control" id="refundMessageTemplate" rows="8" readonly>Kính chào Quý khách,

Đơn hàng #[ORDER_ID] của Quý khách đã được hủy theo yêu cầu. Do Quý khách đã thanh toán qua VNPay, chúng tôi sẽ tiến hành hoàn tiền cho Quý khách.

Để thực hiện việc hoàn tiền, vui lòng cung cấp thông tin sau:
1. Tên chủ tài khoản ngân hàng
2. Số tài khoản ngân hàng
3. Tên ngân hàng
4. Chi nhánh ngân hàng (nếu có)

Số tiền hoàn: [ORDER_TOTAL]
Thời gian hoàn tiền: 3-5 ngngày làm việc

Xin cảm ơn Quý khách đã tin tưởng sử dụng dịch vụ của chúng tôi.

Trân trọng,
Đội ngũ hỗ trợ khách hàng</textarea>

                                                <div class="mt-3">
                                                    <button type="button" class="btn btn-info btn-sm" onclick="copyRefundMessage()">
                                                        <i class="fas fa-copy me-2"></i>Sao chép tin nhắn
                                                    </button>
                                                    <button type="button" class="btn btn-primary btn-sm ms-2" onclick="sendRefundMessage()">
                                                        <i class="fas fa-paper-plane me-2"></i>Gửi tin nhắn cho khách hàng
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary"
                                        data-bs-dismiss="modal">Đóng</button>
                                    <button type="button" class="btn btn-danger" onclick="confirmCancelOrder()">Xác nhận
                                        hủy</button>
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
                        $(document).ready(function () {
                            let searchTimeout;
                            const searchInput = $('#customerSearchInput');
                            const searchSuggestions = $('#searchSuggestions');
                            const clearButton = $('#clearSearch');

                            // Real-time search suggestions
                            searchInput.on('input', function () {
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
                            clearButton.on('click', function () {
                                searchInput.val('').focus();
                                clearButton.hide();
                                searchSuggestions.hide();
                            });

                            // Hide suggestions when clicking outside
                            $(document).on('click', function (e) {
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
                                    success: function (response) {
                                        displaySearchSuggestions(response.customers, query);
                                    },
                                    error: function () {
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
                            window.selectCustomer = function (customerName) {
                                searchInput.val(customerName);
                                searchSuggestions.hide();

                            };

                            // Quick search functions
                            window.quickSearch = function (type) {
                                const form = $('#filterForm');
                                const today = new Date();

                                // Reset form
                                form.find('input[type="text"], input[type="date"]').val('');
                                form.find('select').val('');

                                switch (type) {
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
                            window.resetFilters = function () {
                                $('#filterForm')[0].reset();
                                clearButton.hide();
                                searchSuggestions.hide();
                                window.location.href = '${pageContext.request.contextPath}/orders';
                            };

                            // Auto-focus search input
                            searchInput.focus();

                            // Keyboard shortcuts
                            $(document).on('keydown', function (e) {
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
                                success: function (response) {
                                    hideLoading();
                                    $('#modalOrderId').text(orderId);
                                    $('#orderDetailContent').html(response);
                                    $('#orderDetailModal').modal('show');
                                },
                                error: function () {
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
                            switch (statusId) {
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
                                        success: function (response) {
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
                                        error: function () {
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

                        // Enhanced Send notification function
                        // Thay thế hàm sendNotification hiện tại (dòng 2034) bằng code này:
                        function sendNotification(orderId) {
                            $('#notificationOrderId').val(orderId);
                            $('#orderIdDisplay').text('#' + orderId);
                            $('#notificationMessage').val('');

                            // Show loading state
                            $('#customerName').text('Đang tải...');
                            $('#customerEmail').text('Đang tải...');
                            $('#orderStatus').text('Đang tải...');

                            // Load customer info
                            $.ajax({
                                url: '${pageContext.request.contextPath}/orders',
                                type: 'GET',
                                data: {
                                    action: 'getOrderDetails',
                                    orderId: orderId
                                },
                                dataType: 'json',
                                success: function (data) {
                                    $('#customerName').text(data.fullName || 'Khách hàng');
                                    $('#customerEmail').text(data.email || 'Chưa có email');

                                    // Debug log
                                    console.log('Status from server:', data.status);
                                    console.log('StatusID from server:', data.statusId);

                                    // Set status with proper mapping
                                    const statusBadge = $('#orderStatus');
                                    let displayStatus = 'Chưa xác định';
                                    let statusClass = 'bg-secondary';

                                    // Map status values từ database (tiếng Việt)
                                    if (data.status) {
                                        const status = data.status.toLowerCase();
                                        if (status.includes('chờ duyệt')) {
                                            displayStatus = 'Chờ duyệt';
                                            statusClass = 'bg-warning text-dark';
                                        } else if (status.includes('đã được duyệt') || status.includes('đóng gói')) {
                                            displayStatus = 'Đã duyệt';
                                            statusClass = 'bg-success';
                                        } else if (status.includes('đang được vận chuyển')) {
                                            displayStatus = 'Đang giao hàng';
                                            statusClass = 'bg-info';
                                        } else if (status.includes('đã giao hàng')) {
                                            displayStatus = 'Hoàn thành';
                                            statusClass = 'bg-success';
                                        } else if (status.includes('đã thanh toán')) {
                                            displayStatus = 'Đã thanh toán';
                                            statusClass = 'bg-success';
                                        } else if (status.includes('đã hủy')) {
                                            displayStatus = 'Đã hủy';
                                            statusClass = 'bg-danger';
                                        } else {
                                            displayStatus = data.status;
                                            statusClass = 'bg-secondary';
                                        }
                                    }

                                    // Set text và class một lần duy nhất
                                    statusBadge.text(displayStatus);
                                    statusBadge.removeClass('bg-warning bg-success bg-danger bg-info bg-secondary text-dark');
                                    statusBadge.addClass(statusClass);
                                },
                                error: function () {
                                    $('#customerName').text('Không thể tải');
                                    $('#customerEmail').text('Không thể tải');
                                    $('#orderStatus').text('Không xác định')
                                        .removeClass('bg-warning bg-success bg-danger bg-info bg-secondary text-dark')
                                        .addClass('bg-secondary');
                                },
                                complete: function () {
                                    $('#notificationModal').modal('show');
                                }
                            });
                        }

                        // Hàm set template tin nhắn nhanh
                        function setTemplate(type) {
                            const templates = {
                                approved: 'Chào bạn! Đơn hàng của bạn đã được duyệt và sẽ sớm được giao đến bạn. Cảm ơn bạn đã tin tưởng chúng tôi!',
                                shipping: 'Đơn hàng của bạn đang được giao đến địa chỉ đã đăng ký. Vui lòng chú ý điện thoại để nhận hàng.',
                                completed: 'Đơn hàng đã được giao thành công! Cảm ơn bạn đã mua sắm tại cửa hàng. Hẹn gặp lại bạn!',
                                cancelled: 'Rất tiếc, đơn hàng của bạn đã bị hủy. Nếu có thắc mắc, vui lòng liên hệ với chúng tôi.'
                            };

                            $('#notificationMessage').val(templates[type] || '');

                            // Remove visual feedback effects
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
                                success: function (response) {
                                    hideLoading();
                                    $('#notificationModal').modal('hide');

                                    Swal.fire({
                                        icon: response.success ? 'success' : 'error',
                                        title: response.success ? 'Thành công!' : 'Lỗi!',
                                        text: response.message
                                    });
                                },
                                error: function () {
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
                            const field = document.getElementById(fieldId);
                            field.value = '';
                            field.focus();

                            // Focus field
                            field.focus();
                        }
                        function resetFilters() {
                            const form = document.getElementById('filterForm');
                            form.reset();

                            // Clear URL parameters
                            const url = new URL(window.location);
                            url.search = '';
                            window.history.replaceState({}, '', url);

                            // Add visual feedback
                            const resetBtn = event.target;
                            resetBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Đang làm mới...';

                            setTimeout(() => {
                                window.location.href = 'orders?action=list';
                            }, 500);
                        }


                        function clearQuickSearch() {
                            const field = document.getElementById('quickOrderId');
                            field.value = '';
                            field.focus();

                            // Remove from URL
                            const url = new URL(window.location);
                            url.searchParams.delete('quickOrderId');
                            url.searchParams.delete('action');
                            window.history.replaceState({}, '', url);
                        }

                        // Xử lý Enter key cho quick search
                        document.getElementById('quickOrderId').addEventListener('keypress', function (e) {
                            if (e.key === 'Enter') {
                                e.preventDefault();
                                document.getElementById('quickSearchForm').submit();
                            }
                        });

                        // Validation cho quick search - chỉ cho phép số
                        document.getElementById('quickOrderId').addEventListener('input', function (e) {
                            let value = e.target.value;
                            // Chỉ cho phép số
                            e.target.value = value.replace(/[^0-9]/g, '');
                        });
                        // Auto-submit on date change
                        document.addEventListener('DOMContentLoaded', function () {
                            const dateInputs = document.querySelectorAll('input[type="date"]');
                            dateInputs.forEach(input => {
                                input.addEventListener('change', function () {
                                    // Update border color
                            this.style.borderColor = '#28a745';
                                });
                            });

                            // Enhanced form validation
                            const form = document.getElementById('filterForm');
                            form.addEventListener('submit', function (e) {
                                const dateFrom = document.getElementById('dateFrom').value;
                                const dateTo = document.getElementById('dateTo').value;
                                const customerName = document.getElementById('customerName');

                                // Trim customer name before submission
                                if (customerName && customerName.value) {
                                    customerName.value = customerName.value.trim();
                                }

                                if (dateFrom && dateTo && new Date(dateFrom) > new Date(dateTo)) {
                                    e.preventDefault();
                                    Swal.fire({
                                        icon: 'warning',
                                        title: 'Lỗi ngày tháng',
                                        text: 'Ngày bắt đầu không thể lớn hơn ngày kết thúc!',
                                        confirmButtonColor: '#667eea'
                                    });
                                }
                            });
                        });
                        // Sort functionality
                        // Enhanced Active Button Management
                        function updateActiveSortButton() {
                            const urlParams = new URLSearchParams(window.location.search);
                            const currentSort = urlParams.get('sortBy') || 'date_desc';

                            document.querySelectorAll('.sort-btn').forEach(btn => {
                                btn.classList.remove('active');
                                if (btn.getAttribute('data-sort') === currentSort) {
                                    btn.classList.add('active');
                                }
                            });
                        }

                        // Enhanced Table Display
                        function animateTableEntrance() {
                            const rows = document.querySelectorAll('#ordersTable tbody tr');
                            rows.forEach((row, index) => {
                                row.style.opacity = '1';
                                row.style.transform = 'translateY(0)';
                            });
                        }

                        // Enhanced Loading States
                        function showSortLoading() {
                            const sortSection = document.querySelector('.sort-section');
                            if (sortSection) {
                                sortSection.classList.add('loading-state');
                            }
                        }

                        function hideSortLoading() {
                            const sortSection = document.querySelector('.sort-section');
                            if (sortSection) {
                                sortSection.classList.remove('loading-state');
                            }
                        }

                        // Enhanced DOMContentLoaded with Improved Initialization
                        document.addEventListener('DOMContentLoaded', function () {
                            // Initialize sort state
                            updateActiveSortButton();

                            // Animate table entrance
                            setTimeout(animateTableEntrance, 100);

                            // Enhanced dropdown initialization
                            const dropdownElementList = [].slice.call(document.querySelectorAll('.dropdown-toggle'));
                            const dropdownList = dropdownElementList.map(function (dropdownToggleEl) {
                                return new bootstrap.Dropdown(dropdownToggleEl);
                            });

                            // Initialize sort buttons
                            document.querySelectorAll('.sort-btn').forEach(btn => {
                                // Remove any existing styles
                                btn.style.transform = '';
                                btn.style.boxShadow = '';
                            });

                            // Initialize table rows
                            const tableRows = document.querySelectorAll('#ordersTable tbody tr');
                            tableRows.forEach(row => {
                                // Remove any existing styles
                                row.style.backgroundColor = '';
                                row.style.transform = '';
                                row.style.boxShadow = '';
                                row.style.zIndex = '';
                            });
                        });


                        // Highlight current sort button on page load
                        document.addEventListener('DOMContentLoaded', function () {
                            const urlParams = new URLSearchParams(window.location.search);
                            const currentSort = urlParams.get('sortBy') || 'date_desc';

                            document.querySelectorAll('.sort-btn').forEach(btn => {
                                if (btn.getAttribute('data-sort') === currentSort) {
                                    btn.classList.add('active');
                                }
                            });
                        });
                        // Initialize sort state on page load
                        document.addEventListener('DOMContentLoaded', function () {
                            const urlParams = new URLSearchParams(window.location.search);
                            const currentSort = urlParams.get('sortBy') || 'date_desc';

                            // Update dropdown text and active state
                            const sortTexts = {
                                'date_desc': 'Mới nhất trước',
                                'date_asc': 'Cũ nhất trước',
                                'total_desc': 'Tổng tiền: Cao → Thấp',
                                'total_asc': 'Tổng tiền: Thấp → Cao',
                                'status': 'Theo trạng thái',
                                'order_id': 'Theo mã đơn hàng'
                            };


                            document.querySelector(`[data-sort="${currentSort}"]`)?.classList.add('active');

                            const sortDropdown = document.getElementById('sortDropdown');
                            if (sortDropdown) {
                                sortDropdown.addEventListener('click', function () {
                                    this.classList.add('sort-indicator');
                                    setTimeout(() => this.classList.remove('sort-indicator'), 500);
                                });
                            }
                        });

                        // Enhanced table display
                        function animateTableUpdate() {
                            const rows = document.querySelectorAll('#ordersTable tbody tr');
                            rows.forEach((row, index) => {
                                row.style.opacity = '1';
                                row.style.transform = 'translateY(0)';
                            });
                        }

                        document.addEventListener('DOMContentLoaded', function () {
                            // Đảm bảo Bootstrap dropdown được khởi tạo
                            const dropdownElementList = [].slice.call(document.querySelectorAll('.dropdown-toggle'));
                            const dropdownList = dropdownElementList.map(function (dropdownToggleEl) {
                                return new bootstrap.Dropdown(dropdownToggleEl);
                            });

                            console.log('Bootstrap dropdowns initialized:', dropdownList.length);
                        });

                        // Cải thiện tooltip positioning
                        document.addEventListener('DOMContentLoaded', function () {
                            const tooltips = document.querySelectorAll('.custom-tooltip');

                            tooltips.forEach(tooltip => {
                                const tooltipText = tooltip.querySelector('.tooltip-text');
                                if (tooltipText) {
                                    tooltip.addEventListener('mouseenter', function () {
                                        // Adjust tooltip position if it goes off screen
                                        const rect = tooltipText.getBoundingClientRect();
                                        const viewportWidth = window.innerWidth;

                                        if (rect.right > viewportWidth) {
                                            tooltipText.style.left = 'auto';
                                            tooltipText.style.right = '0';
                                            tooltipText.style.marginLeft = '0';
                                        }

                                        if (rect.left < 0) {
                                            tooltipText.style.left = '0';
                                            tooltipText.style.marginLeft = '0';
                                        }
                                    });
                                }
                            });

                            // Add click to expand functionality for mobile
                            const expandableCells = document.querySelectorAll('.expandable-cell');
                            expandableCells.forEach(cell => {
                                cell.addEventListener('click', function () {
                                    this.classList.toggle('expanded');
                                });
                            });
                        });

                        // Initialize table rows
                        const tableRows = document.querySelectorAll('#ordersTable tbody tr');
                        tableRows.forEach(row => {
                            // Remove any existing styles
                            row.style.backgroundColor = '';
                            row.style.transform = '';
                            row.style.boxShadow = '';
                        });
                        // ===== SORT HIGHLIGHT FUNCTIONALITY =====

                        // Initialize sort highlighting when page loads
                        document.addEventListener('DOMContentLoaded', function () {
                            initializeSortHighlight();
                        });

                        function initializeSortHighlight() {
                            // Tìm tất cả sort buttons với class đúng
                            const sortButtons = document.querySelectorAll('.sort-btn-modern');

                            // Get current sort from URL
                            const urlParams = new URLSearchParams(window.location.search);
                            const currentSort = urlParams.get('sortBy') || 'date_desc';

                            // Highlight current sort button
                            sortButtons.forEach(btn => {
                                const sortType = btn.getAttribute('data-sort');

                                // Remove any existing highlights
                                btn.classList.remove('highlighted');

                                // Add highlight to current sort
                                if (sortType === currentSort) {
                                    btn.classList.add('highlighted');
                                    // Remove animation effects
                                    btn.style.animation = '';
                                }

                                // Add click handler
                                btn.addEventListener('click', function (e) {
                                    // Remove highlight from all buttons
                                    sortButtons.forEach(b => b.classList.remove('highlighted'));

                                    // Add highlight to clicked button
                                    this.classList.add('highlighted');

                                    // Add ripple effect
                                    addRippleEffect(this, e);
                                });

                                // Remove hover effects
                                btn.style.transform = '';
                                btn.style.boxShadow = '';
                            });
                        }

                        // Highlight the current active sort button
                        function highlightCurrentSortButton() {
                            // Get current sort from URL parameters
                            const urlParams = new URLSearchParams(window.location.search);
                            const currentSort = urlParams.get('sortBy') || 'date_desc';

                            // Remove highlight from all sort buttons
                            document.querySelectorAll('.sort-btn').forEach(btn => {
                                btn.classList.remove('highlighted');
                            });

                            // Add highlight to current sort button
                            const currentSortBtn = document.querySelector(`[data-sort="${currentSort}"]`);
                            if (currentSortBtn) {
                                currentSortBtn.classList.add('highlighted');

                                // Remove animation
                                currentSortBtn.style.animation = '';
                            }
                        }

                        // Add click handlers to sort buttons
                        function addSortButtonHandlers() {
                            document.querySelectorAll('.sort-btn').forEach(btn => {
                                btn.addEventListener('click', function (e) {
                                    // Remove highlight from all buttons
                                    document.querySelectorAll('.sort-btn').forEach(b => {
                                        b.classList.remove('highlighted');
                                    });

                                    // Add highlight to clicked button
                                    this.classList.add('highlighted');
                                });

                                // Remove hover effects
                                btn.style.transform = '';
                                btn.style.boxShadow = '';
                            });
                        }

                        // Remove ripple effect function
                        function addRippleEffect(button, event) {
                            // No ripple effect
                        }

                        // Enhanced sortOrders function with highlight
                        function sortOrders(sortType) {
                            // Show loading state on clicked button
                            const clickedButton = document.querySelector(`[data-sort="${sortType}"]`);
                            if (clickedButton) {
                                const originalContent = clickedButton.innerHTML;
                                clickedButton.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Đang sắp xếp...';
                                clickedButton.disabled = true;

                                // Add loading class
                                clickedButton.classList.add('loading');
                            }

                            const urlParams = new URLSearchParams(window.location.search);
                            urlParams.set('sortBy', sortType);
                            urlParams.set('page', '1');

                            // Direct navigation
                            window.location.search = urlParams.toString();
                        }

                        // Remove CSS animations
                        const sortHighlightStyle = document.createElement('style');
                        sortHighlightStyle.textContent = `
    .sort-btn.loading {
        opacity: 0.7;
        pointer-events: none;
    }
`;
                        document.head.appendChild(sortHighlightStyle);

                        function showCancelModal(orderId) {
                            document.getElementById('cancelOrderId').value = orderId;
                            document.getElementById('cancelReason').value = '';

                            // Tìm thông tin đơn hàng để kiểm tra phương thức thanh toán
                            const orderRow = document.querySelector(`tr[data-order-id="${orderId}"]`);
                            let paymentMethod = '';
                            let orderTotal = '';

                            if (orderRow) {
                                // Lấy thông tin từ tooltip của cột tổng tiền
                                const totalCell = orderRow.querySelector('.fw-bold.text-success.custom-tooltip .tooltip-text');
                                if (totalCell) {
                                    const tooltipText = totalCell.textContent;
                                    // Tìm phương thức thanh toán trong tooltip
                                    const paymentMatch = tooltipText.match(/Phương thức:\s*([^<\n]+)/);
                                    if (paymentMatch) {
                                        paymentMethod = paymentMatch[1].trim();
                                    }

                                    // Lấy tổng tiền
                                    const totalMatch = tooltipText.match(/Tổng tiền:\s*([^<\n]+)/);
                                    if (totalMatch) {
                                        orderTotal = totalMatch[1].trim();
                                    }
                                }
                            }

                            document.getElementById('cancelOrderPaymentMethod').value = paymentMethod;

                            // Hiển thị form hoàn tiền nếu thanh toán bằng VNPay
                            const refundSection = document.getElementById('refundInfoSection');
                            if (paymentMethod && paymentMethod.toLowerCase().includes('vnpay')) {
                                refundSection.style.display = 'block';

                                // Cập nhật template tin nhắn với thông tin đơn hàng
                                const template = document.getElementById('refundMessageTemplate');
                                let message = template.value;
                                message = message.replace('[ORDER_ID]', orderId);
                                message = message.replace('[ORDER_TOTAL]', orderTotal || 'Đang cập nhật...');
                                template.value = message;
                            } else {
                                refundSection.style.display = 'none';
                            }

                            var modal = new bootstrap.Modal(document.getElementById('cancelOrderModal'));
                            modal.show();
                        }
                        function confirmCancelOrder() {
                            var orderId = document.getElementById('cancelOrderId').value;
                            var reason = document.getElementById('cancelReason').value.trim();
                            var paymentMethod = document.getElementById('cancelOrderPaymentMethod').value;

                            if (!reason) {
                                Swal.fire({ icon: 'warning', title: 'Vui lòng nhập lý do hủy đơn!' });
                                return;
                            }

                            // Nếu thanh toán bằng VNPay, nhắc nhở admin gửi tin nhắn hoàn tiền
                            if (paymentMethod && paymentMethod.toLowerCase().includes('vnpay')) {
                                Swal.fire({
                                    title: 'Lưu ý quan trọng!',
                                    html: `
                                        <div class="text-start">
                                            <p><i class="fas fa-exclamation-triangle text-warning me-2"></i>Đơn hàng này đã thanh toán qua <strong>VNPay</strong></p>
                                            <p><i class="fas fa-info-circle text-info me-2"></i>Vui lòng nhớ gửi tin nhắn xin thông tin hoàn tiền cho khách hàng</p>
                                            <p><i class="fas fa-clock text-secondary me-2"></i>Thời gian hoàn tiền: 3-5 ngày làm việc</p>
                                        </div>
                                    `,
                                    icon: 'warning',
                                    showCancelButton: true,
                                    confirmButtonText: 'Đã hiểu, tiếp tục hủy',
                                    cancelButtonText: 'Quay lại',
                                    confirmButtonColor: '#dc3545'
                                }).then((result) => {
                                    if (result.isConfirmed) {
                                        updateStatus(orderId, 6, reason);
                                        var modal = bootstrap.Modal.getInstance(document.getElementById('cancelOrderModal'));
                                        modal.hide();
                                    }
                                });
                            } else {
                                updateStatus(orderId, 6, reason);
                                var modal = bootstrap.Modal.getInstance(document.getElementById('cancelOrderModal'));
                                modal.hide();
                            }
                        }

                        // Function sao chép tin nhắn hoàn tiền
                        function copyRefundMessage() {
                            const template = document.getElementById('refundMessageTemplate');
                            template.select();
                            template.setSelectionRange(0, 99999); // For mobile devices

                            try {
                                document.execCommand('copy');
                                Swal.fire({
                                    icon: 'success',
                                    title: 'Đã sao chép!',
                                    text: 'Tin nhắn đã được sao chép vào clipboard',
                                    timer: 2000,
                                    showConfirmButton: false
                                });
                            } catch (err) {
                                Swal.fire({
                                    icon: 'error',
                                    title: 'Lỗi!',
                                    text: 'Không thể sao chép tin nhắn'
                                });
                            }
                        }

                        // Function gửi tin nhắn hoàn tiền cho khách hàng
                        function sendRefundMessage() {
                            const orderId = document.getElementById('cancelOrderId').value;
                            const message = document.getElementById('refundMessageTemplate').value;

                            // Mở modal gửi thông báo với tin nhắn hoàn tiền đã điền sẵn
                            document.getElementById('notificationOrderId').value = orderId;
                            document.getElementById('notificationMessage').value = message;

                            // Đóng modal hủy đơn hàng
                            var cancelModal = bootstrap.Modal.getInstance(document.getElementById('cancelOrderModal'));
                            cancelModal.hide();

                            // Mở modal gửi thông báo
                            setTimeout(() => {
                                var notificationModal = new bootstrap.Modal(document.getElementById('notificationModal'));
                                notificationModal.show();
                            }, 300);
                        }
                        // Sửa hàm updateStatus để nhận thêm lý do hủy (nếu có)
                        function updateStatus(orderId, statusId, cancelReason) {
                            let statusText = '';
                            switch (statusId) {
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
                                            statusId: statusId,
                                            cancelReason: cancelReason || ''
                                        },
                                        success: function (response) {
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
                                        error: function () {
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







                    </script>
                </body>

                </html>