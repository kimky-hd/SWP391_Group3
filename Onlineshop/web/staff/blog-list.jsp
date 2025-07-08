<%-- 
    Document   : blog-list
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
    <!-- Staff Blog CSS -->
    <link href="${pageContext.request.contextPath}/css/staff-blog-list.css" rel="stylesheet">
</head>
<body>
    <!-- Include Top Bar và Sidebar -->
    <jsp:include page="../manager_topbarsidebar.jsp" />
    
    <div class="main-content">
        <div class="container-fluid">
            <!-- Header Section -->
            <div class="page-header">
                <div class="row align-items-center">
                    <div class="col-md-6">
                        <h1 class="page-title">
                            <i class="fas fa-blog"></i>
                            ${pageTitle}
                        </h1>
                        <p class="page-subtitle">Quản lý danh sách blog của shop</p>
                    </div>
                    <div class="col-md-6 text-end">
                        <a href="${pageContext.request.contextPath}/staff/blog/create" class="btn btn-primary btn-create">
                            <i class="fas fa-plus"></i> Tạo Blog Mới
                        </a>
                    </div>
                </div>
            </div>
            
            <!-- Search Section -->
            <div class="search-section">
                <div class="row">
                    <div class="col-md-6">
                        <form action="${pageContext.request.contextPath}/staff/blogs" method="get" class="search-form">
                            <input type="hidden" name="action" value="search">
                            <div class="input-group">
                                <input type="text" name="keyword" value="${searchKeyword}" 
                                       class="form-control" placeholder="Tìm kiếm theo tiêu đề blog...">
                                <button type="submit" class="btn btn-outline-primary">
                                    <i class="fas fa-search"></i> Tìm kiếm
                                </button>
                            </div>
                        </form>
                    </div>
                    <div class="col-md-6 text-end">
                        <span class="total-count">Tổng: ${totalBlogs} blog</span>
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
            
            <!-- Blog List -->
            <div class="blog-list-section">
                <c:if test="${empty blogs}">
                    <div class="empty-state">
                        <i class="fas fa-blog fa-4x text-muted"></i>
                        <h3>Chưa có blog nào</h3>
                        <p class="text-muted">Hãy tạo blog đầu tiên của bạn</p>
                        <a href="${pageContext.request.contextPath}/staff/blog/create" class="btn btn-primary">
                            <i class="fas fa-plus"></i> Tạo Blog Đầu Tiên
                        </a>
                    </div>
                </c:if>
                
                <c:if test="${not empty blogs}">
                    <div class="row">
                        <c:forEach var="blog" items="${blogs}">
                            <div class="col-lg-3 col-md-4 col-sm-6 mb-4">
                                <div class="blog-card">
                                    <div class="blog-image">
                                        <c:choose>
                                            <c:when test="${not empty blog.mainImage}">
                                                <img src="${pageContext.request.contextPath}/img/blog/${blog.mainImage}" 
                                                     alt="${blog.title}" class="img-fluid">
                                            </c:when>
                                            <c:otherwise>
                                                <div class="no-image">
                                                    <i class="fas fa-image"></i>
                                                    <span>Chưa có ảnh</span>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                        
                                        <!-- Status Badge -->
                                        <div class="status-badge status-${fn:toLowerCase(blog.blogStatus)}">
                                            ${blog.blogStatus}
                                        </div>
                                    </div>
                                    
                                    <div class="blog-content">
                                        <h5 class="blog-title">${blog.title}</h5>
                                        <p class="blog-excerpt">
                                            <c:choose>
                                                <c:when test="${fn:length(blog.content) > 100}">
                                                    ${fn:substring(blog.content, 0, 100)}...
                                                </c:when>
                                                <c:otherwise>
                                                    ${blog.content}
                                                </c:otherwise>
                                            </c:choose>
                                        </p>
                                        
                                        <div class="blog-meta">
                                            <small class="text-muted">
                                                <i class="fas fa-clock"></i>
                                                <fmt:formatDate value="${blog.dateCreated}" pattern="dd/MM/yyyy HH:mm"/>
                                            </small>
                                        </div>
                                        
                                        <div class="blog-actions">
                                            <a href="${pageContext.request.contextPath}/staff/blog/detail?id=${blog.blogID}" 
                                               class="btn btn-outline-primary btn-sm">
                                                <i class="fas fa-eye"></i> Xem
                                            </a>
                                            <a href="${pageContext.request.contextPath}/staff/blog/edit?id=${blog.blogID}" 
                                               class="btn btn-outline-warning btn-sm">
                                                <i class="fas fa-edit"></i> Sửa
                                            </a>
                                            <a href="${pageContext.request.contextPath}/staff/blog/delete?id=${blog.blogID}" 
                                               class="btn btn-outline-danger btn-sm">
                                                <i class="fas fa-trash"></i> Xóa
                                            </a>
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
                                        <a class="page-link" href="?${not empty searchKeyword ? 'action=search&keyword=' : ''}${searchKeyword}&page=${currentPage - 1}">
                                            <i class="fas fa-chevron-left"></i> Trước
                                        </a>
                                    </li>
                                </c:if>
                                
                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <li class="page-item ${i == currentPage ? 'active' : ''}">
                                        <a class="page-link" href="?${not empty searchKeyword ? 'action=search&keyword=' : ''}${searchKeyword}&page=${i}">${i}</a>
                                    </li>
                                </c:forEach>
                                
                                <c:if test="${currentPage < totalPages}">
                                    <li class="page-item">
                                        <a class="page-link" href="?${not empty searchKeyword ? 'action=search&keyword=' : ''}${searchKeyword}&page=${currentPage + 1}">
                                            Sau <i class="fas fa-chevron-right"></i>
                                        </a>
                                    </li>
                                </c:if>
                            </ul>
                        </nav>
                    </c:if>
                </c:if>
            </div>
        </div>
    </div>
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Staff Blog List JS -->
    <script src="${pageContext.request.contextPath}/js/staff-blog-list.js"></script>
</body>
</html>
