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
                
                <!-- Thông báo lỗi -->
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger" role="alert">
                        ${errorMessage}
                    </div>
                </c:if>
                
                <!-- Form thêm shipper -->
                <div class="row">
                    <div class="col-md-8">
                        <div class="card">
                            <div class="card-body">
                                <form action="${pageContext.request.contextPath}/manager/shipper/add" method="post" class="needs-validation" novalidate>
                                    <div class="row mb-3">
                                        <div class="col-md-6">
                                            <label for="username" class="form-label">Tên đăng nhập <span class="text-danger">*</span></label>
                                            <input type="text" class="form-control" id="username" name="username" value="${param.username}" required>
                                            <div class="invalid-feedback">
                                                Vui lòng nhập tên đăng nhập.
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <label for="password" class="form-label">Mật khẩu <span class="text-danger">*</span></label>
                                            <input type="password" class="form-control" id="password" name="password" required>
                                            <div class="invalid-feedback">
                                                Vui lòng nhập mật khẩu.
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="row mb-3">
                                        <div class="col-md-6">
                                            <label for="email" class="form-label">Email <span class="text-danger">*</span></label>
                                            <input type="email" class="form-control" id="email" name="email" value="${param.email}" required>
                                            <div class="invalid-feedback">
                                                Vui lòng nhập email hợp lệ.
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <label for="phone" class="form-label">Số điện thoại <span class="text-danger">*</span></label>
                                            <input type="tel" class="form-control" id="phone" name="phone" value="${param.phone}" required>
                                            <div class="invalid-feedback">
                                                Vui lòng nhập số điện thoại.
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="row mb-3">
                                        <div class="col-md-6">
                                            <label for="startDate" class="form-label">Ngày bắt đầu <span class="text-danger">*</span></label>
                                            <input type="date" class="form-control" id="startDate" name="startDate" value="${param.startDate}" required>
                                            <div class="invalid-feedback">
                                                Vui lòng chọn ngày bắt đầu.
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <label for="endDate" class="form-label">Ngày kết thúc</label>
                                            <input type="date" class="form-control" id="endDate" name="endDate" value="${param.endDate}">
                                            <small class="text-muted">Để trống nếu shipper vẫn đang làm việc</small>
                                        </div>
                                    </div>
                                    
                                    <div class="row mb-3">
                                        <div class="col-md-6">
                                            <label for="baseSalary" class="form-label">Lương cơ bản (VNĐ) <span class="text-danger">*</span></label>
                                            <input type="number" class="form-control" id="baseSalary" name="baseSalary" value="${param.baseSalary}" min="0" step="1000" required>
                                            <div class="invalid-feedback">
                                                Vui lòng nhập lương cơ bản.
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <label for="bonusPerOrder" class="form-label">Thưởng mỗi đơn hàng (VNĐ)</label>
                                            <input type="number" class="form-control" id="bonusPerOrder" name="bonusPerOrder" value="${param.bonusPerOrder}" min="0" step="1000">
                                        </div>
                                    </div>
                                    
                                    <div class="mb-3">
                                        <div class="form-check">
                                            <input class="form-check-input" type="checkbox" id="isActive" name="isActive" value="true" checked>
                                            <label class="form-check-label" for="isActive">
                                                Hoạt động
                                            </label>
                                        </div>
                                    </div>
                                    
                                    <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                        <button type="reset" class="btn btn-secondary me-md-2">Đặt lại</button>
                                        <button type="submit" class="btn btn-primary">Thêm shipper</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-md-4">
                        <div class="card">
                            <div class="card-header">
                                <h5 class="card-title mb-0">Hướng dẫn</h5>
                            </div>
                            <div class="card-body">
                                <ul class="list-unstyled">
                                    <li><i class="fas fa-info-circle text-info me-2"></i> Các trường có dấu <span class="text-danger">*</span> là bắt buộc.</li>
                                    <li><i class="fas fa-info-circle text-info me-2"></i> Tên đăng nhập phải là duy nhất.</li>
                                    <li><i class="fas fa-info-circle text-info me-2"></i> Mật khẩu nên có ít nhất 8 ký tự.</li>
                                    <li><i class="fas fa-info-circle text-info me-2"></i> Email và số điện thoại phải là duy nhất.</li>
                                </ul>
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
        // Validation form
        (function() {
            'use strict';
            var forms = document.querySelectorAll('.needs-validation');
            Array.prototype.slice.call(forms).forEach(function(form) {
                form.addEventListener('submit', function(event) {
                    if (!form.checkValidity()) {
                        event.preventDefault();
                        event.stopPropagation();
                    }
                    form.classList.add('was-validated');
                }, false);
            });
        })();
    </script>
</body>
</html>
