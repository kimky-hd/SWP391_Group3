<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm Shipper mới</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/css/manager.css" rel="stylesheet">
    <style>
        .field-error {
            border-color: #dc3545 !important;
            box-shadow: 0 0 0 0.2rem rgba(220, 53, 69, 0.25) !important;
        }
        .error-message {
            color: #dc3545;
            font-size: 0.875rem;
            margin-top: 0.25rem;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar và Topbar -->
            <jsp:include page="../manager_topbarsidebar.jsp" />
            
            <!-- Main Content -->
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">Thêm Shipper mới</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <a href="${pageContext.request.contextPath}/manager/shipper" class="btn btn-sm btn-outline-secondary">
                            <i class="fas fa-arrow-left"></i> Quay lại
                        </a>
                    </div>
                </div>
                
                <!-- Thông báo lỗi chung -->
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger" role="alert">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        ${errorMessage}
                    </div>
                </c:if>
                
                <!-- Thông báo thành công -->
                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success" role="alert">
                        <i class="fas fa-check-circle me-2"></i>
                        ${successMessage}
                    </div>
                </c:if>
                
                <!-- Form thêm shipper -->
                <div class="row">
                    <div class="col-md-8">
                        <div class="card">
                            <div class="card-header">
                                <h5 class="card-title mb-0">
                                    <i class="fas fa-user-plus me-2"></i>
                                    Thông tin Shipper mới
                                </h5>
                            </div>
                            <div class="card-body">
                                <form action="${pageContext.request.contextPath}/manager/shipper/add" method="post" class="needs-validation" novalidate>
                                    
                                    <!-- Username và Password -->
                                    <div class="row mb-3">
                                        <div class="col-md-6">
                                            <label for="username" class="form-label">
                                                Tên đăng nhập <span class="text-danger">*</span>
                                            </label>
                                            <input type="text" 
                                                   class="form-control ${fieldErrors['username'] != null ? 'is-invalid field-error' : ''}" 
                                                   id="username" 
                                                   name="username" 
                                                   value="${formData['username'] != null ? formData['username'] : param.username}" 
                                                   required
                                                   placeholder="Nhập tên đăng nhập">
                                            
                                            <!-- Hiển thị lỗi validation từ server -->
                                            <c:if test="${fieldErrors['username'] != null}">
                                                <div class="invalid-feedback d-block error-message">
                                                    <i class="fas fa-exclamation-circle me-1"></i>
                                                    ${fieldErrors['username']}
                                                </div>
                                            </c:if>
                                            
                                            <!-- Lỗi validation client-side -->
                                            <div class="invalid-feedback">
                                                Vui lòng nhập tên đăng nhập.
                                            </div>
                                        </div>
                                        
                                        <div class="col-md-6">
                                            <label for="password" class="form-label">
                                                Mật khẩu <span class="text-danger">*</span>
                                            </label>
                                            <div class="input-group">
                                                <input type="password" 
                                                       class="form-control ${fieldErrors['password'] != null ? 'is-invalid field-error' : ''}" 
                                                       id="password" 
                                                       name="password" 
                                                       required
                                                       minlength="6"
                                                       placeholder="Nhập mật khẩu">
                                                <button class="btn btn-outline-secondary" type="button" id="togglePassword">
                                                    <i class="fas fa-eye"></i>
                                                </button>
                                            </div>
                                            
                                            <c:if test="${fieldErrors['password'] != null}">
                                                <div class="invalid-feedback d-block error-message">
                                                    <i class="fas fa-exclamation-circle me-1"></i>
                                                    ${fieldErrors['password']}
                                                </div>
                                            </c:if>
                                            
                                            <div class="invalid-feedback">
                                                Mật khẩu phải có ít nhất 6 ký tự.
                                            </div>
                                            <small class="text-muted">Mật khẩu nên có ít nhất 6 ký tự</small>
                                        </div>
                                    </div>
                                    
                                    <!-- Email và Phone -->
                                    <div class="row mb-3">
                                        <div class="col-md-6">
                                            <label for="email" class="form-label">
                                                Email <span class="text-danger">*</span>
                                            </label>
                                            <input type="email" 
                                                   class="form-control ${fieldErrors['email'] != null ? 'is-invalid field-error' : ''}" 
                                                   id="email" 
                                                   name="email" 
                                                   value="${formData['email'] != null ? formData['email'] : param.email}" 
                                                   required
                                                   placeholder="example@email.com">
                                            
                                            <c:if test="${fieldErrors['email'] != null}">
                                                <div class="invalid-feedback d-block error-message">
                                                    <i class="fas fa-exclamation-circle me-1"></i>
                                                    ${fieldErrors['email']}
                                                </div>
                                            </c:if>
                                            
                                            <div class="invalid-feedback">
                                                Vui lòng nhập email hợp lệ.
                                            </div>
                                        </div>
                                        
                                        <div class="col-md-6">
                                            <label for="phone" class="form-label">
                                                Số điện thoại <span class="text-danger">*</span>
                                            </label>
                                            <input type="tel" 
                                                   class="form-control ${fieldErrors['phone'] != null ? 'is-invalid field-error' : ''}" 
                                                   id="phone" 
                                                   name="phone" 
                                                   value="${formData['phone'] != null ? formData['phone'] : param.phone}" 
                                                   required
                                                   pattern="[0-9]{10,11}"
                                                   placeholder="0123456789">
                                            
                                            <c:if test="${fieldErrors['phone'] != null}">
                                                <div class="invalid-feedback d-block error-message">
                                                    <i class="fas fa-exclamation-circle me-1"></i>
                                                    ${fieldErrors['phone']}
                                                </div>
                                            </c:if>
                                            
                                            <div class="invalid-feedback">
                                                Vui lòng nhập số điện thoại hợp lệ (10-11 số).
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <!-- Start Date và End Date -->
                                    <div class="row mb-3">
                                        <div class="col-md-6">
                                            <label for="startDate" class="form-label">
                                                Ngày bắt đầu <span class="text-danger">*</span>
                                            </label>
                                            <input type="date" 
                                                   class="form-control ${fieldErrors['startDate'] != null ? 'is-invalid field-error' : ''}" 
                                                   id="startDate" 
                                                   name="startDate" 
                                                   value="${formData['startDate'] != null ? formData['startDate'] : param.startDate}" 
                                                   required>
                                            
                                            <c:if test="${fieldErrors['startDate'] != null}">
                                                <div class="invalid-feedback d-block error-message">
                                                    <i class="fas fa-exclamation-circle me-1"></i>
                                                    ${fieldErrors['startDate']}
                                                </div>
                                            </c:if>
                                            
                                            <div class="invalid-feedback">
                                                Vui lòng chọn ngày bắt đầu.
                                            </div>
                                        </div>
                                        
                                        <div class="col-md-6">
                                            <label for="endDate" class="form-label">Ngày kết thúc</label>
                                            <input type="date" 
                                                   class="form-control" 
                                                   id="endDate" 
                                                   name="endDate" 
                                                   value="${formData['endDate'] != null ? formData['endDate'] : param.endDate}">
                                            <small class="text-muted">Để trống nếu shipper vẫn đang làm việc</small>
                                        </div>
                                    </div>
                                    
                                    
                                    
                                    <!-- Submit buttons -->
                                    <!-- Submit buttons -->
<div class="d-grid gap-2 d-md-flex justify-content-md-end">
    <a href="${pageContext.request.contextPath}/manager/shipper" class="btn btn-secondary me-md-2">
        <i class="fas fa-arrow-left me-2"></i>
        Quay lại
    </a>
    <button type="submit" class="btn btn-primary">
        <i class="fas fa-plus me-2"></i>
        Thêm shipper
    </button>
</div>

                                </form>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Sidebar hướng dẫn -->
                    <div class="col-md-4">
                        <div class="card">
                            <div class="card-header">
                                <h5 class="card-title mb-0">
                                    <i class="fas fa-info-circle me-2"></i>
                                    Hướng dẫn
                                </h5>
                            </div>
                            <div class="card-body">
                                <div class="alert alert-info" role="alert">
                                    <h6 class="alert-heading">Lưu ý quan trọng:</h6>
                                    <ul class="list-unstyled mb-0">
    <li><i class="fas fa-check text-success me-2"></i> Các trường có dấu <span class="text-danger">*</span> là bắt buộc.</li>
    <li><i class="fas fa-check text-success me-2"></i> Tên đăng nhập phải là duy nhất trong hệ thống.</li>
    <li><i class="fas fa-check text-success me-2"></i> Mật khẩu nên có ít nhất 6 ký tự để bảo mật.</li>
    <li><i class="fas fa-check text-success me-2"></i> Email và số điện thoại phải là duy nhất.</li>
    <li><i class="fas fa-check text-success me-2"></i> Số điện thoại phải có 10-11 chữ số.</li>
    <li><i class="fas fa-check text-success me-2"></i> Lương sẽ được thiết lập sau khi tạo tài khoản.</li>
</ul>

                                </div>
                                
                                <div class="card mt-3">
                                    <div class="card-header">
                                        <h6 class="card-title mb-0">Thông tin mặc định</h6>
                                    </div>
                                    <div class="card-body">
                                        <small class="text-muted">
    <ul class="list-unstyled">
        <li>• Lương cơ bản: 0 VNĐ</li>
        <li>• Thưởng mỗi đơn: 0 VNĐ</li>
        <li>• Số đơn hàng đã giao: 0</li>
        <li>• Trạng thái: Hoạt động</li>
    </ul>
</small>

                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Custom JS -->
    <script src="${pageContext.request.contextPath}/js/manager.js"></script>
    
    <script>
        // Toggle password visibility
        document.getElementById('togglePassword').addEventListener('click', function() {
            const passwordField = document.getElementById('password');
            const icon = this.querySelector('i');
            
            if (passwordField.type === 'password') {
                passwordField.type = 'text';
                icon.classList.remove('fa-eye');
                icon.classList.add('fa-eye-slash');
            } else {
                passwordField.type = 'password';
                icon.classList.remove('fa-eye-slash');
                icon.classList.add('fa-eye');
            }
        });
        
        // Set minimum date to today for start date
        document.getElementById('startDate').min = new Date().toISOString().split('T')[0];
        
        // Validate end date is after start date
        document.getElementById('startDate').addEventListener('change', function() {
            const endDateField = document.getElementById('endDate');
            endDateField.min = this.value;
            if (endDateField.value && endDateField.value < this.value) {
                endDateField.value = '';
            }
        });
        
        // Format number inputs with thousand separators
        function formatNumber(input) {
            let value = input.value.replace(/\D/g, '');
            input.value = value;
        }
        
        document.getElementById('baseSalary').addEventListener('input', function() {
            formatNumber(this);
        });
        
        document.getElementById('bonusPerOrder').addEventListener('input', function() {
            formatNumber(this);
        });
        
        // Bootstrap form validation
        (function() {
            'use strict';
            var forms = document.querySelectorAll('.needs-validation');
            Array.prototype.slice.call(forms).forEach(function(form) {
                form.addEventListener('submit', function(event) {
                    if (!form.checkValidity()) {
                        event.preventDefault();
                        event.stopPropagation();
                        
                        // Focus on first invalid field
                        const firstInvalidField = form.querySelector(':invalid');
                        if (firstInvalidField) {
                            firstInvalidField.focus();
                        }
                    }
                    form.classList.add('was-validated');
                }, false);
            });
        })();
        
        // Real-time validation for username
        document.getElementById('username').addEventListener('blur', function() {
            const username = this.value.trim();
            if (username.length > 0 && username.length < 3) {
                this.setCustomValidity('Tên đăng nhập phải có ít nhất 3 ký tự');
            } else {
                this.setCustomValidity('');
            }
        });
        
        // Real-time validation for email
        document.getElementById('email').addEventListener('blur', function() {
            const email = this.value.trim();
            const emailRegex = /^[A-Za-z0-9+_.-]+@(.+)$/;
            if (email.length > 0 && !emailRegex.test(email)) {
                this.setCustomValidity('Email không đúng định dạng @gmail.com');
            } else {
                this.setCustomValidity('');
            }
        });
        
        // Real-time validation for phone
        document.getElementById('phone').addEventListener('input', function() {
            this.value = this.value.replace(/\D/g, '');
            if (this.value.length > 11) {
                this.value = this.value.slice(0, 11);
            }
            
            if (this.value.length > 0 && (this.value.length < 10 || this.value.length > 11)) {
                this.setCustomValidity('Số điện thoại phải có 10-11 chữ số');
            } else {
                this.setCustomValidity('');
            }
        });
        
        // Auto-hide success/error messages after 5 seconds
        setTimeout(function() {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(function(alert) {
                if (alert.classList.contains('alert-success') || alert.classList.contains('alert-danger')) {
                    alert.style.transition = 'opacity 0.5s';
                    alert.style.opacity = '0';
                    setTimeout(function() {
                        alert.remove();
                    }, 500);
                }
            });
        }, 5000);
    </script>
</body>
</html>
