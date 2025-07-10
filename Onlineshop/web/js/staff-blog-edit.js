// Staff Blog Edit Page JavaScript

document.addEventListener('DOMContentLoaded', function() {
    // Initialize components
    initImageUpload();
    initImageManagement();
    initFormValidation();
    initAutoSave();
});

// Image Upload Preview
function initImageUpload() {
    const imageInput = document.getElementById('blogImages');
    const previewContainer = document.getElementById('imagePreview');
    
    if (imageInput && previewContainer) {
        imageInput.addEventListener('change', function(e) {
            previewContainer.innerHTML = '';
            const files = Array.from(e.target.files);
            
            files.forEach((file, index) => {
                if (file.type.startsWith('image/')) {
                    const reader = new FileReader();
                    reader.onload = function(e) {
                        const previewItem = createPreviewItem(e.target.result, index);
                        previewContainer.appendChild(previewItem);
                    };
                    reader.readAsDataURL(file);
                }
            });
        });
    }
}

// Create preview item
function createPreviewItem(src, index) {
    const div = document.createElement('div');
    div.className = 'preview-item fade-in';
    div.innerHTML = `
        <img src="${src}" alt="Preview ${index + 1}">
        <button type="button" class="preview-remove" onclick="removePreview(this, ${index})">
            <i class="fas fa-times"></i>
        </button>
    `;
    return div;
}

// Remove preview item
function removePreview(button, index) {
    const previewItem = button.closest('.preview-item');
    const imageInput = document.getElementById('blogImages');
    
    // Remove from DOM
    previewItem.remove();
    
    // Update file input
    const dt = new DataTransfer();
    const files = Array.from(imageInput.files);
    files.forEach((file, i) => {
        if (i !== index) {
            dt.items.add(file);
        }
    });
    imageInput.files = dt.files;
}

// Current Image Management
function initImageManagement() {
    // Set main image buttons
    document.querySelectorAll('.set-main-btn').forEach(btn => {
        btn.addEventListener('click', function() {
            const imgID = this.dataset.imgId;
            setMainImage(imgID);
        });
    });
    
    // Delete image buttons
    document.querySelectorAll('.delete-img-btn').forEach(btn => {
        btn.addEventListener('click', function() {
            const imgID = this.dataset.imgId;
            const imageItem = this.closest('.image-item');
            showDeleteImageConfirmation(imgID, imageItem);
        });
    });
}

// Set main image
function setMainImage(imgID) {
    const blogID = document.querySelector('input[name="blogID"]').value;
    
    // Show loading state
    const btn = document.querySelector(`[data-img-id="${imgID}"].set-main-btn`);
    const originalText = btn.innerHTML;
    btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Setting...';
    btn.disabled = true;
    
    // Make AJAX request
    fetch(`${getContextPath()}/staff/blog/edit`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: `action=setMainImage&blogID=${blogID}&imgID=${imgID}`
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            // Update UI
            document.querySelectorAll('.set-main-btn').forEach(b => {
                b.style.display = 'inline-block';
                b.disabled = false;
            });
            document.querySelectorAll('.badge.bg-primary').forEach(badge => {
                if (badge.textContent === 'Main') {
                    badge.remove();
                }
            });
            
            // Hide the clicked button and show main badge
            btn.style.display = 'none';
            const controls = btn.parentElement;
            const badge = document.createElement('span');
            badge.className = 'badge bg-primary';
            badge.textContent = 'Main';
            controls.insertBefore(badge, controls.firstChild);
            
            showToast('success', 'Main image updated successfully');
        } else {
            throw new Error(data.message || 'Failed to set main image');
        }
    })
    .catch(error => {
        console.error('Error:', error);
        btn.innerHTML = originalText;
        btn.disabled = false;
        showToast('error', 'Failed to set main image: ' + error.message);
    });
}

// Delete image confirmation
function showDeleteImageConfirmation(imgID, imageItem) {
    if (confirm('Are you sure you want to delete this image?')) {
        deleteImage(imgID, imageItem);
    }
}

