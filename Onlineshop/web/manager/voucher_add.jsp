<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Thêm Voucher Mới</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <style>
            .main-content {
                background-color: #f8f9fa;
                min-height: 100vh;
                padding: 20px;
            }

            .form-card {
                background: white;
                border-radius: 15px;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                padding: 30px;
                margin: 0 auto;
                max-width: 800px;
            }

            .header-section {
                background: white;
                border-radius: 15px;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                padding: 20px;
                margin-bottom: 20px;
            }

            .form-control:focus {
                border-color: #4f63d2;
                box-shadow: 0 0 0 0.2rem rgba(79, 99, 210, 0.25);
            }

            .btn-primary {
                background-color: #4f63d2;
                border-color: #4f63d2;
                padding: 12px 30px;
                font-weight: 500;
            }

            .btn-primary:hover {
                background-color: #3d4fb8;
                border-color: #3d4fb8;
            }

            .btn-secondary {
                padding: 12px 30px;
                font-weight: 500;
            }

            .form-label {
                font-weight: 600;
                color: #333;
                margin-bottom: 8px;
            }

            .required {
                color: #dc3545;
            }

            .form-group {
                margin-bottom: 20px;
            }

            .alert {
                border-radius: 10px;
                border: none;
                padding: 15px 20px;
            }

            .breadcrumb {
                background: transparent;
                padding: 0;
                margin-bottom: 20px;
            }

            .breadcrumb-item a {
                color: #4f63d2;
                text-decoration: none;
            }

            .breadcrumb-item a:hover {
                text-decoration: underline;
            }

            .input-group-text {
                background-color: #f8f9fa;
                border-color: #ced4da;
            }

            .form-text {
                font-size: 0.875em;
                color: #6c757d;
                margin-top: 5px;
            }

            .button-group {
                display: flex;
                gap: 15px;
                justify-content: center;
                margin-top: 30px;
                padding-top: 20px;
                border-top: 1px solid #e9ecef;
            }

            .icon-input {
                position: relative;
            }

            .icon-input i {
                position: absolute;
                left: 15px;
                top: 50%;
                transform: translateY(-50%);
                color: #6c757d;
                z-index: 10;
            }

            .icon-input .form-control {
                padding-left: 45px;
            }
        </style>
    </head>
    <body>
        <!-- Include sidebar -->
        <jsp:include page="../manager_topbarsidebar.jsp" />

        <div class="main-content">
            <!-- Header -->
            <div class="header-section">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb">
                               <li class="breadcrumb-item">
    <a href="vouchers"><i class="fas fa-ticket-alt me-1"></i>Quản lý Voucher</a>
