/* ===== STAFF THEME JAVASCRIPT - COMPLETELY STANDALONE ===== */
/* Professional Staff Panel Features */

// ===== IMMEDIATE EXECUTION ===== 
(function() {
    'use strict';
    
    // Check if we're in staff role immediately
    if (document.body && document.body.getAttribute('data-role') === '2') {
        console.log('🌿 Staff Panel JavaScript Loading...');
        
        // Force immediate data-role if missing
        if (!document.body.hasAttribute('data-role')) {
            document.body.setAttribute('data-role', '2');
        }
        
        // Add staff theme class immediately
        document.body.classList.add('staff-theme-active');
        
        // Set CSS custom properties
        const root = document.documentElement;
        root.style.setProperty('--staff-primary', '#059669');
        root.style.setProperty('--staff-secondary', '#10b981');
        root.style.setProperty('--staff-accent', '#34d399');
    }
})();

// ===== WAIT FOR DOM READY =====
document.addEventListener('DOMContentLoaded', function() {
    // Only execute for staff role
    if (document.body.getAttribute('data-role') !== '2') {
        return;
    }
    
    console.log('🚀 Initializing Staff Panel Features...');
    
    // Initialize all staff features
    initStaffTopbar();
    initStaffTheme();
    initStaffNavigation();
    initStaffMobileMenu();
    initStaffAnimations();
    initStaffInteractions();
    initStaffNotifications();
    initStaffKeyboardShortcuts();
    initStaffTooltips();
    
    // Fix layout and dropdown issues
    fixStaffLayout();
    fixStaffDropdowns();
    fixStaffLogoutAndLinks();
    preventStaffInterference();
    
    // Show welcome message
    setTimeout(() => {
        showStaffNotification('🌿 Welcome to Staff Panel!', 'success', 3000);
    }, 1000);
    
    console.log('✅ Staff Panel Ready!');
});

// ===== STAFF THEME INITIALIZATION =====
function initStaffTheme() {
    console.log('🎨 Applying Staff Theme...');
    
    // Force theme classes
    document.body.classList.add('staff-theme', 'staff-active');
    document.body.setAttribute('data-theme', 'staff');
    
    // Apply theme to specific elements
    const topbar = document.querySelector('.topbar');
    const sidebar = document.querySelector('.sidebar');
    const brand = document.querySelector('.topbar-brand');
    
    if (topbar) {
        topbar.classList.add('staff-topbar');
        topbar.style.cssText = `
            background: linear-gradient(135deg, #ffffff 0%, #f0fdf4 100%) !important;
            border-bottom: 3px solid #059669 !important;
            box-shadow: 0 4px 20px rgba(5, 150, 105, 0.15) !important;
            height: 70px !important;
            position: fixed !important;
            top: 0 !important;
            left: 0 !important;
            right: 0 !important;
            z-index: 1040 !important;
            width: 100% !important;
        `;
    }
    
    if (sidebar) {
        sidebar.classList.add('staff-sidebar');
        sidebar.style.cssText = `
            background: linear-gradient(180deg, #047857 0%, #10b981 100%) !important;
            border-right: 3px solid #059669 !important;
        `;
    }
    
    if (brand) {
        brand.style.cssText = `
            color: #059669 !important;
            font-weight: 800 !important;
            font-size: 26px !important;
            text-decoration: none !important;
            display: flex !important;
            align-items: center !important;
            gap: 15px !important;
            padding: 10px 20px !important;
            border-radius: 15px !important;
            background: rgba(5, 150, 105, 0.08) !important;
        `;
    }
    
    // Force body padding for fixed topbar
    document.body.style.paddingTop = '70px';
    
    console.log('✅ Staff Theme Applied');
}

// ===== STAFF NAVIGATION =====
function initStaffNavigation() {
    console.log('🧭 Setting up Staff Navigation...');
    
    const currentPath = window.location.pathname;
    const navLinks = document.querySelectorAll('.sidebar-menu .nav-link');
    
    navLinks.forEach((link, index) => {
        // Add staff-specific classes
        link.classList.add('staff-nav-link');
        
        // Check for active state
        const href = link.getAttribute('href');
        if (href && (currentPath.includes(href) || isStaffCurrentPage(href, currentPath))) {
            link.classList.add('active');
            console.log(`📍 Active page detected: ${href}`);
        }
        
        // Add enhanced hover effects
        link.addEventListener('mouseenter', function() {
            if (window.innerWidth > 768 && !this.classList.contains('active')) {
                this.style.transform = 'translateX(8px)';
                this.style.transition = 'all 0.3s ease';
                this.style.boxShadow = '0 4px 15px rgba(5, 150, 105, 0.2)';
            }
        });
        
        link.addEventListener('mouseleave', function() {
            if (!this.classList.contains('active')) {
                this.style.transform = 'translateX(0)';
                this.style.boxShadow = 'none';
            }
        });
        
        // Add click ripple effect
        link.addEventListener('click', function(e) {
            createStaffRipple(e, this);
            
            // Update active state
            navLinks.forEach(l => l.classList.remove('active'));
            this.classList.add('active');
            
            // Show loading for page transitions
            showStaffPageLoading();
        });
        
        // Animate on load
        setTimeout(() => {
            link.style.animation = `staffSlideInLeft 0.6s ease-out`;
            link.style.animationDelay = `${index * 0.1}s`;
        }, 100);
    });
    
    console.log('✅ Staff Navigation Ready');
}

