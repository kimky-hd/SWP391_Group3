<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Blog Management - Manager Portal</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/css/manager-blog-list.css" rel="stylesheet">
</head>
<body>
    <div class="wrapper">
        <!-- Include Sidebar -->
        <jsp:include page="../manager_topbarsidebar.jsp" />
        
        <div class="main-content">
            <div class="container-fluid p-4">
                <!-- Page Header -->
                <div class="page-header">
                    <div class="row">
                        <div class="col-md-8">
                            <h2 class="page-title">
                                <i class="fas fa-blog"></i>Quản lý Blog
                            </h2>
                            <p class="page-subtitle">Xem và quản lý tất cả các bài blog trong hệ thống</p>
                        </div>
                        <div class="col-md-4 text-end">
                            <div class="header-stats">
                                <span class="stat-item">
                                    <i class="fas fa-chart-bar"></i>
                                    Tổng: ${totalBlogs} blog
                                </span>
                            </div>
                        </div>
                    </div>
                </div>

               

                <!-- Error/Success Messages -->
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-circle me-2"></i>
                        ${errorMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>
                
                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle me-2"></i>
                        ${successMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <!-- Blog List Section -->
                <div class="blog-list-section">
                    <c:choose>
                        <c:when test="${empty blogs}">
                            <div class="empty-state">
                                <i class="fas fa-blog fa-5x"></i>
                                <h3>Không có blog nào</h3>
                                <p class="text-muted">Hiện tại chưa có blog nào trong hệ thống.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="row">
                                <c:forEach var="blog" items="${blogs}">
                                    <div class="col-lg-4 col-md-6 mb-4">
                                        <div class="blog-card">
                                            <!-- Blog Image -->
                                            <div class="blog-image">
                                                <c:choose>
                                                    <c:when test="${not empty blog.mainImage}">
                                                        <img src="${pageContext.request.contextPath}/img/blog/${blog.mainImage}" alt="Blog Image">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="no-image">
                                                            <i class="fas fa-image"></i>
                                                            <span>Không có ảnh</span>
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                                
                                                <!-- Status Badge -->
                                                <span class="status-badge status-${fn:toLowerCase(blog.blogStatus)}">
                                                    ${blog.blogStatus}
                                                </span>
                                            </div>
                                            
                                            <!-- Blog Content -->
                                            <div class="blog-content">
                                                <h5 class="blog-title">${fn:escapeXml(blog.title)}</h5>
                                                <p class="blog-excerpt">${fn:substring(fn:escapeXml(blog.content), 0, 120)}...</p>
                                                
                                                <div class="blog-meta">
                                                    <small class="text-muted">
                                                        <i class="fas fa-calendar-alt"></i>
                                                        <fmt:formatDate value="${blog.dateCreated}" pattern="dd/MM/yyyy HH:mm"/>
                                                    </small>
                                                </div>
                                                
                                                <!-- Note Section (if rejected) -->
                                                <c:if test="${blog.blogStatus == 'Rejected' && not empty blog.note}">
                                                    <div class="reject-note">
                                                        <strong>Lý do từ chối:</strong>
                                                        <p class="text-danger">${fn:escapeXml(blog.note)}</p>
                                                    </div>
                                                </c:if>
                                                
                                                <!-- Action Buttons -->
                                                <div class="blog-actions">
                                                    <a href="${pageContext.request.contextPath}/manager/blog/detail?id=${blog.blogID}" 
                                                       class="btn btn-outline-primary btn-sm">
                                                        <i class="fas fa-eye"></i> Chi tiết
                                                    </a>
                                                    
                                                    <c:if test="${blog.blogStatus == 'Pending'}">
                                                        <button type="button" class="btn btn-outline-success btn-sm" 
                                                                onclick="acceptBlog(${blog.blogID})">
                                                            <i class="fas fa-check"></i> Duyệt
                                                        </button>
                                                        <button type="button" class="btn btn-outline-danger btn-sm"
                                                                onclick="rejectBlog(${blog.blogID})">
                                                            <i class="fas fa-times"></i> Từ chối
                                                        </button>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>

                            <!-- Pagination -->
                            <c:if test="${totalPages > 1}">
                                <nav aria-label="Blog pagination">
                                    <ul class="pagination justify-content-center">
                                        <c:if test="${currentPage > 1}">
                                            <li class="page-item">
                                                <a class="page-link" href="?page=${currentPage - 1}&keyword=${searchKeyword}&status=${statusFilter}">
                                                    <i class="fas fa-chevron-left"></i> Trước
                                                </a>
                                            </li>
                                        </c:if>
                                        
                                        <c:forEach begin="1" end="${totalPages}" var="pageNum">
                                            <li class="page-item ${pageNum == currentPage ? 'active' : ''}">
                                                <a class="page-link" href="?page=${pageNum}&keyword=${searchKeyword}&status=${statusFilter}">
                                                    ${pageNum}
                                                </a>
                                            </li>
                                        </c:forEach>
                                        
                                        <c:if test="${currentPage < totalPages}">
                                            <li class="page-item">
                                                <a class="page-link" href="?page=${currentPage + 1}&keyword=${searchKeyword}&status=${statusFilter}">
                                                    Sau <i class="fas fa-chevron-right"></i>
                                                </a>
                                            </li>
                                        </c:if>
                                    </ul>
                                </nav>
                            </c:if>
                        </c:otherwise>
                    </c:choose>
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
