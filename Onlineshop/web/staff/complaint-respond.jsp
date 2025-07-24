<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Phản hồi khiếu nại</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        /* Status badges */
        .status-processing { background-color: #b8daff; color: #004085; }
        .status-resolved { background-color: #c3e6cb; color: #155724; }
        .status-rejected { background-color: #f5c6cb; color: #721c24; }
        .badge { font-size: 0.9rem; padding: 0.5rem; }
        
        /* ===== STYLES CHO GALLERY ẢNH - RESPONSIVE ===== */
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
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 15px;
            margin-top: 15px;
        }
        
        .image-item {
            position: relative;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
            background: white;
            border: 2px solid transparent;
        }
        
        .image-item:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 20px rgba(0,0,0,0.15);
            border-color: #007bff;
        }
        
        .complaint-image {
            width: 100%;
            height: 180px;
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
            padding: 10px;
            font-size: 0.85rem;
            text-align: center;
            font-weight: 500;
        }
        
        /* Container cho ảnh đơn lẻ */
        .single-image-container {
            text-align: center;
            margin: 20px 0;
            max-width: 450px;
            margin-left: auto;
            margin-right: auto;
        }
        
        .single-image {
            max-width: 100%;
            height: auto;
            max-height: 350px;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            cursor: pointer;
            transition: all 0.3s ease;
            border: 2px solid transparent;
        }
        
        .single-image:hover {
            transform: scale(1.02);
            box-shadow: 0 6px 18px rgba(0,0,0,0.15);
            border-color: #007bff;
        }
        
        /* Modal styles cho xem ảnh phóng to */
        .image-modal .modal-dialog {
            max-width: 90vw;
            max-height: 90vh;
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
            max-height: 75vh;
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
        
        /* Zoom hint */
        .zoom-hint {
            position: absolute;
            bottom: 15px;
            left: 50%;
            transform: translateX(-50%);
            background: rgba(0,0,0,0.7);
            color: white;
            padding: 6px 12px;
            border-radius: 15px;
            font-size: 0.8rem;
            opacity: 0;
            transition: opacity 0.3s ease;
        }
        
        .image-item:hover .zoom-hint,
        .single-image-container:hover .zoom-hint {
            opacity: 1;
        }
        
        /* Form styling */
        .complaint-content {
            background-color: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid #6c757d;
        }
        
        .user-info {
            padding: 15px;
            border-left: 3px solid #6c757d;
            background-color: #f8f9fa;
            margin-bottom: 20px;
            border-radius: 8px;
        }
        
        .main-content {
            margin-left: 250px;
            padding: 20px;
            transition: margin-left 0.3s;
        }
        
        /* Form response styling */
        .response-form {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border-radius: 12px;
            padding: 20px;
            border: 1px solid #dee2e6;
        }
        
        .form-control:focus {
            border-color: #007bff;
            box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25);
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #007bff 0%, #0056b3 100%);
            border: none;
            padding: 10px 25px;
            font-weight: 500;
        }
        
        .btn-primary:hover {
            background: linear-gradient(135deg, #0056b3 0%, #004085 100%);
            transform: translateY(-1px);
        }
        
        /* Template buttons */
        .template-btn {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            border: none;
            color: white;
            padding: 8px 15px;
            border-radius: 6px;
            font-size: 0.85rem;
            margin: 2px;
            transition: all 0.3s ease;
        }
        
        .template-btn:hover {
            background: linear-gradient(135deg, #20c997 0%, #17a2b8 100%);
            transform: translateY(-1px);
            color: white;
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .main-content {
                margin-left: 0;
                padding: 15px;
            }
            
            .images-grid {
                grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
                gap: 10px;
            }
            
            .complaint-image {
                height: 150px;
            }
            
            .single-image {
                max-height: 250px;
            }
            
            .image-modal .modal-dialog {
                margin: 0.5rem;
                max-width: calc(100vw - 1rem);
            }
        }
        
        @media (max-width: 576px) {
            .images-grid {
                grid-template-columns: repeat(auto-fill, minmax(120px, 1fr));
                gap: 8px;
            }
            
            .complaint-image {
                height: 120px;
            }
        }
    </style>
</head>
<body>

<jsp:include page="../manager_topbarsidebar.jsp" />

<div class="main-content">
    <div class="container-fluid">
        <div class="d-flex justify-content-between align-items-center pt-3 pb-2 mb-3 border-bottom">
            <h1 class="h2">
                <i class="fas fa-reply me-2 text-primary"></i>
                Phản hồi khiếu nại #${complaint.complaintID}
            </h1>
            <div class="btn-toolbar">
                <div class="btn-group">
                    <a href="${pageContext.request.contextPath}/staff/complaints" class="btn btn-sm btn-outline-secondary">
                        <i class="fas fa-arrow-left"></i> Quay lại danh sách
                    </a>
                    <a href="${pageContext.request.contextPath}/staff/complaints?action=view&id=${complaint.complaintID}" class="btn btn-sm btn-info">
                        <i class="fas fa-eye"></i> Xem chi tiết
                    </a>
                </div>
            </div>
        </div>

        <!-- Thông báo -->
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-triangle me-2"></i>
                ${errorMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <c:if test="${not empty successMessage}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle me-2"></i>
                ${successMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <div class="row">
            <!-- PHẦN TRÁI -->
            <div class="col-lg-8">
                <!-- Thông tin khiếu nại -->
                <div class="card mb-4">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h5 class="mb-0">
                            <i class="fas fa-file-alt me-2"></i>
                            ${complaint.title}
                        </h5>
                        <span class="badge ${complaint.status eq 'Đang xử lý' ? 'status-processing' : 
                                             complaint.status eq 'Đã xử lý' ? 'status-resolved' : 'status-rejected'}">
                            ${complaint.status}
                        </span>
                    </div>
                    <div class="card-body">
                        <div class="user-info mb-4">
                            <div class="d-flex align-items-center mb-2">
                                <i class="fas fa-user-circle fa-2x me-2 text-secondary"></i>
                                <h6 class="fw-bold mb-0">Người gửi khiếu nại</h6>
                            </div>
                            <div class="row">
                                <div class="col-md-6">
                                    <p><strong>Họ tên:</strong> ${userProfile.fullName}</p>
                                    <p><strong>Email:</strong> ${userProfile.email}</p>
                                </div>
                                <div class="col-md-6">
                                    <p><strong>SĐT:</strong> ${userProfile.phoneNumber}</p>
                                    <p><strong>Địa chỉ:</strong> ${userProfile.address}</p>
                                </div>
                            </div>
                        </div>

                        <div class="mb-3">
                            <h6 class="fw-bold">
                                <i class="fas fa-comment-alt me-2 text-primary"></i>
                                Nội dung khiếu nại:
                            </h6>
                            <div class="complaint-content">${complaint.content}</div>
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

                        <small class="text-muted">
                            <i class="fas fa-calendar-alt me-1"></i>
                            Ngày tạo: <fmt:formatDate value="${complaint.dateCreated}" pattern="dd/MM/yyyy HH:mm" />
                        </small>
                    </div>
                </div>

                <!-- Form phản hồi -->
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">
                            <i class="fas fa-reply me-2"></i>
                            Phản hồi khiếu nại
                        </h5>
                    </div>
                    <div class="card-body response-form">
                        <form action="${pageContext.request.contextPath}/staff/complaints" method="post">
                            <input type="hidden" name="action" value="respond">
                            <input type="hidden" name="id" value="${complaint.complaintID}">

                            <!-- Template phản hồi nhanh -->
                            <div class="mb-3">
                                <label class="form-label fw-bold">
                                    <i class="fas fa-magic me-2"></i>
                                    Mẫu phản hồi nhanh:
                                </label>
                                <div class="d-flex flex-wrap gap-2">
                                    <button type="button" class="template-btn" onclick="insertTemplate('Chúng tôi đã tiếp nhận khiếu nại của quý khách và đang tiến hành xem xét. Chúng tôi sẽ phản hồi trong vòng 24-48 giờ.')">
                                        Đã tiếp nhận
                                    </button>
                                    <button type="button" class="template-btn" onclick="insertTemplate('Chúng tôi xin lỗi về sự bất tiện này. Vấn đề đã được giải quyết và chúng tôi sẽ liên hệ với quý khách để hỗ trợ thêm.')">
                                        Đã giải quyết
                                    </button>
                                    <button type="button" class="template-btn" onclick="insertTemplate('Chúng tôi cần thêm thông tin để xử lý khiếu nại. Vui lòng liên hệ hotline để được hỗ trợ trực tiếp.')">
                                        Cần thêm thông tin
                                    </button>
                                    <button type="button" class="template-btn" onclick="insertTemplate('Sau khi xem xét kỹ lưỡng, chúng tôi rất tiếc phải từ chối khiếu nại này vì không đủ căn cứ. Quý khách có thể liên hệ để được tư vấn thêm.')">
                                        Từ chối
                                    </button>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label for="responseContent" class="form-label fw-bold">
                                    <i class="fas fa-pen me-2"></i>
                                    Nội dung phản hồi
                                </label>
                                <textarea name="responseContent" id="responseContent" rows="6" class="form-control" 
                                          placeholder="Nhập nội dung phản hồi cho khách hàng..." required>${complaint.responseContent}</textarea>
                                <div class="form-text">
                                    <i class="fas fa-lightbulb me-1"></i>
                                    Hãy viết phản hồi một cách rõ ràng, lịch sự và chuyên nghiệp.
                                </div>
                            </div>

                            <div class="mb-3">
                                <label for="status" class="form-label fw-bold">
                                    <i class="fas fa-flag me-2"></i>
                                    Trạng thái xử lý
                                </label>
                                <select name="status" id="status" class="form-select">
                                    <option value="Đang xử lý" ${complaint.status eq 'Đang xử lý' ? 'selected' : ''}>
                                        <i class="fas fa-clock"></i> Đang xử lý
                                    </option>
                                    <option value="Đã xử lý" ${complaint.status eq 'Đã xử lý' ? 'selected' : ''}>
                                        <i class="fas fa-check"></i> Đã xử lý
                                    </option>
                                    <option value="Từ chối" ${complaint.status eq 'Từ chối' ? 'selected' : ''}>
                                        <i class="fas fa-times"></i> Từ chối
                                    </option>
                                </select>
                            </div>

                            <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                <a href="${pageContext.request.contextPath}/staff/complaints?action=view&id=${complaint.complaintID}" 
                                   class="btn btn-secondary me-md-2">
                                    <i class="fas fa-times me-2"></i>Hủy
                                </a>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-paper-plane me-2"></i>Gửi phản hồi
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <!-- PHẦN PHẢI -->
            <div class="col-lg-4">
                <!-- Liên hệ -->
                <div class="card mb-3">
                    <div class="card-header bg-info text-white">
                        <h5 class="mb-0"><i class="fas fa-phone-alt me-2"></i>Liên hệ nhanh</h5>
                    </div>
                    <div class="card-body">
                        <div class="d-grid gap-2">
                            <a href="tel:${userProfile.phoneNumber}" class="btn btn-outline-primary">
                                <i class="fas fa-phone-alt me-2"></i>Gọi: ${userProfile.phoneNumber}
                            </a>
                            <a href="mailto:${userProfile.email}" class="btn btn-outline-secondary">
                                <i class="fas fa-envelope me-2"></i>Email: ${userProfile.email}
                            </a>
                        </div>
                    </div>
                </div>

                <!-- Thông tin bổ sung -->
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0">
                            <i class="fas fa-info-circle me-2"></i>
                            Thông tin bổ sung
                        </h5>
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
                        <p><strong>Thời gian tạo:</strong> 
                            <fmt:formatDate value="${complaint.dateCreated}" pattern="dd/MM/yyyy HH:mm" />
                        </p>
                    </div>
                </div>
            </div>
        </div> <!-- End row -->
    </div>
</div>

<!-- Modal xem ảnh phóng to -->
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
    // Hàm chèn template phản hồi
        // Hàm chèn template phản hồi
    function insertTemplate(text) {
        const textarea = document.getElementById('responseContent');
        textarea.value = text;
        textarea.focus();
        
        // Hiệu ứng highlight
        textarea.style.backgroundColor = '#e3f2fd';
        setTimeout(() => {
            textarea.style.backgroundColor = '';
        }, 1000);
    }
    
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
        console.log('=== COMPLAINT RESPONSE PAGE LOADED ===');
        
        // Xử lý form validation
        const form = document.querySelector('form');
        const responseContent = document.getElementById('responseContent');
        const statusSelect = document.getElementById('status');
        
        form.addEventListener('submit', function(e) {
            if (responseContent.value.trim().length < 10) {
                e.preventDefault();
                alert('Nội dung phản hồi phải có ít nhất 10 ký tự!');
                responseContent.focus();
                return false;
            }
            
            // Xác nhận trước khi gửi
            const status = statusSelect.value;
            const confirmMessage = status === 'Đã xử lý' ? 
                'Bạn có chắc chắn muốn đánh dấu khiếu nại này là ĐÃ XỬ LÝ?' :
                status === 'Từ chối' ?
                'Bạn có chắc chắn muốn TỪ CHỐI khiếu nại này?' :
                'Bạn có chắc chắn muốn gửi phản hồi này?';
                
            if (!confirm(confirmMessage)) {
                e.preventDefault();
                return false;
            }
        });
        
        
        
        // Xử lý ảnh
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
        
        // Keyboard shortcuts
        document.addEventListener('keydown', function(e) {
            // Ctrl + Enter để submit form
            if (e.ctrlKey && e.key === 'Enter') {
                form.submit();
            }
            
            // ESC để đóng modal
            if (e.key === 'Escape') {
                const modal = document.getElementById('imageModal');
                if (modal.classList.contains('show')) {
                    bootstrap.Modal.getInstance(modal).hide();
                }
            }
        });
        
        // Tooltip cho các nút template
        const templateBtns = document.querySelectorAll('.template-btn');
        templateBtns.forEach(btn => {
            btn.setAttribute('title', 'Nhấp để chèn mẫu phản hồi này');
        });
        
        // Character counter cho textarea
        const maxLength = 2000;
        const counter = document.createElement('div');
        counter.className = 'form-text text-end';
        counter.innerHTML = `<small><span id="charCount">0</span>/${maxLength} ký tự</small>`;
        responseContent.parentNode.appendChild(counter);
        
        responseContent.addEventListener('input', function() {
            const count = this.value.length;
            document.getElementById('charCount').textContent = count;
            
            if (count > maxLength * 0.9) {
                counter.style.color = '#dc3545';
            } else if (count > maxLength * 0.8) {
                counter.style.color = '#ffc107';
            } else {
                counter.style.color = '#6c757d';
            }
        });
        
        // Trigger initial count
        responseContent.dispatchEvent(new Event('input'));
        
        console.log('=== COMPLAINT RESPONSE PAGE READY ===');
    });
    
   
</script>

</body>
</html>