// Check if current page matches navigation
function isStaffCurrentPage(href, currentPath) {
    const pathMappings = {
        'dashboard': ['dashboard', 'staff/dashboard'],
        'products': ['product', 'staff/products'],
        'orders': ['order', 'staff/orders'],
        'customers': ['customer', 'staff/customers'],
        'inventory': ['inventory', 'stock', 'warehouse'],
        'reports': ['report', 'analytics'],
        'support': ['support', 'help']
    };
    
    for (const [key, patterns] of Object.entries(pathMappings)) {
        if (href.includes(key)) {
            return patterns.some(pattern => currentPath.includes(pattern));
        }
    }
    return false;
}

// ===== STAFF MOBILE MENU =====
function initStaffMobileMenu() {
    console.log('📱 Setting up Staff Mobile Menu...');
    
    const mobileToggle = document.getElementById('mobileToggle');
    const sidebar = document.querySelector('.sidebar');
    const overlay = document.querySelector('.sidebar-overlay');
    
    if (mobileToggle) {
        mobileToggle.classList.add('staff-mobile-toggle');
        
        mobileToggle.addEventListener('click', function() {
            toggleStaffSidebar();
        });
    }
    
    if (overlay) {
        overlay.addEventListener('click', function() {
            closeStaffSidebar();
        });
    }
    
    // Close sidebar when clicking nav links on mobile
    const navLinks = document.querySelectorAll('.sidebar-menu .nav-link');
    navLinks.forEach(link => {
        link.addEventListener('click', function() {
            if (window.innerWidth <= 768) {
                setTimeout(() => closeStaffSidebar(), 300);
            }
        });
    });
    
    // Handle window resize
    window.addEventListener('resize', function() {
        if (window.innerWidth > 768) {
            closeStaffSidebar();
        }
    });
    
    console.log('✅ Staff Mobile Menu Ready');
}

function toggleStaffSidebar() {
    const sidebar = document.querySelector('.sidebar');
    const overlay = document.querySelector('.sidebar-overlay');
    
    if (sidebar && overlay) {
        const isOpen = sidebar.classList.contains('show');
        
        if (isOpen) {
            closeStaffSidebar();
        } else {
            openStaffSidebar();
        }
    }
}

function openStaffSidebar() {
    const sidebar = document.querySelector('.sidebar');
    const overlay = document.querySelector('.sidebar-overlay');
    
    if (sidebar) {
        sidebar.classList.add('show');
        sidebar.style.animation = 'staffSlideInLeft 0.3s ease-out';
    }
    
    if (overlay) {
        overlay.classList.add('show');
    }
    
    document.body.classList.add('sidebar-open');
    showStaffNotification('📱 Menu opened', 'info', 2000);
}

function closeStaffSidebar() {
    const sidebar = document.querySelector('.sidebar');
    const overlay = document.querySelector('.sidebar-overlay');
    
    if (sidebar) {
        sidebar.classList.remove('show');
        sidebar.style.animation = 'staffSlideOutLeft 0.3s ease-in';
    }
    
    if (overlay) {
        overlay.classList.remove('show');
    }
    
    document.body.classList.remove('sidebar-open');
}

// ===== STAFF ANIMATIONS =====
function initStaffAnimations() {
    console.log('✨ Setting up Staff Animations...');
    
    // Add custom animations
    const style = document.createElement('style');
    style.textContent = `
        @keyframes staffSlideInLeft {
            from { opacity: 0; transform: translateX(-30px); }
            to { opacity: 1; transform: translateX(0); }
        }
        
        @keyframes staffSlideOutLeft {
            from { opacity: 1; transform: translateX(0); }
            to { opacity: 0; transform: translateX(-100%); }
        }
        
        @keyframes staffFadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        @keyframes staffPulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.05); }
        }
        
        @keyframes staffRipple {
            to { transform: scale(4); opacity: 0; }
        }
    `;
    document.head.appendChild(style);
    
    // Animate cards and elements
    const cards = document.querySelectorAll('.card, .dashboard-card');
    cards.forEach((card, index) => {
        card.style.animation = `staffFadeIn 0.6s ease-out`;
        card.style.animationDelay = `${index * 0.1}s`;
        card.style.animationFillMode = 'backwards';
        
        // Add hover animation
        card.addEventListener('mouseenter', function() {
            this.style.transform = 'translateY(-5px) scale(1.02)';
            this.style.boxShadow = '0 10px 30px rgba(5, 150, 105, 0.2)';
        });
        
        card.addEventListener('mouseleave', function() {
            this.style.transform = 'translateY(0) scale(1)';
            this.style.boxShadow = '0 4px 15px rgba(0, 0, 0, 0.1)';
        });
    });
    
    console.log('✅ Staff Animations Ready');
}

