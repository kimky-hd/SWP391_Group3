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
    console.log('=== viewOrderDetails CALLED ===');
    console.log('OrderId:', orderId);
    console.log('typeof orderId:', typeof orderId);
    console.log('================================');
    
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
            'Accept': 'application/json',
            'X-Requested-With': 'XMLHttpRequest'
        }
    })
    .then(response => {
        if (response.ok) {
            return response.json();
        } else {
            throw new Error(`HTTP ${response.status}: ${response.statusText}`);
        }
    })
    .then(orderData => {
        console.log('=== ORDER DATA DEBUG ===');
        console.log('Full order data:', orderData);
        console.log('ImageNote value:', orderData.imageNote);
        console.log('ImageNote type:', typeof orderData.imageNote);
        console.log('ImageNote length:', orderData.imageNote ? orderData.imageNote.length : 'null/undefined');
        console.log('ImageNote trimmed:', orderData.imageNote ? orderData.imageNote.trim() : 'null/undefined');
        console.log('Status ID:', orderData.statusID);
        console.log('=== END DEBUG ===');
        
        contentDiv.innerHTML = generateOrderDetailsHTML(orderData);
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

// Function to generate order details HTML from JSON data
function generateOrderDetailsHTML(orderData) {
    console.log('=== generateOrderDetailsHTML called ===');
    console.log('Order data received in function:', orderData);
    console.log('ImageNote from orderData:', orderData.imageNote);
    console.log('======================================');
    
    const statusBadges = {
        2: '<span class="badge bg-warning">Sẵn sàng giao</span>',
        3: '<span class="badge bg-primary">Đang giao</span>',
        4: '<span class="badge bg-success">Đã giao</span>',
        10: '<span class="badge bg-danger">Giao không thành công</span>'
    };
    
    const statusBadge = statusBadges[orderData.statusID] || '<span class="badge bg-secondary">Khác</span>';
    
    // Generate items HTML
    let itemsHTML = '';
    if (orderData.items && orderData.items.length > 0) {
        orderData.items.forEach(item => {
            itemsHTML += `
                <tr>
                    <td>
                        <div class="d-flex align-items-center">
                            <img src="${getContextPath()}/img/${item.image}" alt="${item.name}" 
                                 class="product-image me-3" style="width: 50px; height: 50px; object-fit: cover; border-radius: 5px;">
                            <div>
                                <div class="fw-bold">${item.name}</div>
                                <small class="text-muted">${item.description}</small>
                            </div>
                        </div>
                    </td>
                    <td class="text-center">${item.quantity}</td>
                    <td class="text-end">${new Intl.NumberFormat('vi-VN').format(item.price)}đ</td>
                    <td class="text-end fw-bold">${new Intl.NumberFormat('vi-VN').format(item.total)}đ</td>
                </tr>
            `;
        });
    }
    
    // DEBUG: Check ImageNote value and logic
    console.log('=== IMAGE NOTE PROCESSING ===');
    console.log('Raw ImageNote:', orderData.imageNote);
    console.log('ImageNote type:', typeof orderData.imageNote);
    console.log('ImageNote is null:', orderData.imageNote === null);
    console.log('ImageNote is undefined:', orderData.imageNote === undefined);
    console.log('ImageNote is empty string:', orderData.imageNote === '');
    if (orderData.imageNote) {
        console.log('ImageNote length:', orderData.imageNote.length);
        console.log('ImageNote trimmed:', orderData.imageNote.trim());
        console.log('ImageNote trimmed length:', orderData.imageNote.trim().length);
    }
    console.log('Condition result (imageNote && trim !== ""):', orderData.imageNote && orderData.imageNote.trim() !== '');
    console.log('=== END IMAGE NOTE PROCESSING ===');
    
    return `
        <div class="order-detail-section">
            <h6><i class="fas fa-info-circle me-2"></i>Thông tin đơn hàng</h6>
            <div class="order-info-grid">
                <div class="info-item">
                    <i class="fas fa-hashtag"></i>
                    <span class="label">Mã đơn hàng:</span>
                    <span class="value">#${orderData.maHD}</span>
                </div>
                <div class="info-item">
                    <i class="fas fa-calendar-alt"></i>
                    <span class="label">Ngày tạo:</span>
                    <span class="value">${new Date(orderData.ngayXuat).toLocaleDateString('vi-VN')}</span>
                </div>
                <div class="info-item">
                    <i class="fas fa-tag"></i>
                    <span class="label">Trạng thái:</span>
                    <span class="value">${statusBadge}</span>
                </div>
            </div>
        </div>

        <div class="order-detail-section">
            <h6><i class="fas fa-user me-2"></i>Thông tin khách hàng </h6>
            <div class="order-info-grid">
                <div class="info-item">
                    <i class="fas fa-user"></i>
                    <span class="label">Tên:</span>
                    <span class="value">${orderData.customerName}</span>
                </div>
                <div class="info-item">
                    <i class="fas fa-phone"></i>
                    <span class="label">Điện thoại:</span>
                    <span class="value">${orderData.customerPhone}</span>
                </div>
                <div class="info-item">
                    <i class="fas fa-envelope"></i>
                    <span class="label">Email:</span>
                    <span class="value">${orderData.customerEmail}</span>
                </div>
                <div class="info-item">
                    <i class="fas fa-map-marker-alt"></i>
                    <span class="label">Địa chỉ:</span>
                    <span class="value">${orderData.customerAddress}</span>
                </div>
            </div>
        </div>

        ${orderData.note && orderData.note.trim() !== '' ? `
        <div class="order-detail-section">
            <h6><i class="fas fa-sticky-note me-2"></i>Ghi chú</h6>
            <div class="alert alert-info">
                <i class="fas fa-info-circle me-2"></i>
                ${orderData.note}
            </div>
        </div>
        ` : ''}

        <div class="order-detail-section">
            <h6><i class="fas fa-image me-2"></i>Ảnh minh chứng giao hàng</h6>
            ${orderData.imageNote && orderData.imageNote.trim() !== '' ? `
                <div class="text-center">
                    <img src="${getContextPath()}/uploads/${orderData.imageNote}" 
                         alt="Ảnh minh chứng giao hàng" 
                         class="img-fluid rounded shadow-sm"
                         style="max-width: 400px; max-height: 300px; cursor: pointer;"
                         onclick="showImageModal('${getContextPath()}/uploads/${orderData.imageNote}', 'Ảnh minh chứng giao hàng')">
                    <br>
                    <button class="btn btn-outline-primary btn-sm mt-2" 
                            onclick="downloadImage('${getContextPath()}/uploads/${orderData.imageNote}', 'delivery-evidence-${orderData.maHD}.jpg')">
                        <i class="fas fa-download me-1"></i>Tải xuống
                    </button>
                </div>
            ` : `
                <div class="text-center text-muted">
                    <i class="fas fa-image" style="font-size: 3rem; opacity: 0.3;"></i>
                    <p class="mt-2">Chưa có ảnh minh chứng</p>
                    <small class="text-muted">Ảnh sẽ được hiển thị sau khi giao hàng</small>
                </div>
            `}
        </div>

        <div class="order-detail-section">
            <h6><i class="fas fa-shopping-cart me-2"></i>Sản phẩm đặt hàng</h6>
            <div class="table-responsive">
                <table class="table order-items-table">
                    <thead>
                        <tr>
                            <th>Sản phẩm</th>
                            <th class="text-center">Số lượng</th>
                            <th class="text-end">Đơn giá</th>
                            <th class="text-end">Thành tiền</th>
                        </tr>
                    </thead>
                    <tbody>
                        ${itemsHTML}
                    </tbody>
                </table>
            </div>
        </div>

        <div class="total-section">
            <h5><i class="fas fa-calculator me-2"></i>Tổng cộng</h5>
            <div class="total-amount">${new Intl.NumberFormat('vi-VN').format(orderData.tongGia)}đ</div>
        </div>
    `;
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

// Function to show image in modal
function showImageModal(imageSrc, imageTitle) {
    // Create modal HTML if it doesn't exist
    let imageModal = document.getElementById('imageModal');
    if (!imageModal) {
        const modalHTML = `
            <div class="modal fade" id="imageModal" tabindex="-1" aria-labelledby="imageModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-lg modal-dialog-centered">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="imageModalLabel">Xem ảnh</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body text-center">
                            <img id="modalImage" src="" alt="" class="img-fluid">
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                            <button type="button" class="btn btn-primary" id="downloadBtn">
                                <i class="fas fa-download me-1"></i>Tải xuống
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        `;
        document.body.insertAdjacentHTML('beforeend', modalHTML);
        imageModal = document.getElementById('imageModal');
    }
    
    // Update modal content
    document.getElementById('imageModalLabel').textContent = imageTitle;
    document.getElementById('modalImage').src = imageSrc;
    document.getElementById('modalImage').alt = imageTitle;
    document.getElementById('downloadBtn').onclick = () => downloadImage(imageSrc, imageTitle + '.jpg');
    
    // Show modal
    const modal = new bootstrap.Modal(imageModal);
    modal.show();
}

// Function to download image
function downloadImage(imageSrc, filename) {
    fetch(imageSrc)
        .then(response => response.blob())
        .then(blob => {
            const url = window.URL.createObjectURL(blob);
            const a = document.createElement('a');
            a.style.display = 'none';
            a.href = url;
            a.download = filename;
            document.body.appendChild(a);
            a.click();
            window.URL.revokeObjectURL(url);
            document.body.removeChild(a);
        })
        .catch(error => {
            console.error('Error downloading image:', error);
            alert('Không thể tải xuống ảnh. Vui lòng thử lại.');
        });
}

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
window.showImageModal = showImageModal;
window.downloadImage = downloadImage;
