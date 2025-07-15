<%-- 
    Document   : blog-detail
    Created on : July 8, 2025
    Author     : Staff
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

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
    <!-- Staff Blog Detail CSS -->
    <link href="${pageContext.request.contextPath}/css/staff-blog-detail.css" rel="stylesheet">
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
                        <div class="breadcrumb-nav">
                            <a href="${pageContext.request.contextPath}/staff/blogs" class="breadcrumb-link">
                                <i class="fas fa-blog"></i> Danh sách Blog
                            </a>
                            <i class="fas fa-chevron-right"></i>
                            <span class="current-page">Chi tiết Blog</span>
                        </div>
                        <h1 class="page-title">
                            <i class="fas fa-eye"></i>
                            Chi tiết Blog
                        </h1>
                    </div>
                    <div class="col-md-4 text-end">
                        <div class="action-buttons">
                            <a href="${pageContext.request.contextPath}/staff/blogs" class="btn btn-secondary">
                                <i class="fas fa-arrow-left"></i> Quay lại
                            </a>
                        </div>
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
            
            <!-- Blog Content -->
            <c:if test="${not empty blog}">
                <div class="blog-detail-container">
                    <div class="row">
                        <!-- Main Content -->
                        <div class="col-lg-8">
                            <div class="blog-content-card">
                                <!-- Blog Header -->
                                <div class="blog-header">
                                    <div class="blog-meta">
                                        <div class="meta-item">
                                            <i class="fas fa-user"></i>
                                            <span>Tác giả: ${authorName}</span>
                                        </div>
                                        <div class="meta-item">
                                            <i class="fas fa-clock"></i>
                                            <span>
                                                <fmt:formatDate value="${blog.dateCreated}" pattern="dd/MM/yyyy HH:mm"/>
                                            </span>
                                        </div>
                                        <div class="meta-item">
                                            <span class="status-badge status-${fn:toLowerCase(blog.blogStatus)}">
                                                ${blog.blogStatus}
                                            </span>
                                        </div>
                                    </div>
                                    
                                    <h1 class="blog-title">${blog.title}</h1>
                                    
                                    <c:if test="${blog.blogStatus == 'Rejected' && not empty blog.note}">
                                        <div class="alert alert-danger mt-3">
                                            <strong>Lý do từ chối:</strong>
                                            <div>${fn:escapeXml(blog.note)}</div>
                                        </div>
                                    </c:if>
                                </div>
                                
                                <!-- Main Image -->
                                <c:if test="${not empty blog.mainImage}">
                                    <div class="main-image-container">
                                        <img src="${pageContext.request.contextPath}/img/blog/${blog.mainImage}" 
                                             alt="${blog.title}" class="main-image">
                                    </div>
                                </c:if>
                                
                                <!-- Blog Content -->
                                <div class="blog-text-content">
                                    <p>${fn:replace(blog.content, newline, '<br>')}</p>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Sidebar -->
                        <div class="col-lg-4">
                            <!-- Blog Info Card -->
                            <div class="info-card">
                                <h5 class="info-card-title">
                                    <i class="fas fa-info-circle"></i>
                                    Thông tin Blog
                                </h5>
                                <div class="info-list">
                                    <div class="info-item">
                                        <label>ID Blog:</label>
                                        <span>${blog.blogID}</span>
                                    </div>
                                    <div class="info-item">
                                        <label>Trạng thái:</label>
                                        <span class="status-badge status-${fn:toLowerCase(blog.blogStatus)}">
                                            ${blog.blogStatus}
                                        </span>
                                    </div>
                                    <div class="info-item">
                                        <label>Ngày tạo:</label>
                                        <span>
                                            <fmt:formatDate value="${blog.dateCreated}" pattern="dd/MM/yyyy HH:mm"/>
                                        </span>
                                    </div>
                                    <div class="info-item">
                                        <label>Số lượng ảnh:</label>
                                        <span>${fn:length(blog.blogImages)} ảnh</span>
                                    </div>
                                    <div class="info-item">
                                        <label>Số ký tự:</label>
                                        <span>${fn:length(blog.content)} ký tự</span>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Image Gallery Card -->
                            <c:if test="${not empty blog.blogImages}">
                                <div class="info-card">
                                    <h5 class="info-card-title">
                                        <i class="fas fa-images"></i>
                                        Thư viện ảnh (${fn:length(blog.blogImages)})
                                    </h5>
                                    <div class="image-gallery">
                                        <c:forEach var="image" items="${blog.blogImages}">
                                            <div class="gallery-item ${image.main ? 'main-image' : ''}">
                                                <img src="${pageContext.request.contextPath}/img/blog/${image.image}" 
                                                     alt="Blog image" 
                                                     onclick="openImageModal('${pageContext.request.contextPath}/img/blog/${image.image}', '${image.image}')">
                                                <c:if test="${image.main}">
                                                    <div class="main-badge">
                                                        <i class="fas fa-star"></i>
                                                        Ảnh chính
                                                    </div>
                                                </c:if>
                                                <div class="image-overlay">
                                                    <button type="button" class="btn btn-sm btn-light" 
                                                            onclick="openImageModal('${pageContext.request.contextPath}/img/blog/${image.image}', '${image.image}')">
                                                        <i class="fas fa-expand"></i>
                                                    </button>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>
                            </c:if>
                            
                            <!-- Action Card -->
                            <div class="info-card">
                                <h5 class="info-card-title">
                                    <i class="fas fa-cogs"></i>
                                    Thao tác
                                </h5>
                                <div class="action-list">
                                    <a href="${pageContext.request.contextPath}/staff/blogs" 
                                       class="btn btn-outline-primary btn-block">
                                        <i class="fas fa-list"></i> Quay lại danh sách blog
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </c:if>
            
            <c:if test="${empty blog}">
                <div class="empty-state">
                    <i class="fas fa-exclamation-triangle fa-4x text-muted"></i>
                    <h3>Không tìm thấy blog</h3>
                    <p class="text-muted">Blog bạn đang tìm kiếm không tồn tại hoặc đã bị xóa</p>
                    <a href="${pageContext.request.contextPath}/staff/blogs" class="btn btn-primary">
                        <i class="fas fa-arrow-left"></i> Quay lại danh sách
                    </a>
                </div>
            </c:if>
        </div>
    </div>
    
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Staff Blog Detail JS -->
    <script src="${pageContext.request.contextPath}/js/staff-blog-detail.js"></script>
</body>
</html>