// ===== STAFF INTERACTIONS =====
function initStaffInteractions() {
    console.log('🖱️ Setting up Staff Interactions...');
    
    // Enhance buttons
    const buttons = document.querySelectorAll('button, .btn');
    buttons.forEach(button => {
        if (button.classList.contains('btn-primary')) {
            button.style.background = 'linear-gradient(135deg, #059669, #10b981)';
            button.style.border = 'none';
            button.style.transition = 'all 0.3s ease';
            
            button.addEventListener('mouseenter', function() {
                this.style.transform = 'translateY(-2px)';
                this.style.boxShadow = '0 8px 25px rgba(5, 150, 105, 0.3)';
            });
            
            button.addEventListener('mouseleave', function() {
                this.style.transform = 'translateY(0)';
                this.style.boxShadow = 'none';
            });
        }
        
        // Add click animation
        button.addEventListener('click', function() {
            this.style.transform = 'scale(0.95)';
            setTimeout(() => {
                this.style.transform = '';
            }, 150);
        });
    });
    
    // Enhance form inputs
    const inputs = document.querySelectorAll('input, select, textarea');
    inputs.forEach(input => {
        input.addEventListener('focus', function() {
            this.style.borderColor = '#059669';
            this.style.boxShadow = '0 0 0 3px rgba(5, 150, 105, 0.1)';
            this.style.transform = 'scale(1.02)';
        });
        
        input.addEventListener('blur', function() {
            this.style.borderColor = '';
            this.style.boxShadow = '';
            this.style.transform = '';
        });
    });
    
    console.log('✅ Staff Interactions Ready');
}

// ===== STAFF NOTIFICATIONS =====
function initStaffNotifications() {
    console.log('🔔 Setting up Staff Notifications...');
    
    // Create notification container
    let container = document.getElementById('staff-notifications');
    if (!container) {
        container = document.createElement('div');
        container.id = 'staff-notifications';
        container.style.cssText = `
            position: fixed;
            top: 90px;
            right: 20px;
            z-index: 9999;
            width: 350px;
            pointer-events: none;
        `;
        document.body.appendChild(container);
    }
    
    console.log('✅ Staff Notifications Ready');
}

function showStaffNotification(message, type = 'info', duration = 5000) {
    const container = document.getElementById('staff-notifications');
    if (!container) return;
    
    const notification = document.createElement('div');
    notification.style.cssText = `
        background: white;
        border-radius: 12px;
        box-shadow: 0 8px 32px rgba(5, 150, 105, 0.2);
        margin-bottom: 15px;
        overflow: hidden;
        transition: all 0.3s ease;
        pointer-events: auto;
        border-left: 5px solid ${getStaffNotificationColor(type)};
        animation: staffSlideInRight 0.3s ease-out;
    `;
    
    const icons = {
        success: 'fa-check-circle',
        error: 'fa-exclamation-circle',
        warning: 'fa-exclamation-triangle',
        info: 'fa-info-circle'
    };
    
    notification.innerHTML = `
        <div style="padding: 16px 20px; display: flex; align-items: center; gap: 12px;">
            <i class="fas ${icons[type]}" style="color: ${getStaffNotificationColor(type)}; font-size: 18px;"></i>
            <span style="color: #374151; font-weight: 500; flex: 1;">${message}</span>
            <button onclick="this.parentElement.parentElement.remove()" style="background: none; border: none; color: #9ca3af; cursor: pointer; padding: 4px; border-radius: 4px; transition: all 0.2s ease;">
                <i class="fas fa-times"></i>
            </button>
        </div>
    `;
    
    container.appendChild(notification);
    
    // Auto remove
    setTimeout(() => {
        if (notification.parentElement) {
            notification.style.opacity = '0';
            notification.style.transform = 'translateX(100%)';
            setTimeout(() => {
                if (notification.parentElement) {
                    notification.remove();
                }
            }, 300);
        }
    }, duration);
}

function getStaffNotificationColor(type) {
    const colors = {
        success: '#10b981',
        error: '#ef4444',
        warning: '#f59e0b',
        info: '#059669'
    };
    return colors[type] || colors.info;
}

// ===== STAFF KEYBOARD SHORTCUTS =====
function initStaffKeyboardShortcuts() {
    console.log('⌨️ Setting up Staff Keyboard Shortcuts...');
    
    document.addEventListener('keydown', function(e) {
        if (document.body.getAttribute('data-role') !== '2') return;
        
        // Ctrl + R: Refresh data
        if (e.ctrlKey && e.key === 'r') {
            e.preventDefault();
            refreshStaffData();
        }
        
        // Ctrl + E: Export report
        if (e.ctrlKey && e.key === 'e') {
            e.preventDefault();
            exportStaffReport();
        }
        
        // Ctrl + M: Toggle mobile menu
        if (e.ctrlKey && e.key === 'm') {
            e.preventDefault();
            toggleStaffSidebar();
        }
        
        // Escape: Close modals/overlays
        if (e.key === 'Escape') {
            closeStaffSidebar();
            const modals = document.querySelectorAll('.modal.show');
            modals.forEach(modal => {
                if (modal.classList.contains('show')) {
                    const closeBtn = modal.querySelector('.btn-close, [data-bs-dismiss="modal"]');
                    if (closeBtn) closeBtn.click();
                }
            });
        }
    });
    
    console.log('✅ Staff Keyboard Shortcuts Ready');
}

// ===== STAFF TOOLTIPS =====
function initStaffTooltips() {
    console.log('💡 Setting up Staff Tooltips...');
    
    // Initialize Bootstrap tooltips with staff theme
    const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    const tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl, {
            customClass: 'staff-tooltip'
        });
    });
    
    // Add custom tooltip styles
    const style = document.createElement('style');
    style.textContent = `
        .staff-tooltip .tooltip-inner {
            background: linear-gradient(135deg, #059669, #10b981) !important;
            color: white !important;
            border-radius: 8px !important;
            font-weight: 500 !important;
        }
        
        .staff-tooltip .tooltip-arrow::before {
            border-top-color: #059669 !important;
            border-bottom-color: #059669 !important;
        }
    `;
    document.head.appendChild(style);
    
    console.log('✅ Staff Tooltips Ready');
}

