<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Blog Detail - Manager Portal</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/css/manager-blog-detail.css" rel="stylesheet">
</head>
<body>
    <div class="wrapper">
        <!-- Include Sidebar -->
        <jsp:include page="../manager_topbarsidebar.jsp" />
        
        <div class="main-content">
            <div class="container-fluid p-4">
                <!-- Header -->
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h2 class="mb-1">Chi tiết Blog</h2>
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/manager/blogs">Quản lý Blog</a></li>
                                <li class="breadcrumb-item active">Chi tiết Blog</li>
                            </ol>
                        </nav>
                    </div>
                    <a href="${pageContext.request.contextPath}/manager/blogs" class="btn btn-outline-secondary">
                        <i class="fas fa-arrow-left me-2"></i>Quay lại
                    </a>
                </div>

                <!-- Error/Success Messages -->
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-circle me-2"></i>
                        ${errorMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <!-- Blog Detail Card -->
                <div class="card shadow-sm">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">
                            <i class="fas fa-blog me-2"></i>Thông tin Blog
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <!-- Left Column - Content -->
                            <div class="col-lg-8">
                                <!-- Blog Title -->
                                <div class="mb-4">
                                    <h3 class="blog-title">${fn:escapeXml(blog.title)}</h3>
                                    <div class="blog-meta">
                                        <span class="badge bg-${blog.blogStatus == 'Pending' ? 'warning' : 
                                                                blog.blogStatus == 'Approved' ? 'success' : 'danger'} me-2">
                                            ${blog.blogStatus}
                                        </span>
                                        <small class="text-muted">
                                            <i class="fas fa-calendar-alt me-1"></i>
                                            <fmt:formatDate value="${blog.dateCreated}" pattern="dd/MM/yyyy HH:mm"/>
                                        </small>
                                    </div>
                                </div>

                                <!-- Blog Content -->
                                <div class="blog-content">
                                    <h5>Nội dung:</h5>
                                    <div class="content-text">
                                        ${fn:replace(fn:escapeXml(blog.content), newLineChar, "<br/>")}
                                    </div>
                                </div>

                                <!-- Note Section (if rejected) -->
                                <c:if test="${blog.blogStatus == 'Rejected' && not empty blog.note}">
                                    <div class="reject-note mt-4">
                                        <h5 class="text-danger">Lý do từ chối:</h5>
                                        <div class="alert alert-danger">
                                            <i class="fas fa-exclamation-triangle me-2"></i>
                                            ${fn:escapeXml(blog.note)}
                                        </div>
                                    </div>
                                </c:if>
                            </div>

                            <!-- Right Column - Images & Actions -->
                            <div class="col-lg-4">
                                <!-- Blog Images -->
                                <div class="card mb-4">
                                    <div class="card-header">
                                        <h6 class="mb-0">
                                            <i class="fas fa-images me-2"></i>Hình ảnh Blog
                                        </h6>
                                    </div>
                                    <div class="card-body">
                                        <c:choose>
                                            <c:when test="${not empty images}">
                                                <div class="blog-images">
                                                    <c:forEach var="img" items="${images}">
                                                        <div class="image-item">
                                                            <img src="${pageContext.request.contextPath}/img/blog/${img.image}" 
                                                                 alt="Blog Image" class="img-thumbnail mb-2">
                                                            <c:if test="${img.main}">
                                                                <span class="badge bg-primary">Ảnh chính</span>
                                                            </c:if>
                                                        </div>
                                                    </c:forEach>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="text-center text-muted py-3">
                                                    <i class="fas fa-image fa-3x mb-2"></i>
                                                    <p>Không có hình ảnh</p>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>

                                <!-- Action Buttons -->
                                <c:if test="${blog.blogStatus == 'Pending'}">
                                    <div class="card">
                                        <div class="card-header">
                                            <h6 class="mb-0">
                                                <i class="fas fa-tasks me-2"></i>Hành động
                                            </h6>
                                        </div>
                                        <div class="card-body">
                                            <div class="d-grid gap-2">
                                                <button type="button" class="btn btn-success" onclick="acceptBlog(${blog.blogID})">
                                                    <i class="fas fa-check me-2"></i>Phê duyệt Blog
                                                </button>
                                                <button type="button" class="btn btn-danger" onclick="rejectBlog(${blog.blogID})">
                                                    <i class="fas fa-times me-2"></i>Từ chối Blog
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Reject Modal -->
    <div class="modal fade" id="rejectModal" tabindex="-1" aria-labelledby="rejectModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-danger text-white">
                    <h5 class="modal-title" id="rejectModalLabel">
                        <i class="fas fa-times-circle me-2"></i>Từ chối Blog
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <form id="rejectForm" action="${pageContext.request.contextPath}/manager/blog/action" method="post">
                    <input type="hidden" name="action" value="reject">
                    <input type="hidden" name="blogId" id="rejectBlogId">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label for="rejectNote" class="form-label">Lý do từ chối *</label>
                            <textarea class="form-control" id="rejectNote" name="note" rows="4" 
                                      placeholder="Vui lòng nhập lý do từ chối blog này..." required></textarea>
                            <div class="form-text">Lý do từ chối sẽ được gửi cho tác giả để họ có thể chỉnh sửa.</div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-danger">
                            <i class="fas fa-times"></i> Từ chối Blog
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Accept Form (Hidden) -->
    <form id="acceptForm" action="${pageContext.request.contextPath}/manager/blog/action" method="post" style="display: none;">
        <input type="hidden" name="action" value="accept">
        <input type="hidden" name="blogId" id="acceptBlogId">
        <input type="hidden" name="note" value="">
    </form>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Accept blog function
        function acceptBlog(blogId) {
            if (confirm('Bạn có chắc chắn muốn phê duyệt blog này?')) {
                document.getElementById('acceptBlogId').value = blogId;
                document.getElementById('acceptForm').submit();
            }
        }
        
        // Reject blog function
        function rejectBlog(blogId) {
            document.getElementById('rejectBlogId').value = blogId;
            document.getElementById('rejectNote').value = '';
            new bootstrap.Modal(document.getElementById('rejectModal')).show();
        }
    </script>
</body>
</html>