</li>

                                <li class="breadcrumb-item active" aria-current="page">Thêm voucher mới</li>
                            </ol>
                        </nav>
                        <h4 class="mb-1"><i class="fas fa-plus-circle me-2 text-primary"></i>Thêm Voucher Mới</h4>
                        <p class="text-muted mb-0">Tạo mã giảm giá mới cho khách hàng</p>
                    </div>
                </div>
            </div>

            <!-- Alert Messages -->
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-triangle me-2"></i>${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <!-- Form Card -->
            <div class="form-card">
               <form action="vouchers" method="post" id="voucherForm">
    <input type="hidden" name="action" value="add">

                    
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="form-label">
                                    <i class="fas fa-tag me-1"></i>Mã Voucher <span class="required">*</span>
                                </label>
                                <div class="icon-input">
                                    <i class="fas fa-hashtag"></i>
                                    <input type="text" class="form-control" name="code" required 
                                           placeholder="VD: SALE2025" value="${code}"
                                           pattern="[A-Z0-9]{3,20}" title="Mã voucher chỉ chứa chữ hoa và số, 3-20 ký tự">
                                </div>
                                <div class="form-text">Mã voucher chỉ chứa chữ hoa và số (3-20 ký tự)</div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="form-label">
                                    <i class="fas fa-money-bill-wave me-1"></i>Số tiền giảm (VNĐ) <span class="required">*</span>
                                </label>
                                <div class="input-group">
                                    <span class="input-group-text">₫</span>
                                    <input type="number" class="form-control" name="discountAmount" required 
                                           min="1000" step="1000" placeholder="50000" value="${discountAmount}">
                                </div>
                                <div class="form-text">Số tiền giảm tối thiểu 1,000 VNĐ</div>
                            </div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="form-label">
                                    <i class="fas fa-shopping-cart me-1"></i>Đơn tối thiểu (VNĐ) <span class="required">*</span>
                                </label>
                                <div class="input-group">
                                    <span class="input-group-text">₫</span>
                                    <input type="number" class="form-control" name="minOrderValue" required 
                                           min="0" step="1000" placeholder="200000" value="${minOrderValue}">
                                </div>
                                <div class="form-text">Giá trị đơn hàng tối thiểu để áp dụng voucher</div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="form-label">
                                    <i class="fas fa-users me-1"></i>Giới hạn sử dụng <span class="required">*</span>
                                </label>
                                <div class="icon-input">
                                    <i class="fas fa-hashtag"></i>
                                    <input type="number" class="form-control" name="usageLimit" required 
                                           min="1" placeholder="100" value="${usageLimit}">
                                </div>
                                <div class="form-text">Số lần tối đa voucher có thể được sử dụng</div>
                            </div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="form-label">
                                    <i class="fas fa-calendar-alt me-1"></i>Ngày bắt đầu <span class="required">*</span>
                                </label>
                                <input type="datetime-local" class="form-control" name="startDate" required
                                       value="${startDate}" id="startDate">
                                <div class="form-text">Thời điểm voucher bắt đầu có hiệu lực</div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="form-label">
                                    <i class="fas fa-calendar-times me-1"></i>Ngày kết thúc <span class="required">*</span>
                                </label>
                                <input type="datetime-local" class="form-control" name="endDate" required
                                       value="${endDate}" id="endDate">
                                <div class="form-text">Thời điểm voucher hết hiệu lực</div>
                            </div>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label">
                            <i class="fas fa-align-left me-1"></i>Mô tả
                        </label>
                        <textarea class="form-control" name="description" rows="4" 
                                  placeholder="Nhập mô tả về voucher, điều kiện áp dụng...">${description}</textarea>
                        <div class="form-text">Mô tả chi tiết về voucher và điều kiện sử dụng</div>
                    </div>

                    <div class="button-group">
                        <button type="button" class="btn btn-secondary" onclick="window.location.href='vouchers'">
                            <i class="fas fa-times me-2"></i>Hủy
                        </button>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save me-2"></i>Thêm Voucher
                        </button>
                
                    </div>
                </form>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            document.addEventListener('DOMContentLoaded', function() {
                // Set minimum date for datetime inputs
                const now = new Date();
                const minDateTime = now.toISOString().slice(0, 16);
                
                const startDateInput = document.getElementById('startDate');
                const endDateInput = document.getElementById('endDate');
                
                // Set minimum date to current time
                startDateInput.min = minDateTime;
                endDateInput.min = minDateTime;
                
                // Set default values if empty
                if (!startDateInput.value) {
                    startDateInput.value = minDateTime;
                }
                
                // Validate end date when start date changes
                startDateInput.addEventListener('change', function() {
                    const startDate = new Date(this.value);
                    const endDate = new Date(endDateInput.value);
                    
                    if (endDate <= startDate) {
                        // Set end date to 1 hour after start date
                        const newEndDate = new Date(startDate.getTime() + 60 * 60 * 1000);
                        endDateInput.value = newEndDate.toISOString().slice(0, 16);
                    }
                    
                    endDateInput.min = this.value;
                });
                
                // Validate start date when end date changes
                endDateInput.addEventListener('change', function() {
                    const startDate = new Date(startDateInput.value);
                    const endDate = new Date(this.value);
                    
                    if (startDate >= endDate) {
                        alert('Ngày kết thúc phải sau ngày bắt đầu!');
                        this.focus();
                    }
                });
                
                // Form validation
                document.getElementById('voucherForm').addEventListener('submit', function(e) {
                    const startDate = new Date(startDateInput.value);
                    const endDate = new Date(endDateInput.value);
                    const discountAmount = parseFloat(document.querySelector('input[name="discountAmount"]').value);
                    const minOrderValue = parseFloat(document.querySelector('input[name="minOrderValue"]').value);
                    
                    // Validate dates
                    if (startDate >= endDate) {
                        e.preventDefault();
                        alert('Ngày bắt đầu phải trước ngày kết thúc!');
                        return false;
                    }
                    
                    // Validate discount amount vs min order value
                    if (discountAmount >= minOrderValue) {
                        if (!confirm('Số tiền giảm lớn hơn hoặc bằng đơn tối thiểu. Bạn có chắc chắn muốn tiếp tục?')) {
                            e.preventDefault();
                            return false;
                        }
                    }
                    
                    // Show loading state
                    const submitBtn = this.querySelector('button[type="submit"]');
                    const originalText = submitBtn.innerHTML;
                    submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Đang xử lý...';
                    submitBtn.disabled = true;
                    
                    // Re-enable button after 5 seconds (in case of error)
                    setTimeout(function() {
                        submitBtn.innerHTML = originalText;
                        submitBtn.disabled = false;
                    }, 5000);
                });
                
                // Format number inputs
                const numberInputs = document.querySelectorAll('input[type="number"]');
                numberInputs.forEach(function(input) {
                    input.addEventListener('input', function() {
                        // Remove any non-digit characters except decimal point
                        this.value = this.value.replace(/[^0-9]/g, '');
                    });
                    
                    input.addEventListener('blur', function() {
                        if (this.value) {
                            // Format number with thousand separators for display
                            const value = parseInt(this.value);
                            if (!isNaN(value)) {
                                // Update placeholder to show formatted number
                                this.setAttribute('data-formatted', value.toLocaleString('vi-VN'));
                            }
                        }
                    });
                });
                
                // Auto-uppercase voucher code
                const codeInput = document.querySelector('input[name="code"]');
                codeInput.addEventListener('input', function() {
                    this.value = this.value.toUpperCase().replace(/[^A-Z0-9]/g, '');
                });
                
                // Auto-focus first input
                codeInput.focus();
            });
            
}
        </script>
    </body>
</html>