// ===== STAFF TOPBAR INITIALIZATION =====
function initStaffTopbar() {
    console.log('🔧 Initializing Staff Topbar...');
    
    const topbar = document.querySelector('.topbar');
    const topbarBrand = document.querySelector('.topbar-brand');
    const topbarActions = document.querySelector('.topbar-actions');
    const userDropdown = document.querySelector('.user-dropdown');
    
    if (topbar) {
        // Ensure topbar has correct styling
        topbar.style.cssText = `
            background: linear-gradient(135deg, #ffffff 0%, #f0fdf4 100%) !important;
            border-bottom: 3px solid #059669 !important;
            box-shadow: 0 4px 20px rgba(5, 150, 105, 0.15) !important;
            height: 70px !important;
            position: fixed !important;
            top: 0 !important;
            left: 0 !important;
            right: 0 !important;
            z-index: 1030 !important;
            width: 100% !important;
            backdrop-filter: blur(10px) !important;
        `;
        
        // Ensure container-fluid has correct styling
        const containerFluid = topbar.querySelector('.container-fluid');
        if (containerFluid) {
            containerFluid.style.cssText = `
                height: 70px !important;
                display: flex !important;
                align-items: center !important;
                justify-content: space-between !important;
                padding: 0 30px !important;
                margin: 0 !important;
                max-width: none !important;
                width: 100% !important;
                flex-wrap: nowrap !important;
            `;
        }
    }
    
    if (topbarBrand) {
        topbarBrand.style.cssText = `
            color: #059669 !important;
            font-weight: 800 !important;
            font-size: 22px !important;
            text-decoration: none !important;
            display: flex !important;
            align-items: center !important;
            gap: 12px !important;
            padding: 8px 16px !important;
            border-radius: 15px !important;
            background: rgba(5, 150, 105, 0.08) !important;
            height: 50px !important;
            min-width: 180px !important;
            flex-shrink: 0 !important;
        `;
        
        // Handle brand icon
        const brandIcon = topbarBrand.querySelector('.brand-icon');
        if (brandIcon) {
            brandIcon.style.cssText = `
                font-size: 20px !important;
                color: #10b981 !important;
                background: #d1fae5 !important;
                padding: 6px !important;
                border-radius: 50% !important;
                display: flex !important;
                align-items: center !important;
                justify-content: center !important;
                width: 32px !important;
                height: 32px !important;
                flex-shrink: 0 !important;
            `;
        }
    }
    
    if (topbarActions) {
        topbarActions.style.cssText = `
            display: flex !important;
            align-items: center !important;
            gap: 10px !important;
            margin: 0 !important;
            padding: 0 !important;
            list-style: none !important;
            flex-shrink: 0 !important;
            height: 50px !important;
            flex-direction: row !important;
        `;
        
        // Style action links
        const actionLinks = topbarActions.querySelectorAll('.nav-link:not(.user-dropdown)');
        actionLinks.forEach(link => {
            link.style.cssText = `
                color: #059669 !important;
                font-size: 16px !important;
                padding: 8px 12px !important;
                border-radius: 50% !important;
                display: flex !important;
                align-items: center !important;
                justify-content: center !important;
                width: 40px !important;
                height: 40px !important;
                text-decoration: none !important;
                position: relative !important;
            `;
        });
    }
    
    if (userDropdown) {
        userDropdown.style.cssText = `
            background: #d1fae5 !important;
            border-radius: 20px !important;
            padding: 6px 12px !important;
            color: #059669 !important;
            font-weight: 600 !important;
            min-width: 120px !important;
            height: 40px !important;
            display: flex !important;
            align-items: center !important;
            gap: 8px !important;
            font-size: 14px !important;
            white-space: nowrap !important;
            text-decoration: none !important;
        `;
        
        // Style user image
        const userImg = userDropdown.querySelector('img');
        if (userImg) {
            userImg.style.cssText = `
                width: 28px !important;
                height: 28px !important;
                border: 2px solid #10b981 !important;
                flex-shrink: 0 !important;
            `;
        }
    }
    
    // Fix dropdown positioning
    const dropdownMenu = document.querySelector('.dropdown-menu');
    if (dropdownMenu) {
        dropdownMenu.style.cssText = `
            background: #ffffff !important;
            border: 2px solid #d1fae5 !important;
            border-radius: 15px !important;
            box-shadow: 0 10px 30px rgba(5, 150, 105, 0.15) !important;
            padding: 10px 0 !important;
            min-width: 220px !important;
            margin-top: 5px !important;
            z-index: 1035 !important;
        `;
    }
    
    // Handle responsive behavior
    handleTopbarResponsive();
    
    console.log('✅ Staff Topbar initialized');
}

