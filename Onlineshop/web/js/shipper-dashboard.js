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
    // Show loading state
    document.getElementById('orderDetailsContent').innerHTML = `
        <div class="loading-spinner">
            <div class="spinner-border text-primary" role="status">
                <span class="visually-hidden">Loading...</span>
            </div>
            <p class="mt-3 text-muted">Đang tải chi tiết đơn hàng #${orderId}...</p>
        </div>
    `;
    
    // Show modal
    const modal = new bootstrap.Modal(document.getElementById('orderDetailsModal'));
    modal.show();
    
    // Update modal title
    document.getElementById('orderDetailsModalLabel').innerHTML = `
        <i class="fas fa-info-circle me-2"></i>
        Chi tiết đơn hàng #${orderId}
    `;
    
    // Try to get order data from table first
    let orderFromTable = null;
    
    // Find order row by searching through all table rows
    const allRows = document.querySelectorAll('.order-row');
    allRows.forEach(row => {
        const orderIdCell = row.querySelector('td strong');
        if (orderIdCell && orderIdCell.textContent.includes('#' + orderId)) {
            const cells = row.querySelectorAll('td');
            if (cells.length >= 5) {
                // Extract customer info from second cell
                const customerInfo = cells[1];
                const customerName = customerInfo.querySelector('.fw-bold')?.textContent || 'Khách hàng';
                const customerPhone = customerInfo.querySelector('.text-muted')?.textContent || '';
                
                // Extract price and format it
                const priceText = cells[3]?.textContent?.trim() || '0';
                const priceNumber = parseFloat(priceText.replace(/[^\d]/g, '')) || 0;
                
                orderFromTable = {
                    maHD: orderId,
                    customerName: customerName,
                    customerPhone: customerPhone,
                    customerEmail: 'Đang tải...', // Will be fetched from server
                    customerAddress: cells[2]?.textContent?.trim() || 'Địa chỉ giao hàng',
                    tongGia: priceNumber,
                    ngayXuat: cells[4]?.textContent || new Date().toLocaleDateString('vi-VN'),
                    statusID: parseInt(row.getAttribute('data-status')) || 2,
                    shipperName: 'Chưa phân công',
                    items: [
                        {
                            name: 'Đơn hàng hoa',
                            quantity: 1,
                            price: priceNumber, // Use the extracted price
                            total: priceNumber, // Total = price * 1
                            image: 'default-flower.jpg',
                            description: 'Chi tiết sản phẩm cần được tải từ server'
                        }
                    ]
                };
            }
        }
    });
    
    if (orderFromTable) {
        // Use data from table as base, but get email from server
        
        // Get complete data from server for products, email and shipper info
        const contextPath = getContextPath();
        fetch(`${contextPath}/shipper/order-detail?orderId=${orderId}`, {
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json'
            }
        })
            .then(response => {
                if (response.ok) {
                    return response.json();
                } else {
                    throw new Error('Server không phản hồi');
                }
            })
            .then(serverData => {
                // Use server data as primary source, fill with table data as fallback
                const completeOrder = {
                maHD: serverData.maHD || orderFromTable.maHD,
                customerName: serverData.customerName || orderFromTable.customerName,
                customerPhone: serverData.customerPhone || orderFromTable.customerPhone,
                customerEmail: serverData.customerEmail || 'Chưa có email',
                customerAddress: serverData.customerAddress || orderFromTable.customerAddress,
                tongGia: serverData.tongGia || orderFromTable.tongGia,
                ngayXuat: serverData.ngayXuat || orderFromTable.ngayXuat,
                statusID: serverData.statusID || orderFromTable.statusID,
                shipperName: serverData.shipperName || 'Chưa phân công',
                note: serverData.note || '',
                items: serverData.items && serverData.items.length > 0 ? serverData.items : orderFromTable.items
            };
                // Display the complete data
                displayOrderDetails(completeOrder);
            })
            .catch(error => {
                // Display table data first
                displayOrderDetails(orderFromTable);
                // Then try to fetch email separately
                fetchCustomerEmail(orderFromTable);
            });
    } else {
        // Try to fetch complete order data from server
        const contextPath = getContextPath();
        fetch(`${contextPath}/shipper/order-detail?orderId=${orderId}`, {
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json'
            }
        })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Server không phản hồi');
                }
                return response.json();
            })
            .then(orderData => {
                displayOrderDetails(orderData);
            })
            .catch(error => {
                // Create minimal fallback that encourages server implementation
                const fallbackOrder = {
                    maHD: orderId,
                    customerName: 'Đang tải...',
                    customerPhone: 'Đang tải...',
                    customerEmail: 'Đang tải...',
                    customerAddress: 'Đang tải...',
                    tongGia: 0,
                    ngayXuat: new Date().toLocaleDateString('vi-VN'),
                    statusID: 2,
                    shipperName: 'Đang tải...',
                    items: [
                        {
                            name: 'Đang tải thông tin sản phẩm...',
                            quantity: 1,
                            price: 0,
                            total: 0,
                            image: 'loading.png',
                            description: 'Cần kết nối server để lấy dữ liệu'
                        }
                    ]
                };
                setTimeout(() => displayOrderDetails(fallbackOrder), 500);
            });
    }
}

