// Shipper Dashboard JavaScript
document.addEventListener('DOMContentLoaded', function() {
    // Initialize shipper-specific functionality
    initShipperDashboard();
    initSidebarToggle();
    initActiveNavigation();
    initTooltips();
});

function initShipperDashboard() {
    console.log('Shipper Dashboard initialized');
    
    // Shipper-specific animations
    const sidebar = document.querySelector('.sidebar');
    const navLinks = document.querySelectorAll('.sidebar-menu .nav-link');
    
    // Add hover effects
    navLinks.forEach((link, index) => {
        link.addEventListener('mouseenter', function() {
            this.style.transform = 'translateX(8px)';
        });
        
        link.addEventListener('mouseleave', function() {
            if (!this.classList.contains('active')) {
                this.style.transform = 'translateX(0)';
            }
        });
    });
    
    // Add loading animation for shipper actions
    const shipperActions = document.querySelectorAll('[data-shipper-action]');
    shipperActions.forEach(action => {
        action.addEventListener('click', function() {
            showLoadingSpinner(this);
        });
    });
}

function initSidebarToggle() {
    const sidebarToggle = document.querySelector('.sidebar-toggle');
    const sidebar = document.querySelector('.sidebar');
    const mainContent = document.querySelector('.main-content');
    
    if (sidebarToggle) {
        sidebarToggle.addEventListener('click', function() {
            sidebar.classList.toggle('collapsed');
            mainContent.classList.toggle('expanded');
        });
    }
}

function initActiveNavigation() {
    const currentPath = window.location.pathname;
    const navLinks = document.querySelectorAll('.sidebar-menu .nav-link');
    
    navLinks.forEach(link => {
        const href = link.getAttribute('href');
        if (href && currentPath.includes(href)) {
            link.classList.add('active');
        }
    });
}

function initTooltips() {
    // Initialize Bootstrap tooltips
    const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    const tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });
}

function showLoadingSpinner(element) {
    const spinner = document.createElement('div');
    spinner.className = 'spinner-border spinner-border-sm me-2';
    spinner.setAttribute('role', 'status');
    
    const originalText = element.innerHTML;
    element.innerHTML = '';
    element.appendChild(spinner);
    element.appendChild(document.createTextNode('Đang xử lý...'));
    element.disabled = true;
    
    // Remove spinner after 2 seconds (adjust as needed)
    setTimeout(() => {
        element.innerHTML = originalText;
        element.disabled = false;
    }, 2000);
}

// Shipper-specific utility functions
function showShipperNotification(message, type = 'success') {
    const notification = document.createElement('div');
    notification.className = `alert alert-${type} alert-dismissible fade show position-fixed`;
    notification.style.cssText = 'top: 80px; right: 20px; z-index: 1050; min-width: 300px;';
    notification.innerHTML = `
        <i class="fas fa-check-circle me-2"></i>
        ${message}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    `;
    
    document.body.appendChild(notification);
    
    // Auto remove after 5 seconds
    setTimeout(() => {
        notification.remove();
    }, 5000);
}

// Enhanced shipper functionality for order management
function updateOrderStatus(orderId, statusId, statusName, buttonElement) {
    console.log('updateOrderStatus called with:', {orderId, statusId, statusName});
    console.log('orderId type:', typeof orderId);
    console.log('statusId type:', typeof statusId);
    
    let confirmMessage = '';

    switch(statusId) {
        case '3':
            confirmMessage = `Bạn có chắc chắn muốn bắt đầu giao đơn hàng #${orderId}?`;
            break;
        case '4':
            confirmMessage = `Bạn có chắc chắn đã giao thành công đơn hàng #${orderId}?`;
            break;
        default:
            confirmMessage = `Bạn có chắc chắn muốn cập nhật trạng thái đơn hàng #${orderId}?`;
    }

    if (confirm(confirmMessage)) {
        // Show loading state
        const originalContent = buttonElement.innerHTML;
        showLoading(buttonElement);

        // Use global context path or extract from URL
        let contextPath = '';
        if (window.CONTEXT_PATH) {
            contextPath = window.CONTEXT_PATH;
        } else if (typeof getContextPath === 'function') {
            contextPath = getContextPath();
        } else {
            // Extract context path from current URL
            const pathname = window.location.pathname;
            const pathParts = pathname.split('/');
            if (pathParts.length >= 2 && pathParts[1]) {
                contextPath = '/' + pathParts[1];
            } else {
                contextPath = '/Onlineshop'; // fallback
            }
        }
        const url = `${contextPath}/shipper/update-status`;
        console.log('Making request to URL:', url);
        console.log('Request data:', `orderId=${orderId}&statusId=${statusId}`);

        // Make API call
        fetch(url, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
                'X-Requested-With': 'XMLHttpRequest'
            },
            body: `orderId=${orderId}&statusId=${statusId}`
        })
        .then(response => {
            console.log('Response status:', response.status);
            console.log('Response headers:', response.headers);
            if (response.ok) {
                return response.text();
            } else {
                // Try to get error message from response
                return response.text().then(errorText => {
                    console.log('Error response body:', errorText);
                    throw new Error(`HTTP ${response.status}: ${errorText || response.statusText}`);
                });
            }
        })
        .then(data => {
            showToast('Cập nhật trạng thái thành công!', 'success');

            // Refresh page after short delay
            setTimeout(() => {
                window.location.reload();
            }, 1000);
        })
        .catch(error => {
            console.error('Error:', error);
            showToast('Có lỗi xảy ra: ' + error.message, 'danger');
            hideLoading(buttonElement, originalContent);
        });
    }
}

