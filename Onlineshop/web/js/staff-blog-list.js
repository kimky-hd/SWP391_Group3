// Staff Blog List JavaScript

document.addEventListener('DOMContentLoaded', function() {
    initializeBlogList();
});

function initializeBlogList() {
    // Auto-hide alerts after 5 seconds
    const alerts = document.querySelectorAll('.alert');
    alerts.forEach(alert => {
        setTimeout(() => {
            const bsAlert = new bootstrap.Alert(alert);
            bsAlert.close();
        }, 5000);
    });
    
    // Initialize tooltips
    const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });
    
    // Smooth scroll for pagination
    const paginationLinks = document.querySelectorAll('.pagination .page-link');
    paginationLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            // Add loading state
            const originalText = this.innerHTML;
            this.innerHTML = '<i class="fas fa-spinner fa-spin"></i>';
            
            // Restore text after a short delay (in case the page loads quickly)
            setTimeout(() => {
                this.innerHTML = originalText;
            }, 1000);
        });
    });
    
    // Enhanced search functionality
    const searchForm = document.querySelector('.search-form');
    const searchInput = searchForm?.querySelector('input[name="keyword"]');
    
    if (searchInput) {
        // Add search suggestions or auto-complete here if needed
        searchInput.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                showSearchLoading();
            }
        });
    }
    
    if (searchForm) {
        searchForm.addEventListener('submit', function() {
            showSearchLoading();
        });
    }
}

// Direct delete function - No confirmation needed
function directDelete(blogId) {
    // Get context path and redirect to delete URL
    const contextPath = window.location.pathname.substring(0, window.location.pathname.indexOf('/', 1));
    window.location.href = contextPath + '/staff/blog/delete?id=' + blogId;
}

function showSearchLoading() {
    const searchBtn = document.querySelector('.search-form button[type="submit"]');
    if (searchBtn) {
        const originalHtml = searchBtn.innerHTML;
        searchBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang tìm...';
        searchBtn.disabled = true;
        
        // Re-enable after form submission
        setTimeout(() => {
            searchBtn.innerHTML = originalHtml;
            searchBtn.disabled = false;
        }, 2000);
    }
}

// Utility function to show loading states
function showLoading(element, text = 'Đang tải...') {
    if (element) {
        const originalHtml = element.innerHTML;
        element.innerHTML = `<i class="fas fa-spinner fa-spin"></i> ${text}`;
        element.disabled = true;
        
        return function() {
            element.innerHTML = originalHtml;
            element.disabled = false;
        };
    }
}

// Function to handle card hover effects
document.addEventListener('DOMContentLoaded', function() {
    const blogCards = document.querySelectorAll('.blog-card');
    
    blogCards.forEach(card => {
        card.addEventListener('mouseenter', function() {
            this.style.transform = 'translateY(-5px)';
        });
        
        card.addEventListener('mouseleave', function() {
            this.style.transform = 'translateY(0)';
        });
    });
});

// Function to handle responsive design
function handleResponsiveDesign() {
    const isMobile = window.innerWidth <= 768;
    const isTablet = window.innerWidth <= 992 && window.innerWidth > 768;
    
    // Adjust card layouts for different screen sizes
    const blogCards = document.querySelectorAll('.blog-card');
    blogCards.forEach(card => {
        if (isMobile) {
            card.classList.add('mobile-card');
        } else {
            card.classList.remove('mobile-card');
        }
    });
}

// Listen for window resize
window.addEventListener('resize', handleResponsiveDesign);

// Initialize responsive design on load
document.addEventListener('DOMContentLoaded', handleResponsiveDesign);

// Function to refresh blog list (useful for future AJAX implementations)
function refreshBlogList() {
    window.location.reload();
}

// Function to show success messages
function showSuccessMessage(message) {
    const alertHtml = `
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="fas fa-check-circle"></i> ${message}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    `;
    
    const container = document.querySelector('.container-fluid');
    if (container) {
        container.insertAdjacentHTML('afterbegin', alertHtml);
        
        // Auto-hide after 5 seconds
        setTimeout(() => {
            const alert = container.querySelector('.alert-success');
            if (alert) {
                const bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            }
        }, 5000);
    }
}

// Function to show error messages
function showErrorMessage(message) {
    const alertHtml = `
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="fas fa-exclamation-circle"></i> ${message}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    `;
    
    const container = document.querySelector('.container-fluid');
    if (container) {
        container.insertAdjacentHTML('afterbegin', alertHtml);
        
        // Auto-hide after 7 seconds for error messages
        setTimeout(() => {
            const alert = container.querySelector('.alert-danger');
            if (alert) {
                const bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            }
        }, 7000);
    }
}
