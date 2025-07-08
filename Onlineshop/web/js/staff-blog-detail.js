// Staff Blog Detail JavaScript

document.addEventListener('DOMContentLoaded', function() {
    initializeBlogDetail();
});

function initializeBlogDetail() {
    // Auto-hide alerts after 5 seconds
    autoHideAlerts();
    
    // Initialize tooltips
    initializeTooltips();
    
    // Initialize image gallery
    initializeImageGallery();
    
    // Initialize responsive design
    handleResponsiveDesign();
}

function autoHideAlerts() {
    const alerts = document.querySelectorAll('.alert');
    alerts.forEach(alert => {
        setTimeout(() => {
            const bsAlert = new bootstrap.Alert(alert);
            bsAlert.close();
        }, 5000);
    });
}

function initializeTooltips() {
    const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });
}

function initializeImageGallery() {
    // Add click handlers to gallery images
    const galleryItems = document.querySelectorAll('.gallery-item img');
    galleryItems.forEach(img => {
        img.addEventListener('click', function() {
            const src = this.src;
            const alt = this.alt;
            openImageModal(src, alt);
        });
    });
    
    // Add keyboard navigation for image modal
    document.addEventListener('keydown', function(e) {
        const imageModal = document.getElementById('imageModal');
        if (imageModal && imageModal.classList.contains('show')) {
            if (e.key === 'Escape') {
                const modal = bootstrap.Modal.getInstance(imageModal);
                modal.hide();
            }
        }
    });
}

function openImageModal(imageSrc, imageAlt) {
    const modal = document.getElementById('imageModal');
    const modalImage = document.getElementById('modalImage');
    const modalTitle = document.getElementById('imageModalTitle');
    
    if (modal && modalImage) {
        modalImage.src = imageSrc;
        modalImage.alt = imageAlt;
        modalTitle.textContent = imageAlt || 'Xem ảnh';
        
        const imageModal = new bootstrap.Modal(modal);
        imageModal.show();
        
        // Preload image
        const img = new Image();
        img.onload = function() {
            modalImage.style.opacity = '1';
        };
        img.src = imageSrc;
        modalImage.style.opacity = '0.5';
    }
}

function handleResponsiveDesign() {
    const isMobile = window.innerWidth <= 768;
    
    // Adjust image gallery for mobile
    const imageGallery = document.querySelector('.image-gallery');
    if (imageGallery && isMobile) {
        imageGallery.classList.add('mobile-gallery');
    }
    
    // Adjust action buttons for mobile
    const actionButtons = document.querySelector('.action-buttons');
    if (actionButtons && isMobile) {
        actionButtons.classList.add('mobile-actions');
    }
}

// Listen for window resize
window.addEventListener('resize', handleResponsiveDesign);

// Function to show loading states for action buttons
function showActionLoading(button, text = 'Đang xử lý...') {
    if (button) {
        const originalHtml = button.innerHTML;
        button.innerHTML = `<i class="fas fa-spinner fa-spin"></i> ${text}`;
        button.disabled = true;
        
        return function() {
            button.innerHTML = originalHtml;
            button.disabled = false;
        };
    }
}

// Function to copy blog URL to clipboard
function copyBlogUrl() {
    const url = window.location.href;
    if (navigator.clipboard) {
        navigator.clipboard.writeText(url).then(function() {
            showSuccessMessage('Đã sao chép URL blog vào clipboard');
        }, function() {
            fallbackCopyTextToClipboard(url);
        });
    } else {
        fallbackCopyTextToClipboard(url);
    }
}

function fallbackCopyTextToClipboard(text) {
    const textArea = document.createElement("textarea");
    textArea.value = text;
    textArea.style.top = "0";
    textArea.style.left = "0";
    textArea.style.position = "fixed";
    
    document.body.appendChild(textArea);
    textArea.focus();
    textArea.select();
    
    try {
        const successful = document.execCommand('copy');
        if (successful) {
            showSuccessMessage('Đã sao chép URL blog vào clipboard');
        } else {
            showErrorMessage('Không thể sao chép URL');
        }
    } catch (err) {
        showErrorMessage('Không thể sao chép URL');
    }
    
    document.body.removeChild(textArea);
}

