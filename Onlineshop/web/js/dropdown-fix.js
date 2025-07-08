// Test Bootstrap Dropdown Functionality
document.addEventListener('DOMContentLoaded', function() {
    console.log('Testing dropdown functionality...');
    
    // Test if Bootstrap is loaded
    if (typeof bootstrap !== 'undefined') {
        console.log('Bootstrap is loaded');
        
        // Initialize all dropdowns manually if needed
        var dropdownElementList = [].slice.call(document.querySelectorAll('.dropdown-toggle'));
        var dropdownList = dropdownElementList.map(function (dropdownToggleEl) {
            return new bootstrap.Dropdown(dropdownToggleEl);
        });
        
        console.log('Dropdowns initialized:', dropdownList.length);
    } else {
        console.error('Bootstrap is not loaded!');
    }
    
    // Add click event listener for troubleshooting
    const userDropdown = document.getElementById('userDropdown');
    if (userDropdown) {
        userDropdown.addEventListener('click', function(e) {
            console.log('User dropdown clicked');
            e.preventDefault();
            
            const dropdownMenu = this.nextElementSibling;
            if (dropdownMenu) {
                dropdownMenu.classList.toggle('show');
                console.log('Dropdown menu toggled');
            }
        });
    }
});
