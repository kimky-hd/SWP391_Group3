// Staff Blog Create JavaScript

let selectedFiles = [];
let maxFiles = 10;
let maxFileSize = 10 * 1024 * 1024; // 10MB

document.addEventListener('DOMContentLoaded', function() {
    initializeBlogCreate();
});

function initializeBlogCreate() {
    // Initialize character counters
    initializeCharacterCounters();
    
    // Initialize image upload
    initializeImageUpload();
    
    // Initialize form validation
    initializeFormValidation();
    
    // Auto-hide alerts
    autoHideAlerts();
    
    // Initialize tooltips
    initializeTooltips();
}

function initializeCharacterCounters() {
    const titleInput = document.getElementById('title');
    const contentTextarea = document.getElementById('content');
    const titleCounter = document.getElementById('titleCounter');
    const contentCounter = document.getElementById('contentCounter');
    
    // Title counter
    if (titleInput && titleCounter) {
        titleInput.addEventListener('input', function() {
            const length = this.value.length;
            titleCounter.textContent = length;
            
            if (length > 180) {
                titleCounter.style.color = '#e74c3c';
            } else if (length > 150) {
                titleCounter.style.color = '#f39c12';
            } else {
                titleCounter.style.color = '#3498db';
            }
        });
        
        // Initial count
        titleCounter.textContent = titleInput.value.length;
    }
    
    // Content counter
    if (contentTextarea && contentCounter) {
        contentTextarea.addEventListener('input', function() {
            const length = this.value.length;
            contentCounter.textContent = length;
            
            if (length > 4500) {
                contentCounter.style.color = '#e74c3c';
            } else if (length > 4000) {
                contentCounter.style.color = '#f39c12';
            } else {
                contentCounter.style.color = '#3498db';
            }
        });
        
        // Initial count
        contentCounter.textContent = contentTextarea.value.length;
    }
}

function initializeImageUpload() {
    const imageInput = document.getElementById('images');
    const uploadArea = document.getElementById('imageUploadArea');
    
    if (!imageInput || !uploadArea) return;
    
    // File input change event
    imageInput.addEventListener('change', function(e) {
        handleFileSelect(e.target.files);
    });
    
    // Drag and drop events
    uploadArea.addEventListener('click', function() {
        imageInput.click();
    });
    
    uploadArea.addEventListener('dragover', function(e) {
        e.preventDefault();
        e.stopPropagation();
        this.classList.add('dragover');
    });
    
    uploadArea.addEventListener('dragleave', function(e) {
        e.preventDefault();
        e.stopPropagation();
        this.classList.remove('dragover');
    });
    
    uploadArea.addEventListener('drop', function(e) {
        e.preventDefault();
        e.stopPropagation();
        this.classList.remove('dragover');
        
        const files = e.dataTransfer.files;
        handleFileSelect(files);
    });
}

function handleFileSelect(files) {
    const newFiles = Array.from(files);
    const validFiles = [];
    
    // Validate each file
    newFiles.forEach(file => {
        if (validateFile(file)) {
            validFiles.push(file);
        }
    });
    
    // Check total file count
    if (selectedFiles.length + validFiles.length > maxFiles) {
        showErrorMessage(`Chỉ được chọn tối đa ${maxFiles} ảnh. Hiện tại đã có ${selectedFiles.length} ảnh.`);
        return;
    }
    
    // Add valid files to selected files
    validFiles.forEach(file => {
        selectedFiles.push(file);
    });
    
    // Update preview
    updateImagePreview();
    
    if (validFiles.length > 0) {
        showSuccessMessage(`Đã thêm ${validFiles.length} ảnh thành công!`);
    }
}

