<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Edit Blog - Staff Portal</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/css/staff-blog-edit.css" rel="stylesheet">
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
                        <h2 class="mb-1">Edit Blog Post</h2>
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/staff/blogs">Blogs</a></li>
                                <li class="breadcrumb-item active">Edit Blog</li>
                            </ol>
                        </nav>
                    </div>
                    <a href="${pageContext.request.contextPath}/staff/blog/detail?id=${blog.blogID}" class="btn btn-outline-secondary">
                        <i class="fas fa-eye me-2"></i>View Blog
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
                
                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle me-2"></i>
                        ${successMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <!-- Edit Form -->
                <div class="card shadow-sm">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">
                            <i class="fas fa-edit me-2"></i>Edit Blog Information
                        </h5>
                    </div>
                    <div class="card-body">
                        <form id="editBlogForm" action="${pageContext.request.contextPath}/staff/blog/edit" method="post" enctype="multipart/form-data">
                            <input type="hidden" name="blogId" value="${blog.blogID}">
                            
                            <div class="row">
                                <!-- Left Column -->
                                <div class="col-lg-8">
                                    <!-- Blog Title -->
                                    <div class="mb-3">
                                        <label for="title" class="form-label">
                                            <i class="fas fa-heading me-2"></i>Blog Title *
                                        </label>
                                        <input type="text" class="form-control" id="title" name="title" 
                                               value="${fn:escapeXml(blog.title)}" required maxlength="200"
                                               placeholder="Enter blog title">
                                        <div class="form-text">Maximum 200 characters</div>
                                    </div>

                                    <!-- Blog Content -->
                                    <div class="mb-3">
                                        <label for="content" class="form-label">
                                            <i class="fas fa-align-left me-2"></i>Blog Content *
                                        </label>
                                        <textarea class="form-control" id="content" name="content" 
                                                  rows="12" required placeholder="Write your blog content here...">${fn:escapeXml(blog.content)}</textarea>
                                        <div class="form-text">Use proper formatting and be descriptive</div>
                                    </div>
                                </div>

                                <!-- Right Column -->
                                <div class="col-lg-4">
                                    <!-- Status Info -->
                                    <div class="card mb-3">
                                        <div class="card-header">
                                            <h6 class="mb-0">
                                                <i class="fas fa-info-circle me-2"></i>Blog Status
                                            </h6>
                                        </div>
                                        <div class="card-body">
                                            <p class="mb-2">
                                                <strong>Current Status:</strong> 
                                                <span class="badge bg-warning">${blog.blogStatus}</span>
                                            </p>
                                            <p class="mb-2">
                                                <strong>Created:</strong> 
                                                <fmt:formatDate value="${blog.dateCreated}" pattern="dd/MM/yyyy HH:mm"/>
                                            </p>
                                            <hr>
                                            <div class="text-muted small">
                                                <i class="fas fa-lightbulb me-1"></i>
                                                Status will be reset to "Pending" after update
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Image Upload -->
                                    <div class="card mb-3">
                                        <div class="card-header">
                                            <h6 class="mb-0">
                                                <i class="fas fa-images me-2"></i>Blog Images
                                            </h6>
                                        </div>
                                        <div class="card-body">
                                            <!-- Current Images -->
                                            <c:if test="${not empty images}">
                                                <div class="mb-3">
                                                    <label class="form-label">Current Images:</label>
                                                    <div class="current-images">
                                                        <c:forEach var="img" items="${images}">
                                                            <div class="image-item">
                                                                <img src="${pageContext.request.contextPath}/img/blog/${img.image}" 
                                                                     alt="Blog Image" class="img-thumbnail">
                                                                <c:if test="${img.main}">
                                                                    <span class="badge bg-primary">Main</span>
                                                                </c:if>
                                                            </div>
                                                        </c:forEach>
                                                    </div>
                                                </div>
                                            </c:if>

                                            <!-- Add New Images -->
                                            <div class="mb-3">
                                                <label for="images" class="form-label">Add New Images:</label>
                                                <input type="file" class="form-control" id="images" name="images" 
                                                       multiple accept="image/*">
                                                <div class="form-text">Select multiple images (JPG, PNG, GIF)</div>
                                            </div>

                                            <!-- Image Preview -->
                                            <div id="imagePreview" class="image-preview"></div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Action Buttons -->
                            <div class="border-top pt-3 mt-4">
                                <div class="d-flex justify-content-between">
                                    <div>
                                        <a href="${pageContext.request.contextPath}/staff/blogs" class="btn btn-outline-secondary">
                                            <i class="fas fa-arrow-left me-2"></i>Back to List
                                        </a>
                                    </div>
                                    <div>
                                        <button type="submit" class="btn btn-primary">
                                            <i class="fas fa-save me-2"></i>Update Blog
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Custom JS -->
    <script src="${pageContext.request.contextPath}/js/staff-blog-edit.js"></script>
</body>
</html>