// ===== HANDLE TOPBAR RESPONSIVE =====
function handleTopbarResponsive() {
    const topbar = document.querySelector('.topbar');
    const topbarBrand = document.querySelector('.topbar-brand');
    const topbarActions = document.querySelector('.topbar-actions');
    
    function updateTopbarForScreen() {
        const screenWidth = window.innerWidth;
        
        if (screenWidth <= 576) {
            // Mobile phones
            if (topbar) {
                topbar.style.height = '60px !important';
                const containerFluid = topbar.querySelector('.container-fluid');
                if (containerFluid) {
                    containerFluid.style.cssText += `
                        height: 60px !important;
                        padding: 0 10px !important;
                    `;
                }
            }
            
            if (topbarBrand) {
                topbarBrand.style.cssText += `
                    height: 40px !important;
                    min-width: 60px !important;
                    font-size: 16px !important;
                `;
                
                const brandSpan = topbarBrand.querySelector('span');
                if (brandSpan) {
                    brandSpan.style.display = 'none !important';
                }
            }
            
        } else if (screenWidth <= 768) {
            // Tablets
            if (topbarBrand) {
                const brandSpan = topbarBrand.querySelector('span');
                if (brandSpan) {
                    brandSpan.style.fontSize = '12px !important';
                }
            }
            
        } else if (screenWidth <= 992) {
            // Small desktop
            if (topbar) {
                const containerFluid = topbar.querySelector('.container-fluid');
                if (containerFluid) {
                    containerFluid.style.padding = '0 20px !important';
                }
            }
            
        } else {
            // Large desktop - reset to default
            if (topbar) {
                topbar.style.height = '70px !important';
                const containerFluid = topbar.querySelector('.container-fluid');
                if (containerFluid) {
                    containerFluid.style.cssText = `
                        height: 70px !important;
                        padding: 0 30px !important;
                    `;
                }
            }
            
            if (topbarBrand) {
                topbarBrand.style.cssText = `
                    height: 50px !important;
                    min-width: 180px !important;
                    font-size: 22px !important;
                `;
                
                const brandSpan = topbarBrand.querySelector('span');
                if (brandSpan) {
                    brandSpan.style.display = 'block !important';
                    brandSpan.style.fontSize = '16px !important';
                }
            }
        }
    }
    
    // Update on load and resize
    updateTopbarForScreen();
    window.addEventListener('resize', updateTopbarForScreen);
}

// ===== FORCE TOPBAR INITIALIZATION =====
function initStaffTopbar() {
    console.log('🔧 Initializing Staff Topbar...');
    
    const topbar = document.querySelector('.topbar');
    const brand = document.querySelector('.topbar-brand');
    const container = document.querySelector('.topbar .container-fluid');
    
    if (topbar) {
        // Force topbar styles
        topbar.style.cssText = `
            background: linear-gradient(135deg, #ffffff 0%, #f0fdf4 100%) !important;
            border-bottom: 3px solid #059669 !important;
            box-shadow: 0 4px 20px rgba(5, 150, 105, 0.15) !important;
            height: 70px !important;
            position: fixed !important;
            top: 0 !important;
            left: 0 !important;
            right: 0 !important;
            z-index: 1040 !important;
            width: 100% !important;
        `;
        
        topbar.classList.add('staff-topbar-active');
    }
    
    if (container) {
        container.style.cssText = `
            height: 100% !important;
            display: flex !important;
            align-items: center !important;
            justify-content: space-between !important;
            padding: 0 30px !important;
            margin: 0 !important;
            max-width: none !important;
        `;
    }
    
    if (brand) {
        brand.style.cssText = `
            color: #059669 !important;
            font-weight: 800 !important;
            font-size: 26px !important;
            text-decoration: none !important;
            display: flex !important;
            align-items: center !important;
            gap: 15px !important;
            padding: 10px 20px !important;
            border-radius: 15px !important;
            background: rgba(5, 150, 105, 0.08) !important;
        `;
    }
    
    // Force body padding for fixed topbar
    document.body.style.paddingTop = '70px';
    
    console.log('✅ Staff Topbar Initialized');
}

// ===== FORCE REFRESH STYLES AFTER LOAD =====
window.addEventListener('load', function() {
    if (document.body.getAttribute('data-role') === '2') {
        setTimeout(() => {
            // Force refresh topbar
            initStaffTopbar();
            
            // Force refresh sidebar
            const sidebar = document.querySelector('.sidebar');
            if (sidebar) {
                sidebar.style.top = '70px';
                sidebar.style.height = 'calc(100vh - 70px)';
            }
            
            // Force refresh main content
            const mainContent = document.querySelector('.main-content');
            if (mainContent) {
                mainContent.style.marginTop = '70px';
                mainContent.style.marginLeft = '280px';
            }
            
            console.log('🔄 Staff styles force refreshed');
        }, 100);
    }
});

// ===== WINDOW RESIZE HANDLER =====
window.addEventListener('resize', function() {
    if (document.body.getAttribute('data-role') === '2') {
        // Ensure mobile menu closes on resize
        if (window.innerWidth > 768) {
            const sidebar = document.querySelector('.sidebar');
            const overlay = document.querySelector('.sidebar-overlay');
            if (sidebar) sidebar.classList.remove('show');
            if (overlay) overlay.classList.remove('show');
        }
    }
});

