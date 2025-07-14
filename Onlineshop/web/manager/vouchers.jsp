<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản Lý Voucher</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <style>
            .main-content {
                background-color: #f8f9fa;
                min-height: 100vh;
                padding: 20px;
            }

            .header-card {
                background: white;
                border-radius: 15px;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                padding: 20px;
                margin-bottom: 20px;
            }

            .search-filter-card {
                background: white;
                border-radius: 15px;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                padding: 20px;
                margin-bottom: 20px;
            }

            .voucher-table {
                background: white;
                border-radius: 15px;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                overflow: hidden;
            }

            .table th {
                background: #4f63d2;
                color: white;
                border: none;
                font-weight: 600;
                padding: 15px 10px;
                text-align: center;
                font-size: 14px;
            }

            .table td {
                padding: 12px 10px;
                vertical-align: middle;
                border-color: #e9ecef;
                text-align: center;
                font-size: 13px;
            }

            .status-badge {
                padding: 4px 8px;
                border-radius: 12px;
                font-size: 11px;
                font-weight: 500;
                text-align: center;
                display: inline-block;
                min-width: 70px;
            }

            .status-active {
                background: #d4edda;
                color: #155724;
            }

            .status-expired {
                background: #f8d7da;
                color: #721c24;
            }

            .status-pending {
                background: #fff3cd;
                color: #856404;
            }

            .btn-action {
                padding: 8px 12px;
                margin: 0 3px;
                border-radius: 8px;
                border: none;
                font-size: 12px;
                min-width: 36px;
                height: 36px;
                transition: all 0.3s ease;
                display: inline-flex;
                align-items: center;
                justify-content: center;
            }

            .btn-view {
                background: #4f63d2;
                color: white;
                box-shadow: 0 2px 4px rgba(79, 99, 210, 0.3);
            }

            .btn-view:hover {
                background: #3d4fb8;
                transform: translateY(-1px);
                box-shadow: 0 4px 8px rgba(79, 99, 210, 0.4);
                color: white;
            }

            .btn-edit {
                background: #4f63d2;
                color: white;
                box-shadow: 0 2px 4px rgba(79, 99, 210, 0.3);
            }

            .btn-edit:hover {
                background: #3d4fb8;
                transform: translateY(-1px);
                box-shadow: 0 4px 8px rgba(79, 99, 210, 0.4);
                color: white;
            }

            .action-buttons {
                display: flex;
                justify-content: center;
                align-items: center;
                gap: 8px;
            }

            .btn-toggle {
                background: #ffc107;
                color: #212529;
            }

            .modal-header {
                background: #4f63d2;
                color: white;
            }

            .form-control:focus {
                border-color: #4f63d2;
                box-shadow: 0 0 0 0.2rem rgba(79, 99, 210, 0.25);
            }

            .btn-primary {
                background-color: #4f63d2;
                border-color: #4f63d2;
            }

            .btn-primary:hover {
                background-color: #3d4fb8;
                border-color: #3d4fb8;
            }

            .voucher-code {
                font-weight: bold;
                color: #4f63d2;
            }

            .currency {
                color: #dc3545;
                font-weight: 500;
            }

            .date-range {
                font-size: 11px;
                color: #6c757d;
            }

            .usage-info {
                font-size: 11px;
                color: #6c757d;
            }

            .search-input {
                border-radius: 25px;
                padding-left: 45px;
            }

            .search-icon {
                position: absolute;
                left: 15px;
                top: 50%;
                transform: translateY(-50%);
                color: #6c757d;
            }

            .filter-section {
                background: #f8f9fa;
                border-radius: 10px;
                padding: 15px;
                margin-top: 15px;
            }

            .no-results {
                text-align: center;
                padding: 50px;
                color: #6c757d;
            }

            .results-info {
                color: #6c757d;
                font-size: 14px;
                margin-bottom: 15px;
            }

            .clear-filters {
                color: #dc3545;
                cursor: pointer;
                text-decoration: none;
                font-size: 14px;
            }

            .clear-filters:hover {
                text-decoration: underline;
            }
        </style>
    </head>
    <body>
        <!-- Include sidebar -->
        <jsp:include page="../manager_topbarsidebar.jsp" />

        <div class="main-content">
            <!-- Header -->
            <div class="header-card">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h4 class="mb-1"><i class="fas fa-ticket-alt me-2"></i>Quản Lý Voucher</h4>
                        <p class="text-muted mb-0">Quản lý mã giảm giá và khuyến mãi</p>
                    </div>
                    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addVoucherModal">
                        <i class="fas fa-plus me-2"></i>Thêm Voucher mới
                    </button>
                </div>
            </div>

            <!-- Search and Filter Section -->
            <div class="search-filter-card">
                <div class="row">
                    <div class="col-md-6">
                        <div class="position-relative">
                            <i class="fas fa-search search-icon"></i>
                            <input type="text" id="searchInput" class="form-control search-input" 
                                   placeholder="Tìm kiếm theo mã voucher, mô tả...">
                        </div>
                    </div>
                    <div class="col-md-6">
                        <button class="btn btn-outline-primary" type="button" data-bs-toggle="collapse" 
                                data-bs-target="#filterSection" aria-expanded="false">
                            <i class="fas fa-filter me-2"></i>Bộ lọc nâng cao
                        </button>
                        <span class="clear-filters ms-3" onclick="clearAllFilters()">
                            <i class="fas fa-times me-1"></i>Xóa bộ lọc
                        </span>
                    </div>
                </div>

                <!-- Advanced Filters -->
                <div class="collapse" id="filterSection">
                    <div class="filter-section">
                        <div class="row">
                            <div class="col-md-3">
                                <label class="form-label">Trạng thái</label>
                                <select id="statusFilter" class="form-select">
                                    <option value="">Tất cả trạng thái</option>
                                    <option value="active">Hoạt động</option>
                                    <option value="expired">Hết hạn</option>
                                    <option value="pending">Chưa hiệu lực</option>
                                    <option value="disabled">Vô hiệu hóa</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Giảm giá từ (VNĐ)</label>
                                <input type="number" id="minDiscountFilter" class="form-control" 
                                       placeholder="0" min="0" step="1000">
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Giảm giá đến (VNĐ)</label>
                                <input type="number" id="maxDiscountFilter" class="form-control" 
                                       placeholder="Không giới hạn" min="0" step="1000">
                            </div>
                        </div>
                        <div class="row mt-3">
                            <div class="col-md-4">
                                <label class="form-label">Từ ngày tạo</label>
                                <input type="date" id="fromDateFilter" class="form-control">
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">Đến ngày tạo</label>
                                <input type="date" id="toDateFilter" class="form-control">
                            </div>
                        </div>
                    </div>
                </div>
                <!-- Results Info -->
                <div class="results-info mt-3" id="resultsInfo">
                    Hiển thị <span id="currentResults">0</span> / <span id="totalResults">0</span> voucher
                </div>
            </div>

            <!-- Alert Messages -->
            <c:if test="${not empty sessionScope.message}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    ${sessionScope.message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <c:remove var="message" scope="session"/>
            </c:if>

            <c:if test="${not empty sessionScope.error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    ${sessionScope.error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <c:remove var="error" scope="session"/>
            </c:if>

            <!-- Voucher Table -->
            <div class="voucher-table">
                <table class="table table-hover mb-0" id="voucherTable">
                    <thead>
                        <tr>
                            <th style="width: 5%;">ID</th>
                            <th style="width: 12%;">Mã Voucher</th>
                            <th style="width: 10%;">Giảm giá</th>
                            <th style="width: 10%;">Đơn tối thiểu</th>
                            <th style="width: 18%;">Thời gian hiệu lực</th>
                            <th style="width: 10%;">Ngày tạo</th>
                            <th style="width: 8%;">Trạng thái</th>
                            <th style="width: 12%;">Đã dùng/Giới hạn</th>
                            <th style="width: 15%;">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody id="voucherTableBody">
                        <c:forEach var="voucher" items="${vouchers}" varStatus="status">
                            <tr class="voucher-row" 
                                data-id="${voucher.voucherId}"
                                data-code="${voucher.code}"
                                data-description="${voucher.description}"
                                data-discount="${voucher.discountAmount}"
                                data-min-order="${voucher.minOrderValue}"
                                data-usage-limit="${voucher.usageLimit}"
                                data-used-count="${voucher.usedCount}"
                                data-start-date="<fmt:formatDate value='${voucher.startDate}' pattern='yyyy-MM-dd'/>"
                                data-end-date="<fmt:formatDate value='${voucher.endDate}' pattern='yyyy-MM-dd'/>"
                                data-created-date="<fmt:formatDate value='${voucher.createdDate}' pattern='yyyy-MM-dd'/>"
                                data-status="${voucher.expired ? 'expired' : (voucher.notStarted ? 'pending' : (voucher.active ? 'active' : 'disabled'))}">
                                <td>${voucher.voucherId}</td>
                                <td>
                                    <span class="voucher-code">${voucher.code}</span>
                                </td>
                                <td>
                                    <span class="currency">
                                        <fmt:formatNumber value="${voucher.discountAmount}" type="currency" 
                                                          currencySymbol="₫" groupingUsed="true"/>
                                    </span>
                                </td>
                                <td>
                                    <span class="currency">
                                        <fmt:formatNumber value="${voucher.minOrderValue}" type="currency" 
                                                          currencySymbol="₫" groupingUsed="true"/>
                                    </span>
                                </td>
                                <td>
                                    <div class="date-range">
                                        <fmt:formatDate value="${voucher.startDate}" pattern="dd/MM/yyyy HH:mm"/> - 
                                        <fmt:formatDate value="${voucher.endDate}" pattern="dd/MM/yyyy HH:mm"/>
                                    </div>
                                </td>
                                <td>
                                    <div class="date-range">
                                        <fmt:formatDate value="${voucher.createdDate}" pattern="dd/MM/yyyy HH:mm"/>
                                    </div>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${voucher.expired}">
                                            <span class="status-badge status-expired">Hết hạn</span>
                                        </c:when>
                                        <c:when test="${voucher.notStarted}">
                                            <span class="status-badge status-pending">Chưa hiệu lực</span>
                                        </c:when>
                                        <c:when test="${voucher.active}">
                                            <span class="status-badge status-active">Hoạt động</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-badge status-expired">Vô hiệu hóa</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <div class="usage-info">
                                        ${voucher.usedCount}/${voucher.usageLimit}
                                    </div>
                                </td>
                                <td>
                                    <div class="action-buttons">
                                        <button class="btn btn-action btn-view" onclick="viewVoucher(${voucher.voucherId})" 
                                                title="Xem chi tiết">
                                            <i class="fas fa-eye"></i>
                                        </button>
                                        <button class="btn btn-action btn-edit" onclick="editVoucher(${voucher.voucherId})" 
                                                title="Chỉnh sửa">
                                            <i class="fas fa-edit"></i>
                                        </button>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <!-- No Results Message -->
                <div id="noResults" class="no-results" style="display: none;">
                    <i class="fas fa-search fa-3x mb-3"></i>
                    <h5>Không tìm thấy voucher nào</h5>
                    <p>Thử thay đổi từ khóa tìm kiếm hoặc bộ lọc</p>
                </div>
            </div>
        </div>

        <!-- Add Voucher Modal -->
        <div class="modal fade" id="addVoucherModal" tabindex="-1">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Thêm Voucher Mới</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <form action="vouchers" method="post">
                        <input type="hidden" name="action" value="add">
                        <div class="modal-body">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label class="form-label">Mã Voucher <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control" name="code" required 
                                               placeholder="VD: SALE2025">
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label class="form-label">Số tiền giảm (VNĐ) <span class="text-danger">*</span></label>
                                        <input type="number" class="form-control" name="discountAmount" required 
                                               min="1000" step="1000" placeholder="50000">
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label class="form-label">Đơn tối thiểu (VNĐ) <span class="text-danger">*</span></label>
                                        <input type="number" class="form-control" name="minOrderValue" required 
                                               min="0" step="1000" placeholder="200000">
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label class="form-label">Giới hạn sử dụng <span class="text-danger">*</span></label>
                                        <input type="number" class="form-control" name="usageLimit" required 
                                               min="1" placeholder="100">
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label class="form-label">Ngày bắt đầu <span class="text-danger">*</span></label>
                                        <input type="datetime-local" class="form-control" name="startDate" required>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label class="form-label">Ngày kết thúc <span class="text-danger">*</span></label>
                                        <input type="datetime-local" class="form-control" name="endDate" required>
                                    </div>
                                </div>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Mô tả</label>
                                <textarea class="form-control" name="description" rows="3" 
                                          placeholder="Mô tả về voucher..."></textarea>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                            <button type="submit" class="btn btn-primary">Thêm Voucher</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Edit Voucher Modal -->
        <div class="modal fade" id="editVoucherModal" tabindex="-1">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Chỉnh Sửa Voucher</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <form action="vouchers" method="post">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="id" id="editVoucherId">
                        <div class="modal-body">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label class="form-label">Mã Voucher <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control" name="code" id="editCode" required>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label class="form-label">Số tiền giảm (VNĐ) <span class="text-danger">*</span></label>
                                        <input type="number" class="form-control" name="discountAmount" id="editDiscountAmount" 
                                               required min="1000" step="1000">
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label class="form-label">Đơn tối thiểu (VNĐ) <span class="text-danger">*</span></label>
                                        <input type="number" class="form-control" name="minOrderValue" id="editMinOrderValue" 
                                               required min="0" step="1000">
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label class="form-label">Giới hạn sử dụng <span class="text-danger">*</span></label>
                                        <input type="number" class="form-control" name="usageLimit" id="editUsageLimit" 
                                               required min="1">
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label class="form-label">Ngày bắt đầu <span class="text-danger">*</span></label>
                                        <input type="datetime-local" class="form-control" name="startDate" id="editStartDate" required>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label class="form-label">Ngày kết thúc <span class="text-danger">*</span></label>
                                        <input type="datetime-local" class="form-control" name="endDate" id="editEndDate" required>
                                    </div>
                                </div>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Mô tả</label>
                                <textarea class="form-control" name="description" id="editDescription" rows="3"></textarea>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                            <button type="submit" class="btn btn-primary">Cập Nhật</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- View Voucher Modal -->
        <div class="modal fade" id="viewVoucherModal" tabindex="-1">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Chi Tiết Voucher</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div class="row">
                            <div class="col-md-6">
                                <p><strong>ID:</strong> <span id="viewVoucherId"></span></p>
                                <p><strong>Mã Voucher:</strong> <span id="viewCode" class="voucher-code"></span></p>
                                <p><strong>Số tiền giảm:</strong> <span id="viewDiscountAmount" class="currency"></span></p>
                                <p><strong>Đơn tối thiểu:</strong> <span id="viewMinOrderValue" class="currency"></span></p>
                            </div>
                            <div class="col-md-6">
                                <p><strong>Giới hạn sử dụng:</strong> <span id="viewUsageLimit"></span></p>
                                <p><strong>Đã sử dụng:</strong> <span id="viewUsedCount"></span></p>
                                <p><strong>Trạng thái:</strong> <span id="viewStatus"></span></p>
                                <p><strong>Ngày tạo:</strong> <span id="viewCreatedDate"></span></p>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <p><strong>Ngày bắt đầu:</strong> <span id="viewStartDate"></span></p>
                            </div>
                            <div class="col-md-6">
                                <p><strong>Ngày kết thúc:</strong> <span id="viewEndDate"></span></p>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-12">
                                <p><strong>Mô tả:</strong></p>
                                <p id="viewDescription" class="text-muted"></p>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            // Global variables for search and filter
            let allVouchers = [];
            let filteredVouchers = [];

            // Initialize data on page load
            document.addEventListener('DOMContentLoaded', function () {
                initializeVoucherData();
                setupEventListeners();
                updateDisplay();

                // Set minimum date for datetime inputs
                const now = new Date();
                const minDateTime = now.toISOString().slice(0, 16);
                const startDateInputs = document.querySelectorAll('input[name="startDate"]');
                const endDateInputs = document.querySelectorAll('input[name="endDate"]');

                startDateInputs.forEach(input => {
                    input.min = minDateTime;
                });

                endDateInputs.forEach(input => {
                    input.min = minDateTime;
                });
            });
            
            // Initialize voucher data from table rows
            function initializeVoucherData() {
                const rows = document.querySelectorAll('.voucher-row');
                allVouchers = [];

                rows.forEach(row => {
                    const voucher = {
                        id: parseInt(row.dataset.id),
                        code: row.dataset.code,
                        description: row.dataset.description || '',
                        discount: parseFloat(row.dataset.discount),
                        minOrder: parseFloat(row.dataset.minOrder),
                        usageLimit: parseInt(row.dataset.usageLimit),
                        usedCount: parseInt(row.dataset.usedCount),
                        startDate: row.dataset.startDate,
                        endDate: row.dataset.endDate,
                        createdDate: row.dataset.createdDate,
                        status: row.dataset.status,
                        element: row
                    };
                    allVouchers.push(voucher);
                });

                filteredVouchers = [...allVouchers];
            }

            // Setup event listeners for search and filter
            function setupEventListeners() {
                // Search input
                document.getElementById('searchInput').addEventListener('input', debounce(applyFilters, 300));

                // Filter controls
                document.getElementById('statusFilter').addEventListener('change', applyFilters);
                               document.getElementById('minDiscountFilter').addEventListener('input', debounce(applyFilters, 500));
                document.getElementById('maxDiscountFilter').addEventListener('input', debounce(applyFilters, 500));
                document.getElementById('fromDateFilter').addEventListener('change', applyFilters);
                document.getElementById('toDateFilter').addEventListener('change', applyFilters);
            }

            // Debounce function to limit API calls
            function debounce(func, wait) {
                let timeout;
                return function executedFunction(...args) {
                    const later = () => {
                        clearTimeout(timeout);
                        func(...args);
                    };
                    clearTimeout(timeout);
                    timeout = setTimeout(later, wait);
                };
            }

            // Apply all filters and search
            function applyFilters() {
                const searchTerm = document.getElementById('searchInput').value.toLowerCase().trim();
                const statusFilter = document.getElementById('statusFilter').value;
                const minDiscount = parseFloat(document.getElementById('minDiscountFilter').value) || 0;
                const maxDiscount = parseFloat(document.getElementById('maxDiscountFilter').value) || Infinity;
                const fromDate = document.getElementById('fromDateFilter').value;
                const toDate = document.getElementById('toDateFilter').value;

                // Filter vouchers
                filteredVouchers = allVouchers.filter(voucher => {
                    // Search filter
                    const matchesSearch = !searchTerm ||
                            voucher.code.toLowerCase().includes(searchTerm) ||
                            voucher.description.toLowerCase().includes(searchTerm);

                    // Status filter
                    const matchesStatus = !statusFilter || voucher.status === statusFilter;

                    // Discount amount filter
                    const matchesDiscount = voucher.discount >= minDiscount && voucher.discount <= maxDiscount;

                    // Date range filter
                    const matchesDateRange = (!fromDate || voucher.createdDate >= fromDate) &&
                            (!toDate || voucher.createdDate <= toDate);

                    return matchesSearch && matchesStatus && matchesDiscount && matchesDateRange;
                });

                updateDisplay();
            }

            // Update table display
            function updateDisplay() {
                const tbody = document.getElementById('voucherTableBody');
                const noResults = document.getElementById('noResults');

                // Hide all rows first
                allVouchers.forEach(voucher => {
                    voucher.element.style.display = 'none';
                });

                if (filteredVouchers.length === 0) {
                    // Show no results message
                    noResults.style.display = 'block';
                } else {
                    // Hide no results message
                    noResults.style.display = 'none';

                    // Show filtered vouchers
                    filteredVouchers.forEach(voucher => {
                        voucher.element.style.display = '';
                    });
                }

                // Update results info
                updateResultsInfo();
            }

            // Update results information
            function updateResultsInfo() {
                const totalResults = allVouchers.length;
                const filteredResults = filteredVouchers.length;

                document.getElementById('currentResults').textContent = filteredResults;
                document.getElementById('totalResults').textContent = totalResults;
            }

            // Clear all filters
            function clearAllFilters() {
                document.getElementById('searchInput').value = '';
                document.getElementById('statusFilter').value = '';
                document.getElementById('minDiscountFilter').value = '';
                document.getElementById('maxDiscountFilter').value = '';
                document.getElementById('fromDateFilter').value = '';
                document.getElementById('toDateFilter').value = '';

                filteredVouchers = [...allVouchers];
                updateDisplay();
            }

            // Function to view voucher details
            function viewVoucher(id) {
                fetch('vouchers?action=view&id=' + id)
                        .then(response => response.json())
                        .then(data => {
                            if (data.error) {
                                alert(data.error);
                                return;
                            }

                            document.getElementById('viewVoucherId').textContent = data.voucherId;
                            document.getElementById('viewCode').textContent = data.code;
                            document.getElementById('viewDiscountAmount').textContent =
                                    new Intl.NumberFormat('vi-VN', {style: 'currency', currency: 'VND'}).format(data.discountAmount);
                            document.getElementById('viewMinOrderValue').textContent =
                                    new Intl.NumberFormat('vi-VN', {style: 'currency', currency: 'VND'}).format(data.minOrderValue);
                            document.getElementById('viewUsageLimit').textContent = data.usageLimit;
                            document.getElementById('viewUsedCount').textContent = data.usedCount;
                            document.getElementById('viewStatus').innerHTML = getStatusBadge(data);
                            document.getElementById('viewCreatedDate').textContent = formatDateTime(data.createdDate);
                            document.getElementById('viewStartDate').textContent = formatDateTime(data.startDate);
                            document.getElementById('viewEndDate').textContent = formatDateTime(data.endDate);
                            document.getElementById('viewDescription').textContent = data.description || 'Không có mô tả';

                            new bootstrap.Modal(document.getElementById('viewVoucherModal')).show();
                        })
                        .catch(error => {
                            console.error('Error:', error);
                            alert('Có lỗi xảy ra khi tải thông tin voucher');
                        });
            }

            // Function to edit voucher
            function editVoucher(id) {
                fetch('vouchers?action=edit&id=' + id)
                        .then(response => response.json())
                        .then(data => {
                            if (data.error) {
                                alert(data.error);
                                return;
                            }

                            document.getElementById('editVoucherId').value = data.voucherId;
                            document.getElementById('editCode').value = data.code;
                            document.getElementById('editDiscountAmount').value = data.discountAmount;
                            document.getElementById('editMinOrderValue').value = data.minOrderValue;
                            document.getElementById('editUsageLimit').value = data.usageLimit;
                            document.getElementById('editStartDate').value = formatDateTimeLocal(data.startDate);
                            document.getElementById('editEndDate').value = formatDateTimeLocal(data.endDate);
                            document.getElementById('editDescription').value = data.description || '';

                            new bootstrap.Modal(document.getElementById('editVoucherModal')).show();
                        })
                        .catch(error => {
                            console.error('Error:', error);
                            alert('Có lỗi xảy ra khi tải thông tin voucher');
                        });
            }

            // Function to toggle voucher status
            function toggleVoucher(id, currentStatus) {
                const action = currentStatus ? 'vô hiệu hóa' : 'kích hoạt';
                if (confirm(`Bạn có chắc chắn muốn ${action} voucher này?`)) {
                    window.location.href = `vouchers?action=toggle&id=${id}&status=${currentStatus}`;
                }
            }

            // Helper function to get status badge
            function getStatusBadge(voucher) {
                const now = new Date();
                const startDate = new Date(voucher.startDate);
                const endDate = new Date(voucher.endDate);

                if (now > endDate) {
                    return '<span class="status-badge status-expired">Hết hạn</span>';
                } else if (now < startDate) {
                    return '<span class="status-badge status-pending">Chưa hiệu lực</span>';
                } else if (voucher.isActive) {
                    return '<span class="status-badge status-active">Hoạt động</span>';
                } else {
                    return '<span class="status-badge status-expired">Vô hiệu hóa</span>';
                }
            }

            // Helper function to format datetime
            function formatDateTime(dateString) {
                const date = new Date(dateString);
                return date.toLocaleString('vi-VN', {
                    year: 'numeric',
                    month: '2-digit',
                    day: '2-digit',
                    hour: '2-digit',
                    minute: '2-digit'
                });
            }

            // Helper function to format datetime for input
            function formatDateTimeLocal(dateString) {
                const date = new Date(dateString);
                const year = date.getFullYear();
                const month = String(date.getMonth() + 1).padStart(2, '0');
                const day = String(date.getDate()).padStart(2, '0');
                const hours = String(date.getHours()).padStart(2, '0');
                const minutes = String(date.getMinutes()).padStart(2, '0');

                return `${year}-${month}-${day}T${hours}:${minutes}`;
            }

            // Export functions for external use
            window.viewVoucher = viewVoucher;
            window.editVoucher = editVoucher;
            window.toggleVoucher = toggleVoucher;
            window.clearAllFilters = clearAllFilters;
        </script>
    </body>
</html>

