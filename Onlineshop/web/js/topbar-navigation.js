/**
 * Topbar and Sidebar Navigation Management
 * Handles active link highlighting and navigation logic
 */

document.addEventListener('DOMContentLoaded', function() {
    // Get current URL path
    const currentPath = window.location.pathname;
    const urlParams = new URLSearchParams(window.location.search);
    
    // Get all navigation links
    const navLinks = document.querySelectorAll('.sidebar-menu .nav-link');
    
    // Remove existing active classes
    navLinks.forEach(link => {
        link.classList.remove('active');
        link.parentElement.classList.remove('active');
    });
    
    // Find matching link and set active
    navLinks.forEach(link => {
        const href = link.getAttribute('href');
        if (href) {
            // Check for exact match first
            if (currentPath === href || currentPath.endsWith(href)) {
                link.classList.add('active');
                link.parentElement.classList.add('active');
            }
            // Check for shipper dashboard
            else if (currentPath.includes('/shipper/dashboard') && href.includes('/shipper/dashboard')) {
                link.classList.add('active');
                link.parentElement.classList.add('active');
            }
            // Check for shipper orders with status parameter
            else if (currentPath.includes('/shipper/orders')) {
                const status = urlParams.get('status');
                if (href.includes('/shipper/orders')) {
                    if (status && href.includes('status=' + status)) {
                        link.classList.add('active');
                        link.parentElement.classList.add('active');
                    } else if (!status && !href.includes('status=')) {
                        link.classList.add('active');
                        link.parentElement.classList.add('active');
                    }
                }
            }
            // Check for manager routes
            else if (currentPath.includes('/managerproductlist') && href.includes('managerproductlist')) {
                link.classList.add('active');
                link.parentElement.classList.add('active');
            }
            else if (currentPath.includes('/viewcategorylist') && href.includes('viewcategorylist')) {
                link.classList.add('active');
                link.parentElement.classList.add('active');
            }
            else if (currentPath.includes('/managermateriallist') && href.includes('managermateriallist')) {
                link.classList.add('active');
                link.parentElement.classList.add('active');
            }
            // Check for staff routes
            else if (currentPath.includes('/staff/') && href.includes('/staff/')) {
                const staffRoute = currentPath.split('/staff/')[1];
                if (href.includes('/staff/' + staffRoute)) {
                    link.classList.add('active');
                    link.parentElement.classList.add('active');
                }
            }
        }
    });
    
    // Initialize tooltips
    var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });
});
