<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chỉnh Sửa Nhân Viên</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8f9fa;
        }

        .topbar {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            height: 60px;
            background: white;
            border-bottom: 1px solid #e3e6f0;
            z-index: 1001;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .main-content {
            margin-left: 250px;
            margin-top: 60px;
            padding: 30px;
            min-height: calc(100vh - 60px);
            background-color: #f8f9fa;
        }

        .card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15);
            margin-bottom: 2rem;
        }

        .card-header {
            background-color: #f8f9fc;
            border-bottom: 1px solid #e3e6f0;
            border-radius: 15px 15px 0 0 !important;
            padding: 1.5rem;
            font-weight: 600;
            color: #5a5c69;
        }

        .card-body {
            padding: 2rem;
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

        .form-label {
            font-weight: 600;
            color: #5a5c69;
            margin-bottom: 0.5rem;
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
            background: linear-gradient(45deg, #858796, #60616f);
            border: none;
        }

        .btn-warning {
            background: linear-gradient(45deg, #f6c23e, #dda20a);
            border: none;
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

        .alert-info {
            background: linear-gradient(45deg, #36b9cc, #258391);
            color: white;
        }

        .required {
            color: #e74a3b;
        }

        .breadcrumb {
            background: transparent;
            padding: 0;
            margin-bottom: 1.5rem;
        }

        .breadcrumb-item a {
            color: #4e73df;
            text-decoration: none;
        }

        .breadcrumb-item.active {
            color: #5a5c69;
        }

        .info-section {
            background: #f8f9fc;
            border-radius: 10px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            border-left: 4px solid #4e73df;
        }

        .staff-info {
            display: flex;
            align-items: center;
            margin-bottom: 1rem;
        }

        .avatar-circle {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            background: linear-gradient(45deg, #4e73df, #224abe);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
            font-size: 1.5rem;
            margin-right: 1rem;
        }

        .staff-details h5 {
            margin: 0;
            color: #5a5c69;
        }

        .staff-details p {
            margin: 0;
            color: #858796;
        }

        @media (max-width: 768px) {
            .main-content {
                margin-left: 0;
                padding: 15px;
            }
            .card-body {
                padding: 1rem;
            }
            .info-section {
                padding: 1rem;
            }
        }
    </style>
</head>

<body>
    <jsp:include page="../manager_topbarsidebar.jsp" />

    <!-- Main Content -->
    <main class="main-content">
        <div class="container-fluid">
            <!-- Breadcrumb -->
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item">
                        <a href="staff">
                            <i class="fas fa-user-tie me-1"></i>Quản lý Nhân viên
                        </a>
                    </li>
                    <li class="breadcrumb-item">
                        <a href="staff?action=detail&id=${staff.staffID}">
                            Chi tiết nhân viên
                        </a>
                    </li>
                    <li class="breadcrumb-item active" aria-current="page">Chỉnh sửa</li>
                </ol>
            </nav>

            <!-- Header -->
            <div class="d-sm-flex align-items-center justify-content-between mb-4">
                <div>
                    <h1 class="h3 mb-0 text-gray-800">
                        <i class="fas fa-user-edit me-2"></i>Chỉnh Sửa Nhân Viên
                    </h1>
                    <p class="mb-0 text-muted">Cập nhật thông tin nhân viên trong hệ thống</p>
                </div>
                <div>
                    <a href="staff?action=detail&id=${staff.staffID}" class="btn btn-secondary me-2">
                        <i class="fas fa-eye me-2"></i>Xem chi tiết
                    </a>
                    <a href="staff" class="btn btn-secondary">
                        <i class="fas fa-arrow-left me-2"></i>Quay lại
                    </a>
                </div>
            </div>

            <!-- Thông báo -->
           <!-- Thông báo -->
<c:if test="${not empty message || not empty param.message}">
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        <i class="fas fa-check-circle me-2"></i>
        <c:choose>
            <c:when test="${not empty param.message}">${param.message}</c:when>
            <c:otherwise>${message}</c:otherwise>
        </c:choose>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert"></button>
    </div>
</c:if>

<c:if test="${not empty error || not empty param.error}">
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
        <i class="fas fa-exclamation-circle me-2"></i>
        <c:choose>
            <c:when test="${not empty param.error}">${param.error}</c:when>
            <c:otherwise>${error}</c:otherwise>
        </c:choose>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert"></button>
    </div>
</c:if>


            <!-- Thông tin nhân viên hiện tại -->
            <div class="info-section">
                <h6 class="text-primary mb-3">
                    <i class="fas fa-info-circle me-2"></i>Thông Tin Hiện Tại
                </h6>
                <div class="staff-info">
                    <div class="avatar-circle">
                        ${staff.username.substring(0, 1).toUpperCase()}
                    </div>
                    <div class="staff-details">
                        <h5>${staff.username}</h5>
                        <p>ID: ${staff.staffID} | Email: ${staff.email}</p>
                        <p>
                            <span class="badge ${staff.active ? 'bg-success' : 'bg-secondary'}">
                                ${staff.active ? 'Đang hoạt động' : 'Vô hiệu hóa'}
                            </span>
                        </p>
                    </div>
                </div>
            </div>

            <!-- Form chỉnh sửa nhân viên -->
            <div class="card">
                <div class="card-header">
                    <h6 class="m-0 font-weight-bold text-primary">
                        <i class="fas fa-edit me-2"></i>Chỉnh Sửa Thông Tin
                    </h6>
                </div>
                <div class="card-body">
                    <form action="staff" method="post" id="editStaffForm">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="id" value="${staff.staffID}">
                        
                        <!-- Thông tin đăng nhập -->
                        <div class="row mb-4">
                            <div class="col-12">
                                <h5 class="text-primary mb-3">
                                    <i class="fas fa-key me-2"></i>Thông Tin Đăng Nhập
                                </h5>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="username" class="form-label">
                                        Tên đăng nhập <span class="required">*</span>
                                    </label>
                                    <input type="text" class="form-control" id="username" name="username" 
                                           value="${staff.username}" required minlength="3">
                                    <div class="form-text">Tên đăng nhập phải có ít nhất 3 ký tự</div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="email" class="form-label">
                                        Email <span class="required">*</span>
                                    </label>
                                    <input type="email" class="form-control" id="email" name="email" 
                                           value="${staff.email}" required>
                                    <div class="form-text">Email sẽ được sử dụng để gửi thông báo</div>
                                </div>
                            </div>
                        </div>

                        <!-- Thông tin cá nhân -->
                        <div class="row mb-4">
                            <div class="col-12">
                                <h5 class="text-primary mb-3">
                                    <i class="fas fa-user me-2"></i>Thông Tin Cá Nhân
                                </h5>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="phone" class="form-label">Số điện thoại</label>
                                    <input type="tel" class="form-control" id="phone" name="phone" 
                                           value="${staff.phone}" pattern="[0-9]{10,11}">
                                    <div class="form-text">Số điện thoại từ 10-11 chữ số</div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="salary" class="form-label">Lương (VNĐ)</label>
                                    <input type="number" class="form-control" id="salary" name="salary" 
                                           value="${staff.salary}" min="0" step="1000">
                                    <div class="form-text">Nhập 0 nếu chưa có lương cố định</div>
                                </div>
                            </div>
                        </div>

                        <!-- Thông tin hợp đồng -->
                        <div class="row mb-4">
                            <div class="col-12">
                                <h5 class="text-primary mb-3">
                                    <i class="fas fa-calendar-alt me-2"></i>Thông Tin Hợp Đồng
                                </h5>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="startMonth" class="form-label">Ngày bắt đầu làm việc</label>
                                    <input type="date" class="form-control" id="startMonth" name="startMonth" 
                                           value="<fmt:formatDate value='${staff.startMonth}' pattern='yyyy-MM-dd'/>">
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="endMonth" class="form-label">Ngày kết thúc hợp đồng</label>
                                    <input type="date" class="form-control" id="endMonth" name="endMonth" 
                                           value="<fmt:formatDate value='${staff.endMonth}' pattern='yyyy-MM-dd'/>">
                                    <div class="form-text">Để trống nếu hợp đồng không thời hạn</div>
                                </div>
                            </div>
                        </div>

                        <!-- Thông báo -->
                        <div class="alert alert-info mb-4">
                            <i class="fas fa-info-circle me-2"></i>
                            <strong>Lưu ý:</strong> 
                            Việc thay đổi thông tin nhân viên có thể ảnh hưởng đến các chức năng khác trong hệ thống. 
                            Vui lòng kiểm tra kỹ trước khi lưu.
                        </div>

                        <!-- Buttons -->
                        <div class="row">
                            <div class="col-12">
                                <div class="d-flex justify-content-end gap-2">
                                    <a href="staff?action=detail&id=${staff.staffID}" class="btn btn-secondary">
                                        <i class="fas fa-times me-1"></i>Hủy
                                    </a>
                                    
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-save me-1"></i>Cập Nhật
                                    </button>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </main>

    <!-- Bootstrap Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        // Lưu giá trị ban đầu để khôi phục
        const originalValues = {
            username: '${staff.username}',
            email: '${staff.email}',
            phone: '${staff.phone}',
            salary: '${staff.salary}',
            startMonth: '<fmt:formatDate value="${staff.startMonth}" pattern="yyyy-MM-dd"/>',
            endMonth: '<fmt:formatDate value="${staff.endMonth}" pattern="yyyy-MM-dd"/>'
        };

        document.addEventListener('DOMContentLoaded', function() {
            // Tự động ẩn thông báo sau 5 giây
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(function(alert) {
                setTimeout(function() {
                    const bsAlert = new bootstrap.Alert(alert);
                    bsAlert.close();
                }, 5000);
            });

            // Validation cho form
            const form = document.getElementById('editStaffForm');
            const startDateInput = document.getElementById('startMonth');
            const endDateInput = document.getElementById('endMonth');

            // Validation ngày
            function validateDates() {
                const startDate = new Date(startDateInput.value);
                const endDate = new Date(endDateInput.value);

                if (startDate && endDate && endDate <= startDate) {
                    endDateInput.setCustomValidity('Ngày kết thúc phải sau ngày bắt đầu');
                } else {
                    endDateInput.setCustomValidity('');
                }
            }

            startDateInput.addEventListener('change', validateDates);
            endDateInput.addEventListener('change', validateDates);

            // Khi start date thay đổi, set min cho end date
            startDateInput.addEventListener('change', function() {
                if (this.value) {
                    const nextDay = new Date(this.value);
                    nextDay.setDate(nextDay.getDate() + 1);
                    endDateInput.setAttribute('min', nextDay.toISOString().split('T')[0]);
                }
            });

            // Validation form trước khi submit
            form.addEventListener('submit', function(e) {
                validateDates();
                
                if (!form.checkValidity()) {
                    e.preventDefault();
                    e.stopPropagation();
                }
                
                form.classList.add('was-validated');
            });

            // Real-time validation cho username
            const usernameInput = document.getElementById('username');
            usernameInput.addEventListener('input', function() {
                if (this.value.length > 0 && this.value.length < 3) {
                    this.setCustomValidity('Tên đăng nhập phải có ít nhất 3 ký tự');
                } else {
                    this.setCustomValidity('');
                }
            });

            // Email validation
            document.getElementById('email').addEventListener('input', function() {
                const emailRegex = /^[A-Za-z0-9+_.-]+@(.+)$/;
                if (this.value.length > 0 && !emailRegex.test(this.value)) {
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

            // Real-time validation cho salary
            const salaryInput = document.getElementById('salary');
            salaryInput.addEventListener('input', function() {
                if (this.value < 0) {
                    this.setCustomValidity('Lương không được âm');
                } else {
                    this.setCustomValidity('');
                }
            });
        });

        // Hàm khôi phục form về giá trị ban đầu
        function resetForm() {
            if (confirm('Bạn có chắc chắn muốn khôi phục về giá trị ban đầu?')) {
                document.getElementById('username').value = originalValues.username || '';
                document.getElementById('email').value = originalValues.email || '';
                document.getElementById('phone').value = originalValues.phone || '';
                document.getElementById('salary').value = originalValues.salary || '';
                document.getElementById('startMonth').value = originalValues.startMonth || '';
                document.getElementById('endMonth').value = originalValues.endMonth || '';
                
                // Clear validation
                document.getElementById('editStaffForm').classList.remove('was-validated');
            }
        }
    </script>
</body>
</html>