// ===== FIX DROPDOWN BEHAVIOR FOR STAFF =====
function fixStaffDropdowns() {
    console.log('🔧 Fixing Staff Dropdowns...');
    
    // Force hide all dropdowns initially
    const dropdowns = document.querySelectorAll('.dropdown-menu');
    dropdowns.forEach(dropdown => {
        dropdown.style.display = 'none';
        dropdown.style.opacity = '0';
        dropdown.style.visibility = 'hidden';
        dropdown.classList.remove('show');
    });
    
    // Handle dropdown toggle clicks
    const dropdownToggles = document.querySelectorAll('[data-bs-toggle="dropdown"]');
    dropdownToggles.forEach(toggle => {
        toggle.addEventListener('click', function(e) {
            e.preventDefault();
            e.stopPropagation();
            
            const targetId = this.getAttribute('id');
            const dropdownMenu = document.querySelector(`[aria-labelledby="${targetId}"]`);
            
            if (dropdownMenu) {
                const isShown = dropdownMenu.classList.contains('show');
                
                // Hide all other dropdowns first
                dropdowns.forEach(dd => {
                    dd.classList.remove('show');
                    dd.style.display = 'none';
                    dd.style.opacity = '0';
                    dd.style.visibility = 'hidden';
                });
                
                if (!isShown) {
                    // Show this dropdown
                    dropdownMenu.classList.add('show');
                    dropdownMenu.style.display = 'block';
                    dropdownMenu.style.opacity = '1';
                    dropdownMenu.style.visibility = 'visible';
                    dropdownMenu.style.transform = 'translateY(0)';
                }
            }
        });
    });
    
    // Handle dropdown item clicks - DON'T PREVENT DEFAULT for links and buttons
    const dropdownItems = document.querySelectorAll('.dropdown-item');
    dropdownItems.forEach(item => {
        item.addEventListener('click', function(e) {
            // Check if this is a link or has href
            const href = this.getAttribute('href');
            const isButton = this.tagName === 'BUTTON';
            const hasModal = this.getAttribute('data-bs-toggle') === 'modal';
            
            // If it's a regular link, let it work normally
            if (href && !href.startsWith('#') && !hasModal) {
                // Don't prevent default - let the link work
                console.log('🔗 Following link:', href);
                return;
            }
            
            // If it's a button or modal trigger, let it work
            if (isButton || hasModal) {
                console.log('🔘 Button/Modal trigger clicked');
                return;
            }
            
            // Only close dropdown for non-functional items
            setTimeout(() => {
                dropdowns.forEach(dropdown => {
                    dropdown.classList.remove('show');
                    dropdown.style.display = 'none';
                    dropdown.style.opacity = '0';
                    dropdown.style.visibility = 'hidden';
                });
            }, 100);
        });
    });
    
    // Hide dropdowns when clicking outside
    document.addEventListener('click', function(e) {
        if (!e.target.closest('.dropdown')) {
            dropdowns.forEach(dropdown => {
                dropdown.classList.remove('show');
                dropdown.style.display = 'none';
                dropdown.style.opacity = '0';
                dropdown.style.visibility = 'hidden';
            });
        }
    });
    
    console.log('✅ Staff Dropdowns fixed');
}

// ===== FIX LAYOUT ISSUES =====
function fixStaffLayout() {
    console.log('🔧 Fixing Staff Layout...');
    
    // Force correct body padding
    document.body.style.paddingTop = '70px';
    
    // Fix any overflow issues
    const topbar = document.querySelector('.topbar');
    if (topbar) {
        topbar.style.overflow = 'visible';
        topbar.style.position = 'fixed';
        topbar.style.width = '100%';
        topbar.style.zIndex = '1030';
    }
    
    // Fix container fluid
    const containerFluid = document.querySelector('.topbar .container-fluid');
    if (containerFluid) {
        containerFluid.style.overflow = 'visible';
        containerFluid.style.position = 'relative';
    }
    
    // Fix any stray elements
    const problematicElements = document.querySelectorAll('[style*="position: absolute"][style*="top"][style*="right"]');
    problematicElements.forEach(el => {
        if (el.textContent.includes('Đổi mật khẩu') || el.textContent.includes('Đăng xuất')) {
            el.style.position = 'static';
            el.style.top = 'auto';
            el.style.right = 'auto';
        }
    });
    
    console.log('✅ Staff Layout fixed');
}

// ===== FIX LOGOUT MODAL AND LINKS =====
function fixStaffLogoutAndLinks() {
    console.log('🔧 Fixing Staff Logout and Links...');
    
    // Fix logout button to trigger modal properly
    const logoutBtn = document.querySelector('.logout-btn');
    if (logoutBtn) {
        logoutBtn.addEventListener('click', function(e) {
            e.stopPropagation(); // Don't close dropdown immediately
            
            // Trigger the modal
            const modalTarget = this.getAttribute('data-bs-target');
            if (modalTarget) {
                const modal = document.querySelector(modalTarget);
                if (modal) {
                    // Use Bootstrap modal if available
                    if (window.bootstrap && bootstrap.Modal) {
                        const bsModal = new bootstrap.Modal(modal);
                        bsModal.show();
                    } else {
                        // Fallback to manual show
                        modal.classList.add('show');
                        modal.style.display = 'block';
                        document.body.classList.add('modal-open');
                    }
                }
            }
            
            console.log('🚪 Logout modal triggered');
        });
    }
    
    // Fix profile and other dropdown links
    const profileLink = document.querySelector('a[href="profile.jsp"]');
    if (profileLink) {
        profileLink.addEventListener('click', function(e) {
            console.log('👤 Profile link clicked');
            // Let the default behavior work
        });
    }
    
    const changePasswordLink = document.querySelector('a[href="changepassword.jsp"]');
    if (changePasswordLink) {
        changePasswordLink.addEventListener('click', function(e) {
            console.log('🔑 Change password link clicked');
            // Let the default behavior work
        });
    }
    
    // Fix final logout confirmation link
    const finalLogoutLink = document.querySelector('a[href="LogoutServlet"]');
    if (finalLogoutLink) {
        finalLogoutLink.addEventListener('click', function(e) {
            console.log('🚪 Final logout link clicked');
            
            // Show loading message
            showStaffNotification('🔄 Đang đăng xuất...', 'info', 2000);
            
            // Add loading state to button
            this.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Đang đăng xuất...';
            this.style.pointerEvents = 'none';
            
            // Let the default behavior work (redirect to LogoutServlet)
        });
    }
    
    console.log('✅ Staff Logout and Links fixed');
}

