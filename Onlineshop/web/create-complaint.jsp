<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gửi khiếu nại</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .complaint-form {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
            background-color: #f8f9fa;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        .order-info {
            background-color: #e9ecef;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        .image-preview {
            max-width: 100%;
            max-height: 300px;
            margin-top: 10px;
            border-radius: 5px;
            display: none;
        }
    </style>
</head>
<body>
  
    <jsp:include page="header.jsp" />
    <div class="container mt-5 mb-5">
        <div class="complaint-form">
            <h2 class="text-center mb-4">Gửi khiếu nại</h2>
            
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger" role="alert">
                    ${errorMessage}
                </div>
            </c:if>
            
            <div class="order-info">
                <h5>Thông tin đơn hàng #${order.orderId}</h5>
                <p><strong>Ngày đặt:</strong> ${order.orderDate}</p>
                <p><strong>Trạng thái:</strong> ${order.status}</p>
                <p><strong>Tổng tiền:</strong> ${order.total} VNĐ</p>
            </div>
            
            <form action="complaint?action=create" method="post" enctype="multipart/form-data">
                <input type="hidden" name="maHD" value="${order.orderId}">
                
                <div class="mb-3">
                    <label for="title" class="form-label">Tiêu đề khiếu nại <span class="text-danger">*</span></label>
                    <input type="text" class="form-control" id="title" name="title" required>
                </div>
                
                <div class="mb-3">
                    <label for="content" class="form-label">Nội dung khiếu nại <span class="text-danger">*</span></label>
                    <textarea class="form-control" id="content" name="content" rows="5" required></textarea>
                    <div class="form-text">Vui lòng mô tả chi tiết vấn đề bạn gặp phải.</div>
                </div>
                
                <div class="mb-3">
                    <label for="complaintImage" class="form-label">Hình ảnh minh họa (nếu có)</label>
                    <input type="file" class="form-control" id="complaintImage" name="complaintImage" accept="image/*" onchange="previewImage(this)">
                    <div class="form-text">Tải lên hình ảnh để minh họa vấn đề (định dạng: JPG, PNG, GIF; tối đa 10MB).</div>
                    <img id="imagePreview" src="#" alt="Xem trước hình ảnh" class="image-preview">
                </div>
                
                <div class="d-grid gap-2">
                    <button type="submit" class="btn btn-primary">Gửi khiếu nại</button>
                    <a href="order?action=view" class="btn btn-outline-secondary">Quay lại</a>
                </div>
            </form>
        </div>
    </div>
    
    <jsp:include page="footer.jsp" />
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Script xem trước hình ảnh -->
    <script>
        function previewImage(input) {
            var preview = document.getElementById('imagePreview');
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                
                reader.onload = function(e) {
                    preview.src = e.target.result;
                    preview.style.display = 'block';
                }
                
                reader.readAsDataURL(input.files[0]);
            } else {
                preview.src = '#';
                preview.style.display = 'none';
            }
        }
    </script>
</body>
</html>