// Delete image
function deleteImage(imgID, imageItem) {
    const blogID = document.querySelector('input[name="blogID"]').value;
    
    // Show loading state
    imageItem.style.opacity = '0.5';
    const btn = imageItem.querySelector('.delete-img-btn');
    btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i>';
    btn.disabled = true;
    
    // Make AJAX request
    fetch(`${getContextPath()}/staff/blog/edit`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: `action=deleteImage&blogID=${blogID}&imgID=${imgID}`
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            // Remove from DOM with animation
            imageItem.style.transform = 'scale(0)';
            setTimeout(() => {
                imageItem.remove();
            }, 300);
            showToast('success', 'Image deleted successfully');
        } else {
            throw new Error(data.message || 'Failed to delete image');
        }
    })
    .catch(error => {
        console.error('Error:', error);
        imageItem.style.opacity = '1';
        btn.innerHTML = '<i class="fas fa-trash"></i> Delete';
        btn.disabled = false;
        showToast('error', 'Failed to delete image: ' + error.message);
    });
}

// Form Validation
function initFormValidation() {
    const form = document.getElementById('editBlogForm');
    const titleInput = document.getElementById('blogTitle');
    const contentInput = document.getElementById('blogContent');
    
    if (form) {
        form.addEventListener('submit', function(e) {
            if (!validateForm()) {
                e.preventDefault();
                return false;
            }
            
            // Show loading state
            const submitBtn = form.querySelector('button[type="submit"]');
            submitBtn.classList.add('loading');
            submitBtn.disabled = true;
        });
    }
    
    // Real-time validation
    if (titleInput) {
        titleInput.addEventListener('input', validateTitle);
        titleInput.addEventListener('blur', validateTitle);
    }
    
    if (contentInput) {
        contentInput.addEventListener('input', validateContent);
        contentInput.addEventListener('blur', validateContent);
    }
}

// Validate form
function validateForm() {
    let isValid = true;
    
    isValid = validateTitle() && isValid;
    isValid = validateContent() && isValid;
    
    return isValid;
}

// Validate title
function validateTitle() {
    const input = document.getElementById('blogTitle');
    const value = input.value.trim();
    
    clearFieldError(input);
    
    if (!value) {
        showFieldError(input, 'Blog title is required');
        return false;
    }
    
    if (value.length > 200) {
        showFieldError(input, 'Blog title must not exceed 200 characters');
        return false;
    }
    
    showFieldSuccess(input);
    return true;
}

// Validate content
function validateContent() {
    const input = document.getElementById('blogContent');
    const value = input.value.trim();
    
    clearFieldError(input);
    
    if (!value) {
        showFieldError(input, 'Blog content is required');
        return false;
    }
    
    if (value.length < 50) {
        showFieldError(input, 'Blog content should be at least 50 characters');
        return false;
    }
    
    showFieldSuccess(input);
    return true;
}

// Show field error
function showFieldError(field, message) {
    field.classList.add('is-invalid');
    field.classList.remove('is-valid');
    
    let feedback = field.parentElement.querySelector('.invalid-feedback');
    if (!feedback) {
        feedback = document.createElement('div');
        feedback.className = 'invalid-feedback';
        field.parentElement.appendChild(feedback);
    }
    feedback.textContent = message;
}

// Show field success
function showFieldSuccess(field) {
    field.classList.add('is-valid');
    field.classList.remove('is-invalid');
    
    const feedback = field.parentElement.querySelector('.invalid-feedback');
    if (feedback) {
        feedback.remove();
    }
}

// Clear field error
function clearFieldError(field) {
    field.classList.remove('is-invalid', 'is-valid');
    
    const feedback = field.parentElement.querySelector('.invalid-feedback');
    if (feedback) {
        feedback.remove();
    }
}