// ===== PREVENT JAVASCRIPT INTERFERENCE =====
function preventStaffInterference() {
    console.log('🛡️ Preventing Staff JS Interference...');
    
    // Don't interfere with Bootstrap modal functionality
    const modalButtons = document.querySelectorAll('[data-bs-toggle="modal"]');
    modalButtons.forEach(btn => {
        // Remove any existing event listeners that might interfere
        const newBtn = btn.cloneNode(true);
        btn.parentNode.replaceChild(newBtn, btn);
        
        console.log('🔧 Modal button behavior reset');
    });
    
    // Don't interfere with normal links
    const normalLinks = document.querySelectorAll('a[href]:not([href^="#"]):not([data-bs-toggle])');
    normalLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            // Don't prevent default for normal links
            console.log('🔗 Normal link clicked:', this.href);
        });
    });
    
    console.log('✅ Staff JS Interference prevented');
}

// ===== UTILITY FUNCTIONS =====
function createStaffRipple(event, element) {
    const ripple = document.createElement('span');
    const rect = element.getBoundingClientRect();
    const size = Math.max(rect.width, rect.height);
    
    ripple.style.cssText = `
        position: absolute;
        border-radius: 50%;
        background: rgba(255, 255, 255, 0.3);
        width: ${size}px;
        height: ${size}px;
        left: ${event.clientX - rect.left - size / 2}px;
        top: ${event.clientY - rect.top - size / 2}px;
        animation: staffRipple 0.6s ease-out;
        pointer-events: none;
    `;
    
    element.style.position = 'relative';
    element.style.overflow = 'hidden';
    element.appendChild(ripple);
    
    setTimeout(() => {
        if (ripple.parentElement) {
            ripple.remove();
        }
    }, 600);
}

function showStaffPageLoading() {
    const loading = document.createElement('div');
    loading.style.cssText = `
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 4px;
        background: linear-gradient(90deg, #059669, #10b981, #34d399);
        background-size: 200% 100%;
        z-index: 9999;
        animation: staffLoadingBar 1s ease-in-out infinite;
    `;
    
    const style = document.createElement('style');
    style.textContent = `
        @keyframes staffLoadingBar {
            0% { background-position: -200% 0; }
            100% { background-position: 200% 0; }
        }
    `;
    document.head.appendChild(style);
    document.body.appendChild(loading);
    
    setTimeout(() => {
        if (loading.parentElement) {
            loading.remove();
        }
    }, 2000);
}

function refreshStaffData() {
    console.log('🔄 Refreshing Staff Data...');
    showStaffNotification('🔄 Refreshing data...', 'info', 2000);
    
    // Simulate data refresh
    setTimeout(() => {
        showStaffNotification('✅ Data refreshed successfully!', 'success');
        console.log('✅ Staff Data Refreshed');
    }, 2000);
}

function exportStaffReport() {
    console.log('📄 Exporting Staff Report...');
    showStaffNotification('📄 Exporting report...', 'info', 3000);
    
    // Simulate export process
    setTimeout(() => {
        showStaffNotification('📄 Report exported successfully!', 'success');
        console.log('✅ Staff Report Exported');
    }, 3000);
}

// ===== STAFF SCROLL EFFECTS =====
window.addEventListener('scroll', function() {
    if (document.body.getAttribute('data-role') !== '2') return;
    
    const scrollTop = window.pageYOffset;
    const topbar = document.querySelector('.topbar');
    
    if (topbar) {
        if (scrollTop > 50) {
            topbar.style.backdropFilter = 'blur(15px)';
            topbar.style.boxShadow = '0 6px 30px rgba(5, 150, 105, 0.25)';
        } else {
            topbar.style.backdropFilter = 'blur(10px)';
            topbar.style.boxShadow = '0 4px 20px rgba(5, 150, 105, 0.15)';
        }
    }
});

// ===== EXPORT STAFF UTILITIES =====
window.staffUtils = {
    showNotification: showStaffNotification,
    refreshData: refreshStaffData,
    exportReport: exportStaffReport,
    toggleSidebar: toggleStaffSidebar,
    createRipple: createStaffRipple
};

// ===== STAFF READY INDICATOR =====
window.addEventListener('load', function() {
    if (document.body.getAttribute('data-role') === '2') {
        console.log('🎉 Staff Panel Fully Loaded!');
        
        // Re-initialize topbar after full load
        initStaffTopbar();
        
        // Re-fix dropdown and links after everything is loaded
        setTimeout(() => {
            fixStaffDropdowns();
            fixStaffLogoutAndLinks();
            preventStaffInterference();
        }, 500);
        
        // Add final success animation
        const style = document.createElement('style');
        style.textContent = `
            @keyframes staffSlideInRight {
                from { opacity: 0; transform: translateX(100%); }
                to { opacity: 1; transform: translateX(0); }
            }
        `;
        document.head.appendChild(style);
        
        // Show completion message
        setTimeout(() => {
            showStaffNotification('🎉 Staff Panel loaded successfully!', 'success', 4000);
        }, 1000);
    }
});

