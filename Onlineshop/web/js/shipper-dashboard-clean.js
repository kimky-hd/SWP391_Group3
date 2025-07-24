/**
 * Shipper Dashboard JavaScript
 * Handles dashboard-specific functionality including stats, quick actions, and recent orders
 */

document.addEventListener('DOMContentLoaded', function() {
    initShipperDashboard();
});

function initShipperDashboard() {
    // Initialize tooltips
    initTooltips();
    
    // Initialize dashboard stats animation
    animateStats();
    
    // Initialize auto-refresh for dashboard
    initDashboardAutoRefresh();
    
    // Initialize quick actions
    initQuickActions();
    
    // Initialize recent orders table
    initRecentOrdersTable();
}

function initTooltips() {
    var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });
}

/**
 * Update order status from dashboard
 * @param {string} orderId - Order ID
 * @param {string} statusId - New status ID
 */
function updateStatus(orderId, statusId) {
    let confirmMessage = '';
    let actionText = '';
    let iconClass = '';
    let buttonClass = '';
    
    switch(statusId) {
        case '3':
            confirmMessage = `Bạn có chắc chắn muốn bắt đầu giao đơn hàng #${orderId}?`;
            actionText = 'Bắt đầu giao';
            iconClass = 'fa-truck';
            buttonClass = 'primary';
            break;
        case '4':
            confirmMessage = `Bạn có chắc chắn đã giao thành công đơn hàng #${orderId}?`;
            actionText = 'Xác nhận đã giao';
            iconClass = 'fa-check-circle';
            buttonClass = 'success';
            break;
        case '6':
            // Handle cancellation with note
            cancelOrder(orderId);
            return;
        default:
            confirmMessage = `Bạn có chắc chắn muốn cập nhật trạng thái đơn hàng #${orderId}?`;
            actionText = 'Cập nhật trạng thái';
            iconClass = 'fa-edit';
            buttonClass = 'primary';
    }
    
    // Show modal instead of confirm dialog
    showConfirmModal(orderId, statusId, confirmMessage, iconClass, actionText, buttonClass);
}

/**
 * Execute confirmed status update
 * @param {string} orderId - Order ID
 * @param {string} statusId - New status ID
 * @param {string} actionText - Action text for success message
 */
function performStatusUpdate(orderId, statusId, actionText) {
    // Get context path from the page
    const contextPath = getContextPath();
    
    fetch(`${contextPath}/shipper/update-status`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: `orderId=${orderId}&statusId=${statusId}`
    })
    .then(response => {
        if (response.ok) {
            showToast(`${actionText} thành công!`, 'success');
            setTimeout(() => location.reload(), 1000);
        } else {
            return response.text().then(text => {
                throw new Error(text || 'Có lỗi xảy ra khi cập nhật trạng thái');
            });
        }
    })
    .catch(error => {
        console.error('Error updating status:', error);
        showToast(`Có lỗi xảy ra: ${error.message}`, 'danger');
    });
}

/**
 * Cancel order with note
 * @param {string} orderId - Order ID
 */
function cancelOrder(orderId) {
    // Store order ID for later use
    window.currentCancelOrderId = orderId;
    
    // Clear previous reason
    document.getElementById('cancelReason').value = '';
    
    // Show cancel order modal
    const modal = new bootstrap.Modal(document.getElementById('cancelOrderModal'));
    modal.show();
}

/**
 * Confirm cancel order (called from modal)
 */
function confirmCancel() {
    const orderId = window.currentCancelOrderId;
    const note = document.getElementById('cancelReason').value.trim();
    
    if (note === '') {
        showToast('Bạn phải nhập lý do hủy đơn hàng', 'danger');
        return;
    }
    
    // Close modal
    const modal = bootstrap.Modal.getInstance(document.getElementById('cancelOrderModal'));
    modal.hide();
    
    // Get context path from the page
    const contextPath = getContextPath();
    
    fetch(`${contextPath}/shipper/update-status`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: `orderId=${orderId}&statusId=6&note=${encodeURIComponent(note)}`
    })
    .then(response => {
        if (response.ok) {
            showToast('Hủy đơn hàng thành công!', 'success');
            setTimeout(() => location.reload(), 1000);
        } else {
            return response.text().then(text => {
                throw new Error(text || 'Có lỗi xảy ra khi hủy đơn hàng');
            });
        }
    })
    .catch(error => {
        console.error('Error cancelling order:', error);
        showToast(`Có lỗi xảy ra: ${error.message}`, 'danger');
    });
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
 * Show confirmation modal instead of browser confirm
 */
function showConfirmModal(orderID, newStatus, message, icon, buttonText, buttonClass) {
    // Store pending action
    window.pendingAction = { orderID, newStatus, buttonText };
    
    // Update modal content
    document.getElementById('confirmMessage').textContent = message;
    document.getElementById('confirmIcon').className = `fas ${icon} text-${buttonClass}`;
    document.getElementById('confirmActionBtn').className = `btn btn-${buttonClass}`;
    document.getElementById('confirmActionBtn').textContent = buttonText;
    
    // Show modal
    const modal = new bootstrap.Modal(document.getElementById('confirmActionModal'));
    modal.show();
}

/**
 * Execute the confirmed action
 */
function executeConfirmedAction() {
    if (window.pendingAction) {
        // Close modal first
        const modal = bootstrap.Modal.getInstance(document.getElementById('confirmActionModal'));
        modal.hide();
        
        // Execute the actual update
        performStatusUpdate(window.pendingAction.orderID, window.pendingAction.newStatus, window.pendingAction.buttonText);
        window.pendingAction = null;
    }
}