// Function to view order details
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
    let contextPath = '';
    if (window.CONTEXT_PATH) {
        contextPath = window.CONTEXT_PATH;
    } else if (typeof getContextPath === 'function') {
        contextPath = getContextPath();
    } else {
        // Extract context path from current URL
        const pathname = window.location.pathname;
        const pathParts = pathname.split('/');
        if (pathParts.length >= 2 && pathParts[1]) {
            contextPath = '/' + pathParts[1];
        } else {
            contextPath = '/Onlineshop'; // fallback
        }
    }
    
    // Make AJAX request to get real order details
    fetch(`${contextPath}/shipper/order-detail?orderId=${orderId}`, {
        method: 'GET',
        headers: {
            'X-Requested-With': 'XMLHttpRequest'
        }
    })
    .then(response => {
        if (response.ok) {
            return response.text();
        } else {
            throw new Error(`HTTP ${response.status}: ${response.statusText}`);
        }
    })
    .then(html => {
        contentDiv.innerHTML = html;
    })
    .catch(error => {
        console.error('Error loading order details:', error);
        contentDiv.innerHTML = `
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-triangle me-2"></i>
                <strong>Lỗi:</strong> Không thể tải chi tiết đơn hàng.
                <br><small>Chi tiết lỗi: ${error.message}</small>
                <br><button class="btn btn-sm btn-outline-danger mt-2" onclick="viewOrderDetails('${orderId}')">
                    <i class="fas fa-retry me-1"></i>Thử lại
                </button>
            </div>
        `;
    });
}

// Function to refresh page
function refreshPage() {
    window.location.reload();
}

// Function to show/hide loading on elements
function showLoading(element) {
    if (element) {
        element.innerHTML = '<i class="fas fa-spinner fa-spin"></i>';
        element.disabled = true;
    }
}

function hideLoading(element, originalContent) {
    if (element) {
        element.innerHTML = originalContent;
        element.disabled = false;
    }
}

// Function to show toast notifications
function showToast(message, type = 'success') {
    // Create toast element
    const toast = document.createElement('div');
    toast.className = `toast align-items-center text-white bg-${type} border-0`;
    toast.setAttribute('role', 'alert');
    toast.setAttribute('aria-live', 'assertive');
    toast.setAttribute('aria-atomic', 'true');
    
    toast.innerHTML = `
        <div class="d-flex">
            <div class="toast-body">
                <i class="fas fa-${type === 'success' ? 'check-circle' : 'exclamation-triangle'} me-2"></i>
                ${message}
            </div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
        </div>
    `;
    
    // Add to toast container
    let toastContainer = document.querySelector('.toast-container');
    if (!toastContainer) {
        toastContainer = document.createElement('div');
        toastContainer.className = 'toast-container position-fixed top-0 end-0 p-3';
        toastContainer.style.zIndex = '1080';
        document.body.appendChild(toastContainer);
    }
    
    toastContainer.appendChild(toast);
    
    // Show toast
    const bsToast = new bootstrap.Toast(toast, {
        delay: 5000
    });
    bsToast.show();
    
    // Remove toast after it's hidden
    toast.addEventListener('hidden.bs.toast', function() {
        toast.remove();
    });
}

// Auto-refresh functionality for shipper pages
function enableAutoRefresh(intervalMinutes = 5) {
    if (window.location.pathname.includes('/shipper/orders')) {
        setInterval(function() {
            if (document.hasFocus() && !document.querySelector('.modal.show')) {
                window.location.reload();
            }
        }, intervalMinutes * 60 * 1000);
    }
}

// Initialize auto-refresh
enableAutoRefresh(5);

// Export functions for global use
window.shipperUtils = {
    showNotification: showShipperNotification,
    showLoadingSpinner: showLoadingSpinner
};

// Export functions for global use
window.updateOrderStatus = updateOrderStatus;
window.viewOrderDetails = viewOrderDetails;
window.refreshPage = refreshPage;
window.showToast = showToast;