/**
 * Fetch customer email from inforline table
 */
function fetchCustomerEmail(orderData) {
    const contextPath = getContextPath();
    const customerName = encodeURIComponent(orderData.customerName);
    const customerPhone = encodeURIComponent(orderData.customerPhone);
    
    fetch(`${contextPath}/shipper/customer-email?name=${customerName}&phone=${customerPhone}`)
        .then(response => {
            if (response.ok) {
                return response.json();
            } else {
                throw new Error('Không thể lấy email khách hàng');
            }
        })
        .then(data => {
            // Update the order data with the email
            const updatedOrder = {
                ...orderData,
                customerEmail: data.email || 'Chưa có email'
            };
            // Refresh the display with the updated data
            displayOrderDetails(updatedOrder);
        })
        .catch(error => {
            // Keep the existing data
        });
}

/**
 * Display order details in modal
 */
function displayOrderDetails(order) {
    // Ensure all required fields have fallback values
    const safeOrder = {
        maHD: order.maHD || 'N/A',
        customerName: order.customerName || 'Khách hàng',
        customerPhone: order.customerPhone || 'Chưa có',
        customerEmail: order.customerEmail || 'Chưa có',
        customerAddress: order.customerAddress || 'Chưa có địa chỉ',
        tongGia: order.tongGia || 0,
        ngayXuat: order.ngayXuat || new Date().toISOString(),
        statusID: order.statusID || 2,
        shipperName: order.shipperName || 'Chưa phân công',
        note: order.note || '',
        items: order.items || []
    };
    
    const statusInfo = getStatusInfo(safeOrder.statusID);
    
    const content = `
        <!-- Order Basic Info -->
        <div class="order-detail-section">
            <h6><i class="fas fa-info-circle me-2"></i>Thông tin đơn hàng</h6>
            <div class="order-info-grid">
                <div class="info-item">
                    <i class="fas fa-hashtag"></i>
                    <span class="label">Mã đơn hàng:</span>
                    <span class="value">#${safeOrder.maHD}</span>
                </div>
                <div class="info-item">
                    <i class="fas fa-calendar"></i>
                    <span class="label">Ngày tạo:</span>
                    <span class="value">${formatDate(safeOrder.ngayXuat)}</span>
                </div>
                <div class="info-item">
                    <i class="fas fa-flag"></i>
                    <span class="label">Trạng thái:</span>
                    <span class="status-badge" style="background-color: ${statusInfo.color}; color: white;">
                        <i class="${statusInfo.icon}"></i>
                        ${statusInfo.text}
                    </span>
                </div>
                <div class="info-item">
                    <i class="fas fa-user-tie"></i>
                    <span class="label">Shipper:</span>
                    <span class="value">${safeOrder.shipperName}</span>
                </div>
            </div>
        </div>

        <!-- Customer Info -->
        <div class="order-detail-section">
            <h6><i class="fas fa-user me-2"></i>Thông tin khách hàng</h6>
            <div class="order-info-grid">
                <div class="info-item">
                    <i class="fas fa-user"></i>
                    <span class="label">Tên:</span>
                    <span class="value">${safeOrder.customerName}</span>
                </div>
                <div class="info-item">
                    <i class="fas fa-phone"></i>
                    <span class="label">Điện thoại:</span>
                    <span class="value">${safeOrder.customerPhone}</span>
                </div>
                <div class="info-item">
                    <i class="fas fa-envelope"></i>
                    <span class="label">Email:</span>
                    <span class="value">${safeOrder.customerEmail}</span>
                </div>
                <div class="info-item">
                    <i class="fas fa-map-marker-alt"></i>
                    <span class="label">Địa chỉ:</span>
                    <span class="value">${safeOrder.customerAddress}</span>
                </div>
                ${safeOrder.note && safeOrder.note.trim() !== '' ? `
                <div class="info-item">
                    <i class="fas fa-sticky-note"></i>
                    <span class="label">Ghi chú:</span>
                    <span class="value">${safeOrder.note}</span>
                </div>
                ` : ''}
            </div>
        </div>

        <!-- Order Items -->
        <div class="order-detail-section">
            <h6><i class="fas fa-shopping-cart me-2"></i>Sản phẩm đặt hàng</h6>
            <div class="table-responsive order-items-table">
                <table class="table table-hover">
                    <thead>
                        <tr>
                            <th>Sản phẩm</th>
                            <th>Số lượng</th>
                            <th>Đơn giá</th>
                            <th>Thành tiền</th>
                        </tr>
                    </thead>
                    <tbody>
                        ${safeOrder.items.length > 0 ? safeOrder.items.map((item, index) => {
                            const imageUrl = getProductImageUrl(item.image);
                            const uniqueId = `product-img-${safeOrder.maHD}-${index}`;
                            
                            // Ensure price and total are numbers
                            const price = parseFloat(item.price) || 0;
                            const quantity = parseInt(item.quantity) || 1;
                            const total = parseFloat(item.total) || (price * quantity);
                            
                            return `
                            <tr>
                                <td>
                                    <div class="d-flex align-items-center">
                                        <div class="product-image-container me-3" style="width: 50px; height: 50px; position: relative;">
                                            <img id="${uniqueId}" 
                                                 src="${imageUrl}" 
                                                 alt="${item.name || 'Sản phẩm'}" 
                                                 class="product-image"
                                                 style="width: 100%; height: 100%; object-fit: cover; border-radius: 8px; background-color: #f8f9fa; opacity: 0; transition: opacity 0.3s ease;"
                                                 onload="this.style.opacity='1';"
                                                 onerror="handleImageError(this);">
                                        </div>
                                        <div>
                                            <div class="fw-bold">${item.name || 'Sản phẩm'}</div>
                                            <small class="text-muted">${item.description || ''}</small>
                                        </div>
                                    </div>
                                </td>
                                <td class="text-center">
                                    <span class="badge bg-secondary">${quantity}</span>
                                </td>
                                <td class="text-end">
                                    ${formatCurrency(price)}
                                </td>
                                <td class="text-end fw-bold">
                                    ${formatCurrency(total)}
                                </td>
                            </tr>`;
                        }).join('') : '<tr><td colspan="4" class="text-center text-muted py-4"><i class="fas fa-info-circle me-2"></i>Không có thông tin sản phẩm</td></tr>'}
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Order Timeline -->
        <div class="order-timeline">
            <h6><i class="fas fa-history me-2"></i>Lịch sử đơn hàng</h6>
            <div class="timeline-item ${safeOrder.statusID >= 1 ? 'active' : ''}">
                <strong>Đặt hàng</strong>
                <div class="text-muted small">${formatDate(safeOrder.ngayXuat)}</div>
            </div>
            <div class="timeline-item ${safeOrder.statusID >= 2 ? 'active' : ''}">
                <strong>Đã duyệt</strong>
                <div class="text-muted small">${safeOrder.approvedDate ? formatDate(safeOrder.approvedDate) : 'Chưa duyệt'}</div>
            </div>
            <div class="timeline-item ${safeOrder.statusID >= 3 ? 'active' : ''}">
                <strong>Đang giao hàng</strong>
                <div class="text-muted small">${safeOrder.shippingDate ? formatDate(safeOrder.shippingDate) : 'Chưa giao'}</div>
            </div>
            <div class="timeline-item ${safeOrder.statusID >= 4 ? 'active' : ''}">
                <strong>Đã giao thành công</strong>
                <div class="text-muted small">${safeOrder.deliveredDate ? formatDate(safeOrder.deliveredDate) : 'Chưa hoàn thành'}</div>
            </div>
            ${safeOrder.statusID === 6 ? `
                <div class="timeline-item active" style="color: #dc3545;">
                    <strong>Đã hủy</strong>
                    <div class="text-muted small">${safeOrder.cancelledDate ? formatDate(safeOrder.cancelledDate) : ''}</div>
                    ${safeOrder.cancelReason ? `<div class="small text-danger mt-1">Lý do: ${safeOrder.cancelReason}</div>` : ''}
                </div>
            ` : ''}
        </div>

        <!-- Total Section -->
        <div class="total-section">
            <h6 class="mb-0"><i class="fas fa-calculator me-2"></i>Tổng giá trị đơn hàng</h6>
            <div class="total-amount">${formatCurrency(safeOrder.tongGia)}</div>
        </div>
    `;
    
    document.getElementById('orderDetailsContent').innerHTML = content;
}

