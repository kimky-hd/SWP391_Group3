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
    
    switch(statusId) {
        case '3':
            confirmMessage = `Bạn có chắc chắn muốn bắt đầu giao đơn hàng #${orderId}?`;
            actionText = 'Bắt đầu giao hàng';
            break;
        case '4':
            confirmMessage = `Bạn có chắc chắn đã giao thành công đơn hàng #${orderId}?`;
            actionText = 'Hoàn thành giao hàng';
            break;
        case '6':
            // Handle cancellation with note
            cancelOrder(orderId);
            return;
        case '9':
            confirmMessage = `Bạn có chắc chắn muốn chuẩn bị đơn hàng #${orderId}?`;
            actionText = 'Chuẩn bị đơn hàng';
            break;
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
        
        fetch(`${contextPath}/shipper/update-status`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: `orderId=${orderId}&statusId=${statusId}`
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
            body: `orderId=${orderId}&statusId=6&note=${encodeURIComponent(note)}`
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
            const originalIcon = icon.className;
            icon.className = 'fas fa-spinner fa-spin me-2';
            
            // Remove loading effect after navigation
            setTimeout(() => {
                icon.className = originalIcon;
            }, 500);
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

/**
 * Update order status from dashboard
 * @param {string} orderId - Order ID
 * @param {string} statusId - New status ID
 */
function updateStatus(orderId, statusId) {
    let confirmMessage = '';
    let successMessage = '';
    
    switch(statusId) {
        case '3':
            confirmMessage = `Bạn có chắc chắn muốn bắt đầu giao đơn hàng #${orderId}?`;
            successMessage = 'Đã chuyển đơn hàng sang trạng thái "Đang giao"';
            break;
        case '4':
            confirmMessage = `Bạn có chắc chắn đã giao thành công đơn hàng #${orderId}?`;
            successMessage = 'Đơn hàng đã được giao thành công';
            break;
        default:
            confirmMessage = `Bạn có chắc chắn muốn cập nhật trạng thái đơn hàng #${orderId}?`;
            successMessage = 'Trạng thái đơn hàng đã được cập nhật';
    }
    
    if (confirm(confirmMessage)) {
        // Find the button that triggered this action
        const button = event.target.closest('button');
        const originalContent = button.innerHTML;
        
        // Show loading state
        button.innerHTML = '<i class="fas fa-spinner fa-spin me-1"></i>Đang xử lý...';
        button.disabled = true;
        
        // Make API call
        fetch(`${getContextPath()}/shipper/update-status`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
                'X-Requested-With': 'XMLHttpRequest'
            },
            body: `orderId=${orderId}&statusId=${statusId}`
        })
        .then(response => {
            if (response.ok) {
                return response.text();
            } else {
                throw new Error(`HTTP ${response.status}: ${response.statusText}`);
            }
        })
        .then(data => {
            // Show success notification
            showNotification(successMessage, 'success');
            
            // Update the UI immediately for better UX
            updateOrderRowStatus(orderId, statusId);
            
            // Refresh stats
            setTimeout(() => {
                refreshDashboardStats();
            }, 1000);
        })
        .catch(error => {
            console.error('Error:', error);
            showNotification('Có lỗi xảy ra: ' + error.message, 'error');
            
            // Restore button state
            button.innerHTML = originalContent;
            button.disabled = false;
        });
    }
}

/**
 * Update order row status in the table
 * @param {string} orderId - Order ID
 * @param {string} statusId - New status ID
 */
function updateOrderRowStatus(orderId, statusId) {
    const orderRow = document.querySelector(`tr[data-order-id="${orderId}"]`);
    if (!orderRow) return;
    
    const statusCell = orderRow.querySelector('.badge');
    const actionCell = orderRow.querySelector('td:last-child');
    
    if (statusCell) {
        switch(statusId) {
            case '3':
                statusCell.className = 'badge bg-primary';
                statusCell.textContent = 'Đang giao';
                break;
            case '4':
                statusCell.className = 'badge bg-success';
                statusCell.textContent = 'Đã giao';
                break;
        }
    }
    
    // Update action buttons
    if (actionCell && statusId === '3') {
        actionCell.innerHTML = `
            <button class="btn btn-sm btn-success" onclick="updateStatus('${orderId}', '4')">
                <i class="fas fa-check me-1"></i>
                Đã giao
            </button>
        `;
    } else if (actionCell && statusId === '4') {
        actionCell.innerHTML = '<span class="text-muted">Hoàn thành</span>';
    }
}

/**
 * Show notification to user
 * @param {string} message - Notification message
 * @param {string} type - Notification type (success, error, warning, info)
 */
function showNotification(message, type = 'info') {
    const alertClass = type === 'error' ? 'danger' : type;
    const iconClass = type === 'success' ? 'check-circle' : 
                     type === 'error' ? 'exclamation-triangle' : 
                     type === 'warning' ? 'exclamation-triangle' : 'info-circle';
    
    // Create notification element
    const notification = document.createElement('div');
    notification.className = `alert alert-${alertClass} alert-dismissible fade show position-fixed`;
    notification.style.cssText = 'top: 20px; right: 20px; z-index: 1060; min-width: 300px;';
    
    notification.innerHTML = `
        <i class="fas fa-${iconClass} me-2"></i>
        ${message}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    `;
    
    document.body.appendChild(notification);
    
    // Auto remove after 5 seconds
    setTimeout(() => {
        if (notification.parentNode) {
            notification.remove();
        }
    }, 5000);
}

/**
 * Refresh page
 */
function refreshPage() {
    // Add loading overlay
    const overlay = document.createElement('div');
    overlay.className = 'position-fixed top-0 start-0 w-100 h-100 d-flex align-items-center justify-content-center';
    overlay.style.cssText = 'background: rgba(255,255,255,0.8); z-index: 9999;';
    overlay.innerHTML = `
        <div class="text-center">
            <i class="fas fa-spinner fa-spin fa-3x text-primary"></i>
            <p class="mt-3">Đang làm mới dữ liệu...</p>
        </div>
    `;
    
    document.body.appendChild(overlay);
    
    setTimeout(() => {
        window.location.reload();
    }, 500);
}

/**
 * Handle keyboard shortcuts
 */
document.addEventListener('keydown', function(e) {
    // Ctrl/Cmd + R: Refresh
    if ((e.ctrlKey || e.metaKey) && e.key === 'r') {
        e.preventDefault();
        refreshPage();
    }
    
    // Escape: Close any open modals
    if (e.key === 'Escape') {
        const openModal = document.querySelector('.modal.show');
        if (openModal) {
            const modal = bootstrap.Modal.getInstance(openModal);
            if (modal) {
                modal.hide();
            }
        }
    }
});

// Export functions for global access
window.updateStatus = updateStatus;
window.refreshPage = refreshPage;
window.showNotification = showNotification;