/**
 * Show toast notification
 */
function showToast(message, type) {
    const toastContainer = document.getElementById('toastContainer') || createToastContainer();
    const toast = document.createElement('div');
    toast.className = `toast align-items-center text-white bg-${type === 'success' ? 'success' : 'danger'} border-0`;
    toast.setAttribute('role', 'alert');
    toast.innerHTML = `
        <div class="d-flex">
            <div class="toast-body">
                <i class="fas fa-${type === 'success' ? 'check-circle' : 'exclamation-triangle'} me-2"></i>
                ${message}
            </div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
        </div>
    `;
    
    toastContainer.appendChild(toast);
    const bsToast = new bootstrap.Toast(toast);
    bsToast.show();
    
    toast.addEventListener('hidden.bs.toast', () => {
        toast.remove();
    });
}

function createToastContainer() {
    const container = document.createElement('div');
    container.id = 'toastContainer';
    container.className = 'toast-container position-fixed top-0 end-0 p-3';
    document.body.appendChild(container);
    return container;
}

/**
 * View order details
 */
function viewOrderDetails(orderId) {
    // Show loading in modal
    document.getElementById('orderDetailsContent').innerHTML = `
        <div class="text-center">
            <div class="spinner-border text-primary" role="status">
                <span class="visually-hidden">Loading...</span>
            </div>
            <p class="mt-2">Đang tải chi tiết đơn hàng...</p>
        </div>
    `;
    
    // Show modal
    const modal = new bootstrap.Modal(document.getElementById('orderDetailsModal'));
    modal.show();
    
    // Fetch order details
    const contextPath = getContextPath();
    fetch(`${contextPath}/shipper/order-detail?orderId=${orderId}`)
        .then(response => response.text())
        .then(html => {
            document.getElementById('orderDetailsContent').innerHTML = html;
        })
        .catch(error => {
            console.error('Error loading order details:', error);
            document.getElementById('orderDetailsContent').innerHTML = `
                <div class="text-center text-danger">
                    <i class="fas fa-exclamation-triangle" style="font-size: 3rem;"></i>
                    <h5 class="mt-3">Không thể tải chi tiết đơn hàng</h5>
                    <p>Có lỗi xảy ra khi tải thông tin đơn hàng. Vui lòng thử lại.</p>
                </div>
            `;
        });
}

function animateStats() {
    // Animate stats cards on page load
    const statsCards = document.querySelectorAll('.stats-card');
    statsCards.forEach((card, index) => {
        card.style.opacity = '0';
        card.style.transform = 'translateY(20px)';
        
        setTimeout(() => {
            card.style.transition = 'all 0.5s ease';
            card.style.opacity = '1';
            card.style.transform = 'translateY(0)';
        }, index * 100);
    });
    
    // Animate numbers counting up
    const statNumbers = document.querySelectorAll('.stats-card h5');
    statNumbers.forEach(number => {
        const finalValue = parseInt(number.textContent);
        if (!isNaN(finalValue)) {
            animateCounter(number, 0, finalValue, 1000);
        }
    });
}

function animateCounter(element, start, end, duration) {
    const range = end - start;
    const increment = range / (duration / 16); // 60 FPS
    let current = start;
    
    const timer = setInterval(() => {
        current += increment;
        if (current >= end) {
            current = end;
            clearInterval(timer);
        }
        element.textContent = Math.floor(current);
    }, 16);
}

function initDashboardAutoRefresh() {
    // Auto-refresh dashboard every 2 minutes
    setInterval(() => {
        if (document.hasFocus() && !document.querySelector('.modal.show')) {
            refreshDashboardStats();
        }
    }, 2 * 60 * 1000);
}

function refreshDashboardStats() {
    // Add loading indicator to stats cards
    const statsCards = document.querySelectorAll('.stats-card h5');
    statsCards.forEach(card => {
        card.innerHTML = '<i class="fas fa-spinner fa-spin"></i>';
    });
    
    // Simulate API call to refresh stats
    setTimeout(() => {
        window.location.reload();
    }, 1000);
}

function initQuickActions() {
    // Add click handlers for quick action buttons
    const quickActionButtons = document.querySelectorAll('.btn[href*="/shipper/orders"]');
    quickActionButtons.forEach(button => {
        button.addEventListener('click', function(e) {
            // Add loading effect
            const icon = this.querySelector('i');
            if (icon) {
                const originalIcon = icon.className;
                icon.className = 'fas fa-spinner fa-spin me-2';
                
                // Remove loading effect after navigation
                setTimeout(() => {
                    icon.className = originalIcon;
                }, 500);
            }
        });
    });
}

function initRecentOrdersTable() {
    // Add hover effects to table rows
    const tableRows = document.querySelectorAll('.table tbody tr');
    tableRows.forEach(row => {
        row.addEventListener('mouseenter', function() {
            this.style.transform = 'scale(1.01)';
            this.style.transition = 'transform 0.2s ease';
        });
        
        row.addEventListener('mouseleave', function() {
            this.style.transform = 'scale(1)';
        });
    });
}

// Export functions for global access
window.updateStatus = updateStatus;
window.cancelOrder = cancelOrder;
window.confirmCancel = confirmCancel;
window.executeConfirmedAction = executeConfirmedAction;
window.viewOrderDetails = viewOrderDetails;
