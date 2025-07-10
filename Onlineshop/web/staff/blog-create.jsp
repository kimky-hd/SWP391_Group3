<%-- 
    Document   : blog-create
    Created on : July 8, 2025
    Author     : Staff
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle} - Quản lý Blog</title>
    
    <!-- Bootstrap CSS -->
    <link href="${pageContext.request.contextPath}/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Staff Blog Create CSS -->
    <link href="${pageContext.request.contextPath}/css/staff-blog-create.css" rel="stylesheet">
</head>
<body>
    <!-- Include Top Bar và Sidebar -->
    <jsp:include page="../manager_topbarsidebar.jsp" />
    
    <div class="main-content">
        <div class="container-fluid">
            <!-- Header Section -->
            <div class="page-header">
                <div class="row align-items-center">
                    <div class="col-md-8">
                        <h1 class="page-title">
                            <i class="fas fa-plus-circle"></i>
                            ${pageTitle}
                        </h1>
                        <p class="page-subtitle">Tạo một bài viết blog mới để chia sẻ với khách hàng</p>
                    </div>
                    <div class="col-md-4 text-end">
                        <a href="${pageContext.request.contextPath}/staff/blogs" class="btn btn-outline-secondary">
                            <i class="fas fa-arrow-left"></i> Quay lại danh sách
                        </a>
                    </div>
                </div>
            </div>
            
            <!-- Messages -->
            <c:if test="${not empty sessionScope.successMessage}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle"></i> ${sessionScope.successMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <c:remove var="successMessage" scope="session"/>
            </c:if>
            
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-circle"></i> ${errorMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            
            <!-- Create Form -->
            <div class="create-form-section">
                <form action="${pageContext.request.contextPath}/staff/blog/create" method="post" 
                      enctype="multipart/form-data" class="blog-form" id="blogCreateForm">
                    
                    <div class="row">
                        <!-- Left Column - Main Content -->
                        <div class="col-lg-8">
                            <div class="form-card">
                                <h5 class="form-card-title">
                                    <i class="fas fa-edit"></i> Thông tin bài viết
                                </h5>
                                
                                <!-- Title -->
                                <div class="mb-4">
                                    <label for="title" class="form-label required">Tiêu đề blog</label>
                                    <input type="text" class="form-control" id="title" name="title" 
                                           value="${title}" required maxlength="200"
                                           placeholder="Nhập tiêu đề hấp dẫn cho blog của bạn...">
                                    <div class="form-text">
                                        <span id="titleCounter">0</span>/200 ký tự
                                    </div>
                                </div>
                                
                                <!-- Content -->
                                <div class="mb-4">
                                    <label for="content" class="form-label required">Nội dung blog</label>
                                    <textarea class="form-control" id="content" name="content" 
                                              rows="12" required maxlength="5000"
                                              placeholder="Viết nội dung blog của bạn tại đây. Hãy chia sẻ những thông tin hữu ích và thú vị với khách hàng...">${content}</textarea>
                                    <div class="form-text">
                                        <span id="contentCounter">0</span>/5000 ký tự
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Right Column - Images -->
                        <div class="col-lg-4">
                            <div class="form-card">
                                <h5 class="form-card-title">
                                    <i class="fas fa-images"></i> Hình ảnh blog
                                </h5>
                                
                                <!-- Image Upload -->
                                <div class="mb-4">
                                    <label for="images" class="form-label">Tải lên hình ảnh</label>
                                    <div class="image-upload-area" id="imageUploadArea">
                                        <div class="upload-content">
                                            <i class="fas fa-cloud-upload-alt"></i>
                                            <h6>Kéo thả ảnh vào đây</h6>
                                            <p>hoặc</p>
                                            <button type="button" class="btn btn-outline-primary btn-sm" onclick="document.getElementById('images').click()">
                                                Chọn file
                                            </button>
                                            <input type="file" class="form-control" id="images" name="images" 
                                                   multiple accept="image/*" style="display: none;">
                                        </div>
                                    </div>
                                    <div class="form-text">
                                        Chọn tối đa 10 ảnh. Định dạng: JPG, PNG, GIF (tối đa 10MB mỗi ảnh)
                                    </div>
                                </div>
                                
                                <!-- Image Preview -->
                                <div id="imagePreview" class="image-preview-container" style="display: none;">
                                    <h6>Xem trước ảnh:</h6>
                                    <div id="previewGrid" class="preview-grid"></div>
                                    <button type="button" class="btn btn-outline-danger btn-sm mt-2" onclick="clearImages()">
                                        <i class="fas fa-trash"></i> Xóa tất cả ảnh
                                    </button>
                                </div>
                                
                                <!-- Blog Status Info -->
                                <div class="status-info">
                                    <div class="info-item">
                                        <i class="fas fa-info-circle text-primary"></i>
                                        <div>
                                            <strong>Trạng thái:</strong>
                                            <span class="badge bg-warning">Pending</span>
                                            <small class="d-block text-muted">
                                                Blog sẽ được đặt trạng thái "Pending" và chờ duyệt
                                            </small>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Action Buttons -->
                    <div class="action-buttons">
                        <div class="d-flex justify-content-between">
                            <a href="${pageContext.request.contextPath}/staff/blogs" class="btn btn-outline-secondary">
                                <i class="fas fa-times"></i> Hủy
                            </a>
                            <div>
                                <button type="button" class="btn btn-outline-primary me-2" onclick="previewBlog()">
                                    <i class="fas fa-eye"></i> Xem trước
                                </button>
                                <button type="submit" class="btn btn-success" id="submitBtn">
                                    <i class="fas fa-save"></i> Lưu Blog
                                </button>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <!-- Preview Modal -->
    <div class="modal fade" id="previewModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="fas fa-eye"></i> Xem trước blog
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div id="previewContent">
                        <!-- Preview content will be inserted here -->
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                    <button type="button" class="btn btn-success" onclick="submitForm()">
                        <i class="fas fa-save"></i> Lưu Blog
                    </button>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Staff Blog Create JS -->
    <script src="${pageContext.request.contextPath}/js/staff-blog-create.js"></script>
</body>
</html>