function validateFile(file) {
    // Check file type
    const allowedTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif', 'image/webp'];
    if (!allowedTypes.includes(file.type)) {
        showErrorMessage(`File "${file.name}" không đúng định dạng. Chỉ chấp nhận: JPG, PNG, GIF, WEBP`);
        return false;
    }
    
    // Check file size
    if (file.size > maxFileSize) {
        showErrorMessage(`File "${file.name}" quá lớn. Kích thước tối đa: 10MB`);
        return false;
    }
    
    return true;
}

function updateImagePreview() {
    const previewContainer = document.getElementById('imagePreview');
    const previewGrid = document.getElementById('previewGrid');
    
    if (!previewContainer || !previewGrid) return;
    
    if (selectedFiles.length === 0) {
        previewContainer.style.display = 'none';
        return;
    }
    
    previewContainer.style.display = 'block';
    previewGrid.innerHTML = '';
    
    selectedFiles.forEach((file, index) => {
        const previewItem = createPreviewItem(file, index);
        previewGrid.appendChild(previewItem);
    });
    
    // Update file input with selected files
    updateFileInput();
}

function createPreviewItem(file, index) {
    const div = document.createElement('div');
    div.className = 'preview-item';
    
    const img = document.createElement('img');
    img.src = URL.createObjectURL(file);
    img.alt = file.name;
    
    const removeBtn = document.createElement('button');
    removeBtn.type = 'button';
    removeBtn.className = 'remove-btn';
    removeBtn.innerHTML = '<i class="fas fa-times"></i>';
    removeBtn.onclick = () => removeImage(index);
    
    div.appendChild(img);
    div.appendChild(removeBtn);
    
    // Add main badge for first image
    if (index === 0) {
        const mainBadge = document.createElement('span');
        mainBadge.className = 'main-badge';
        mainBadge.textContent = 'Chính';
        div.appendChild(mainBadge);
    }
    
    return div;
}

function removeImage(index) {
    selectedFiles.splice(index, 1);
    updateImagePreview();
    
    if (selectedFiles.length === 0) {
        showInfoMessage('Đã xóa tất cả ảnh');
    }
}

function clearImages() {
    selectedFiles = [];
    updateImagePreview();
    showInfoMessage('Đã xóa tất cả ảnh');
}

function updateFileInput() {
    const imageInput = document.getElementById('images');
    if (!imageInput) return;
    
    // Create a new DataTransfer object to simulate file selection
    const dt = new DataTransfer();
    selectedFiles.forEach(file => {
        dt.items.add(file);
    });
    
    imageInput.files = dt.files;
}

function initializeFormValidation() {
    const form = document.getElementById('blogCreateForm');
    if (!form) return;
    
    form.addEventListener('submit', function(e) {
        if (!validateForm()) {
            e.preventDefault();
            return false;
        }
        
        // Show loading state
        showSubmitLoading();
    });
    
    // Real-time validation
    const titleInput = document.getElementById('title');
    const contentTextarea = document.getElementById('content');
    
    if (titleInput) {
        titleInput.addEventListener('blur', validateTitle);
        titleInput.addEventListener('input', clearValidation);
    }
    
    if (contentTextarea) {
        contentTextarea.addEventListener('blur', validateContent);
        contentTextarea.addEventListener('input', clearValidation);
    }
}

function validateForm() {
    let isValid = true;
    
    // Validate title
    if (!validateTitle()) {
        isValid = false;
    }
    
    // Validate content
    if (!validateContent()) {
        isValid = false;
    }
    
    return isValid;
}

function validateTitle() {
    const titleInput = document.getElementById('title');
    const title = titleInput.value.trim();
    
    if (title.length === 0) {
        showFieldError(titleInput, 'Tiêu đề không được để trống');
        return false;
    }
    
    if (title.length < 10) {
        showFieldError(titleInput, 'Tiêu đề phải có ít nhất 10 ký tự');
        return false;
    }
    
    if (title.length > 200) {
        showFieldError(titleInput, 'Tiêu đề không được vượt quá 200 ký tự');
        return false;
    }
    
    showFieldSuccess(titleInput, 'Tiêu đề hợp lệ');
    return true;
}

