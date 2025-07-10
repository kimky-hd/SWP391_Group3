// Manager Dashboard JavaScript
document.addEventListener('DOMContentLoaded', function() {
    // Initialize manager-specific functionality
    initManagerDashboard();
    initSidebarToggle();
    initActiveNavigation();
    initTooltips();
    
    // Force apply manager theme
    applyManagerTheme();
});

function initManagerDashboard() {
    console.log('Manager Dashboard initialized');
    
    // Manager-specific animations
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
    
    // Add loading animation for manager actions
    const managerActions = document.querySelectorAll('[data-manager-action]');
    managerActions.forEach(action => {
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

// Force apply manager theme on page load
function applyManagerTheme() {
    const body = document.body;
    const roleId = body.getAttribute('data-role');
    
    if (roleId === '1') {
        // Force manager theme
        body.classList.add('manager-theme');
        
        // Force override any conflicting styles
        const style = document.createElement('style');
        style.textContent = `
            body[data-role="1"] .sidebar {
                background: linear-gradient(180deg, #1e40af 0%, #3b82f6 100%) !important;
            }
            body[data-role="1"] .topbar-brand {
                color: #1e40af !important;
            }
            body[data-role="1"] .btn-primary {
                background: #1e40af !important;
                border-color: #1e40af !important;
            }
        `;
        document.head.appendChild(style);
    }
}

// Manager-specific utility functions
function showManagerNotification(message, type = 'success') {
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

// Export functions for global use
window.managerUtils = {
    showNotification: showManagerNotification,
    showLoadingSpinner: showLoadingSpinner
};