// Auto-save functionality
function initAutoSave() {
    const titleInput = document.getElementById('blogTitle');
    const contentInput = document.getElementById('blogContent');
    const tagsInput = document.getElementById('tags');
    
    let autoSaveTimeout;
    
    function triggerAutoSave() {
        clearTimeout(autoSaveTimeout);
        autoSaveTimeout = setTimeout(autoSave, 30000); // Auto-save every 30 seconds
    }
    
    if (titleInput) titleInput.addEventListener('input', triggerAutoSave);
    if (contentInput) contentInput.addEventListener('input', triggerAutoSave);
    if (tagsInput) tagsInput.addEventListener('input', triggerAutoSave);
}

// Auto-save function
function autoSave() {
    const form = document.getElementById('editBlogForm');
    const formData = new FormData(form);
    formData.set('action', 'autoSave');
    
    fetch(form.action, {
        method: 'POST',
        body: formData
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            showToast('info', 'Draft saved automatically', 2000);
        }
    })
    .catch(error => {
        console.error('Auto-save error:', error);
    });
}

// Toast notification
function showToast(type, message, duration = 5000) {
    // Remove existing toasts
    document.querySelectorAll('.toast-notification').forEach(toast => {
        toast.remove();
    });
    
    const toast = document.createElement('div');
    toast.className = `toast-notification alert alert-${type === 'error' ? 'danger' : type} alert-dismissible fade show`;
    toast.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        z-index: 9999;
        min-width: 300px;
        box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
    `;
    
    const icon = type === 'success' ? 'check-circle' : 
                 type === 'error' ? 'exclamation-circle' : 
                 type === 'info' ? 'info-circle' : 'warning';
    
    toast.innerHTML = `
        <i class="fas fa-${icon} me-2"></i>
        ${message}
        <button type="button" class="btn-close" onclick="this.parentElement.remove()"></button>
    `;
    
    document.body.appendChild(toast);
    
    // Auto-remove after duration
    setTimeout(() => {
        if (toast.parentElement) {
            toast.remove();
        }
    }, duration);
}

// Get context path
function getContextPath() {
    return window.location.pathname.substring(0, window.location.pathname.indexOf("/", 2));
}

// Character counter for textarea
document.addEventListener('DOMContentLoaded', function() {
    const contentTextarea = document.getElementById('blogContent');
    if (contentTextarea) {
        const counterDiv = document.createElement('div');
        counterDiv.className = 'form-text text-end';
        counterDiv.id = 'contentCounter';
        contentTextarea.parentElement.appendChild(counterDiv);
        
        function updateCounter() {
            const length = contentTextarea.value.length;
            counterDiv.textContent = `${length} characters`;
            
            if (length < 50) {
                counterDiv.className = 'form-text text-end text-warning';
            } else {
                counterDiv.className = 'form-text text-end text-muted';
            }
        }
        
        contentTextarea.addEventListener('input', updateCounter);
        updateCounter(); // Initial count
    }
});

// Keyboard shortcuts
document.addEventListener('keydown', function(e) {
    // Ctrl+S to save
    if (e.ctrlKey && e.key === 's') {
        e.preventDefault();
        const form = document.getElementById('editBlogForm');
        if (form) {
            form.submit();
        }
    }
    
    // Esc to cancel/go back
    if (e.key === 'Escape') {
        const modal = document.querySelector('.modal.show');
        if (modal) {
            const bootstrapModal = bootstrap.Modal.getInstance(modal);
            if (bootstrapModal) {
                bootstrapModal.hide();
            }
        } else {
            window.location.href = `${getContextPath()}/staff/blogs`;
        }
    }
});

// Prevent accidental navigation
window.addEventListener('beforeunload', function(e) {
    const form = document.getElementById('editBlogForm');
    if (form && form.dataset.changed === 'true') {
        e.preventDefault();
        e.returnValue = '';
        return '';
    }
});

// Track form changes
document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('editBlogForm');
    if (form) {
        const inputs = form.querySelectorAll('input, textarea, select');
        inputs.forEach(input => {
            input.addEventListener('input', function() {
                form.dataset.changed = 'true';
            });
        });
        
        form.addEventListener('submit', function() {
            form.dataset.changed = 'false';
        });
    }
});