// Function to print blog content
function printBlog() {
    const blogContent = document.querySelector('.blog-content-card').cloneNode(true);
    
    // Remove action buttons and interactive elements
    const actionsToRemove = blogContent.querySelectorAll('.btn, .action-buttons, .image-overlay');
    actionsToRemove.forEach(el => el.remove());
    
    // Create print window
    const printWindow = window.open('', '_blank');
    printWindow.document.write(`
        <!DOCTYPE html>
        <html>
        <head>
            <title>In Blog</title>
            <style>
                body { font-family: Arial, sans-serif; margin: 20px; }
                .blog-header { margin-bottom: 30px; }
                .blog-title { color: #2c3e50; font-size: 2rem; margin-bottom: 10px; }
                .blog-meta { color: #7f8c8d; margin-bottom: 20px; }
                .main-image { max-width: 100%; height: auto; margin: 20px 0; }
                .blog-text-content { line-height: 1.6; color: #2c3e50; }
                .status-badge { padding: 4px 8px; border-radius: 4px; font-size: 0.8rem; }
                .status-pending { background: #f39c12; color: white; }
                .status-approved { background: #27ae60; color: white; }
                .status-rejected { background: #e74c3c; color: white; }
                @media print {
                    body { margin: 0; }
                    .main-image { page-break-inside: avoid; }
                }
            </style>
        </head>
        <body>
            ${blogContent.innerHTML}
        </body>
        </html>
    `);
    
    printWindow.document.close();
    printWindow.focus();
    
    // Wait for images to load before printing
    setTimeout(() => {
        printWindow.print();
        printWindow.close();
    }, 1000);
}

// Utility functions for messages
function showSuccessMessage(message) {
    showMessage(message, 'success');
}

function showErrorMessage(message) {
    showMessage(message, 'danger');
}

function showInfoMessage(message) {
    showMessage(message, 'info');
}

function showMessage(message, type) {
    const alertHtml = `
        <div class="alert alert-${type} alert-dismissible fade show" role="alert">
            <i class="fas fa-${type === 'success' ? 'check-circle' : type === 'danger' ? 'exclamation-circle' : 'info-circle'}"></i> 
            ${message}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    `;
    
    const container = document.querySelector('.container-fluid');
    if (container) {
        const firstChild = container.firstElementChild;
        firstChild.insertAdjacentHTML('beforebegin', alertHtml);
        
        // Auto-hide after delay
        setTimeout(() => {
            const alert = container.querySelector(`.alert-${type}`);
            if (alert) {
                const bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            }
        }, type === 'danger' ? 7000 : 5000);
    }
}

// Function to navigate between blog details (if needed for future implementation)
function navigateToBlog(direction) {
    // This could be implemented to navigate to next/previous blog
    // For now, just show a message
    showInfoMessage(`Tính năng điều hướng ${direction} sẽ được thêm trong tương lai`);
}

// Initialize keyboard shortcuts
document.addEventListener('keydown', function(e) {
    // Ctrl/Cmd + E for edit
    if ((e.ctrlKey || e.metaKey) && e.key === 'e') {
        e.preventDefault();
        const editBtn = document.querySelector('a[href*="/edit"]');
        if (editBtn) {
            editBtn.click();
        }
    }
    
    // Ctrl/Cmd + P for print
    if ((e.ctrlKey || e.metaKey) && e.key === 'p') {
        e.preventDefault();
        printBlog();
    }
    
    // Ctrl/Cmd + C for copy URL (when not in input field)
    if ((e.ctrlKey || e.metaKey) && e.key === 'c' && !e.target.matches('input, textarea')) {
        // Don't interfere with normal copy operations
        // This would need more specific implementation
    }
});