function validateContent() {
    const contentTextarea = document.getElementById('content');
    const content = contentTextarea.value.trim();
    
    if (content.length === 0) {
        showFieldError(contentTextarea, 'Nội dung không được để trống');
        return false;
    }
    
    if (content.length < 50) {
        showFieldError(contentTextarea, 'Nội dung phải có ít nhất 50 ký tự');
        return false;
    }
    
    if (content.length > 5000) {
        showFieldError(contentTextarea, 'Nội dung không được vượt quá 5000 ký tự');
        return false;
    }
    
    showFieldSuccess(contentTextarea, 'Nội dung hợp lệ');
    return true;
}

function showFieldError(field, message) {
    field.classList.remove('is-valid');
    field.classList.add('is-invalid');
    
    // Remove existing feedback
    const existingFeedback = field.parentNode.querySelector('.invalid-feedback');
    if (existingFeedback) {
        existingFeedback.remove();
    }
    
    // Add error feedback
    const feedback = document.createElement('div');
    feedback.className = 'invalid-feedback';
    feedback.textContent = message;
    field.parentNode.appendChild(feedback);
}

function showFieldSuccess(field, message) {
    field.classList.remove('is-invalid');
    field.classList.add('is-valid');
    
    // Remove existing feedback
    const existingFeedback = field.parentNode.querySelector('.valid-feedback');
    if (existingFeedback) {
        existingFeedback.remove();
    }
    
    // Add success feedback
    const feedback = document.createElement('div');
    feedback.className = 'valid-feedback';
    feedback.textContent = message;
    field.parentNode.appendChild(feedback);
}

function clearValidation(e) {
    const field = e.target;
    field.classList.remove('is-invalid', 'is-valid');
    
    // Remove feedback
    const feedback = field.parentNode.querySelector('.invalid-feedback, .valid-feedback');
    if (feedback) {
        feedback.remove();
    }
}

function previewBlog() {
    const title = document.getElementById('title').value.trim();
    const content = document.getElementById('content').value.trim();
    
    if (!title || !content) {
        showErrorMessage('Vui lòng nhập đầy đủ tiêu đề và nội dung trước khi xem trước');
        return;
    }
    
    // Create preview content
    const previewHtml = `
        <div class="preview-blog">
            <div class="preview-header">
                <h4 class="preview-title">${escapeHtml(title)}</h4>
                <div class="preview-meta">
                    <i class="fas fa-clock"></i> ${new Date().toLocaleDateString('vi-VN')}
                    <span class="badge bg-warning ms-2">Pending</span>
                </div>
            </div>
            <div class="preview-body">
                <div class="preview-content">
                    ${escapeHtml(content).replace(/\n/g, '<br>')}
                </div>
                ${selectedFiles.length > 0 ? createPreviewImages() : ''}
            </div>
        </div>
    `;
    
    document.getElementById('previewContent').innerHTML = previewHtml;
    
    // Show modal
    const previewModal = new bootstrap.Modal(document.getElementById('previewModal'));
    previewModal.show();
}

function createPreviewImages() {
    let imagesHtml = '<div class="preview-images">';
    
    selectedFiles.forEach((file, index) => {
        const imageUrl = URL.createObjectURL(file);
        imagesHtml += `
            <div class="preview-image-item">
                <img src="${imageUrl}" alt="Preview ${index + 1}">
                ${index === 0 ? '<div class="main-badge">Ảnh chính</div>' : ''}
            </div>
        `;
    });
    
    imagesHtml += '</div>';
    return imagesHtml;
}

function submitForm() {
    document.getElementById('blogCreateForm').submit();
}

function showSubmitLoading() {
    const submitBtn = document.getElementById('submitBtn');
    if (submitBtn) {
        submitBtn.classList.add('loading');
        submitBtn.disabled = true;
        submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang lưu...';
    }
}

// Utility functions
function escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
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
