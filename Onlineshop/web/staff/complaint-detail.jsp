<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Chi tiết khiếu nại</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            .status-processing {
                background-color: #b8daff;
                color: #004085;
            }
            .status-resolved {
                background-color: #c3e6cb;
                color: #155724;
            }
            .status-rejected {
                background-color: #f5c6cb;
                color: #721c24;
            }
            .badge {
                font-size: 0.9rem;
                padding: 0.5rem;
            }
            
            /* ===== STYLES CHO GALLERY ẢNH - PHIÊN BẢN HOÀN CHỈNH ===== */
            .images-gallery {
                margin: 20px 0;
                padding: 15px;
                background-color: #f8f9fa;
                border-radius: 8px;
                border: 1px solid #dee2e6;
            }
            
            .images-count {
                color: #495057;
                font-size: 0.95rem;
                margin-bottom: 15px;
                padding: 8px 12px;
                background-color: #e9ecef;
                border-radius: 6px;
                border-left: 4px solid #007bff;
                display: inline-block;
                font-weight: 500;
            }
            
            .images-count i {
                color: #007bff;
                margin-right: 8px;
            }
            
            /* Grid layout cho nhiều ảnh */
            .images-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
                gap: 20px;
                margin-top: 15px;
            }
            
            .image-item {
                position: relative;
                border-radius: 12px;
                overflow: hidden;
                box-shadow: 0 4px 12px rgba(0,0,0,0.1);
                transition: all 0.3s ease;
                background: white;
                border: 2px solid transparent;
            }
            
            .image-item:hover {
                transform: translateY(-5px);
                box-shadow: 0 8px 25px rgba(0,0,0,0.15);
                border-color: #007bff;
            }
            
            .complaint-image {
                width: 100%;
                height: 220px;
                object-fit: cover;
                cursor: pointer;
                transition: transform 0.3s ease;
                border: none;
                display: block;
            }
            
            .complaint-image:hover {
                transform: scale(1.05);
            }
            
            .image-overlay {
                position: absolute;
                bottom: 0;
                left: 0;
                right: 0;
                background: linear-gradient(transparent, rgba(0,0,0,0.8));
                color: white;
                padding: 12px;
                font-size: 0.85rem;
                text-align: center;
                font-weight: 500;
            }
            
            /* Container cho ảnh đơn lẻ */
            .single-image-container {
                text-align: center;
                margin: 20px 0;
                max-width: 500px;
                margin-left: auto;
                margin-right: auto;
            }
            
            .single-image {
                max-width: 100%;
                height: auto;
                max-height: 400px;
                border-radius: 12px;
                box-shadow: 0 4px 15px rgba(0,0,0,0.1);
                cursor: pointer;
                transition: all 0.3s ease;
                border: 2px solid transparent;
            }
            
            .single-image:hover {
                transform: scale(1.02);
                box-shadow: 0 6px 20px rgba(0,0,0,0.15);
                border-color: #007bff;
            }
            
            /* Modal styles - NÂNG CAP */
            .image-modal .modal-dialog {
                max-width: 95vw;
                max-height: 95vh;
                margin: 1.75rem auto;
            }
            
            .image-modal .modal-content {
                background: transparent;
                border: none;
                border-radius: 15px;
                overflow: hidden;
            }
            
            .image-modal .modal-header {
                background: rgba(0,0,0,0.9);
                color: white;
                border-bottom: none;
                padding: 15px 20px;
            }
            
            .image-modal .modal-body {
                padding: 0;
                text-align: center;
                background: rgba(0,0,0,0.95);
                position: relative;
                min-height: 300px;
                display: flex;
                align-items: center;
                justify-content: center;
            }
            
            .image-modal img {
                max-width: 100%;
                max-height: 80vh;
                object-fit: contain;
                border-radius: 8px;
                box-shadow: 0 4px 20px rgba(255,255,255,0.1);
            }
            
            .image-modal .modal-footer {
                background: rgba(0,0,0,0.9);
                border-top: none;
                padding: 15px 20px;
            }
            
            .image-modal .btn-close {
                filter: invert(1);
                opacity: 0.8;
            }
            
            .image-modal .btn-close:hover {
                opacity: 1;
            }
            
            /* Loading animation */
            .image-loading {
                background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
                background-size: 200% 100%;
                animation: loading 1.5s infinite;
            }
            
            @keyframes loading {
                0% { background-position: 200% 0; }
                100% { background-position: -200% 0; }
            }
            
            /* Image counter info */
            .image-info {
                position: absolute;
                top: 15px;
                right: 15px;
                background: rgba(0,0,0,0.7);
                color: white;
                padding: 8px 12px;
                border-radius: 20px;
                font-size: 0.9rem;
                font-weight: 500;
            }
            
            /* Zoom hint */
            .zoom-hint {
                position: absolute;
                bottom: 15px;
                left: 50%;
                transform: translateX(-50%);
                background: rgba(0,0,0,0.7);
                color: white;
                padding: 8px 15px;
                border-radius: 20px;
                font-size: 0.85rem;
                opacity: 0;
                transition: opacity 0.3s ease;
            }
            
            .image-item:hover .zoom-hint,
            .single-image-container:hover .zoom-hint {
                opacity: 1;
            }
            
            /* Responsive */
            @media (max-width: 768px) {
                .images-grid {
                    grid-template-columns: repeat(auto-fill, minmax(160px, 1fr));
                    gap: 15px;
                }
                
                .complaint-image {
                    height: 160px;
                }
                
                .main-content {
                    margin-left: 0 !important;
                }
                
                .image-modal .modal-dialog {
                    margin: 0.5rem;
                    max-width: calc(100vw - 1rem);
                }
                
                .single-image {
                    max-height: 300px;
                }
            }
            
            @media (max-width: 576px) {
                .images-grid {
                    grid-template-columns: repeat(auto-fill, minmax(140px, 1fr));
                    gap: 10px;
                }
                
                .complaint-image {
                    height: 140px;
                }
                
                .images-gallery {
                    padding: 10px;
                    margin: 15px 0;
                }
            }
            
            /* Existing styles */
            .complaint-content, .response-content {
                background-color: #f8f9fa;
                padding: 15px;
                border-radius: 5px;
                margin-bottom: 20px;
            }
            .user-info {
                padding: 15px;
                border-left: 3px solid #6c757d;
                background-color: #f8f9fa;
                margin-bottom: 20px;
            }
            
            .main-content {
                margin-left: 250px !important;
                padding: 20px !important;
                transition: margin-left 0.3s !important;
            }
            
            @media (max-width: 768px) {
                .main-content {
                    margin-left: 0 !important;
                }
            }
        </style>
    </head>
    <body>
        <jsp:include page="../manager_topbarsidebar.jsp" />

        <!-- Main Content -->
        <div class="main-content">
            <div class="container-fluid">
                <div class="row">
                    <!-- Main Content -->
                    <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                        <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                            <h1 class="h2">Chi tiết khiếu nại #${complaint.complaintID}</h1>
                            <div class="btn-toolbar mb-2 mb-md-0">
                                <div class="btn-group me-2">
                                    <a href="${pageContext.request.contextPath}/staff/complaints" class="btn btn-sm btn-outline-secondary">
                                        <i class="fas fa-arrow-left"></i> Quay lại danh sách
                                    </a>
                                    <c:if test="${complaint.status eq 'Đang xử lý'}">
                                        <a href="${pageContext.request.contextPath}/staff/complaints?action=respond&id=${complaint.complaintID}" class="btn btn-sm btn-primary">
                                            <i class="fas fa-reply"></i> Phản hồi
                                        </a>
                                    </c:if>
                                </div>
                            </div>
                        </div>

                        <!-- Thông báo lỗi hoặc thành công -->
                        <c:if test="${not empty errorMessage}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                ${errorMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        </c:if>

                        <c:if test="${not empty successMessage}">
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                ${successMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        </c:if>

                        <!-- Thông tin khiếu nại -->
                        <div class="row mb-4">
                            <div class="col-md-8">
                                <div class="card">
                                    <div class="card-header d-flex justify-content-between align-items-center">
                                        <h5 class="mb-0">${complaint.title}</h5>
                                        <span class="badge ${complaint.status eq 'Đang xử lý' ? 'status-processing' : 
                                                             complaint.status eq 'Đã xử lý' ? 'status-resolved' : 'status-rejected'}">
                                            ${complaint.status}
                                        </span>
                                    </div>
                                    <div class="card-body">
                                        <!-- Thông tin người gửi khiếu nại -->
                                        <div class="user-info mb-4">
                                            <div class="d-flex align-items-center mb-2">
                                                <i class="fas fa-user-circle fa-2x me-2 text-secondary"></i>
                                                <h6 class="fw-bold mb-0">Người gửi khiếu nại</h6>
                                            </div>
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <p><strong>Họ tên:</strong> ${userProfile.fullName}</p>
                                                </div>
                                                <div class="col-md-6">
                                                    <p><strong>Số điện thoại:</strong> ${userProfile.phoneNumber}</p>
                                                    <p><strong>Địa chỉ:</strong> ${userProfile.address}</p>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="mb-3">
                                            <h6 class="fw-bold">Nội dung khiếu nại:</h6>
                                            <div class="complaint-content">
                                                ${complaint.content}
                                            </div>
                                        </div>

                                        <!-- ===== PHẦN HIỂN THỊ ẢNH MỚI - HOÀN CHỈNH ===== -->
                                        <c:choose>
                                            <c:when test="${not empty complaint.images and complaint.images.size() > 0}">
                                                <h6 class="fw-bold mb-3">
                                                    <i class="fas fa-images me-2 text-primary"></i>
                                                    Hình ảnh đính kèm:
                                                </h6>
                                                <div class="images-gallery">
                                                    <div class="images-count">
                                                        <i class="fas fa-camera"></i>
                                                        <strong>${complaint.images.size()}</strong> hình ảnh được đính kèm
                                                    </div>
                                                    
                                                    <c:choose>
                                                        <c:when test="${complaint.images.size() == 1}">
                                                            <!-- Hiển thị 1 ảnh duy nhất -->
                                                            <div class="single-image-container">
                                                                <div style="position: relative; display: inline-block;">
                                                                    <img src="${pageContext.request.contextPath}/${complaint.images[0].imagePath}" 
                                                                         alt="Hình ảnh khiếu nại" 
                                                                         class="single-image image-loading" 
                                                                         onclick="showFullImage('${pageContext.request.contextPath}/${complaint.images[0].imagePath}', 'Hình ảnh khiếu nại', 1, 1)"
                                                                         onload="this.classList.remove('image-loading')"
                                                                         onerror="handleImageError(this)">
                                                                    <div class="zoom-hint">
                                                                        <i class="fas fa-search-plus me-1"></i>
                                                                        Nhấp để phóng to
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <!-- Hiển thị nhiều ảnh dạng grid -->
                                                            <div class="images-grid">
                                                                <c:forEach var="image" items="${complaint.images}" varStatus="status">
                                                                    <div class="image-item">
                                                                        <img src="${pageContext.request.contextPath}/${image.imagePath}" 
                                                                             alt="Hình ảnh khiếu nại ${status.index + 1}" 
                                                                             class="complaint-image image-loading"
                                                                             onclick="showFullImage('${pageContext.request.contextPath}/${image.imagePath}', 'Hình ảnh khiếu nại ${status.index + 1}', ${status.index + 1}, ${complaint.images.size()})"
                                                                             onload="this.classList.remove('image-loading')"
                                                                             onerror="handleImageError(this)">
                                                                        <div class="image-overlay">
                                                                            <i class="fas fa-search-plus me-1"></i>
                                                                            Ảnh ${status.index + 1}/${complaint.images.size()}
                                                                        </div>
                                                                        <div class="zoom-hint">
                                                                            <i class="fas fa-expand me-1"></i>
                                                                            Xem phóng to
                                                                        </div>
                                                                    </div>
                                                                </c:forEach>
                                                            </div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                    
                                                    <div class="text-center mt-3">
                                                        <small class="text-muted">
                                                            <i class="fas fa-info-circle me-1"></i>
                                                            Nhấp vào ảnh để xem phóng to và tải xuống
                                                        </small>
                                                    </div>
                                                </div>
                                            </c:when>
                                            <c:when test="${not empty complaint.image}">
                                                <!-- Fallback cho ảnh đơn lẻ -->
                                                <h6 class="fw-bold mb-3">
                                                    <i class="fas fa-image me-2 text-primary"></i>
                                                    Hình ảnh đính kèm:
                                                </h6>
                                                <div class="images-gallery">
                                                    <div class="images-count">
                                                        <i class="fas fa-camera"></i>
                                                        <strong>1</strong> hình ảnh được đính kèm
                                                    </div>
                                                    <div class="single-image-container">
                                                        <div style="position: relative; display: inline-block;">
                                                            <img src="${pageContext.request.contextPath}/${complaint.image}" 
                                                                 alt="Hình ảnh khiếu nại" 
                                                                 class="single-image"
                                                                 onclick="showFullImage('${pageContext.request.contextPath}/${complaint.image}', 'Hình ảnh khiếu nại', 1, 1)"
                                                                 onerror="handleImageError(this)">
                                                            <div class="zoom-hint">
                                                                <i class="fas fa-search-plus me-1"></i>
                                                                Nhấp để phóng to
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="alert alert-info">
                                                    <i class="fas fa-info-circle me-2"></i>
                                                    Khiếu nại này không có hình ảnh đính kèm.
                                                </div>
                                            </c:otherwise>
                                        </c:choose>

                                        <c:if test="${not empty complaint.responseContent}">
                                            <div class="mb-3">
                                                <h6 class="fw-bold">Phản hồi:</h6>
                                                <div class="response-content">
                                                    ${complaint.responseContent}
                                                </div>
                                                <small class="text-muted">
                                                    Phản hồi lúc: <fmt:formatDate value="${complaint.dateResolved}" pattern="dd/MM/yyyy HH:mm" />
                                                </small>
                                            </div>
                                        </c:if>

                                        <div class="d-flex justify-content-between">
                                            <small class="text-muted">Ngày tạo: <fmt:formatDate value="${complaint.dateCreated}" pattern="dd/MM/yyyy HH:mm" /></small>
                                            <c:if test="${not empty complaint.dateResolved}">
                                                <small class="text-muted">Ngày giải quyết: <fmt:formatDate value="${complaint.dateResolved}" pattern="dd/MM/yyyy HH:mm" /></small>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="col-md-4">
                                <!-- Thông tin liên hệ -->
                                <div class="card mb-3">
                                    <div class="card-header bg-info text-white">
                                        <h5 class="mb-0"><i class="fas fa-phone-alt me-2"></i>Liên hệ nhanh</h5>
                                    </div>
                                    <div class="card-body">
                                        <div class="d-grid gap-2">
                                            <a href="tel:${userProfile.phoneNumber}" class="btn btn-outline-primary">
                                                <i class="fas fa-phone-alt me-2"></i>Gọi điện: ${userProfile.phoneNumber}
                                            </a>
                                        </div>
                                    </div>
                                </div>

                                <!-- Thông tin bổ sung -->
                                <div class="card mt-3">
                                    <div class="card-header">
                                        <h5 class="mb-0">Thông tin bổ sung</h5>
                                    </div>
                                    <div class="card-body">
                                        <p><strong>ID Khiếu nại:</strong> #${complaint.complaintID}</p>
                                        <p><strong>ID Tài khoản:</strong> #${complaint.accountID}</p>
                                        <p><strong>Mã đơn hàng:</strong> #${complaint.maHD}</p>
                                        <p><strong>Số lượng ảnh:</strong> 
                                            <span class="badge bg-secondary">
                                                ${not empty complaint.images ? complaint.images.size() : (not empty complaint.image ? '1' : '0')}
                                            </span>
                                        </p>
                                        <p><strong>Thời gian tạo:</strong> <fmt:formatDate value="${complaint.dateCreated}" pattern="dd/MM/yyyy HH:mm" /></p>
                                        <c:if test="${not empty complaint.dateResolved}">
                                            <p><strong>Thời gian giải quyết:</strong> <fmt:formatDate value="${complaint.dateResolved}" pattern="dd/MM/yyyy HH:mm" /></p>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </main>
                </div>
            </div>
        </div>

        <!-- Modal xem ảnh phóng to - HOÀN CHỈNH -->
        <div class="modal fade image-modal" id="imageModal" tabindex="-1" aria-labelledby="imageModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="imageModalLabel">Xem ảnh</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <img id="modalImage" src="" alt="Ảnh phóng to" class="img-fluid">
                        <div id="imageInfo" class="image-info"></div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                            <i class="fas fa-times me-2"></i>Đóng
                        </button>
                        <a id="downloadImageBtn" href="" download class="btn btn-primary">
                            <i class="fas fa-download me-2"></i>Tải xuống
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            // Hàm hiển thị ảnh phóng to
            function showFullImage(src, title, currentIndex, totalImages) {
                console.log('🔍 Mở modal với ảnh:', src);
                
                const modal = document.getElementById('imageModal');
                const modalImage = document.getElementById('modalImage');
                const modalTitle = document.getElementById('imageModalLabel');
                const imageInfo = document.getElementById('imageInfo');
                const downloadBtn = document.getElementById('downloadImageBtn');
                
                modalImage.src = src;
                modalTitle.textContent = title;
                imageInfo.textContent = totalImages > 1 ? `${currentIndex} / ${totalImages}` : '';
                downloadBtn.href = src;
                
                const bootstrapModal = new bootstrap.Modal(modal);
                bootstrapModal.show();
            }
            
            // Xử lý lỗi ảnh
            function handleImageError(img) {
                console.log('❌ Lỗi load ảnh:', img.src);
                img.classList.remove('image-loading');
                img.src = '${pageContext.request.contextPath}/assets/images/no-image.png';
                img.alt = 'Không thể tải ảnh';
                img.style.opacity = '0.6';
                img.style.filter = 'grayscale(100%)';
            }

            document.addEventListener('DOMContentLoaded', function() {
                console.log('=== COMPLAINT DETAIL PAGE DEBUG ===');
                
                // Debug thông tin complaint
                const complaintImages = document.querySelectorAll('.complaint-image, .single-image');
                console.log('📷 Số lượng ảnh trên trang:', complaintImages.length);
                
                complaintImages.forEach((img, index) => {
                    console.log(`📸 Ảnh ${index + 1}:`, img.src);
                    
                    img.addEventListener('load', function() {
                        console.log(`✅ Ảnh ${index + 1} đã load thành công`);
                        this.classList.remove('image-loading');
                    });
                    
                    img.addEventListener('error', function() {
                        console.log(`❌ Lỗi load ảnh ${index + 1}:`, img.src);
                        handleImageError(this);
                    });
                });
                
                // Xử lý keyboard navigation trong modal
                document.addEventListener('keydown', function(e) {
                    const modal = document.getElementById('imageModal');
                    if (modal.classList.contains('show')) {
                        if (e.key === 'Escape') {
                            bootstrap.Modal.getInstance(modal).hide();
                        }
                    }
                });
                
                console.log('=== END DEBUG ===');
            });
        </script>
    </body>
</html>