/**
 * Handle image loading errors to prevent flickering
 */
function handleImageError(imgElement) {
    if (imgElement.dataset.errorHandled === 'true') {
        return; // Already handled, prevent infinite loop
    }
    
    imgElement.dataset.errorHandled = 'true';
    imgElement.src = '/Onlineshop/img/product-1.jpg'; // Use existing product image as fallback
    imgElement.style.backgroundColor = '#e9ecef';
    imgElement.style.opacity = '1';
}

/**
 * Get proper product image URL with proper error handling
 */
function getProductImageUrl(imagePath) {
    if (!imagePath || imagePath === 'default-flower.jpg' || imagePath === 'loading.png') {
        return '/Onlineshop/img/product-1.jpg'; // Use existing product image as fallback
    }
    
    // If it's already a full URL or starts with /, use as is
    if (imagePath.startsWith('http') || imagePath.startsWith('/')) {
        return imagePath;
    }
    
    // If it contains img folder path, use as is with context
    if (imagePath.includes('img/')) {
        return `/Onlineshop/${imagePath}`;
    }
    
    // Otherwise, assume it's relative to the img folder
    return `/Onlineshop/img/${imagePath}`;
}

/**
 * Get status information
 */
function getStatusInfo(statusID) {
    const statusMap = {
        1: { text: 'Chờ duyệt', color: '#ffc107', icon: 'fas fa-clock' },
        2: { text: 'Đã duyệt', color: '#17a2b8', icon: 'fas fa-check-circle' },
        3: { text: 'Đang giao', color: '#007bff', icon: 'fas fa-truck' },
        4: { text: 'Đã giao', color: '#28a745', icon: 'fas fa-check-double' },
        6: { text: 'Đã hủy', color: '#dc3545', icon: 'fas fa-times-circle' }
    };
    return statusMap[statusID] || { text: 'Không xác định', color: '#6c757d', icon: 'fas fa-question' };
}

