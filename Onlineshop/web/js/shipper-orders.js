/**
 * Shipper Orders JavaScript
 * Handles orders page functionality including filtering, pagination, and order management
 */

document.addEventListener('DOMContentLoaded', function() {
    initShipperOrders();
});

/**
 * Initialize orders page functionality
 */
function initShipperOrders() {
    // Initialize tooltips
    initializeTooltips();
    
    // Initialize search functionality
    initializeSearch();
    
    // Initialize filter functionality
    initializeFilters();
    
    // Initialize pagination
    initializePagination();
    
    // Initialize order actions
    initializeOrderActions();
    
    console.log('Shipper Orders page initialized');
}

/**
 * Initialize Bootstrap tooltips
 */
function initializeTooltips() {
    if (typeof bootstrap !== 'undefined') {
        var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
        var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
            return new bootstrap.Tooltip(tooltipTriggerEl);
        });
    }
}

/**
 * Initialize search functionality
 */
function initializeSearch() {
    const searchInput = document.getElementById('search');
    if (searchInput) {
        // Add enter key support
        searchInput.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                e.preventDefault();
                document.querySelector('form').submit();
            }
        });
        
        // Add search icon click support
        const searchIcon = document.querySelector('.search-icon');
        if (searchIcon) {
            searchIcon.addEventListener('click', function() {
                document.querySelector('form').submit();
            });
        }
    }
}

/**
 * Initialize filter functionality
 */
function initializeFilters() {
    const statusFilter = document.getElementById('status');
    const pageSizeFilter = document.getElementById('pageSize');
    
    // Auto-submit on status change
    if (statusFilter) {
        statusFilter.addEventListener('change', function() {
            document.querySelector('form').submit();
        });
    }
    
    // Auto-submit on page size change
    if (pageSizeFilter) {
        pageSizeFilter.addEventListener('change', function() {
            document.querySelector('form').submit();
        });
    }
}

/**
 * Initialize pagination functionality
 */
function initializePagination() {
    const paginationLinks = document.querySelectorAll('.pagination .page-link');
    paginationLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            // Add loading state to clicked pagination link
            const icon = this.querySelector('i');
            if (icon) {
                icon.classList.add('fa-spin');
            }
        });
    });
}

/**
 * Initialize order actions
 */
function initializeOrderActions() {
    // Initialize modal if it exists
    const orderModal = document.getElementById('orderDetailsModal');
    if (orderModal) {
        orderModal.addEventListener('hidden.bs.modal', function() {
            // Clear modal content when closed
            document.getElementById('orderDetailsContent').innerHTML = '';
        });
    }
}

/**
 * Refresh the orders page
 */
function refreshPage() {
    window.location.reload();
}

/**
 * Update order status
 * @param {string} orderId - Order ID
 * @param {string} statusId - New status ID
 */
function updateStatus(orderId, statusId) {
    let confirmMessage = '';
    let actionText = '';
    
    switch(statusId) {
        case '3':
            confirmMessage = `Bạn có chắc chắn muốn bắt đầu giao đơn hàng #${orderId}?`;
            actionText = 'Bắt đầu giao hàng';
            break;
        case '4':
            confirmMessage = `Bạn có chắc chắn đã giao thành công đơn hàng #${orderId}?`;
            actionText = 'Hoàn thành giao hàng';
            break;
        case '9':
            // Handle cancellation with note
            cancelOrder(orderId);
            return;
        default:
            confirmMessage = `Bạn có chắc chắn muốn cập nhật trạng thái đơn hàng #${orderId}?`;
            actionText = 'Cập nhật trạng thái';
    }
    
    if (confirm(confirmMessage)) {
        // Show loading state
        const button = event.target.closest('button');
        const originalContent = button.innerHTML;
        button.innerHTML = '<i class="fas fa-spinner fa-spin"></i>';
        button.disabled = true;

        // Get context path from the page
        const contextPath = getContextPath();
        const requestUrl = `${contextPath}/shipper/update-status`;
        const requestBody = `orderId=${orderId}&statusId=${statusId}`;
        
        console.log('Making request to:', requestUrl);
        console.log('Request body:', requestBody);
        console.log('Parameters:', {orderId, statusId, types: {orderId: typeof orderId, statusId: typeof statusId}});
        
        fetch(requestUrl, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: requestBody
        })
        .then(response => {
            if (response.ok) {
                if (typeof showToast === 'function') {
                    showToast(`${actionText} thành công!`, 'success');
                } else {
                    alert(`${actionText} thành công!`);
                }
                setTimeout(() => location.reload(), 1000);
            } else {
                return response.text().then(text => {
                    throw new Error(text || 'Có lỗi xảy ra khi cập nhật trạng thái');
                });
            }
        })
        .catch(error => {
            console.error('Error updating status:', error);
            if (typeof showToast === 'function') {
                showToast(`Có lỗi xảy ra: ${error.message}`, 'danger');
            } else {
                alert(`Có lỗi xảy ra: ${error.message}`);
            }
            
            // Restore button state
            button.innerHTML = originalContent;
            button.disabled = false;
        });
    }
}

