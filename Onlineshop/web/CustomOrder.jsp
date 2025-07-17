<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="subiz-chat.jsp" />
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewpocrt" content="width=device-width, initial-scale=1.0">
        <title>Đặt hàng tùy chỉnh</title>
        <!-- Favicon -->
        <link href="img/favicon.ico" rel="icon">

        <!-- Google Web Fonts -->
        <link rel="preconnect" href="https://fonts.gstatic.com">
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">  
        <link href="https://fonts.googleapis.com/css2?family=Dancing+Script:wght@400;700&family=Playfair+Display:wght@400;500&display=swap" rel="stylesheet">

        <!-- Font Awesome -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">

        <!-- Libraries Stylesheet -->
        <link href="lib/animate/animate.min.css" rel="stylesheet">
        <link href="lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">

        <!-- Customized Bootstrap Stylesheet -->
        <link href="css/style.css" rel="stylesheet">

        <!-- Custom Pastel Pink Flower Shop Styles -->
    </head>
    <body>
        <!-- Header -->
        <jsp:include page="header.jsp" />

        <!-- Main Content -->
        <div class="container-fluid py-5">
            <div class="custom-order-container">
                <div class="card border-0 shadow-lg">
                    <div class="card-header text-center">
                        <h2>Đặt hàng tùy chỉnh</h2>
                        <p class="mb-0">Hãy cho chúng tôi biết ý tưởng của bạn</p>
                    </div>
                    <div class="card-body">
                        <!-- Decorative elements -->
                        <div class="flower-decoration flower-1"></div>
                        <div class="flower-decoration flower-2"></div>

                        <form action="submit-customize-request" method="post" enctype="multipart/form-data" id="customOrderForm">
                            <!-- Thông tin yêu cầu -->
                            <div class="form-section">
                                <div class="form-section-title">
                                    <i class="fas fa-clipboard-list"></i>
                                    <h5>Chi tiết yêu cầu</h5>
                                </div>

                                <div class="form-group">
                                    <label for="imageUpload" class="form-label">Hình ảnh mẫu (tối đa 5 hình ảnh)</label>

                                    <!-- Khu vực kéo thả -->
                                    <div class="image-drop-area" id="imageDropArea">
                                        <div class="drop-message text-center p-4">
                                            <i class="fas fa-cloud-upload-alt fa-3x mb-3 text-muted"></i>
                                            <p>Kéo và thả hình ảnh vào đây hoặc <span class="text-primary">nhấp để chọn file</span></p>
                                            <p class="small text-muted">Hỗ trợ: JPG, JPEG, PNG (Tối đa 5 hình ảnh)</p>
                                        </div>
                                        <input type="file" id="fileInput" name="imageUpload" accept="image/*" multiple style="display: none;" required>
                                    </div>

                                    <!-- Khu vực xem trước hình ảnh -->
                                    <div class="image-preview-container mt-3" id="imagePreviewContainer">
                                        <!-- Hình ảnh sẽ được hiển thị ở đây -->
                                    </div>

                                    <!-- Input ẩn để lưu trữ các file đã chọn -->
                                    <input type="file" id="imageUpload" name="imageUpload" accept="image/*" style="display: none;" required>
                                    <input type="file" id="imageUpload2" name="imageUpload2" accept="image/*" style="display: none;">
                                    <input type="file" id="imageUpload3" name="imageUpload3" accept="image/*" style="display: none;">
                                    <input type="file" id="imageUpload4" name="imageUpload4" accept="image/*" style="display: none;">
                                    <input type="file" id="imageUpload5" name="imageUpload5" accept="image/*" style="display: none;">

                                    <small class="text-muted"><i class="fas fa-info-circle"></i> Tải lên tối đa 5 hình ảnh mẫu để chúng tôi hiểu rõ hơn về yêu cầu của bạn.</small>
                                </div>

                                <div class="form-group">
                                    <label for="description" class="form-label">Mô tả chi tiết</label>
                                    <textarea class="form-control" id="description" name="description" rows="5"placeholder="Vui lòng cung cấp thông tin chi tiết về sản phẩm bạn muốn đặt (loại hoa, màu sắc, kích thước, dịp tặng, ngân sách và các yêu cầu riêng nếu có) để chúng tôi tư vấn phù hợp."><c:out value="${sessionScope.savedDescription}"/></textarea>
                                    <small class="text-muted"><i class="fas fa-lightbulb"></i> Càng chi tiết càng giúp chúng tôi hiểu rõ nhu cầu của bạn</small>
                                </div>

                                <div class="form-group">
                                    <label for="quantity" class="form-label">Số lượng</label>
                                    <input type="number" class="form-control" id="quantity" name="quantity" value="${not empty sessionScope.savedQuantity ? sessionScope.savedQuantity : '1'}">
                                    <small class="text-muted"><i class="fas fa-box"></i> Nhập số lượng sản phẩm bạn muốn đặt</small>
                                </div>
                                <div class="form-group">
                                    <label for="editDesiredPrice">Giá mong muốn (VNĐ)</label>
                                    <input type="number" class="form-control" placeholder="giá mong muốn gợi ý: 100000, 200000" id="editDesiredPrice" name="desiredPrice" min="0" step="1000" required>
                                    <small class="text-muted"><i class="fas fa-tag"></i>Nhập giá mong muốn cho sản phẩm (VNĐ)</small>
                                </div>
                            </div>

                            <!-- Nút gửi -->
                            <div class="d-grid gap-2">
                                <button type="submit" class="btn btn-primary btn-lg">
                                    <i class="fas fa-paper-plane mr-2"></i> Gửi yêu cầu
                                </button>
                            </div>

                            <div class="footer-note">
                                <small><i class="fas fa-clock"></i> Chúng tôi sẽ liên hệ với bạn trong vòng 24 giờ sau khi nhận được yêu cầu</small>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <!-- Footer -->
        <jsp:include page="footer.jsp" />

        <!-- JavaScript Libraries -->
        <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.bundle.min.js"></script>
        <script src="lib/easing/easing.min.js"></script>
        <script src="lib/owlcarousel/owl.carousel.min.js"></script>

        <!-- Contact Javascript File -->
        <script src="mail/jqBootstrapValidation.min.js"></script>
        <script src="mail/contact.js"></script>

        <!-- Template Javascript -->
        <script src="js/main.js"></script>

        <!-- Sticky Button for Custom Order -->
        <div class="flower-fixed-btn">
            <a href="CustomOrder.jsp" title="Đặt hoa theo yêu cầu">
                <i class="fas fa-seedling"></i> <!-- Bạn có thể thay bằng: fa-pencil-alt, fa-heart, fa-rose -->
            </a>
        </div>
        <!-- Sticky Button for Custom Order End -->

        <!-- Toast Container -->
        <div class="toast-container"></div>
        <style>
            .toast-container {
                position: fixed;
                top: 20px;
                right: 20px;
                z-index: 9999;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }

            .toast {
                padding: 15px 25px;
                margin-bottom: 12px;
                border-radius: 12px;
                color: #5f375f;
                background-color: #fce4ec;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
                opacity: 0;
                transform: translateX(100%);
                transition: all 0.4s ease-in-out;
                border-left: 6px solid #f48fb1;
            }

            .toast.show {
                opacity: 1;
                transform: translateX(0);
            }

            .toast.success {
                background-color: #f8bbd0;
                border-left-color: #40ec46;
            }

            .toast.error {
                background-color: #fce4ec;
                border-left-color: #d81b60;
            }

            /* Khu vực kéo thả */
            .image-drop-area {
                border: 2px dashed #f8bbd0;
                border-radius: 10px;
                padding: 20px;
                text-align: center;
                background-color: #fff5f8;
                transition: all 0.3s ease;
                cursor: pointer;
            }

            .image-drop-area:hover, .image-drop-area.dragover {
                background-color: #fce4ec;
                border-color: #f48fb1;
            }

            /* Khu vực xem trước hình ảnh */
            .image-preview-container {
                display: flex;
                flex-wrap: wrap;
                gap: 10px;
                margin-top: 15px;
            }

            .image-preview-item {
                position: relative;
                width: 120px;
                height: 120px;
                border-radius: 8px;
                overflow: hidden;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
                border: 1px solid #f8bbd0;
            }

            .image-preview-item img {
                width: 100%;
                height: 100%;
                object-fit: cover;
            }

            .image-preview-item .remove-btn {
                position: absolute;
                top: 5px;
                right: 5px;
                background-color: rgba(255,255,255,0.8);
                border-radius: 50%;
                width: 24px;
                height: 24px;
                display: flex;
                align-items: center;
                justify-content: center;
                cursor: pointer;
                color: #d81b60;
                transition: all 0.2s;
            }

            .image-preview-item .remove-btn:hover {
                background-color: #d81b60;
                color: white;
            }

            .image-preview-item .main-badge {
                position: absolute;
                bottom: 5px;
                left: 5px;
                background-color: rgba(244, 143, 177, 0.8);
                color: white;
                font-size: 10px;
                padding: 2px 6px;
                border-radius: 10px;
            }
        </style>
        <script>
            // Biến lưu trữ các file đã chọn
            let selectedFiles = [];
            const maxFiles = 5;

            // Lấy các phần tử DOM
            const dropArea = document.getElementById('imageDropArea');
            const fileInput = document.getElementById('fileInput');
            const previewContainer = document.getElementById('imagePreviewContainer');
            const hiddenInputs = [
                document.getElementById('imageUpload'),
                document.getElementById('imageUpload2'),
                document.getElementById('imageUpload3'),
                document.getElementById('imageUpload4'),
                document.getElementById('imageUpload5')
            ];

            // Sự kiện click vào khu vực kéo thả
            dropArea.addEventListener('click', () => {
                fileInput.click();
            });

            // Ngăn chặn hành vi mặc định của trình duyệt khi kéo thả
            ['dragenter', 'dragover', 'dragleave', 'drop'].forEach(eventName => {
                dropArea.addEventListener(eventName, preventDefaults, false);
            });

            function preventDefaults(e) {
                e.preventDefault();
                e.stopPropagation();
            }

            // Thêm hiệu ứng khi kéo file vào khu vực
            ['dragenter', 'dragover'].forEach(eventName => {
                dropArea.addEventListener(eventName, () => {
                    dropArea.classList.add('dragover');
                });
            });

            ['dragleave', 'drop'].forEach(eventName => {
                dropArea.addEventListener(eventName, () => {
                    dropArea.classList.remove('dragover');
                });
            });

            // Xử lý khi thả file
            dropArea.addEventListener('drop', (e) => {
                const dt = e.dataTransfer;
                const files = dt.files;
                handleFiles(files);
            });

            // Xử lý khi chọn file qua input
            fileInput.addEventListener('change', (e) => {
                const files = e.target.files;
                handleFiles(files);
            });

            // Xử lý các file được chọn
            function handleFiles(files) {
                const filesArray = Array.from(files);

                // Kiểm tra số lượng file
                if (selectedFiles.length + filesArray.length > maxFiles) {
                    showToast(`Chỉ có thể tải lên tối đa ${maxFiles} hình ảnh. Chỉ 5 ảnh đầu tiên sẽ được thêm vào.`, 'error');
                    filesArray.splice(Math.max(0, maxFiles - selectedFiles.length));
                }

                // Lọc chỉ lấy file hình ảnh
                const imageFiles = filesArray.filter(file => file.type.match('image.*'));

                if (filesArray.length !== imageFiles.length) {
                    showToast('Chỉ chấp nhận file hình ảnh', 'error');
                }

                // Thêm vào danh sách file đã chọn
                selectedFiles = [...selectedFiles, ...imageFiles].slice(0, maxFiles);

                // Cập nhật giao diện
                updatePreview();
                updateHiddenInputs();
            }

            // Cập nhật giao diện xem trước
            function updatePreview() {
                // Xóa tất cả các preview hiện tại
                previewContainer.innerHTML = '';

                // Tạo preview cho mỗi file
                selectedFiles.forEach((file, index) => {
                    const reader = new FileReader();
                    const previewItem = document.createElement('div');
                    previewItem.className = 'image-preview-item';

                    // Tạo thẻ img
                    const img = document.createElement('img');
                    previewItem.appendChild(img);

                    // Tạo nút xóa
                    const removeBtn = document.createElement('div');
                    removeBtn.className = 'remove-btn';
                    removeBtn.innerHTML = '<i class="fas fa-times"></i>';
                    removeBtn.addEventListener('click', (e) => {
                        e.stopPropagation(); // Ngăn không cho sự kiện click lan đến dropArea
                        removeFile(index);
                    });
                    previewItem.appendChild(removeBtn);

                    // Thêm badge cho ảnh chính
                    if (index === 0) {
                        const mainBadge = document.createElement('div');
                        mainBadge.className = 'main-badge';
                        mainBadge.textContent = 'Ảnh chính';
                        previewItem.appendChild(mainBadge);
                    }

                    // Đọc file và hiển thị
                    reader.onload = (e) => {
                        img.src = e.target.result;
                    };
                    reader.readAsDataURL(file);

                    previewContainer.appendChild(previewItem);
                });
            }

            // Cập nhật các input ẩn để gửi lên server
            function updateHiddenInputs() {
                // Reset tất cả các input ẩn
                hiddenInputs.forEach(input => {
                    const dataTransfer = new DataTransfer();
                    input.files = dataTransfer.files;
                });

                // Gán file cho từng input ẩn
                selectedFiles.forEach((file, index) => {
                    if (index < hiddenInputs.length) {
                        const dataTransfer = new DataTransfer();
                        dataTransfer.items.add(file);
                        hiddenInputs[index].files = dataTransfer.files;
                    }
                });
            }

            // Xóa file khỏi danh sách
            function removeFile(index) {
                selectedFiles.splice(index, 1);
                updatePreview();
                updateHiddenInputs();
            }

            // Kiểm tra form trước khi submit
            document.getElementById('customOrderForm').addEventListener('submit', (e) => {
                if (selectedFiles.length === 0) {
                    e.preventDefault();
                    showToast('Vui lòng tải lên ít nhất 1 hình ảnh', 'error');
                }
            });

            // Hàm hiển thị thông báo
            function showToast(message, type) {
                const container = document.querySelector('.toast-container');
                const toast = document.createElement('div');
                toast.className = `toast ${type}`;
                toast.textContent = message;

                container.appendChild(toast);

                // Reflow để kích hoạt animation
                toast.offsetHeight;

                // Show toast
                toast.classList.add('show');

                // Tự động biến mất sau 3s
                setTimeout(() => {
                    toast.classList.remove('show');
                    setTimeout(() => {
                        container.removeChild(toast);
                    }, 400);
                }, 3000);
            }

            // Lấy message từ session JSP
            const message = '<%= session.getAttribute("message") != null ? session.getAttribute("message") : "" %>';
            const messageType = '<%= session.getAttribute("messageType") != null ? session.getAttribute("messageType") : "" %>';

            if (message && messageType) {
                showToast(message, messageType);
            <% session.removeAttribute("message"); %>
            <% session.removeAttribute("messageType"); %>
            }
        </script>

        <!-- Contact Information Modal -->
        <div class="modal fade" id="contactInfoModal" tabindex="-1" aria-labelledby="contactInfoModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="contactInfoModalLabel">Thông tin liên hệ</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <p>Vui lòng cung cấp thông tin liên hệ của bạn để chúng tôi có thể liên lạc về yêu cầu đặt hàng.</p>
                        <form id="contactInfoForm">
                            <div class="form-group">
                                <label for="fullName">Họ và tên <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="fullName" name="fullName" required>
                            </div>
                            <div class="form-group">
                                <label for="phone">Số điện thoại <span class="text-danger">*</span></label>
                                <input type="tel" class="form-control" id="phone" name="phone" required>
                            </div>
                            <div class="form-group">
                                <label for="email">Email <span class="text-danger">*</span></label>
                                <input type="email" class="form-control" id="email" name="email" required>
                            </div>
                            <div class="text-right">
                                <button type="button" class="btn btn-secondary" data-dismiss="modal">Hủy</button>
                                <button type="submit" class="btn btn-primary">Xác nhận</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <script>
            // Xử lý form đặt hàng tùy chỉnh
            document.getElementById('customOrderForm').addEventListener('submit', function (e) {
                e.preventDefault(); // Ngăn form submit mặc định

                // Kiểm tra xem đã chọn ít nhất 1 hình ảnh chưa
                if (selectedFiles.length === 0) {
                    showToast('Vui lòng tải lên ít nhất 1 hình ảnh', 'error');
                    return;
                }

                // Hiển thị modal thông tin liên hệ
                $('#contactInfoModal').modal('show');
            });

            // Xử lý form thông tin liên hệ
            document.getElementById('contactInfoForm').addEventListener('submit', function (e) {
                e.preventDefault(); // Ngăn form submit mặc định

                // Lấy thông tin từ form liên hệ
                const fullName = document.getElementById('fullName').value;
                const phone = document.getElementById('phone').value;
                const email = document.getElementById('email').value;

                // Kiểm tra thông tin
                if (!fullName || !phone || !email) {
                    showToast('Vui lòng điền đầy đủ thông tin liên hệ', 'error');
                    return;
                }

                // Tạo các input ẩn để gửi thông tin liên hệ
                const fullNameInput = document.createElement('input');
                fullNameInput.type = 'hidden';
                fullNameInput.name = 'fullName';
                fullNameInput.value = fullName;

                const phoneInput = document.createElement('input');
                phoneInput.type = 'hidden';
                phoneInput.name = 'phone';
                phoneInput.value = phone;

                const emailInput = document.createElement('input');
                emailInput.type = 'hidden';
                emailInput.name = 'email';
                emailInput.value = email;

                // Thêm các input vào form chính
                const mainForm = document.getElementById('customOrderForm');
                mainForm.appendChild(fullNameInput);
                mainForm.appendChild(phoneInput);
                mainForm.appendChild(emailInput);

                // Đóng modal
                $('#contactInfoModal').modal('hide');

                // Submit form chính
                mainForm.submit();
            });
        </script>
    </body>
</html>