// ===== REVIEW CONTENT TOGGLE FUNCTION =====
// Toggle review content expand/collapse for reviews page
function toggleReviewContent(reviewId) {
    console.log('🔄 Toggling review content for ID:', reviewId);

    const contentDiv = document.getElementById('content-' + reviewId);
    if (!contentDiv) {
        console.error('❌ Content div not found for review ID:', reviewId);
        return;
    }

    const shortText = contentDiv.querySelector('.short-text');
    const fullText = contentDiv.querySelector('.full-text');
    const expandText = contentDiv.querySelector('.expand-text');

    if (!shortText || !fullText || !expandText) {
        console.error('❌ Required elements not found for review ID:', reviewId);
        return;
    }

    if (contentDiv.classList.contains('collapsed')) {
        // Expand
        console.log('📖 Expanding review content');
        contentDiv.classList.remove('collapsed');
        contentDiv.classList.add('expanded');
        shortText.style.display = 'none';
        fullText.style.display = 'inline';
        expandText.textContent = 'Thu gọn';
    } else {
        // Collapse
        console.log('📕 Collapsing review content');
        contentDiv.classList.remove('expanded');
        contentDiv.classList.add('collapsed');
        shortText.style.display = 'inline';
        fullText.style.display = 'none';
        expandText.textContent = 'Xem chi tiết';
    }
}

// Make function globally available
window.toggleReviewContent = toggleReviewContent;

// ===== REVIEW IMAGES MODAL FUNCTIONS =====
let currentImageIndex = 0;
let reviewImages = [];
let currentReviewId = null;

// View review images
function viewReviewImages(reviewId, imageCount) {
    console.log('🖼️ Opening images modal for review:', reviewId, 'Images:', imageCount);

    currentReviewId = reviewId;
    currentImageIndex = 0;

    // Generate demo images (replace with actual images from database)
    reviewImages = [];
    for (let i = 1; i <= imageCount; i++) {
        reviewImages.push({
            url: `https://picsum.photos/600/400?random=${reviewId}${i}`,
            thumbnail: `https://picsum.photos/60/60?random=${reviewId}${i}`
        });
    }

    // Update modal title
    document.getElementById('modalReviewId').textContent = reviewId;
    document.getElementById('totalImages').textContent = imageCount;

    // Generate thumbnails and page numbers
    generateThumbnails();
    generatePageNumbers();

    // Show first image
    showImage(0);

    // Show modal
    const modal = new bootstrap.Modal(document.getElementById('reviewImagesModal'));
    modal.show();
}

// Show specific image
function showImage(index) {
    if (index < 0 || index >= reviewImages.length) return;

    currentImageIndex = index;

    // Update main image
    document.getElementById('currentImage').src = reviewImages[index].url;
    document.getElementById('currentImageIndex').textContent = index + 1;

    // Update active thumbnail
    document.querySelectorAll('.thumbnail-nav img').forEach((img, i) => {
        img.classList.toggle('active', i === index);
    });

    // Update active page number
    document.querySelectorAll('.page-numbers .btn').forEach((btn, i) => {
        btn.classList.toggle('active', i === index);
    });
}

// Navigate to previous image
function previousImage() {
    const newIndex = currentImageIndex > 0 ? currentImageIndex - 1 : reviewImages.length - 1;
    showImage(newIndex);
}

// Navigate to next image
function nextImage() {
    const newIndex = currentImageIndex < reviewImages.length - 1 ? currentImageIndex + 1 : 0;
    showImage(newIndex);
}

// Generate thumbnail navigation
function generateThumbnails() {
    const container = document.getElementById('thumbnailContainer');
    container.innerHTML = reviewImages.map((img, index) => `
        <img src="${img.thumbnail}"
             alt="Thumbnail ${index + 1}"
             onclick="showImage(${index})"
             class="${index === 0 ? 'active' : ''}">
    `).join('');
}

// Generate page numbers
function generatePageNumbers() {
    const container = document.getElementById('pageNumbers');
    container.innerHTML = reviewImages.map((_, index) => `
        <button type="button"
                class="btn ${index === 0 ? 'active' : ''}"
                onclick="showImage(${index})">
            ${index + 1}
        </button>
    `).join('');
}

// Download current image
function downloadImage() {
    if (currentImageIndex >= 0 && currentImageIndex < reviewImages.length) {
        const link = document.createElement('a');
        link.href = reviewImages[currentImageIndex].url;
        link.download = `review-${currentReviewId}-image-${currentImageIndex + 1}.jpg`;
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
        console.log('📥 Downloading image:', currentImageIndex + 1);
    }
}

// Make functions globally available
window.viewReviewImages = viewReviewImages;
window.showImage = showImage;
window.previousImage = previousImage;
window.nextImage = nextImage;
window.downloadImage = downloadImage;

// Add keyboard navigation for image modal
document.addEventListener('keydown', function(e) {
    const modal = document.getElementById('reviewImagesModal');
    if (modal && modal.classList.contains('show')) {
        if (e.key === 'ArrowLeft') {
            e.preventDefault();
            previousImage();
        } else if (e.key === 'ArrowRight') {
            e.preventDefault();
            nextImage();
        } else if (e.key === 'Escape') {
            bootstrap.Modal.getInstance(modal).hide();
        }
    }
});

console.log('🌿 Staff Panel JavaScript Loaded Successfully!');
