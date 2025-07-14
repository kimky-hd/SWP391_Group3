<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Flower Shop - Blog Details</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">

    <!-- Google Web Fonts -->
    <link rel="preconnect" href="https://fonts.gstatic.com">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">  

    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">

    <!-- Libraries Stylesheet -->
    <link href="${pageContext.request.contextPath}/lib/animate/animate.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">

    <!-- Customized Bootstrap Stylesheet -->
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">

    <style>
        .blog-detail-page {
            /* Reset for this page only */
        }
        .blog-detail-page html, .blog-detail-page body {
            margin: 0;
            padding: 0;
            min-height: 100vh;
            background: linear-gradient(120deg, #fdf6e3 0%, #f5e6ff 100%);
            font-family: 'Roboto', Arial, sans-serif;
        }
        .blog-detail-page .container {
            width: 95%;
            max-width: 1280px;
            margin: 24px auto;
            background: rgba(255,255,255,0.98);
            padding: 32px 18px 24px 18px;
            border-radius: 12px;
            box-shadow: 0 4px 24px rgba(0,0,0,0.10);
        }
        .blog-detail-page h2 {
            text-align: center;
            margin-bottom: 8px;
            font-size: 2.1rem;
            color: #7c3aed;
            letter-spacing: 1px;
        }
        .blog-detail-page p.sub-heading {
            text-align: center;
            color: #a0aec0;
            margin-bottom: 28px;
            font-size: 1rem;
        }
        .blog-detail-page .blog-detail {
            display: flex;
            gap: 24px;
            margin-top: 18px;
        }
        .blog-detail-page .image-column {
            flex: 1 1 40%;
            max-width: 40%;
        }
        .blog-detail-page .content-column {
            flex: 1 1 60%;
            max-width: 60%;
        }
        .blog-detail-page .main-image {
            width: 100%;
            max-height: 300px;
            object-fit: cover;
            border-radius: 10px;
            background: #f3f3f3;
            margin-bottom: 20px;
        }
        .blog-detail-page .images-grid {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-bottom: 20px;
        }
        .blog-detail-page .images-grid img {
            flex: 1 1 calc(100% / ${fn:length(blog.blogImages)} - 10px);
            max-width: calc(100% / ${fn:length(blog.blogImages)} - 10px);
            height: 100px;
            object-fit: cover;
            border-radius: 8px;
            background: #f3f3f3;
            cursor: pointer;
            transition: transform 0.2s;
        }
        .blog-detail-page .images-grid img:hover {
            transform: scale(1.05);
        }
        .blog-detail-page h3 {
            font-size: 1.8rem;
            font-weight: 600;
            color: #4b2995;
            margin-bottom: 12px;
        }
        .blog-detail-page .meta {
            font-size: 0.95rem;
            color: #6b7280;
            margin-bottom: 20px;
        }
        .blog-detail-page .content {
            font-size: 1.05rem;
            line-height: 1.65;
            color: #374151;
            margin-bottom: 24px;
        }
        .blog-detail-page .btn-back {
            display: inline-block;
            background: linear-gradient(90deg, #7c3aed 60%, #f472b6 100%);
            color: white;
            padding: 8px 20px;
            border-radius: 6px;
            text-decoration: none;
            font-size: 1rem;
            font-weight: 500;
            transition: background 0.18s;
            box-shadow: 0 2px 8px rgba(124,58,237,0.08);
        }
        .blog-detail-page .btn-back:hover {
            background: linear-gradient(90deg, #5b21b6 60%, #ec4899 100%);
        }
        .blog-detail-page .no-blog {
            text-align: center;
            color: #bdbdbd;
            padding: 48px 0;
            font-size: 1.1rem;
        }
        @media (max-width: 1024px) {
            .blog-detail-page .blog-detail {
                flex-direction: column;
            }
            .blog-detail-page .image-column, .blog-detail-page .content-column {
                flex: 1 1 100%;
                max-width: 100%;
            }
            .blog-detail-page .images-grid img {
                height: 120px;
            }
        }
        @media (max-width: 700px) {
            .blog-detail-page .container {
                padding: 20px 12px;
            }
            .blog-detail-page h3 {
                font-size: 1.5rem;
            }
            .blog-detail-page .content {
                font-size: 1rem;
            }
            .blog-detail-page .main-image {
                max-height: 200px;
            }
            .blog-detail-page .images-grid img {
                height: 80px;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="header.jsp" />
    <div class="blog-detail-page">
        <div class="container">
            <h2>Chi tiết bài viết</h2>
            <p class="sub-heading">Khám phá tin tức chi tiết từ Flower Shop</p>

            <c:choose>
                <c:when test="${not empty blog}">
                    <div class="blog-detail">
                        <div class="image-column">
                            <c:if test="${not empty blog.mainImage}">
                                <img src="${pageContext.request.contextPath}/img/blog/${blog.mainImage}" alt="Main Image" class="main-image" id="mainImage"
                                     onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/images/default.png';" />
                            </c:if>
                            <c:if test="${not empty blog.blogImages}">
                                <h4>Ảnh liên quan</h4>
                                <div class="images-grid">
                                    <c:forEach var="image" items="${blog.blogImages}">
                                        <img src="${pageContext.request.contextPath}/img/blog/${image.image}" alt="Blog Image" class="related-image"
                                             data-src="${pageContext.request.contextPath}/img/blog/${image.image}"
                                             onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/images/default.png';" />
                                    </c:forEach>
                                </div>
                            </c:if>
                        </div>
                        <div class="content-column">
                            <h3>${blog.title}</h3>
                            <div class="meta">
                                Đăng ngày: ${blog.dateCreated}
                            </div>
                            <div class="content">
                                ${blog.content}
                            </div>
                            <a href="${pageContext.request.contextPath}/blogs${not empty param.keyword ? '?keyword='.concat(param.keyword) : ''}" class="btn-back">Quay lại danh sách</a>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="no-blog">Không tìm thấy bài viết.</div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <jsp:include page="footer.jsp" />
    <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/lib/easing/easing.min.js"></script>
    <script src="${pageContext.request.contextPath}/lib/owlcarousel/owl.carousel.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/main.js"></script>
    <script>
        $(document).ready(function() {
            // Click related image to update main image
            $('.related-image').on('click', function() {
                const newSrc = $(this).data('src');
                $('#mainImage').attr('src', newSrc).attr('onerror', "this.onerror=null;this.src='${pageContext.request.contextPath}/images/default.png';");
            });
        });
    </script>
</body>
</html>