/**
 * Cancel order with note
 * @param {string} orderId - Order ID
 */
function cancelOrder(orderId) {
    const note = prompt('Vui lòng nhập lý do hủy đơn hàng:');
    
    if (note === null) {
        return; // User clicked cancel
    }
    
    if (note.trim() === '') {
        alert('Bạn phải nhập lý do hủy đơn hàng');
        return;
    }
    
    if (confirm(`Bạn có chắc chắn muốn hủy đơn hàng #${orderId}?\nLý do: ${note}`)) {
        // Show loading state
        const button = event.target.closest('button');
        const originalContent = button.innerHTML;
        button.innerHTML = '<i class="fas fa-spinner fa-spin"></i>';
        button.disabled = true;

        // Get context path from the page
        const contextPath = getContextPath();
        
        fetch(`${contextPath}/shipper/update-status`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: `orderId=${orderId}&statusId=9&note=${encodeURIComponent(note)}`
        })
        .then(response => {
            if (response.ok) {
                if (typeof showToast === 'function') {
                    showToast('Hủy đơn hàng thành công!', 'success');
                } else {
                    alert('Hủy đơn hàng thành công!');
                }
                setTimeout(() => location.reload(), 1000);
            } else {
                return response.text().then(text => {
                    throw new Error(text || 'Có lỗi xảy ra khi hủy đơn hàng');
                });
            }
        })
        .catch(error => {
            console.error('Error cancelling order:', error);
            if (typeof showToast === 'function') {
                showToast(`Có lỗi xảy ra: ${error.message}`, 'danger');
            } else {
                alert(`Có lỗi xảy ra: ${error.message}`);
            }
            
            // Restore button state
            button.innerHTML = originalContent;
            button.disabled = false;
        });
    }
}

/**
 * View order details in modal
 * @param {string} orderId - Order ID
 */
function viewOrderDetails(orderId) {
    const modal = new bootstrap.Modal(document.getElementById('orderDetailsModal'));
    const contentDiv = document.getElementById('orderDetailsContent');
    
    // Show loading
    contentDiv.innerHTML = `
        <div class="text-center p-4">
            <i class="fas fa-spinner fa-spin fa-3x text-primary"></i>
            <p class="mt-3">Đang tải chi tiết đơn hàng #${orderId}...</p>
        </div>
    `;
    
    modal.show();
    
    // Get context path
    const contextPath = getContextPath();
    
    // Fetch order details (you can implement this API endpoint)
    fetch(`${contextPath}/shipper/order-details?orderId=${orderId}`)
        .then(response => {
            if (response.ok) {
                return response.json();
            } else {
                throw new Error('Không thể tải chi tiết đơn hàng');
            }
        })
        .then(data => {
            displayOrderDetails(data);
        })
        .catch(error => {
            console.error('Error loading order details:', error);
            // Show placeholder content for now
            contentDiv.innerHTML = `
                <div class="alert alert-info">
                    <i class="fas fa-info-circle me-2"></i>
                    Chi tiết đơn hàng #${orderId} sẽ được hiển thị tại đây.
                    <br><small>Bạn có thể implement thêm API để lấy chi tiết đơn hàng từ server.</small>
                </div>
                <div class="row">
                    <div class="col-md-6">
                        <h6>Thông tin đơn hàng</h6>
                        <ul class="list-unstyled">
                            <li><strong>Mã đơn hàng:</strong> #${orderId}</li>
                            <li><strong>Ngày tạo:</strong> ${new Date().toLocaleDateString('vi-VN')}</li>
                            <li><strong>Trạng thái:</strong> <span class="badge bg-primary">Đang giao</span></li>
                        </ul>
                    </div>
                    <div class="col-md-6">
                        <h6>Thông tin khách hàng</h6>
                        <ul class="list-unstyled">
                            <li><strong>Tên:</strong> Khách hàng ${orderId}</li>
                            <li><strong>SĐT:</strong> 0123456789</li>
                            <li><strong>Email:</strong> customer@example.com</li>
                        </ul>
                    </div>
                </div>
            `;
        });
}

