<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xử lý yêu cầu tùy chỉnh</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <!-- Custom CSS -->
    <link href="css/style.css" rel="stylesheet">
</head>
<body>
    <!-- Header -->
    <jsp:include page="manager_topbarsidebar.jsp"></jsp:include>
    
    <!-- Main Content -->
    <div class="container-fluid py-4 px-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2>Xử lý yêu cầu tùy chỉnh #${customizeRequest.customizeCartID}</h2>
            <a href="manager-customize-requests" class="btn btn-outline-secondary">
                <i class="fas fa-arrow-left"></i> Quay lại danh sách
            </a>
        </div>
        
        <div class="row">
            <div class="col-md-8">
                <div class="card shadow mb-4">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">Thông tin yêu cầu</h5>
                    </div>
                    <div class="card-body">
                        <div class="row mb-3">
                            <div class="col-md-4 fw-bold">Mã yêu cầu:</div>
                            <div class="col-md-8">#${customizeRequest.customizeCartID}</div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-4 fw-bold">Khách hàng:</div>
                            <div class="col-md-8">${customizeRequest.username}</div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-4 fw-bold">Email:</div>
                            <div class="col-md-8">${customizeRequest.email}</div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-4 fw-bold">Số điện thoại:</div>
                            <div class="col-md-8">${customizeRequest.phone}</div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-4 fw-bold">Ngày yêu cầu:</div>
                            <div class="col-md-8"><fmt:formatDate value="${customizeRequest.requestDate}" pattern="dd/MM/yyyy HH:mm" /></div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-4 fw-bold">Mô tả yêu cầu:</div>
                            <div class="col-md-8">${customizeRequest.description}</div>
                        </div>
                    </div>
                </div>
                
                <div class="card shadow">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">Xử lý yêu cầu</h5>
                    </div>
                    <div class="card-body">
                        <form action="process-customize-request" method="post" id="processForm">
                            <input type="hidden" name="requestId" value="${customizeRequest.customizeCartID}">
                            
                            <div class="mb-3">
                                <label class="form-label">Quyết định:</label>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="approvalStatus" id="approve" value="1" checked>
                                    <label class="form-check-label" for="approve">
                                        <span class="text-success"><i class="fas fa-check-circle"></i> Duyệt yêu cầu</span>
                                    </label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="approvalStatus" id="reject" value="2">
                                    <label class="form-check-label" for="reject">
                                        <span class="text-danger"><i class="fas fa-times-circle"></i> Từ chối yêu cầu</span>
                                    </label>
                                </div>
                            </div>
                            
                            <div class="mb-3" id="priceSection">
                                <label for="estimatedPrice" class="form-label">Giá ước tính (VNĐ):</label>
                                <input type="number" class="form-control" id="estimatedPrice" name="estimatedPrice" min="0" step="1000" value="0">
                                <small class="text-muted">Nhập giá ước tính cho yêu cầu tùy chỉnh này</small>
                            </div>
                            
                            <div class="mb-3">
                                <label for="notes" class="form-label">Ghi chú:</label>
                                <textarea class="form-control" id="notes" name="notes" rows="3" placeholder="Nhập ghi chú hoặc phản hồi cho khách hàng..."></textarea>
                            </div>
                            
                            <div class="d-grid gap-2">
                                <button type="submit" class="btn btn-primary">Xác nhận</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="card shadow">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">Hình ảnh tham khảo</h5>
                    </div>
                    <div class="card-body text-center">
                        <img src="${customizeRequest.imageURL}" class="img-fluid rounded" alt="Hình ảnh tham khảo">
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Custom JS -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const approveRadio = document.getElementById('approve');
            const rejectRadio = document.getElementById('reject');
            const priceSection = document.getElementById('priceSection');
            
            // Hiển thị/ẩn phần giá ước tính dựa trên lựa chọn
            function togglePriceSection() {
                if (approveRadio.checked) {
                    priceSection.style.display = 'block';
                } else {
                    priceSection.style.display = 'none';
                }
            }
            
            // Thiết lập ban đầu
            togglePriceSection();
            
            // Thêm sự kiện lắng nghe
            approveRadio.addEventListener('change', togglePriceSection);
            rejectRadio.addEventListener('change', togglePriceSection);
            
            // Xác nhận trước khi gửi form
            document.getElementById('processForm').addEventListener('submit', function(e) {
                if (approveRadio.checked) {
                    const price = document.getElementById('estimatedPrice').value;
                    if (price <= 0) {
                        e.preventDefault();
                        alert('Vui lòng nhập giá ước tính hợp lệ!');
                    }
                }
            });
        });
    </script>
</body>
</html>