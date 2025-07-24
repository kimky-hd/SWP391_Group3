<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Gửi khiếu nại</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">

    <meta content="Free HTML Templates" name="keywords">
    <meta content="Free HTML Templates" name="description">

    <!-- Favicon -->
    <link href="img/favicon.ico" rel="icon">

    <!-- Google Web Fonts -->
    <link rel="preconnect" href="https://fonts.gstatic.com">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">  

    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">

    <!-- Libraries Stylesheet -->
    <link href="lib/animate/animate.min.css" rel="stylesheet">
    <link href="lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">

    <!-- Customized Bootstrap Stylesheet -->
    <link href="css/style.css" rel="stylesheet">

    <style>
        .complaint-form {
            max-width: 800px;
            margin: auto;
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
        .image-preview-container {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-top: 10px;
        }
        .image-preview-item {
            display: flex;
            flex-direction: column;
            align-items: center;
            position: relative;
            width: 150px;
        }
        .image-preview {
            width: 100%;
            height: auto;
            border-radius: 6px;
            object-fit: cover;
            border: 2px solid #ddd;
        }
        .remove-image {
            position: absolute;
            top: -5px;
            right: -5px;
            background: #dc3545;
            color: white;
            border: none;
            border-radius: 50%;
            width: 25px;
            height: 25px;
            font-size: 12px;
            cursor: pointer;
        }
        .file-input-label {
            background-color: #007bff;
            color: white;
            padding: 8px 16px;
            border-radius: 4px;
            cursor: pointer;
            display: inline-block;
        }
        .file-input-label:hover {
            background-color: #0056b3;
        }
        #fileInput {
            position: absolute;
            left: -9999px;
        }
        .image-count {
            font-size: 0.9em;
            color: #666;
            margin-top: 5px;
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

        <form action="complaint" method="post" enctype="multipart/form-data" id="complaintForm">
            <input type="hidden" name="action" value="create">
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

            <!-- Upload ảnh -->
            <div class="mb-3">
                <label class="form-label">Hình ảnh minh họa (tối đa 5 ảnh)</label>
                <label for="fileInput" class="file-input-label">
                    <i class="fas fa-camera"></i> Chọn ảnh
                </label>
                <input type="file" id="fileInput" accept="image/*" multiple>
                
                <!-- Input ẩn để chứa file thực sự gửi lên server -->
                <div id="hiddenInputs"></div>
                
                <div class="form-text">
                    Tải lên hình ảnh để minh họa vấn đề (JPG, PNG, GIF; mỗi ảnh tối đa 10MB).
                </div>
                <div class="image-count" id="imageCount">Đã chọn: 0/5 ảnh</div>
                <div class="image-preview-container" id="imagePreviewContainer"></div>
            </div>

            <div class="d-grid gap-2">
                <button type="submit" class="btn btn-primary">Gửi khiếu nại</button>
                <a href="order?action=view" class="btn btn-outline-secondary">Quay lại</a>
            </div>
        </form>
    </div>
</div>

<jsp:include page="footer.jsp" />

<!-- Scripts -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://kit.fontawesome.com/your-fontawesome-kit.js"></script>
<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>

<script>
    let selectedFiles = [];
    const maxFiles = 5;
    const fileInput = document.getElementById('fileInput');
    const hiddenInputsContainer = document.getElementById('hiddenInputs');

    fileInput.addEventListener('change', function () {
        const newFiles = Array.from(this.files);

        if (selectedFiles.length + newFiles.length > maxFiles) {
            alert(`Bạn chỉ có thể chọn tối đa ${maxFiles} ảnh.`);
            return;
        }

        for (const file of newFiles) {
            if (file.size > 10 * 1024 * 1024) {
                alert(`Ảnh "${file.name}" vượt quá 10MB.`);
                return;
            }
        }

        selectedFiles = selectedFiles.concat(newFiles);
        updateHiddenInputs();
        renderPreviews();
        updateImageCount();
        
        // Reset file input để có thể chọn lại cùng file
        this.value = '';
    });

    function updateHiddenInputs() {
        // Xóa tất cả input ẩn cũ
        hiddenInputsContainer.innerHTML = '';
        
        // Tạo input ẩn cho mỗi file đã chọn
        selectedFiles.forEach((file, index) => {
            const input = document.createElement('input');
            input.type = 'file';
            input.name = 'complaintImages';
            input.style.display = 'none';
            
            // Tạo DataTransfer để gán file vào input
            const dt = new DataTransfer();
            dt.items.add(file);
            input.files = dt.files;
            
            hiddenInputsContainer.appendChild(input);
        });
        
        console.log('✅ Đã tạo', selectedFiles.length, 'input ẩn cho upload');
    }

    function renderPreviews() {
        const container = document.getElementById('imagePreviewContainer');
        container.innerHTML = '';
        
        selectedFiles.forEach((file, index) => {
            const reader = new FileReader();
            reader.onload = function (e) {
                const div = document.createElement('div');
                div.className = 'image-preview-item';
                div.innerHTML = `
                    <img src="${e.target.result}" class="image-preview" />
                    <div style="font-size: 0.85em; margin-top: 4px; text-align: center;">${file.name}</div>
                    <button class="remove-image" type="button" onclick="removeImage(${index})">×</button>
                `;
                container.appendChild(div);
            };
            reader.readAsDataURL(file);
        });
    }

    function updateImageCount() {
        document.getElementById('imageCount').textContent =
            `Đã chọn: ${selectedFiles.length}/${maxFiles} ảnh`;
    }

    function removeImage(index) {
        selectedFiles.splice(index, 1);
        updateHiddenInputs();
        renderPreviews();
        updateImageCount();
    }

    // Debug form submit
    document.getElementById('complaintForm').addEventListener('submit', function(e) {
        console.log('=== FORM SUBMIT DEBUG ===');
        console.log('Số file sẽ upload:', selectedFiles.length);
        
        selectedFiles.forEach((file, index) => {
            console.log(`File ${index + 1}:`, file.name, 'Size:', file.size);
        });
        
        // Kiểm tra FormData
        const formData = new FormData(this);
        let fileCount = 0;
        for (let [key, value] of formData.entries()) {
            if (key === 'complaintImages' && value instanceof File) {
                fileCount++;
                console.log('FormData file:', value.name, 'Size:', value.size);
            }
        }
        console.log('Tổng file trong FormData:', fileCount);
        console.log('=== END DEBUG ===');
    });
    // Thêm vào cuối script trong JSP
document.getElementById('complaintForm').addEventListener('submit', function(e) {
    console.log('=== CLIENT SIDE DEBUG ===');
    console.log('📤 Submitting form with', selectedFiles.length, 'files');
    
    selectedFiles.forEach((file, index) => {
        console.log(`📎 File ${index + 1}:`);
        console.log(`  - Name: ${file.name}`);
        console.log(`  - Size: ${file.size} bytes`);
        console.log(`  - Type: ${file.type}`);
       
    });
    
    // Kiểm tra FormData
    const formData = new FormData(this);
    let fileCount = 0;
    console.log('📋 FormData contents:');
    
    for (let [key, value] of formData.entries()) {
        if (key === 'complaintImages' && value instanceof File) {
            fileCount++;
            console.log(`  📁 ${key}[${fileCount}]: ${value.name} (${value.size} bytes)`);
        } else if (value instanceof File) {
            console.log(`  📄 ${key}: ${value.name}`);
        } else {
            console.log(`  📝 ${key}: ${value}`);
        }
    }
    
    console.log(`📊 Total files in FormData: ${fileCount}`);
    console.log('=== END CLIENT DEBUG ===');
});

</script>

<script src="https://widget.subiz.net/sbz/app.js?account_id=acpzooihzhalzeskamky"></script>

<!-- JavaScript Libraries -->
<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.bundle.min.js"></script>
<script src="lib/easing/easing.min.js"></script>
<script src="lib/owlcarousel/owl.carousel.min.js"></script>

<!-- Contact Javascript File -->
<script src="mail/jqBootstrapValidation.min.js"></script>
<script src="mail/contact.js"></script>

</body>
</html>