/**
 * Format currency
 */
function formatCurrency(amount) {
    return new Intl.NumberFormat('vi-VN', {
        style: 'currency',
        currency: 'VND'
    }).format(amount);
}

/**
 * Format date
 */
function formatDate(dateString) {
    if (!dateString) return 'Chưa có';
    
    // Handle various date formats
    let date;
    
    // If it's already in DD/MM/YYYY format, parse it correctly
    if (dateString.includes('/') && !dateString.includes('T')) {
        const parts = dateString.split(' ');
        if (parts.length > 1) {
            // Handle "00:00 07/01/2025" format
            const datePart = parts[1];
            const [day, month, year] = datePart.split('/');
            date = new Date(year, month - 1, day);
        } else {
            // Handle "07/01/2025" format
            const [day, month, year] = dateString.split('/');
            date = new Date(year, month - 1, day);
        }
    } else {
        // Handle ISO format
        date = new Date(dateString);
    }
    
    // Check if date is valid
    if (isNaN(date.getTime())) {
        return dateString; // Return original if can't parse
    }
    
    return date.toLocaleDateString('vi-VN', {
        year: 'numeric',
        month: '2-digit',
        day: '2-digit',
        hour: date.getHours() !== 0 ? '2-digit' : undefined,
        minute: date.getMinutes() !== 0 ? '2-digit' : undefined
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
