<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm khách hàng mới</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8f9fa;
        }

        .main-content {
            margin-left: 250px;
            margin-top: 60px;
            padding: 30px;
            min-height: calc(100vh - 60px);
            background-color: #f8f9fa;
        }

        @media (max-width: 768px) {
            .main-content {
                margin-left: 0;
                padding: 15px;
            }
        }

        .form-container {
            background: white;
            border-radius: 15px;
            box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15);
            padding: 2rem;
            max-width: 800px;
            margin: 0 auto;
        }

        .form-header {
            border-bottom: 2px solid #e3e6f0;
            padding-bottom: 1.5rem;
            margin-bottom: 2rem;
        }

        .form-header h2 {
            color: #5a5c69;
            font-weight: 600;
            margin-bottom: 0.5rem;
        }

        .form-label {
            font-weight: 600;
            color: #5a5c69;
            margin-bottom: 0.5rem;
        }

        .required {
            color: #e74a3b;
        }

        .form-control {
            border-radius: 10px;
            border: 1px solid #d1d3e2;
            padding: 0.75rem 1rem;
            transition: all 0.3s ease;
        }

        .form-control:focus {
            border-color: #4e73df;
            box-shadow: 0 0 0 0.2rem rgba(78, 115, 223, 0.25);
        }

        .btn {
            border-radius: 8px;
            font-weight: 500;
            padding: 0.75rem 1.5rem;
            transition: all 0.3s ease;
        }

        .btn-primary {
            background: linear-gradient(45deg, #4e73df, #224abe);
            border: none;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(78, 115, 223, 0.4);
        }

        .btn-secondary {
            background: linear-gradient(45deg, #858796, #6c757d);
            border: none;
        }

        .btn-outline-secondary {
            border-color: #d1d3e2;
            color: #5a5c69;
        }

        .btn-outline-secondary:hover {
            background-color: #5a5c69;
            border-color: #5a5c69;
        }

        .alert {
            border: none;
            border-radius: 10px;
            font-weight: 500;
        }

        .alert-success {
            background: linear-gradient(45deg, #1cc88a, #17a673);
            color: white;
        }

        .alert-danger {
            background: linear-gradient(45deg, #e74a3b, #c0392b);
            color: white;
        }

        .breadcrumb {
            background-color: transparent;
            padding: 0;
            margin-bottom: 1.5rem;
        }

        .breadcrumb-item a {
            color: #6c757d;
            text-decoration: none;
        }

        .breadcrumb-item a:hover {
            color: #5a5c69;
        }

        .breadcrumb-item.active {
            color: #5a5c69;
        }

        .btn-group-custom {
            gap: 10px;
        }

        .is-invalid {
            border-color: #e74a3b;
        }

        .invalid-feedback {
            display: block;
            color: #e74a3b;
            font-size: 0.875em;
            margin-top: 0.25rem;
        }
    </style>
</head>
<body>
    <jsp:include page="../manager_topbarsidebar.jsp" />

    <div class="main-content">
        <div class="container-fluid">
            <!-- Breadcrumb -->
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item">
                        <a href="${pageContext.request.contextPath}/staff/dashboard">
                            <i class="fas fa-home"></i> Dashboard
                        </a>
                    </li>
                    <li class="breadcrumb-item">
                        <a href="${pageContext.request.contextPath}/staff/customers">
                            <i class="fas fa-users"></i> Quản lý khách hàng
                        </a>
                    </li>
                    <li class="breadcrumb-item active" aria-current="page">
                        <i class="fas fa-plus"></i> Thêm mới
                    </li>
                </ol>
            </nav>

            <div class="form-container">
                <div class="form-header">
                    <h2><i class="fas fa-user-plus text-primary me-2"></i>Thêm khách hàng mới</h2>
                    <p class="text-muted mb-0">Vui lòng điền đầy đủ thông tin để thêm khách hàng mới vào hệ thống</p>
                </div>

                <!-- Thông báo lỗi -->
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        ${errorMessage}
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <!-- Thông báo thành công -->
                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle me-2"></i>
                        ${successMessage}
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/staff/customers" method="post" novalidate id="addCustomerForm">
                    <input type="hidden" name="action" value="add">
                    <input type="hidden" name="role" value="0">

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="username" class="form-label">
                                <i class="fas fa-user me-1"></i>Tên đăng nhập <span class="required">*</span>
                            </label>
                            <input type="text" 
                                   class="form-control ${fieldErrors['username'] != null ? 'is-invalid' : ''}" 
                                   id="username" 
                                   name="username" 
                                   value="${formData['username'] != null ? formData['username'] : ''}"
                                   required
                                   placeholder="Nhập tên đăng nhập">
                            <c:if test="${fieldErrors['username'] != null}">
                                <div class="invalid-feedback">
                                    <i class="fas fa-exclamation-circle me-1"></i>
                                    ${fieldErrors['username']}
                                </div>
                            </c:if>
                        </div>

                        <div class="col-md-6 mb-3">
                            <label for="password" class="form-label">
                                <i class="fas fa-lock me-1"></i>Mật khẩu <span class="required">*</span>
                            </label>
                            <input type="password" 
                                   class="form-control ${fieldErrors['password'] != null ? 'is-invalid' : ''}" 
                                   id="password" 
                                   name="password" 
                                   required
                                   placeholder="Nhập mật khẩu">
                            <c:if test="${fieldErrors['password'] != null}">
                                <div class="invalid-feedback">
                                    <i class="fas fa-exclamation-circle me-1"></i>
                                    ${fieldErrors['password']}
                                </div>
                            </c:if>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="email" class="form-label">
                                <i class="fas fa-envelope me-1"></i>Email <span class="required">*</span>
                            </label>
                            <input type="email" 
                                   class="form-control ${fieldErrors['email'] != null ? 'is-invalid' : ''}" 
                                   id="email" 
                                   name="email" 
                                   value="${formData['email'] != null ? formData['email'] : ''}"
                                   required
                                   placeholder="example@email.com">
                            <c:if test="${fieldErrors['email'] != null}">
                                <div class="invalid-feedback">
                                    <i class="fas fa-exclamation-circle me-1"></i>
                                    ${fieldErrors['email']}
                                </div>
                            </c:if>
                        </div>

                        <div class="col-md-6 mb-3">
                            <label for="phone" class="form-label">
                                <i class="fas fa-phone me-1"></i>Số điện thoại
                            </label>
                            <input type="text" 
                                   class="form-control ${fieldErrors['phone'] != null ? 'is-invalid' : ''}" 
                                   id="phone" 
                                   name="phone" 
                                   value="${formData['phone'] != null ? formData['phone'] : ''}"
                                   placeholder="0123456789">
                            <c:if test="${fieldErrors['phone'] != null}">
                                <div class="invalid-feedback">
                                    <i class="fas fa-exclamation-circle me-1"></i>
                                    ${fieldErrors['phone']}
                                </div>
                            </c:if>
                        </div>
                    </div>

                    <hr class="my-4">

                    <div class="d-flex justify-content-end btn-group-custom">
                        <a href="${pageContext.request.contextPath}/staff/customers" class="btn btn-secondary">
                            <i class="fas fa-arrow-left me-2"></i>Quay lại
                        </a>
                        
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save me-2"></i>Thêm khách hàng
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Auto dismiss alerts after 5 seconds
        setTimeout(function() {
            var alerts = document.querySelectorAll('.alert');
            alerts.forEach(function(alert) {
                var bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            });
        }, 5000);

        // Clear form sau khi thành công
        <c:if test="${not empty successMessage}">
            setTimeout(function() {
                document.getElementById('addCustomerForm').reset();
                // Clear validation classes
                document.querySelectorAll('.is-invalid').forEach(el => el.classList.remove('is-invalid'));
                document.querySelectorAll('.invalid-feedback').forEach(el => el.remove());
            }, 2000);
        </c:if>

        // Form validation
        document.getElementById('addCustomerForm').addEventListener('submit', function(e) {
            const username = document.getElementById('username').value.trim();
            const password = document.getElementById('password').value.trim();
            const email = document.getElementById('email').value.trim();
            const phone = document.getElementById('phone').value.trim();

            let hasError = false;

            // Clear previous client-side errors
            document.querySelectorAll('.is-invalid').forEach(el => {
                if (!el.closest('.form-group')?.querySelector('.invalid-feedback')?.textContent?.includes('đã tồn tại')) {
                    el.classList.remove('is-invalid');
                }
            });
            document.querySelectorAll('.invalid-feedback').forEach(el => {
                if (!el.textContent.includes('đã tồn tại')) {
                    el.remove();
                }
            });

            // Validate username
            if (username.length < 3) {
                showFieldError('username', 'Tên đăng nhập phải có ít nhất 3 ký tự');
                hasError = true;
            }

            // Validate password
            if (password.length < 6) {
                showFieldError('password', 'Mật khẩu phải có ít nhất 6 ký tự');
                hasError = true;
            }

            // Validate email
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(email)) {
                showFieldError('email', 'Email không đúng định dạng');
                hasError = true;
            }

            // Validate phone (if provided)
            if (phone && !/^[0-9]{10,11}$/.test(phone)) {
                showFieldError('phone', 'Số điện thoại phải có 10-11 chữ số');
                hasError = true;
            }

            if (hasError) {
                e.preventDefault();
                // Scroll to first error
                const firstError = document.querySelector('.is-invalid');
                if (firstError) {
                    firstError.scrollIntoView({ behavior: 'smooth', block: 'center' });
                    firstError.focus();
                }
            }
        });

        function showFieldError(fieldId, message) {
            const field = document.getElementById(fieldId);
            field.classList.add('is-invalid');
            
            // Remove existing error message for this field
            const existingError = field.parentNode.querySelector('.invalid-feedback');
            if (existingError) {
                existingError.remove();
            }
            
            const errorDiv = document.createElement('div');
            errorDiv.className = 'invalid-feedback';
            errorDiv.innerHTML = '<i class="fas fa-exclamation-circle me-1"></i>' + message;
            
            field.parentNode.appendChild(errorDiv);
        }

        // Clear individual field errors on input
        document.querySelectorAll('input').forEach(input => {
            input.addEventListener('input', function() {
                if (this.classList.contains('is-invalid')) {
                    // Only clear client-side validation errors, not server-side errors
                    const errorDiv = this.parentNode.querySelector('.invalid-feedback');
                    if (errorDiv && !errorDiv.textContent.includes('đã tồn tại')) {
                        this.classList.remove('is-invalid');
                        errorDiv.remove();
                    }
                }
            });
        });

        // Focus on first input when page loads
        document.addEventListener('DOMContentLoaded', function() {
            const firstInput = document.getElementById('username');
            if (firstInput && !firstInput.value) {
                firstInput.focus();
            }
        });
    </script>
</body>
</html>