/**
 * Display order details in modal
 * @param {Object} orderData - Order data
 */
function displayOrderDetails(orderData) {
    const contentDiv = document.getElementById('orderDetailsContent');
    
    contentDiv.innerHTML = `
        <div class="row">
            <div class="col-md-6">
                <h6>Thông tin đơn hàng</h6>
                <ul class="list-unstyled">
                    <li><strong>Mã đơn hàng:</strong> #${orderData.orderId}</li>
                    <li><strong>Ngày tạo:</strong> ${orderData.createdDate}</li>
                    <li><strong>Trạng thái:</strong> <span class="badge bg-primary">${orderData.status}</span></li>
                    <li><strong>Giá trị:</strong> ${orderData.totalAmount}</li>
                </ul>
            </div>
            <div class="col-md-6">
                <h6>Thông tin khách hàng</h6>
                <ul class="list-unstyled">
                    <li><strong>Tên:</strong> ${orderData.customerName}</li>
                    <li><strong>SĐT:</strong> ${orderData.customerPhone}</li>
                    <li><strong>Email:</strong> ${orderData.customerEmail}</li>
                    <li><strong>Địa chỉ:</strong> ${orderData.customerAddress}</li>
                </ul>
            </div>
        </div>
        <hr>
        <h6>Chi tiết sản phẩm</h6>
        <div class="table-responsive">
            <table class="table table-sm">
                <thead>
                    <tr>
                        <th>Sản phẩm</th>
                        <th>Số lượng</th>
                        <th>Đơn giá</th>
                        <th>Thành tiền</th>
                    </tr>
                </thead>
                <tbody>
                    ${orderData.items ? orderData.items.map(item => `
                        <tr>
                            <td>${item.productName}</td>
                            <td>${item.quantity}</td>
                            <td>${item.price}</td>
                            <td>${item.subtotal}</td>
                        </tr>
                    `).join('') : '<tr><td colspan="4">Không có thông tin sản phẩm</td></tr>'}
                </tbody>
            </table>
        </div>
    `;
}

/**
 * Get context path from current URL
 */
function getContextPath() {
    // Extract context path from current URL
    const pathname = window.location.pathname;
    const pathParts = pathname.split('/');
    if (pathParts.length >= 2 && pathParts[1]) {
        return '/' + pathParts[1];
    }
    // Fallback to /Onlineshop if unable to detect
    return '/Onlineshop';
}

/**
 * Clear all filters
 */
function clearFilters() {
    document.getElementById('search').value = '';
    document.getElementById('status').value = '';
    document.getElementById('pageSize').value = '10';
    document.querySelector('form').submit();
}

/**
 * Export selected orders (placeholder function)
 */
function exportOrders() {
    alert('Tính năng xuất dữ liệu sẽ được phát triển trong tương lai');
}

// Export functions for use in other scripts
window.shipperOrders = {
    updateStatus,
    cancelOrder,
    viewOrderDetails,
    refreshPage,
    clearFilters,
    exportOrders
};
