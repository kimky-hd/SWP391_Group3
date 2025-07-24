<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm nhà cung cấp mới</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* Main content container - tránh chồng lấn với sidebar */
        .main-content {
            margin-left: 250px;
            padding: 20px;
            min-height: 100vh;
            transition: margin-left 0.3s ease;
        }
        
        /* Responsive cho sidebar collapse */
        @media (max-width: 768px) {
            .main-content {
                margin-left: 0;
                padding: 15px;
            }
        }
        
        .sidebar-collapsed .main-content {
            margin-left: 80px;
        }
        
        @media (max-width: 768px) {
            .sidebar-collapsed .main-content {
                margin-left: 0;
            }
        }
        
        .form-container {
            background: white;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
            padding: 30px;
            max-width: 800px;
            margin: 0 auto;
        }
        
        .form-header {
            border-bottom: 2px solid #e9ecef;
            padding-bottom: 20px;
            margin-bottom: 30px;
        }
        
        .form-header h2 {
            color: #495057;
            font-weight: 600;
        }
        
        .form-label {
            font-weight: 500;
            color: #495057;
        }
        
        .required {
            color: #dc3545;
        }
        
        .form-control:focus {
            border-color: #80bdff;
            box-shadow: 0 0 0 0.2rem rgba(0,123,255,.25);
        }
        
        .btn-group-custom {
            gap: 10px;
        }
        
        .error-feedback {
            color: #dc3545;
            font-size: 0.875em;
            margin-top: 0.25rem;
            display: block;
        }
        
        .is-invalid {
            border-color: #dc3545;
        }
        
        .breadcrumb {
            background-color: transparent;
            padding: 0;
            margin-bottom: 20px;
        }
        
        .breadcrumb-item a {
            color: #6c757d;
            text-decoration: none;
        }
        
        .breadcrumb-item a:hover {
            color: #495057;
        }
        
        .breadcrumb-item.active {
            color: #495057;
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
                        <a href="${pageContext.request.contextPath}/manager/dashboard">
                            <i class="fas fa-home"></i> Dashboard
                        </a>
                    </li>
                    <li class="breadcrumb-item">
                        <a href="${pageContext.request.contextPath}/manager/supplier">
                            <i class="fas fa-truck"></i> Quản lý nhà cung cấp
                        </a>
                    </li>
                    <li class="breadcrumb-item active" aria-current="page">
                        <i class="fas fa-plus"></i> Thêm mới
                    </li>
                </ol>
            </nav>

            <div class="form-container">
                <div class="form-header">
                    <h2><i class="fas fa-plus-circle text-success me-2"></i>Thêm nhà cung cấp mới</h2>
                    <p class="text-muted mb-0">Vui lòng điền đầy đủ thông tin để thêm nhà cung cấp mới vào hệ thống</p>
                </div>

                <!-- Thông báo lỗi -->
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        ${errorMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <!-- Thông báo thành công -->
                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle me-2"></i>
                        ${successMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/manager/supplier" method="post" novalidate>
                    <input type="hidden" name="action" value="add">
                    
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="supplierName" class="form-label">
                                Tên nhà cung cấp <span class="required">*</span>
                            </label>
                            <input type="text" 
                                   class="form-control ${fieldErrors['supplierName'] != null ? 'is-invalid' : ''}" 
                                   id="supplierName" 
                                   name="supplierName" 
                                   value="${formData['supplierName'] != null ? formData['supplierName'] : param.supplierName}"
                                   required
                                   placeholder="Nhập tên nhà cung cấp">
                            <c:if test="${fieldErrors['supplierName'] != null}">
                                <div class="error-feedback">
                                    <i class="fas fa-exclamation-circle me-1"></i>
                                    ${fieldErrors['supplierName']}
                                </div>
                            </c:if>
                        </div>
                        
                        <div class="col-md-6 mb-3">
                            <label for="email" class="form-label">
                                Email <span class="required">*</span>
                            </label>
                            <input type="email" 
                                   class="form-control ${fieldErrors['email'] != null ? 'is-invalid' : ''}" 
                                   id="email" 
                                   name="email" 
                                   value="${formData['email'] != null ? formData['email'] : param.email}"
                                   required
                                   placeholder="example@email.com">
                            <c:if test="${fieldErrors['email'] != null}">
                                <div class="error-feedback">
                                    <i class="fas fa-exclamation-circle me-1"></i>
                                    ${fieldErrors['email']}
                                </div>
                            </c:if>
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="phone" class="form-label">Số điện thoại</label>
                            <input type="tel" 
                                   class="form-control ${fieldErrors['phone'] != null ? 'is-invalid' : ''}" 
                                   id="phone" 
                                   name="phone" 
                                   value="${formData['phone'] != null ? formData['phone'] : param.phone}"
                                   placeholder="0123456789">
                            <c:if test="${fieldErrors['phone'] != null}">
                                <div class="error-feedback">
                                    <i class="fas fa-exclamation-circle me-1"></i>
                                    ${fieldErrors['phone']}
                                </div>
                            </c:if>
                        </div>
                        
                        <div class="col-md-6 mb-3">
                            <label for="address" class="form-label">Địa chỉ</label>
                            <textarea class="form-control ${fieldErrors['address'] != null ? 'is-invalid' : ''}" 
                                      id="address" 
                                      name="address" 
                                      rows="3"
                                      placeholder="Nhập địa chỉ nhà cung cấp">${formData['address'] != null ? formData['address'] : param.address}</textarea>
                            <c:if test="${fieldErrors['address'] != null}">
                                <div class="error-feedback">
                                    <i class="fas fa-exclamation-circle me-1"></i>
                                    ${fieldErrors['address']}
                                </div>
                            </c:if>
                        </div>
                    </div>
                    
                    <hr class="my-4">
                    
                    <div class="d-flex justify-content-end btn-group-custom">
                        <a href="${pageContext.request.contextPath}/manager/supplier" class="btn btn-secondary">
                            <i class="fas fa-arrow-left me-2"></i>Quay lại
                        </a>
                        <button type="reset" class="btn btn-outline-secondary">
                            <i class="fas fa-undo me-2"></i>Đặt lại
                        </button>
                        <button type="submit" class="btn btn-success">
                            <i class="fas fa-plus me-2"></i>Thêm nhà cung cấp
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Auto dismiss alerts after 5 seconds
        setTimeout(function() {
            var alerts = document.querySelectorAll('.alert');
            alerts.forEach(function(alert) {
                var bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            });
        }, 5000);
        
        // Form validation
        (function() {
            'use strict';
            window.addEventListener('load', function() {
                var forms = document.getElementsByTagName('form');
                var validation = Array.prototype.filter.call(forms, function(form) {
                    form.addEventListener('submit', function(event) {
                        if (form.checkValidity() === false) {
                            event.preventDefault();
                            event.stopPropagation();
                        }
                        form.classList.add('was-validated');
                    }, false);
                });
            }, false);
        })();
        
        // Email validation
        document.getElementById('email').addEventListener('blur', function() {
            const email = this.value.trim();
            const emailRegex = /^[A-Za-z0-9+_.-]+@(.+)$/;
            if (email.length > 0 && !emailRegex.test(email)) {
                this.setCustomValidity('Email không đúng định dạng @gmail.com');
            } else {
                this.setCustomValidity('');
            }
        });
        
        // Phone validation
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
    </script>
</body>
</html>
